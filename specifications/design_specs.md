````md
# TaoPulse Design Specification
Version: MVP v1.0  
Platform: iOS / Android (Flutter)  
Theme: AI-native realtime Bittensor intelligence platform

---

# 1. Design Philosophy

TaoPulse should feel:

- intelligent
- realtime
- premium
- focused
- operational
- AI-native
- financial-grade

The experience should resemble:

- Perplexity
- Linear
- modern Bloomberg terminal
- AI copilot products

Avoid:
- noisy crypto aesthetics
- excessive cyberpunk neon
- gamified UI
- cluttered dashboards

---

# 2. Visual Identity

## Design Keywords

- Dark intelligence
- Ambient glow
- Signal-focused
- Minimal but alive
- Futuristic but readable
- Realtime ecosystem awareness

---

# 3. Layout System

## Global Screen Structure

```txt
SafeArea
 ├── Top Bar
 ├── Filters / Controls
 ├── Main Scroll Content
 ├── Floating Input / CTA (optional)
 └── Bottom Navigation
````

---

## Global Spacing

| Token   | Value |
| ------- | ----- |
| xs      | 4     |
| sm      | 8     |
| md      | 12    |
| lg      | 16    |
| xl      | 20    |
| xxl     | 24    |
| section | 32    |

---

# 2.1 Color Tokens

## Brand
| Token           | Value   |
| --------------- | ------- |
| primary         | #6F4BBC |
| primary-light   | #9B7FE8 |
| primary-dark    | #4E3190 |

## Background
| Token      | Value   |
| ---------- | ------- |
| bg-primary | #050816 |
| bg-surface | #0B1023 |
| bg-card    | #11182D |
| bg-hover   | #161F3A |
| border     | rgba(255,255,255,0.06) |

## Text
| Token          | Value                  |
| -------------- | ---------------------- |
| text-primary   | #FFFFFF                |
| text-secondary | rgba(255,255,255,0.72) |
| text-muted     | rgba(255,255,255,0.50) |
| text-disabled  | rgba(255,255,255,0.32) |

## Semantic
| Token    | Value   |
| -------- | ------- |
| success  | #22C55E |
| warning  | #F59E0B |
| critical | #EF4444 |
| info     | #3B82F6 |

---

# 2.2 Typography Tokens

## Scale
| Token        | Size | Weight | Line Height |
| ------------ | ---- | ------ | ----------- |
| hero         | 34   | 700    | 40          |
| screen-title | 28   | 700    | 34          |
| section      | 20   | 600    | 28          |
| card-title   | 18   | 600    | 24          |
| body         | 15   | 400    | 22          |
| caption      | 13   | 400    | 18          |
| metadata     | 11   | 500    | 16          |

---

## Safe Area

| Area                    | Value |
| ----------------------- | ----- |
| Horizontal Padding      | 20    |
| Top Padding             | 16-24 |
| Bottom Navigation Space | 100+  |

---

# 4. Navigation System

## Bottom Navigation Tabs

| Tab       | Purpose                      |
| --------- | ---------------------------- |
| Feed      | realtime ecosystem awareness |
| Watchlist | tracked entities             |
| Ask AI    | AI copilot                   |
| Alerts    | notification center          |
| Profile   | account/settings             |

---

## Bottom Navigation Style

### Active State

* brighter icon
* purple gradient glow
* stronger opacity
* elevated feel

### Inactive State

```css
color: rgba(255,255,255,0.55)
```

---

## Ask AI Navigation Button

This is the central brand element.

### Rules

* larger than other tabs
* floating orb style
* gradient background
* ambient glow
* subtle pulse animation

---

# 5. Top Bar Specification

## Standard Top Bar

### Left

* Screen title
* Optional logo

### Right

* Search
* Filter
* Notifications
* Profile icon

---

## Top Bar Height

```txt
56-64px
```

---

# 6. Color System

## Background Colors

| Usage              | Color                  |
| ------------------ | ---------------------- |
| Primary Background | #050816                |
| Secondary Surface  | #0B1023                |
| Elevated Card      | #11182D                |
| Hover Surface      | #161F3A                |
| Divider Border     | rgba(255,255,255,0.06) |

---

## Primary Brand Gradient

```css
#7B5CFF → #A855F7 → #4F8CFF
```

Used for:

* active navigation
* AI actions
* CTA buttons
* highlights
* selected states

---

## Semantic Colors

### Success

```css
#22C55E
```

### Warning

```css
#F59E0B
```

### Critical

```css
#EF4444
```

### Info

```css
#3B82F6
```

### AI Purple

```css
#8B5CF6
```

---

## Text Colors

| Usage          | Color                  |
| -------------- | ---------------------- |
| Primary Text   | #FFFFFF                |
| Secondary Text | rgba(255,255,255,0.72) |
| Muted Text     | rgba(255,255,255,0.50) |
| Disabled Text  | rgba(255,255,255,0.32) |

---

# 7. Glow & Shadow System

## Glow Rules

Glow should:

* remain soft
* low opacity
* blurred
* minimal

Avoid:

* hard neon edges
* excessive bloom
* strong outer glows

---

## Standard Glow

```css
box-shadow: 0 0 24px rgba(139,92,246,0.18)
```

---

## Card Shadow

```css
0 8px 32px rgba(0,0,0,0.35)
```

---

# 8. Typography System

## Font Family

Primary:

* Inter

Fallback:

* SF Pro Display
* Plus Jakarta Sans

---

# Typography Scale

| Role           | Size  | Weight |
| -------------- | ----- | ------ |
| Hero           | 34    | 700    |
| Screen Title   | 28    | 700    |
| Section Header | 20    | 600    |
| Card Title     | 18    | 600    |
| Body           | 15-16 | 400    |
| Caption        | 13    | 400    |
| Metadata       | 11-12 | 500    |

---

# Typography Rules

## Headlines

* tighter spacing
* slightly reduced line height

## Body Text

* maintain readability
* avoid overly dim gray

## Numeric Data

Use:

* semibold
* brighter emphasis
* aligned spacing

Examples:

* TAO amounts
* percentages
* subnet metrics

---

# 9. Card System

## Standard Card Style

```css
background: rgba(17,24,45,0.92)
border: 1px solid rgba(255,255,255,0.06)
border-radius: 24px
```

---

# Corner Radius System

| Element     | Radius |
| ----------- | ------ |
| Main Cards  | 24     |
| Small Cards | 20     |
| Buttons     | 16     |
| Pills       | 999    |
| Modals      | 32     |

---

# Card Types

| Card         | Usage              |
| ------------ | ------------------ |
| Feed Card    | network activity   |
| Alert Card   | notifications      |
| Insight Card | AI summaries       |
| Metric Card  | statistics         |
| Action Card  | settings/watchlist |

---

# 10. Feed Screen Specification

## Feed Layout

```txt
Top Bar
Category Filters
Priority Controls
Live Feed List
Bottom Navigation
```

---

# Feed Categories

* All
* Subnets
* Stake
* Validators
* Governance
* GitHub
* AI Insights

---

# Feed Card Structure

## Required Elements

* category
* title
* explanation
* timestamp
* impact level
* tags
* AI insight
* action affordance

---

## Impact Levels

| Level    | Color  |
| -------- | ------ |
| Critical | Red    |
| High     | Orange |
| Medium   | Blue   |
| Low      | Gray   |

---

## AI Insight Style

```txt
✨ AI Insight
```

Purpose:

* contextual explanation
* implications
* simplified interpretation

---

# 11. Ask AI Screen Specification

## Purpose

Ask AI is:

* ecosystem copilot
* network intelligence assistant
* realtime explainer

Not:

* generic chatbot

---

# Ask AI Layout

```txt
Top Bar
Live Status Strip
Hero Prompt
Suggested Questions
Recent Conversations
Floating AI Input
Bottom Navigation
```

---

# Suggested Questions

Should feel:

* proactive
* ecosystem-aware
* contextual

Examples:

* Why is SN19 moving today?
* Which validators changed weights?
* Any unusual stake movement?
* What risks matter today?

---

# AI Input Design

## Features

* floating glass container
* microphone button
* send action
* contextual placeholder

---

# Voice Input

Use:

* subtle waveform animation
* minimal pulse effect

Avoid:

* loud recording animations

---

# 12. Alerts Screen Specification

## Alerts Purpose

Alerts should feel:

* operational
* meaningful
* actionable

Not:

* spammy notifications

---

# Alerts Layout

```txt
Top Bar
Alert Filters
Alert Feed
Bottom Navigation
```

---

# Alert Filters

* All
* Unread
* Critical
* Watchlist

---

# Alert Card Actions

Recommended:

* Ask AI
* View Details
* Open Feed
* View Wallet
* View Subnet

---

# Alert Setup UX

## MVP Approach

Preset-based toggles:

* emission changes
* stake movement
* validator activity
* unusual activity
* deregistration risks
* GitHub releases

Avoid:

* complex rule builders initially

---

# 13. Profile Screen Specification

## Purpose

Simple operational account center.

---

# Profile Layout

```txt
Profile Header
User Stats
Settings Sections
Bottom Navigation
```

---

# Profile Sections

* Watching
* Notification Settings
* AI Preferences
* Connected Wallets
* Appearance
* Data & Privacy
* Help & Support

---

# 14. Watchlist Screen Specification

## Purpose

Personalized monitoring dashboard.

---

# Watchlist Entities

* subnets
* validators
* miners
* wallets
* governance proposals

---

# Watchlist Features

* follow/unfollow
* priority watch
* quick alerts
* recent activity
* AI summaries

---

# 15. Motion System

## Motion Philosophy

Animations should:

* communicate state
* reinforce intelligence
* remain subtle

---

# Recommended Motion

* fade transitions
* blur transitions
* shimmer loading
* breathing glow
* soft scale
* live pulse indicators

---

# Avoid

* bouncing
* elastic motion
* spinning effects
* flashy transitions

---

# 16. Iconography

## Icon Style

Use:

* rounded outline icons
* thin-medium stroke
* modern/futuristic feel

Recommended:

* Lucide Icons

---

# 17. Component Specifications

## Pills / Tags

```txt
Height: 28-32
Padding X: 12
Radius: 999
```

---

## Buttons

### Primary

* purple gradient
* glow

### Secondary

* dark elevated surface

### Ghost

* transparent

---

## Toggles

* purple active state
* soft glow
* smooth transition

---

# 18. Blur & Glassmorphism

Use sparingly.

Correct:

* subtle elevated blur
* readable transparency

Avoid:

* excessive frosted glass
* blurry unreadable surfaces

---

# 19. Accessibility

## Minimum Touch Target

```txt
44x44
```

---

## Contrast

Maintain:

* readable contrast ratios
* bright actionable elements
* visible disabled states

---

# 20. Flutter Design Tokens

## AppColors

```dart
class AppColors {
  static const bgPrimary = Color(0xFF050816);
  static const surface = Color(0xFF11182D);
  static const purple = Color(0xFF8B5CF6);
}
```

---

## AppRadius

```dart
class AppRadius {
  static const card = 24.0;
  static const button = 16.0;
  static const pill = 999.0;
}
```

---

## AppSpacing

```dart
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
}
```

---

# 21. Consistency Rules

## Never Hardcode

Avoid hardcoding:

* spacing
* radiuses
* colors
* typography
* shadows

Everything should come from:

* AppColors
* AppTypography
* AppSpacing
* AppRadius
* AppShadows

---

# 22. MVP Visual Priorities

Highest polish priority:

1. Feed
2. Ask AI
3. Alerts
4. Bottom Navigation
5. AI interactions

Profile/settings can remain simpler initially.

---

# 23. Final Product Direction

TaoPulse should feel like:

> “An AI-powered realtime operating system for the Bittensor ecosystem.”

Not:

* generic crypto tracker
* chatbot wrapper
* dashboard clone
* social feed app

This distinction defines the product identity.

```
```
