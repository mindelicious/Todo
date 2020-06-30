//
//  String+Extensions.swift
//  TODO
//
//  Created by Matt on 25/06/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
