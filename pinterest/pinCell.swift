//
//  pinCell.swift
//  pinterest
//
//  Created by Nicolas De La Cruz, Mariano Ramirez, Ricardo Sanchez on 10/3/19.
//  Copyright © 2019 Alumno IDS. All rights reserved.//

import UIKit
import Firebase

class pinCell : UICollectionViewCell {
    override init (frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    var imageDownloadURL : String?
    
    func setSnapValues(snapshot: DataSnapshot){
        let snapFull = snapshot.value as! [String : Any]
        self.imageDownloadURL = snapFull["url"] as! String ?? ""
    }
    
    func setup(){
        self.addSubview(imageView1)
        self.addSubview(label1)
        
        imageView1.topAnchor.constraint(equalTo: self.topAnchor, constant: (17 * (1/3) )).isActive = true
        imageView1.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView1.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 8/10).isActive = true

        imageView1.heightAnchor.constraint(equalToConstant: self.bounds.height - 34).isActive = true
        
        label1.topAnchor.constraint(equalTo: imageView1.bottomAnchor, constant: (17 / 3 )).isActive = true
        label1.leftAnchor.constraint(equalTo: imageView1.leftAnchor).isActive = true
        label1.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 80/100).isActive = true
        label1.heightAnchor.constraint(equalToConstant: 17).isActive = true
    
        self.addSubview(imageViewOptions)
        imageViewOptions.centerYAnchor.constraint(equalTo: label1.centerYAnchor).isActive = true
        imageViewOptions.rightAnchor.constraint(equalTo: imageView1.rightAnchor).isActive = true
        imageViewOptions.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 7/100).isActive = true
        imageViewOptions.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 7/100).isActive = true
        
        self.backgroundColor = .white
        
    }
    
    func updateCellHeight(_ newWidth: CGFloat, currentHeight: CGFloat, currentWidth: CGFloat) -> CGFloat{
        var newHeight : CGFloat = (newWidth * currentHeight) / currentWidth
        newHeight = 2000
        return newHeight
    }
    
    func animateCell(duration: CGFloat, delay: CGFloat, newX: CGFloat, newY: CGFloat, newWidth: CGFloat, newHeight: CGFloat){
        
        UIView.animate(withDuration: TimeInterval(duration), delay: TimeInterval(delay), options: .curveEaseOut, animations: {
            let newFrame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
            self.imageView1.frame = newFrame

            
            
        }, completion: {finished in

        })
    }
    
    
    var imageView1 : UIImageView = {
        let imageView2 = UIImageView()
        imageView2.image = #imageLiteral(resourceName: "paisaje")
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        return imageView2
    }()
    
    let label1 : UILabel = {
        let label2 = UILabel()
        label2.textColor = .black
        label2.translatesAutoresizingMaskIntoConstraints = false
        return label2
    }()
    
    let imageViewOptions : UIImageView = {
        let imageView3 = UIImageView()
        imageView3.image = #imageLiteral(resourceName: "3Puntos")
        imageView3.translatesAutoresizingMaskIntoConstraints = false
        return imageView3
    }()
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}
