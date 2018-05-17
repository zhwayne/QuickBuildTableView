//
//  TableBuilder.swift
//  QuickBuildTableView
//
//  Created by 张尉 on 2017/10/20.
//  Copyright © 2017年 Wayne. All rights reserved.
//

import Foundation
import UIKit


public struct TableBuilerConfiguration {
    
    public var useFixedRowHeight: Bool = false
    
    public var useSwipeActionsConfiguration: Bool = false
}


@available(iOS 8.0, *)
@objc public class TableBuilder: NSObject {
    
    public final class Row {
        
        public var rendering: ((UITableView, IndexPath) -> UITableViewCell)?
        
        public var height: ((UITableView, IndexPath) -> CGFloat)?
        
        public var estimatedHeight: ((UITableView, IndexPath) -> CGFloat)?
        
        public var willSelected: ((UITableView, IndexPath) -> IndexPath)?
        
        public var didSelected: ((UITableView, IndexPath) -> Void)?
        
        public var willDeselected: ((UITableView, IndexPath) -> IndexPath)?
        
        public var didDeselected: ((UITableView, IndexPath) -> Void)?
        
        public var shouldHighLight: ((UITableView, IndexPath) -> Bool)?
        
        public var didHighlight: ((UITableView, IndexPath) -> Void)?
        
        public var didUnhighlight: ((UITableView, IndexPath) -> Void)?
        
        public var willDisplay: ((UITableView, UITableViewCell, IndexPath) -> Void)?
        
        public var didEndDisplay: ((UITableView, UITableViewCell, IndexPath) -> Void)?
        
        public var canEdit: ((UITableView, IndexPath) -> Bool)?
        
        public var editActions: ((UITableView, IndexPath) -> [UITableViewRowAction])?
        
        public var titleForDeleteConfirmationButton: ((UITableView, IndexPath) -> String?)?
        
        public var willBeginEditing: ((UITableView, IndexPath) -> Void)?
        
        public var didEndEditing: ((UITableView, IndexPath?) -> Void)?
        
        public var canMove: ((UITableView, IndexPath) -> Bool)?
        
        public var didMoved: ((UITableView, IndexPath, IndexPath) -> Void)?
        
        public var targetIndexPathForMove: ((UITableView, IndexPath, IndexPath) -> IndexPath)?
        
        public var accessoryButtonTapped: ((UITableView, IndexPath) -> Void)?
        
        public var shouldShowMenu: ((UITableView, IndexPath) -> Bool)?
        
        public var indentationLevel: ((UITableView, IndexPath) -> Int)?
        
        public var shouldIndentWhileEditing: ((UITableView, IndexPath) -> Bool)?
        
        public var performAction: ((UITableView, Selector, IndexPath, Any?) -> Void)?
        
        public var canPerformAction: ((UITableView, Selector, IndexPath, Any?) -> Bool)?

        @available(iOS 11.0, *)
        public var leadingSwipeActionsConfiguration: ((UITableView, IndexPath) -> UISwipeActionsConfiguration?)? {
            set { _leadingSwipeActionsConfiguration = leadingSwipeActionsConfiguration }
            get { return _leadingSwipeActionsConfiguration as? ((UITableView, IndexPath) -> UISwipeActionsConfiguration?) }
        }
        private var _leadingSwipeActionsConfiguration: Any?
        
        @available(iOS 11.0, *)
        public var trailingSwipeActionsConfiguration: ((UITableView, IndexPath) -> UISwipeActionsConfiguration?)? {
            set { _trailingSwipeActionsConfiguration = trailingSwipeActionsConfiguration }
            get { return _trailingSwipeActionsConfiguration as? ((UITableView, IndexPath) -> UISwipeActionsConfiguration?) }
        }
        private var _trailingSwipeActionsConfiguration: Any?
        
        @available(iOS 11.0, *)
        public var shouldSpringLoad: ((UITableView, IndexPath, UISpringLoadedInteractionContext) -> Bool)? {
            set { _shouldSpringLoad = shouldSpringLoad }
            get { return _shouldSpringLoad as? ((UITableView, IndexPath, UISpringLoadedInteractionContext) -> Bool) }
        }
        private var _shouldSpringLoad: Any?
    
    }
    
    
    
