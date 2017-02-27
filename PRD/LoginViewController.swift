//
//  LoginViewController.swift
//  PRD
//
//  Created by Ilham on 2/26/17.
//  Copyright © 2017 Ilham. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Warna untuk navigation bar
        navigationController?.navigationBar.barTintColor = UIColor(red: 100/255.0, green: 181/255.0, blue: 246/255.0, alpha: 1.0)
        
        //Warna untuk tulisan dinavigation bar
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        
        
        navigationController?.navigationBar.tintColor = .white
        
        //Menyembunyikan tombol kembali
        self.navigationItem.setHidesBackButton(true, animated:true)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Masuk(_ sender: UIButton) {
        print("Tombol masuk ditekan")
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
