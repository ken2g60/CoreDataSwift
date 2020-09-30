//
//  AddNewLifeGoalTableViewController.swift
//  LifeGoals
//
//  Created by knight on 9/29/20.
//

import UIKit
import CoreData


class AddNewLifeGoalTableViewController: UITableViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    
    var goals: GoalsMO!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var goalTextField: RoundedTextField! {
        didSet {
            goalTextField.tag = 1
            goalTextField.becomeFirstResponder()
            goalTextField.delegate = self
        }
    }
    @IBOutlet var goalTextFieldCategory: RoundedTextField! {
        didSet {
            goalTextFieldCategory.tag = 2
            goalTextFieldCategory.delegate = self
        }
    }
    @IBOutlet var goalAchieviableTime: RoundedTextField!{
        didSet {
            goalAchieviableTime.tag = 3
            goalAchieviableTime.delegate = self
        }
    }
    
    @IBOutlet var goalDescription: UITextView! {
        didSet {
            goalDescription.tag = 4
            goalDescription.layer.cornerRadius = 5.0
            goalDescription.layer.masksToBounds = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Table view data source
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1){
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    imagePicker.delegate = self
                    
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            
            
            if let popoverController = photoSourceRequestController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath){
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            
            present(photoSourceRequestController, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        
        let leadingConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        
        let topConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraints = NSLayoutConstraint(item: photoImageView as Any, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraints.isActive = true
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveGoals(sender: AnyObject){
     
        
        
        if goalTextField.text!.isEmpty || goalTextFieldCategory.text!.isEmpty || goalDescription.text.isEmpty {
            let alertController = UIAlertController(title: "Error", message: "Please Provide The Requireds Fields", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                
                
                let now = Date()
                let formatter = DateFormatter()
                formatter.timeZone = TimeZone.current
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let dateString = formatter.string(from: now)
             
                
                
                goals = GoalsMO(context: appDelegate.persistentContainer.viewContext)
                goals.goalName = goalTextField.text
                goals.goalCategory = goalTextFieldCategory.text
                goals.goalDescription = goalDescription.text
                goals.goalAchieved = false
                goals.timeCreated = dateString
                goals.goalAchievableTime = goalAchieviableTime.text
                
                if let customGoalImage = photoImageView.image {
                    goals.goalImage = customGoalImage.pngData()
                }
                
                // uiAlert
                // return redirect
                // performSegue(withIdentifier: "segueRecent", sender: nil)
                
                
                appDelegate.saveContext()
                let alertController = UIAlertController(title: "LifeGoal", message: "Goal Saved", preferredStyle: .alert)
                let okController = UIAlertAction(title: "OK", style: .default) { (action) in
                    // self.performSegue(withIdentifier: "segueRecent", sender: self)
                }
                
                alertController.addAction(okController)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
        
        
    }
    
    
}
