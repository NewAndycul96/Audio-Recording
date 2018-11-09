//
//  AudioViewController.swift
//  AudioRecording
//
//  Created by Anand Kulkarni on 11/9/18.
//  Copyright © 2018 Anand Kulkarni. All rights reserved.
//

import UIKit
import AVKit

class AudioViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    var audioSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var isAudioRecorder: Bool!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecorder = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecorder = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().recordPermission { [unowned self] allowed in DispatchQueue.main.async {
                if allowed {
                    self.isAudioRecorder = true
                } else {
                    self.isAudioRecorder = false
                }
            }
        }
        break
        default:
            break
        }
    }
    
    @IBAction func audioRecorder(_ sender: Any) {
        
        if isAudioRecorder {
            
            let session = AVAudioSession.sharedInstance()
            
            do {
                try session.setCategory(AVAudioSession.Category, mode:.default)
                try session.setActive(true, options: AVAudioSession.SetActiveOptions)
                
                let recordingSettings =
                    [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                     AVEncoderBitRateKey: 16,
                     AVNumberOfChannelsKey: 2,
                     AVSampleRateKey: 44100.0] as [String : Any]
                
            } catch let error {
                print("Error for start audio recording")
            }
        }
    }
    
    @IBAction func finsihRecording(_ sender: Any) {
        
        finishAudioRecording(success: true)
    }
    func finishAudioRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            print("Recording finished")
        } else {
            print("Recording failed")
        }
    }
    func getdocumentsDirectory() -> URL {
        
        let fileManager = FileManager.default
        let documentDirectoryPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectoryURL = documentDirectoryPaths[0]
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishAudioRecording(success: false)
        }
    }
}
