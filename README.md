
# RedDragon Project 

## *Project Overview*

#### _The "RedDragon" project is built using MVVM architecture and utilizes Swift 5 as the programming language. It is developed in Xcode 15. This README provides an overview of the project structure and key components._



Project Structure

_Localization_
The project supports localization for both English and Chinese.



_Resource Folder_
Under the Resource folder, you'll find various subfolders that contain reusable common files:

_Fonts_: Contains custom fonts used in the project.
_Constants_: Stores constants and configuration settings.
_Animations_: Holds animation-related resources.
_Extensions_: Contains Swift extensions to enhance functionality.
_Utilities_: Includes utility functions and helpers for general use.



_Network Folder_
Under the Network folder, you'll find reusable Swift files related to networking:

Custom Errors: Defines custom error handling for the project.

Network Reachability: Provides network reachability checks.

Request Type: Enumerates different HTTP request types (e.g., GET, POST).

URL Constants: Stores URL constants for network requests.

HTTPSClient: Handles network communication over HTTPS.

HTTPHeaderFile: Manages HTTP headers for requests.

Common Service Manager: Contains a reusable Swift file, APIServiceManager, that handles all network calls in the project.

AppModules Folder
In the AppModules folder, the project's modules are organized separately. Each module has its own folder. Here are some of the modules:

Common: Contains reusable CollectionViewCells and a Splash screen responsible for handling the app's entrance flow.

Database Module: This module includes the following components:

Database Storyboard: The user interface components for the database module.

Model for LeagueDetailModel: The data model for league details.

View: Contains LeagueCollectionViewCell, StandingsTableViewCell, and SeasonPerformanceTableViewCell for displaying data in the database module.

ViewModel: Contains DatabaseViewModel, which handles API calls for league data.

The DatabaseVC controller manages the view of this module. It loads data for different leagues and provides options to switch between standings and events.
