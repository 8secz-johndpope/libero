# Backend documentation

This document is the documentation for all the backend classes written by John Kotz.

## Classes


### User

The first class is the User. It controls all login and authentication with the server. There a number of functions that you cannot perform without a user object because you must be authenticated. Most of the actual authentication will be dealt with for you, but there are a couple of things you will need to interact with.

#### Properties

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

#### Authentication functions:

##### login

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
- block: Function(User?, BackendError?)
	- The function you pass here will be called when the process is done. The arguments are an optional user and an optional error. The user object will be non-nil when you have successfully logged in, and can be used like any user object.
	- If the user is nil then it failed to login, and the BackendError will be able to describe that better

##### loginWithFacebook

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

- block: Function(User?, BackendError?)
	- The function you pass here will be called when the process is done. The user object will be non-nil if login was successful. If it is not, error will non-nil and will explain it.


##### signUp

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
- block: Function(User?, BackendError?)
	- This function will be called when it is done in the same way as the other two login functions


##### requestPasswordReset

The function requestPasswordReset will request from the server that the given email be sent a password reset form.

_UNDOCUMENTED_: This entry is incomplete! This is probably because John hasn’t yet finalized the syntax for it. Contact him for more info.

##### logout

The function logout will log the user out from the device

Usage:

```swift
User.logout { () in 
	
}
```

_UNDOCUMENTED_: This entry is incomplete! This is probably because John hasn’t yet finalized the syntax for it. Contact him for more info.

##### isLoggedIn

Returns Boolean that is true when there is a user

##### isValidEmail

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

##### finishSignUp

This function will deal with the survey results and complete the signup process! This one is a bit more complicated because it uses the User.SurveyResponse object

Usage:

See [SurveyResponse](#head1234) for more on initializing

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

- response: [User.SurveyResponse](#head1234) (link unconnected until documentation is written)
	- The response object you generated
- block: Function([BackendError](http://example.com "Title")?)
	- The callback function for completion. If the error object is non-nil there was an error!

#### Other User Functions

##### addWorkout

Adds the given workout to the user. If the workout is marked as active it will save the workout as the active workout (in the activeWorkout value).

Usage:

```swift
// user is a User object, and workout a Workout object
user.addWorkout(workout)
```

Arguments:

- workout: Workout
	- The workout that you want added

##### initialize

Pulls all extraneous data from the server and saves it locally.

#### <a name=“head1234”></a>SurveyResponse class

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