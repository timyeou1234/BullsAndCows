//
//  ViewController.swift
//  BullsAndCows
//
//  Created by Brian Hu on 5/19/16.
//  Copyright © 2016 Brian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var guessButton: UIButton!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var answearLabel: UILabel!
    var remainingTime: UInt8! {
        didSet {
            remainingTimeLabel.text = "remaining time: \(remainingTime)"
            if remainingTime == 0 {
                guessButton.enabled = false
            } else {
                guessButton.enabled = true
            }
        }
    }
    
    var hintArray = [(guess: String, hint: String)]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // TODO: 1. decide the data type you want to use to store the answear
    var answear: UInt16!
    var ansArray:[Int] = []
    var ansString:String  = ""
    //以陣列作為答案型別
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGame()
    }

    func setGame() {
        generateAnswear()
        remainingTime = 9
        hintArray.removeAll()
        answearLabel.text = nil
        guessTextField.text = nil
    }
    
    func generateAnswear() {
        // TODO: 2. generate your answear here
        // You need to generate 4 random and non-repeating digits.
        // Some hints: http://stackoverflow.com/q/24007129/938380
        ansArray = []
        ansString = ""
        var i:UInt32 = 0
//        while i < 4 {
//            ansArray.append(Int(arc4random_uniform(9)))
//            if ansArray.count == Set(ansArray).count{
//                i += 1
//            }else{
//                ansArray.removeLast()
//            }
//        }
        //產生一個陣列當中有四個不重複0~9隨機數字作為答案
        var ansArrayFrom = [0,1,2,3,4,5,6,7,8,9]
        var count:UInt32 = 0
        var pickNum = 0
        while i < 4 {
            count = 9 - i
            pickNum = Int(arc4random_uniform(count))
            ansArray.append(ansArrayFrom[pickNum])
            ansArrayFrom.removeAtIndex(pickNum)
            i += 1
        }
    }
    
    @IBAction func guess(sender: AnyObject) {
        let guessString = guessTextField.text
        guessTextField.text = ""
        guard guessString?.characters.count == 4 else {
            let alert = UIAlertController(title: "you should input 4 digits to guess!", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        // TODO: 3. convert guessString to the data type you want to use and judge the guess
        
        
        
        var guessInt = Int(guessString!)
        var guessIntArray:[Int] = []
        for i in (0...3).reverse(){
            guessIntArray.append(guessInt! / Int(pow(Double(10) , Double(i))))
            guessInt = guessInt! % Int(pow(Double(10) , Double(i)))
        }
        //將輸入的字串轉為四位數的Int，利用餘數方法得到一個使用者輸入數字的陣列
        
        if guessIntArray.count != Set(guessIntArray).count{
            let alert = UIAlertController(title: "you should input 4 Different digits to guess!", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return

        }
        
        // TODO: 4. update the hint
        var numbersOfA = 0
        var numbersOfB = 0
        var y = 0
        for i in 0...3{
            while y < 4 {
                if ansArray[i] == guessIntArray[y]{
                    numbersOfB += 1
                }
                y += 1
            }
            y = 0
        }
        
        if numbersOfB > 0{
            for i in 0...3{
                if ansArray[i] == guessIntArray[i]{
                numbersOfA += 1
                numbersOfB -= 1
                }
            }
        }
        
        //先用兩層迴圈比對兩陣列是否有重複的數字，若有，比對兩陣列是否由位置和數字皆一樣的數字
        var gusPrint:String = ""
        for i in 0...3{
             gusPrint += "\(String(guessIntArray[i]))"
        }
        let hint = "\(String(numbersOfA))A\(Int(numbersOfB))B"
        
        hintArray.append((gusPrint, hint))
        
        // TODO: 5. update the constant "correct" if the guess is correct
        var correct = false
        if numbersOfA == 4{
            correct = true
        }
        //若4A則代表完全猜對
        if correct {
            let alert = UIAlertController(title: "Wow! You are awesome!", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            guessButton.enabled = false
        } else {
            remainingTime! -= 1
            switch remainingTime{
                case 4...6:
                    remainingTimeLabel.textColor = UIColor.yellowColor()
                case 0...3:
                    remainingTimeLabel.textColor = UIColor.redColor()
                default: break
            }
        }
    }
    @IBAction func showAnswear(sender: AnyObject) {
        // TODO: 6. convert your answear to string(if it's necessary) and display it
        if ansString == ""{
            for i in 0...3{
                ansString += "\(String(ansArray[i]))"
                answearLabel.text = ansString
            }
        }else {
            self.answearLabel.text = "Wrong at 140"
        }
        //將每個元素分開存進AnsString讓他能順利印出來
    }
    
    
    @IBAction func playAgain(sender: AnyObject) {
        setGame()
    }
    
    // MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hintArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Hint Cell", forIndexPath: indexPath)
        let (guess, hint) = hintArray[indexPath.row]
        cell.textLabel?.text = "\(guess) => \(hint)"
        return cell
    }
}

