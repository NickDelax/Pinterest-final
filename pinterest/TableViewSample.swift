//
//  TableViewSample.swift
//  pinterest
//
//  Created by Nicolas De La Cruz, Mariano Ramirez, Ricardo Sanchez on 11/5/19.
//  Copyright © 2019 Alumno IDS. All rights reserved.
//

import UIKit

class TableViewSample: UITableViewController {
    
    let identifier = "cellId1"
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        tableView.register(CustomCell.self, forCellReuseIdentifier: identifier)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CustomCell
        return cell
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    
}




class CustomCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()

    }
   
    
    func setupViews(){
        self.addSubview(imageView1)
        
        
        imageView1.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView1.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView1.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 9/10).isActive = true
        imageView1.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 8/10)
        
        
    }
    
    let imageView1 : UIImageView = {
        let imageView2 = UIImageView()
        imageView2.image = #imageLiteral(resourceName: "collageBackground")
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        return imageView2
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
