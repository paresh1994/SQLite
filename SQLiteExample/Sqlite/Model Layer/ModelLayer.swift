//
//  ModelLayer.swift
//  SQLiteExample
//
//  Created by iDeveloper2 on 26/02/18.
//  Copyright © 2018 Vincent Garrigues. All rights reserved.
//

import Foundation

enum Positions:String {
    case Pitcher = "Pitcher"
    case Catcher = "Catcher"
    case FirstBase = "First Base"
    case SecondBase = "Second Base"
    case ThirdBase = "Third Base"
    case Shortstop = "Shortstop"
    case LeftField = "Left Field"
    case CenterField = "Center Field"
    case RightField = "Right field"
    case DesignatedHitter = "Designated Hitter"
}

typealias Team = (
    teamID:Int64?,
    city:String?,
    nickName:String?,
    abbreviation:String?
)

typealias Player = (
    playerID:Int64?,
    firstName:String?,
    lastName:String?,
    number:Int?,
    teamID:Int64?,
    position:Positions?
)



