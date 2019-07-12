//
//  ImageToTextViewController.swift
//  AugRealApp
//
//  Created by Madhumita Ghosal on 6/14/19.
//  Copyright © 2019 Madhumita Ghosal. All rights reserved.
//

import AVFoundation
import UIKit
import Firebase
import CoreLocation
import MapKit

class ImageToTextViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    
   
    
    //Constants
    let locationManager = CLLocationManager()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detectTextLabel: UILabel!
    @IBOutlet weak var detectedTextLabel: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var manualEntryButton: UIButton!
    
    lazy var vision = Vision.vision()
    var textRecognize: VisionTextDetector?
    
    //Declaration of instance variables 
    var detectedText : String = ""
    var url = ""
    var loc = ""
    var ani = ""
    var randomNo = Int()
     
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Location settings
        locationManager.delegate = self as! CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        detectTextLabel.isHidden = true
        detectedTextLabel.isHidden = true
        okButton.isHidden = true
        manualEntryButton.isHidden = true
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let photoLibraryAction = UIAlertAction(title: "From Photo Library", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
            {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let prompt = UIAlertController(title: "Please choose one option", message: nil, preferredStyle: .actionSheet)
        prompt.addAction(cameraAction)
        prompt.addAction(photoLibraryAction)
        self.present(prompt, animated: true)
      
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userlocation = locations[0] as CLLocation
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userlocation) { (placemarks, error) in
            if(error != nil)
            {
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks! [0]
                self.loc = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
            }
        }
       // print(self.loc)
        let newPin = MKPointAnnotation()
        mapView.removeAnnotation(newPin)
        
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //set region on the map
        mapView.setRegion(region, animated: true)
        newPin.coordinate = location.coordinate
        mapView.addAnnotation(newPin)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("couldn't load image")
        }
        convertText(image: image)
    }
    
    
    func convertText (image: UIImage)
    {
        textRecognize = vision.textDetector()
        let visionImage = VisionImage(image: image)
        
        let cameraPosition = AVCaptureDevice.Position.back  // Set to the capture device you used.
        let metadata = VisionImageMetadata()
        metadata.orientation = imageOrientation(
            deviceOrientation: UIDevice.current.orientation,
            cameraPosition: cameraPosition
        )
        
        visionImage.metadata = metadata
        
        textRecognize?.detect(in: visionImage) { (features, error) in
            guard error == nil, let features = features, !features.isEmpty else {
                return
            }
            
        //   debugPrint("Feature blocks in th image: \(features.count)")
            
            for feature in features {
                let value = feature.text
                self.detectedText.append("\(value) ")
            }
            debugPrint(self.detectedText)
            self.verifyDetectedText()
        }
    }
    
    
    func imageOrientation(
        deviceOrientation: UIDeviceOrientation,
        cameraPosition: AVCaptureDevice.Position
        ) -> VisionDetectorImageOrientation {
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftTop : .rightTop
        case .landscapeLeft:
            return cameraPosition == .front ? .bottomLeft : .topLeft
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightBottom : .leftBottom
        case .landscapeRight:
            return cameraPosition == .front ? .topRight : .bottomRight
        case .faceDown, .faceUp, .unknown:
            return .leftTop
        }
    }
    
    
    func verifyDetectedText()
    {
        detectTextLabel.isHidden = false
        detectedTextLabel.isHidden = false
        okButton.isHidden = false
        manualEntryButton.isHidden = false
        
        detectedTextLabel.text = detectedText
        okButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        manualEntryButton.addTarget(self, action: #selector(manualbuttonAction), for: .touchUpInside)
        
        calldb()
    }
    
    func calldb()
    {
        randomNo = Int.random(in: 1 ... 7)
        let ref = Database.database().reference()
        
        var rand = String(randomNo)
        print("Random number to retrive animal is \(rand)")
        
        ref.child("location").child("wetland").child(rand).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.ani = value?["animal"] as? String ?? "wood frog"
            print("The displayed animal is \(self.ani)")
        })
//        { (error) in
//            print(error.localizedDescription)
//        }
        
        
        
        // db query to randomly pick up any animal
//        ref.child("Location").child("Wetlands").child(rand).observeSingleEvent(of: .value, with: {(snapshot) in
//            let dict = snapshot.value as! [String: Any]
//            if self.ani  == nil
//            {
//                return
//            }
//            else
//            {
//                self.ani = dict["Animal"] as! String ?? ""
//                print("++++++++++++++\(self.ani)")
//            }
//        })
        
        
    }
    
    @objc func manualbuttonAction(sender: UIButton!) {
        let alert = UIAlertController(title: "Enter Text", message: "Please type the text", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter text"
        })
        let action = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            if let alertTextField = alert.textFields?.first, alertTextField.text != nil {

                self.detectedTextLabel.text = " \(alertTextField.text!)"
                self.detectedText = alertTextField.text!
            }
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated:true)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        self.performSegue(withIdentifier: "goToAR", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var aug = segue.destination as! AugmentedRealityViewController
        aug.url = self.url
        aug.detectedText = detectedText
        aug.ObjectToDisplay = self.ani
        aug.location = loc
        aug.randomAnimalDisplay = randomNo
    }
}
