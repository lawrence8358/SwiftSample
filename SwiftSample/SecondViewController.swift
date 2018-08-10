//
//  SecondViewController.swift
//  SwiftSample
//
//  Created by Lawrence on 2018/8/7.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import Cocoa

protocol SecondViewDelegate {
    func onSecondCallBackEvent(_ isClose: Bool);
}


class SecondViewController: NSViewController
{
    var delegate : SecondViewDelegate?;

    var customerValue: String?
    {
        didSet {
            if let window = self.view.window {
                if let value = customerValue {
                    window.title = value;
                }
                else {
                    window.title = "Non Title";
                }
            }
        }
    };
    
    override func viewDidLoad() {
        super.viewDidLoad() 
    }
    
    @IBAction func delegateCallBackClick(_ sender: Any)
    {
        self.delegate?.onSecondCallBackEvent(false);
    }
    
    @IBAction func notifyCenterClick(_ sender: Any) {
        var model: [String : Any] = [:];
        model["message"] = "通知中心";
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CustomerNotify"), object: self, userInfo: model);

    }
    
    @IBAction func nsAppSharedClick(_ sender: Any) {         //如果要明確地要找主視窗可以直接用底下的方法就可以了
        //NSApplication.shared.mainWindow;
        
        let windows = NSApplication.shared.windows.filter { (window) -> Bool in
            return (window.contentViewController as? ViewController) != nil;
        }
        
        if windows.count > 0, let viewCtrl = windows[0].contentViewController as? ViewController {
            viewCtrl.labelCallBack.stringValue = "大絕招 NSApplication.shared";
            viewCtrl.labelCallBack.sizeToFit();
        }
    }
    
}

class SecondWindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
    }
}
