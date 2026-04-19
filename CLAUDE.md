# ReaderToolbarPrimitive

> Claude Code loads this file automatically at the start of every session.

## Package Purpose

`ReaderToolbarPrimitive` owns the shared reader toolbar chrome. It exposes `ReaderToolbarChrome`, a `ToolbarContent` that assembles annotation-pane toggles, search, studio toggle, and six host-injected control slots (chapter, appearance, info, read-aloud, reading-speed, translation) with consistent layout and theming.

`ReaderView` composes this primitive internally. Hosts using `ReaderView` do not need to import this package directly. Hosts building custom reader surfaces import this package to get the same toolbar shape without re-implementing it.

**Tech stack:** Swift 6.0 / SwiftUI.

## Key Types

- `ReaderToolbarChrome` — `ToolbarContent`, the main export
- `ReaderToolbarAnnotationPane` — typealias for `ReaderSidebarPane`

## Dependencies

- `ReaderChromeThemePrimitive` — theme tokens consumed by the toolbar
- `ReaderSidebarPrimitive` — source of the `ReaderSidebarPane` type the toolbar shares for annotation-pane tabs

## Architecture Rules

- **Host injects, primitive arranges.** The toolbar does not own the content of its six control slots — hosts inject `ChapterControl`, `AppearanceControl`, etc. The primitive owns layout, spacing, and theming across those slots.
- **Pane state is bound, not owned.** The annotation-pane toggles are driven by `Binding<ReaderToolbarAnnotationPane>`. The host (or `ReaderKit`) owns pane state so the toolbar and sidebar stay in sync.
- **Keep this package focused on reusable reader toolbar chrome.** Host-specific popover internals, menu bodies, or product-specific control content do not belong here.
- **All theme access is via environment.** The toolbar reads `@Environment(\.readerChromeTheme)` indirectly through its sub-views; hosts inject the theme via `.readerChromeTheme(_:)` on the parent view.

## Primary Documentation

- Host-facing usage + API reference: `/Users/todd/Programming/Packages/ReaderToolbarPrimitive/README.md`
- Portfolio integration guide: `/Users/todd/Programming/Packages/ReaderKit/docs/reader-stack-integration-guide.md`

When answering toolbar questions, prefer the README first. For how the toolbar fits into the broader reader stack, go to the integration guide.

## Primitives-First Development

This primitive does one thing: it is the reader toolbar. Questions to ask before extending:

1. Is the proposed addition reader-toolbar-shaped, or is it a host concern that should stay in the host?
2. Does it fit in one of the existing six slots, or does it genuinely need a seventh? If seventh, flag the cross-cutting change.
3. Is it consumed by more than one host? Host-specific toolbar features stay in the host.

## GitHub Repository Visibility

- This repository is **private**. Do not change visibility without Todd's explicit request.
