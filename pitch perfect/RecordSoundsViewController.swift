//
//  RecordSoundsViewController.swift
//  pitch perfect
//
//  Created by Giovanni Palusa on 2017-06-24.
//  Copyright © 2017 Giovanni Palusa. All rights reserved.
//

import UIKit
import AVKit

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }

    @IBAction func recordAudio(_ sender: Any) {
        setUIState(isRecording: true, recordingText: "Inspelning pågår")
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        setUIState(isRecording: false, recordingText: "Tryck för att spela in")
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            showInfoBox(title: "Fel", body: "Inspelningen lyckades inte")
        }
    }
    
    func setUIState(isRecording:Bool, recordingText:String) {
        stopRecordingButton.isEnabled = isRecording
        recordingLabel.text = recordingText
        recordButton.isEnabled = !isRecording
    }
    
    func showInfoBox(title:String, body:String) {
        let alertController = UIAlertController(title: title, message: body, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Stäng", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}
