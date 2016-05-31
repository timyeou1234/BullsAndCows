//
//  GameLogicProtocol.swift
//  BullsAndCows
//
//  Created by YeouTimothy on 2016/5/31.
//  Copyright © 2016年 Brian. All rights reserved.
//

import Foundation

protocol BullsAndCowsGameLogic {
    var ansArray:[Int] {get set}
    var ansString:String {get set}
    var remainingTime: UInt8! {get set}
    
    func setGame()
    func generateAnswear()
    func guessAnswearReturnAnsAB(guessString:String) -> String
    func guessAnswearComfirmRepeat(guessString:String)
    func showAnswearString(ansArray:[Int]) -> String
}