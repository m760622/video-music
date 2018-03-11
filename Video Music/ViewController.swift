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
import MediaPlayer




class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var imagePicker: UIImagePickerController! = UIImagePickerController()
    
    let saveFileName = UUID().uuidString
    
    func fixAudio() {
        do {
            _ = try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: .mixWithOthers)
            try AVAudioSession.sharedInstance().setMode(AVAudioSessionModeDefault)
            print(AVAudioSession.sharedInstance().mode)
        } catch let error as NSError {
            print(error)
        }
    }
    
//    func didSwitch(overlayView:CameraOverlayView) {
//        print("u")
//        print(AVAudioSession.sharedInstance().isOtherAudioPlaying)
////        try? AVAudioSession.sharedInstance().setMode(AVAudioSessionModeDefault)
////        fixAudio()
//        print("ut")
//        print(AVAudioSession.sharedInstance().isOtherAudioPlaying)
//        if imagePicker.cameraDevice == .front {
//            print(AVAudioSession.sharedInstance().isOtherAudioPlaying)
//            imagePicker.cameraDevice = .rear
//        } else {
//            print(AVAudioSession.sharedInstance().isOtherAudioPlaying)
//            imagePicker.cameraDevice = .front
//        }
//        print(AVAudioSession.sharedInstance().isOtherAudioPlaying)
//
//        print("fin")
////        fixAudio()
//
//
//    }

    
    @IBAction func buttonClicked(_ sender: Any) {
        
        takeVideo(front: false)
        
        fixAudio()
        
    }
    
    @IBAction func frontButtonClicked(_ sender: UIButton) {
        takeVideo(front: true)
        fixAudio()
    }
    
    @IBOutlet weak var cameraButton: UIButton!
    
    
    @IBOutlet var camPreview: UIView!

    
    
    
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
            
            //customView stuff
//            let overlayViewController = CameraOverlayViewController(
//                nibName:"CameraOverlayViewController",
//                bundle: nil
//            )
//            let cameraView:CameraOverlayView = overlayViewController.view as! CameraOverlayView
//
//            cameraView.frame = imagePicker.view.frame
            
            
//            cameraView.delegate = self
            
//            imagePicker.cameraOverlayView = cameraView
            
            fixAudio()
            
            present(imagePicker, animated: true, completion: {
//                self.imagePicker.cameraOverlayView = cameraView
            })
            
            fixAudio()
            
        }  else { //no camera found -- alert the user.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    
    
    // Finished recording a video
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePicker.dismiss(animated: true, completion: {
        })
        
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
        }

        if MPMusicPlayerController.systemMusicPlayer.playbackState == .playing {
            print("Music is playing")
        } else {
            print("Play your music")
            //TODO: automatically resume background music when a user plays their own video
        }

        
    }
    
    
    
    
    func imagePickerController2(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        picker.dismiss(animated: true, completion: nil)
        let manager = FileManager.default

        guard let documentDirectory = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {return}
        guard let mediaType = info[UIImagePickerControllerMediaType] as? String else {return}
        guard let url = info[UIImagePickerControllerMediaURL] as? NSURL else {return}

        if mediaType == kUTTypeMovie as String || mediaType == kUTTypeVideo as String {
            let asset = AVAsset(url: url as URL)
            let length = Float(asset.duration.value) / Float(asset.duration.timescale)
            print("video length: \(length) seconds")

            let start = info["_UIImagePickerControllerVideoEditingStart"] as? Float
            let end = info["_UIImagePickerControllerVideoEditingEnd"] as? Float


//            var outputURL = documentDirectory.URLByAppendingPathComponent("output")
            var outputURL = documentDirectory.appendingPathComponent("output")

            do {
                try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
//                outputURL = outputURL.URLByAppendingPathComponent("output.mp4")
                outputURL = documentDirectory.appendingPathComponent("output.mp4")
            }catch let error {
                print(error)
            }

            //Remove existing file
            _ = try? manager.removeItem(at: outputURL)


            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return}
            exportSession.outputURL = outputURL
            exportSession.outputFileType = AVFileType.mp4

            let startTime = CMTime(seconds: Double(start ?? 0), preferredTimescale: 1000)
            let endTime = CMTime(seconds: Double(end ?? length), preferredTimescale: 1000)
            let timeRange = CMTimeRange(start: startTime, end: endTime)

            exportSession.timeRange = timeRange
            exportSession.exportAsynchronously{
                switch exportSession.status {
                case .completed:
                    print("exported at \(outputURL)")

                case .failed:
                    print("failed \(exportSession.error)")

                case .cancelled:
                    print("cancelled \(exportSession.error)")

                default: break
                }
            }
        }
    }
    
        


}

