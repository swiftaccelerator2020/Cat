//
//  CatsViewController.swift
//  I'm Cat
//
//  Created by JiaChen(: on 11/11/20.
//

import UIKit
import AVFoundation
import CoreML
import Vision

class CatsViewController: UIViewController {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var captureImageButton: UIButton!
    @IBOutlet weak var flipCameraButton: UIButton!
    
    var source: PreviewViewController?
    
    // AVCapture variables to hold sequence data
    var session: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var imageCaptured = false
    
    var videoDataOutput: AVCaptureVideoDataOutput?
    var videoDataOutputQueue: DispatchQueue?
    
    var captureDevice: AVCaptureDevice?
    var captureDeviceResolution: CGSize = CGSize()
    
    var extractedImage: UIImage?
    var extractedObservations: [VNFaceObservation]?
    
    
    // Layer UI for drawing Vision results
    var rootLayer: CALayer?
    var detectionOverlayLayer: CALayer?
    var detectedFaceRectangleShapeLayer: CAShapeLayer?
    var detectedTextLayer: CATextLayer?
    
    // Vision requests
    var detectionRequests: [VNDetectFaceRectanglesRequest]?
    var trackingRequests: [VNTrackObjectRequest]?
    
    var captureImageOutput: AVCapturePhotoOutput?
    
    lazy var sequenceRequestHandler = VNSequenceRequestHandler()
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: Reactions_2(configuration: .init()).model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    lazy var postProcessingFaceRequest: VNDetectFaceRectanglesRequest = {
        
        let faceLandmarksRequest = VNDetectFaceRectanglesRequest(completionHandler: { [self] request, error in
            
            guard let observations = request.results as? [VNFaceObservation] else {
                fatalError("unexpected result type!")
            }
            
            print("Detected \(observations.count) faces")
            
            self.extractedObservations = observations
            
            DispatchQueue.main.async {
                self.session?.stopRunning()
                
                self.dismiss(animated: true) {
                    if let previewVC = self.source {
                        print(self.extractedObservations)
                        previewVC.observations = self.extractedObservations ?? []

                    }
                }
            }
        })
        return faceLandmarksRequest
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.session = self.setupAVCaptureSession()
        
        self.prepareVisionRequest()
        
        self.session?.startRunning()
        
        dismissButton.layer.cornerRadius = 10
    
        flipCameraButton.layer.cornerRadius = 20
        
        captureImageButton.layer.cornerRadius = 20
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func dismissButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func flipCameraButtonClicked(_ sender: Any) {
        guard let session = session else { return }
        session.beginConfiguration()
        let sessionInfo = try! configureCamera(for: session, position: captureDevice?.position == .front ? .back : .front)
        
        captureDevice = sessionInfo.device
        captureDeviceResolution = sessionInfo.resolution

        detectedFaceRectangleShapeLayer?.path = .none
        setupVisionDrawingLayers()
        
        session.commitConfiguration()
    }
    
    @IBAction func takePhotoButtonClicked(_ sender: Any) {
        postProcessing()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let destination = segue.destination as? PreviewViewController {
            destination.image = extractedImage
            destination.observations = extractedObservations ?? []
        }
    }

}
