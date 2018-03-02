//
//  ViewController.swift
//  Video Music
//
//  Created by Will Said on 2/26/18.
//  Copyright © 2018 Will Said. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = UUID().uuidString

    
    @IBAction func buttonClicked(_ sender: Any) {
        
        takeVideo()
        
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
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.videoQuality = .typeHigh
            
            do {
                try AVAudioSession.sharedInstance().setMode(AVAudioSessionModeDefault)
            } catch let error as NSError {
                print(error)
            }
            
            present(imagePicker, animated: true, completion: nil)
            
            do {
                try AVAudioSession.sharedInstance().setMode(AVAudioSessionModeDefault)
            } catch let error as NSError {
                print(error)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
    
    // Finished recording a video
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedVideo:URL = info[UIImagePickerControllerMediaURL] as? URL {
            // Save video to the main photo album
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

        }
        imagePicker.dismiss(animated: true, completion: {
            // Anything you want to happen when the user saves an video
        })
    }
    
    


}

