//
//  GameLogicProtocol.swift
//  BullsAndCows
//
//  Created by YeouTimothy on 2016/5/31.
//  Copyright © 2016年 Brian. All rights reserved.
//

import Foundation

protocol BullsAndCowsGameLogic {
    func setGame()
    func generateAnswear()
    func guessAnswearReturnAnsAB(guessString:String) -> String
    func guessAnswearComfirmRepeat(guessString:String)
    func showAnswearString(ansArray:[Int]) -> String
}