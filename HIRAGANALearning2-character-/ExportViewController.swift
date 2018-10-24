//
//  ExportViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation
import MultipeerConnectivity
import SVProgressHUD

class ExportViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MCNearbyServiceBrowserDelegate {

    var imageArray: [NSData] = []
    var wordArray: [String] = []
    var imageDataArray: [Data] = []
    var wordDataArray: [Data] = []
    
    let realm = try! Realm()
    var collectionCard: CollectionCardData!
    var cardArray: [Card] = []
    
    var myPeerID : MCPeerID!
    var youPeerID : MCPeerID!
    var session : MCSession!
    var browser: MCNearbyServiceBrowser!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var noCardLabel: UILabel!
    @IBOutlet weak var endButton: UIButton!
    
    var SE: SoundEffect!
    
    @IBOutlet weak var helpButton: UIButton!
    var helpImageView:UIImageView!
    var helpView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        cardCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        
        myPeerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer : myPeerID)
        
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: Communication.serviceType)
        browser.delegate = self
        
        SVProgressHUD.setMinimumDismissTimeInterval(0)
        
        
        layoutSetting()
        SE = SoundEffect.sharedSoundEffect
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        browser.startBrowsingForPeers()
        SVProgressHUD.show(withStatus: "接続中")
    }
    
    func layoutSetting(){
        let VS = VisualSetting()
        VS.backgraundView(self.view)

        titleLabel.font = VS.fontAdjust(viewSize: .important)
        endButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        noCardLabel.font = VS.fontAdjust(viewSize: .important)
        
        endButton.buttonTapActionSetting(.circle)
        
        cardCollectionView.layer.borderColor = UIColor.white.cgColor
        cardCollectionView.layer.borderWidth = 5.0
        cardCollectionView.layer.borderColor = UIColor.flatGray.cgColor
        cardCollectionView.layer.cornerRadius = 10.0
        cardCollectionView.layer.masksToBounds = true
        
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
            helpImageView = UIImageView(image: UIImage(named:"Help19"))
            helpImageView.frame = self.view.frame
            helpImageView.contentMode = UIViewContentMode.scaleAspectFit
            self.view.insertSubview(helpImageView, belowSubview: helpButton)
        }else{
            helpImageView.removeFromSuperview()
            helpView.removeFromSuperview()
            helpButton.shadowDisappear()
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 0)
        SVProgressHUD.dismiss()
        SVProgressHUD.showSuccess(withStatus: "接続完了")
        endButton.setTitle("送信終了", for: .normal)
        let results = realm.objects(Card.self).filter("id >= 100").sorted(byKeyPath: "id", ascending: true)
        collectionCard = CollectionCardData.init(results)
        noCardLabel.text = "送信できるカードがありません。\nオリジナルのカードを作成してください。"
        cardCollectionView.reloadData()
        youPeerID = peerID
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        browser.stopBrowsingForPeers()
        SVProgressHUD.showError(withStatus: "受信相手との接続が切れました")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        SVProgressHUD.showError(withStatus: "通信を開始できませんでした")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionCard == nil{
            self.view.bringSubview(toFront: noCardLabel)
            return 0
        }else{
            self.view.sendSubview(toBack: noCardLabel)
            return collectionCard.totalCardDataArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CardCollectionViewCell
        cell.createCard(collectionCard.totalCardDataArray[indexPath.row])
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(export(_:)))
        cell.addGestureRecognizer(tapGesture)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.size.width < 900.0{
            return CGSize(width: 70, height: 100)
        }else{
            return CGSize(width: 105, height: 150)
        }
    }
    
    @objc func export(_ sender:UITapGestureRecognizer){
        let cell = sender.view as! CardCollectionViewCell
        let cardData = cell.cardData
        if youPeerID != nil{
            let cardImage = cardData!.card.image!
            let imageData = cardImage as Data
            let cardWord = cardData!.card.word
            let wordData = cardWord.data(using: String.Encoding.utf8)!
            print(youPeerID)
            do{
                try session.send(imageData, toPeers: [youPeerID], with: MCSessionSendDataMode.reliable)
                try session.send(wordData, toPeers: [youPeerID], with: MCSessionSendDataMode.reliable)
                SE.play(.card)
                SVProgressHUD.showSuccess(withStatus: "送信完了！")
                cell.alpha = 0.5
            }catch{
                SVProgressHUD.showError(withStatus: "データを送信できませんでした")
            }
        }else{
            SVProgressHUD.showError(withStatus: "送信相手が見つかりません")
        }
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        SVProgressHUD.dismiss()
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
    
    
}
