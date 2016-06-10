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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func segmentedControl(sender: UISegmentedControl) {
    }
    
    @IBAction func wear(sender: AnyObject) {
    }
    
    @IBAction func rate(sender: AnyObject) {
    }
    
    // Insert sample data
    func insertSampleData() {
        let fetchRequest = NSFetchRequest(entityName: "Bowtie")
        fetchRequest.predicate = NSPredicate(format: "searchKey != nil")
        
        let count = managedContext.countForFetchRequest(fetchRequest, error: nil)
        
        if count > 0 { return }
        
        let path = NSBundle.mainBundle().pathForResource("SampleData", ofType: "plist")
        let dataArray = NSArray(contentOfFile: path!)
        
        
    }
}

