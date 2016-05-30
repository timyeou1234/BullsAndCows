//
//  ViewController.swift
//  BullsAndCows
//
//  Created by Brian Hu on 5/19/16.
//  Copyright © 2016 Brian. All rights reserved.
//

import UIKit

class RefactorViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var guessButton: UIButton!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var answearLabel: UILabel!
    var game:GameLogic = GameLogic()
    
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
        game = GameLogic()
        hintArray.removeAll()
        remainingTimeLabel.text = "remaining time: 9"
        answearLabel.text = nil
        guessTextField.text = nil
    }
    
    @IBAction func guess(sender: AnyObject) {
        let guessString = guessTextField.text
        guessTextField.text = ""
        guard game.guessCharLengthEqualToFour(guessString) else {
            let alert = UIAlertController(title: "you should input 4 digits to guess!", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let ansAB = game.guess(guessString)
        
        if game.guessRepeat(guessString){
            let alert = UIAlertController(title: "you should input 4 Different digits to guess!", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
        }
    
        hintArray.append((guessString!, ansAB))
        
        if game.correct {
            let alert = UIAlertController(title: "Wow! You are awesome!", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            guessButton.enabled = false
        } else {
            remainingTimeLabel.text = "remaining time: \(game.remainingTime)"
            switch game.remainingTime{
            case 4...6:
                remainingTimeLabel.textColor = UIColor.yellowColor()
            case 1...3:
                remainingTimeLabel.textColor = UIColor.redColor()
            case 0:
                guessButton.enabled = false
            default:
                break
            }
        }
    }
    
    @IBAction func showAnswear(sender: AnyObject) {
        answearLabel.text = game.showAnsString()
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

