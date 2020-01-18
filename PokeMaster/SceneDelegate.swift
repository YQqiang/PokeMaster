//
//  SceneDelegate.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/17.
//  Copyright © 2019 sungrow. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private func showMainTab(scene: UIScene, with store: Store) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: MainTab().environmentObject(store))
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    private func createStore(_ URLContexts: Set<UIOpenURLContext>) -> Store {
        let store = Store()
        guard let url = URLContexts.first?.url,
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return store
        }
        
        switch (components.scheme, components.host) {
        case ("pokemaster", "showPanel"):
            guard let idQuery = (components.queryItems?.first {
                $0.name == "id"
                }),
                let idString = idQuery.value,
                let id = Int(idString),
                id >= 1 && id <= 30
            else {
                break
            }
            store.appState.pokemonList.selectionState = .init(expandingIndex: id, panelIndex: id, panelPresented: true)
        default:
            break
        }
        return store
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Get the managed object context from the shared persistent container.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        let contentView = ContentView().environment(\.managedObjectContext, context)

        // Use a UIHostingController as window root view controller.
        let store = createStore(connectionOptions.urlContexts)
        showMainTab(scene: scene, with: store)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let store = createStore(URLContexts)
        showMainTab(scene: scene, with: store)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

