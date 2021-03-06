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
    
    // AVCapture variables to hold sequence data
    var session: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var videoDataOutput: AVCaptureVideoDataOutput?
    var videoDataOutputQueue: DispatchQueue?
    
    var captureDevice: AVCaptureDevice?
    var captureDeviceResolution: CGSize = CGSize()
    
    // Layer UI for drawing Vision results
    var rootLayer: CALayer?
    var detectionOverlayLayer: CALayer?
    var detectedFaceRectangleShapeLayer: CAShapeLayer?
    var detectedTextLayer: CATextLayer?
    
    // Vision requests
    var detectionRequests: [VNDetectFaceRectanglesRequest]?
    var trackingRequests: [VNTrackObjectRequest]?
    
    lazy var sequenceRequestHandler = VNSequenceRequestHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.session = self.setupAVCaptureSession()
        
        self.prepareVisionRequest()
        
        self.session?.startRunning()
        
        dismissButton.layer.cornerRadius = 10
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
