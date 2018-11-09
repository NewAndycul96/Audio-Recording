//
//  AudioViewController.swift
//  AudioRecording
//
//  Created by Anand Kulkarni on 11/9/18.
//  Copyright © 2018 Anand Kulkarni. All rights reserved.
//

import UIKit
import AVKit

class AudioViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var playButton: UIBarButtonItem!
    
    var audioSession:AVAudioSession!
    var audioRecorder: AVAudioRecorder!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioSession = AVAudioSession.sharedInstance()
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback, mode: .default)
            } catch {
                print("Setting category to AVAudioSessionCategoryPlayback failed.")
            }
            // Other project setup
            return true
        }
        let recordingSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
    }
    let fileManager = FileManager.default
    let documentDirectoryPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectoryURL = documentDirectoryPaths[0]

    let audioFileName = "audio.caf"
    let audioFileURL = documentDirectoryURL.appendingPathComponent(audioFileName)
    
    playButton.image = UIImage(named: "play")
    let playImage = UIImage(named: "play")
    
    playButton.image = playImage
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            audioRecorder = try AVAudioRecorder(url: self.directoryURL()! as URL,
                                                settings: settings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            finishRecording(success: false)
        }
        do {
            try audioSession.setActive(true)
            audioRecorder.record()
        } catch {
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        if success {
            print(success)
        } else {
            audioRecorder = nil
            print("Somthing Wrong.")
        }
    }

    @IBAction func clickAudioRecord(_ sender: Any) {
        if audioRecorder == nil {
            self.clickAudioRecord.setTitle("Stop", for: UIControl.State.normal)
            self.clickAudioRecord.backgroundColor = UIColor(red: 119.0/255.0, green: 119.0/255.0, blue: 119.0/255.0, alpha: 1.0)
            self.startRecording()
        } else {
            self.clickAudioRecord.setTitle("Record", for: UIControl.State.normal)
            self.clickAudioRecord.backgroundColor = UIColor(red: 221.0/255.0, green: 27.0/255.0, blue: 50.0/255.0, alpha: 1.0)
            self.finishRecording(success: true)
        }
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
