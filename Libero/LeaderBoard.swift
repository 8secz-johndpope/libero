//
//  LeaderBoard.swift
//  Libero
//
//  Created by John Kotz on 10/26/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import Foundation
import Parse

class Leaderboard {
    /**
     A static class that deals with the leaderboard
     
     Example code for getting global walking leaderboards:
         var query = Leaderboard.Query()
         query.activity = .walk
         
         query.complete() { (users, error) in
            // ... use the users
         }
     */
    
    class Query {
        /**
         A query for the leaderboards
         */
        
        // These values are the how a user will specify the system
        var activity: Workout.Name?
        var league: League?
        
        convenience init(activity: Workout.Name) {
            self.init(activity: activity, league: nil)
        }
        
        convenience init(league: League) {
            self.init(activity: nil, league: league)
        }
        
        convenience init() {
            self.init(activity: nil, league: nil)
        }
        
        init(activity: Workout.Name?, league: League?) {
            self.activity = activity
            self.league = league
        }

        /**
         Will complete the query and return all the users in order of the leaderboard
         */
        func complete(_ block: @escaping ([User]?, BackendError?) -> Void) {
            var query = PFQuery(className: "User")
            if let league = league {
                query = league.relation(forKey: "members").query()
            }
            
            if let activity = activity {
                query.addDescendingOrder(activity.rawValue)
            }else{
                query.addDescendingOrder("numWorkouts")
            }
            
            query.findObjectsInBackground { (objects, error) in
                var retError: BackendError? = nil
                
                if let error = error {
                    switch error._code {
                    case 500:
                        retError = BackendError.FailedToConnect
                        break
                        
                    default:
                        retError = BackendError.UnknownError
                    }
                }
                
                block(objects as? [User], retError)
            }
        }
    }
    
    /**
     Completes the given query
     */
    class func completeQuery(query: Query, _ block: @escaping ([User]?, BackendError?) -> Void) {
        query.complete(block)
    }
}
