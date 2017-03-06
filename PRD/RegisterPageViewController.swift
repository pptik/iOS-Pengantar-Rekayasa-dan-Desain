//
//  RegisterPageViewController.swift
//  PRD
//
//  Created by Ilham on 2/26/17.
//  Copyright © 2017 Ilham. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class RegisterPageViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    var idPeran = [String]()
    var namaPeran = [String]()
    var univ = [String]()
    var idUniv = [String]()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var peranPicker: UIPickerView!
    
    @IBOutlet weak var univPicker: UIPickerView!
    
    
    @IBOutlet weak var peranPickerValue: UILabel!
    
    @IBOutlet weak var universitasPickerValue: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
   
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sandiTextField: UITextField!
    
    
    @IBOutlet weak var sandiUlangTextField: UITextField!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
       
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == peranPicker{
            let titleRow = namaPeran[row]
            
            return titleRow
        }else if pickerView == univPicker{
            let titleRow = univ[row]
            
            return titleRow
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countRows : Int = namaPeran.count
        if pickerView == univPicker{
            countRows = self.univ.count
        }
        return countRows
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == peranPicker{
            print (namaPeran[row])
            self.peranPickerValue.text = idPeran[row]
        }else if pickerView == univPicker{
            print (idUniv[row])
            self.universitasPickerValue.text = idUniv[row]
        }
    }
    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let pickerLabel = UILabel()
