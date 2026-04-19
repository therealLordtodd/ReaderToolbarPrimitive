# ReaderToolbarPrimitive

`ReaderToolbarPrimitive` is the shared reader toolbar chrome for the portfolio. It exposes `ReaderToolbarChrome`, a `ToolbarContent` that composes the standard reader controls — annotation-pane toggles, search, studio visibility toggle, and host-provided chapter / appearance / info / read-aloud / speed / translation controls — with consistent layout and theming.

Use it whenever a host app surfaces a reader experience and wants the same toolbar shape every other reader in the portfolio has. Do not build a parallel reader toolbar in the host.

## What The Package Gives You

- `ReaderToolbarChrome` — a `ToolbarContent` that drops into a SwiftUI toolbar
- `ReaderToolbarAnnotationPane` — typealias for `ReaderSidebarPane` (annotation pane enum: `.none`, `.all`, `.highlights`, `.comments`, `.bookmarks`)
- annotation-pane toggle buttons that drive a host-held `Binding<ReaderToolbarAnnotationPane>`
- a search button with host-specified help text and callback
- a studio visibility toggle with host-specified callback
- a translation indicator driven by a `showTranslationControl` flag
- six host-injected control slots (chapter, appearance, info, read-aloud, reading-speed, translation) that the host owns entirely

## When To Use It

- You are building a host that uses `ReaderKit` and want toolbar chrome consistent with Noema, Vantage, and Data Estate reader surfaces
- You are using `ReaderView` directly (it composes this primitive internally) — no need to import this package yourself in that case
- You are building a custom reader surface and want just the toolbar shell

## When Not To Use It

- You want a toolbar for non-reader surfaces (use SwiftUI's `ToolbarItem` / `ToolbarItemGroup` directly)
- You want reader chrome without a toolbar (use `ReaderView` without overriding toolbar behavior)
- You want to add a *seventh* control slot that doesn't fit the existing six (flag the use case rather than forking the toolbar)

## Install

```swift
dependencies: [
    .package(path: "../ReaderToolbarPrimitive"),
],
targets: [
    .target(
        name: "MyReaderHost",
        dependencies: ["ReaderToolbarPrimitive"]
    )
]
```

This package depends on `ReaderChromeThemePrimitive` and `ReaderSidebarPrimitive` transitively.

## Basic Usage

### Inside `ReaderView` (the common case)

If you are using `ReaderView` from `ReaderKit`, you already get this toolbar. Do not import `ReaderToolbarPrimitive` directly — `ReaderView` composes it internally.

### In a custom reader surface

If you are building a custom reader (not using `ReaderView`), mount the toolbar via SwiftUI's `.toolbar` modifier:

```swift
import ReaderChromeThemePrimitive
import ReaderSidebarPrimitive
import ReaderToolbarPrimitive
import SwiftUI

struct CustomReaderView: View {
    @State private var activePane: ReaderToolbarAnnotationPane = .none
    @State private var isStudioVisible = false

    var body: some View {
        ReaderContent(
            activePane: $activePane,
            isStudioVisible: $isStudioVisible
        )
        .toolbar {
            ReaderToolbarChrome(
                activeAnnotationPane: $activePane,
                theme: .default,
                annotationPanes: ReaderSidebarPane.standardAnnotationPanes,
                isStudioVisible: isStudioVisible,
                showSearchControl: true,
                showStudioControl: true,
                showTranslationControl: false,
                searchHelp: "Search this document",
                onSearchRequested: { focusSearchField() },
                onStudioToggle: { isStudioVisible.toggle() },
                chapterControl: { ChapterMenuButton() },
                appearanceControl: { AppearanceMenuButton() },
                infoControl: { InfoMenuButton() },
                readAloudControl: { ReadAloudButton() },
                readingSpeedControl: { ReadingSpeedButton() },
                translationControl: { TranslationStatusView() }
            )
        }
        .readerChromeTheme(.default)
    }
}
```

### Hiding controls the host does not provide

Every control slot is required, but the host can provide `EmptyView()` for slots that don't apply. The toolbar already suppresses the studio and translation surfaces when the corresponding `show*Control` flags are `false`.

```swift
ReaderToolbarChrome(
    activeAnnotationPane: $activePane,
    theme: .default,
    isStudioVisible: false,
    showSearchControl: true,
    showStudioControl: false,       // hides studio button
    showTranslationControl: false,   // hides translation indicator
    searchHelp: "Search",
    onSearchRequested: focusSearch,
    onStudioToggle: { },
    chapterControl: { EmptyView() },    // no chapter control
    appearanceControl: { AppearanceMenuButton() },
    infoControl: { EmptyView() },        // no info control
    readAloudControl: { EmptyView() },
    readingSpeedControl: { EmptyView() },
    translationControl: { EmptyView() }
)
```

## Control Slot Semantics

The six injected control slots are strongly suggestive but not enforced:

| Slot | Typical content |
|------|-----------------|
| `chapterControl` | chapter-nav dropdown / back-forward chapter buttons |
| `appearanceControl` | font-size / typography / dark-mode toggle |
| `infoControl` | book or document info popover (title, author, metadata) |
| `readAloudControl` | play/pause for text-to-speech |
| `readingSpeedControl` | speed slider or menu for read-aloud |
| `translationControl` | current-language indicator or translation-pane shortcut |

Hosts that do not need a slot should pass `EmptyView()` — do not smuggle unrelated controls into existing slots just because they have room.

## Integration Guide

This package is one of the shared reader chrome primitives. For how the toolbar fits into the broader reader stack (how it composes with sidebars, selection bars, search, annotation storage, etc.), see:

- `Packages/ReaderKit/docs/reader-stack-integration-guide.md`

## Design Notes

The toolbar is `ToolbarContent`, not a `View`. It must be attached via `.toolbar { ... }` on a parent view. That keeps it honest — it cannot be mounted as a standalone UI element; it belongs in a toolbar region.

Annotation-pane tabs are driven by `Binding<ReaderToolbarAnnotationPane>`. The primitive does not own pane state — the host (typically `ReaderSidebarPrimitive` or `ReaderKit`) does. That keeps pane activation consistent between the toolbar buttons and the sidebar tabs.

The `ReaderToolbarAnnotationPane` typealias points to `ReaderSidebarPane` in `ReaderSidebarPrimitive`. The two packages share the same enum on purpose — a toggle in the toolbar and a tab in the sidebar are the same concept.
