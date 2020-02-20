//
//  String.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/28/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
