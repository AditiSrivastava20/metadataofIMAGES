//
//  ViewController.swift
//  metaData
//
//  Created by Sierra 4 on 27/04/17.
//  Copyright © 2017 Sierra 4. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var imgDisplayCell: UICollectionView!
    let imagePicker = UIImagePickerController()
    var photo = UIImage()
    var images = [UIImage]()
    var imgCollection = PHAssetCollection()
    let albumName = enumeration.albumname.rawValue
    var albumFound = Bool()
    var photoAssets:PHFetchResult<AnyObject>!
    let fetchOptions = PHFetchOptions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.authorizationStatus()
       
        FetchCustomAlbumPhotos()
    }
    
    func FetchCustomAlbumPhotos()
    {
        
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .moment, subtype: .any, options: fetchOptions)
        let count = collection.count
        for i in 0...count-1
        {
            
            if let first_object:AnyObject = collection.object(at: i){
                
                self.imgCollection = first_object as! PHAssetCollection
                albumFound = true
                print("Start Date: ",imgCollection.startDate!)
                print("Localized Title: ",imgCollection.localizedTitle ?? "")
                print("Local Identifier: ",imgCollection.localIdentifier)
                print("LocationNames: ",imgCollection.localizedLocationNames)
                print("ApproximateLocation: ",imgCollection.approximateLocation ?? "")
                let string1 = imgCollection.approximateLocation
                let string2 = imgCollection.localizedLocationNames
                let string3 = imgCollection.localIdentifier
                let string4 = imgCollection.startDate!
                let string5 = imgCollection.localizedTitle
                var appendString = "\(string1) \(string2) \(string3) \(string4) \(string5)"
                print("APPEND STRING:\(appendString)")
               
                
            }
                
            else { albumFound = false }
        }
        _ = collection.count
        photoAssets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions) as! PHFetchResult<AnyObject>
        let imageManager = PHCachingImageManager()
        photoAssets.enumerateObjects({(object: AnyObject!,
            count: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in
            
            if object is PHAsset{
                let asset = object as! PHAsset
                
                
                let imageSize = CGSize(width: asset.pixelWidth,
                                       height: asset.pixelHeight)
                let options = PHImageRequestOptions()
                options.deliveryMode = .fastFormat
                options.isSynchronous = true
                
                imageManager.requestImage(for: asset,
                                          targetSize: imageSize,
                                          contentMode: .aspectFill,
                                          options: options,
                                          resultHandler: {
                                            (image, info) -> Void in
                                            self.photo = image!
                                            self.addImgToArray(uploadImage: self.photo)
                                            
                })
                
            }
        })
    }
    
    
    func addImgToArray(uploadImage:UIImage)
    {
        
        self.images.append(uploadImage)
        
        
    }
    func imageFromAsset(nsurl: NSURL) {
        let asset = PHAsset.fetchAssets(withALAssetURLs: [nsurl as URL], options: nil).firstObject
        print("location: " + String(describing: asset?.location))
    }
   
   }
extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }
    
    
}
    

