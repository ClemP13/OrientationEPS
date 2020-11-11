//
//  StopwatchManager.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 08/11/2020.
//

import Foundation
import AVFoundation


class Stopwatch: ObservableObject {
    // 2.
    @Published var duree: Int = 0
    @Published var restant: Int = 0
    @Published var counter = 0
    @Published var timerIsRunning = false
    var bombSoundEffect: AVAudioPlayer?

    var timer = Timer()
    init() {
        self.restant = self.duree - self.counter
    }
    // 3.
    func start() {
        self.timerIsRunning = true
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            
            self.counter = self.counter + 1
            self.restant = self.duree - self.counter
            if self.restant <= 0 {
                self.stop()
                self.playSound()
                
                
            }
        }
    }
    
    // 4.
    func stop() {
        self.timerIsRunning = false
        timer.invalidate()
    }
    
    // 5.
    func reset() {
        self.timerIsRunning = false
        self.counter = 0
        self.restant = self.duree
        timer.invalidate()
    }
    func playSound() {
        let path = Bundle.main.path(forResource: "courseterm.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
            bombSoundEffect?.play()
        } catch {
            // couldn't load file :(
        }
    }
}
