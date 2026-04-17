import SwiftUI
import ReaderChromeThemePrimitive

public enum ReaderToolbarAnnotationPane: String, CaseIterable, Sendable {
    case none
    case highlights
    case comments
    case bookmarks

    public var title: String {
        switch self {
        case .none:
            return "None"
        case .highlights:
            return "Highlights"
        case .comments:
            return "Comments"
        case .bookmarks:
            return "Bookmarks"
        }
    }

    public var systemImage: String {
        switch self {
        case .none:
            return "sidebar.trailing"
        case .highlights:
            return "highlighter"
        case .comments:
            return "text.bubble"
        case .bookmarks:
            return "bookmark"
        }
    }

    public func toggled(from activePane: ReaderToolbarAnnotationPane) -> ReaderToolbarAnnotationPane {
        activePane == self ? .none : self
    }
}

public struct ReaderToolbarChrome: ToolbarContent {
    @Binding public var activeAnnotationPane: ReaderToolbarAnnotationPane

    public var theme: ReaderChromeTheme
    public var isStudioVisible: Bool
    public var showTranslationControl: Bool
    public var searchHelp: String
    public var onSearchRequested: () -> Void
    public var onStudioToggle: () -> Void

    private let chapterControl: AnyView
    private let appearanceControl: AnyView
    private let infoControl: AnyView
    private let readAloudControl: AnyView
    private let readingSpeedControl: AnyView
    private let translationControl: AnyView

    public init<ChapterControl: View, AppearanceControl: View, InfoControl: View, ReadAloudControl: View, ReadingSpeedControl: View, TranslationControl: View>(
        activeAnnotationPane: Binding<ReaderToolbarAnnotationPane>,
        theme: ReaderChromeTheme,
        isStudioVisible: Bool,
        showTranslationControl: Bool,
        searchHelp: String,
        onSearchRequested: @escaping () -> Void,
        onStudioToggle: @escaping () -> Void,
        @ViewBuilder chapterControl: () -> ChapterControl,
        @ViewBuilder appearanceControl: () -> AppearanceControl,
        @ViewBuilder infoControl: () -> InfoControl,
        @ViewBuilder readAloudControl: () -> ReadAloudControl,
        @ViewBuilder readingSpeedControl: () -> ReadingSpeedControl,
        @ViewBuilder translationControl: () -> TranslationControl
    ) {
        self._activeAnnotationPane = activeAnnotationPane
        self.theme = theme
        self.isStudioVisible = isStudioVisible
        self.showTranslationControl = showTranslationControl
        self.searchHelp = searchHelp
        self.onSearchRequested = onSearchRequested
        self.onStudioToggle = onStudioToggle
        self.chapterControl = AnyView(chapterControl())
        self.appearanceControl = AnyView(appearanceControl())
        self.infoControl = AnyView(infoControl())
        self.readAloudControl = AnyView(readAloudControl())
        self.readingSpeedControl = AnyView(readingSpeedControl())
        self.translationControl = AnyView(translationControl())
    }

    public var body: some ToolbarContent {
        ToolbarItemGroup {
            chapterControl
                .font(theme.typography.title3)
                .frame(height: Self.toolbarItemHeight)

            appearanceControl
                .font(theme.typography.title3)
                .frame(height: Self.toolbarItemHeight)

            infoControl
                .font(theme.typography.title3)
                .frame(height: Self.toolbarItemHeight)

            Spacer()
                .frame(width: theme.spacing.control)

            annotationButton(for: .bookmarks, help: "Toggle bookmarks panel")
            annotationButton(for: .highlights, help: "Toggle highlights panel (\u{2318}L)")
            annotationButton(for: .comments, help: "Toggle comments panel (\u{2318}N)")

            readAloudControl
                .font(theme.typography.title3)
                .frame(height: Self.toolbarItemHeight)

            readingSpeedControl
                .font(theme.typography.title3)
                .frame(height: Self.toolbarItemHeight)

            if showTranslationControl {
                translationControl
                    .font(theme.typography.title3)
                    .frame(height: Self.toolbarItemHeight)
            }

            Button(action: onSearchRequested) {
                Label("Search", systemImage: "magnifyingglass")
            }
            .help(searchHelp)
            .font(theme.typography.title3)
            .frame(height: Self.toolbarItemHeight)

            Button(action: onStudioToggle) {
                Label("Studio", systemImage: "brain")
            }
            .help("Toggle Studio (\u{2318}J)")
            .font(theme.typography.title3)
            .frame(height: Self.toolbarItemHeight)
            .foregroundStyle(isStudioVisible ? theme.colors.infoTint : theme.colors.primaryText)
        }
    }

    private func annotationButton(for pane: ReaderToolbarAnnotationPane, help: String) -> some View {
        Button {
            activeAnnotationPane = pane.toggled(from: activeAnnotationPane)
        } label: {
            Label(pane.title, systemImage: pane.systemImage)
        }
        .help(help)
        .font(theme.typography.title3)
        .frame(height: Self.toolbarItemHeight)
        .foregroundStyle(activeAnnotationPane == pane ? theme.colors.infoTint : theme.colors.primaryText)
    }

    private static let toolbarItemHeight: CGFloat = 38
}
