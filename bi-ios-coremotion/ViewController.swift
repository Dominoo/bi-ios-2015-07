//
//  ViewController.swift
//  bi-ios-coremotion
//
//  Created by Dominik Vesely on 07/12/15.
//  Copyright © 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion
import AVFoundation



class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    weak var cameraPreview : UIView!
    
    lazy var captureSession : AVCaptureSession = {
        let session =  AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetHigh
        return session
    }()
    
    lazy var inputDevice : AVCaptureDevice = {
        return AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    }()
    
    let motionManager = CMMotionManager()
    let locationManager = CLLocationManager()
    
    weak var label: UILabel!
    weak var imageView : UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = UIView(frame: self.view.bounds)
        view.addSubview(v)
        cameraPreview = v
        
        let label = UILabel(frame: CGRectMake(0,0,320,40))
        label.backgroundColor = .whiteColor()
        label.textColor = .blackColor()
        view.addSubview(label)
        self.label = label
        
        
        let imgV = UIImageView(image: UIImage(named: "Dominik"))
        imgV.center = view.center
        view.addSubview(imgV)
        imageView = imgV
        
        
        let deviceInput =  try! AVCaptureDeviceInput(device: inputDevice)

        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
       

        let rootLayer = cameraPreview.layer
        rootLayer.masksToBounds = true
        previewLayer.frame = CGRectMake(-70,0,rootLayer.bounds.size.height,rootLayer.bounds.size.height)
        rootLayer.insertSublayer(previewLayer, atIndex: 0)
        
        captureSession.startRunning()
        
        
        //Camera stuff end
        
        self.motionManager.gyroUpdateInterval = 0.1;
        self.motionManager.startGyroUpdatesToQueue(NSOperationQueue.mainQueue()) { (data, err)  in
            
           // let rotation = atan2(data!.rotationRate.x, data!.rotationRate.y) - M_PI;
           // self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(rotation));
            
          //  print("\(data!.rotationRate.x), \(data!.rotationRate.y), \(data!.rotationRate.z)")
        }
        
        
        
        self.motionManager.accelerometerUpdateInterval = 0.1;
        self.motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) { (data, err) -> Void in
            
           // let rotation = atan2(data!.acceleration.x, data!.acceleration.y) - M_PI;
           // self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(rotation));
         
           // print("\(data!.acceleration.x) , \(data!.acceleration.y),\(data!.acceleration.z)");
            
            
        }
        
        //CM Motion stuff
        
        self.motionManager.magnetometerUpdateInterval = 0.01;
        /*self.motionManager.startMagnetometerUpdatesToQueue(NSOperationQueue.mainQueue()) { (data, err) -> Void in
         // NSLog(@"%f %f %f", magnetometerData.magneticField.x,magnetometerData.magneticField.y,magnetometerData.magneticField.z);
        } */
        
        
        self.motionManager.deviceMotionUpdateInterval = 0.1;
        self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { (motion, err) -> Void in
            
         //   print(motion!.gravity.x,motion!.gravity.y,motion!.gravity.z);
            
          //    let rotation = atan2(motion!.gravity.x, motion!.gravity.y) - M_PI;
          //    self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(rotation));
            
        }
       
        func RadiansToDegrees (value:Double) -> Double {
            return value * 180.0 / M_PI
        }
        
        
    
      /*  self.motionManager.startDeviceMotionUpdatesUsingReferenceFrame(.XTrueNorthZVertical, toQueue: NSOperationQueue.mainQueue()) { (motion, err) -> Void in
            
        let x = motion!.magneticField.field.x;
        let y = motion!.magneticField.field.y;
        let z = motion!.magneticField.field.z;
            
            
            let rotation = motion!.attitude.yaw;
            let angle = RadiansToDegrees(rotation);
            self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(rotation));
            print(angle);
            
            
            
        self.label.text = NSString(format:"{%8.4f, %8.4f, %8.4f}", x, y, z) as String
           
        } */
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.headingFilter = 1
        locationManager.delegate = self
        locationManager.startUpdatingHeading();
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        
        let oldRad = -manager.heading!.trueHeading * M_PI / 180.0
        let newRad = -newHeading.trueHeading * M_PI / 180.0
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = NSNumber(double: oldRad)
        animation.toValue = NSNumber(double: newRad)
        animation.duration = 0.5
        self.imageView.layer.addAnimation(animation, forKey: "rotate")
        self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(newRad))
        
        
        print(manager.heading!.trueHeading, oldRad, newHeading.trueHeading, newRad);

        
    }

    
    
  /*  - (CAAnimation *)animationForRotationX:(float)x Y:(float)y andZ:(float)z
    {
    CATransform3D transform;
    transform = CATransform3DMakeRotation(M_PI, x, y, z);
    
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    animation.duration = 2;
    animation.cumulative = YES;
    animation.repeatCount = 10000;
    return animation;
    } */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

