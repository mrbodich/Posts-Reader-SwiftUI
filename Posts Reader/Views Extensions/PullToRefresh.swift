//
//  PullToRefresh.swift
//  Posts Reader
//
//  Created by Bogdan Chornobryvets on 17.07.2021.
//
//  Copyright (c) 2019 Timber Software (https://timber.so/)
//  https://github.com/siteline/SwiftUIRefresh
//  Copyright 2019 Timber Software
//  https://github.com/siteline/SwiftUI-Introspect
//

import SwiftUI

private struct PullToRefresh: UIViewRepresentable {

    @Binding var isShowing: Bool
    let onRefresh: () -> Void

    public init(
        isShowing: Binding<Bool>,
        onRefresh: @escaping () -> Void
    ) {
        _isShowing = isShowing
        self.onRefresh = onRefresh
    }

    public class Coordinator {
        let onRefresh: () -> Void
        let isShowing: Binding<Bool>

        init(
            onRefresh: @escaping () -> Void,
            isShowing: Binding<Bool>
        ) {
            self.onRefresh = onRefresh
            self.isShowing = isShowing
        }

        @objc
        func onValueChanged() {
            isShowing.wrappedValue = true
            onRefresh()
        }
    }

    public func makeUIView(context: UIViewRepresentableContext<PullToRefresh>) -> UIView {
        let view = UIView(frame: .zero)
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }

    private func tableView(entry: UIView) -> UIScrollView? {

        // Search in ancestors
        if let tableView = Introspect.findAncestor(ofType: UIScrollView.self, from: entry) {
            return tableView
        }

        guard let viewHost = Introspect.findViewHost(from: entry) else {
            return nil
        }

        // Search in siblings
        return Introspect.previousSibling(containing: UIScrollView.self, from: viewHost)
    }

    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PullToRefresh>) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

            guard let tableView = self.tableView(entry: uiView) else {
                return
            }

            if let refreshControl = tableView.refreshControl {
                if self.isShowing {
                    refreshControl.beginRefreshing()
                } else {
                    refreshControl.endRefreshing()
                }
                return
            }

            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.onValueChanged), for: .valueChanged)
            tableView.refreshControl = refreshControl
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(onRefresh: onRefresh, isShowing: $isShowing)
    }
}

extension View {
    public func pullToRefresh(isShowing: Binding<Bool>, onRefresh: @escaping () -> Void) -> some View {
        return overlay(
            PullToRefresh(isShowing: isShowing, onRefresh: onRefresh)
                .frame(width: 0, height: 0)
        )
    }
}

public typealias PlatformViewController = UIViewController
public typealias PlatformView = UIView

public enum Introspect {

    /// Finds a subview of the specified type.
    /// This method will recursively look for this view.
    /// Returns nil if it can't find a view of the specified type.
    public static func findChild<AnyViewType: PlatformView>(
        ofType type: AnyViewType.Type,
        in root: PlatformView
    ) -> AnyViewType? {
        for subview in root.subviews {
            if let typed = subview as? AnyViewType {
                return typed
            } else if let typed = findChild(ofType: type, in: subview) {
                return typed
            }
        }
        return nil
    }

    /// Finds a child view controller of the specified type.
    /// This method will recursively look for this child.
    /// Returns nil if it can't find a view of the specified type.
    public static func findChild<AnyViewControllerType: PlatformViewController>(
        ofType type: AnyViewControllerType.Type,
        in root: PlatformViewController
    ) -> AnyViewControllerType? {
        for child in root.children {
            if let typed = child as? AnyViewControllerType {
                return typed
            } else if let typed = findChild(ofType: type, in: child) {
                return typed
            }
        }
        return root as? AnyViewControllerType
    }

    /// Finds a subview of the specified type.
    /// This method will recursively look for this view.
    /// Returns nil if it can't find a view of the specified type.
    public static func findChildUsingFrame<AnyViewType: PlatformView>(
        ofType type: AnyViewType.Type,
        in root: PlatformView,
        from originalEntry: PlatformView
    ) -> AnyViewType? {
        var children: [AnyViewType] = []
        for subview in root.subviews {
            if let typed = subview as? AnyViewType {
                children.append(typed)
            } else if let typed = findChild(ofType: type, in: subview) {
                children.append(typed)
            }
        }

        if children.count > 1 {
            for child in children {
                let converted = child.convert(
                    CGPoint(x: originalEntry.frame.size.width / 2, y: originalEntry.frame.size.height / 2),
                    from: originalEntry
                )
                if CGRect(origin: .zero, size: child.frame.size).contains(converted) {
                    return child
                }
            }
            return nil
        }

        return children.first
    }

