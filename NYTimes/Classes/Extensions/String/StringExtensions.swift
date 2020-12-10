//
//  StringExtensions.swift
//  NYTimes
//
//  Created by Michael Grigoryan on 12/9/20.
//

extension String {
    
    // MARK: - Properties
    
    /// Pass string key (from Localizable.strings) to get localized
    /// text for phone's language (will return default language if not available).
    
    var localized: String? {
        return NSLocalizedString(self, comment: self)
    }
}
