//
//  ProfileViewController.swift
//  DrinkWater
//
//  Created by sungyeon kim on 2021/10/09.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextfields(nameTextfield)
        setTextfields(heightTextField)
        setTextfields(weightTextField)
    }
    
    func setTextfields(_ textFiled: UITextField) {
        textFiled.borderStyle = .none
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textFiled.frame.height - 1, width: textFiled.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        textFiled.layer.addSublayer(bottomLine)
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let height = Double(heightTextField.text!)
        let weight = Double(weightTextField.text!)
        var name = nameTextfield.text ?? "User"
        if name == "" {
            name = "user"
            UserDefaults.standard.set(name, forKey: "name")
        } else {
            UserDefaults.standard.set(name, forKey: "name")
        }
        let amountWater = calculateToDrink(height: height ?? 0.1, weight: weight ?? 0.1)
        UserDefaults.standard.set(amountWater, forKey: "amountWater")
        UserDefaults.standard.removeObject(forKey: "waterDrunkAmount")
    }
    
    func calculateToDrink(height: Double, weight: Double) -> Double {
        let amountWater = Double((height + weight) / 100)
        return amountWater
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextfield.endEditing(true)
        heightTextField.endEditing(true)
        weightTextField.endEditing(true)
    }

}
