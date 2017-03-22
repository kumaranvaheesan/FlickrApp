//
//  DetailViewController.swift
//  FlickerApp
//
//  Created by kumaran V on 21/03/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class DetailViewController: UIViewController,FlickrPhotoInfoDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    var photoInfo : PhotoInfo!
    var spinner = UIActivityIndicatorView()
    var imageURL : String!
    var photoId : String!
    var flickrClient: FlickrPhotoInfoGetter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Info"
        tableView.tableFooterView = UIView(frame: .zero)
        self.navigationController?.hidesBarsOnSwipe = true
        
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.setupSpinner()
        flickrClient = FlickrPhotoInfoGetter(delegate: self)
        flickrClient.getPhotoInfo(photoId: photoId)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func didreceivePhotoInfo(photoInfo: PhotoInfo) {
        
        self.photoInfo = photoInfo
        self.tableView.reloadData()
        spinner.stopAnimating()
        
    }
    func didNotreceivePhotoInfo(error: NSError) {
        
        spinner.stopAnimating()
        let alert = UIAlertController(title: "Error", message: "There seems to be an error connecting to the server. Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.spinner.stopAnimating()
        
    }
    
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.photoInfo != nil{
            return 6
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)  as! detailInfoCell
        
        switch (indexPath.row) {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell")! as! detailImageCell
            Alamofire.request(imageURL).responseImage { response in
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    DispatchQueue.main.async {
                        cell.detailImageView.image = image
                        
                    }
                }
            }
            
            return cell
            
        case 1:
            
            cell.fieldLabel.text = "Title"
            if let title = self.photoInfo.title?.titleContent{
                cell.detailLabel.text = title
            }
            return cell
            
        case 2:
            
            cell.fieldLabel.text = "Description"
            if let description = self.photoInfo.description?.descriptionContent{
                cell.detailLabel.text = description
                
            }
            return cell
            
            
        case 3:
            
            cell.fieldLabel.text = "Owner"
            cell.detailLabel.text = self.photoInfo.owner?.userName!
            return cell
            
        case 4:
            
            cell.fieldLabel.text = "Date Taken"
            cell.detailLabel.text = self.convertDateFormatter(date: (self.photoInfo.dates?.taken)!)
            return cell
            
        case 5:
            
            cell.fieldLabel.text = "Tags"
            
            if self.photoInfo.tags != nil{
                var tags = ""
                let tagsArray = self.photoInfo.tags?.tag
                for tagContent in tagsArray! {
                    tags.append(tagContent.tag! )
                    tags.append(" ")
                }
                cell.detailLabel.text = tags
            }
            return cell
            
        default:
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func convertDateFormatter(date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "dd MMM yyyy"
        let timeStamp = dateFormatter.string(from: date!)
        
        return timeStamp
    }
    
}