    public final class Group {
        
        public var rows: [Row] = []
        
        public var headerTitle: ((UITableView, Int) -> String?)?
        
        public var headerView: ((UITableView, Int) -> UIView?)?
        
        public var headerHeight: ((UITableView, Int) -> CGFloat)?
        
        public var estimatedHeaderHeight: ((UITableView, Int) -> CGFloat)?
        
        public var willDisplayHeader: ((UITableView, UIView, Int) -> Void)?
        
        public var didEndDisplayingHeader: ((UITableView, UIView, Int) -> Void)?
        
        public var footerTitle: ((UITableView, Int) -> String?)?
        
        public var footerView: ((UITableView, Int) -> UIView?)?
        
        public var footerHeight: ((UITableView, Int) -> CGFloat)?
        
        public var estimatedFooterHeight: ((UITableView, Int) -> CGFloat)?
        
        public var willDisplayFooter: ((UITableView, UIView, Int) -> Void)?
        
        public var didEndDisplayingFooter: ((UITableView, UIView, Int) -> Void)?
    }
    
    
    public weak var tableView: UITableView?
    
    public var groups: [Group] = []
    
    public var didSelectedSectionIndex: ((UITableView, String, Int) -> Int)?
    
    public var indexTitles: [String]?
    
    public var didScroll: ((UIScrollView) -> Void)?
    
    public var didScrollToTop: ((UIScrollView) -> Void)?
    
    public var willBeginDragging: ((UIScrollView) -> Void)?
    
    public var willEndDragging: ((UIScrollView, CGPoint, UnsafeMutablePointer<CGPoint>) -> Void)?
    
    public var didEndDragging: ((UIScrollView, Bool) -> Void)?
    
    public var didEndDecelerating: ((UIScrollView) -> Void)?
    
    public var willBeginDecelerating: ((UIScrollView) -> Void)?
    
    public var didEndScrollingAnimation: ((UIScrollView) -> Void)?
    
    public var shouldScrollToTop: ((UIScrollView) -> Bool)?
    
    public var didChangeAdjustedContentInset: ((UIScrollView) -> Void)?
    
    private let configuration: TableBuilerConfiguration!
    
    public init(configuration: TableBuilerConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    public override init() {
        fatalError("use `init(configuration:)` instead.")
    }
}


public extension Array {
    
    subscript (safe index: Int) -> Element? {
        return (0..<self.count).contains(index) ? self[index] : nil
    }
}

public protocol QuickGenerator where Self: Any  {
    
    static func generate(block: (inout Self) -> Void) -> Self
}


extension TableBuilder.Row: QuickGenerator {
    
    public static func generate(block: (inout TableBuilder.Row) -> Void) -> TableBuilder.Row {
        var aCell = TableBuilder.Row()
        block(&aCell)
        return aCell
    }
}


extension TableBuilder.Group: QuickGenerator {
    
    public static func generate(block: (inout TableBuilder.Group) -> Void) -> TableBuilder.Group {
        var aSection = TableBuilder.Group()
        block(&aSection)
        return aSection
    }
}


extension TableBuilder {
    
    public func group(at section: Int) -> Group? {
        return groups[safe: section]
    }
    
    public func row(at indexPath: IndexPath) -> Row? {
        return groups[safe: indexPath.section]?.rows[safe: indexPath.row]
    }
    
    public override func responds(to aSelector: Selector!) -> Bool {
        
        if [#selector(tableView(_:heightForRowAt:)),
            #selector(tableView(_:estimatedHeightForRowAt:))].contains(aSelector) {
            return !self.configuration.useFixedRowHeight
        }
        
        if #available(iOS 11.0, *) {
            if [#selector(tableView(_:leadingSwipeActionsConfigurationForRowAt:)),
                #selector(tableView(_:trailingSwipeActionsConfigurationForRowAt:))].contains(aSelector) {
                return self.configuration.useSwipeActionsConfiguration
            }
        }

        return super.responds(to: aSelector)
    }
}


