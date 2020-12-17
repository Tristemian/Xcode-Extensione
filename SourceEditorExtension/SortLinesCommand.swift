//
//  SortLinesCommand.swift
//  SourceEditorExtension
//
//  Created by Vadim Bulavin on 8/20/18.
//  Copyright © 2018 Vadim Bulavin. All rights reserved.
//

import Foundation
import XcodeKit

class SortLinesCommand: NSObject, XCSourceEditorCommand {

	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Swift.Error?) -> Void ) -> Void {
		defer { completionHandler(nil) }

		// At least something is selected
		guard let firstSelection = invocation.buffer.selections.firstObject as? XCSourceTextRange,
			let lastSelection = invocation.buffer.selections.lastObject as? XCSourceTextRange else {
				return
		}

		// One line selected
		guard firstSelection.start.line < lastSelection.end.line else {
			return
		}

		LinesSorter().sort(invocation.buffer.lines, in: firstSelection.start.line...lastSelection.end.line, by: <)

		let lastSelectedLine = invocation.buffer.lines[lastSelection.end.line] as? String

		firstSelection.start.column = 0
		lastSelection.end.column = lastSelectedLine?.count ?? 0
	}
}
