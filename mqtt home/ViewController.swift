//
//  ViewController.swift
//  mqtt home
//
//  Created by Milos Wikarski on 6.10.17.
//  Copyright © 2017 Milos Wikarski. All rights reserved.
//

import UIKit
import Moscapsule
import SwiftyUserDefaults

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txt: UITextField!
    @IBOutlet weak var lbl: UITextView!

    @IBOutlet weak var msgInfo: UILabel!

    var mqttConfig: MQTTConfig!
    var mqttClient: MQTTClient!
    var CurrentTime: Double = 0.0

    @IBAction func clrLbl(_ sender: Any) {
        lbl.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType==UIReturnKeyType.send)
        {
            goAll( textField )
            textField.resignFirstResponder()  
        }
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        CurrentTime = CACurrentMediaTime()
        self.showMsg(msg: "..." )
        
        mqttConfig = MQTTConfig(clientId: "iOS simple MQTT client", host: Defaults[.mqttserver] ?? "test.mosquitto.org", port: Int32(Defaults[.mqttport] ?? 1883), keepAlive: 60)
        
        mqttConfig.onConnectCallback = { returnCode in
            NSLog("Return Code is \(returnCode.description)")
            self.showMsg(msg: "Connected" )
        }
        mqttConfig.onMessageCallback = { mqttMessage in
            NSLog("MQTT Message received: payload=\(String(describing: mqttMessage.payloadString))")
            let ct = CACurrentMediaTime()
            self.showMsg(msg: "ping-pong: \( Int((ct - self.CurrentTime)*1000) ) ms")
            DispatchQueue.main.async {
                self.lbl.text = (mqttMessage.payloadString ?? "") + "\n" + (self.lbl.text ?? "")
            }
        }
        
        
        mqttConfig.onPublishCallback = { messageId in
            self.showMsg(msg: "Sent..." )
        }
        
        // create new MQTT Connection
        mqttClient = MQTT.newConnection(mqttConfig!)
        
        // subscribe
        mqttClient.subscribe(Defaults[.topic] ?? "", qos: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt.delegate = self
        // Note that initializer must be called only once after launch application
        moscapsule_init()
        // set MQTT Client Configuration
        

    }

    func showMsg( msg: String) {
        DispatchQueue.main.async {
            self.msgInfo.text = msg
        }
    }

    @IBAction func goAll(_ sender: Any) {
        
        self.showMsg(msg: "Sending..." )
        CurrentTime = CACurrentMediaTime()
        mqttClient.publish(string: self.txt.text ?? "", topic: Defaults[.topic] ?? "", qos: 0, retain: false)
        
    }
    
    @IBAction func goOff(_ sender: Any) {
        // disconnect
        mqttClient.disconnect()
        self.showMsg(msg: "Not connected" )
    }
}

