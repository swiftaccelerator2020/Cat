//
//  PreviewViewController.swift
//  I'm Cat
//
//  Created by JiaChen(: on 15/11/20.
//

import UIKit
import CoreML
import Vision

class PreviewViewController: UIViewController {

    var image: UIImage? {
        didSet {
            previewImageView.image = image
            
            previewImageView.transform = CGAffineTransform(degrees: 90)
        }
    }
    var observations: [VNFaceObservation] = []
    
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
    
    @IBOutlet weak var previewImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        previewImageView.image = image
//        previewImageView.backgroundColor = .blue
        print(observations)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    @IBAction func catifyButtonClicked(_ sender: Any) {
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            
            guard let image = image else { return }
            observations.forEach({ observation in
                
                let imageSize = image.size
                let boundingBox = observation.boundingBox
                let origin = boundingBox.origin
                let size = boundingBox.size
                
                let cropRect = CGRect(x: origin.x * imageSize.width,
                                      y: origin.y * imageSize.height,
                                      width: size.width * imageSize.width,
                                      height: size.height * imageSize.height)
                
                
                let croppedImage = cropImage(image, toRect: cropRect)
                
                updateClassifications(for: croppedImage)
                
                print(croppedImage)
            })
            
        }
    }
    
    func cropImage(_ imageToCrop: UIImage, toRect rect:CGRect) -> UIImage{
        
        if let cgImage = imageToCrop.cgImage,
           let imageRef = cgImage.cropping(to: rect) {
            
            let cropped: UIImage = UIImage(cgImage: imageRef)
            
            return cropped
        }
        
        return UIImage()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let dest = segue.destination as? CatsViewController {
            dest.source = self
        }
    }
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage) {
        print("Classifying...")
        
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))
        
        guard let ciImage = CIImage(image: image) else { print("Unable to create \(CIImage.self) from \(image)."); return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation!)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    /// Updates the UI with the results of the classification.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                print("Unable to classify image.\n\(error!.localizedDescription)")
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                print("Nothing recognized.")
            } else {
                // Display top classifications ranked by confidence in the UI.
                let descriptions = classifications.map { classification in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                    
                    return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                
                let alert = UIAlertController(title: "classification results", message: descriptions.joined(separator: "\n"), preferredStyle: .alert)
                
                alert.addAction(.init(title: "Done", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                print("Classification:\n" + descriptions.joined(separator: "\n"))
                
            }
        }
    }

}
