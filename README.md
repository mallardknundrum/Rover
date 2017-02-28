Rover

Please fork and clone this repository

Students will build an app to access the photos of NASA's Mars Rovers. This app will help students practice and solify the following concepts in Objective-C:

Table Views
Collection Views
REST API calls
Caching data
Bridging Objective-C files so they are usable in Swift code.
Please note and be aware that parts of these instructions are intentionally vague as this is Unit 5, and you have accrued a lot of experience thus far. A decent portion of this app is fairly simple, and you have done these things many times (Table Views, model objects, etc.), simply not in Objective-C. Remember the 20 minute rule, and try Googling, looking at Stack Overflow, and use the documentation before you ask a mentor. This is for your own benefit to help you aquire the skills to find solutions independently.

Part One - Model Objects and Mars Rover Client

Models Objects:

You will need three model objects in this project. First, a model representing a Mars rover, second, a photo that a rover took, and third, a description of each sol.

Create a new Cocoa Touch subclass of NSObject for each of these three model objects.

Add properties for the following model objects:

Rover:

Name of the rover
The launch date
Landing date
The max sol that represents the most recent sol that photos exist for the rover
The max date (on Earth) that the photos exist for the rover
The status of the rover. Make an enum ( NS_ENUM ) representing either complete or incomplete. Follow standard naming convention for NS_ENUMs.

Photo:

The photo's identifier
The sol it was taken
The name of the camera that took the photo
The Earth date it was taken
The url to the image

Sol Description:

Which sol it is
The amount of photos taken during the sol
An array of cameras as strings

On the photo model, you will have to add the Objective-C equivalent of the Equatable Protocol using the method isEqual

Think about where we're getting the data from, and create an appropriate initializer for each model object.

Mars Rover Client:

Create a new Cocoa Touch subclass of NSObjectcalled MarsRoverClient with a three letter prefix at the start. This will be where we make the network calls to get the JSON from NASA's API.

MarsRoverClient.h:

In the header file, create four method signatures: 1. fetchAllMarsRoversWithCompletion has a completion block as a parameter that returns an array of rover names, and an error. 2. fetchMissionManifestForRoverNamed takes in a string and has a completion block that returns an instance of your rover model, and an error 3. fetchPhotosFromRover that takes in an instance of your rover model, which sol you want photos for, and a completion block that returns an array of photos, and an error. 4. fetchImageDataForPhoto that takes in an instance of your photo model, and has a completion block that returns imageData ( NSData, not Data )

Look here and here at the sections named 'Blocks As Completion Handlers' for both of them for better understanding of blocks.

MarsRoverClient.m:

Take the time to look through the documentation for the API here. It will be essential that you can navigate and know how to find the information needed from the API in these next steps, again as the instructions are intentionally vague.

Private methods:

In the .m file, add the following private class methods:

Copy and paste this snippet. There is a file called APIKeys.plist that should be in your project if you cloned the repo. This contains the API key for NASA's API, and returns it to you as an instance of NSString.
+ (NSString *)apiKey {
  static NSString *apiKey = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSURL *apiKeysURL = [[NSBundle mainBundle] URLForResource:@"APIKeys" withExtension:@"plist"];
    if (!apiKeysURL) {
      NSLog(@"Error! APIKeys file not found!");
      return;
    }
    NSDictionary *apiKeys = [[NSDictionary alloc] initWithContentsOfURL:apiKeysURL];
    apiKey = apiKeys[@"APIKey"];
  });
  return apiKey;
}
Create a class method called baseURL that returns an instance of NSURL created from the base url of the API.
Create a class method called URLForInfoForRover that takes in a string called 'roverName' and returns an NSURL pointing to the mission manifest of the rover passed in. (hint: It should return an instance of NSURL created using the baseURL and the information passed in to create a more specific url pointing to the information for that mission)
Create a class method called urlForPhotosFromRover that takes in a string called 'roverName' and the sol that you want photos for, then like above, return a new, more specific NSURL pointing to the photos for the given rover and sol.
Make sure that you add the API key as one of the query items in your urls above.

Instance methods:

You will now fill out the methods that you defined in the .h file. The following four methods will all use NSURLSession, and follow the same steps as in Swift to take a URL, get data from it, turn it into JSON, and then turn the JSON into our model objects. Use the class methods we made above to create the URLs necessary. Refer to the NetworkController we've used in Unit 3 projects such as Representatives or Pokedex if needed. Remember to look at what each method should return through the completion block for the end goal of the method.