    /// Finds a previous sibling that contains a view of the specified type.
    /// This method inspects siblings recursively.
    /// Returns nil if no sibling contains the specified type.
    public static func previousSibling<AnyViewType: PlatformView>(
        containing type: AnyViewType.Type,
        from entry: PlatformView
    ) -> AnyViewType? {

        guard let superview = entry.superview,
            let entryIndex = superview.subviews.firstIndex(of: entry),
            entryIndex > 0
        else {
            return nil
        }

        for subview in superview.subviews[0..<entryIndex].reversed() {
            if let typed = findChild(ofType: type, in: subview) {
                return typed
            }
        }

        return nil
    }

    /// Finds a previous sibling that is of the specified type.
    /// This method inspects siblings recursively.
    /// Returns nil if no sibling contains the specified type.
    public static func previousSibling<AnyViewType: PlatformView>(
        ofType type: AnyViewType.Type,
        from entry: PlatformView
    ) -> AnyViewType? {

        guard let superview = entry.superview,
            let entryIndex = superview.subviews.firstIndex(of: entry),
            entryIndex > 0
        else {
            return nil
        }

        for subview in superview.subviews[0..<entryIndex].reversed() {
            if let typed = subview as? AnyViewType {
                return typed
            }
        }

        return nil
    }

    /// Finds a previous sibling that contains a view controller of the specified type.
    /// This method inspects siblings recursively.
    /// Returns nil if no sibling contains the specified type.
    @available(macOS, unavailable)
    public static func previousSibling<AnyViewControllerType: PlatformViewController>(
        containing type: AnyViewControllerType.Type,
        from entry: PlatformViewController
    ) -> AnyViewControllerType? {

        guard let parent = entry.parent,
            let entryIndex = parent.children.firstIndex(of: entry),
            entryIndex > 0
        else {
            return nil
        }

        for child in parent.children[0..<entryIndex].reversed() {
            if let typed = findChild(ofType: type, in: child) {
                return typed
            }
        }

        return nil
    }

    /// Finds a previous sibling that is a view controller of the specified type.
    /// This method does not inspect siblings recursively.
    /// Returns nil if no sibling is of the specified type.
    public static func previousSibling<AnyViewControllerType: PlatformViewController>(
        ofType type: AnyViewControllerType.Type,
        from entry: PlatformViewController
    ) -> AnyViewControllerType? {

        guard let parent = entry.parent,
            let entryIndex = parent.children.firstIndex(of: entry),
            entryIndex > 0
        else {
            return nil
        }

        for child in parent.children[0..<entryIndex].reversed() {
            if let typed = child as? AnyViewControllerType {
                return typed
            }
        }

        return nil
    }

    /// Finds a next sibling that contains a view of the specified type.
    /// This method inspects siblings recursively.
    /// Returns nil if no sibling contains the specified type.
    public static func nextSibling<AnyViewType: PlatformView>(
        containing type: AnyViewType.Type,
        from entry: PlatformView
    ) -> AnyViewType? {

        guard let superview = entry.superview,
            let entryIndex = superview.subviews.firstIndex(of: entry)
        else {
            return nil
        }

        for subview in superview.subviews[entryIndex..<superview.subviews.endIndex] {
            if let typed = findChild(ofType: type, in: subview) {
                return typed
            }
        }

        return nil
    }

    /// Finds a next sibling that if of the specified type.
    /// This method inspects siblings recursively.
    /// Returns nil if no sibling contains the specified type.
    public static func nextSibling<AnyViewType: PlatformView>(
        ofType type: AnyViewType.Type,
        from entry: PlatformView
    ) -> AnyViewType? {

        guard let superview = entry.superview,
            let entryIndex = superview.subviews.firstIndex(of: entry)
        else {
            return nil
        }

        for subview in superview.subviews[entryIndex..<superview.subviews.endIndex] {
            if let typed = subview as? AnyViewType {
                return typed
            }
        }

        return nil
    }

