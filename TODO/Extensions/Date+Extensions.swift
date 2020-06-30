//
//  Date+Extensions.swift
//  TODO
//
//  Created by Matt on 26/06/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit

extension Date {
    func asString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm"
        return dateFormatter.string(from: self)
    }
}
