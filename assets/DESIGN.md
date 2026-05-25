---
name: Modernist Functionalist
colors:
  surface: '#fcf9f8'
  surface-dim: '#dcd9d9'
  surface-bright: '#fcf9f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f3f2'
  surface-container: '#f0eded'
  surface-container-high: '#eae7e7'
  surface-container-highest: '#e5e2e1'
  on-surface: '#1c1b1b'
  on-surface-variant: '#5c403b'
  inverse-surface: '#313030'
  inverse-on-surface: '#f3f0ef'
  outline: '#916f69'
  outline-variant: '#e6bdb6'
  surface-tint: '#bd1304'
  primary: '#a40800'
  on-primary: '#ffffff'
  primary-container: '#cc2110'
  on-primary-container: '#ffe3de'
  inverse-primary: '#ffb4a7'
  secondary: '#3c5d9e'
  on-secondary: '#ffffff'
  secondary-container: '#99b8ff'
  on-secondary-container: '#244787'
  tertiary: '#6b4b00'
  on-tertiary: '#ffffff'
  tertiary-container: '#8a6100'
  on-tertiary-container: '#ffe5be'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdad4'
  primary-fixed-dim: '#ffb4a7'
  on-primary-fixed: '#400100'
  on-primary-fixed-variant: '#920600'
  secondary-fixed: '#d8e2ff'
  secondary-fixed-dim: '#aec6ff'
  on-secondary-fixed: '#001a43'
  on-secondary-fixed-variant: '#214584'
  tertiary-fixed: '#ffdea9'
  tertiary-fixed-dim: '#febb2f'
  on-tertiary-fixed: '#271900'
  on-tertiary-fixed-variant: '#5e4100'
  background: '#fcf9f8'
  on-background: '#1c1b1b'
  surface-variant: '#e5e2e1'
typography:
  display-lg:
    fontFamily: Space Grotesk
    fontSize: 64px
    fontWeight: '700'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Space Grotesk
    fontSize: 40px
    fontWeight: '700'
    lineHeight: '1.2'
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Space Grotesk
    fontSize: 32px
    fontWeight: '700'
    lineHeight: '1.2'
  headline-md:
    fontFamily: Space Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: '1.3'
  body-lg:
    fontFamily: Literata
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: Literata
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
  label-lg:
    fontFamily: Space Grotesk
    fontSize: 14px
    fontWeight: '700'
    lineHeight: '1'
    letterSpacing: 0.05em
  label-md:
    fontFamily: Space Grotesk
    fontSize: 12px
    fontWeight: '500'
    lineHeight: '1'
spacing:
  unit: 4px
  gutter: 24px
  margin: 32px
  border-width: 2px
  border-width-heavy: 4px
---

## Brand & Style
The design system is rooted in the Bauhaus "Form Follows Function" philosophy, specifically tailored for the Basa language learning platform. It emphasizes clarity, structural integrity, and the reduction of elements to their essential geometric forms. The target audience consists of disciplined learners who value intellectual rigor and clean, distraction-free environments.

The visual style is **Modernist/Brutalist**, characterized by heavy structural borders, a primary-color-driven hierarchy, and asymmetric balance. Every element serves a clear utility; decoration is avoided in favor of typographic expression and grid-based composition. The emotional response is one of stability, authority, and methodical progress.

## Colors
The palette is restricted to the classic Bauhaus primaries, supported by high-contrast neutrals.

- **Primary (Red):** Used for critical actions, errors, and primary brand moments.
- **Secondary (Blue):** Used for informational accents, progress indicators, and secondary interactive elements.
- **Tertiary (Yellow):** Used for highlighting vocabulary, "new" badges, and warnings.
- **Neutral (Black):** Used for all structural borders, typography, and heavy-fill backgrounds.
- **Surface (Off-White):** The base canvas, providing a warm, archival feel that reduces eye strain compared to pure white.

Color should be applied in solid blocks. Gradients and soft transitions are strictly prohibited.

## Typography
The typographic system utilizes a high-contrast pairing to distinguish between UI navigation and educational content.

- **UI & Headlines:** **Space Grotesk** provides a geometric, engineered feel. Use heavy weights for headlines to create a "poster-like" impact.
- **Content & Reading:** **Literata** is used for all long-form text, vocabulary definitions, and reading exercises. Its modernist serif structure ensures high legibility during intensive study sessions.

Large display type should often be treated as a structural element, aligned strictly to the grid edges.

## Layout & Spacing
The layout follows a **12-column fixed grid** on desktop and a **4-column fluid grid** on mobile. The system rejects centered layouts in favor of asymmetric compositions that create dynamic tension.

- **Structural Borders:** Layout sections are separated by 2px black borders. Use "heavy" 4px borders for the main app frame or primary content containers.
- **Alignment:** All elements must snap to the grid. Negative space is used as a deliberate structural tool rather than just "breathing room."
- **Rhythm:** Spacing is based on a 4px baseline. Internal padding for containers should be generous (24px or 32px) to offset the weight of the heavy borders.

## Elevation & Depth
This design system is strictly **Flat**. There are no shadows, blurs, or gradients.

Depth is communicated through **Tonal Layering and Overlap**:
- **Level 0:** Off-white background.
- **Level 1:** Solid white containers with 2px black borders.
- **Level 2:** Solid primary-colored containers (Red, Blue, Yellow) that appear to sit "on top" of the grid through contrast, not shadow.
- **Interaction:** Hover states involve a solid color shift (e.g., from White to Yellow) or a slight 4px "offset" shift to mimic physical stacking without using light-source metaphors.

## Shapes
Shapes are purely **Geometric and Sharp**. There are no rounded corners in this design system.

- **Rectangles:** Used for buttons, inputs, and cards.
- **Circles:** Used exclusively for progress charts or specific avatar icons.
- **Triangles:** Used for play buttons or directional indicators.

The 90-degree angle is the primary visual motif, reinforcing the architectural nature of the design.

## Components
- **Buttons:** Rectangular with a 2px black border. Default state is white or a primary color; hover state is a high-contrast color swap. Label text is Space Grotesk Bold, Uppercase.
- **Input Fields:** 2px black bottom border only (minimalist) or full 2px rectangular border. Use Space Grotesk for input text.
- **Cards:** Heavy 2px borders, no shadow. Headers within cards are separated by a 2px horizontal line.
- **Progress Bars:** Solid blocks of Red or Blue within a 2px black-bordered container. No rounded caps.
- **Chips/Labels:** Solid black background with white Space Grotesk text for high-priority tags; Primary yellow background for secondary tags.
- **Lists:** Items separated by 2px horizontal rules. Interactive list items highlight the entire row in a primary color on hover.