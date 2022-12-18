//
//  mapViewController.swift
//
//  Created by Qing Liu on 10/18/22.
//  Copyright © 2022 Qing Liu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class mapViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate{

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var oneFeetButton: UIButton!
    
    @IBOutlet weak var threeButton: UIButton!
        
    
//    private let locationManager=CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.mapView.delegate=self
//        locationManager.delegate=self
        
//        locationManager.requestWhenInUseAuthorization()
        
//        locationManager.desiredAccuracy=kCLLocationAccuracyBest
//        locationManager.distanceFilter=kCLDistanceFilterNone
//        locationManager.startUpdatingLocation()

        
        self.mapView.showsUserLocation=true
        
        self.mapTypeSegmentedControl.addTarget(self, action: #selector(mapTypeChanged), for: .valueChanged)
        
    }
    
    
    @objc func mapTypeChanged(segmentedControl:UISegmentedControl){
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.mapView.mapType = .standard
        case 1:
            self.mapView.mapType = .satellite
        case 2:
            self.mapView.mapType = .hybrid
        default:
            self.mapView.mapType = .standard
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        let center1 = CLLocationCoordinate2DMake(41.825, -71.408056) //(latitude,longtitude) in Providence
        let region=MKCoordinateRegion(center: center1, latitudinalMeters:280,longitudinalMeters:280)
        mapView.setRegion(region, animated: true)
    
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        var floodingAnnotationView=mapView.dequeueReusableAnnotationView(withIdentifier: "downTownFloodingView") as? MKMarkerAnnotationView

        if floodingAnnotationView==nil{
//            floodingAnnotationView=MKAnnotationView(annotation: annotation, reuseIdentifier: "downTownFloodingView")
            floodingAnnotationView=MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "downTownFloodingView")

//            floodingAnnotationView?.glyphImage=UIImage(contentsOfFile: "water15.png")
            floodingAnnotationView?.glyphText="💧"
            floodingAnnotationView?.markerTintColor=UIColor.white
            
            floodingAnnotationView?.canShowCallout=true


        }else{
            floodingAnnotationView?.annotation=annotation
        }

//        if let floodingAnnotation = annotation as? FloodingSites{
//            floodingAnnotationView?.image=UIImage(named: floodingAnnotation.imageURL)
//        }
        
        print("ann")
        print("annotation:\(annotation)")
        let annotationName=annotation.title as? String
        print("name:\(annotationName)")
        configureView(floodingAnnotationView,annotation,annotationName!)
        return floodingAnnotationView

    }
    
//    private func configureView(_ annotationView: MKAnnotationView?,_ annotation: MKAnnotation?){
//
//        let view=UIView(frame: CGRect.zero)
//        view.translatesAutoresizingMaskIntoConstraints=false
//        view.widthAnchor.constraint(equalToConstant: 200).isActive=true
//        view.heightAnchor.constraint(equalToConstant: 200).isActive=true
//        view.backgroundColor = .red
//
//        annotationView?.leftCalloutAccessoryView=UIImageView(image: UIImage(named: "water10"))
//
//
//
//        let rightButton = UIButton(type: .detailDisclosure) // HERE IS THIS BUTTON, BUT I NEED EACH BUTTON FOR EACH ANNOTATION - THIS WAY IT SHOULD BE ONE FOR ALL OF THEM
//
//        annotationView?.canShowCallout = true
//        annotationView?.rightCalloutAccessoryView = rightButton
//
//        annotationView?.detailCalloutAccessoryView=view
//        rightButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
////        rightButton.addTarget(self, action: #selector(SingleQuestionViewController.selected(_:annotation)), for: .touchUpInside)
////        annotationView.rightCalloutAccessoryView = btn
//    }
    
    private func configureView(_ annotationView: MKAnnotationView?,_ annotation: MKAnnotation?,_ annotationName:String){
//        
//        let view=UIView(frame: CGRect.zero)
//        view.translatesAutoresizingMaskIntoConstraints=false
//        view.widthAnchor.constraint(equalToConstant: 200).isActive=true
//        view.heightAnchor.constraint(equalToConstant: 200).isActive=true
//        view.backgroundColor = .red
//        annotationView?.rightCalloutAccessoryView=view
//
//        let name=annotation.title
        
        let lists:[String]=[
            "Bridge","Bench","Garden","Road","Street","Open Space","Riverwalk","Parking","Forest"
        ]
        var imageName="notsure"
        
        for item in lists{
            if annotationName==item{
                imageName=item
            }
        }
        if imageName=="notsure"{
            imageName="present"
        }
        
        print("annotationName:\(annotationName)")
        print("1111imageName:\(imageName)")
       
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 180, height: 180))
        print("2222imageName:\(imageName)")
        button.setImage(UIImage(named: imageName), for: .normal)
        print("3333imageName:\(imageName)")
        annotationView!.rightCalloutAccessoryView = button
        
//        annotationView?.leftCalloutAccessoryView=UIImageView.init(frame: CGRect.zero)
        
        
        
        
        let snapShotSize=CGSize(width: 150, height: 150)
        let snapShotView=UIView(frame: CGRect.zero)
        snapShotView.translatesAutoresizingMaskIntoConstraints=false
        snapShotView.widthAnchor.constraint(equalToConstant: snapShotSize.width).isActive=true
        snapShotView.heightAnchor.constraint(equalToConstant: snapShotSize.height).isActive=true
        
        
        let options=MKMapSnapshotter.Options()
        options.size=snapShotSize
        options.mapType = .satellite
        options.camera=MKMapCamera(lookingAtCenter: (annotationView?.annotation?.coordinate)!, fromDistance: 100, pitch: -50, heading: 30)
            
