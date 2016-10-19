//
//  Workout.swift
//  Libero
//
//  Created by John Kotz on 10/16/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import Foundation
import Parse

class Workout: PFObject, PFSubclassing {
    @NSManaged var start: NSDate
    @NSManaged var duration: Float // in minutes
    @NSManaged private var type: String
    @NSManaged private var activity: String
    @NSManaged private var count: NSNumber?
    @NSManaged private var distance: NSNumber?
    @NSManaged private var speed: NSNumber?
    var locationData: [CLLocation] = []
    var end: NSDate?
    
    // This is the public value which can be received and set to
    //     but when they set it I will redirect the value into the Parse managed values
    var typeInfo: (type: WorkoutType, name: WorkoutName) {
        get {
            return typeValue
        }
        set {
            self.typeValue = newValue
            self.type = newValue.type.rawValue
            self.activity = newValue.name.rawValue
        }
    }
    // This is the actual value stored. Within this file I wont touch the one above
    private var typeValue: (type: WorkoutType, name: WorkoutName) = (.unknown, .unknown)
    
    
    var data: Subdata? = Subdata(activity: .unknown)
    
    // ------ Enums -------
    // This will provide an easy way to identify and set values
    enum WorkoutType: String {
        case distance
        case repetition
        case unknown
    }
    
    // The names here are exactly what will be used in the string value
    enum WorkoutName: String {
        case run
        case walk
        case pushups
        case unknown
    }
    
    // ---- Data Subclassing ----
    class Subdata {
        // This class will provide a super class for different types of activity data
        
        // Clearly every activity will have a name, liking running, walking, so on
        //     so I will store that in every object
        var activity: WorkoutName
        
        class Repetition: Subdata {
            // For things like pushups and so on
            
            // We will likely take more data eventually
            var count: Int
            
            // This will make use of the super property
            init(activity: WorkoutName, count: Int) {
                self.count = count
                super.init(activity: activity)
            }
            
            // The object will put the count value into the workout
            override func save(into workout: Workout) {
                super.save(into: workout)
                
                workout.count = self.count as NSNumber
            }
        }
        
        class Distance: Subdata {
            var distance: Double
            var speed: Double
            
            init(activity: WorkoutName, distance: Double, speed: Double) {
                self.distance = distance
                self.speed = speed
                super.init(activity: activity)
            }
            
            // Now objects with this type will be able to save their special data
            override func save(into workout: Workout) {
                super.save(into: workout)
                
                workout.distance = self.distance as NSNumber
                workout.speed = self.speed as NSNumber
            }
        }
        
        // This will control the creation
        init(activity: WorkoutName) {
            self.activity = activity
        }
        
        /**
         This will put all the pertinent data into the given workout object
         */
        func save(into workout: Workout) {
            workout.activity = self.activity.rawValue
            workout.typeValue = (workout.typeValue.type, self.activity)
        }
    }
    
    override init() {
        super.init()
        
        // The following parses the name and type of the object
        let type = WorkoutType(rawValue: self.type)
        let name = WorkoutName(rawValue: self.activity)
        
        self.typeValue = (type != nil ? type! : .unknown, name != nil ? name! : .unknown)
        
        if let type = type, let name = name {
            switch type {
            case .distance:
                self.data = Subdata.Distance(activity: name,
                                             distance: self.distance != nil ? self.distance!.doubleValue : 0.0,
                                             speed: self.speed != nil ? self.speed!.doubleValue : 0.0)
                break
                
            case .repetition:
                self.data = Subdata.Repetition(activity: name, count: self.count != nil ? self.count!.intValue : 0)
                break
                
            default:
                self.data = nil
                break
            }
        }
    }
    
    /**
     Will save the workout in the current thread. Not recomended
     */
    override func save() throws {
        self.data?.save(into: self)
        try super.save()
    }
    
    /**
     Saves the workout in the background
     */
    override func saveInBackground(block: PFBooleanResultBlock? = nil) {
        // This will consolidate all parsed data into Parse managed values
        self.data?.save(into: self)
        // I am going to force it to update itself, just so the Parse managed values reflect it
        self.typeInfo = (self.typeInfo.type, self.typeInfo.name)
        
        super.saveInBackground(block: block)
    }
    
    static func parseClassName() -> String {
        return "Workout"
    }
    
    
}
