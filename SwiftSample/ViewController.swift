//
//  ViewController.swift
//  SwiftSample
//
//  Created by Lawrence on 2018/8/7.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import Cocoa
import SwiftyJSON

class ViewController: NSViewController {

    @IBOutlet weak var labelCallBack: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let observe : NSObjectProtocol = NotificationCenter.default.addObserver(forName:NSNotification.Name(rawValue: "CustomerNotify"), object: nil, queue: nil)
        {
            notification in
            DispatchQueue.main.async {
                if let userInfo = notification.userInfo, let message = userInfo["message"] as? String {
                    self.labelCallBack.stringValue = message;
                    self.labelCallBack.sizeToFit();
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: {
            NotificationCenter.default.removeObserver(observe);
        });
    }
    
    deinit {
    }
    

    @IBAction func jsonButton(_ sender: Any) {
        let jsonString = "{ \"name\": \"swift\", \"value\": \"Hello Swift JSON\" }";
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try! JSON(data: dataFromString);
            self.labelCallBack.stringValue = json["value"].description;
            self.labelCallBack.sizeToFit();
        }
    }
    
    @IBAction func haveParaButton(_ sender: Any) {
        let dateformatter = DateFormatter();
        dateformatter.dateFormat = "YYYY/MM/dd HH:mm:ss";
        let dateString = dateformatter.string(from: Date());
        
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "customerSegue"), sender: dateString);
    }
    
    @IBAction func haveParaNilButton(_ sender: Any) {
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "customerSegue"), sender: nil); 
    }
    
    @IBAction func programButton(_ sender: Any) {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil);
        let controllerId = NSStoryboard.SceneIdentifier(rawValue: "SecondViewCtrlId");
        
        if let viewCtrl = storyboard.instantiateController(withIdentifier: controllerId) as? SecondViewController {
            //方法一
            let myWindow = NSWindow(contentViewController: viewCtrl);
            myWindow.makeKeyAndOrderFront(self);
            
            //方法二
            //presentViewControllerAsModalWindow(viewCtrl);
            
            viewCtrl.customerValue = "程式開啟";
            viewCtrl.delegate = self;
        }
    }
    
    /** Storyboard 切換 Page 準備參數事件 */
    override func prepare(for segue: NSStoryboardSegue, sender: Any?)
    {
        guard let windowController = segue.destinationController as? NSWindowController else { return }
        
        if let controller = windowController.contentViewController as? SecondViewController {
            controller.customerValue = (sender as? String);
        }
    }
}

extension ViewController: SecondViewDelegate {
    func onSecondCallBackEvent(_ isClose: Bool) {
        self.labelCallBack.stringValue = "Delegate call back value is \(isClose)";
        self.labelCallBack.sizeToFit();
    }
}
