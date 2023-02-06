//
//  AudioService.swift
//  MusicPlayer
//
//  Created by hyosung on 2023/02/04.
//

import AVFoundation
import UIKit

protocol AudioServicable {
  var player: AVAudioPlayer? { get }
  
  func play(_ asset: NSDataAsset?)
  func pause()
  func setDelegate(_ self: AudioServiceDelegate)
}

protocol AudioServiceDelegate {
  func audioPlayerDidPlaying()
  func audioPlayerDidPausePlaying()
  func audioPlayerDidFinishPlaying(successfully flag: Bool)
  func audioPlayerDecodeErrorDidOccur(error: Error?)
}

extension AudioServicable {
  func play(_ asset: NSDataAsset? = nil) {
    play(asset)
  }
}

final class AudioService: NSObject, AudioServicable{
  var player: AVAudioPlayer?
  var delegate: AudioServiceDelegate?
}

extension AudioService {
  func play(_ asset: NSDataAsset? = nil) {
    if player == nil {
      guard let player = createPlayer(asset) else { return }
      self.player = player
    }
    
    player?.play()
    delegate?.audioPlayerDidPlaying()
  }
  
  func pause() {
    player?.pause()
    delegate?.audioPlayerDidPausePlaying()
  }
  
  func setDelegate(_ self: AudioServiceDelegate) {
    delegate = self
  }
}

// MARK: - Private Function
extension AudioService {
  private func createPlayer(_ asset: NSDataAsset?) -> AVAudioPlayer? {
    guard let asset = asset else { print("Asset 을 입력해주세요"); return nil }
    do {
      let player = try AVAudioPlayer(data: asset.data)
      player.delegate = self
      return player
    } catch {
      print("Error \(error)")
      return nil
    }
  }
}

extension AudioService: AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    self.player = nil
    delegate?.audioPlayerDidFinishPlaying(successfully: flag)
  }
  
  func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
    delegate?.audioPlayerDecodeErrorDidOccur(error: error)
  }
}
