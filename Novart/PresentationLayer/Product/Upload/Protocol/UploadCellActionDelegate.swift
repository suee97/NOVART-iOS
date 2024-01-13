//
//  UploadCellActionDelegate.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/23.
//

import Foundation

protocol UploadCellActionDelegate: NSObject {
    func didTapDeleteButton(identifier: String)
    func didTapCropButton(identifier: String)
}
