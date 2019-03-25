//
//  ProfileVC.swift
//  Protect_Security
//
//  Created by Jatin Garg on 20/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var tfName: ProtectField!
    @IBOutlet weak var tfMobNo: ProtectField!
    @IBOutlet weak var tfEmail: ProtectField!
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var imgCamera: InteractiveImageview!
   
    private var imagePicker = UIImagePickerController()
    private var isProfileEdited = false
    private var userNamePrev = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureIntialSetUp()
        
        setupUserDetailsInOfflineMode()
        getProfileApiCalling()
    }
    private func configureIntialSetUp(){
        navigationItem.title = "My Profile"
        
        imgCamera.delegate = self
        imgProfilePic.setRoundImage()
        imgProfilePic.layer.borderWidth = 1
        imgProfilePic.layer.borderColor = UIColor.lightGray.cgColor
        
        tfEmail.isUserInteractionEnabled = false
        tfMobNo.isUserInteractionEnabled = false
        tfName.textColor = UIColor.black
     
        let newBackButton = UIBarButtonItem(image: UIImage(named: "arrow-up"), landscapeImagePhone: UIImage(named: "arrow-up"), style: .plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem) {
        if isProfileEdited || userNamePrev != tfName.text!.trim() {
            confirmPopup()
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    //#MARK: Saving the users details offline
    private func setupUserDetailsInOfflineMode() {
        if let userDetails = UserPreferences.userDetails {
            if let userImageUrl = userDetails.profileImageURL {
                if let url = URL(string: userImageUrl) {
                    self.imgProfilePic.sd_setImage(with: url, placeholderImage: UIImage(named: "default_user"))
                }
            }
            self.userNamePrev = userDetails.name ?? ""
            self.tfName.text = userDetails.name ?? ""
            self.tfMobNo.text = userDetails.contactNumber
            self.tfEmail.text = userDetails.email ?? ""
        }
    }
    //#MARK: Fetching Profile Details 
    func getProfileApiCalling() {
        let service = GetprofileService()
        view.showIndicator()
        service.fire { (model, error) in
            self.view.hideIndicator()
            if error == nil {
                let userToken = UserPreferences.userToken
                UserPreferences.userDetails = model!
                UserPreferences.userDetails?.token = userToken
            }
            if let userDetails = UserPreferences.userDetails {
                if let userImageUrl = userDetails.profileImageURL {
                    if let url = URL(string: userImageUrl) {
                        self.imgProfilePic.sd_setImage(with: url, placeholderImage: UIImage(named: "default_user"))
                    }
                }
                self.tfName.text = userDetails.name ?? ""
                self.tfMobNo.text = userDetails.contactNumber
                self.tfEmail.text = userDetails.email ?? ""
            }
        }
    }
  
    @IBAction func btnSaveProfileTapped(_ sender: Any) {
        if isProfileEdited || userNamePrev != tfName.text!.trim() {
            if (tfName.text?.trim().count)!>0{
             updateuserProfileApiCalling()
            } else {
                tfName.shake()
                let toast = iToast(text: "Name can not be empty.")
                toast.show()
            }
        }
    }
    //#MARK: Save Edited profile Details
    func updateuserProfileApiCalling() {
        let userImage = convertImageToBase64String(img: imgProfilePic.image!)
        let service = UpdateUserProfileService(name: tfName.text!, profileImage: userImage)
        
        view.showIndicator()
        service.fire { (model, error) in
            self.view.hideIndicator()
            if error != nil {
                System.showInfo(withMessage: (error?.localizedDescription)!, ofType: .error, onVC: self)
            } else {
                self.isProfileEdited = false
                let userToken = UserPreferences.userDetails?.token
                UserPreferences.userDetails = model!
                UserPreferences.userDetails?.token = userToken
                self.userNamePrev = UserPreferences.userDetails?.name ?? ""
                
                let toast = iToast(text: "Details saved successfully.")
                toast.show()
            }
        }
    }
    
    func confirmPopup() {
        let alertController = UIAlertController(title: InfoType.information.title, message: "Do you want to save changes?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            //print("OK Pressed")
            if (self.tfName.text?.trim().count)!>0 {
                self.updateuserProfileApiCalling()
            } else {
                let toast = iToast(text: "Name can not be empty.")
                toast.show()
            }
            _ = self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            _ = self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
//#MARK: Selecting profile image Logic starts
extension ProfileVC: InteractiveImageviewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func imageTapped(_ sender: InteractiveImageview) {
        
        let alert:UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default){
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel){
            UIAlertAction in
        }
        
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
    if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        } else {
            System.showInfo(withMessage: "You don't have camera", ofType: .information, onVC: self)
        }
    }
    
    func openGallery() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgProfilePic.image = pickedImage
            self.isProfileEdited = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    //#MARK:Encoding
    func convertImageToBase64String (img: UIImage) -> String {
        let imageData: Data = UIImageJPEGRepresentation(img, 0.50)! as Data
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
}


