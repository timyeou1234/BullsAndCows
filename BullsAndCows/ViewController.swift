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
        var i = 0
        while i < 4 {
            ansArray.append(Int(arc4random_uniform(9)))
            if ansArray.count == Set(ansArray).count{
                i += 1
            }else{
                ansArray.removeLast()
            }
        }
    }
    
    @IBAction func guess(sender: AnyObject) {
        let guessString = guessTextField.text
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
        if correct {
            let alert = UIAlertController(title: "Wow! You are awesome!", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            guessButton.enabled = false
        } else {
            remainingTime! -= 1
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

