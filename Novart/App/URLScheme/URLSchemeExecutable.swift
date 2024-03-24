//
//  URLSchemeExecutable.swift
//  Novart
//
//  Created by Jinwook Huh on 3/9/24.
//

import UIKit

protocol URLSchemeExecutable {
    var url: URL? { get set }
    func execute(to coordinator: (any Coordinator)?) -> Bool
}
