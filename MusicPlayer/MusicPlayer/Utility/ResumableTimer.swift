//
//  ResumableTimer.swift
//  MusicPlayer
//
//  Created by hyosung on 2023/02/04.
//

import UIKit

protocol ResumableTimerable {
  init(interval: Double, repeats: Bool, callback: @escaping (Timer) -> Void)
  
  func isPaused() -> Bool
  func start()
  func pause()
  func resume()
  func invalidate()
  func reset()
}

final class ResumableTimer: NSObject, ResumableTimerable {
  
  private var timer: Timer? = Timer()
  
  private var interval: Double = 0.0
  private var repeats: Bool = false
  private var callback: (Timer) -> Void
  
  private var startTime: TimeInterval?
  private var elapsedTime: TimeInterval?
  
  // MARK: Init
  init(
    interval: Double,
    repeats: Bool,
    callback: @escaping (Timer) -> Void
  ) {
    self.repeats = repeats
    self.callback = callback
    self.interval = interval
  }
  
  func isPaused() -> Bool {
    guard let timer = timer else { return false }
    return !timer.isValid
  }
  
  func start() {
    runTimer(interval: interval)
  }
  
  func pause() {
    elapsedTime = Date.timeIntervalSinceReferenceDate - (startTime ?? 0.0)
    timer?.invalidate()
  }
  
  func resume() {
    interval -= elapsedTime ?? 0.0
    runTimer(interval: interval)
  }
  
  func invalidate() {
    timer?.invalidate()
  }
  
  func reset() {
    startTime = Date.timeIntervalSinceReferenceDate
    runTimer(interval: interval)
  }
  
  // MARK: Private
  private func runTimer(interval: Double) {
    startTime = Date.timeIntervalSinceReferenceDate
    
    timer = Timer.scheduledTimer(
      withTimeInterval: interval,
      repeats: repeats
    ) { [weak self] timer in
      self?.callback(timer)
    }
  }
}
