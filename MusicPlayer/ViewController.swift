//
//  ViewController.swift
//  MusicPlayer
//
//  Created by 강동영 on 2023/02/04.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var progressSlider: UISlider!
    
    var player: AVAudioPlayer!
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializePlayer()
    }
    
    func initializePlayer() {
        
        guard let soundAsset: NSDataAsset = NSDataAsset(name: "sound") else {
            print("음원 파일 에셋을 가져올 수 없습니다")
            return
        }
        
        do {
            try self.player = AVAudioPlayer(data: soundAsset.data)
            self.player.delegate = self
            playPauseButton.addTarget(self, action: #selector(playPause(_:)), for: .touchUpInside)
        } catch let error as NSError {
            print("플레이어 초기화 실패")
            print("코드 : \(error.code), 메세지 : \(error.localizedDescription)")
        }
        
        progressSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .touchUpInside)
        progressSlider.maximumValue = Float(self.player.duration)
        progressSlider.minimumValue = 0
        progressSlider.value = Float(self.player.currentTime)
    }

    func updateTimeLabelText(time: TimeInterval) {
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        
        let timeText: String = String(format: "%02ld:%02ld:%02ld", minute, second, milisecond)
        
        timeLabel.text = timeText
    }
    
    func makeAndFireTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in
          
            if progressSlider.isTracking { return }
            
            updateTimeLabelText(time: player.currentTime)
            progressSlider.value = Float(player.currentTime)
        })
        timer.fire()
    }
    
    func invalidateTimer() {
        timer.invalidate()
        timer = nil
    }

    @objc
    func playPause(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            player?.play()
        } else {
            player?.pause()
        }
        
        if sender.isSelected {
            makeAndFireTimer()
        } else {
            invalidateTimer()
        }
    }
    
    @objc
    func sliderValueChanged(_ sender: UISlider) {
        
        updateTimeLabelText(time: TimeInterval(sender.value))
        if sender.isTracking { return }
        player.currentTime = TimeInterval(sender.value)
    }
}

extension ViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
        guard let error: Error = error else {
            print("오디오 플레이어 디코드 오류발생")
            return
        }
        
        let message: String
        message = "오디오 플레이어 오류 발생 \(error.localizedDescription)"
        
        let alert: UIAlertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "확인", style: .default) { (action: UIAlertAction) -> Void in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        playPauseButton.isSelected = false
        progressSlider.value = 0
        updateTimeLabelText(time: 0)
        invalidateTimer()
    }
}

