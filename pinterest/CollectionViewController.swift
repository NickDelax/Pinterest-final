//
//  CollectionViewController.swift
//  pinterest
//
//  Created by Nicolas De La Cruz, Mariano Ramirez, Ricardo Sanchez on 10/3/19.
//  Copyright © 2019 Alumno IDS. All rights reserved.//

import UIKit
import Firebase

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    
    var imagensCells = [pinCell]()
    
    func testFunc(){
    }
    
    var URLSRef : DatabaseReference = Database.database().reference().child("imagesURLS")
    
    
    @objc func uploadNewImage(){
        let uploadVC = UploadImageVC()
        self.navigationController?.pushViewController(uploadVC, animated: true)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "UploadImage", style: .plain, target: self, action: #selector(uploadNewImage))
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView?.backgroundColor = .black
        collectionView?.register(pinCell.self, forCellWithReuseIdentifier: cellId )
        
        
        self.collectionView?.reloadData()
    }
    
    var imageReference : StorageReference {
        return Storage.storage().reference().child("MEMES")
    }
    
    var imagenes = imagenesArray
    var pines = messagesArray
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("++++ Aqui cargamos numberOfItems")
        //print("=========== la cuenta de urlsList es \(urlsList.count)")
        return urlsList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print("++++ Aqui cargamos cellforItemAt")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! pinCell
        
        cell.label1.text = pines[indexPath.item]
        cell.imageView1.image = imagenes[indexPath.item]
        cell.backgroundColor = .white
        
        
        //cell.imageView1.image = imageToUse
        cell.imageView1.translatesAutoresizingMaskIntoConstraints = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //print("++++ Aqui cargamos inserForSectionAt")
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("seleccionaste \(pines[indexPath.item])")
        animateCell(collectionView, indexPath: indexPath)
        //changeScreen(indexPath: indexPath)
        
        
    }
    
    func changeScreen(indexPath: IndexPath){
        var animateTransition : Bool = true
        
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        //transition.subtype = kCATransition
        self.navigationController!.view.layer.add(transition, forKey: nil)
        
        let pinDVC = pinDetailVC()
        pinDVC.pinImage.image = imagenes[indexPath.item]
        pinDVC.pinTitle.text = pines[indexPath.item]
        animateTransition = false
        self.navigationController?.pushViewController(pinDVC, animated: animateTransition)
    }
    
    func animateCell(_ collectionView: UICollectionView, indexPath : IndexPath){
        let cell = collectionView.cellForItem(at: indexPath) as! pinCell
        collectionView.bringSubview(toFront: cell)
        var zoomTopConstraint = cell.imageView1.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 85)
        var zoomLeftConstraint = cell.imageView1.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        var zoomRightConstraint = cell.imageView1.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        var zoomHeightConstraint = cell.imageView1.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: (self.imagenes[indexPath.item].size.height / self.imagenes[indexPath.item].size.width) )
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
           
            
            zoomTopConstraint.isActive = true
            zoomLeftConstraint.isActive = true
            zoomRightConstraint.isActive = true
            zoomHeightConstraint.isActive = true
            self.view.layoutIfNeeded()
            
        }, completion: {finished in
            cell.alpha = 1
            cell.backgroundColor = .white
            zoomTopConstraint.isActive = false
            zoomLeftConstraint.isActive = false
            zoomRightConstraint.isActive = false
            zoomHeightConstraint.isActive = false
            self.changeScreen(indexPath: indexPath)
            
        })
        
        
    }
    
}


extension CollectionViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        //print("sacamos height de imagen \(indexPath.item)")
        return imagenes[indexPath.item].size.height
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        widthForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return imagenes[indexPath.item].size.width
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        currentPhotoWidth indexPath:IndexPath) -> CGFloat {
        return (((view.frame.width / 2) - 16) * 0.8)
        
    }
}
