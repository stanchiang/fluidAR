//
//  DebugView.swift
//  GameFace
//
//  Created by Stanley Chiang on 10/14/16.
//  Copyright © 2016 Stanley Chiang. All rights reserved.
//

import UIKit

class DebugView: UIView, UITextFieldDelegate, GameVarDelegate {

    var dict = [String:[String:Double]]()
    var prevView:UIView!
    let spacer:CGFloat = 15
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.cyan
        
        loadDict()
        
        for option in dict {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = option.0
            addSubview(label)
            
            let input = UITextField()
            input.translatesAutoresizingMaskIntoConstraints = false
            input.delegate = self
            input.keyboardType = UIKeyboardType.decimalPad
            input.backgroundColor = UIColor.white
            input.text = "\(option.1["value"]!)"
            addSubview(input)
            
            let stepper = UIStepper()
            stepper.translatesAutoresizingMaskIntoConstraints = false
            stepper.tag = Int(option.1["tag"]!)
            stepper.value = option.1["value"]!
            stepper.minimumValue = option.1["min"]!
            stepper.maximumValue = option.1["max"]!
            stepper.stepValue = option.1["step"]!
            
            stepper.isContinuous = true
            stepper.autorepeat = true
            stepper.wraps = true
            addSubview(stepper)
            
            stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
            
        }
    }
    
    func stepperValueChanged(_ sender:UIStepper!) {
        let indexOfInput = subviews.index(of: sender)! - 1
        (subviews[indexOfInput] as! UITextField).text = "\(sender.value)"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let indexOfStepper = subviews.index(of: textField)! + 1
        print(Double(textField.text!)!)
        let stepper = (subviews[indexOfStepper] as! UIStepper)
        stepper.value = Double(textField.text!)!
    }
    
    func getAdjustedPPI() -> CGFloat {
        switch UIScreen.main.bounds.height {
        case 480:
            return 0
        case 568.0:
            return 1.0
        case 667.0:
            return 12.5
        case 736.0:
            return 21.5
        default:
            return 21.5
        }
    }
    
    func checkStepperWithTagId(_ tag:Int) -> Double? {
        for view in subviews {
            if view is UIStepper && view.tag == tag {
                return (view as! UIStepper).value
            }
        }
        return nil
    }
    
    func setDelegate(_ scene:GameScene) {
        scene.gameVarDelegate = self
    }
    
    override func layoutSubviews() {
        for (index, view) in subviews.enumerated() {
            if view is UILabel {
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                if index == 0 {
                    view.topAnchor.constraint(equalTo: topAnchor, constant: spacer).isActive = true
                }else {
                    view.topAnchor.constraint(equalTo: prevView.bottomAnchor, constant: spacer).isActive = true
                }
                prevView = view
            }
            
            if view is UITextField {
                view.leadingAnchor.constraint(equalTo: prevView.trailingAnchor, constant: spacer).isActive = true
                view.centerYAnchor.constraint(equalTo: prevView.centerYAnchor).isActive = true
                
                prevView = view
            }
            
            if view is UIStepper {
                view.leadingAnchor.constraint(equalTo: prevView.trailingAnchor, constant: spacer).isActive = true
                view.centerYAnchor.constraint(equalTo: prevView.centerYAnchor).isActive = true
            }
        }
    }
    
    func loadDict() {
        dict.updateValue(["tag":4,"value":21.5,"min":-30,"max":30,"step":0.5], forKey: "adjustedPPI")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
