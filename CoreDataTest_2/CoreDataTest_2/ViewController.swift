//
//  ViewController.swift
//  CoreDataTest_2
//
//  Created by Kim, Min Ho on 2016. 6. 3..
//  Copyright © 2016년 Void Systems. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timesWornLabel: UILabel!
    @IBOutlet weak var lastWornLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var managedContext: NSManagedObjectContext!
    var currentBowtie: Bowtie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        insertSampleData()
        
        let request = NSFetchRequest(entityName: "Bowtie")
        let firstTitle = segmentedControl.titleForSegmentAtIndex(0)
        
        request.predicate = NSPredicate(format: "searchKey == %@", firstTitle!)
        
        do {
            let bowties = try managedContext.executeFetchRequest(request) as? [Bowtie]

            currentBowtie = bowties![0]
            populate(currentBowtie)
        } catch (let error as NSError?) {
            print("Could not fetch \(error), \(error!.userInfo)")
        }
        print("a")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func segmentedControl(sender: UISegmentedControl) {
        let selectedValue = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)
        let fetchRequest = NSFetchRequest(entityName: "Bowtie")
        
        fetchRequest.predicate = NSPredicate(format: "searchKey == %@", selectedValue!)
        
        do {
            let bowties = try managedContext.executeFetchRequest(fetchRequest) as? [Bowtie]
            
            currentBowtie = bowties!.last!
            populate(currentBowtie)
        } catch (let error as NSError?) {
            print("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    @IBAction func wear(sender: AnyObject) {
        let times = currentBowtie.timesWorn?.integerValue
        
        currentBowtie.timesWorn = NSNumber(integer: (times! + 1))
        currentBowtie.lastWorn = NSDate()
        
        do {
            try managedContext.save()
            populate(currentBowtie)
            
        } catch(let error as NSError?) {
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    @IBAction func rate(sender: AnyObject) {
        let alert = UIAlertController(title: "New Rating", message: "Rate this bow tie", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) in }
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction!) in
            let textField = alert.textFields![0]
            self.updateRating(textField.text!)
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) in }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Insert sample data
    func insertSampleData() {
        let fetchRequest = NSFetchRequest(entityName: "Bowtie")
        fetchRequest.predicate = NSPredicate(format: "searchKey != nil")
        
        let count = managedContext.countForFetchRequest(fetchRequest, error: nil)
        
        if count > 0 { return }
        
        let path = NSBundle.mainBundle().pathForResource("SampleData", ofType: "plist")
        let dicts = NSArray(contentsOfFile: path!)
        
        for dict: AnyObject in dicts! {
            let entity = NSEntityDescription.entityForName("Bowtie", inManagedObjectContext: managedContext)
            
            let bowtie = Bowtie(entity: entity!, insertIntoManagedObjectContext: managedContext)

            let bowtieDict = dict as! NSDictionary
            
            bowtie.name = bowtieDict["name"] as? String
            bowtie.searchKey = bowtieDict["searchKey"] as? String
            bowtie.rating = bowtieDict["rating"] as? NSNumber
            bowtie.tintColor = colorFromDictionary(bowtieDict["tintColor"] as! NSDictionary)
            bowtie.lastWorn = bowtieDict["lastWorn"] as? NSDate
            bowtie.timesWorn = bowtieDict["timesWorn"] as? NSNumber
            bowtie.isFavorite = bowtieDict["isFavorite"] as? NSNumber
            
            let imageName = bowtieDict["imageName"] as? String
            let image = UIImage(named: imageName!)
            let photoData = UIImagePNGRepresentation(image!)
            
            bowtie.photoData = photoData
        }
        
//        _ = try? managedContext.save()
        
        do {
            try managedContext.save()
            
        } catch(let error as NSError?) {
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func colorFromDictionary(dict: NSDictionary) -> UIColor {
        let r = dict["red"] as! NSNumber
        let g = dict["green"] as! NSNumber
        let b = dict["blue"] as! NSNumber
        
        let color = UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
        
        return color
    }
    
    func populate(bowtie: Bowtie) {
        imageView.image = UIImage(data: bowtie.photoData!)
        nameLabel.text = bowtie.name
        ratingLabel.text = "Rating: \(bowtie.rating!.doubleValue)/5"
        timesWornLabel.text = "# times worn: \(bowtie.timesWorn!.integerValue)"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .NoStyle
        
        lastWornLabel.text = "Last worn: " + dateFormatter.stringFromDate(bowtie.lastWorn!)
        favoriteLabel.hidden = !bowtie.isFavorite!.boolValue
        
        view.tintColor = bowtie.tintColor as! UIColor
    }
    
    func updateRating(numericString: String) {
        let rating = Double(numericString)
        currentBowtie.rating = NSNumber(double: rating!)
        
        do {
            try managedContext.save()
            populate(currentBowtie)
            
        } catch(let error as NSError?) {
            if error!.code == NSValidationNumberTooLargeError ||
               error!.code == NSValidationNumberTooSmallError {
                rate(currentBowtie)
            }
        }
    }
}

