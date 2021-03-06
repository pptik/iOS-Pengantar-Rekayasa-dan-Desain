//
//  LoginViewController.swift
//  PRD
//
//  Created by Ilham on 2/26/17.
//  Copyright © 2017 Ilham. All rights reserved.
//  Kelas ini dibuat untuk menghandle proses login dari sebuah tombol

import UIKit
import SwiftHTTP
import JSONJoy
import YYHRequest
import Foundation

class LoginViewController: UIViewController {
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    //Deklarasi Text Field
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sandiTextField: UITextField!
    
    @IBOutlet weak var MasukButton: UIButton!
    @IBAction func OnTapMasukButton(_ sender: UIButton) {//Aksi ketika menekan tombol
        
        //Menampilkan icon loading ketika proses ini dijalankan
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
            
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Melakukan REST
        do {
            let opt = try HTTP.POST("http://prdapi.lskk.ee.itb.ac.id/public/login", parameters: ["email": emailTextField.text, "password": sandiTextField.text])//HTTP POST untuk proses login
            opt.start { response in //Mengolah hasil HTTP REST
                
                //Menguraikan kembalian berupa JSON ke dalam dictionary
                let json = try? JSONSerialization.jsonObject(with: response.data, options: [])
                
                if let dictionary = json as? [String: Any] {
                    if let rc = dictionary["RC"] as? String {//Mengambil objek RC
                        if(rc == "00"){//RC berhasil
                            //Menghentinkan tampilan loading
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()                        
                            UserDefaults.standard.set(24, forKey: "userId")
                            OperationQueue.main.addOperation{
                                self.performSegue(withIdentifier: "menujuTopik", sender: self)
                            }
                        }else if(rc == "01"){//RC gagal
                            let message = dictionary["message"] as? String
                            
                            //Memberikan dialog bahwa email atau sandi salah
                            OperationQueue.main.addOperation{
                            let alert = UIAlertController(title: "Peringatan", message: message, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            OperationQueue.main.addOperation{
                                self.dismissAlert()
                                }
                            }
                            
                            //Menghentinkan tampilan loading
                            OperationQueue.main.addOperation{
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                            }
                        }
                    }
                }
                
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    
    func dismissAlert() {
        DispatchQueue.main.async {
            self.dismissAlert()
        }
    }
    
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
        
        //Kustomisasi tombol
        MasukButton.backgroundColor = UIColor(red: 247/255.0, green: 202/255.0, blue: 24/255.0, alpha: 1.0)
        MasukButton.layer.cornerRadius = 5
//        MasukButton.layer.borderWidth = 1
//        MasukButton.layer.borderColor = UIColor.black.cgColor

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
