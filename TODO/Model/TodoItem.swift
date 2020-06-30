//
//  TodoItem.swift
//  TODO
//
//  Created by Matt on 26/06/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit

struct TodoItem: Codable {
    var todoLabel: String?
    var todoDate: Date?
    var category: Category?
}
