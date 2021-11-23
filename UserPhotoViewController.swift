//
//  UserPhotoViewController.swift
//  volunteers
//
//  Created by Pichu Chen on 平成29/11/24.
//  Copyright © 平成29年 Taiwan Intelligent Home Corp. All rights reserved.
//

import Foundation
import UIKit

class UserPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var viewControllerTitle: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var imagePicker: UIImagePickerController?
    @objc var images:[[String: Any]] = []
    
    @objc var canDelete = false
    @objc var canAdd = false
    
    override func viewDidLoad() {
        viewControllerTitle.title = title
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
    }
    
    @IBAction func doDismiss(_ sender: Any) {
//        let all
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        if(canAdd == false){
            return
        }
        if(imagePicker == nil){
            return
        }
        imagePicker?.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker!, animated: true, completion: nil)
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count;
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserPhotoCellViewController;
        print("item \(images[indexPath.row])")
        
        let urlLick = String.init(format: "%@%@",
                                  WilloAPIV2.getHostName(),
                                  (images[indexPath.row]["image"] as? String) ?? "")
        let fileName = urlLick.components(separatedBy: "/").last
        print("urlLick \(urlLick)");
        
        cell.image.sd_setImage(with: URL.init(string: urlLick), placeholderImage: UIImage.init(named: fileName!), options: [], completed: { (img, err, _, _) in

        })
        
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapImage(sender:)));
        cell.image.addGestureRecognizer(tap);
        cell.image.isUserInteractionEnabled = true;
        
        let deleteTap = UITapGestureRecognizer.init(target: self, action: #selector(tapDelete(sender:)));
        cell.deleteButton.addGestureRecognizer(deleteTap);
        cell.deleteButton.isUserInteractionEnabled = true;
        
        if(canDelete == false){
            cell.deleteButton.isHidden = true
        }
        
        if(canAdd == false){
            self.addButton.isEnabled = false
            self.addButton.tintColor = UIColor.clear
        }
        
        return cell
    }
    
    @objc func tapImage(sender: UIGestureRecognizer) {
        let view = sender.view?.superview?.superview as? UserPhotoCellViewController
        print("superview: \(String(describing: sender.view?.superview?.superview ?? nil))")
        if(view == nil){
            return
        }
        let indexPath = collectionView.indexPath(for: view!)
        
        let urlLick = String.init(format: "%@%@",
                                  WilloAPIV2.getHostName(),
                                  (images[indexPath!.row]["image"] as? String) ?? "")
        
        UIApplication.shared.openURL(URL.init(string: urlLick)!)
        
        
        print("TAP: \(indexPath!.row)")
        
    }
    
    @objc func tapDelete(sender: UIGestureRecognizer) {
        if(canDelete == false){
            return
        }
        let view = sender.view?.superview?.superview as? UserPhotoCellViewController
        print("superview: \(String(describing: sender.view?.superview?.superview ?? nil))")
        if(view == nil){
            return
        }
        let indexPath = collectionView.indexPath(for: view!)
        
        var params: [String:String] = [:]
        let id = images[indexPath!.row]["id"] as! Int
        
        params["delete_id"] = "\(id)"
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async {
            
        
            WilloAPIV2.deleteUserLicense(withParameters: params, viewController: self, success: { (about, _) in
                print("success")
                
                WilloAPIV2.getDump({
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    self.images = appDelegate.user["images"] as! [[String:Any]]
                    DispatchQueue.main.async {
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        self.collectionView.reloadData()
                    }
                })
            }) { (op, err) in
                print("error");
                WilloAPIV2.getDump({
                    DispatchQueue.main.async {
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        
                    }
                })
            }
        }
        
        print("TAP: \(indexPath!.row)")
        
    }
    
    
    // UIImagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("return photo")
        let mediaType = info[UIImagePickerControllerMediaType] as? String ?? ""
        if(mediaType != "public.image"){
            picker.dismiss(animated: true, completion: nil)
            return;
        }
        picker.dismiss(animated: true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let resizedImage = AppDelegate.resizeImage(toSize: 600, sourceImage: image)
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]

        let imagePath = (documentDirectory as NSString).appendingPathComponent("license.jpg")
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async {
            AppDelegate.save(resizedImage, withFileName: "license", ofType: "jpg", inDirectory: documentDirectory)
            WilloAPIV2.updateUserLicense(withParameters: [:], viewController: self, constructingBodyWith: { (formData) in
                print("imagePath: \(imagePath)")
                let data = NSData.init(contentsOfFile: imagePath) as Data?
                formData?.appendPart(withFileData: data!, name: "add_license", fileName: "license.jpg", mimeType: "image/jpeg")
                
            }, success: { (_, _) in
                print("success")
                WilloAPIV2.getDump({
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    self.images = appDelegate.user["images"] as! [[String:Any]]
                    DispatchQueue.main.async {
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        self.collectionView.reloadData()
                    }
                })
                
                
            }) { (op, error) in
                print("errror")
                WilloAPIV2.getDump({
                    DispatchQueue.main.async {
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        
                    }
                })
            }
        }
        
        
        
    }
    
}



