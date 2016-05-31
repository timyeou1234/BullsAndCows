//
//  ViewController.swift
//  BullsAndCows
//
//  Created by Brian Hu on 5/19/16.
//  Copyright © 2016 Brian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, BullsAndCowsGameLogic {
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var guessButton: UIButton!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var answearLabel: UILabel!
    
    var ansArray:[Int] = []
    var ansString:String  = ""
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGame()
    }

    func setGame() {
        generateAnswear()
        remainingTime = 9
        hintArray.removeAll()
        answearLabel.text = ""
        guessTextField.text = nil
    }
    
    func generateAnswear() {
        ansArray = []
        var i:UInt32 = 0
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
    
    func guessAnswearComfirmRepeat(guessString:String) {
        guessTextField.text = ""
        guard guessString.characters.count == 4 else {
            let alert = UIAlertController(title: "you should input 4 digits to guess!", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
    }
    
    func guessAnswearReturnAnsAB(guessString:String) ->String{
        var guessInt = Int(guessString)
        var guessIntArray:[Int] = []
        for i in (0...3).reverse(){
            guessIntArray.append(guessInt! / Int(pow(Double(10) , Double(i))))
            guessInt = guessInt! % Int(pow(Double(10) , Double(i)))
        }
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
            switch remainingTime{
            case 4...6:
                remainingTimeLabel.textColor = UIColor.yellowColor()
            case 0...3:
                remainingTimeLabel.textColor = UIColor.redColor()
            default:
                break
            }
        }
        return "\(String(numbersOfA))A\(Int(numbersOfB))B"
    }
    
    func showAnswearString(ansArray:[Int]) -> String{
        ansString = ""
        for i in 0...3{
            ansString += "\(String(ansArray[i]))"
        }
        return ansString
    }
    
    @IBAction func guess(sender: AnyObject) {
        let guessString = guessTextField.text
        guessAnswearComfirmRepeat(guessString!)
        
        let hint = guessAnswearReturnAnsAB(guessString!)
        
        hintArray.append((guessString!, hint))
        
    }
    
    
    @IBAction func showAnswear(sender: AnyObject) {
        answearLabel.text = ""
        answearLabel.text = showAnswearString(ansArray)
    
    }
    
    
    @IBAction func playAgain(sender: AnyObject) {
        setGame()
        remainingTimeLabel.textColor = UIColor.blackColor()
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

