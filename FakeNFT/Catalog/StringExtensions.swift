//
//  StringExtensions.swift
//  FakeNFT
//
//  Created by Ян Максимов on 22.12.2023.
//

import Foundation

extension String {
    func convertedURL() -> URL? {
        if let url = URL(string: self) {
            return url
        }
        
        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedString) else {
            return nil
        }
        
        return url
    }
}
