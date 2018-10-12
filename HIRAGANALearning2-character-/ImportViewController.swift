//
//  ImportViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import SVProgressHUD
import RealmSwift
import AVFoundation

class ImportViewController: UIViewController, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var endButton: UIButton!
    
    var editCardArray:[EditCard] = []
    var imageData:NSData!
    var word:String!
    var id = 0
    
    let realm = try! Realm()
    
    var myPeerID : MCPeerID!
    var session : MCSession!
    var advertiser : MCNearbyServiceAdvertiser!
    var count = 0
    
    var SE: SoundEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cardResults = realm.objects(Card.self)
        id = cardResults.max(ofProperty: "id")!
        if id < 100{
            id = 100
        }
        
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        cardCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        
        myPeerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer : myPeerID)
        session.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: Communication.serviceType)
        advertiser.delegate = self
        
        SVProgressHUD.setMinimumDismissTimeInterval(0)
        
        layoutSetting()
        SE = SoundEffect.sharedSoundEffect
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.show(withStatus: "接続中")
        advertiser.startAdvertisingPeer()
    }
    
    func layoutSetting(){
        let VS = VisualSetting()
        VS.backgraundView(self.view)

        titleLabel.font = VS.fontAdjust(viewSize: .important)
        endButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        
        endButton.buttonTapActionSetting(.circle)
        
        cardCollectionView.layer.borderColor = UIColor.white.cgColor
        cardCollectionView.layer.borderWidth = 5.0
        cardCollectionView.layer.borderColor = UIColor.flatGray.cgColor
        cardCollectionView.layer.cornerRadius = 10.0
        cardCollectionView.layer.masksToBounds = true
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print(peerID)
        invitationHandler(true,session)
        SVProgressHUD.dismiss()
        SVProgressHUD.showSuccess(withStatus: "接続完了")
        endButton.setTitle("受信終了", for: .normal)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        SVProgressHUD.showError(withStatus: "通信を開始できませんでした")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let editCard = EditCard()
        if count == 0{
            imageData = data as NSData
            count = 1
        }else if count == 1{
            word = String(data: data, encoding: .utf8)!
            count = 0
            editCard.importCard(word, imageData)
            editCardArray.append(editCard)
            imageData = nil
            word = nil
            DispatchQueue.main.async{
                self.cardCollectionView.reloadData()
            }
            SE.play(.card)
            SVProgressHUD.showSuccess(withStatus: "受信完了！")
        }
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    }
    
    
    //    collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return editCardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CardCollectionViewCell
        cell.importCard(editCardArray[indexPath.row])
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteCard(_:)))
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
    
    @objc func deleteCard(_ sender:UITapGestureRecognizer){
        let cell = sender.view as! CardCollectionViewCell
        let editCard = cell.editCard
        let alertController: UIAlertController = UIAlertController(title: "このカードを削除しますか？", message: "削除したデータは保存されません", preferredStyle: .alert)
        let yes = UIAlertAction(title: "はい", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            self.editCardArray.remove(value: editCard!)
            SVProgressHUD.showSuccess(withStatus: "カードを削除しました")
            self.cardCollectionView.reloadData()
        })
        let no = UIAlertAction(title: "いいえ", style: .cancel)
        
        alertController.addAction(yes)
        alertController.addAction(no)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func endButton(_ sender: Any) {
        SVProgressHUD.dismiss()
        if editCardArray.count != 0{
            for editCard in editCardArray{
                id += 1
                try! realm .write {
                    let card = Card()
                    card.id = id
                    card.word = editCard.word
                    card.image = editCard.image
                    
                    realm.add(card, update: true)
                }
            }
        }
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
