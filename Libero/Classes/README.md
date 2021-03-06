# Backend documentation

This document is the documentation for all the backend classes written by John Kotz.

## User

The first class is the User. It controls all login and authentication with the server. There a number of functions that you cannot perform without a user object because you must be authenticated. Most of the actual authentication will be dealt with for you, but there are a couple of things you will need to interact with.

### Properties

- emailVerified: Bool
	- True if the email has been verified
- completedSetup: Bool
	- True if the user has completed setup
- firstName: String
	- The first name of the user
- lastName: String
	- The last name of the user
- league: League?
	- The league the user is in. Can be nil if the user hasn’t been placed
- picture: User.ProfilePic?
	- The profile picture for the user. Use pictureURL to get the picture
- activeWorkout: Workout?
	- The active workout if there is one
- pictureURL: String?
	- The URL to the image the user has for their profile
- pastWorkouts: [Workout]?
	- A list of workouts that have been completed by this user, if loaded
- achievements: [Achievement]?
	- A list of achievements the user has completed, if loaded
- friends: [User]?
	- A list of users the user has friended, if loaded

### Authentication functions:

#### login

The login function will log the device in using the given credentials

Usage:

```swift
let username = “username”
let password = “password”

User.login(withUsername: username, andPassword: password) { (user, error) in 
	if let user = user {
		// You logged in!
	}else if let error = error {
		// Failed to login!
	}else{
		// Bad input
	}
}
```

Arguments:

- username: String
	- The username for the user
- password: String
	- The password for the user
