//
//  Settings.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 12/2/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import Foundation

/// Control layouts for moving the player.
enum ControlScheme {
    /// The move left button is on the bottom left and the move right button is on the bottom right.
    case BothSides
    /// The move left and move right buttons are adjacent and on the left side.
    case LeftSide
    /// The move left and move right buttons are adjacent and on the right side.
    case RightSide
}

/// The currently selected control scheme.
var currentControlScheme: ControlScheme = .BothSides
