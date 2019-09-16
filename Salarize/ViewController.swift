//
//  ViewController.swift
//  Salarize
//
//  Created by Benjamin Garrison on 9/13/19.
//  Copyright © 2019 Benji Garrison. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    let imagePicker = UIImagePickerController()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            
            guard let analyzedImage = CIImage(image: selectedImage) else {
                fatalError("Could not read image.")
            }
            
            detectImage(image: analyzedImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detectImage(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: MNIST().model) else {
            fatalError("Could not load data model.")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Could not classify observation.")
            }
            
            print(results)
            
            if let topHit = results.first {
                self.priceLabel.text = topHit.identifier
            } else {
                self.priceLabel.text = ""
            }
        }
        
        let handler = VNImageRequestHandler(ciImage:  image)
        
        do {
        try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func camerButtonTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    

}

