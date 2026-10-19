//
//  AppDelegate.swift
//  QuePersonajeEres
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // La app tiene una sola pantalla, por lo que la ventana se crea por código.
        let ventana = UIWindow(frame: UIScreen.main.bounds)
        ventana.rootViewController = ViewController()
        ventana.makeKeyAndVisible()
        window = ventana
        return true
    }
}