    /// Finds an ancestor of the specified type.
    /// If it reaches the top of the view without finding the specified view type, it returns nil.
    public static func findAncestor<AnyViewType: PlatformView>(ofType type: AnyViewType.Type, from entry: PlatformView) -> AnyViewType? {
        var superview = entry.superview
        while let s = superview {
            if let typed = s as? AnyViewType {
                return typed
            }
            superview = s.superview
        }
        return nil
    }

    /// Finds an ancestor of the specified type.
    /// If it reaches the top of the view without finding the specified view type, it returns nil.
    public static func findAncestorOrAncestorChild<AnyViewType: PlatformView>(ofType type: AnyViewType.Type, from entry: PlatformView) -> AnyViewType? {
        var superview = entry.superview
        while let s = superview {
            if let typed = s as? AnyViewType ?? findChildUsingFrame(ofType: type, in: s, from: entry) {
                return typed
            }
            superview = s.superview
        }
        return nil
    }

    /// Finds the hosting view of a specific subview.
    /// Hosting views generally contain subviews for one specific SwiftUI element.
    /// For instance, if there are multiple text fields in a VStack, the hosting view will contain those text fields (and their host views, see below).
    /// Returns nil if it couldn't find a hosting view. This should never happen when called with an IntrospectionView.
    public static func findHostingView(from entry: PlatformView) -> PlatformView? {
        var superview = entry.superview
        while let s = superview {
            if NSStringFromClass(type(of: s)).contains("HostingView") {
                return s
            }
            superview = s.superview
        }
        return nil
    }

    /// Finds the view host of a specific view.
    /// SwiftUI wraps each UIView within a ViewHost, then within a HostingView.
    /// Returns nil if it couldn't find a view host. This should never happen when called with an IntrospectionView.
    public static func findViewHost(from entry: PlatformView) -> PlatformView? {
        var superview = entry.superview
        while let s = superview {
            if NSStringFromClass(type(of: s)).contains("ViewHost") {
                return s
            }
            superview = s.superview
        }
        return nil
    }
}

public enum TargetViewSelector {
    public static func siblingContaining<TargetView: PlatformView>(from entry: PlatformView) -> TargetView? {
        guard let viewHost = Introspect.findViewHost(from: entry) else {
            return nil
        }
        return Introspect.previousSibling(containing: TargetView.self, from: viewHost)
    }

    public static func siblingContainingOrAncestor<TargetView: PlatformView>(from entry: PlatformView) -> TargetView? {
        if let sibling: TargetView = siblingContaining(from: entry) {
            return sibling
        }
        return Introspect.findAncestor(ofType: TargetView.self, from: entry)
    }

    public static func siblingContainingOrAncestorOrAncestorChild<TargetView: PlatformView>(from entry: PlatformView) -> TargetView? {
        if let sibling: TargetView = siblingContaining(from: entry) {
            return sibling
        }
        return Introspect.findAncestorOrAncestorChild(ofType: TargetView.self, from: entry)
    }

    public static func siblingOfType<TargetView: PlatformView>(from entry: PlatformView) -> TargetView? {
        guard let viewHost = Introspect.findViewHost(from: entry) else {
            return nil
        }
        return Introspect.previousSibling(ofType: TargetView.self, from: viewHost)
    }

    public static func siblingOfTypeOrAncestor<TargetView: PlatformView>(from entry: PlatformView) -> TargetView? {
        if let sibling: TargetView = siblingOfType(from: entry) {
            return sibling
        }
        return Introspect.findAncestor(ofType: TargetView.self, from: entry)
    }

    public static func ancestorOrSiblingContaining<TargetView: PlatformView>(from entry: PlatformView) -> TargetView? {
        if let tableView = Introspect.findAncestor(ofType: TargetView.self, from: entry) {
            return tableView
        }
        return siblingContaining(from: entry)
    }

    public static func ancestorOrSiblingOfType<TargetView: PlatformView>(from entry: PlatformView) -> TargetView? {
        if let tableView = Introspect.findAncestor(ofType: TargetView.self, from: entry) {
            return tableView
        }
        return siblingOfType(from: entry)
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