//            MKMapCamera(lookingAtCenter: (annotationView?.annotation?.coordinate)!, fromDistance: 200, pitch: 90, heading: 0)
        
        let snapshotter=MKMapSnapshotter(options: options)
        snapshotter.start{(snapshot,error) in
            if let error=error{
                print(error.localizedDescription)
                return
            }
            
            if let snapshot=snapshot{
                let imageView=UIImageView(frame: CGRect(x: 0, y: 0, width: snapShotSize.width, height: snapShotSize.height))
                imageView.image=snapshot.image
                snapShotView.addSubview(imageView)
            }
        }
        
        
        annotationView?.detailCalloutAccessoryView=snapShotView
        
        
    }
    
    

    @objc func buttonPressed(_ sender: Any) {
        let alert = UIAlertController(
            title: "Howdy!", message: "You tapped me!",
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }


    
    
    //add annotation to 25 years
    @IBAction func displayShot(_ sender: UIButton) {
        //threeButton
        
        
        threeButton.backgroundColor = .orange
        
        let locations = [
            ["title": "Street","subtitle":"1 foot sea level rise",    "latitude": 41.826667, "longitude": -71.409444],
            ["title": "Street","subtitle":"1 foot sea level rise",    "latitude": 41.826111, "longitude": -71.41],
            ["title": "Parking","subtitle":"1 foot sea level rise", "latitude": 41.825833, "longitude": -71.41],
            ["title": "Street", "subtitle":"1 foot sea level rise",    "latitude": 41.825278, "longitude": -71.408889],
            ["title": "Street", "subtitle":"1 foot sea level rise",    "latitude": 41.823889, "longitude": -71.408056],
            ["title": "Forest", "subtitle":"1 foot sea level rise",    "latitude": 41.824444, "longitude": -71.407222],
            ["title": "Bench", "subtitle":"1 foot sea level rise",    "latitude": 41.824722, "longitude": -71.4075],
            ["title": "Statue", "subtitle":"1 foot sea level rise",    "latitude": 41.825278, "longitude": -71.407778],
            ["title": "Open Space", "subtitle":"1 foot sea level rise",    "latitude": 41.825833, "longitude": -71.408333],
            ["title": "Garden", "subtitle":"1 foot sea level rise",    "latitude": 41.825278, "longitude": -71.409167],
            ["title": "Parking", "subtitle":"1 foot sea level rise",    "latitude": 41.824167, "longitude": -71.408611],
            ["title": "Parking", "subtitle":"1 foot sea level rise",    "latitude": 41.823889, "longitude": 71.408611],
            
            
        ]
        
        for location in locations {
//            let annotation = MKPointAnnotation()
            let annotation=FloodingSites()
            annotation.title = location["title"] as? String
//            var des=annotation.title!
            annotation.subtitle = location["subtitle"] as? String
            annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
            annotation.imageURL = "water14.png"
           
            self.mapView.addAnnotation(annotation)

        }
        
        
//        let annotation = FloodingSites()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 41.825278, longitude: -71.409167)
//        annotation.title = "DownTown Providence"
////        annotation.subtitle = "Statue of Liberty"
////        annotation.imageURL = "water8.png"
//        self.mapView.addAnnotation(annotation)
    }
    
    
    
    
    
    //add annotation
    @IBAction func oneFeetPress(_ sender: UIButton) {
        oneFeetButton.backgroundColor = .orange
        
        let locations = [
            ["title": "Bridge","subtitle":"1 foot sea level rise",    "latitude": 41.826389, "longitude": -71.409722],
            ["title": "Bridge","subtitle":"1 foot sea level rise",    "latitude": 41.825278, "longitude": -71.408333],
            ["title": "Bridge","subtitle":"1 foot sea level rise", "latitude": 41.824167, "longitude": -71.407778],
            ["title": "Riverwalk", "subtitle":"1 foot sea level rise",    "latitude": 41.826111, "longitude": -71.409167],
            ["title": "Riverwalk", "subtitle":"1 foot sea level rise",    "latitude": 41.824722, "longitude": -71.408056],
            ["title": "Road", "subtitle":"1 foot sea level rise",    "latitude": 41.824444, "longitude": -71.407778],
            ["title": "Road", "subtitle":"1 foot sea level rise",    "latitude": 41.824167, "longitude": -71.4075]
            
        ]
        
//        let locations = [
//            ["title": "Riverwalk","subtitle":"1 foot sea level rise",    "latitude": 41.825, "longitude": -71.408056],
//            ["title": "Bridge","subtitle":"1 foot sea level rise",    "latitude": 41.824444, "longitude": -71.407778],
//            ["title": "Parking","subtitle":"1 foot sea level rise", "latitude": 41.824167, "longitude": -71.408611],
//            ["title": "Statue", "subtitle":"1 foot sea level rise",    "latitude": 41.825278, "longitude": -71.408056]
//
//        ]
        
        for location in locations {
//            let annotation = MKPointAnnotation()
            let annotation=FloodingSites()
            annotation.title = location["title"] as? String
//            var des=annotation.title!
            annotation.subtitle = location["subtitle"] as? String
            annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
            annotation.imageURL = "water12.png"
            self.mapView.addAnnotation(annotation)
        }
        
    }
    
    
    

    
   
//    cell?.backgroundColor = UIColor.systemGray2

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
