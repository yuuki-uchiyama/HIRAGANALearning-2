//
//  SwitchControlViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/06.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import SVProgressHUD

class SwitchControlViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var toHomeButton: UIButton!
    @IBOutlet weak var singleSwitchButton: UIButton!
    @IBOutlet weak var multipleSwitchButton: UIButton!
    @IBOutlet weak var noSwitchButton: UIButton!
    
    var SE: SoundEffect!
    
    @IBOutlet weak var helpButton: UIButton!
    var helpImageView:UIImageView!
    var helpView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        SE = SoundEffect.sharedSoundEffect
        
        SVProgressHUD.setMinimumDismissTimeInterval(0)

        // Do any additional setup after loading the view.
    }
    
    func layoutSetting(){
        let VS = VisualSetting()
        VS.backgraundView(self.view)
        noSwitchButton.backgroundColor = VS.importantOutletColor
        
        titleLabel.font = VS.fontAdjust(viewSize: .important)
        singleSwitchButton.titleLabel?.font = VS.fontAdjust(viewSize: .important)
        multipleSwitchButton.titleLabel?.font = VS.fontAdjust(viewSize: .important)
        noSwitchButton.titleLabel?.font = VS.fontAdjust(viewSize: .important)
        toHomeButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        
        noSwitchButton.titleLabel?.numberOfLines = 0
        noSwitchButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        singleSwitchButton.buttonTapActionSetting(.circle)
        multipleSwitchButton.buttonTapActionSetting(.circle)
        noSwitchButton.buttonTapActionSetting(.circle)
        toHomeButton.buttonTapActionSetting(.circle)
        
        helpButton.helpButtonAction()
    }
    
    @IBAction func helpViewChange(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            helpButton.shadowSetting()
            helpView = UIView(frame: self.view.frame)
            helpView.backgroundColor = UIColor.flatGray
            helpView.alpha = 0.8
            self.view.insertSubview(helpView, belowSubview: helpButton)
            helpImageView = UIImageView(image: UIImage(named:"Help14"))
            helpImageView.frame = self.view.frame
            helpImageView.contentMode = UIViewContentMode.scaleAspectFit
            self.view.insertSubview(helpImageView, belowSubview: helpButton)
        }else{
            helpImageView.removeFromSuperview()
            helpView.removeFromSuperview()
            helpButton.shadowDisappear()
        }
    }
    
    @IBAction func removeSwitch(_ sender: Any) {
        let alertController = UIAlertController(title: "ボタン設定を解除しますか？", message: nil, preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK", style: .destructive, handler: {
            (acrion:UIAlertAction) -> Void in
            let userDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: Constants.SwitchKey)
            userDefaults.removeObject(forKey: Constants.cursorSpeedKey)
            userDefaults.removeObject(forKey: Constants.singleDecisionKey)
            userDefaults.removeObject(forKey: Constants.toNextKey)
            userDefaults.removeObject(forKey: Constants.toPreviousKey)
            userDefaults.removeObject(forKey: Constants.multiDecisionKey)
            SVProgressHUD.showSuccess(withStatus: "ボタン操作を解除しました")
            self.soundPlay(self.noSwitchButton)
        })
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertController.addAction(OK)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
