//
//  ViewController.swift
//  Video Music
//
//  Created by Will Said on 2/26/18.
//  Copyright © 2018 Will Said. All rights reserved.
//
// Todo: enable editing, resume music on pause, and fix dual-camera switch problem
//

import UIKit
import AVFoundation
import MobileCoreServices
import MediaPlayer




class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = UUID().uuidString
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
    }
    

    
    
    
    
    @IBAction func buttonClicked(_ sender: Any) {
        takeVideo(front: false)
        fixAudio()
    }
    
    @IBAction func frontButtonClicked(_ sender: UIButton) {
        takeVideo(front: true)
        fixAudio()
    }
    
    
    
    func takeVideo(front: Bool) {
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.delegate = self
            imagePicker.videoQuality = .typeHigh
            
            if front {
                imagePicker.cameraDevice = .front
            } else {
                imagePicker.cameraDevice = .rear
            }
            
            fixAudio()
            
            present(imagePicker, animated: true, completion: nil)
            
            fixAudio()
            
        }  else {
            //no camera found -- alert the user.
            let alertVC = UIAlertController(
                title: "No Camera",
                message: "Sorry, this device has no camera",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style:.default,
                handler: nil)
            alertVC.addAction(okAction)
            present(
                alertVC,
                animated: true,
                completion: nil)
        }
    }
    
    
    
    
    
    
    
    
    
    // Finished recording a video
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        
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
                failureAlert()
                return
            }

            print("Saved to " + dataPath.absoluteString)
            
            let alertVC = UIAlertController(
                title: "Success",
                message: "Video has been saved successfully.",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style:.default,
                handler: nil)
            alertVC.addAction(okAction)
            self.present(
                alertVC,
                animated: true,
                completion: nil)
        } else {
            failureAlert()
        }

    }
    
    func failureAlert() {
        let alertVC = UIAlertController(
            title: "Failure",
            message: "Sorry, video was not saved.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    
        
    func fixAudio() {
        do {
            _ = try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: .mixWithOthers)
            try AVAudioSession.sharedInstance().setMode(AVAudioSessionModeDefault)
            print(AVAudioSession.sharedInstance().mode)
        } catch let error as NSError {
            print(error)
        }
    }

    
    
}


