//
//  ViewController.swift
//  Video Music
//
//  Created by Will Said on 2/26/18.
//  Copyright © 2018 Will Said. All rights reserved.
//

import UIKit
import AVFoundation
//import Photos
import MobileCoreServices

//var audioPlayer: AVAudioPlayer


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = UUID().uuidString

    
    @IBAction func buttonClicked(_ sender: Any) {
        
        
        
        
        
        print("BEFORE")
        print(AVAudioSession.sharedInstance().mode)
        takeVideo()
        print("AFTER")
        print(AVAudioSession.sharedInstance().mode)
        print("end")
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setMode(AVAudioSessionModeDefault)
            print(AVAudioSession.sharedInstance().mode)
        } catch let error as NSError {
            print(error)
        }
        
        
    }
    
    @IBOutlet weak var cameraButton: UIButton!
    
    
    @IBOutlet var camPreview: UIView!
    
    func takeVideo() {
        print(1)
        print(AVAudioSession.sharedInstance().isOtherAudioPlaying)
        print()
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            //            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.videoQuality = .typeHigh
            
            print(2)
            print(AVAudioSession.sharedInstance().isOtherAudioPlaying)
            
            do {
                try AVAudioSession.sharedInstance().setMode(AVAudioSessionModeDefault)
                print(AVAudioSession.sharedInstance().mode)
            } catch let error as NSError {
                print(error)
            }
            
            print(AVAudioSession.sharedInstance().category)
            present(imagePicker, animated: true, completion: { () in
                print(3)
                print(AVAudioSession.sharedInstance().isOtherAudioPlaying)
                
                print(AVAudioSession.sharedInstance().isOtherAudioPlaying)
                print(4)
            })
            
            do {
                try AVAudioSession.sharedInstance().setMode(AVAudioSessionModeDefault)
                print(AVAudioSession.sharedInstance().mode)
            } catch let error as NSError {
                print(error)
            }
            
            
            
            
//            print(AVAudioSession.sharedInstance().isOtherAudioPlaying)
//            print("hi ")
//            print(5)
            //                imagePickerController(picker: imagePicker, didFinishPickingMediaWithInfo: ["": "" as AnyObject] )
            //            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(AVAudioSession.sharedInstance().category)
        print(6)
        print(AVAudioSession.sharedInstance().isOtherAudioPlaying)
        
        setupNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption(notification:)), name: NSNotification.Name.AVAudioSessionInterruption, object: AVAudioSession.sharedInstance())

        UIApplication.shared.beginReceivingRemoteControlEvents()
        
//        try? AVAudioSession.sharedInstance().setActive(false)
//        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: .mixWithOthers)
        
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: [AVAudioSessionCategoryOptions.mixWithOthers])
//
//        } catch {
//            print("error")
//        }
        
        
        
//         _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
//        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
//        try? AVAudioSession.sharedInstance().setActive(true)
//        
//        let audioSession = AVAudioSession()
//        
//        do
//        {
//            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
//        }
//        catch
//        {
//            print("Can't Set Audio Session Category: \(error)")
//        }
//        AVAudioSessionCategoryOptions.mixWithOthers
//        do
//        {
//            try audioSession.setMode(AVAudioSessionModeVideoRecording)
//        }
//        catch
//        {
//            print("Can't Set Audio Session Mode: \(error)")
//        }
//        // Start Session
//        
//
//        try? audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: [AVAudioSessionCategoryOptions.mixWithOthers])
//        
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
//        } catch let error as NSError {
//            print(error)
//        }
//        
//        do {
//            try AVAudioSession.sharedInstance().setActive(true)
//        } catch let error as NSError {
//            print(error)
//        }
        
        
        
        imagePicker.delegate = self
        print(AVAudioSession.sharedInstance().isOtherAudioPlaying)
        print(7)
    }
    
    
    
    func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(handleInterruption),
                                       name: .AVAudioSessionInterruption,
                                       object: nil)
    }
    
    @objc func handleInterruption(notification: Notification) {
        print("made it to handler")
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSessionInterruptionType(rawValue: typeValue) else {
                return
        }
        if type == .began {
            print("interuption began")
            // Interruption began, take appropriate actions
        }
        else if type == .ended {
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSessionInterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    // Interruption Ended - playback should resume
                    
                    print("interuption ended, resume")
                } else {
                    // Interruption Ended - playback should NOT resume
                    print("interuption ended, do not resume")

                }
            }
        }
    }
    
    
    
    
    
    
    
    // Finished recording a video
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(8)
        print("Got a video")
        print(AVAudioSession.sharedInstance().isOtherAudioPlaying)
        if let pickedVideo:URL = info[UIImagePickerControllerMediaURL] as? URL {
            // Save video to the main photo album
//            let selectorToCall = Selector("videoWasSavedSuccessfully:didFinishSavingWithError:context:")
            
            
            
            
            
            UISaveVideoAtPathToSavedPhotosAlbum(pickedVideo.relativePath, self, nil, nil)
            
            // Save the video to the app directory so we can play it later
            let videoData = try? Data(contentsOf: pickedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
            let dataPath = documentsDirectory.appendingPathComponent(saveFileName)
            do {
                try videoData?.write(to: dataPath, options: [])
            } catch let error as NSError {
                print(error)
            }
            
            print("Saved to " + dataPath.absoluteString)

            
            
//            let dataPath = documentsDirectory.appendingPathComponent(saveFileName as! String)
//            UISaveVideoAtPathToSavedPhotosAlbum(String(describing: dataPath),nil,nil,nil);

//            videoData?.write(toFile: String(describing: dataPath), atomically: false)

//            PHPhotoLibrary.shared().performChanges({
//                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: dataPath)
//            }) { saved, error in
//                if saved {
//                    let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
//                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                    alertController.addAction(defaultAction)
//                    self.present(alertController, animated: true, completion: nil)
//                }
//            }
//
//            self.dismiss(animated: true, completion: nil)
            
        }
        print(9)
        print(AVAudioSession.sharedInstance().isOtherAudioPlaying)
        imagePicker.dismiss(animated: true, completion: {
            
            // Anything you want to happen when the user saves an video
        })
        print(AVAudioSession.sharedInstance().isOtherAudioPlaying)
        print(10)
    }
    
    


}

