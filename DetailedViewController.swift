//
//  DetailedViewController.swift
//  Wardrobe_Planner
//
//  Created by Paul Bunnell on 12/23/20.
//

import UIKit

class DetailedViewController: UIViewController {
    @IBOutlet weak var imageVeiw: UIImageView!
    @IBOutlet weak var whiteBackgroundView: UILabel!
    @IBOutlet weak var choosePhotoButton: UIButton!
    
//MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        backgroundView.layer.cornerRadius = 10
//        backgroundView.clipsToBounds = true
        
        whiteBackgroundView.layer.cornerRadius = 10
        whiteBackgroundView.clipsToBounds = true
        
        choosePhotoButton.layer.cornerRadius = 10
        choosePhotoButton.clipsToBounds = true
        
        imageVeiw.layer.cornerRadius = 10
        imageVeiw.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? DetailViewController {
            if let image = imageVeiw.image {
                destinationController.closetItem.image = image.pngData()
            }
        }
    }
    
    func getPhoto() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func choosePhotoButtonTapped(_ sender: UIButton) {
        getPhoto()
    }
    
}

//MARK: Image Picker
extension DetailedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imageVeiw.image = image
            
        }
        
        picker.dismiss(animated: true) {
            self.performSegue(withIdentifier: "nextChoice1", sender: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
