//
//  ViewController.swift
//  SeeFood
//
//  Created by admin on 10/04/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            
            guard let ciimage = CIImage(image: image) else {
                fatalError("could not convert ui image to ci image")
            }
            
            detect(image: ciimage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("loading coreml model failed")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("model failed to process image")
            }
            
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog!"
                } else {
                    self.navigationItem.title = "Not Hotdog"
                }
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        try! handler.perform([request])
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

