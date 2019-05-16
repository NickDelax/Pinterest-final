//
//  datosViewController.swift
//  pinterest
//
//  Created by Nicolas De La Cruz, Mariano Ramirez, Ricardo Sanchez on 11/5/19.
//  Copyright © 2019 Alumno IDS. All rights reserved.//

import UIKit
import Firebase
class datosViewController: UIViewController, UITextFieldDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Register"
        view.backgroundColor = UIColor(r: 0, g: 0, b: 0)
        let padding1:CGFloat = 10
        label1.text = "Favor de poner su \(activeScreen.rawValue)"
        label1.textColor = .white
        
        //add subview
        self.view.addSubview(label1)
        view.addSubview(emailTextField)
        view.addSubview(firstButton)
        

        //constraints
        emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -220).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        //emailTextField.setLeftPaddingPoints(padding1)//Padding
        if activeScreen.rawValue == screens.Password.rawValue {emailTextField.isSecureTextEntry = true}
        
        
        firstButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 210).isActive = true
        firstButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        firstButton.leftAnchor.constraint(equalTo: emailTextField.leftAnchor).isActive = true
        firstButton.rightAnchor.constraint(equalTo: emailTextField.rightAnchor).isActive = true
        firstButton.layer.cornerRadius = 10
    }
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = activeScreen.rawValue
        tf.backgroundColor = .white
        //tf.text = "usuario55@gmail.com"
        return tf
    }()
    
    lazy var firstButton : UIButton = {
        let ub = UIButton()
        ub.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 153/255, alpha: 1)
        ub.setTitleColor(.white, for: .normal)
        ub.setTitle("Siguiente", for: .normal)
        ub.translatesAutoresizingMaskIntoConstraints = false
        ub.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        return ub
    }()
    
    let label1 = UILabel(frame: CGRect(x: 10, y: 70, width: 300, height: 21))
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            switch activeScreen {
                case .Mail: activeScreen = screens.Mail
                case .Password: activeScreen = screens.Mail
                case .Age: activeScreen = screens.Password
            }
        }
    }
    @objc func handleButton(){
        if emailTextField.text != "" {
            switch activeScreen {
                case .Mail:
                    
                    userL = userLocal()
                    userL?.mail = emailTextField.text
                
                    let datosViewC = datosViewController()
                    let signViewC = singInViewController()
                    
                    
                    Auth.auth().fetchProviders(forEmail: emailTextField.text!, completion: {
                        (providers, error) in
                        
                        if let error = error { print(error.localizedDescription) }
                        else if let providers = providers {
                            self.navigationController?.pushViewController(signViewC, animated: true)
                        } else {
                            print("Disponible")
                            activeScreen = screens.Password
                            self.navigationController?.pushViewController(datosViewC, animated: true)
                        }
                    })
                
                case .Password:
                    userL?.password = emailTextField.text
                    activeScreen = screens.Age
                    let datosViewC = datosViewController()
                    
                    self.navigationController?.pushViewController(datosViewC, animated: true)
                
                case .Age:
                    
                    userL?.age = emailTextField.text
                    guard let email = userL!.mail, let password = userL!.password, let age = userL!.age else { return }
                    
                    var data:AuthDataResultCallback
                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                        
                        var user2 = user?.user
                        if error != nil { print(error); return }
                        guard let uid = user2?.uid else { print(); return }
                        
                        userL?.uid = uid
                        
                        var ref = Database.database().reference(fromURL: "https:pinterest-5f68e.firebaseio.com")
                        let values = ["age" :age, "email": email]
                        let usersRef = ref.child("users").child(uid)
                        
                        usersRef.updateChildValues(values, withCompletionBlock: { (error, databaseRef:DatabaseReference?) in
                            if  error != nil { print(error) }
                        })
                        let mensaje = ["mensaje" : "soy un mensaje dummy", "uid" : uid]
                        let mensajeRef = ref.child("messages").child(uid)
                        mensajeRef.updateChildValues(mensaje)
                    }
                    
                    let layout = PinterestLayout()

                    let uploadVC = UploadImageVC()
                    self.navigationController?.pushViewController(uploadVC, animated: true)
            }
            
        }
        
    }
    
    
}

