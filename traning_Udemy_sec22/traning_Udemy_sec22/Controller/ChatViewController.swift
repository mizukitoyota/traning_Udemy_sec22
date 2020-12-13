//
//  ChatViewController.swift
//  traning_Udemy_sec22
//
//  Created by Training on 2020/12/13.
//  Copyright © 2020 training. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messegeText: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    //スクリーン高さ
    let screenSize = UIScreen.main.bounds.size
    var chatArray = [Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //テーブルの表示や操作を処理するためのもの
        tableView.delegate = self
        //テーブルに表示する内容を提供するもの
        tableView.dataSource = self
        messegeText.delegate = self
        //新しいテーブルセルの作成に使用するクラスを登録
        tableView.register(UINib(nibName: "CustomCellTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        //可変
        tableView.rowHeight = UITableView.automaticDimension
        //高さ
        tableView.estimatedRowHeight = 75
        //キーボード
        //通知センター、UIResponder.keyboardWillShowNotificationが通知された際、keyboardWillShowが呼ばれる
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        //FireBaseからデータ取得
        self.fetchChatDate()
        //セルハイライト消去(区切り線の消去)
        tableView.separatorStyle = .none
    }
    //引数でNSNotification,notification-通知状態,キーボード出た時表示
    @objc func keyboardWillShow(_ notification:NSNotification){
        //通知に関連付けられたユーザー情報,キーボードの表示アニメーション完了時の大きさ,AnyObject-配列保管なんでも、cgRectValueー画面viewのサイズ情報
        let keyboardHeight = ((notification.userInfo! [UIResponder.keyboardFrameEndUserInfoKey] as Any)as AnyObject).cgRectValue.height
        //全体高さーキーボードのたかさーメッセージの高さ
        messegeText.frame.origin.y = screenSize.height - keyboardHeight - messegeText.frame.height
        
    }
    //キーボード隠れる
    @objc func keyboardWillHide(_ notification:NSNotification){
        //全体の高さーメッセージの高さ,duration-閉じる時間
        messegeText.frame.origin.y = screenSize.height - messegeText.frame.height
        guard let rect = (notification.userInfo! [UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as?TimeInterval else {return}
        //CGAffineTransform-数値指定で移動,
        UIView.animate(withDuration: duration){
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.transform = transform
        }
    }
    //キーボードタッチで閉じ
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //キーボードが非表示になる
        messegeText.resignFirstResponder()
    }
    //リターンキーで閉じ,タッチしましたtrue
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //段の数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //メッセージの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //チャット数
        return chatArray.count
    }
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //テーブルビューの数
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! CustomCellTableViewCell
        //チャットを追加
        cell.messegeLabel.text = chatArray[indexPath.row].message
        //送信者の名前追加
        cell.UserNameLabel.text = chatArray[indexPath.row].sender
        cell.iconImageView.image = UIImage(named: "dogAvatarImage")
        //自分の名前のメッセージなら(アドレスが自分のものだったら)
        if cell.UserNameLabel.text == Auth.auth().currentUser?.email as! String {
            cell.messegeLabel.backgroundColor = UIColor.flatGreen()
            //角丸,masksToBounds-Viewの外の文字を描写するか
            cell.messegeLabel.font = UIFont.systemFont(ofSize: 14)
            cell.messegeLabel.layer.cornerRadius = 5
            cell.messegeLabel.layer.masksToBounds = true
        }else{
            cell.messegeLabel.backgroundColor = UIColor.flatBlue()
            cell.messegeLabel.font = UIFont.systemFont(ofSize: 14)
            //角丸,masksToBounds-Viewの外の文字を描写するか
            cell.messegeLabel.layer.cornerRadius = 5
            cell.messegeLabel.layer.masksToBounds = true
        }
        return cell
    }
    //セルの高さをかえす
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    @IBAction func sendAction(_ sender: Any) {
        //入力終わり閉じる
        messegeText.endEditing(true)
        //テキスト入力不可
        messegeText.isEnabled = false
        //ボタン再度押し不可
        sendButton.isEnabled = false
        //メーセージテキスト１５文字不可
        if messegeText.text!.count > 15{
            print("１５文字以上です")
            return
        }
        //データの中からchatを抜き出し、データベース参照、childーキー値
        let chatDB = Database.database().reference().child("chats")
        //キーバリュー型で送信（辞書型）、ユーザー情報送信者とメッっセージ内容
        let messegeInfo = ["sender":Auth.auth().currentUser?.email,"message":messegeText.text!]
        //チャットDBに入れる、childByAutoIdー呼び出すたびに新しいidを払い出す、setValueーId入力
        chatDB.childByAutoId().setValue(messegeInfo) { (error,result) in
            if error != nil{
                //エラー
                print(error)
            }else{
                print("送信完了！！")
                //テキスト書き込み可
                self.messegeText.isEnabled = true
                //ボタン使用可
                self.sendButton.isEnabled = true
                //メッセージ初期化
                self.messegeText.text = ""
            }
        }
    }
    //引っ張ってくる
    func fetchChatDate(){
        
        //どこからデータを引っ張ってくる,データベースのURLの在り処
        let fetchDataRef = Database.database().reference().child("chats")
        //新更新があった時のみ更新,childAdded-アイテムのリストを取得,入ったもののみ取得、snapShotー新データはここに入る
        fetchDataRef.observe(.childAdded) { (snapShot) in
            //新データの中みキャスト
            let snapShotData = snapShot.value as AnyObject
            //新データメッセージ
            let text = snapShotData.value(forKey: "message")
            //新データの送信者
            let sender = snapShotData.value(forKey: "sender")
            //初期化
            let message = Message()
            //メッセージ内に新規データ
            message.message = text as! String
            //焼身者に新規データ
            message.sender = sender as! String
            //配列に追加
            self.chatArray.append(message)
            //すべてのデリゲートを呼び更新
            self.tableView.reloadData()
            
        }
    }
}
