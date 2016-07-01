//
//  Bowtie+CoreDataProperties.swift
//  CoreDataTest_2
//
//  Created by Kim, Min Ho on 2016. 6. 10..
//  Copyright © 2016년 Void Systems. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Bowtie {

    @NSManaged var isFavorite: NSNumber?
    @NSManaged var lastWorn: NSDate?
    @NSManaged var name: String?
    @NSManaged var photoData: NSData?
    @NSManaged var rating: NSNumber?
    @NSManaged var searchKey: String?
    @NSManaged var timesWorn: NSNumber?
    @NSManaged var tintColor: NSObject?

}
