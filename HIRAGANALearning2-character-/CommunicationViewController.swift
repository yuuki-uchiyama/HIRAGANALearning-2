//
//  CommunicationViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

class CommunicationViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var toHomeButton: UIButton!
    @IBOutlet weak var exportButton: UIButton!
    @IBOutlet weak var importButton: UIButton!
    
    var SE: SoundEffect!
    
    @IBOutlet weak var helpButton: UIButton!
    var helpImageView:UIImageView!
    var helpView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        SE = SoundEffect.sharedSoundEffect
        // Do any additional setup after loading the view.
    }
    
    func layoutSetting(){
        let VS = VisualSetting()
        VS.backgraundView(self.view)
        titleLabel.font = VS.fontAdjust(viewSize: .important)
        toHomeButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        exportButton.titleLabel?.font = VS.fontAdjust(viewSize: .important)
        importButton.titleLabel?.font = VS.fontAdjust(viewSize: .important)
        exportButton.titleLabel?.numberOfLines = 0
        importButton.titleLabel?.numberOfLines = 0
        exportButton.titleLabel?.textAlignment = NSTextAlignment.center
        importButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        toHomeButton.buttonTapActionSetting(.circle)
        exportButton.buttonTapActionSetting(.circle)
        importButton.buttonTapActionSetting(.circle)
        
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
            helpImageView = UIImageView(image: UIImage(named:"Help18"))
            helpImageView.frame = self.view.frame
            helpImageView.contentMode = UIViewContentMode.scaleAspectFit
            self.view.insertSubview(helpImageView, belowSubview: helpButton)
        }else{
            helpImageView.removeFromSuperview()
            helpView.removeFromSuperview()
            helpButton.shadowDisappear()
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
    
    @IBAction func toHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
