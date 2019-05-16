//
//  testDownloadImage.swift
//  pinterest
//
//  Created by Nicolas De La Cruz, Mariano Ramirez, Ricardo Sanchez on 10/3/19.
//  Copyright © 2019 Alumno IDS. All rights reserved.//

import Foundation
import UIKit
import Firebase



class testDownloadImage: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        let storageRef = Storage.storage().reference().child("DSC_0931.jpg")
        
        
        
        
        let pinterestBackground = #imageLiteral(resourceName: "collageBackground")
        let backgroundView = UIImageView()
        backgroundView.frame = CGRect(x: 0, y:40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.75)
        print("-------------------primero")
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("hubo un error al descargar. Fue \(error)")
            } else {
                let image = UIImage(data: data!)
                backgroundView.image = image as! UIImage
                print("la imagen se llama \(image?.size)")
                print("-----------------en teoria todo bien")
            }
        }
        print("llego aqui")
        view.addSubview(backgroundView)
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
    }
    
    
    
}
