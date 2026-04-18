# ClipNet iOS App

SwiftUI app for the ClipNet clip campaign marketplace. Built for iOS 16+.

## Project Setup (Xcode)

1. Open Xcode → File → New → Project
2. Choose **App** under iOS
3. Set:
   - Product Name: `ClipNet`
   - Bundle ID: `com.yourname.clipnet`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Minimum Deployment: **iOS 16.0**
4. Delete the auto-generated `ContentView.swift` and `ClipNetApp.swift`
5. Drag all folders from this directory into the Xcode project navigator:
   - `Models/`
   - `ViewModels/`
   - `Views/`
   - `DesignSystem.swift`
   - `ContentView.swift`
   - `ClipNetApp.swift`
6. When prompted, check **"Copy items if needed"** and **"Create groups"**
7. Build and run (⌘R)

## File Structure

```
ClipNet/
├── ClipNetApp.swift          — @main entry point
├── ContentView.swift         — Role router
├── DesignSystem.swift        — Colors, typography, modifiers
│
├── Models/
│   └── AppModels.swift       — All data types (Campaign, ClipSubmission, etc.)
│
├── ViewModels/
│   └── AppViewModel.swift    — App state, sample data, actions
│
└── Views/
    ├── Onboarding/
    │   └── RoleSelectView.swift      — Brand / Clipper role picker
    │
    ├── Brand/
    │   ├── BrandTabView.swift        — Brand tab bar + placeholders
    │   ├── BrandDashboardView.swift  — Campaign list + stats
    │   ├── CampaignDetailView.swift  — Per-campaign deep dive
    │   └── CreateCampaignView.swift  — New campaign sheet
    │
    ├── Clipper/
    │   ├── ClipperTabView.swift      — Clipper tab bar + account settings
    │   ├── BrowseCampaignsView.swift — Campaign discovery + filters
    │   ├── CampaignApplyView.swift   — Apply to clip detail
    │   ├── MyClipsView.swift         — Submitted clips list
    │   └── ClipperEarningsView.swift — Earnings dashboard
    │
    └── Shared/
        └── SharedComponents.swift   — StatCard, PlatformTag, buttons, etc.
```

## Architecture

- **Pattern**: MVVM with a single `AppViewModel` (`@EnvironmentObject`)
- **Navigation**: `NavigationStack` + `TabView`
- **State**: `@Published` on ViewModel, `@State` for local UI
- **No third-party dependencies** — pure SwiftUI + Foundation

## Design System

| Token | Value |
|-------|-------|
| Navy | `#0A1628` |
| Amber | `#F5A623` (primary accent) |
| Teal | `#10B9A7` (clipper accent) |
| Surface | `#F8F9FA` |
| Border | `#E5E7EB` |

## Next Steps (Phase 2 hooks)

- Replace sample data in `AppViewModel` with real API calls
- Add OAuth flow in `ClipperSettingsView` (TikTok, IG, YouTube)
- Wire up Stripe payout via backend in `ClipperEarningsView`
- Add real clip URL validation + view count fetch in `SubmitClipView`
- Integrate push notifications for campaign milestone alerts
