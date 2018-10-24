//
//  SettingViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

// 各種設定画面
class SettingViewController: UIViewController {
    
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var tapBanImage: UIImageView!
    @IBOutlet weak var correctBanImage: UIImageView!
    @IBOutlet weak var incorrectBanImage: UIImageView!
    
    @IBOutlet weak var SEView: UIView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var correctView: UIView!
    @IBOutlet weak var incorrectView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var volumuTitleLabel: UILabel!
    @IBOutlet weak var SETitleLabel: UILabel!
    @IBOutlet weak var tapTextLabel: UILabel!
    @IBOutlet weak var correctTextLabel: UILabel!
    @IBOutlet weak var incorrectTextLabel: UILabel!
    
    @IBOutlet weak var toHomeButton: UIButton!
    @IBOutlet weak var defaultButton: UIButton!
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var correctButton: UIButton!
    @IBOutlet weak var incorrectButton: UIButton!
    
    
    var volume:Float = 0.0
    var tapSoundBool = true
    var correctSoundBool = true
    var incorrectSoundBool = true
    
    let userDefaults = UserDefaults.standard
    
    var SE:SoundEffect!
    
    @IBOutlet weak var helpButton: UIButton!
    var helpImageView:UIImageView!
    var helpView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        SE = SoundEffect.sharedSoundEffect

        
        volume = userDefaults.float(forKey: Constants.volumeKey)
        tapSoundBool = userDefaults.bool(forKey: Constants.tapSoundKey)
        correctSoundBool = userDefaults.bool(forKey: Constants.correctSoundKey)
        incorrectSoundBool = userDefaults.bool(forKey: Constants.incorrectSoundKey)
        volumeSlider.value = volume
        tapBanImage.isHidden = tapSoundBool
        correctBanImage.isHidden = correctSoundBool
        incorrectBanImage.isHidden = incorrectSoundBool
        allButtonAlphaChange()
    }
    
    func layoutSetting(){
        let VS = VisualSetting()
        VS.backgraundView(self.view)
        defaultButton.backgroundColor = VS.importantOutletColor
        tapButton.backgroundColor = UIColor.clear
        correctButton.backgroundColor = UIColor.clear
        incorrectButton.backgroundColor = UIColor.clear

        titleLabel.font = VS.fontAdjust(viewSize: .important)
        volumuTitleLabel.font = VS.fontAdjust(viewSize: .normal)
        SETitleLabel.font = VS.fontAdjust(viewSize: .normal)
        tapTextLabel.font = VS.fontAdjust(viewSize: .verySmall)
        correctTextLabel.font = VS.fontAdjust(viewSize: .verySmall)
        incorrectTextLabel.font = VS.fontAdjust(viewSize: .verySmall)
        toHomeButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        defaultButton.titleLabel?.font = VS.fontAdjust(viewSize: .normal)
        
        toHomeButton.buttonTapActionSetting(.circle)
        defaultButton.buttonTapActionSetting(.circle)

        tapButton.imageFit()
        correctButton.imageFit()
        incorrectButton.imageFit()
        let viewArray:[UIView] = [tapView, correctView, incorrectView]
        for view in viewArray{
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(viewTap(_:)))
            longPress.minimumPressDuration = 0
            view.addGestureRecognizer(longPress)
            view.shadowSetting()
            view.cornerLayout(.verySmall)
        }
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
            helpImageView = UIImageView(image: UIImage(named:"Help17"))
            helpImageView.frame = self.view.frame
            helpImageView.contentMode = UIViewContentMode.scaleAspectFit
            self.view.insertSubview(helpImageView, belowSubview: helpButton)
        }else{
            helpImageView.removeFromSuperview()
            helpView.removeFromSuperview()
            helpButton.shadowDisappear()
        }
    }
    
    @IBAction func volumeChange(_ sender: UISlider) {
        volume = sender.value
    }
    
    func buttonAlphaChange(_ bool:Bool,_ view:UIView){
        if bool{
            view.alpha = 1.0
            let shadowSize = view.layer.shadowOffset.height
            if shadowSize < UIScreen.main.bounds.height / 100{
                viewUnSelect(view)
            }
        }else{
            view.alpha = 0.2
            viewSelect(view)
        }
    }
    
    @objc func viewTap(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            print("tapBegan")
            viewSelect(sender.view! as UIView)
        }
        if  sender.state == .ended {
            print("tapEnded")
            viewUnSelect(sender.view! as UIView)
            if (sender.view?.frame.contains(sender.location(in: SEView)))!{
                var bool:Bool!
                switch sender.view{
                case tapView:
                    tapSoundBool = !tapSoundBool
                    tapBanImage.isHidden = tapSoundBool
                    bool = tapSoundBool
                case correctView:
                    correctSoundBool = !correctSoundBool
                    correctBanImage.isHidden = correctSoundBool
                    bool = correctSoundBool
                case incorrectView:
                    incorrectSoundBool = !incorrectSoundBool
                    incorrectBanImage.isHidden = incorrectSoundBool
                    bool = incorrectSoundBool
                default:break
                }
                buttonAlphaChange(bool, sender.view!)
            }
        }
    }
    
    func viewSelect(_ view:UIView){
        let shadowSize = view.layer.shadowOffset.height
        view.frame.origin.x += shadowSize / 2
        view.frame.origin.y += shadowSize / 2
        view.layer.shadowOffset = CGSize(width:shadowSize / 4, height: shadowSize / 4)
    }
    
    func viewUnSelect(_ view:UIView){
        let shadowSize = view.layer.shadowOffset.height
        view.frame.origin.x -= shadowSize * 2
        view.frame.origin.y -= shadowSize * 2
        view.layer.shadowOffset = CGSize(width: shadowSize * 4, height: shadowSize * 4)
    }
    
    func allButtonAlphaChange(){
        buttonAlphaChange(tapSoundBool,tapView)
        buttonAlphaChange(incorrectSoundBool, incorrectView)
        buttonAlphaChange(correctSoundBool, correctView)
    }
    
    @IBAction func tapSoundChange(_ sender: UIButton) {
        tapSoundBool = !tapSoundBool
        UserDefaults.standard.set(!sender.isSelected, forKey: Constants.tapSoundKey)
        tapBanImage.isHidden = tapSoundBool
    }
    
    @IBAction func correctSoundChange(_ sender: UIButton) {
        correctSoundBool = !correctSoundBool
        UserDefaults.standard.set(!sender.isSelected, forKey: Constants.correctSoundKey)
        correctBanImage.isHidden = correctSoundBool
    }
    
    @IBAction func incorrectSoundChange(_ sender: UIButton) {
        incorrectSoundBool = !incorrectSoundBool
        UserDefaults.standard.set(!sender.isSelected, forKey: Constants.incorrectSoundKey)
        incorrectBanImage.isHidden = incorrectSoundBool
    }
    
    @IBAction func defaultButton(_ sender: Any) {
        volume = 0.5
        tapSoundBool = false
        correctSoundBool = false
        incorrectSoundBool = false
        volumeSlider.value = volume
        allButtonAlphaChange()
    }
    
    
    @IBAction func toHome(_ sender: Any) {
        userDefaults.set(volume, forKey: Constants.volumeKey)
        userDefaults.set(tapSoundBool, forKey: Constants.tapSoundKey)
        userDefaults.set(correctSoundBool, forKey: Constants.correctSoundKey)
        userDefaults.set(incorrectSoundBool, forKey: Constants.incorrectSoundKey)
        SE.boolChange(.all)
        SE.play(.cancel)
        self.dismiss(animated: true, completion: nil)
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
