# NexFlix iOS App

**Submission Instructions:**  
This repository contains the complete NexFlix iOS project for submission.  

- Download the Zip or clone the repository and follow the instructions below.  
- The project implements **MVVM architecture**, **async networking**, **image caching**, and **unit tests** for the ViewModel.  

---

## Screenshots

<img width="300" height="600" alt="Image" src="https://github.com/user-attachments/assets/2187d0a6-fff2-4fe6-a470-9a9e3d0cce8b" />
<img width="300" height="600" alt="DetailsScreen" src="https://github.com/user-attachments/assets/cd0bf574-8c19-4acd-8d06-884a3321ee33" />


> **Note:** Place your screenshots in a `Screenshots` folder inside the repository for GitHub to display them correctly.

---

## 1. Architectural Choices

- **MVVM (Model-View-ViewModel)**:
  - `ViewModel` handles all business logic and networking.
  - `ViewController` handles only UI updates.
  - Enables **unit testing** and separation of concerns.
  
- **Async/Await Networking**:
  - Modern Swift concurrency for clean API calls.
  - Prevents callback hell and simplifies error handling.

- **UICollectionViewCompositionalLayout**:
  - Flexible grid layout with large + small movie tiles.
  - Fully scrollable and dynamic.

- **Diffable Data Source**:
  - Efficient updates with smooth animations.
  - Eliminates manual index and reload logic.

- **Debounced Search**:
  - Reduces unnecessary network calls while typing.
  - Smooth search experience.

---

## 2. 3rd Party Libraries

No third-party libraries are used.  
All functionality is implemented using **UIKit**, **Foundation**, and native Swift.

---

## 3. Image Caching

- `ImageLoader` class uses **NSCache** to cache images.
- Images are loaded asynchronously to **avoid blocking the main thread**.
- Cached images are returned immediately to improve **scroll performance**.
- Example usage:
let image = try await ImageLoader.shared.loadImage(from: url)

4. Error Handling

Networking errors handled in APIClient include:

Invalid URL

HTTP status codes: 401, 404, 500+

Decoding errors

No internet / timeout / cancelled requests

HomeViewModel exposes state via onStateChange closure:

.idle

.loading

.loaded([Movie])

.error(String)

5. Build Instructions
-Download the Zip
-open NexFlix.xcodeproj
-Set your TMDB API Key:(Currently My Key Is Added)
Open APIClient.swift
Replace the apiKey value with your TMDB API Key:
private let apiKey = "YOUR_API_KEY"

6. Run Instructions
Select a Simulator in Xcode (no provisioning profile required).
Press ⌘ + R to build and run.
The app should launch with the Home Screen showing trending movies.
You can scroll and search movies using the search bar.

7. Unit Testing
Unit tests are included in the NexFlixTests target.
Tests cover HomeViewModel logic using a mock service.
Run tests in Xcode with ⌘ + U.

Key scenarios tested:
Initial load success/failure
Pagination when scrolling near the end
Search success/failure

8. Notes
All network calls are async/await and non-blocking.
Image caching ensures smooth scrolling performance.
Proper memory management with [weak self] in closures.
Uses structs and classes appropriately for performance and safety.
Supports light and dark mode automatically.
Designed for clean architecture, scalability, and testability.