//        pickerLabel.textColor = UIColor.black
//
//        //pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
//        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 15) // In this use your custom font
//        return pickerLabel
//    }
    
    @IBOutlet weak var DaftarButton: UIButton!
        
    @IBAction func OnTap(_ sender: UIButton) {
        var peranVal = self.peranPickerValue.text
        var univVal = self.universitasPickerValue.text
        var username = self.usernameTextField.text
        var email = self.emailTextField.text
        var password = self.sandiTextField.text
        var passwordUlang = self.sandiUlangTextField.text
        
        do {
            let opt = try HTTP.POST("http://prdapi.lskk.ee.itb.ac.id/public/register", parameters: ["peran": peranVal, "universitas": univVal, "email" : email, "username" : username, "password" : password, "password_ulang" : passwordUlang])//HTTP POST untuk proses login
            opt.start { response in //Mengolah hasil HTTP REST
                
                //Menguraikan kembalian berupa JSON ke dalam dictionary
                let json = try? JSONSerialization.jsonObject(with: response.data, options: [])
                
                if let dictionary = json as? [String: Any] {
                    if let rc = dictionary["RC"] as? String {//Mengambil objek RC
                        if(rc == "00"){//RC berhasil
                            //Menghentinkan tampilan loading
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            //UserDefaults.standard.set(24, forKey: "userId")
                            OperationQueue.main.addOperation{
                                self.performSegue(withIdentifier: "menujuHalamanAwal", sender: self)
                            }
                        }else if(rc == "01"){//RC gagal
                            let message = dictionary["message"] as? String
                            
                            //Memberikan dialog bahwa email atau sandi salah
                            OperationQueue.main.addOperation{
                                let alert = UIAlertController(title: "Peringatan", message: message, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
//                                OperationQueue.main.addOperation{
//                                    self.dismissAlert()
//                                }
                            }
                            
                            //Menghentinkan tampilan loading
//                            OperationQueue.main.addOperation{
//                                self.activityIndicator.stopAnimating()
//                                UIApplication.shared.endIgnoringInteractionEvents()
//                            }
                        }
                    }
                }
                
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
//        OperationQueue.main.addOperation{
//            let alert = UIAlertController(title: "Peringatan", message: self.universitasPickerValue.text, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
////            OperationQueue.main.addOperation{
////                self.dismissAlert()
////            }
//        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.universitasPickerValue.text = nil
        self.peranPickerValue.text = nil
        self.getUniversities()
        self.getRoles()
        //Kustomisasi tombol
        DaftarButton.backgroundColor = UIColor(red: 247/255.0, green: 202/255.0, blue: 24/255.0, alpha: 1.0)
        DaftarButton.layer.cornerRadius = 5
    }
    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUniversities(){
        //Menampilkan icon loading ketika proses ini dijalankan
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        //UIApplication.shared.beginIgnoringInteractionEvents()
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.activityIndicator.startAnimating()
        

        
        
        let methodStart = Date()
        do {
            let opt = try HTTP.GET("http://prdapi.lskk.ee.itb.ac.id/public/universities")//HTTP GET untuk ambil daftar semua universitas
            opt.start { response in //Mengolah hasil HTTP REST
                
                //Menguraikan kembalian berupa JSON ke dalam dictionary
                let json = try? JSONSerialization.jsonObject(with: response.data, options: [])
                
                if let dictionary = json as? [String: Any] {
                    if let rc = dictionary["RC"] as? String {//Mengambil objek RC
                        if(rc == "00"){//RC berhasil
                            //Penguraian
                            let json = JSON(response.data)
                            
                            let count = json["data"].count;
                            
                            for index in 0...count{
                                var idUniv = json["data"][index]["id"].stringValue
                                var namaDepan = json["data"][index]["nama_depan"].stringValue
                                var namaBelakang = json["data"][index]["nama_belakang"].stringValue
                                self.univ.append(namaDepan+" "+namaBelakang)
                                self.idUniv.append(idUniv)
                                
                                //self.univ.append(json["data"][index]["nama_depan"].stringValue)
                                //print(json["data"][index]["nama_depan"].stringValue)
                                
                            }
                            self.univPicker.reloadAllComponents()
                            //Menghentinkan tampilan loading
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                        }else if(rc == "01"){//RC gagal
                            let message = dictionary["message"] as? String
                            
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                            //Memberikan dialog bahwa email atau sandi salah
                            OperationQueue.main.addOperation{
                                let alert = UIAlertController(title: "Peringatan", message: message, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                            
                        }
                    }
                }
                
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
        let methodFinish = Date()
        let executionTime = methodFinish.timeIntervalSince(methodStart)
        print("Executin time slow:\(executionTime)")
    }
    
    func getRoles(){
        //Menampilkan icon loading ketika proses ini dijalankan
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.activityIndicator.startAnimating()
        
        
        let methodStart = Date()
        do {
            let opt = try HTTP.GET("http://prdapi.lskk.ee.itb.ac.id/public/registrationroles")//HTTP GET untuk ambil daftar semua universitas
            opt.start { response in //Mengolah hasil HTTP REST
                
                //Menguraikan kembalian berupa JSON ke dalam dictionary
                let json = try? JSONSerialization.jsonObject(with: response.data, options: [])
                
                if let dictionary = json as? [String: Any] {
                    if let rc = dictionary["RC"] as? String {//Mengambil objek RC
                        if(rc == "00"){//RC berhasil
                            //Penguraian
                            let json = JSON(response.data)
                            
                            let count = json["data"].count;
                            
                            for index in 0...count{
                                var idPeranTemp = json["data"][index]["id"].stringValue
                                var namaPeranTemp = json["data"][index]["deskripsi"].stringValue
                                
                                self.idPeran.append(idPeranTemp)
                                self.namaPeran.append(namaPeranTemp)
                                
                                //self.univ.append(json["data"][index]["nama_depan"].stringValue)
                                //print(json["data"][index]["nama_depan"].stringValue)
                                
                            }
                            self.peranPicker.reloadAllComponents()
                            //Menghentinkan tampilan loading
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                        }else if(rc == "01"){//RC gagal
                            let message = dictionary["message"] as? String
                            
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                            //Memberikan dialog bahwa email atau sandi salah
                            OperationQueue.main.addOperation{
                                let alert = UIAlertController(title: "Peringatan", message: message, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                            
                        }
                    }
                }
                
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
        let methodFinish = Date()
        let executionTime = methodFinish.timeIntervalSince(methodStart)
        print("Executin time slow:\(executionTime)")
    }
    
}
