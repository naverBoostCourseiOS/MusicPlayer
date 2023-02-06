//
//  SceneDelegate.swift
//  MusicPlayer
//
//  Created by hyosung on 2023/01/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    let playerViewController: UIViewController = {
      let viewController = PlayerViewController()
      viewController.view.translatesAutoresizingMaskIntoConstraints = false
      return viewController
    }()
    
    let audioService: AudioServicable = AudioService()
    let viewController = ViewController(
      dependency: .init(
        playerViewController: playerViewController,
        audioServicable: audioService
      )
    )
    
    self.window = makeWindow(scene: scene)
    
    configure(
      window: window,
      rootViewController: viewController
    )
  }
}

// MARK: - Private Function
extension SceneDelegate {
  private func makeWindow(scene: UIScene) -> UIWindow? {
    guard let windowScene = (scene as? UIWindowScene) else { return nil }
    return UIWindow(windowScene: windowScene)
  }
  
  private func configure(
    window: UIWindow?,
    rootViewController: UIViewController
  ) {
    guard let window = window else { return }
    window.backgroundColor = .white
    window.overrideUserInterfaceStyle = .light
    window.rootViewController = rootViewController
    window.makeKeyAndVisible()
  }
}

