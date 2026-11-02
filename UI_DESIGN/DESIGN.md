---
name: MediXa Clinical Mobile
colors:
  surface: '#f6fafd'
  surface-dim: '#d6dbdd'
  surface-bright: '#f6fafd'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f0f4f7'
  surface-container: '#eaeef1'
  surface-container-high: '#e5e9ec'
  surface-container-highest: '#dfe3e6'
  on-surface: '#171c1f'
  on-surface-variant: '#4c444c'
  inverse-surface: '#2c3134'
  inverse-on-surface: '#edf1f4'
  outline: '#7d747d'
  outline-variant: '#cfc3cd'
  surface-tint: '#73537b'
  primary: '#42264a'
  on-primary: '#ffffff'
  primary-container: '#5a3c62'
  on-primary-container: '#cfa9d6'
  inverse-primary: '#e1bae7'
  secondary: '#366668'
  on-secondary: '#ffffff'
  secondary-container: '#baecee'
  on-secondary-container: '#3c6c6e'
  tertiary: '#222f50'
  on-tertiary: '#ffffff'
  tertiary-container: '#394668'
  on-tertiary-container: '#a7b4dc'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#fad7ff'
  primary-fixed-dim: '#e1bae7'
  on-primary-fixed: '#2b1034'
  on-primary-fixed-variant: '#5a3c62'
  secondary-fixed: '#baecee'
  secondary-fixed-dim: '#9ecfd1'
  on-secondary-fixed: '#002021'
  on-secondary-fixed-variant: '#1b4e50'
  tertiary-fixed: '#dae2ff'
  tertiary-fixed-dim: '#b9c6ef'
  on-tertiary-fixed: '#0c1a3a'
  on-tertiary-fixed-variant: '#394668'
  background: '#f6fafd'
  on-background: '#171c1f'
  surface-variant: '#dfe3e6'
typography:
  headline-lg:
    fontFamily: Cairo
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 44px
  headline-lg-mobile:
    fontFamily: Cairo
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 36px
  headline-md:
    fontFamily: Cairo
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 32px
  headline-sm:
    fontFamily: Cairo
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 26px
  title-lg:
    fontFamily: Cairo
    fontSize: 16px
    fontWeight: '700'
    lineHeight: 24px
  title-md:
    fontFamily: Cairo
    fontSize: 15px
    fontWeight: '600'
    lineHeight: 22px
  body-lg:
    fontFamily: Cairo
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Cairo
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Cairo
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 18px
  label-lg:
    fontFamily: Cairo
    fontSize: 13px
    fontWeight: '600'
    lineHeight: 18px
  label-md:
    fontFamily: Cairo
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 16px
  label-sm:
    fontFamily: Cairo
    fontSize: 10px
    fontWeight: '500'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 0.75rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
---

## Brand & Style
The design system powers an enterprise-grade mobile clinical workspace for pharmacists and pharmacy technicians operating in high-tempo retail and hospital environments. The visual language blends authoritative clinical precision with welcoming, non-fatiguing softness tailored specifically for handheld Android devices. 

The emotional tone balances high-trust pharmacology, operational clarity, and intuitive speed. Rooted in Modern Material 3 guidelines and tuned for right-to-left (RTL) Arabic typography, the style minimizes visual clutter through clear structural hierarchy, high-contrast textual legibility, calm medical tints, and purposeful, non-distracting elevation layers. Physical buttons, inventory cards, and prescription tallies provide immediate haptic and visual feedback, fostering absolute confidence during rapid medication dispensing and inventory auditing.

## Colors
The color palette establishes deliberate functional separation across workflow states:

- **Primary Plum (`#5A3C62`) & Light Accent (`#9D7EA6`):** Governs executive navigation, primary call-to-actions, brand identity anchors, and system-level triggers. The primary gradient (`linear-gradient(135deg, #5A3C62 0%, #CAAFD1 100%)`) is reserved for high-impact metric cards, AI assistant headers, and primary checkout floating action buttons.
- **Secondary Teal (`#3A6A6C`) & Light Accent (`#78BFC1`):** Applied to active inventory tracking, clinical confirmation states, secondary actions, and diagnostic metrics. The secondary gradient (`linear-gradient(135deg, #3A6A6C 0%, #78BFC1 100%)`) highlights dispense progress and operational analytics.
- **Tertiary Navy (`#374466`) & Light Accent (`#5A6A8C`):** Used for administrative data, structural tables, batch tracking indicators, and auxiliary controls.
- **Neutral Canvas (`#F4F8FB`) & Card Surface (`#FFFFFF`):** The cool neutral background prevents eye fatigue under fluorescent pharmacy lighting while crisp white surfaces separate distinct functional card clusters.
- **Text Layers:** High-contrast `#000000` for primary medical titles, SKU codes, and prices; muted `#5A5A5A` for Arabic metadata, dosage notes, and secondary timestamps.
- **Dividers & Strokes:** `#E0E0E0` for structural outlines and subtle container dividers; `#9E9E9E` for inactive icons and placeholder states.
- **Semantic Clinical Tiers:**
  - **Success:** `#ABFDC3` background with `#036C2A` text (in-stock, verified dosage, completed transaction).
  - **Error / Critical:** `#FFC9C8` background with `#D32F2F` text (expired batch, dangerous interaction, zero stock).
  - **Warning:** `#FFDCA7` background with `#A95704` text (near expiry, low threshold, pending approval).
  - **Info:** `#BFECFA` background with `#02A1D1` text (storage conditions, generic alternative available).

