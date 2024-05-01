//
//  Sound.swift
//  LearningSushi
//
//  Created by Nadhif Rahman Alfan on 01/05/24.
//

import Foundation
import AVFoundation

struct Sound {
    
    static var audioPlayer: AVAudioPlayer?
    static var audioPlayerBackground: AVAudioPlayer?
    
    static func playClick(){
        if let url = Bundle.main.url(forResource: "click 1", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        } else {
            print("Error: file not found")
        }
    }
    
    static func playBackground(){
        if let url = Bundle.main.url(forResource: "background", withExtension: "mp3") {
            do {
                audioPlayerBackground = try AVAudioPlayer(contentsOf: url)
                audioPlayerBackground?.numberOfLoops = -1
                audioPlayerBackground?.play()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        } else {
            print("Error: file not found")
        }
    }
    
    static func stopBackground(){
        audioPlayerBackground?.stop()
    }
    
    static func playLoseSound(){
        if let url = Bundle.main.url(forResource: "losing", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        } else {
            print("Error: file not found")
        }
    }
    
    static func playWinSound(){
        if let url = Bundle.main.url(forResource: "winning", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        } else {
            print("Error: file not found")
        }
    }
}
