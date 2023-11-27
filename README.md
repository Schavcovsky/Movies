# Movies

Movies App is a native iOS movile app for movie enthusiasts, offering comprehensive access to a wide range of movies from the TMDB API. It features various categories, detailed movie information, a robust search functionality, and user-centric favorites management. Additionally, its user interface is dynamically designed to adapt to the available content, ensuring an engaging and seamless experience regardless of the data being displayed.

![feature](https://github.com/Schavcovsky/Movies/assets/8847468/e4400c7c-497c-4d82-962f-38d493571523)


## 📝 Features

- **Multiple Movie Categories**: Access movies across categories like Top Rated, Now Playing, Popular, and Upcoming.
- **Search Functionality**: Efficient search capability to find specific movies.
- **Detailed Movie Information**: Explore extensive details such as genres, overviews, release dates, rate counts, average ratings, and popularity.
- **User Reviews**: Gain insights from user reviews for each movie.
- **Favorites List**: Add movies to a personal favorites list for easy retrieval.
- **Rich UI Animations**: Smooth animations for favoriting movies, image transitions, and other UI elements.

## ⚙️ Technical Specifications

- **Languages**: Swift and Objective-C.
- **UI Frameworks**: UIKit and SwiftUI.
- **Architecture**: MVVM pattern.
- **Unit Testing**: Inclusion of unit tests.
- **Network Layer**: Developed in Objective-C, requiring a bearer token from Firebase AppConfig.
- **Dependency Injection**: Implemented using Swinject for enhanced modularity.
- **Pagination**: Supports browsing through movie lists with pagination.
- **Persistence**: Facilitates favoriting movies with an ordered persistence mechanism.
- **Network Monitoring**: Includes a network monitor for alerting and handling connectivity issues.
- **Image Management**: Utilizes Kingfisher for image downloading and caching.
- **Dependency Management**: Managed through CocoaPods and Swift Package Manager.
- **Dark Mode Ready**: Supports Dark Mode and Light Moide for optimal viewing comfort and accessibility.

## 🤲🏻 Improvement Opportunities

While the app is fully functional and robust, there are areas for improvement:
- **Code Refactoring**: Continuous refactoring for improved code efficiency and maintainability.
- **Expanded Test Coverage**: Enhancing the scope of unit and integration tests.

## 💻 Getting Started

To set up the app:
1. Clone the repository.
2. Open the project in Xcode.
3. Run `pod install` to install necessary CocoaPod dependencies.
4. Build and run the app in your preferred simulator or device.

## ⚠️ Disclaimer
**Please note that on the initial launch, retrieving the bearer token from Firebase RemoteConfig may take some time. Please be patient, there's no need to close the app. Once the token is successfully acquired, the movies will automatically load, and the initial alert message can be dismissed.**

## 📄 License
This work is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License.
For more details, see [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/).