## Typography
Cairo is deployed consistently across all Arabic and Latin numerical outputs. Its balanced geometric letterforms provide exceptional legibility for Arabic script diacritics and compact prescription notes.

- **RTL Baseline Alignment:** Because Arabic glyphs possess taller ascenders and deep descenders compared to Latin alphabets, baseline heights are spaced generously (`lineHeight` multiplier between 1.35x and 1.5x) to prevent collision with medication accents or vocalization marks.
- **Tabular Numerals:** For currency (SAR / EGP / USD), batch expiration dates, dosage quantities, and barcode figures, numeral representations leverage proportional monospacing (`font-feature-settings: "tnum"`) to maintain strict vertical alignment across itemized carts and inventory tables.
- **Hierarchical Discipline:** `headline-lg-mobile` anchors dashboard revenue counters; `headline-sm` titles screens and modular dialogs; `title-md` and `title-lg` label medicine brand names; `body-md` handles active clinical instructions; `label-md` and `label-sm` govern status badges, expiration chips, and navigation items.

## Layout & Spacing
The layout adheres to an Android fluid mobile grid structured around a strict 4px/8px incremental rhythm:

- **Canvas Enclosure & Safe Areas:** The primary screen margins are anchored at `margin` (`16px`). Edge-to-edge Android displays strictly respect `WindowInsets` (Status bar top padding and Gesture Navigation bar bottom inset) to prevent overlap with clinical actions or the bottom navigation bar.
- **Grid Structure:** A 4-column fluid mobile grid with `gutter` (`12px`) accommodates compact two-column medication catalog displays, fast POS grid tiles, and dual metric summaries.
- **RTL Reflow Mechanics:** All directional layouts flip across the vertical axis. Start margins become physical right margins (`margin-right`); action arrows point to the left (`chevron_left` denotes progression); trailing badges dock at the physical left; trailing close/clear inputs anchor left.
- **Vertical Spacing Rhythm:** Component stacks utilize `space-md` (`12px`) between sibling cards and `space-xl` (`24px`) between distinct functional screen blocks (e.g., Quick Stats to Low Stock Alerts).

## Elevation & Depth
Depth conveys tactile touchability without introducing heavy, distracting drop shadows:

- **Level 0 (Flat Ground):** `#F4F8FB` serves as the canvas substrate for scrollable bodies and non-interactive backgrounds.
- **Level 1 (Surface Cards & Lists):** Pure `#FFFFFF` surface cards utilize an ambient shadow: `box-shadow: 0px 2px 8px rgba(55, 68, 102, 0.05)`, rimmed with a subtle border of `1px solid #E0E0E0`. This neutralizes optical wash on bright IPS/AMOLED mobile screens.
- **Level 2 (Dropdowns, Floating Actions, Bottom Sheet):** Elevated panels and dialogs employ `box-shadow: 0px 6px 20px rgba(90, 60, 98, 0.12)` to establish clear foreground dominance.
- **Level 3 (Modal Alerts & Barcode Scanner Overlay):** Heavy scrim overlay (`rgba(30, 20, 35, 0.45)`) paired with `box-shadow: 0px 12px 32px rgba(0, 0, 0, 0.20)` for high-risk drug interaction warnings and batch deletion prompts.
- **Tonal Contrast:** AI Assistant dialogue and quick-action surfaces utilize soft tinted fills rather than heavy drop shadows, reinforcing seamless tactile containment.

## Shapes
A unified radius architecture defines interactive ergonomics across thumb-reachable target zones:

