//
//  ResultViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SVProgressHUD

// 結果発表画面
class ResultViewController: UIViewController, SwitchControlDelegate, GADInterstitialDelegate {
    
    
    @IBOutlet weak var percentLabel: UILabel!
    
    @IBOutlet weak var rewardImageView: UIImageView!
    var rewardImage:UIImage!
    
    @IBOutlet weak var oneMoreButton: UIButton!
    @IBOutlet weak var toHomeButton: UIButton!
    
    var totalCharacterCount = 0
    var perfectAnswerCount = 0
    var accuracyRate = 0
    
    let switchKey = UserDefaults.standard.integer(forKey: Constants.SwitchKey)
    var switchControl:SwitchControlSystem!
    
    var SE: SoundEffect!
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setMinimumDismissTimeInterval(0)
        
        accuracyRate = perfectAnswerCount * 100 / totalCharacterCount
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3240594386716005/2900948285")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
        SVProgressHUD.show(withStatus: "ちょっと待ってね")

        switch accuracyRate {
        case 0 ... 60:
            rewardImage = UIImage(named: "OK")
        case 61 ... 80:
            rewardImage = UIImage(named: "Good")
        case 81 ... 100:
            rewardImage = UIImage(named: "VeryGood")
        default:
            break
        }
        
        layoutSetting()
        SE = SoundEffect.sharedSoundEffect
        

        
        // Do any additional setup after loading the view.
    }
    
    func layoutSetting(){
        let VS = VisualSetting()
        VS.backgraundView(self)
        percentLabel.font = VS.fontAdjust(viewSize: .important)
        oneMoreButton.titleLabel?.font = VS.fontAdjust(viewSize: .normal)
        toHomeButton.titleLabel?.font = VS.fontAdjust(viewSize: .normal)
        
        oneMoreButton.layer.cornerRadius = VS.cornerRadiusAdjust(oneMoreButton.frame.size, type: .normal)
        toHomeButton.layer.cornerRadius = VS.cornerRadiusAdjust(toHomeButton.frame.size, type: .normal)
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        interstitial.present(fromRootViewController: self)
        SVProgressHUD.dismiss()
    }
    
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        rewardDisplay()
        SE.rewardVoice(accuracyRate)
        
        if switchKey > 0{
            let cgRectArray:[CGRect] = [oneMoreButton.frame, toHomeButton.frame]
            switchControl = SwitchControlSystem(switchKey, cgRectArray, self.view, self.view)
            switchControl.delegate = self
        }
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        
        SVProgressHUD.showError(withStatus: "広告を受信できませんでした")
        if switchKey > 0{
            let cgRectArray:[CGRect] = [oneMoreButton.frame, toHomeButton.frame]
            switchControl = SwitchControlSystem(switchKey, cgRectArray, self.view, self.view)
            switchControl.delegate = self
        }
    }
    
    func rewardDisplay(){
        percentLabel.text = "結果　：　\(accuracyRate)%　せいかい！"
        rewardImageView.image = rewardImage
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.3
        animation.fromValue = 3.0
        animation.toValue = 1.0
        animation.autoreverses = false
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        rewardImageView.layer.add(animation, forKey: nil)
        SE.play(.stamp)
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
    
    @IBAction func soundPlay(_ sender: UIButton) {
        switch sender.tag{
        case 1:SE.play(.tap)
        case 2:SE.play(.cancel)
        case 3:SE.play(.important)
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
