//
//  HomeProductCellDelegate.swift
//  Plain
//
//  Created by Jinwook Huh on 8/4/24.
//

import Foundation

protocol HomeProductCellDelegate: AnyObject {
    func didTapLikeButton(productID: Int64, like: Bool)
}
