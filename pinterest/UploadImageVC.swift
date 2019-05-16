//
//  UploadImageVC.swift
//  pinterest
//
//  Created by Nicolas De La Cruz, Mariano Ramirez, Ricardo Sanchez on 10/3/19.
//  Copyright © 2019 Alumno IDS. All rights reserved.//

import UIKit
import Firebase
import AVFoundation
import Vision

class UploadImageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 0, g: 0, b: 0)
        view.addSubview(takePictureButton)
        view.addSubview(chooseButton)
        view.addSubview(uploadButton)
        view.addSubview(imageToUpload)
    
        
        takePictureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        takePictureButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 240).isActive = true
        takePictureButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        takePictureButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        takePictureButton.addTarget(self, action: "setupCaptureSession:", for: .touchUpInside)
        
        chooseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chooseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200).isActive = true
        chooseButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        chooseButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        uploadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 160).isActive = true
        uploadButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        uploadButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        imageToUpload.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        imageToUpload.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageToUpload.widthAnchor.constraint(equalToConstant: 300).isActive = true
        imageToUpload.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        func setupCaptureSession() {
            let captureSession = AVCaptureSession()
            
            let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices
            
            do {
                if let captureDevice = availableDevices.first {
                    let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
                    captureSession.addInput(captureDeviceInput)
                }
            } catch {
                print(error.localizedDescription)
            }
            
            let captureOutput = AVCaptureVideoDataOutput()
            captureOutput.setSampleBufferDelegate(self as! AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue(label: "videoQueue"))
            captureSession.addOutput(captureOutput)
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = view.frame
            view.layer.addSublayer(previewLayer)
            
            captureSession.startRunning()
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let model = try? VNCoreMLModel(for: MarsHabitatPricer().model) else {return}
            
            let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
                
                guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
                guard let Observation = results.first else { return }
                
                DispatchQueue.main.async(execute: {
                    self.label.text = "\(Observation.identifier)"
                })
            }
            guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
                        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        }
        
        func setupLabel() {
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        }
    }
    
    let imageToUpload : UIImageView = {
        let imageV = UIImageView()
        imageV.image = #imageLiteral(resourceName: "pinterestLogo")
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    lazy var takePictureButton : UIButton = {
        let ub = UIButton()
        ub.backgroundColor = UIColor(red: 213/255, green: 75/255, blue: 61/255, alpha: 1)
        ub.setTitle("Tomar imagen", for: .normal)
        ub.translatesAutoresizingMaskIntoConstraints = false
        ub.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        return ub
    }()
    
    lazy var chooseButton : UIButton = {
        let ub = UIButton()
        ub.backgroundColor = UIColor(red: 15/255, green: 156/255, blue: 88/255, alpha: 1)
        ub.setTitle("Elegir imagen", for: .normal)
        ub.translatesAutoresizingMaskIntoConstraints = false
        ub.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        return ub
    }()
    
    lazy var uploadButton : UIButton = {
        let ub = UIButton()
        ub.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 153/255, alpha: 1)
        ub.setTitle("Subir imagen", for: .normal)
        ub.translatesAutoresizingMaskIntoConstraints = false
        ub.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
        return ub
    }()
    
    
    let pinMessageTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "mensaje..."
        tf.backgroundColor = .white
        tf.text = ""
        return tf
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Label"
        label.font = label.font.withSize(30)
        return label
    }()
    
    
    @objc func handleButton(_ sender:UIButton){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)

    }
    
    
    @objc func uploadImage(){
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("MEMES").child("\(imageName).jpg")
        var UID = "123"//userL?.uid
        
        var metaData = StorageMetadata()
        metaData.customMetadata = [ "user uuid" : UID, "message" : "imagen de prueba", "url" : "1223"] as! [String : String]
        
        if let uploadData = UIImageJPEGRepresentation(imageToUpload.image!, 300){
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("error al subir imagen, sustituyendo")
                    var imagenSustituto = #imageLiteral(resourceName: "laptop_acer")
                    imagenesArray.append(imagenSustituto as! UIImage)
                    return
                }
                
                var ref = Database.database().reference(fromURL: "https:pinterest-5f68e.firebaseio.com")
                let values = ["nombre" :imageName, "type": "jpg", "uuid" : UID, "message" : self.pinMessageTextField.text as! String, "url" : "123"]
                let usersRef = ref.child("imagesURLS").child(imageName)
                
                usersRef.updateChildValues(values, withCompletionBlock: { (error, databaseRef:DatabaseReference?) in
                    if  error != nil { print(error) }
                })
                
            })
        }
        
        self.loadPines()
        
    }
    
    
    func run(after seconds: Int, completion: @escaping () -> Void){
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
    }
    
    func loadPines() -> Int {
        let URLSRef = Database.database().reference().child("imagesURLS")
        
        URLSRef.observe(DataEventType.value, with: {(snapshot)  in
            if snapshot.childrenCount > 0 {
                
                imagenesArray.removeAll()
                urlsList.removeAll()
                messagesArray.removeAll()
                
                for pines in snapshot.children.allObjects as! [DataSnapshot]{
                    let pinObject = pines.value as? [String: AnyObject]
                    var pinName = pinObject?["nombre"] as! String!
                    var pinType = pinObject?["type"] as! String!
                    var currentMessage = pinObject?["message"] as! String!
                    messagesArray.append(currentMessage!)
                    var imageToDownload = pinName! + "." + pinType!
                    urlsList.append(imageToDownload)
                    
                    storageRef = Storage.storage().reference().child("MEMES/\(imageToDownload)")
                    storageRef.getData(maxSize: 3 * 1024 * 1024) { data, error in
                        if let error = error {
  
                            print("error, sustituyendo imagen")
                            var imagenSustituto = #imageLiteral(resourceName: "laptop_acer")
                            imagenesArray.append(imagenSustituto as! UIImage)
                        } else {
                            let image = UIImage(data: data!)
                            imagenesArray.append(image as! UIImage)
                        }
                    }
                    print("nueva imagen: \(imageToDownload) cuenta nueva de urlsList \(urlsList.count)")
                }
                
                
                self.run(after: 3){
                    
                    let layout = PinterestLayout()
                    let collectionViewC = CollectionViewController(collectionViewLayout: layout)
                    self.navigationController?.pushViewController(collectionViewC, animated: true)                }
                
            } else {
                
            }
            
        })
        

        return urlsList.count
    }
    
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            print(editedImage.size)
            selectedImageFromPicker = editedImage
            print(selectedImageFromPicker?.size)
        }

        if let selectedImage = selectedImageFromPicker {
            imageToUpload.image = selectedImage
        }
        
        print("imagen seleccionada")        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled")
    }
    
    
}
