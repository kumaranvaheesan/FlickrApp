//
//  MasterViewController.swift
//  FlickerApp
//
//  Created by kumaran V on 21/03/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

import UIKit
import CoreLocation

class MasterViewController: UITableViewController,FlickrGetterDelegate,UISearchBarDelegate, CLLocationManagerDelegate {
    
    var detailViewController: DetailViewController? = nil
    var flickrClient: FlickrPhotosGetter!
    var photosList = [Any]()
    var spinner = UIActivityIndicatorView()
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    var searchBar:UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchBar()
        tableView.tableFooterView = UIView(frame: .zero)
        
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        self.setupSpinner()
        flickrClient = FlickrPhotosGetter(delegate: self)
        self.initLocationManager()
    }
    func setupSearchBar()
    {
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Search Flickr"
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.tintColor = UIColor.black
        self.navigationItem.title = "Search"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initLocationManager()
    {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        spinner.startAnimating()
        flickrClient.getPhotosUsingTags(searchText:searchBar.text)
        self.searchBar.resignFirstResponder()
        
    }
    
    func getFlickrPhotosByLocation()
    {
        self.spinner.startAnimating()
        flickrClient.getPhotosUsingLocation(currentLocation: self.currentLocation)
    }
    
    func didreceivePhotos(photosArray : [Any]) {
        DispatchQueue.main.async {
            self.photosList = photosArray
            self.tableView.reloadData()
            self.spinner.stopAnimating()
        }
    }
    
    func didNotreceivePhotos(error: NSError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "There seems to be an error connecting to the server. Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.spinner.stopAnimating()
        }
    }
    
    
    
    func setupSpinner(){
        
        spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height:60))
        self.spinner.center = self.view.center
        self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        self.spinner.transform = transform
        self.view.addSubview(spinner)
        spinner.hidesWhenStopped = true
        
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let photo = photosList[indexPath.row] as! FlickrPhoto
                var controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.imageURL = photo.photoUrl()
                controller.photoId = photo.id
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                
            }
        }
    }
    
    
    //MARK: - Location Service
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations[0] as CLLocation
        self.getFlickrPhotosByLocation()
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell")! as! CustomTableViewCell
        
        let photo = photosList[indexPath.row] as! FlickrPhoto
        cell.titleLabel.text = photo.title
        cell.flickerImageView.imageFromServerURL(urlString: photo.photoUrl())
        return cell
    }
    
}

//Extension for loading Image from server asynchronously

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}


