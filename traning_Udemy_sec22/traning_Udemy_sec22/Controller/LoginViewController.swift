//
//  LoginViewController.swift
//  traning_Udemy_sec22
//
//  Created by Training on 2020/12/13.
//  Copyright © 2020 training. All rights reserved.
//ログイン画面

import UIKit
import Firebase
import Lottie

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextFieled: UITextField!
    @IBOutlet weak var passWordTextFieled: UITextField!
    
    let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func Login(_ sender: Any) {
        startAnimation()
        //サインイン機能
        Auth.auth().signIn(withEmail: emailTextFieled.text!, password: passWordTextFieled.text!)
        { (user,error)in
            if error != nil {
                print(error ?? "エラー")
            }else{
                print("ログイン成功！！")
                self.stopAnimation()
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
