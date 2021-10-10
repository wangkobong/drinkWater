//
//  ViewController.swift
//  DrinkWater
//
//  Created by sungyeon kim on 2021/10/09.
//

import UIKit
import UserNotifications


class ViewController: UIViewController {
    var ud: UserDefaults?
    var user: String? = ""
    var amountWater: Double? = 0.0
    var waterDrunkAmount: Int? = 0

    let imageArray = [#imageLiteral(resourceName: "1-1"), #imageLiteral(resourceName: "1-2"), #imageLiteral(resourceName: "1-4"), #imageLiteral(resourceName: "1-5"), #imageLiteral(resourceName: "1-6"), #imageLiteral(resourceName: "1-7"), #imageLiteral(resourceName: "1-8"), #imageLiteral(resourceName: "1-9")]
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    @IBOutlet weak var BottomLabel: UILabel!
    @IBOutlet weak var waterTextFiled: UITextField!
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var goalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextfields(waterTextFiled)
        setImage()
        setTextLabel()
        requestNotificationAuthorization()
    }
    override func viewDidAppear(_ animated: Bool) {
        setImage()
        setTextLabel()
    }
    

    @IBAction func initButtonPressed(_ sender: UIBarButtonItem) {

        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "amountWater")
        UserDefaults.standard.removeObject(forKey: "waterDrunkAmount")
        UserDefaults.standard.removeObject(forKey: "percentage")
        centerImageView.image = imageArray[0]
        BottomLabel.text = "물 많이 드셔야해요!"
        goalLabel.text = "키와 몸무게를 입력해주세요."
    }
    
    @IBAction func drinkButtonPressed(_ sender: UIButton) {
        let userDrunk = Int(waterTextFiled.text!) ?? 0
        
        if  ud?.integer(forKey: "waterDrunkAmount") == 0 {
            UserDefaults.standard.set(0, forKey: "waterDrunkAmount")
        }
        
        let waterDrunkAmount = UserDefaults.standard.integer(forKey: "waterDrunkAmount")
        UserDefaults.standard.set(waterDrunkAmount + userDrunk, forKey: "waterDrunkAmount")
        let updatedWaterDrunkAmount = ud?.integer(forKey: "waterDrunkAmount")
        amountWater = ud?.double(forKey: "amountWater")
        
        if user != nil && amountWater != 0.002{
            goalLabel.text = " 잘하셨어요\n 오늘 마신 양은 \n \(updatedWaterDrunkAmount ?? 0)ml \n 목표의 \(calculatePercentage())%"
        } else if amountWater == 0.002 {
            goalLabel.text = "키와 몸무게를 먼저 입력해주세요."
        }else {
            goalLabel.text = "키와 몸무게를 입력해주세요."
        }
        setImage()
        waterTextFiled.text = ""
    }
    
    func setTextfields(_ textFiled: UITextField) {
        textFiled.borderStyle = .none
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textFiled.frame.height - 1, width: textFiled.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        textFiled.layer.addSublayer(bottomLine)
    }
    
    func setTextLabel() {
        ud = UserDefaults.standard
        user = ud?.string(forKey: "name")
        amountWater = ud?.double(forKey: "amountWater")
        waterDrunkAmount = ud?.integer(forKey: "waterDrunkAmount")
        goalLabel.textColor = .white
        BottomLabel.textColor = .white

        
        if user != nil && amountWater != 0.002 {
            BottomLabel.text = "\(user!)님의 하루 물 권장 섭취량은 \(amountWater!)L입니다"
            goalLabel.text = "잘하셨어요\n 오늘 마신 양은 \n \(waterDrunkAmount ?? 0)ml \n목표의 \(calculatePercentage())%"
        } else if amountWater == 0.002 {
            goalLabel.text = "정확한 키와 몸무게를 입력해주세요."
            BottomLabel.text = "물 많이 드셔야해요!"
        }else {
            goalLabel.text = "키와 몸무게를 입력해주세요."
            BottomLabel.text = "물 많이 드셔야해요!"
        }
        
    }
    
    func calculatePercentage() -> Int {
        amountWater = ud?.double(forKey: "amountWater")
        let amountWaterToML =  (amountWater ?? 0.1) * 1000.0
        let updatedWaterDrunkAmount = ud?.integer(forKey: "waterDrunkAmount")
        let percentage = Double(updatedWaterDrunkAmount ?? 1) / amountWaterToML * 100.0
        let percentageToInt = Int(percentage)
        UserDefaults.standard.set(percentageToInt, forKey: "percentage")
        return percentageToInt
    }
    
    func setImage(){
        let percentage = ud?.integer(forKey: "percentage") ?? 0
        switch percentage {
        case ..<12 :
            centerImageView.image = imageArray[0]
        case ..<24:
            centerImageView.image = imageArray[1]
        case ..<36:
            centerImageView.image = imageArray[2]
        case ..<48:
            centerImageView.image = imageArray[3]
        case ..<60:
            centerImageView.image = imageArray[4]
        case ..<72:
            centerImageView.image = imageArray[5]
        case ..<84:
            centerImageView.image = imageArray[6]
        case 84..<999:
            centerImageView.image = imageArray[7]
        default:
            centerImageView.image = imageArray[0]
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        waterTextFiled.endEditing(true)
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)

        userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
            if success {
                self.sendNotification()
            }
        }
    }
    
    func sendNotification() {
        user = ud?.string(forKey: "name")
        amountWater = ud?.double(forKey: "amountWater")

        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = "\(String(describing: user))님! 물 마실 시간이에요!"
        notificationContent.body = "하루 \(String(describing: amountWater))리터 목표 달성을 위해 열심히 달려보아요"
        notificationContent.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 60, repeats: false)
        
        let request = UNNotificationRequest(identifier: "\(Date())",
                                            content: notificationContent,
                                            trigger: trigger)

        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    
}

