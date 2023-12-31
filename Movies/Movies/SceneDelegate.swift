//
//  SceneDelegate.swift
//  Movies
//
//  Created by Alejandro Villalobos on 23-11-23.
//

import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    static let container = Container()  // Only static shared container
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        // Guard to ensure the scene is of type UIWindowScene
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        setupDependencyInjection()

        let initialViewController = SceneDelegate.container.resolve(DashboardViewController.self)!
        let navigationController = UINavigationController(rootViewController: initialViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
    
    private func setupDependencyInjection() {
            let container = SceneDelegate.container
        // Existing registrations
        container.register(NetworkManager.self) { _ in NetworkManager.shared() }
        container.register(ConnectivityManager.self) { _ in ConnectivityManager() }
        container.register(DashboardViewModel.self) { r in
            DashboardViewModel(networkManager: r.resolve(NetworkManager.self)!)
        }
        container.register(DashboardViewController.self) { r in
            let controller = DashboardViewController()
            controller.viewModel = r.resolve(DashboardViewModel.self)
            controller.connectivityManager = r.resolve(ConnectivityManager.self)
            return controller
        }

        // Register MovieDetailsViewModelFactory
        container.register(MovieDetailsViewModelFactory.self) { _ in
            DefaultMovieDetailsViewModelFactory()
        }
        
        container.register(FavoritesViewModel.self) { _ in
            FavoritesViewModel()
        }
        container.register(FavoritesViewFactory.self) { _ in
            DefaultFavoritesViewFactory()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

