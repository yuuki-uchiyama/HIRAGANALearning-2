//
//  CardViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

// カード追加・設定への案内VC
class CardViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toHomeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deckButton: UIButton!
    
    var SE: SoundEffect!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        SE = SoundEffect.sharedSoundEffect
        // Do any additional setup after loading the view.
    }
    
    func layoutSetting(){
        let VS = VisualSetting()
        VS.backgraundView(self)
        
        titleLabel.font = VS.fontAdjust(viewSize: .important)
        cancelButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        toHomeButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        addButton.titleLabel?.font = VS.fontAdjust(viewSize: .important)
        editButton.titleLabel?.font = VS.fontAdjust(viewSize: .important)
        deckButton.titleLabel?.font = VS.fontAdjust(viewSize: .important)
        addButton.titleLabel?.numberOfLines = 0
        editButton.titleLabel?.numberOfLines = 0
        deckButton.titleLabel?.numberOfLines = 0
        addButton.titleLabel?.textAlignment = NSTextAlignment.center
        editButton.titleLabel?.textAlignment = NSTextAlignment.center
        deckButton.titleLabel?.textAlignment = NSTextAlignment.center

        cancelButton.layer.cornerRadius = VS.cornerRadiusAdjust(cancelButton.frame.size, type: .small)
        toHomeButton.layer.cornerRadius = VS.cornerRadiusAdjust(toHomeButton.frame.size, type: .small)
        addButton.layer.cornerRadius = VS.cornerRadiusAdjust(addButton.frame.size, type: .small)
        editButton.layer.cornerRadius = VS.cornerRadiusAdjust(editButton.frame.size, type: .small)
        deckButton.layer.cornerRadius = VS.cornerRadiusAdjust(deckButton.frame.size, type: .small)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func unwindToCard(segue:UIStoryboardSegue){
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
