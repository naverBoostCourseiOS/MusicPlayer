//
//  PlayerViewController.swift
//  MusicPlayer
//
//  Created by hyosung on 2023/02/04.
//

import UIKit

protocol PlayerViewControllerDelegate {
  func didTapPlayButton(_ sender: UIButton) 
}

final class PlayerViewController: UIViewController {
  
  private lazy var playButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(
      UIImage(named: "button_play"),
      for: .normal
    )
    button.setImage(
      UIImage(named: "button_pause"),
      for: .selected
    )
    button.addTarget(
      self,
      action: #selector(didTapPlayButton),
      for: .touchUpInside
    )
    return button
  }()
  
  private let timerLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.textColor = .black
    label.text = "00:00"
    return label
  }()
  
  private let timeSlider: UISlider = {
    let slider = UISlider()
    slider.translatesAutoresizingMaskIntoConstraints = false
    return slider
  }()
  
  var delegate: PlayerViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    setupConstraints()
  }
  
  @objc private func didTapPlayButton(_ sender: UIButton) {
    delegate?.didTapPlayButton(sender)
  }
}

extension PlayerViewController {
  private func configureUI() {
    view.addSubviews(
      playButton,
      timerLabel,
      timeSlider
    )
  }
}

extension PlayerViewController {
  private func setupConstraints() {
    [
      playButton.topAnchor.constraint(equalTo: view.topAnchor),
      playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      playButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)
    ].forEach { $0.isActive = true }
    
    [
      timerLabel.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 50),
      timerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      timerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      timerLabel.heightAnchor.constraint(equalToConstant: 50)
    ].forEach { $0.isActive = true }
    
    [
      timeSlider.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20),
      timeSlider.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      timeSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      timeSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      timeSlider.heightAnchor.constraint(equalToConstant: 50)
    ].forEach { $0.isActive = true }
  }
}

extension PlayerViewController {
  public func setDelegate(_ self: PlayerViewControllerDelegate) {
    delegate = self
  }
  
  public func setSlider(maximumValue: Float, minimumValue: Float) {
    timeSlider.maximumValue = maximumValue
    timeSlider.minimumValue = minimumValue
    timeSlider.value = 0.0
  }
  
  public func updatePlayButton(_ isSelected: Bool) {
    playButton.isSelected = isSelected
  }
  
  public func updateTimerLabel(_ text: String?) {
    timerLabel.text = text
  }
  
  public func updateSlider(_ value: Float) {
    timeSlider.setValue(value, animated: false)
  }
}
