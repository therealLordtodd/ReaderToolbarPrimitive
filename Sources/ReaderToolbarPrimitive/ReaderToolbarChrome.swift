import SwiftUI
import ReaderChromeThemePrimitive
import ReaderSidebarPrimitive

public typealias ReaderToolbarAnnotationPane = ReaderSidebarPane

public struct ReaderToolbarChrome: ToolbarContent {
    @Binding public var activeAnnotationPane: ReaderToolbarAnnotationPane

    public var theme: ReaderChromeTheme?
    public var annotationPanes: [ReaderToolbarAnnotationPane]
    public var isStudioVisible: Bool
    public var showSearchControl: Bool
    public var showStudioControl: Bool
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

    @Environment(\.readerChromeTheme) private var environmentTheme

    public init<ChapterControl: View, AppearanceControl: View, InfoControl: View, ReadAloudControl: View, ReadingSpeedControl: View, TranslationControl: View>(
        activeAnnotationPane: Binding<ReaderToolbarAnnotationPane>,
        theme: ReaderChromeTheme? = nil,
        annotationPanes: [ReaderToolbarAnnotationPane] = [.bookmarks, .highlights, .comments],
        isStudioVisible: Bool,
        showSearchControl: Bool = true,
        showStudioControl: Bool = true,
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
        self.annotationPanes = annotationPanes
        self.isStudioVisible = isStudioVisible
        self.showSearchControl = showSearchControl
        self.showStudioControl = showStudioControl
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
                .font(resolvedTheme.typography.title3)
                .frame(height: Self.toolbarItemHeight)

            appearanceControl
                .font(resolvedTheme.typography.title3)
                .frame(height: Self.toolbarItemHeight)

            infoControl
                .font(resolvedTheme.typography.title3)
                .frame(height: Self.toolbarItemHeight)

            Spacer()
                .frame(width: resolvedTheme.spacing.control)

            ForEach(annotationPanes, id: \.self) { pane in
                annotationButton(for: pane, help: helpText(for: pane))
            }

            readAloudControl
                .font(resolvedTheme.typography.title3)
                .frame(height: Self.toolbarItemHeight)

            readingSpeedControl
                .font(resolvedTheme.typography.title3)
                .frame(height: Self.toolbarItemHeight)

            if showTranslationControl {
                translationControl
                    .font(resolvedTheme.typography.title3)
                    .frame(height: Self.toolbarItemHeight)
            }

            if showSearchControl {
                Button(action: onSearchRequested) {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .help(searchHelp)
                .font(resolvedTheme.typography.title3)
                .frame(height: Self.toolbarItemHeight)
            }

            if showStudioControl {
                Button(action: onStudioToggle) {
                    Label("Studio", systemImage: "brain")
                }
                .help("Toggle Studio (\u{2318}J)")
                .font(resolvedTheme.typography.title3)
                .frame(height: Self.toolbarItemHeight)
                .foregroundStyle(isStudioVisible ? resolvedTheme.colors.infoTint : resolvedTheme.colors.primaryText)
            }
        }
    }

    private func annotationButton(for pane: ReaderToolbarAnnotationPane, help: String) -> some View {
        Button {
            activeAnnotationPane = pane.toggled(from: activeAnnotationPane)
        } label: {
            Label(pane.title, systemImage: pane.systemImage)
        }
        .help(help)
        .font(resolvedTheme.typography.title3)
        .frame(height: Self.toolbarItemHeight)
        .foregroundStyle(
            activeAnnotationPane == pane
                ? resolvedTheme.colors.infoTint
                : resolvedTheme.colors.primaryText
        )
    }

    private func helpText(for pane: ReaderToolbarAnnotationPane) -> String {
        switch pane {
        case .none:
            return "Hide annotation panels"
        case .all:
            return "Toggle all annotations panel"
        case .highlights:
            return "Toggle highlights panel"
        case .comments:
            return "Toggle comments panel"
        case .bookmarks:
            return "Toggle bookmarks panel"
        }
    }

    private static let toolbarItemHeight: CGFloat = 38

    private var resolvedTheme: ReaderChromeTheme {
        theme ?? environmentTheme
    }
}