Part Two: Storyboard and Table View Controllers

Storyboard:

Implement the following view hierarchy in the Storyboard. As you create each scene in the storyboard, create the appropriate Cocoa Touch files for each scene. Follow standard file naming conventions.

The project will have a UITableViewController as its initial View Controller embedded in a UINavigationController, with a basic cell. This will show a list of the Mars Rovers.
From the table view cell, create a show segue that will then display a list of sols that contain photos. The cell style should be able to show which sol it is, and how many photos were taken on that sol.
From the table view cell just created, create a show segue to a UICollectionViewController. The collection view's cell should have an image view that fills the whole cell. Each cell will display a preview of the sol's photos. Remember to create a Cocoa Touch file for the collection view cell as well.
From the collection view cell, create a show segue to a new UIViewController that will display a larger version of the image on the cell that you segued from, along with labels to display which camera the photo was taken with, which sol it was taken on, and the Earth date it was taken on.
If you haven't already, create Cocoa Touch Files for the views and view controllers you just made in the Storyboard.

RoversTableViewController:

Create a private array called rovers that will be the data source for the table view.
Call the appropriate method to fetch the Mars Rovers available to display, and set the rovers array to the returned rovers in the completion handler.
Implement the UITableViewDataSource methods.
Using the prepareForSegue method, pass the appropriate information to the destination view controller. Make sure that the destination view controller has a public property that serves as a placeholder to put the information to.
SolsTableViewController:

Implement the UITableViewDataSource methods. (hint: Use the passed rover's solDescriptions)
Create a custom setter for the public rover property that checks if the rover being passed through the setter is the same as the current rover ( _rover ). If it isn't, then set the current rover to the one passed into the setter, and also reload the tableview. Remember that this setter is where we can do the Objective-C equivalent of a Swift willSet and didSet.
In the prepareForSegue, you should pass two things to the destination view controller; the rover that the SolsTableViewController got from the initial view controller's prepareForSegue, and the sol from the cell that the user just tapped on. (Again, make sure to create public properties on the destination view controller to be placeholders for these two things)
At this point, you should be able to run the app and be able to select a rover from the inital table view controller, and see a list of its sols that have photos on the table view controller that you segue to. Make sure this works before continuing.

Part Three: Collection View Controller, Cache, and Swift PhotoDetailViewController

PhotosCollectionViewController:

You will set up the collection view controller to display thumbnail images of each photo taken on the sol passed into it.

Create two private properties:

An instance of your MarsRoverClient
An array of photo references.
Create a method called fetchPhotoReferences that doesn't return anything, but uses the appropriate MarsRoverClient method to fetch the photo references from the API, and sets the photo references property you just made to the photo references returned from the API. Call this method in the viewDidLoad

If you haven't already, go to your custom collection view cell file, create the necessary outlet. In the implementation of the cell file, call the prepareForReuse function. This will be explained later on, we will come back to it.

The private photo references property will be your data source for the collection view. Implement the required UICollectionViewDataSource methods. For now, just set the cell's imageView's image to the placeholder image in the assets folder.

Implement the prepareForSegue method to pass the photo reference from the cell that the user taps on.

Photo Cache:

Create a new Cocoa Touch file, called PhotoCache (with a prefix) as a subclass of NSObject. We will set up a cache in the device's memory for our photos so we aren't needlessly performing network calls to re-download photos that we've already downloaded from the API. We wil be using a class called NSCache to accomplish this. Take the time to look at the documentation (and elsewhere if you want) to understand how NSCache works before moving on.

In the header file, create the following:
A singleton instance called sharedCache
A method that returns nothing called cacheImageData...forIdentifier that takes in data of type NSData and an identifier as an NSInteger. This will be used to store the image data returned from the api, and store it so that later on, we can access it whenever we want without having to do another network call.
A method called imageDataForIdentifier that takes in an identifier as an NSInteger, and returns NSData. This is the method used to access/fetch the image data in the cache instead of the API.
In the .m file:

Create a private property called 'cache' of type NSCache
Fill out the initializer:

Set the private cache you just created to a new instance of NSCache
Set the cache's name property to @"com.DevMountain.MarsRover.PhotosCache" or something similar to uniquely identify the cache.
The cacheImageData...forIdentifier method should simply call the appropriate method on the private cache property to set the image data in the cache with the identifier as the key. (Remember that NSCache stores data as key-value pairs.)

Similarly, the imageDataForIdentifier method should return the data in the cache, using the identifier as the key.