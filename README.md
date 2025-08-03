# Playermaker iOS Developer Home Assignment

# Developer: [Vladimir Tribushevsky](https://www.linkedin.com/in/vladimir-tribushevsky/)

## Architecture: MVVM + Navigator + Dependency Injection 

Module Structure:

- VIEW: Layout representation
- VIEW_MODEL: Business Logic of the Module
- NAVIGATOR: Handles routing to the next screens and sends output signals to previous modules
- USECASE: Acts as a proxy between the VIEW_MODEL and services (e.g., Storage, Bluetooth, etc.) 
- DEPENDENCY: Stores service dependencies for the module (e.g., Storage, Bluetooth, etc.)
- DEPENDENCY INJECTION: Constructs modules by setting up dependencies between module components and preparing services for the module

   ........... rx ...............
   .							.
   .							.
   \/							.
  VIEW ..... strong .....> VIEW_MODEL .....> strong .....> USE_CASE ..... strong ..... > DEPENDENCY
   /\						.	/\
   .						.	.
   .						.	.
   .				strong	.	. rx
   .						.	.
   .						.	.
   .						\/	.
   ......... weak .........NAVIGATOR

## Dependencies

- CocoaPors: Dependency Manager
- RealmSwift: Local Storage DB
- RxSwift, RxCocoa, RxRealm, RxDataSources: Implementation of the Reactive Paradigm in Swift
- SnapKit: Autolayout UI in code
- Swinject: Dependency Injection
- SwiftGen: Automaticaly generate Code for resources(images, colors, fonts, localizations)

## How to run

1. Clone the git repository: https://github.com/tribushevsky/playermaker.git
2. Navigate to the cloned repository folder:
3. Run Dependency Install command:
```yaml
pod install 
``` 
4. After successfull pods installation open the PlayermakerTrybusheusky.xcworkspace file:
```yaml
open PlayermakerTrybusheusky.xcworkspace
```
5. Navigate to the PlayermakerTrybusheusky Target -> Change Team -> Change Bundle Identifier by adding any character
5. Run on the real device

## Assumptions

- The UUID of each device is unique and used as its primary identifier;
- The device's name field is stored as an optional type and is displayed as "Unknown Name" in the UI layer;
- Error handling is implemented by dividing errors into four categories: 
	1. Major: Errors that occur due to issues that block core features of the entire application. An error dialog is shown with an option to redirect to the Settings app;
	2. Normal: Errors that occur due to issues that block further interaction on the current screen. An error message is displayed, and the screen is closed along with an alert; 
	3. Minor: Errors that occur due to issues that may be resolved by retrying the same action. An error message is displayed and can be dismissed by user action;
	4. Super Minor: Errors that can be safely ignored without notifying the user.

## Bonus features

- Dark/Light mode is applied based on the device's system settings;
- Sorting feature is available on the Favorites List screen;
- Localization is supported for three languages: English, Russian, and Belarusian. The language changes automatically according to the device's language settings;
- Code generation for resources (images, colors, fonts, and localizations). Improves development efficiency and ensures type safety, eliminating resource-related compilation errors in production.
- Custom AppIcon:)
