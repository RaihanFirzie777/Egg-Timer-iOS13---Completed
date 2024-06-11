//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    let eggTimes = ["Soft" : 3, "Medium" : 420, "Hard" : 720]
    var timer = Timer()
    var totalTime = 0
    var secondPassed = 0
    var player: AVAudioPlayer?
    var alarmTimer: Timer?
    var isAlarmPlaying = false
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        let hardness = sender.currentTitle!
        timer.invalidate()
        totalTime = eggTimes[hardness]!
        
        progressBar.progress = 0.0
        secondPassed = 0
        titleLabel.text = hardness
        isAlarmPlaying = false
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        if secondPassed < totalTime {
            secondPassed += 1
            progressBar.progress = Float(secondPassed) / Float(totalTime)
            print(Float(secondPassed) / Float(totalTime))
        } else {
            timer.invalidate()
            if !isAlarmPlaying {
                titleLabel.text = "DONE!"
                playAlarm()
            }
        }
    }
    
    func playAlarm() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else {
            print("Error: File not found")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = 0 // Ensure the audio does not loop
            player?.play()
            isAlarmPlaying = true
            print("Alarm started")
            // Schedule Timer to stop the alarm after 30 seconds
            alarmTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(stopAlarm), userInfo: nil, repeats: false)
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
    
    @objc func stopAlarm() {
        print("Alarm stopped")
        player?.stop()
        alarmTimer?.invalidate()
        isAlarmPlaying = false
    }
}
