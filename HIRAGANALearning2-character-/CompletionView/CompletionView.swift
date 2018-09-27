//
//  completionView.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/08.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

class CompletionView: UIView {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var sameProblemButton: UIButton!
    @IBOutlet weak var nextProblemButton: UIButton!
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    func loadNib(){
        let view = Bundle.main.loadNibNamed("CompletionView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
