import Testing
import SwiftUI
@testable import ReaderToolbarPrimitive

@Test func readerToolbarAnnotationPaneToggleIsMutuallyExclusive() {
    #expect(ReaderToolbarAnnotationPane.highlights.toggled(from: .none) == .highlights)
    #expect(ReaderToolbarAnnotationPane.highlights.toggled(from: .highlights) == .none)
    #expect(ReaderToolbarAnnotationPane.comments.toggled(from: .bookmarks) == .comments)
}

@MainActor
@Test func readerToolbarChromePublicSurfaceLoads() {
    let activePane = Binding.constant(ReaderToolbarAnnotationPane.none)

    _ = ReaderToolbarChrome(
        activeAnnotationPane: activePane,
        annotationPanes: [.all, .highlights, .comments, .bookmarks],
        isStudioVisible: false,
        showSearchControl: true,
        showStudioControl: false,
        showTranslationControl: true,
        searchHelp: "Find in book",
        onSearchRequested: {},
        onStudioToggle: {},
        chapterControl: { Text("Chapters") },
        appearanceControl: { Text("Appearance") },
        infoControl: { Text("Info") },
        readAloudControl: { Text("Read Aloud") },
        readingSpeedControl: { Text("Speed") },
        translationControl: { Text("Translate") }
    )
}
