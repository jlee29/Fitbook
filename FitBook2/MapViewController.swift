//
//  MapViewController.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/13/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var post: Post?
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if post != nil {
            let postLocation = CLLocation(latitude: Double(((post?.latitude)!)!)!, longitude: Double(((post?.longitude)!)!)!)
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(postLocation.coordinate, 500, 500)
            let annotation = MKPointAnnotation()
            annotation.coordinate = postLocation.coordinate
            map.addAnnotation(annotation)
            map.setRegion(coordinateRegion, animated: true)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
