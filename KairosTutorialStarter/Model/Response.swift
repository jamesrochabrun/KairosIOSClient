//
//  Response.swift
//  KairosTutorialStarter
//
//  Created by James Rochabrun on 3/3/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation

enum Response<T> {
    case success(T)
    case error(String)
}
