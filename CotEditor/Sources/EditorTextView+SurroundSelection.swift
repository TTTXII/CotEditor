//
//  EditorTextView+SurroundSelection.swift
//
//  CotEditor
//  https://coteditor.com
//
//  Created by 1024jp on 2017-03-19.
//
//  ---------------------------------------------------------------------------
//
//  © 2017-2018 1024jp
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Cocoa

extension EditorTextView {
    
    // MARK: Action Messages
    
    /// insert ' around selections
    @IBAction func surroundSelectionWithSingleQuotes(_ sender: AnyObject?) {
        
        self.surroundSelections(begin: "'", end: "'")
    }
    
    
    /// insert " around selections
    @IBAction func surroundSelectionWithDoubleQuotes(_ sender: AnyObject?) {
        
        self.surroundSelections(begin: "\"", end: "\"")
    }
    
    
    /// insert () around selections
    @IBAction func surroundSelectionWithParenthesis(_ sender: AnyObject?) {
        
        self.surroundSelections(begin: "(", end: ")")
    }
    
    
    /// insert {} around selections
    @IBAction func surroundSelectionWithBraces(_ sender: AnyObject?) {
        
        self.surroundSelections(begin: "{", end: "}")
    }
    
    
    /// show custom surround sheet
    @IBAction func surroundSelection(_ sender: Any?) {
        
        let viewController = NSStoryboard(name: NSStoryboard.Name("CustomSurroundStringView"), bundle: nil).instantiateInitialController() as! CustomSurroundStringViewController
        viewController.representedObject = self
        
        self.viewControllerForSheet?.presentViewControllerAsSheet(viewController)
    }
    
}



extension NSTextView {
    
    /// insert strings around selections
    @discardableResult
    func surroundSelections(begin: String, end: String) -> Bool {
        
        let string = self.string as NSString
        let selectedRanges = self.selectedRanges as! [NSRange]
        
        let replacementStrings = selectedRanges.map { begin + string.substring(with: $0) + end }
        let newSelectedRanges = selectedRanges.enumerated().map { item -> NSRange in
            let range = item.element
            return NSRange(location: (item.offset + 1) * begin.utf16.count + range.location + item.offset * end.utf16.count,
                           length: range.length)
        }
        
        return self.replace(with: replacementStrings, ranges: selectedRanges, selectedRanges: newSelectedRanges)
    }
    
}
