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
    @NSManaged var start: NSDate?
    @NSManaged var duration: Float // in minutes
    @NSManaged var isActive: Bool
    @NSManaged private var type: String
    @NSManaged private var activity: String
    @NSManaged private var difficulty: NSNumber
    @NSManaged private var count: NSNumber?
    @NSManaged private var distance: NSNumber?
    @NSManaged private var speed: NSNumber?
    var locationData: [(loc: CLLocation, date: NSDate)] = []
    var locationManager: LocationManager?
    var end: NSDate?
    var data: Subdata?
    var timer: Timer?
    
    // This is the public value which can be received and set to
    //     but when they set it I will redirect the value into the Parse managed values
    var typeInfo: (type: Type, name: Name, difficulty: Difficulty) {
        get {
            return typeValue
        }
        set {
            self.typeValue = newValue
            self.type = newValue.type.rawValue
            self.activity = newValue.name.rawValue
            self.difficulty = NSNumber(integerLiteral: newValue.difficulty.rawValue)
        }
    }
    // This is the actual value stored. Within this file I wont touch the one above
    private var typeValue: (type: Type, name: Name, difficulty: Difficulty) = (.unknown, .unknown, .unknown)
    
    // ------ Enums -------
    // This will provide an easy way to identify and set values
    // We only support distance for now
    enum `Type`: String {
        case distance
        case unknown
    }
    
    // The names here are exactly what will be used in the string value
    enum Name: String {
        case run
        case walk
        case swim
        case bike
        case unknown
    }
    
    enum Difficulty: Int {
        case easy
        case medium
        case hard
        case unknown
    }
    
    func setName(name: Name) {
        self.typeInfo = (type: self.typeInfo.type, name: name, difficulty: self.typeInfo.difficulty)
    }
    
    // ---- Data Subclassing ----
    class Subdata {
        // This class will provide a super class for different types of activity data
        
        // Clearly every activity will have a name, liking running, walking, so on
        //     so I will store that in every object
        var activity: Name
        
        // We have decided to not use a repetition data set yet
//        class Repetition: Subdata {
//            // For things like pushups and so on
//            
//            // We will likely take more data eventually
//            var count: Int
//            
//            // This will make use of the super property
//            init(activity: Name, count: Int) {
//                self.count = count
//                super.init(activity: activity)
//            }
//            
//            // The object will put the count value into the workout
//            override func save(into workout: Workout) {
//                super.save(into: workout)
//                
//                workout.count = self.count as NSNumber
//            }
//        }
        
        class Distance: Subdata {
            var distance: LocationManager.Distance
            var speed: Double
            
            init(activity: Name, distance: LocationManager.Distance, speed: Double) {
                self.distance = distance
                self.speed = speed
                super.init(activity: activity)
            }
            
            // Now objects with this type will be able to save their special data
            override func save(into workout: Workout) {
                super.save(into: workout)
                
                workout.distance = self.distance.meters as NSNumber
                workout.speed = self.speed as NSNumber
            }
        }
        
        // This will control the creation
        init(activity: Name) {
            self.activity = activity
        }
        
        /**
         This will put all the pertinent data into the given workout object
         */
        func save(into workout: Workout) {
            workout.activity = self.activity.rawValue
            workout.typeValue = (workout.typeValue.type, self.activity, workout.typeValue.difficulty)
        }
    }
    
    func getDuration() -> TimeInterval {
        return ((self.end as? Date) ?? Date()).timeIntervalSince((self.start as? Date) ?? Date())
    }
    
    func startWorkout() {
        self.isActive = true
        self.start = NSDate()
        self.end = nil
    }
    
    func endWorkout() {
        self.isActive = false
        self.end = NSDate()
    }
    
    func startTimer(block: @escaping (_ interval: TimeInterval) -> Void) {
        timer = Timer(timeInterval: 0.01, repeats: true, block: { (timer) in
            block(self.getDuration())
        });
        
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    //
    override init() {
        super.init()
        
        parseTypeInfo()
    }
    
    private func parseTypeInfo() {
        // The following parses the name and type of the object
        let type = Type(rawValue: self.type)
        let name = Name(rawValue: self.activity)
        let difficulty = Difficulty(rawValue: self.difficulty.intValue)
        
        self.typeValue = (type ?? .unknown, name ?? .unknown, difficulty ?? .unknown)
        
        if let type = type, let name = name {
            switch type {
            case .distance:
                self.data = Subdata.Distance(activity: name,
                                             distance: LocationManager.Distance(distance: (self.distance == nil) ? 0.0 : self.distance!.doubleValue),
                                             speed: self.speed != nil ? self.speed!.doubleValue : 0.0)
                break
                
            default:
                self.data = nil
                break
            }
        }
    }
    
    // Creates a new one
    init(type: Type, activity: Name) {
       super.init()
        
        self.type = type.rawValue
        self.activity = activity.rawValue
        
        parseTypeInfo()
    }
    
    /**
     Adds the workout to the user object given
     */
    func addToUser(user: User) {
        user.addWorkout(workout: self)
    }
    
    func startLocationTracking() {
        self.locationManager = LocationManager()
        
        self.locationData.removeAll()
        locationManager?.getMultipleLocations(callback: { (location) in
            if let lastLoc = self.locationData.last {
                let lastLegDistance = self.locationManager!.calculateDistance(start: lastLoc.loc, end: location)
                
                if let data = self.data as? Subdata.Distance {
                    data.distance = lastLegDistance.addToDistance(distance: data.distance)
                }else{
                    self.data = Subdata.Distance(activity: self.typeValue.name, distance: LocationManager.Distance(distance: 0.0), speed: 0.0)
                }
            }
            
            self.locationData.append((loc: location, date: NSDate()))
        })
    }
    
    func stopLocationTracking() {
        locationManager?.cancelLocation()
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
        self.typeInfo = self.typeValue
        
        super.saveInBackground(block: block)
    }
    
    static func parseClassName() -> String {
        return "Workout"
    }
}
