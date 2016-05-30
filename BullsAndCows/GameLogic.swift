//
//  GameLogic.swift
//  BullsAndCows
//
//  Created by YeouTimothy on 2016/5/30.
//  Copyright © 2016年 Brian. All rights reserved.
//

import UIKit

class GameLogic{
    var ansArray:[Int] = []
    var correct:Bool
    var remainingTime:Int
    
    
    init(){
        self.correct = false
        self.remainingTime = 9
        
        var i:UInt32 = 0
        var ansArrayFrom = [0,1,2,3,4,5,6,7,8,9]
        var count:UInt32 = 0
        var pickNum = 0
        while i < 4 {
            count = 9 - i
            pickNum = Int(arc4random_uniform(count))
            self.ansArray.append(ansArrayFrom[pickNum])
            ansArrayFrom.removeAtIndex(pickNum)
            i += 1
        }
        // generate ansArray
    }
    
    func guessCharLengthEqualToFour(guessString:String?) -> Bool{
        return guessString?.characters.count == 4
    }
    
    func guessRepeat(guessString:String?) -> Bool {
        return (guessString?.characters.count)! != Set(guessString!.characters).count
    }
    
    func guess(guessString:String?) -> String{
        var guessInt = Int(guessString!)
        var guessIntArray:[Int] = []
        for i in (0...3).reverse(){
            guessIntArray.append(guessInt! / Int(pow(Double(10) , Double(i))))
            guessInt = guessInt! % Int(pow(Double(10) , Double(i)))
        }
        //將輸入的字串轉為四位數的Int，利用餘數方法得到一個使用者輸入數字的陣列
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
        self.correct = numbersOfA == 4
        //4A更新Correct
        self.remainingTime -= 1
        //更新剩餘次數
        return "\(String(numbersOfA))A\(Int(numbersOfB))B"
    }
    
    func showAnsString() -> String {
        var ansString:String = ""
        for i in 0...3{
            ansString += "\(String(self.ansArray[i]))"
        }
        return ansString
    }
    

    }
    