- block: Function(User?, [BackendError](#backenderror)?)
	- The function you pass here will be called when the process is done. The arguments are an optional user and an optional error. The user object will be non-nil when you have successfully logged in, and can be used like any user object.
	- If the user is nil then it failed to login, and the [BackendError](#backenderror) will be able to describe that better

#### loginWithFacebook

The loginWithFacebook function will open the Facebook login system in Safari when called. When the user is done logging in, the app will automatically reopen. The block will execute on completion of the login process

Usage:

```swift
User.loginWithFacebook() { (user, error) in 
	if let user = user {
		// You logged in!
	}else{
		let error = error!
		// Failed to login!
	}
}
```

Arguments:

- block: Function(User?, [BackendError](#backenderror)?)
	- The function you pass here will be called when the process is done. The user object will be non-nil if login was successful. If it is not, error will non-nil and will explain it.


#### signUp

The function signUp will create a user using the given credentials.

Usage:

```swift
let username = “username”
let password = “password”

User.signUp(withUsername: username, andPassword: password) { (user, error) in
	if let user = user {
		// You signed up!
	}else{
		let error = error!
		// Encountered an error. Examine error to understand the problem
	}
}
```

Arguments:

- username: String
	- The username for the user
- password: String
	- The password for the user
- block: Function(User?, [BackendError](#backenderror)?)
	- This function will be called when it is done in the same way as the other two login functions


#### requestPasswordReset

The function requestPasswordReset will request from the server that the given email be sent a password reset form.

Usage:

```swift
User.requestPasswordReset(forEmail: “example@gmail.com”) { (error) in 
	if error != nil {
		// Failed
	} else {
		// Succeeded
	}
}
```

Arguments:

- email: String
	- The email for the user
- block: Function([BackendError](#backenderror).User.PasswordReset?)
	- Called when done

#### logout

The function logout will log the user out from the device

Usage:

```swift
User.logout() { () in 
	
}
```

Arguments:

- block: Function(NSError?) (PFUserLogoutResultBlock)
	- Called when the logout is complete

#### isLoggedIn

Returns Boolean that is true when there is a user

#### isValidEmail

Returns Boolean that is true when the email given is a valid email

Usage:

```swift
let email = “some@email.com”

if User.isValidEmail(email) {
	// It’s valid
}
```

Arguments:

- email: String
	- The email you want to check

#### finishSignUp

This function will deal with the survey results and complete the signup process! This one is a bit more complicated because it uses the User.SurveyResponse object

Usage:

See [SurveyResponse](#surveyresponse-class) for more on initializing

```swift
let response = User.SurveyResponse()

// When you are done:
guard let user = User.current() else {
	return
}
user.finishSignUp(response) { (error) in 
	if let error = error {
		// Something went wrong!	
	}else{
		// All's fine!	
	}
}
```

Arguments:

- response: [User.SurveyResponse](#surveyresponse-class) (link unconnected until documentation is written)
	- The response object you generated
- block: Function([BackendError](#backenderror)?)
	- The callback function for completion. If the error object is non-nil there was an error!

### Other User Functions

#### addWorkout

Adds the given workout to the user. If the workout is marked as active it will save the workout as the active workout (in the activeWorkout value).

Usage:

```swift
// user is a User object, and workout a Workout object
user.addWorkout(workout)
```

Arguments:

- workout: [Workout](#workout)
	- The workout that you want added

#### initialize

Pulls all extraneous data from the server and saves it locally.

### SurveyResponse class

Properties:

- frequency: Frequency!
- intensity: Intensity!
- firstName: String
- lastName: String

Frequency: This is an enum on Ints that describes values as follows:

	LessThanOnce = 0
	Once = 1
	TwoThree = 2
	FourPlus = 3

Intensity: This is an enum on Ints that describes values as follows:

	Beginner = 0
	Intermediate = 1
	Advanced = 2
	Enthusiast = 3

Usage:

```swift
let response = User.SurveyResponse() 
response.firstName = "John"
response.lastName = "Kotz"
response.frequency = .LessThanOnce
// Or you could do this:
response.frequncy = User.SurveyResponse.Frequency(rawValue: 0)
// Those two are identical in effect

response.intensity = .Intermediate
// Same here
response.intensity = User.SurveyResponse.Frequency(rawValue: 1)
```












## Leaderboard

The Leaderboard class is a static class that will perform queries for leaderboards. In order to do this you will need to create a query object, set the parts you want to search on, and then complete the query. Each bit you add to a query will compound the query, so for example a query without anything set will get the global leaderboard.

Usage:

```swift
let query = Leaderboard.Query()
query.activity = .walk
query.league = // some league

query.complete { (users, error) in 
	if let users = users {
		// Succeeded!
	}else{
		// Encountered an error!
	}
}
```

Properties:

- activity: [Workout](#workout).[Name](#name)?
	- An optional name for an activity. Will make the query order by number of that type of workout
- league: [League](#league)?
	- An optional league to search in. Will make the resulting leaderboard be the leaderboard for that league


## Workout
A class to control all Workout backend and local functionality

Properties:

- start: NSDate
- duration: Float
	- In minutes
- isActive: Bool
- locationData: [(CLLocation, NSDate)]
	- If there has been any location data recorded, it will be here
- end: NSDate?
- data: [Subdata](#subdata-class)?
	- This is all the data having to do with the different kinds of activity. For now there is only one subclass: Distance, which contains distance and speed values.
- typeInfo: (type: [Type](#type-enum), name: [Name](#name-enum))
	- This variable will help identify the workout type, like between distance and other things, and between a run, walk, swim, bike, or unknown

### Functions
#### addToUser

Adds the workout to the user using the User.addWorkout function

Arguments:

- user: User

#### startLocationTracking

Begins to track the phone using GPS and will save all the location data.

#### stopLocationTracking

Stops location tracking

#### getDuration
Gets the amount of time between the start and end dates. If the workout is active it will be between start and the current date. If neither start or end is set, the interval will be 0.

Returns: TimeInterval (a double in seconds)

#### startWorkout
Begins the workout. This will make the workout active (meaning that the isActive property will be true), and set the start date.

#### endWorkout
Ends the workout. This will solidify the ending of the workout to being the time it was called.

#### startTimer
The Workout class will deal with the timer for interface timers. Call this function with a block and that block will be called every 0.01 seconds, or 1 millisecond.

__NOTE__: This doesn’t start the workout

Usage:

```swift
workout.startTimer { (interval) in 
	// Interval is the time between start and stop
}
```

Arguments:

- block: Function(TimeInterval)
	- The function that will be called each 0.01 seconds with the current time interval

#### stopTimer
Stops the Workout timer

__NOTE__: This doesn’t end the workout

### Classes and enums
#### Type Enum
This is just an easy way to notate what type of activity it is. Possible values are shown below. The enum is based on String, so the raw value for each will be the same as the name.

	distance
	unknown
#### Name Enum
This is just an easy way to notate what more specific of activity it is. This one will distinguish between things like running, walking, and so on. Possible values are shown below. The enum is based on String, so the raw value for each will be the same as the name.

	run
	walk
	swim
	bike
	unknown
#### Difficulty Enum
Another easy type for the difficult

	easy
	medium
	hard
	unknown
#### Subdata Class
A class to simply provide templates for the different types of activities. Since for now we only have distance type activities there is only one subclass: [Distance](#subdatadistance).

Properties:

- activity: [Workout.Name](#name-enum)

#### Subdata.Distance

Properties:

- distance: Double
- speed: Double





## League

### Properties:

- name: String
	- The name of the League
- members: [User]?
	- A list of users in the League. Will be nil if the data hasn’t been loaded yet

### Functions

#### initialize
Initializes the league object. This includes loading all the members in the league






## Achievement
This class hasn’t been expanded on much, and we don’t event have the code yet for calculating these achievements

### Properties:

- name: String

### Classes and enums

#### TypeEnum
An enumeration to keep track of what stage (aka type) of achievement this is:

	first
	second
	third
	fourth
	unknown

### Functions

#### init

Initializes the object. There are two overloads:

##### 1:
Usage:

```swift
Achievement()
```

##### 2:
Usage:

```swift
Achievement(“10 miles run”, .first)
```

Arguments:

- name: String
	- The name of the achievement
- type: [Achievement.TypeEnum](#typeenum)
	- An enumeration that defines type. This will define the type of image that will be used for the acheivement




## Other
### BackendError

I haven’t had time to write a thorough documentation for this class, but I have included the code that initializes plus a number of clarifying comments

```swift
class BackendError: Error, CustomStringConvertible {
    
    // This is a messy way to make an enumeration, but this way I get to make subclasses of the error
    class User: BackendError {
        // Some of the overall errors
        static let UnknownUserError = User("unknown_user_error")
        
        // Errors occured when signing up
        class SignUp: BackendError.User {
            static let UsernameExists: SignUp = SignUp("username_exists")
            static let InvalidUsername: SignUp = SignUp("invalid_username")
            
            override init(_ val: String) {
                // The ending value will be "Backend Error: user-signup-\(val)"
                super.init("signup-\(val)")
            }
        }
        
        // Errors occured when logging in
        class Login: BackendError.User {
            static let UnknownLogin = Login("unknown_login")
            static let UnknownLoginError = Login("unknown_error")
            
            override init(_ val: String) {
                // The ending value will be "Backend Error: user-login-\(val)"
                super.init("login-\(val)")
            }
        }
        
        // Errors occured when resetting password
        class PasswordReset: BackendError.User {
            static let UnknownPasswordResetError = PasswordReset("unknown_error (we should figure out what the error codes are)")
            
            override init(_ val: String) {
                super.init("passwdReset-\(val)")
            }
        }
        
        // This will give a printable value to the error
        override init(_ val: String) {
            // This will make a list of types in the value
            super.init("user-\(val)")
        }
    }
    class ServerError: BackendError {
        static let CloudCodeFailed = User("cloud_code_failed")
        
        override init(_ val: String) {
            // The ending value will be "Backend Error: signup-\(val)"
            super.init("signup-\(val)")
        }
    }
    static let FailedToConnect: BackendError = BackendError("failed_to_connect")
    static let FailedToSave: BackendError = BackendError("failed_to_save")
    static let DataDoesntExist: BackendError = BackendError("data_doesnt_exist")
    static let UnknownError: BackendError = BackendError("unknown_error")
    
    let raw_value: String
    init(_ val: String) {
        self.raw_value = val
    }
    
    var description: String {
        return "Backend Error: \(raw_value)"
    }
}
```