//
//  ViewController.swift
//  System
//
//  Created by tran trung thanh on 5/17/17.
//  Copyright © 2017 tran trung thanh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIAlertViewDelegate {

    var fileManagaer:FileManager?
    var documentDir:NSString?
    var filePath:NSString?
    override func viewDidLoad() {
        super.viewDidLoad()
        fileManagaer=FileManager.default
        var dirPaths:NSArray=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        documentDir=dirPaths[0] as? NSString
        print("path : \(documentDir)")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnRemoveFile(_ sender: AnyObject)
    {
        filePath=documentDir?.appendingPathComponent("file1.txt") as! NSString
        do{
            try fileManagaer?.removeItem(atPath: filePath as! String)
        }
        catch let error as Error{
            print(error.localizedDescription);
        }
        //fileManagaer?.removeItemAtPath(filePath as! String, error: nil)
        self.showSuccessAlert("Message", messageAlert: "File removed successfully.")
    }
    
    @IBAction func btnEqualityClicked(_ sender: AnyObject)
    {
        let filePath1=documentDir?.appendingPathComponent("file1.txt")
        let filePath2=documentDir?.appendingPathComponent("file2.txt")
        
        if((fileManagaer? .contentsEqual(atPath: filePath1!, andPath: filePath2!)) != nil)
        {
            self.showSuccessAlert("Message", messageAlert: "Files are equal.")
        }
        else
        {
            self.showSuccessAlert("Message", messageAlert: "Files are not equal.")
        }
    }
    

    
    @IBAction func btnMoveClicked(_ sender: AnyObject)
    {
        var oldFilePath:String=documentDir!.appendingPathComponent("file1.txt") as String
        var newFilePath:String=documentDir!.appendingPathComponent("/folder1/file1.txt") as String
        var err :NSError?
        do{
            try fileManagaer?.moveItem(atPath: oldFilePath, toPath: newFilePath)
        }
        catch let error as Error{
            print(error.localizedDescription);
        }
        //fileManagaer?.moveItemAtPath(oldFilePath, toPath: newFilePath, error:&err)
        if((err) != nil)
        {
            print("errorrr \(err)")
        }
        self.showSuccessAlert("Success", messageAlert: "File moved successfully")
    }
    
    @IBAction func btnWriteFileClicked(_ sender: AnyObject)
    {
        let content:NSString=NSString(string: "helllo how are you?")
        let fileContent:Data=content.data(using: String.Encoding.utf8.rawValue)!
        try? fileContent .write(to: URL(fileURLWithPath: documentDir!.appendingPathComponent("file1.txt")), options: [.atomic])
        self.showSuccessAlert("Success", messageAlert: "Content written successfully")
    }
    
    @IBAction func btnCreateFileClicked(_ sender: AnyObject)
    {
        var error: NSError? = nil
        filePath=documentDir?.appendingPathComponent("file1.txt") as! NSString
        fileManagaer?.createFile(atPath: filePath! as String, contents: nil, attributes: nil)
        
        filePath=documentDir?.appendingPathComponent("file2.txt") as! NSString
        fileManagaer?.createFile(atPath: filePath! as String, contents: nil, attributes: nil)
        
        self.showSuccessAlert("Success", messageAlert: "File created successfully")
    }
    
    @IBAction func btnCreateDirectoryClicked(_ sender: AnyObject)
    {
        filePath=documentDir?.appendingPathComponent("/folder1") as! NSString
        do{
            try fileManagaer?.createDirectory(atPath: filePath! as String, withIntermediateDirectories: false, attributes: nil)
        }
        catch let error as Error {
            print(error.localizedDescription);
        }
        //fileManagaer?.createDirectoryAtPath(filePath! as String, withIntermediateDirectories: false, attributes: nil, error: nil)
        self.showSuccessAlert("Success", messageAlert: "Directory created successfully")
    }
    
    @IBAction func btnReadFileClicked(_ sender: AnyObject)
    {
        filePath=documentDir?.appendingPathComponent("/file1.txt") as! NSString
        var fileContent:Data?
        fileContent=fileManagaer?.contents(atPath: filePath! as String)
        let str:NSString=NSString(data: fileContent!, encoding: String.Encoding.utf8.rawValue)!
        self.showSuccessAlert("Success", messageAlert: "data : \(str)" as NSString)
    }
    
    @IBAction func btnCopyFileClicked(_ sender: AnyObject)
    {
        var originalFile=documentDir?.appendingPathComponent("file1.txt")
        var copyFile=documentDir?.appendingPathComponent("copy.txt")
        do{
            try fileManagaer?.copyItem(atPath: originalFile!, toPath: copyFile!)
        }
        catch let error as Error{
            print(error.localizedDescription);
        }
        //fileManagaer?.copyItemAtPath(originalFile!, toPath: copyFile!, error: nil)
        self.showSuccessAlert("Success", messageAlert:"File copied successfully")
    }
    
    @IBAction func btnDirectoryContentsClicked(_ sender: AnyObject)
    {
        var error: NSError? = nil
        let arrDirContent = try? fileManagaer?.contentsOfDirectory(atPath: documentDir! as String)
        //var arrDirContent=fileManagaer!.contentsOfDirectoryAtPath(documentDir as! String, error: &error)
        self.showSuccessAlert("Success", messageAlert: "Content of directory \(arrDirContent)" as NSString)
    }
    
    func showSuccessAlert(_ titleAlert:NSString,messageAlert:NSString)
    {
        let alert:UIAlertController=UIAlertController(title:titleAlert as String, message: messageAlert as String, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
        }
        alert.addAction(okAction)
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnFilePermissionClicked(_ sender: AnyObject)
    {
        filePath=documentDir?.appendingPathComponent("file1.txt") as! NSString
        var filePermissions:NSString = ""
        
        if((fileManagaer?.isWritableFile(atPath: filePath! as String)) != nil)
        {
            filePermissions=filePermissions.appending("file is writable. ") as NSString
        }
        if((fileManagaer?.isReadableFile(atPath: filePath! as String)) != nil)
        {
            filePermissions=filePermissions.appending("file is readable. ") as NSString
        }
        if((fileManagaer?.isExecutableFile(atPath: filePath! as String)) != nil)
        {
            filePermissions=filePermissions.appending("file is executable.") as NSString
        }
        self.showSuccessAlert("Success", messageAlert: "\(filePermissions)" as NSString)
    }
   
}

