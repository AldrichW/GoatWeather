# GOAT Weather App

## Overview

GOAT Weather is a simple app that displays the daily weather forecast for a user's current location in a simple, digestible feed.
So sneakerheads are always aware of the weather and can plan ahead before rocking their heat.

The feed displays the following information:
*  weather icon image for that day
*  The date and day of week
*  The high and low temperature

### Functionality

The user can see/do the following:
  * see a custom splash screen when launching the app
  * see a right navigation bar item to grant user location permissions
  * see the 7-day forecast for their location
  * pull to refresh the feed
  * see an error view in case of network errors
  * see an empty state view when backend returns an empty list or user hasn't granted permissions
  * tap "Try again" to reload the feed when they encounter an error

Please see the corresponsing screenshots and demos in the `/demo_screenshots` folder from the root directory


## Running the app
GOAT Weather app was developed using the following configuration:
  * Xcode 12
  * iOS14 runtime, min iOS10 required
  * Swift 5
  * Cocoapods dependency manager

**To run the app on a local simulator:**
1. From the root of the app directory, open `GoatWeather.xcworkspace` using Xcode
2. Build and Run the app using `Cmd + R`

## Testing the app
1. With the project opened on Xcode, Tap on Product tab > Test or use `Cmd + U`

## Third Party Libraries

The following third party libraries and frameworks were used to help develop GOAT Weather:
  * SnapKit - Snapkit offers an easy to use API for setting autolayout constraints for views. I find the default API apple provides confusing and hard to read
  * Cocoapods - I needed to use cocoapods in order to easily integrate Snapkit into my project
  * URLProtocolMock - I got inspiration from an exteral blog to mock the URLProtocol in order to accurately test the network layer. I'm not too familiar with unit testing network layer code, so I did a bit of research for this part.

## Architecture

When designing the architecture for this app, I focused on the following guiding principles:

  * Clear data flow - making sure that data flows in the direction of service layer -> model -> view model -> view, while invocations and interactions are clearly communicated from the view controller to the service layer.
  * Flexible and extendable components - Since we'll be building on it in future interviews, I wanted to ensure that features can be easily added
  * Easy to test - Decoupling components to make business logic easy to test by injecting mocks
  * UX flows coverage - I focused on the user not getting stuck in any flow (cold start, returning user, error case, empty case), so I made sure the app always had a call to action and we don't introduce complicated stateful experiences since they tend to be fragile 

### Design Pattern - MVVM vs VIPER/RIBs

I decided to go with an **MVVM Design pattern**, as a good balance of keeping components separate while not introducing too much overhead and boilerplate code. I see myself and a few other developers working on this problem with me (me + interviewers). To keep dependencies modular and decoupled, I wrap most of my classes with a protocol and pass the protocol to the class constructors.

Alternatives considered - VIPER/RIBs, MVC

**MVVM pros:**
* separation of concerns, better than MVC
* view model handles a lot of the buisness logic and shileds the view from having to know about how the responses are parsed. We keep the client simple and unaware of how the business works
* The view controller only retains the view model, and modifies the view based on updates from the view model
* not too complicated to understand the architecture, keeps things fairly flat
* Althought the individual components are separated, not too much overhead in terms of boilerplate code compared to VIPER/RIBs

**MVVM cons:**
* If developer scale shoots up (50+ devs), it makes it hard for multiple devs to work on MVVM due to merge conflicts
* Still runs the risk of view models being bloated and tangled with too much business logic and custom transformation code
* Depending on how you set it up, this approach maybe hard to unit test at a granular level, if dependencies are created within the view model

**VIPER pros:**
* With clean architecture, we truly get separation of concerns where view, interactor, presenter, and router are all doing specific things
* Code becomes more modular and easy to adapt new features or swap out logic
* Separate components become easier to unit test as all dependencies can get passed into the constructor as mocks
* Easy to collaborate with numerous devs as components are separate and less likely to hit version control conflicts

**VIPER cons:**
* A lot of overhead and boilerplate code since we have to create prototypes and classes for every single component
* Certain classes such as the router and presenter have little to no logic for simple apps
* Simple changes can become frustrating and painful due to the boilerplate code and data passing
* Steeper learning curve for devs to understand how the architecture is laid out or how to create a new feature using VIPER

### Storyboard vs Programmatic UI

I decided to remove the storyboard and implement my views programmatically  with the exception of the custom cell class `StockTickerItemCell` which is a Xib. I decided keep the cell a xib since it was quick to prototype, easy to visualize, and easy talk through with interviewers or other collaborators.

**Storyboard/Nib pros:**
* Easy to visualize
* Quick to prototype a working app while adding constraints and properties
* Drag and drop functionality is intuitive

**Storyboard/Nib cons:**
* Version control doesn't play well with storyboards as the diffs end up pretty cryptic
* Hard to collaborate with other engineers due to merge conflicts and cryptic diffs
* Doesn't scale well as the app navigation structure becomes more complex
* Takes up a lot of computing resources when running, especially as the app grows larger

**Programmatic UI pros:**
* easy to read and put under version control
* full customizability of the UI and other developers can understand the changes
* Not dependent on interface builder and having to adapt to new updates from Apple

**Programmatic UI cons:**
* not as fast to prototype single-view apps
* a bit of a learning curve to understand autolayout constraints API
* Hard to visualize the view hiearchy and layout without running the app.


### Service Layer Router and Model nullability

I wanted to be mindful of adding new endpoints or modifying existing endpoints from backend so I implemented the `CashStockServiceRouter` to easily generate new URLs based on different path components. I also made all my `codable` models nullable to keep clients compatible with backend changes and to not break runtime if backend ever decideds to pass `nil` back to the client.