extension TableBuilder: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.group(at: section)?.rows.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = row(at: indexPath)?.rendering?(tableView, indexPath) else {
            fatalError("cell must not be nil")
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.group(at: section)?.footerTitle?(tableView, section)
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.group(at: section)?.headerTitle?(tableView, section)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.row(at: indexPath)?.canEdit?(tableView, indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return self.row(at: indexPath)?.canMove?(tableView, indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.row(at: sourceIndexPath)?.didMoved?(tableView, sourceIndexPath, destinationIndexPath)
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return self.didSelectedSectionIndex!(tableView, title, index)
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.indexTitles
    }
}


extension TableBuilder: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let defaultHeight: CGFloat = tableView.style == .plain ? 0 : UITableViewAutomaticDimension
        return self.group(at: section)?.headerHeight?(tableView, section) ?? defaultHeight
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let defaultHeight: CGFloat = tableView.style == .plain ? 0 : UITableViewAutomaticDimension
        return self.group(at: section)?.footerHeight?(tableView, section) ?? defaultHeight
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.group(at: section)?.estimatedHeaderHeight?(tableView, section) ?? UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return self.group(at: section)?.estimatedFooterHeight?(tableView, section) ?? UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.group(at: section)?.headerView?(tableView, section)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.group(at: section)?.footerView?(tableView, section)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        self.group(at: section)?.willDisplayHeader?(tableView, view, section)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        self.group(at: section)?.didEndDisplayingHeader?(tableView, view, section)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        self.group(at: section)?.willDisplayFooter?(tableView, view, section)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        self.group(at: section)?.didEndDisplayingFooter?(tableView, view, section)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.row(at: indexPath)?.height?(tableView, indexPath) ?? UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.row(at: indexPath)?.estimatedHeight?(tableView, indexPath) ?? UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.row(at: indexPath)?.willDisplay?(tableView, cell, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.row(at: indexPath)?.didEndDisplay?(tableView, cell, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return self.row(at: indexPath)?.willSelected?(tableView, indexPath) ?? indexPath
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.row(at: indexPath)?.didSelected?(tableView, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return self.row(at: indexPath)?.willDeselected?(tableView, indexPath) ?? indexPath
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.row(at: indexPath)?.didDeselected?(tableView, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return self.row(at: indexPath)?.shouldHighLight?(tableView, indexPath) ?? true
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        self.row(at: indexPath)?.didHighlight?(tableView, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        self.row(at: indexPath)?.didUnhighlight?(tableView, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.row(at: indexPath)?.willBeginEditing?(tableView, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        if let `indexPath` = indexPath {
            self.row(at: indexPath)?.didEndEditing?(tableView, indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return self.row(at: indexPath)?.editActions?(tableView, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.row(at: indexPath)?.accessoryButtonTapped?(tableView, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return self.row(at: indexPath)?.shouldShowMenu?(tableView, indexPath) ?? true
    }
    
    public func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return self.row(at: indexPath)?.indentationLevel?(tableView, indexPath) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return self.row(at: indexPath)?.shouldIndentWhileEditing?(tableView, indexPath) ?? true
    }
    
    public func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        self.row(at: indexPath)?.performAction?(tableView, action, indexPath, sender)
    }
    
    public func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return self.row(at: indexPath)?.canPerformAction?(tableView, action, indexPath, sender) ?? true
    }
    
    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return self.row(at: sourceIndexPath)?.targetIndexPathForMove?(tableView, sourceIndexPath, proposedDestinationIndexPath) ?? proposedDestinationIndexPath
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return self.row(at: indexPath)?.leadingSwipeActionsConfiguration?(tableView, indexPath)
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return self.row(at: indexPath)?.trailingSwipeActionsConfiguration?(tableView, indexPath)
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return self.row(at: indexPath)?.shouldSpringLoad?(tableView, indexPath, context) ?? true
    }
    

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.didScroll?(scrollView)
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.didScrollToTop?(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.willBeginDragging?(scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.willEndDragging?(scrollView, velocity, targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.didEndDragging?(scrollView, decelerate)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.didEndDecelerating?(scrollView)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.willBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.didEndScrollingAnimation?(scrollView)
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return self.shouldScrollToTop?(scrollView) ?? true
    }
    
    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        self.didChangeAdjustedContentInset?(scrollView)
    }
}
