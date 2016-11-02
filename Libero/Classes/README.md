# Backend documentation

This document is the documentation for all the backend classes written by John Kotz.

## Classes


### User

The first class is the User. It controls all login and authentication with the server. There a number of functions that you cannot perform without a user object because you must be authenticated. Most of the actual authentication will be dealt with for you, but there are a couple of things you will need to interact with.

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

UNDOCUMENTED: This entry is incomplete! This is probably because John hasn’t yet finalized the syntax for it. Contact him for more info.

#### 