# swift-firebase-minimal
A minimalistic demo application showcasing integration between Swift and Firebase, featuring Firestore for data storage and Cloud Functions for serverless backend operations. Build in one night to try & debug future Firebase functions.

> [!IMPORTANT]  
> This repo is just for testing and should not considered any kind of production-ready code.

This project demonstrates how to build a simple iOS application with Swift and SwiftUI that connects to Firebase services, specifically:

* Firebase Firestore for real-time data storage
* Firebase Cloud Functions for serverless backend logic

The app implements a basic task management system where users can create, update, and delete tasks, with all changes synchronized to Firestore in real-time. It also demonstrates calling Firebase Cloud Functions from the iOS client.

## Prerequisites

Xcode 15 or later
macOS Ventura or later
Firebase account
Node.js and npm (for Cloud Functions)

## Setup Instructions
### 1. Firebase Setup

1. Create a new Firebase project at [firebase.google.com](https://firebase.google.com)
2. Add an iOS app to your Firebase project
3. Download the `GoogleService-Info.plist` file and add it to your Xcode project
4. Enable Firestore Database in your Firebase project
5. Configure Firestore security rules

### 2. iOS Project Setup

1. Clone this repository
2. Open the project in Xcode
3. Make sure your `GoogleService-Info.plist` file is added to the project
4. Add Firebase packages via Swift Package Manager:
   - URL: `https://github.com/firebase/firebase-ios-sdk.git`
   - Select packages: FirebaseFirestore, FirebaseFunctions
5. Build and run the project

### 3. Cloud Functions Setup

1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```

2. Login to Firebase:
   ```bash
   firebase login
   ```

3. Navigate to the `firebase/functions` directory
4. Install dependencies:
   ```bash
   npm install
   ```

5. Build the TypeScript code:
   ```bash
   npm run build
   ```

6. Deploy the functions:
   ```bash
   firebase deploy --only functions
   ```

## Firebase Cloud Functions

This project includes at this point several example Cloud Functions:

1. **helloWorld**: A callable function that returns a greeting and timestamp
2. **onTaskCreated**: A Firestore trigger that runs when a new task is created
3. **getAllTasks**: An HTTP function that returns all tasks

## Swift Integration

The Swift code demonstrates:

- Initializing Firebase in a SwiftUI app
- Creating a data model for Firestore documents
- Building a ViewModel to handle Firebase operations
- Creating a responsive UI with SwiftUI
- Handling asynchronous Firebase operations

## Firestore Data Structure

Tasks are stored in Firestore with the following structure:

```
/tasks/{taskId}
  - title: string
  - isCompleted: boolean
  - createdAt: timestamp
```

## Security & Production Considerations

Never use Firestore test security rules in production, duh.

## License

This project is licensed under the GPL-3.0 License - see the LICENSE file for details.