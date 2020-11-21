//
//  PostProcessing+Cat.swift
//  I'm Cat
//
//  Created by JiaChen(: on 15/11/20.
//

import Foundation
import CoreML
import UIKit
import AVFoundation
import Vision

extension CatsViewController {
    func postProcessing() {
        
        captureImageOutput?.capturePhoto(with: .init(), delegate: self)
    }
}

extension CatsViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        
        if let cgImage = photo.cgImageRepresentation()?.takeRetainedValue() {
            
            let image = UIImage(cgImage: cgImage)
            
            extractedImage = image
            
            if let previewVC = self.source {
                previewVC.image = image
            }
            
            let orientation = image.coreOrientation()
            guard let coreImage = CIImage(image: image) else { return }
            
            let handler = VNImageRequestHandler(ciImage: coreImage, orientation: orientation)
            
            do {
                try handler.perform([self.postProcessingFaceRequest])
            } catch {
                print("Failed to perform detection .\n\(error.localizedDescription)")
            }
            
        } else {
            let alert = UIAlertController(title: "Error generating image",
                                          message: "An error occurred while saving the photo. Please try again",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

