//
//  ResultViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

// 結果発表画面
class ResultViewController: UIViewController, SwitchControlDelegate {
    
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var rewardImageView: UIImageView!
    
    @IBOutlet weak var oneMoreButton: UIButton!
    @IBOutlet weak var toHomeButton: UIButton!
    
    var totalCharacterCount = 0
    var perfectAnswerCount = 0
    var accuracyRate = 0
    
    let switchKey = UserDefaults.standard.integer(forKey: Constants.SwitchKey)
    var switchControl:SwitchControlSystem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accuracyRate = perfectAnswerCount * 100 / totalCharacterCount
        percentLabel.text = "\(accuracyRate)%"
        
        switch accuracyRate {
        case 0 ... 60:
            rewardImageView.image = UIImage(named: "OK")
        case 61 ... 80:
            rewardImageView.image = UIImage(named: "Good")
        case 81 ... 100:
                rewardImageView.image = UIImage(named: "VeryGood")
        default:
            break
        }
        
        layoutSetting()
        
        if switchKey > 0{
            let cgRectArray:[CGRect] = [oneMoreButton.frame, toHomeButton.frame]
            switchControl = SwitchControlSystem(switchKey, cgRectArray, self.view, self.view)
            switchControl.delegate = self
        }
        
        // Do any additional setup after loading the view.
    }
    
    func layoutSetting(){
        VisualSetting().backgraundView(self)
    }
    
    
    @IBAction func oneMore(_ sender: Any) {
        let gameLevel = UserDefaults.standard.integer(forKey: Constants.gameLevelKey)
        switch gameLevel {
        case 0: performSegue(withIdentifier: "unwindToSearch", sender: nil)
        case 1: performSegue(withIdentifier: "unwindToSort", sender: nil)
        case 2: performSegue(withIdentifier: "unwindToSyllabary", sender: nil)
        default:break
        }
    }
    @IBAction func toHome(_ sender: Any) {
        performSegue(withIdentifier: "unwindToHome", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "unwindToSearch":
            let searchVC = segue.destination as! SearchingViewController
            searchVC.problemNumber = 10
        case "unwindToSort":
            let sortVC = segue.destination as! SortingViewController
            sortVC.problemNumber = 10
        case "unwindToSyllabary":
            let syllabaryVC = segue.destination as! SyllabaryViewController
            syllabaryVC.problemNumber = 10
        default:break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func decisionKeyPushed(_ cursorNumber: Int) {
        if cursorNumber == 0{
            oneMore(oneMoreButton)
        }else{
            toHome(toHomeButton)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