- **Standard Cards & Surfaces:** Configured strictly with `16px` (`rounded-lg`) corner radii, yielding soft, contemporary medical cards that neatly nest within the Android viewport.
- **Form Inputs & Text Fields:** Standardized at `12px` border radius, balancing readable structural geometry with ergonomic tap affordability.
- **Chips, Badges & Interactive Pills:** Built with `24px` (`rounded-full`) fully rounded caps to guarantee clear distinction against rectangular cards and tabular lists.
- **Bottom Navigation & Bottom Sheets:** Top corners of persistent bottom sheets and modals use `20px` to create a smooth shelf effect.

## Components

### Buttons
- **Primary Action (Dispense / Checkout):** Height 52px, filled with Primary Purple (`#5A3C62`) or Primary Gradient. Text is bold white with centered Arabic label. Radius 12px. Pressed state triggers an overlay of `rgba(255, 255, 255, 0.16)`.
- **Secondary Action:** Height 44px, background `#FFFFFF`, border `1.5px solid #3A6A6C`, text `#3A6A6C`.
- **Tonal / Quick-Tap:** Background `rgba(90, 60, 98, 0.08)`, text `#5A3C62`, radius 12px. Used for auxiliary POS actions like adding discounts or toggling generic switches.

### Status Chips & Pills
- Fully pill-shaped (height 28px, radius 24px, padding 4px 12px).
- Pair specific semantic background and text colors:
  - *متوفر (In Stock):* Background `#ABFDC3`, text `#036C2A`.
  - *نفذت الكمية (Out of Stock / Critical):* Background `#FFC9C8`, text `#D32F2F`.
  - *وشك الانتهاء (Low Stock):* Background `#FFDCA7`, text `#A95704`.
  - *تنبيه دوائي (Clinical Info):* Background `#BFECFA`, text `#02A1D1`.
- Contains leading 14px status indicator icon on the right side in RTL layout.

### Input Fields
- Height 48px, background `#FFFFFF`, border `1px solid #E0E0E0`, radius 12px.
- Focused state transitions to `1.5px solid #5A3C62` with a subtle glow `rgba(90, 60, 98, 0.08)`.
- Label rests inside the upper right frame in Arabic (`Cairo`, `label-md`, `#5A5A5A`).
- Leading icon (search/barcode) docks at the physical right edge; clear button docks at the left edge.

### Stat Cards
- Background `#FFFFFF`, radius 16px, padding 16px, border `1px solid #E0E0E0`.
- Includes an icon container (36x36px, radius 10px) filled with primary or secondary light tints.
- Numerical metric uses `headline-md` (bold tabular digits), subtitle uses `body-sm` (`#5A5A5A`).
- Highlight variant applies the Primary Gradient with crisp white typography.

### Fast Medicine Cards (Catalog / POS)
- Minimum height 96px, radius 16px, background `#FFFFFF`, 1px border `#E0E0E0`.
- Divided into: Trade name (`title-md`), Scientific name (`body-sm`, `#5A5A5A`), Stock badge, and Price tag (`title-lg`, `#5A3C62`).
- Quick-add button sits at the physical left edge: 36x36px rounded square with a plus icon.

### Prescription / Sale Line Items
- Horizontal strip card (padding 12px, background `#FFFFFF`, radius 12px).
- Right-to-left layout: Drug name and strength on the right, quantity counter (`- 1 +`) in the middle, subtotal price on the left.
- Subtle divider (`1px solid #F4F8FB`) between recurring line items.

### AI Clinical Assistant Bubble Dialogues
- **Pharmacist Query:** Aligned to the physical left, background `#5A3C62`, text `#FFFFFF`, rounded 16px with the bottom-left corner tightened to 4px.
- **AI Recommendation:** Aligned to the physical right, background `#FFFFFF`, border `1px solid #78BFC1`, rounded 16px with the bottom-right corner tightened to 4px. Features a 20px leading spark icon tinted with `#3A6A6C`, and structured markdown bullet points for clinical contraindications and alternative dosages.

### Bottom Navigation Bar (Material 3 Mobile)
- Height 68px plus Android navigation bar inset padding. Surface `#FFFFFF` with top border `1px solid #E0E0E0`.
- 5 symmetric navigation destinations in RTL reading order:
  1. **الرئيسية (Home):** Dashboard overview, daily metrics.
  2. **المخزون (Inventory):** SKU catalog, batch expiry, reorder alerts.
  3. **البيع (Sales):** Active point-of-sale terminal and cart.
  4. **المساعد الدوائي (AI Assistant):** Interaction checker and drug inquiries.
  5. **المزيد (More):** Settings, shifts, and reports.
- Active destination shows an elliptical pill background (`rgba(90, 60, 98, 0.12)`) behind the active icon, with icon and label tinted in `#5A3C62` (`label-md`, bold). Inactive destinations display `#5A5A5A`.