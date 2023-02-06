//
//  ViewController.swift
//  MusicPlayer
//
//  Created by hyosung on 2023/01/26.
//

import UIKit

final class ViewController: UIViewController {
  
  struct Dependency {
    let playerViewController: UIViewController
    let audioServicable: AudioServicable
  }
  
  private let dependency: Dependency
  private var timer: ResumableTimerable?
  
  init(dependency: Dependency) {
    self.dependency = dependency
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    setupConstraints()
    setDelegates()
  }
}
extension ViewController {
  private func setDelegates() {
    dependency.audioServicable.setDelegate(self)
    if let playerViewController = dependency.playerViewController as? PlayerViewController {
      playerViewController.setDelegate(self)
    }
  }
}

extension ViewController {
  private func configureUI() {
    addChild(dependency.playerViewController)
    
    view.addSubviews(
      dependency.playerViewController.view
    )
  }
}

extension ViewController {
  private func setupConstraints() {
    [
      dependency.playerViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      dependency.playerViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      dependency.playerViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor)
    ].forEach { $0.isActive = true }
  }
}

extension ViewController {
  private func updatePlayButton(_ viewController: UIViewController, isSelected: Bool) {
    if let playerViewController = viewController as? PlayerViewController {
      playerViewController.updatePlayButton(isSelected)
    }
  }
  
  private func updateTimerLabel(_ viewController: UIViewController, time: String) {
    if let playerViewController = viewController as? PlayerViewController {
      playerViewController.updateTimerLabel(time)
    }
  }
  
  private func updateTimerSlider(_ viewController: UIViewController, time: Float) {
    if let playerViewController = viewController as? PlayerViewController {
      playerViewController.updateSlider(time)
    }
  }
  
  func updateTimer(time: TimeInterval?) -> String {
    guard let time = time else { return "00:00:00" }
    let minute: Int = Int(time / 60)
    let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
    let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
    
    let timeText: String = String(format: "%02ld:%02ld:%02ld", minute, second, milisecond)
    return timeText
  }
  
  private func makeTimer() {
    if timer == nil {
      self.timer = ResumableTimer(
        interval: 0.01,
        repeats: true,
        callback: { [weak self] _ in
          guard let self = self else { return }
          let stringTime = self.updateTimer(time: self.dependency.audioServicable.player?.currentTime)
          let floatTime = Float(self.dependency.audioServicable.player?.currentTime ?? 0)
          self.updateTimerLabel(self.dependency.playerViewController, time: stringTime)
          self.updateTimerSlider(self.dependency.playerViewController, time: floatTime)
        }
      )
    }
  }
  
  private func startTimer() {
    guard let timer = timer else { return }
    if timer.isPaused() {
      timer.resume()
    } else {
      timer.start()
    }
  }
  
  private func setSlider(_ viewController: UIViewController, maximumValue: Float, minimumValue: Float) {
    if let playerViewController = viewController as? PlayerViewController {
      playerViewController.setSlider(maximumValue: maximumValue, minimumValue: minimumValue)
    }
  }
  
  private func startPlayer() {
    makeTimer()
    startTimer()
    setSlider(
      dependency.playerViewController,
      maximumValue: Float(dependency.audioServicable.player?.duration ?? 0.0),
      minimumValue: 0.0
    )
  }
}

// MARK: - AudioServiceDelegate
extension ViewController: AudioServiceDelegate {
  func audioPlayerDidPlaying() {
    updatePlayButton(
      dependency.playerViewController,
      isSelected: true
    )
    
    startPlayer()
  }
  
  func audioPlayerDidPausePlaying() {
    updatePlayButton(
      dependency.playerViewController,
      isSelected: false
    )
    
    timer?.pause()
  }
  
  func audioPlayerDidFinishPlaying(successfully flag: Bool) {
    updatePlayButton(
      dependency.playerViewController,
      isSelected: false
    )
    
    timer?.invalidate()
  }
  
  func audioPlayerDecodeErrorDidOccur(error: Error?) {
    updatePlayButton(
      dependency.playerViewController,
      isSelected: false
    )
    
    timer?.invalidate()
  }
}

// MARK: - PlayerViewControllerDelegate
extension ViewController: PlayerViewControllerDelegate {
  func didTapPlayButton(_ sender: UIButton) {
    !sender.isSelected ? dependency.audioServicable.play(.init(name: "sound")) : dependency.audioServicable.pause()
  }
}
