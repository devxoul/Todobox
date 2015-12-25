//
//  Task.swift
//  Todobox
//
//  Created by 전수열 on 12/26/15.
//  Copyright © 2015 Suyeol Jeon. All rights reserved.
//

struct Task {
    var title: String
    var note: String?
    var done: Bool = false

    init(title: String, note: String? = nil, done: Bool = false) {
        self.title = title
        self.note = note
        self.done = done
    }
}
