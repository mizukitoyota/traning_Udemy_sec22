//
//  RegisterViewController.swift
//  traning_Udemy_sec22
//
//  Created by Training on 2020/12/12.
//  Copyright © 2020 training. All rights reserved.
//

import UIKit
import Firebase
//アニメーションの詰まったライブラリ
import Lottie

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var EmailTextFieled: UITextField!
    @IBOutlet weak var PassWordTextFieled: UITextField!
    //ローディング也、アニメーションの詰まったライブラリ
    let animationView = AnimationView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //ファイアベースに新ユーザー追加
    @IBAction func registarNewUser(_ sender: Any) {
        //下記、クロージャー、createUser関数帰ってくるユーザーかエラーに返ってくればい以後の処理に続く
        //新規登録
        Auth.auth().createUser(withEmail: EmailTextFieled.text!, password: PassWordTextFieled.text!) { (user, error) in
            if error != nil{
                //Anyにキャスト
                print(error as Any)
            }else{
                print("ユーザー作成が成功しました！！")
                //アニメーションのストップ
                self.stopAnimation()
                //チャット画面に遷移させる
                self.performSegue(withIdentifier: "chat", sender: nil)
            }
        }
    }
    func startAnimation(){
        //ファイル作成
        let animation = Animation.named("loading")
        animationView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/1.5)
        //animationービューをアニメーション化
        animationView.animation = animation
        //サイズをフィット
        animationView.contentMode = .scaleAspectFit
        //くり返し
        animationView.loopMode = .loop
        //アニメーション開始
        animationView.play()
        //ビューを追加
        view.addSubview(animationView)
    }
    
    func stopAnimation(){
        //addSubviewしたビューを削除
        animationView.removeFromSuperview()
    }
}
