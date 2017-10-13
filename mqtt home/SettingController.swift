//
//  SettingController.swift
//  mqtt home
//
//  Created by Milos Wikarski on 11.10.17.
//  Copyright © 2017 Milos Wikarski. All rights reserved.
//


import UIKit
import SwiftyUserDefaults

class SettingController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var servertxt: UITextField!
    @IBOutlet weak var porttxt: UITextField!
    @IBOutlet weak var topictxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // txt.delegate = self
        servertxt.text = Defaults[.mqttserver] ?? ""
        porttxt.text = String(Defaults[.mqttport] ?? 1883)
        topictxt.text = Defaults[.topic] ?? ""
        
    }
    @IBAction func exitWin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeWin(_ sender: Any) {
        Defaults[.mqttserver] = servertxt.text
        Defaults[.mqttport] = Int(porttxt.text ?? "1883" )
        Defaults[.topic] = topictxt.text

        self.dismiss(animated: true, completion: nil)
    }
}

