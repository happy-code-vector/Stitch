# **StitchVision - Master Product & Technical Specification**

Version: 7.0

Date: January 16, 2026

Status: Approved for Immediate Engineering

Architectural Mandate: Edge-First (Offline Default) with Cloud Intelligence (On-Demand)

# **SECTION 1: STRATEGIC CONTEXT & ECONOMICS**

## **1.1 The Product Philosophy**

StitchVision is not a passive PDF reader; it is an **Active Knitting Co-Pilot**.

- **The Problem:** Knitters lose track of rows, leading to hours of frustration and "frogging" (undoing work).
- **The Solution:** Computer Vision that watches the needles and counts automatically.
- **The Differentiation:** We do not rely on cloud streaming. We use **Edge AI** (On-Device) for the core loop, making the tool faster, private, and infinitely scalable without server costs.

## **1.2 The "Bankruptcy Shield" (Financial Guardrails)**

To maintain a **\>70% Net Margin** at \$79.99/year, the architecture strictly enforces a separation of powers.

| **Feature**         | **Execution Environment** | **Technology**        | **Cost Profile**                |
| ------------------- | ------------------------- | --------------------- | ------------------------------- |
| **Row Counting**    | **Device (Edge)**         | Apple Vision / ML Kit | **\$0.00** (Zero Marginal Cost) |
| ---                 | ---                       | ---                   | ---                             |
| **Stitch Doctor**   | **Cloud (Server)**        | Gemini 2.0 Flash      | Variable (Gated by Limits)      |
| ---                 | ---                       | ---                   | ---                             |
| **Pattern Parsing** | **Cloud (Server)**        | Gemini 2.5 Flash-Lite | Variable (Gated by Limits)      |
| ---                 | ---                       | ---                   | ---                             |

**CRITICAL DEVELOPER MANDATE:**

**The live video feed from WorkModeScreen must NEVER be streamed to a cloud endpoint. The AVCaptureSession buffer must connect only to the local Native Module processor.**

## **1.3 Pricing & Feature Tiers**

We utilize a **"Quantity Gate"** strategy. The AI quality is never throttled; only the volume of usage is capped.

### **Tier A: Free (The "Hook")**

- **Target:** New users testing the magic.
- **Active Project Limit:** **Strictly 1.** (User must delete/archive Project A to start Project B).
- **Row Counting:** Unlimited (On-Device).
- **Stitch Doctor:** **Hard Cap: 3 Lifetime Uses.** (After 3, show Paywall).
- **Pattern Uploads:** **Hard Cap: 1 Lifetime Upload.**
- **Cloud Sync:** Disabled. Local storage only.

### **Tier B: Pro (\$12.99/mo or \$79.99/yr)**

- **Target:** Dedicated hobbyists.
- **Active Project Limit:** **Unlimited.**
- **Row Counting:** Unlimited.
- **Stitch Doctor:** **50 Diagnoses per Month** (Fair Use Limit).
- **Pattern Uploads:** **5 Uploads per Month** (Max 20 pages per PDF).
- **Cloud Sync:** Enabled (Multi-device support).
- **Content:** Access to Curated Starter Library.

# **SECTION 2: USER EXPERIENCE SPECIFICATION (The Flow)**

## **2.1 Onboarding Phase (Screens 1-12)**

_Goal: Get to the "Magic Moment" (Calibration) in <60 seconds._

- **Screens 1-6 (Personalization):** Standard inputs (Craft: Knitting/Crochet, Skill Level, Pain Points).
  - _Dev Note:_ Store these locally in AsyncStorage as user_preferences.
- **Screens 7-10 (Value Prop):** Loading Animation → Result ("You are a Focused Creator") → "How it Works" Carousel → Stats ("Save 4 Hours").
- **Screen 11: Camera Permissions (Privacy Focus):**
  - _Headline:_ "Set Up Your AI Counter"
  - _Body Copy:_ "StitchVision uses your camera to count rows. **Row counting happens 100% on your device**-video is never recorded or sent to the cloud."
  - _Benefit Bullets:_ "✓ Private & Secure", "✓ Works Offline", "✓ Zero Data Usage".
- **Screen 12: Calibration (The "Magic" Moment):**
  - _UI:_ Full-screen camera view with a central "Target Box."
  - _Instruction:_ "Hold your knitting in the box and knit normally for 30 seconds."
  - _Technical Trigger:_ The app runs the VisionCounter module in "Calibration Mode." It measures the average **Optical Flow Vector Magnitude** of the user's "Turn" gesture.
  - _Success State:_ When 3 distinct "Turns" are detected → Haptic Buzz + Confetti → Proceed.

## **2.2 Conversion Phase (Screens 13-17)**

- **Screen 13: Subscription (Paywall):**
  - _Primary Offer:_ **Yearly Pro (\$79.99)**. Tag: "Best Value - Save 50%".
  - _Secondary Option:_ Monthly (\$12.99).
  - _Footer:_ "Terms | Privacy | **Restore Purchases**" (Required for App Store).
- **Screen 14: Downsell (Conditional):** Shown only if user taps "Skip". Offers "Monthly Pro" as a lower barrier.
- **Screen 15: Create Account (Data Sync):**
  - _Headline:_ "Save Your Stash."
  - _Action:_ "Sign in with Apple" / "Sign in with Google."
  - _Logic:_ Create a Firebase Auth record. If skipped, create an anonymous user (migratable later).
- **Screen 17: Free Tier Welcome:**
  - _Headline:_ "You have **1 Free Project Slot**."
  - _Subtext:_ "Experience full AI magic on one project. Upgrade anytime to do more."

## **2.3 The Core Loop (Dashboard & Work Mode)**

- **Dashboard (Empty State):**
  - **Card 1 (Primary):** "Start New Project" (Sage Green). Opens Modal:
    - Option A: "From Library" (Loads starter_library.json).
    - Option B: "Upload PDF" (Trigger parsePattern API).
    - Option C: "Manual Setup" (User inputs Row 0).
  - **Card 2:** "Quick Count" (Camera only, no project state).
  - **Card 3:** "Add to Stash".
- **Work Mode (The Interface):**
  - **Video Feed:** Full screen.
  - **HUD:** Neon Yellow (#EBFF00) horizontal guide line at 50% height.
  - **Manual Toggle:** A Switch (UISwitch) labeled "Battery Saver."
    - _On:_ Camera View is hidden (black screen). Large "+" and "-" buttons appear.
    - _Off:_ Camera View is active. Native Vision Module is running.
  - **Stitch Doctor:** Stethoscope Icon (Bottom Left). Tapping captures a **still image** (not video) for API analysis.

# **SECTION 3: VISUAL DESIGN SYSTEM**

## **3.1 Color Palette (Tailwind / Native Tokens)**

- **Primary Sage:** #8FA888 (Buttons, Active States, Progress)
- **Sage Dark:** #7D9176 (Pressed States)
- **Terracotta:** #C96D5F (Badges, "Save" Tags, Error States)
- **Background Cream:** #F9F7F2 (Main App Background)
- **Surface White:** #FFFFFF (Cards, Modals)
- **HUD Yellow:** #EBFF00 (Camera Overlay ONLY - High Contrast)
- **Text Charcoal:** #2C2C2C (Primary Text)
- **Text Grey:** #666666 (Secondary Text)

**Button Color Hierarchy**

**Primary CTA** (Continue, Subscribe, Save, Submit): Terracotta #C96D5F - white text.

**Secondary CTA** (Skip, Cancel, outline buttons): Sage #8FA888 border + text, transparent fill.

**Destructive** (Delete, Archive): #DC2626 - white text.

**Disabled state**: #CCCCCC fill, #999999 text - never use Sage or Terracotta for disabled states.

## **3.2 Typography**

- **Font Family:** System Default (San Francisco on iOS / Roboto on Android).
- **H1 (Headlines):** 32px, Bold, Charcoal.
- **H2 (Section Headers):** 24px, Semibold, Charcoal.
- **Body:** 16px, Regular, Grey.
- **Button Text:** 16px, Semibold, White (on Terracotta or Destructive) or Terracotta (on Outline).

# **SECTION 4: TECHNICAL ARCHITECTURE (The Hardware)**

## **4.1 Hybrid Stack**

- **Framework:** React Native (Expo Prebuild recommended).
- **Native Modules:** Critical vision logic is written in Swift (iOS) and Kotlin (Android).
- **State Management:** Zustand (Lightweight) or React Context.
- **Local DB:** WatermelonDB or SQLite (for offline persistence).

## **4.2 The Vision Module (Native Implementation)**

**Constraint:** React Native's JS thread is too slow for 60fps analysis. The "Count" logic must run on the Native thread.

### **iOS Implementation (ios/VisionCounter.swift)**

Framework: Vision.framework (NOT ARKit).

API: VNGenerateOpticalFlowRequest.

**Logic Flow:**

- **Input:** Receive CMSampleBuffer from Camera.
- **Request:** Pass buffer to VNGenerateOpticalFlowRequest.
- **Analysis:** The API returns a pixel vector field. Calculate the average vector of the **Center 50%** (Region of Interest).
- **Trigger:**
  - If Vector.x > User_Threshold (Left-to-Right "Turn"): Increment Count.
  - If Vector.x < -User_Threshold (Right-to-Left "Turn"): Increment Count (for left-handed users).
- **Debounce:** After a count is registered, lock the counter for **5 Seconds** (User preference adjustable).
- **Output:** Send event onRowCounted(newCount) to React Native bridge.

### **Android Implementation (android/VisionCounter.kt)**

Framework: ML Kit Motion Detection.

Fallback: If ML Kit is unreliable on low-end devices (< Android 10), force "Manual Mode" UI.

# **SECTION 5: CLOUD INTELLIGENCE (API Contracts)**

## **5.1 Infrastructure**

- **Platform:** Firebase Functions (Node.js 20).
- **Region:** us-central1 (Lowest cost).
- **AI Provider:** Google Gemini API (via Vertex AI or AI Studio).

## **5.2 Endpoint: POST /api/v1/stitch-doctor**

- **Purpose:** Analyze a photo for knitting mistakes.
- **Model:** gemini-2.0-flash (Vision Optimized).
- **Cost Control:** Client **MUST** resize image to 1024x1024px before upload.
- **Rate Limit:** Check users/{uid}/usage/stitch_doctor_month. If > 50, reject.

**System Prompt:**

Plaintext

- You are an expert knitting instructor. Analyze this image.
- Task: Identify errors (Dropped stitch, Twisted stitch, Split yarn).
- Output Schema (JSON):
- {
- "has_error": boolean,
- "error_type": "dropped" | "twisted" | "tension" | "none",
- "confidence": number,
- "fix_suggestion": "string (max 15 words)"
- }
- If no error, return "has_error": false.

## **5.3 Endpoint: POST /api/v1/parse-pattern**

- **Purpose:** Convert a PDF into interactive steps.
- **Model:** gemini-2.5-flash-lite (Text Optimized).
- **Cost Control:** If PDF > 20 pages, reject.
- **Rate Limit:** Check users/{uid}/usage/pdf_uploads_month. If > 5, reject.

**System Prompt:**

Plaintext

- Extract knitting instructions from this text.
- Rules:
- 1\. Flatten repeats (e.g., "Repeat rows 1-4 twice" becomes 8 distinct row objects).
- 2\. Ignore intro text/bios.
- 3\. Output strictly valid JSON.
- Output Schema (JSON):
- \[
- { "row_index": 1, "display_num": "Row 1", "instruction": "Knit 2, Purl 2" },
- { "row_index": 2, "display_num": "Row 2", "instruction": "Knit 2, Purl 2" }
- \]

# **SECTION 6: DATABASE SCHEMA (Firestore / Local)**

## **6.1 Collection: users**

- uid: String (Auth ID)
- email: String
- subscription_status: "free" | "pro"
- subscription_expiry: Timestamp
- created_at: Timestamp

## **6.2 Sub-Collection: users/{uid}/usage_limits**

- doc_id: "monthly_stats"
- stitch_doctor_count: Number (Resets monthly via Scheduled Function)
- pdf_upload_count: Number (Resets monthly)
- lifetime_doctor_count: Number (For Free Tier cap)

## **6.3 Sub-Collection: users/{uid}/projects**

- project_id: UUID
- title: String
- status: "active" | "finished"
- current_row: Number
- manual_mode_pref: Boolean
- pattern_source: "library" | "upload" | "manual"
- pattern_data: JSON Object (Array of steps)
  - _Dev Note:_ Store pattern data inside the document to avoid extra reads.

# **SECTION 7: CONTENT & STARTER LIBRARY**

## **7.1 "Empty State" Mitigation**

The app must launch with **20 Public Domain patterns** pre-loaded.

## **7.2 Source Material**

- **Source:** The Antique Pattern Library (Pre-1927).
- **Categories:** Scarves, Beanies, Basic Socks.

## **7.3 Seed Data JSON (assets/data/starter_library.json)**

JSON

- \[
- {
- "id": "starter_001",
- "title": "Basic Garter Scarf",
- "difficulty": "Beginner",
- "category": "Accessories",
- "source_credit": "Project Gutenberg (Public Domain)",
- "steps": \[
- { "row": 1, "text": "Cast on 30 stitches.", "type": "setup" },
- { "row": 2, "text": "Knit all stitches.", "repeat": true, "repeat_count": 200 }
- \]
- },
- {
- "id": "starter_002",
- "title": "Ribbed Watch Cap",
- "difficulty": "Easy",
- "category": "Hats",
- "steps": \[
- { "row": 1, "text": "K2, P2 across row.", "repeat": true, "repeat_count": 60 }
- \]
- }
- \]

# **SECTION 8: IMPLEMENTATION ROADMAP & QA**

## **8.1 Phase 1: The "Vision Spike" (Days 1-7)**

- **Objective:** Prove the Optical Flow works.
- **Deliverable:** A raw iOS app that simply increments a counter when you "Turn" a knitting needle in front of it.
- **Fail Condition:** If detection is <80% accurate, pivot to "Touch to Count" as primary interaction.

## **8.2 Phase 2: The Core App (Days 8-21)**

- **Objective:** Build Screens 1-17 and Local DB.
- **Deliverable:** Fully functional app with Manual Mode and Local Vision counting.
- **Checklist:**
  - \[ \] Calibration flow works.
  - \[ \] Free Tier "1 Project" limit is enforced.
  - \[ \] Starter Library loads correctly.

## **8.3 Phase 3: The Cloud & Paywall (Days 22-30)**

- **Objective:** Integrate Firebase, Gemini, and RevenueCat.
- **Deliverable:** Full production build.
- **Checklist:**
  - \[ \] **Video Firewall:** Verify NO network egress during counting.
  - \[ \] **Image Resizer:** Verify 1024px limit.
  - \[ \] **Restore Purchases:** Button exists and works.
  - \[ \] **Privacy Label:** Ready for App Store submission.

# **SECTION 9: AI COMMUNICATION POLICY**

StitchVision is the only CraftEngine app that explicitly markets its AI features. The knitting and crochet community is technology-receptive - AI-assisted tools are seen as innovation, not intrusion. This is the opposite of the leatherworking, fly tying, and bookbinding communities served by the other portfolio apps. Do not apply the same AI-avoidance language from those PRDs to StitchVision. However, the rules below still apply.

**9.1 Labeling Rules**

**Row Counting (Vision Module):** Label as "AI Row Counter" or "Vision Counter" - this is the hero differentiator. Market it explicitly.

**StitchBot (AI Chat):** Label as "Ask StitchBot". Acceptable to say "AI-powered". Never say "Powered by Gemini" or mention Google.

**Stitch Doctor:** Label as "Stitch Doctor". Acceptable to describe as "AI-powered error detection". Never say "Powered by Gemini".

**Pattern Parser:** Label as "Import Pattern" or "Parse Pattern". Acceptable to say "AI converts your PDF". Never expose the model name.

**9.2 The Absolute Rules (Apply to All CraftEngine Apps)**

Never name the underlying model (Gemini, GPT, Claude) in any user-facing string, label, or tooltip.

Never send a video stream to any cloud endpoint. StitchBot and Stitch Doctor use still images only. The Vision module runs 100% on-device. See Section 1.2 Critical Developer Mandate.

Never store conversation history server-side. StitchBot history is session-only (6 turns max), held in component state, gone on screen exit.

Rate limits are enforced server-side in Cloud Functions. Never trust the client to enforce limits. A client-side bug that bypasses limits costs real money across all portfolio apps simultaneously because they share the same functions.

# **SECTION 10: GO-TO-MARKET & PORTFOLIO ALIGNMENT**

**10.1 Cross-App Portfolio Upsell (Required on Every Paywall)**

StitchVision ships first. Every subsequent CraftEngine app (FlyKit, BindKit, LeatherKit) will cross-reference StitchVision in their paywalls. StitchVision's paywall must reciprocate. Below the primary Annual/Monthly CTA, add an "Also from AR Company" footer: small app icons for any other live CraftEngine apps with App Store links. This section is left blank at v1.0 launch (no other apps live yet) and filled in as each app ships. The footer component must be built now - even if it renders nothing at launch - so it can be populated via a remote config update without an app store release.

**10.2 Go-to-Market Channels**

**Primary:** TikTok and Instagram Reels demonstrating vision counting in action. The "needles turning, counter ticking" demo is the most shareable moment in the app. Lead every ad with it. 15-second format, no voiceover needed.

**Secondary:** Pinterest and Facebook ads targeting knitting/crochet interest segments (ages 30-65). Ad creative priority: (1) Vision counter demo, (2) Stitch Doctor catching a dropped stitch, (3) Pattern library grid "80+ free patterns".

**Community:** r/knitting, r/crochet, Ravelry groups - organic participation only. Do not spam. Do not mention competitor apps. Let the product speak.

**Creator:** Target knitting/crochet YouTube channels (100K+ subscribers). Offer a dedicated pattern library section featuring their most popular patterns. Same model as LeatherKit creator partnerships in Section 10.3 of that PRD.

**Seasonal:** September-January (fall/winter knitting season and holiday gifting). 2× ad spend from October 1 - January 7. Knitting kits are common holiday gifts - target gift-givers as well as crafters.

**- DETAILED SPECIFICATIONS -**

_Addendums A through J - Complete technical specifications, analytics schema, CraftEngine SDK, and multi-app architecture_

**StitchVision**

Product Specification Addendum v1.0

_Companion to PRD v8 + Competitive Adjustments Brief_

April 2026 | Status: APPROVED FOR ENGINEERING

# **OVERVIEW: What This Document Covers**

This addendum closes every gap identified in the PRD v8 and Competitive Adjustments Brief. Sections are self-contained and can be handed directly to the developer. Do NOT contradict the PRD; this document extends it.

| **Section** | **Contents**                                                                      | **Priority**               |
| ----------- | --------------------------------------------------------------------------------- | -------------------------- |
| Addendum A  | Full specs: Pattern Library, Rounds, Haptics, Dark Mode, Photo Journal, Reminders | P0 (A.1-A.4), P1 (A.5-A.6) |
| Addendum B  | Missing onboarding Screen 16 + updated Firestore schema                           | P0                         |
| Addendum C  | Crochet counting technical spec (iOS + Android)                                   | P0                         |
| Addendum D  | Android Vision full spec (ML Kit equivalence to iOS)                              | P0                         |
| Addendum E  | StitchBot: resolved stateless vs. history question + full spec                    | P0                         |
| Addendum F  | Analytics event schema (all events, properties, Firebase setup)                   | P0                         |
| Addendum G  | Complete 100-term Abbreviation JSON                                               | P0                         |
| Addendum H  | Gamification + Streak System (Retention engine)                                   | P1                         |
| Addendum I  | Apple Watch + iOS Widget specs (Competitive differentiator)                       | P1                         |
| Addendum J  | CraftEngine SDK: Multi-App Architecture for future hobby apps                     | P1                         |

# **ADDENDUM A: Complete Feature Specifications (Previously Missing)**

## **A.1 - Pattern Library Expansion (v1.0 Launch, 80+ Patterns)**

The PRD v8 seed data showed 2 example patterns with a note to reach 20. The competitive brief raised this to 80+. This section resolves the discrepancy and specifies the full content requirement.

### **Content Requirements**

| **Category**         | **Count** | **Difficulty Mix**                                | **Craft Type**     |
| -------------------- | --------- | ------------------------------------------------- | ------------------ |
| Scarves & Cowls      | 15        | 8 Beginner, 5 Easy, 2 Intermediate                | Knitting + Crochet |
| Hats & Beanies       | 15        | 6 Beginner, 6 Easy, 3 Intermediate                | Knitting + Crochet |
| Baby Items           | 10        | 4 Beginner, 4 Easy, 2 Intermediate                | Knitting + Crochet |
| Dishcloths & Squares | 10        | 5 Beginner, 3 Easy, 2 Intermediate                | Knitting + Crochet |
| Socks                | 8         | 2 Easy, 4 Intermediate, 2 Advanced                | Knitting           |
| Mittens & Gloves     | 8         | 3 Easy, 3 Intermediate, 2 Advanced                | Knitting + Crochet |
| Shawls               | 7         | 2 Easy, 3 Intermediate, 2 Advanced                | Knitting + Crochet |
| Amigurumi (Toys)     | 8         | 3 Beginner, 3 Easy, 2 Intermediate                | Crochet only       |
| Home Decor           | 5         | 2 Beginner, 2 Easy, 1 Intermediate                | Knitting + Crochet |
| TOTAL                | 86        | 33 Beginner, 31 Easy, 19 Intermediate, 3 Advanced | Both crafts        |

### **Source & Legal**

- Primary source: Antique Pattern Library (antique-pattern-library.org) - pre-1927, fully public domain.
- Secondary source: Project Gutenberg textile collections.
- All patterns must include source_credit field in JSON. Do not modify or modernize language - use as-is to preserve public domain status.

**⚠️ CRITICAL: Do NOT use patterns from Ravelry, Lion Brand, or any modern publisher. All 86 patterns must be pre-1927 public domain. If a pattern cannot be verified as public domain, do not include it.**

### **Extended JSON Schema (assets/data/starter_library.json)**

Each pattern object must conform to this schema:

{

"id": "starter_001",

"title": "Basic Garter Scarf",

"difficulty": "Beginner", // Beginner | Easy | Intermediate | Advanced

"category": "Scarves & Cowls",

"craft_type": "knitting", // knitting | crochet | both

"estimated_hours": 4,

"yarn_weight": "worsted", // fingering | dk | worsted | bulky

"needle_size": "US 8", // null for crochet

"hook_size": null, // null for knitting, e.g. "5.0mm" for crochet

"gauge": "18 sts x 24 rows = 4in", // null if not specified

"source_credit": "Project Gutenberg (Public Domain, pre-1923)",

"tags": \["beginner", "gift", "quick"\],

"is_featured": false, // true = shown in onboarding preview

"supports_rounds": false, // true = uses round counter (Addendum A.2)

"steps": \[

{ "row": 1, "text": "Cast on 30 stitches.", "type": "setup" },

{ "row": 2, "text": "Knit all stitches.", "type": "main",

"repeat": true, "repeat_count": 200, "is_round": false }

\]

}

_⚡ Dev Note: Set is_featured: true on 8 patterns (2 per major category) - these appear in the onboarding Pattern Library Preview screen._

_⚡ Dev Note: Pre-process all repeat rows so the app does not need to expand them at runtime. The parse-pattern API handles uploaded PDFs; the starter library JSON should be pre-expanded._

## **A.2 - Rounds + Repeat Counter**

Standard row counting tracks linear progress. Knitting in the round (circular needles, DPNs) and crochet in the round require a separate paradigm: the counter must track both the current round number AND how many repeats of a stitch pattern have been completed within that round.

### **Data Model Extension**

Add to the project schema (Section 6.3 of PRD):

"counting_mode": "rows" | "rounds",

"current_round": 0,

"current_repeat": 0,

"repeats_per_round": 8, // User-defined, e.g. 8 pattern repeats per round

"stitch_marker_alert": true // Buzz on each repeat completion

### **UI Changes in WorkModeScreen**

- When counting_mode === "rounds": Replace the "Row: 12" display with a dual counter: "Round: 3 | Repeat: 5/8"
- Add a "Stitch Marker" button (small flag icon, top right of HUD). Each tap increments current_repeat. When current_repeat === repeats_per_round, it resets to 0 and increments current_round.
- The vision module still counts the primary turning gesture - but now it maps to "end of round" not "end of row" depending on mode.

### **Vision Integration for Rounds**

A knitting "round" ends when the user reaches their first stitch marker and the work passes the needle join point. Optically, this looks similar to a row turn but may occur more subtly. Spec:

- Run VisionCounter in "rounds mode" when counting_mode === "rounds".
- Lower the detection threshold by 15% (rounds turns are shorter wrist movements on circulars).
- After a round is counted, pause detection for 3 seconds (shorter than the 5s row debounce - rounds go faster).

_⚡ Dev Note: In Manual Mode, rounds work identically. The "+" button increments current_repeat. A long-press on "+" completes the round (increments current_round, resets current_repeat)._

## **A.3 - Haptics + Audio Feedback**

### **Haptic Patterns (iOS - CHHapticEngine)**

| **Event**             | **Pattern**                     | **iOS API**                                             | **Android API**                                        |
| --------------------- | ------------------------------- | ------------------------------------------------------- | ------------------------------------------------------ |
| Row/Round counted     | Single firm tap (medium impact) | UIImpactFeedbackGenerator(.medium)                      | VibrationEffect.createOneShot(80ms, 200)               |
| Repeat/stitch marker  | Double light tap                | UIImpactFeedbackGenerator(.light) x2, 100ms apart       | VibrationEffect.createWaveform(\[0,80,100,80\])        |
| Calibration success   | Rising triple tap               | Custom CHHapticPattern: 3 events, intensity 0.4/0.7/1.0 | VibrationEffect.createWaveform(\[0,60,80,80,120,200\]) |
| Error / Limit hit     | Heavy double buzz               | UINotificationFeedbackGenerator(.error)                 | VibrationEffect.createOneShot(200ms, 255)              |
| Pattern step complete | Soft single tap                 | UIImpactFeedbackGenerator(.soft)                        | VibrationEffect.createOneShot(40ms, 128)               |

### **Audio Feedback (Optional - user toggleable)**

- Use AVAudioSession (iOS) / SoundPool (Android).
- Sound file: a soft "click" at 440Hz, 80ms duration (generate programmatically - no asset needed).
- Volume: 30% of system volume, non-interruptive (duck other audio).
- User setting: Settings > Sounds > "Click on row count" (toggle, default ON).

_⚡ Dev Note: Use AVAudioSession.Category.ambient so the click does not interrupt podcast/music playback. This is important - knitters listen to audiobooks while working._

## **A.4 - Dark Mode (System-Follow)**

Dark mode uses the same semantic token names but different values. Use Appearance API (iOS) / DayNight theme (Android) to switch automatically. Never hardcode color values - always reference tokens.

### **Dark Mode Color Tokens**

| **Token Name**           | **Light Mode** | **Dark Mode** | **Usage**                                |
| ------------------------ | -------------- | ------------- | ---------------------------------------- |
| \--color-primary         | #8FA888        | #6B9B78       | Buttons, active states, progress bars    |
| \--color-primary-pressed | #7D9176        | #5A8A66       | Button pressed state                     |
| \--color-accent          | #C96D5F        | #E0857A       | Badges, save tags, error highlights      |
| \--color-background      | #F9F7F2        | #1A1A1A       | Main app background                      |
| \--color-surface         | #FFFFFF        | #2C2C2C       | Cards, modals, sheet surfaces            |
| \--color-surface-raised  | #F2F0EB        | #383838       | Elevated cards (shadow replaced by tone) |
| \--color-hud             | #EBFF00        | #EBFF00       | Camera HUD overlay ONLY - never changes  |
| \--color-text-primary    | #2C2C2C        | #F0F0F0       | Primary body and headline text           |
| \--color-text-secondary  | #666666        | #A0A0A0       | Secondary, caption, placeholder text     |
| \--color-border          | #E0DDD6        | #3A3A3A       | Card borders, dividers, input outlines   |
| \--color-destructive     | #DC2626        | #FF6B6B       | Delete actions, critical warnings        |
| \--color-success         | #16A34A        | #4ADE80       | Completion states, green checkmarks      |

### **React Native Implementation**

// In your theme provider:

const colorScheme = useColorScheme(); // "light" | "dark"

const theme = colorScheme === "dark" ? darkTokens : lightTokens;

// Never do this:

color: "#2C2C2C" // WRONG - hardcoded, breaks dark mode

// Always do this:

color: theme.textPrimary // CORRECT

_⚡ Dev Note: WorkModeScreen camera feed does not need dark mode treatment - it is full-screen video. Only the HUD overlays and the bottom control panel use theme tokens._

_⚡ Dev Note: Test dark mode on OLED screen (iPhone 15 Pro) - true black backgrounds (#1A1A1A) look premium on OLED and save battery. This is a selling point._

## **A.5 - Photo Journal (Target: v1.1)**

Deferred from v1.0. Spec included here so v1.1 development can begin immediately post-launch without re-scoping.

### **Core Concept**

A per-project photo diary. Users capture progress shots as they work. The journal becomes a visual record of the project from cast-on to finished object.

### **Data Model (add to users/{uid}/projects/{project_id})**

"journal": \[

{

"photo_id": "uuid",

"taken_at": Timestamp,

"row_at_time": 42, // Current row when photo was taken

"storage_url": "gs://...", // Firebase Storage URL

"thumbnail_url": "gs://...",

"caption": "string | null"

}

\]

### **UI Spec**

- Access: Project detail screen > "Journal" tab (third tab after "Pattern" and "Notes").
- Grid layout: 3 columns, square thumbnails with row number badge in bottom-right corner.
- Tap thumbnail: Full-screen viewer with swipe between photos. Shows caption and row number.
- Add photo: FAB (floating action button) with camera icon. Captures photo + auto-tags current row number.
- Share: Long-press photo > "Share Progress" generates a collage of 4 milestone photos with app branding watermark.

_⚡ Dev Note: Firebase Storage pricing: ~\$0.026/GB/month. Average project = 15 photos at 300KB each = ~4.5MB = \$0.0001/project/month. Negligible cost. No need to gate behind Pro - include in Free tier for v1.1 (drives social sharing)._

## **A.6 - Due Date Reminders (Target: v1.1)**

Deferred from v1.0. Spec included here for v1.1 planning.

### **Core Concept**

Users set a gift deadline or personal goal date per project. The app sends local push notifications to keep them on track.

### **Data Model (add to project schema)**

"due_date": Timestamp | null,

"reminder_enabled": boolean,

"reminder_frequency": "daily" | "every_3_days" | "weekly"

### **Notification Logic (Local - No Server Required)**

- When due_date is set, schedule local notifications using expo-notifications.
- Notification fires at 7:00 PM user local time on the scheduled day.
- Message template: "Your \[project_title\] deadline is in \[X\] days. You're on row \[current_row\]. Keep going!"
- Cancel all notifications for a project when status === "finished".

_⚡ Dev Note: Use local notifications only - no push server needed. Cost: \$0. Schedule up to 64 notifications per project at setup time (iOS limit). For long-horizon projects, reschedule when the app opens._

# **ADDENDUM B: Missing Onboarding Screen + Updated Firestore Schema**

## **B.1 - Screen 16: Pro Activation Confirmation**

Screen 16 is the missing screen between "Create Account" (Screen 15) and "Free Tier Welcome" (Screen 17). It appears only for users who purchased Pro during the paywall (Screen 10).

| **Attribute**     | **Spec**                                                                                                                   |
| ----------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Screen Number     | 16 (Pro flow only)                                                                                                         |
| Trigger Condition | user.subscription_status === "pro" after Screen 15 Auth                                                                    |
| Skipped When      | User is on Free tier - goes directly to Screen 17                                                                          |
| Headline          | "Pro Unlocked. You're All Set."                                                                                            |
| Subtext           | "Your AI-powered knitting assistant is ready. Here's what you can do:"                                                     |
| Body Content      | Three feature callouts with checkmarks: "Unlimited Projects", "Unlimited StitchBot", "Vision Row Counter (calibrate next)" |
| Primary CTA       | "Start Calibrating" → navigates to Screen 13 (Calibration)                                                                 |
| Secondary CTA     | "Skip Calibration" → navigates to Screen 18 (Dashboard)                                                                    |
| Background        | Solid --color-primary (#8FA888 light / #6B9B78 dark) with white text                                                       |
| Analytics Event   | screen_view { screen_name: "pro_activation_confirmation" }                                                                 |

_⚡ Dev Note: The "Skip Calibration" option is important - some Pro users will be in a context where they cannot knit right now. Do not force calibration. They can run it later from Settings > "Set Up Vision Counter"._

## **B.2 - Updated Firestore Schema (Complete, Reconciled)**

This replaces Section 6 of the PRD entirely. All fields from the PRD plus additions from the brief and this addendum are included.

### **Collection: users/{uid}**

{

"uid": "string", // Firebase Auth UID

"email": "string | null", // null for Apple Sign-In with hidden email

"display_name": "string | null",

"craft_preference": "knitting" | "crochet" | "both",

"skill_level": "beginner" | "easy" | "intermediate" | "advanced",

"subscription_status": "free" | "pro",

"subscription_expiry": "Timestamp | null",

"subscription_platform": "ios" | "android" | null,

"revenue_cat_id": "string", // RevenueCat customer ID

"created_at": "Timestamp",

"last_active": "Timestamp", // Update on app open

"streak_days": 0, // See Addendum H

"streak_last_date": "Timestamp | null",

"total_rows_counted": 0, // Lifetime aggregate for gamification

"calibration_complete": false, // Vision module calibrated?

"onboarding_complete": false,

"dark_mode_pref": "system" | "light" | "dark"

}

### **Sub-Collection: users/{uid}/usage_limits (doc_id: "monthly_stats")**

{

"stitch_doctor_count": 0, // Pro: resets monthly. Free: lifetime cap (3)

"pdf_upload_count": 0, // Pro: resets monthly. Free: lifetime cap (1)

"stitchbot_count": 0, // Free: resets monthly (cap 10). Pro: unlimited

"lifetime_doctor_count": 0, // Free tier cap tracking (never resets)

"lifetime_pdf_count": 0, // Free tier cap tracking (never resets)

"month_key": "2026-04", // "YYYY-MM" - reset trigger

"last_reset_at": Timestamp

}

**Monthly Reset Logic (Cloud Function - runs 1st of each month, 00:01 UTC):**

// Scheduled Cloud Function:

exports.resetMonthlyUsage = functions.pubsub.schedule("1 0 1 \* \*").onRun(async () => {

const newMonthKey = format(new Date(), "yyyy-MM");

// Query all users where month_key != newMonthKey

// Update: stitch_doctor_count=0, pdf_upload_count=0, stitchbot_count=0

// Do NOT reset lifetime_doctor_count or lifetime_pdf_count

});

### **Sub-Collection: users/{uid}/projects/{project_id}**

{

"project_id": "UUID",

"title": "string",

"status": "active" | "finished" | "archived",

"craft_type": "knitting" | "crochet",

"counting_mode": "rows" | "rounds", // A.2

"current_row": 0,

"current_round": 0, // A.2

"current_repeat": 0, // A.2

"repeats_per_round": null, // A.2

"total_rows": null, // From parsed pattern, if known

"manual_mode_pref": false,

"pattern_source": "library" | "upload" | "manual",

"library_pattern_id": "string | null",

"pattern_data": \[\], // Array of step objects

"notes": "string",

"yarn_details": "string",

"due_date": "Timestamp | null", // A.6

"reminder_enabled": false, // A.6

"journal": \[\], // A.5 (empty array, populated in v1.1)

"created_at": Timestamp,

"updated_at": Timestamp,

"finished_at": "Timestamp | null"

}

# **ADDENDUM C: Crochet Counting - Technical Specification**

## **C.1 - Why Crochet is Different from Knitting**

The PRD v8 Vision Module spec assumes knitting. The optical flow "turn" detection (horizontal vector crossing threshold) works because knitting rows end with a consistent wrist rotation. Crochet does not work this way:

| **Attribute**     | **Knitting**                                              | **Crochet**                                                                |
| ----------------- | --------------------------------------------------------- | -------------------------------------------------------------------------- |
| Row end gesture   | Clear wrist turn - needle pivots 180 degrees              | No turn - hook stays in hand, work flips passively                         |
| Motion direction  | Strong horizontal vector (left-to-right or right-to-left) | Primarily vertical (pull-through) and small horizontal                     |
| Speed             | Deliberate, 1-3 second turn                               | Fast, 0.3-0.8 second stitch cycles                                         |
| Row end indicator | Physical turn of work                                     | Completion of final stitch in row + chain-turn sequence                    |
| Detectable signal | Horizontal optical flow spike                             | Optical flow complexity DROPS then the hook moves up-and-away (chain turn) |

## **C.2 - Crochet Detection Algorithm**

### **Core Approach: Flow-Pause + Chain-Turn Detection**

A crochet row end is detected via a two-phase signature: (1) a brief pause in optical flow as the last stitch is completed, followed by (2) a distinct upward + lateral motion of the hook as the turning chain is worked.

- Feed CMSampleBuffer (iOS) or ImageProxy (Android) into optical flow processor at 30fps.
- Calculate per-frame "flow magnitude" - the mean vector magnitude across the center 50% ROI.
- Build a rolling 2-second flow magnitude buffer (60 frames at 30fps).
- Detect a "flow valley": 3+ consecutive frames where magnitude drops below 20% of the preceding 30-frame average.
- After the flow valley, detect an upward vector event: mean Y-component > +1.5 px/frame for 5+ consecutive frames within the next 1 second.
- If BOTH conditions are met within 1.2 seconds: fire onRowCounted().
- Debounce: lock counter for 4 seconds after detection.

### **Calibration Adaptation for Crochet**

The onboarding calibration screen (Screen 13) must behave differently when craft_type === "crochet":

- Instruction text changes to: "Crochet 2-3 rows normally. We'll learn your turning rhythm."
- The calibration algorithm samples the user's personal flow valley magnitude to set their threshold (instead of the fixed 20%). This adapts to fast vs. slow crocheters.
- Success condition: 2 distinct row endings detected (lowered from 3 for knitting - crochet rows are shorter and faster).

### **Hybrid Manual-Assist Mode for Crochet**

Crochet optical flow is inherently noisier than knitting. Add a "Crochet Assist" mode:

- When craft_type === "crochet" AND the confidence score of the last 3 detections averaged below 70%: automatically suggest "Switch to Tap Mode" via a non-blocking toast notification.
- Tap Mode: The camera stays active but the vision module pauses. A large tap-zone overlay appears at the bottom. Single tap = count row. This is not the same as Battery Saver mode - camera still shows.

_⚡ Dev Note: Crochet Assist is StitchVision's answer to the inherent optical flow limitation. Present this as a feature, not a fallback: "Smart Crochet Mode adapts to your speed."_

## **C.3 - iOS Crochet Implementation (VisionCounter.swift additions)**

// Add to VisionCounter.swift:

enum CraftMode { case knitting, crochet }

var craftMode: CraftMode = .knitting

var flowMagnitudeBuffer: \[Float\] = \[\] // Rolling 60-frame buffer

var inFlowValley: Bool = false

var valleyStartFrame: Int = 0

var currentFrame: Int = 0

func processFlow(\_ pixelBuffer: CVPixelBuffer) {

let magnitude = calculateMeanMagnitude(pixelBuffer, roi: centerROI)

flowMagnitudeBuffer.append(magnitude)

if flowMagnitudeBuffer.count > 60 { flowMagnitudeBuffer.removeFirst() }

if craftMode == .crochet {

let avg30 = flowMagnitudeBuffer.suffix(30).reduce(0,+) / 30

let isValley = magnitude < (avg30 \* 0.20)

if isValley && !inFlowValley {

inFlowValley = true; valleyStartFrame = currentFrame

}

if inFlowValley && detectUpwardVector(pixelBuffer) {

if currentFrame - valleyStartFrame < 36 { // within 1.2s at 30fps

fireRowCounted(); inFlowValley = false

}

}

}

currentFrame += 1

}

# **ADDENDUM D: Android Vision Module - Full Specification**

The PRD v8 Android spec was two sentences. This addendum provides full parity with the iOS spec.

## **D.1 - Android Architecture Overview**

| **Component**       | **iOS**                                         | **Android**                                                                      |
| ------------------- | ----------------------------------------------- | -------------------------------------------------------------------------------- |
| Capture pipeline    | AVCaptureSession + CMSampleBuffer               | CameraX + ImageAnalysis.Analyzer                                                 |
| Optical flow engine | VNGenerateOpticalFlowRequest (Vision.framework) | Custom dense optical flow via OpenCV4Android                                     |
| Threading           | Native module on background thread              | Analyzer runs on background executor, result posted to main thread via RN bridge |
| RN Bridge event     | onRowCounted(newCount)                          | Same event name - bridge parity required                                         |
| Fallback condition  | None (Vision.framework is OS-level)             | Android < 10 OR OpenCV init failure → force Manual Mode                          |

## **D.2 - Android Implementation (android/VisionCounter.kt)**

class VisionCounter(private val reactContext: ReactApplicationContext)

: ReactContextBaseJavaModule(reactContext), ImageAnalysis.Analyzer {

private val executor = Executors.newSingleThreadExecutor()

private var prevGray: Mat? = null

private var debounceActive = false

private var craftMode = "knitting"

private val flowBuffer = ArrayDeque&lt;Float&gt;(60)

override fun analyze(imageProxy: ImageProxy) {

val currentGray = imageProxy.toGrayMat() // Convert YUV to grayscale Mat

prevGray?.let { prev ->

val flow = Mat()

Video.calcOpticalFlowFarneback(

prev, currentGray, flow,

0.5, 3, 15, 3, 5, 1.2, 0 // Farneback params (tuned for 720p)

)

val roiFlow = flow.submat(

currentGray.rows()/4, currentGray.rows()\*3/4, // Center 50% ROI

currentGray.cols()/4, currentGray.cols()\*3/4

)

val (meanX, meanY) = calculateMeanVector(roiFlow)

if (craftMode == "knitting") {

processKnitting(meanX)

} else {

val magnitude = sqrt(meanX\*meanX + meanY\*meanY)

processCrochet(magnitude, meanY)

}

}

prevGray = currentGray

imageProxy.close()

}

private fun processKnitting(meanX: Float) {

val threshold = userThreshold // Set during calibration

if (!debounceActive && abs(meanX) > threshold) {

fireRowCounted()

startDebounce(5000) // 5 second lockout

}

}

private fun fireRowCounted() {

reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)

.emit("onRowCounted", newCount)

}

}

## **D.3 - OpenCV4Android Setup**

- Add to android/app/build.gradle: implementation "org.opencv:opencv-android:4.8.0"
- Initialize in MainApplication.kt: OpenCVLoader.initDebug()
- If OpenCVLoader.initDebug() returns false: set a flag forceManualMode = true and emit "onVisionUnavailable" event to RN. Display Manual Mode automatically.

## **D.4 - Android Calibration Flow**

Identical to iOS spec (PRD Section 2.1, Screen 13) with one difference: calibration runs the Farneback flow at 15fps instead of 30fps on Android &lt; API 30 (lower-end devices) to prevent thermal throttling. Use getHeapSize() &gt; 2GB as proxy for capable device.

**⚠️ CRITICAL: OpenCV Farneback is CPU-intensive. Test on a Pixel 4a (low-end target device). If frame processing takes > 33ms, reduce to 15fps automatically using a frame-skip counter (only process every other frame).**

# **ADDENDUM E: StitchBot - Resolved Specification**

## **E.1 - The Contradiction Resolved**

The competitive brief specified conversation_history as an API input field but also said "NO conversation persistence between sessions." These are not in conflict - they describe two different scopes:

| **Scope**                       | **Decision**                     | **Rationale**                                                                                                                                     |
| ------------------------------- | -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| Within a session (app open)     | RETAIN context for up to 6 turns | Users ask follow-up questions ("what if I use DK weight instead?"). Without context, StitchBot gives disconnected answers. This is a UX disaster. |
| Between sessions (app relaunch) | DO NOT persist                   | Token cost grows unbounded if we carry history across sessions. Each session starts fresh.                                                        |

## **E.2 - Full StitchBot API Spec**

### **Client-Side Conversation Management**

// In your React Native StitchBot component:

const \[history, setHistory\] = useState(\[\]); // Resets on component unmount

const askQuestion = async (question) => {

const recentHistory = history.slice(-6); // Last 3 exchanges (6 messages)

const response = await callStitchBot(question, recentHistory);

setHistory(prev => \[...prev,

{ role: "user", content: question },

{ role: "assistant", content: response.answer }

\]);

};

// History is held in component state - gone when user leaves the screen.

### **API Contract - POST /api/v1/ask-stitchbot**

// Request:

{

"question": "string", // Max 500 chars - enforce client-side

"conversation_history": \[ // Last 6 messages max

{ "role": "user", "content": "..." },

{ "role": "assistant", "content": "..." }

\],

"context": {

"current_pattern_step": "string | null", // Current row instruction if viewing pattern

"craft_type": "knitting" | "crochet"

}

}

// Response:

{

"answer": "string",

"questions_remaining": 7, // Free tier only. null for Pro.

"suggested_followups": \["string", "string"\] // 2 suggested next questions

}

### **Updated System Prompt**

Replace the brief's system prompt with this expanded version:

You are StitchBot, an expert knitting and crochet instructor inside the StitchVision app.

CONTEXT: The user may be actively knitting or crocheting. Keep answers brief and scannable.

If context.current_pattern_step is provided, use it to give specific help for that step.

RULES:

1\. Answer in under 120 words. Use bullet points for multi-step answers.

2\. If asked about a specific stitch, explain it in the context of the current craft_type.

3\. If you are unsure, say: "I'm not certain - check your pattern or a local yarn shop."

4\. Never recommend competitor apps.

5\. If the question is completely off-topic (not craft-related), say:

"I'm StitchBot - I only know yarn and stitches! Anything craft-related I can help with?"

6\. End every response with one suggested follow-up question in italics.

_⚡ Dev Note: The suggested_followups field in the response is used to populate "Quick question" chips below the response bubble. Clicking a chip auto-sends that question. This drives session depth and burns free-tier questions faster - creating more paywall touchpoints._

**⚠️ CRITICAL: Rate limit enforcement MUST happen server-side in the Cloud Function. Never trust the client to enforce limits. Always check Firestore usage_limits before calling Gemini.**

# **ADDENDUM F: Analytics Event Schema**

All events fire to Firebase Analytics. Group them by lifecycle stage. Properties listed are required unless marked optional.

## **F.1 - Onboarding Events**

| **Event Name**            | **Trigger**                        | **Key Properties**                                        |
| ------------------------- | ---------------------------------- | --------------------------------------------------------- |
| onboarding_started        | User opens app for first time      | platform: ios\|android, app_version: string               |
| onboarding_screen_viewed  | Each screen renders                | screen_number: int, screen_name: string                   |
| onboarding_craft_selected | User picks knitting/crochet/both   | craft_type: string                                        |
| onboarding_skill_selected | User picks skill level             | skill_level: string                                       |
| paywall_viewed            | Paywall screen renders (Screen 10) | source: "onboarding", user_id: string                     |
| paywall_dismissed         | User taps Skip on paywall          | source: "onboarding"                                      |
| subscription_started      | RevenueCat purchase confirmed      | plan: "monthly"\|"annual", price: float, platform: string |
| calibration_started       | Screen 13 renders (Pro users)      | craft_type: string                                        |
| calibration_succeeded     | Vision confirms 3 turns detected   | duration_seconds: int, craft_type: string                 |
| calibration_failed        | User exits before success          | attempts: int, craft_type: string                         |
| onboarding_completed      | User reaches Dashboard             | is_pro: boolean, completed_calibration: boolean           |

## **F.2 - Core Feature Events**

| **Event Name**        | **Trigger**                      | **Key Properties**                                        |
| --------------------- | -------------------------------- | --------------------------------------------------------- |
| project_created       | User starts new project          | source: "library"\|"upload"\|"manual", craft_type, is_pro |
| row_counted_vision    | Vision module detects row        | project_id, current_row, craft_type, counting_mode        |
| row_counted_manual    | User taps + button               | project_id, current_row                                   |
| row_adjusted          | User taps - to undo              | project_id, current_row, delta: -1                        |
| battery_saver_toggled | User switches manual/vision mode | new_state: "on"\|"off", project_id                        |
| stitch_doctor_used    | Image sent to API                | is_pro, remaining_uses: int, result_type: string          |
| stitch_doctor_paywall | User hits limit, paywall shown   | uses_consumed: 3                                          |
| pattern_uploaded      | PDF sent to parse-pattern API    | page_count: int, is_pro, result: "success"\|"error"       |
| project_finished      | User marks project complete      | total_rows: int, days_active: int, craft_type             |
| project_archived      | User archives project            | project_id, status_at_archive: string                     |

## **F.3 - StitchBot Events**

| **Event Name**            | **Trigger**                        | **Key Properties**                                   |
| ------------------------- | ---------------------------------- | ---------------------------------------------------- |
| stitchbot_session_started | User opens StitchBot screen        | is_pro, questions_remaining: int\|null               |
| stitchbot_question_asked  | User sends a question              | is_pro, session_turn: int, context_provided: boolean |
| stitchbot_followup_tapped | User taps suggested follow-up chip | session_turn: int                                    |
| stitchbot_limit_hit       | Free user hits 10 questions        | source: "stitchbot"                                  |
| stitchbot_paywall_viewed  | Paywall shown from StitchBot limit | source: "stitchbot_limit"                            |

## **F.4 - Retention & Monetization Events**

| **Event Name**         | **Trigger**                               | **Key Properties**                                                                     |
| ---------------------- | ----------------------------------------- | -------------------------------------------------------------------------------------- |
| paywall_viewed         | Any paywall renders (not just onboarding) | source: "project_limit"\|"stitch_doctor"\|"stitchbot_limit"\|"upload_limit", is_repeat |
| subscription_started   | Any successful purchase                   | plan, price, source (which paywall triggered it)                                       |
| subscription_cancelled | RevenueCat webhook - user cancels         | plan, days_active, projects_count                                                      |
| subscription_renewed   | RevenueCat webhook - annual renewal       | plan, year_number                                                                      |
| streak_achieved        | User opens app N days in a row            | streak_days: int (fire at 3, 7, 14, 30, 60, 100)                                       |
| app_opened             | App foregrounds                           | is_pro, days_since_install: int, current_streak: int                                   |
| glossary_opened        | User opens Abbreviation Guide             | source: "settings"\|"work_mode_help"                                                   |
| glossary_searched      | User types in search bar                  | query_length: int (no PII - do not log the actual query)                               |

## **F.5 - Firebase Analytics Setup**

_⚡ Dev Note: Use logEvent() from @react-native-firebase/analytics. Import the module once in a shared analytics.ts utility file. Never call Firebase directly from components - always route through the utility._

// analytics.ts

import analytics from "@react-native-firebase/analytics";

export const track = async (eventName: string, params?: Record&lt;string, any&gt;) => {

if (\__DEV_\_) { console.log("\[Analytics\]", eventName, params); return; }

await analytics().logEvent(eventName, params);

};

// Usage anywhere in the app:

track("stitch_doctor_used", { is_pro: user.isPro, remaining_uses: 2 });

# **ADDENDUM G: Complete Abbreviation Glossary (100 Terms)**

Deliverable: assets/data/abbreviations.json. This is the full list. Structure each entry as shown. The developer must build the searchable UI per the brief (Feature 1.1).

## **G.1 - JSON File Content**

Knitting Abbreviations (40 terms):

{ "abbr": "k", "full": "Knit", "desc": "Insert right needle from left to right through stitch, wrap yarn counter-clockwise, pull through.", "craft": "knitting" },

{ "abbr": "p", "full": "Purl", "desc": "Insert right needle from right to left through stitch, wrap yarn counter-clockwise, pull through to front.", "craft": "knitting" },

{ "abbr": "yo", "full": "Yarn Over", "desc": "Wrap working yarn around right needle before working next stitch. Creates a new stitch and an eyelet.", "craft": "knitting" },

{ "abbr": "k2tog", "full": "Knit 2 Together", "desc": "Right-leaning decrease. Insert needle through 2 stitches simultaneously and knit them as one.", "craft": "knitting" },

{ "abbr": "ssk", "full": "Slip, Slip, Knit", "desc": "Left-leaning decrease. Slip 2 sts knitwise, insert left needle through fronts of both, knit together.", "craft": "knitting" },

{ "abbr": "kfb", "full": "Knit Front and Back", "desc": "Increase. Knit into front of stitch, do not slip off; knit into back of same stitch.", "craft": "knitting" },

{ "abbr": "m1l", "full": "Make One Left", "desc": "Left-leaning increase. Lift bar between sts with left needle from front to back, knit through back loop.", "craft": "knitting" },

{ "abbr": "m1r", "full": "Make One Right", "desc": "Right-leaning increase. Lift bar between sts with left needle from back to front, knit through front loop.", "craft": "knitting" },

{ "abbr": "sl", "full": "Slip Stitch (knitting)", "desc": "Transfer stitch from left to right needle without working it. Usually done purlwise unless noted.", "craft": "knitting" },

{ "abbr": "psso", "full": "Pass Slipped Stitch Over", "desc": "Used in decreases. Pass previously slipped stitch over last worked stitch and off needle.", "craft": "knitting" },

{ "abbr": "tbl", "full": "Through Back Loop", "desc": "Insert needle through the back loop of a stitch instead of the front. Twists the stitch.", "craft": "knitting" },

{ "abbr": "wyif", "full": "With Yarn in Front", "desc": "Bring working yarn to front of work before slipping or working next stitch.", "craft": "knitting" },

{ "abbr": "wyib", "full": "With Yarn in Back", "desc": "Hold working yarn to back of work before slipping or working next stitch.", "craft": "knitting" },

{ "abbr": "dpn", "full": "Double-Pointed Needle", "desc": "Set of needles pointed at both ends, used for small circumference knitting in the round.", "craft": "knitting" },

{ "abbr": "circ", "full": "Circular Needle", "desc": "Two needle tips connected by a flexible cord, used for knitting in the round or flat.", "craft": "knitting" },

{ "abbr": "sm", "full": "Slip Marker", "desc": "Transfer stitch marker from left to right needle without working it.", "craft": "knitting" },

{ "abbr": "pm", "full": "Place Marker", "desc": "Place a stitch ring marker on the right needle to mark a position.", "craft": "knitting" },

{ "abbr": "w&t", "full": "Wrap and Turn", "desc": "Short-row technique. Wrap yarn around next stitch, turn work, work back the other direction.", "craft": "knitting" },

{ "abbr": "p2tog", "full": "Purl 2 Together", "desc": "Decrease on purl side. Insert needle through 2 stitches purlwise and purl them as one.", "craft": "knitting" },

{ "abbr": "ssp", "full": "Slip, Slip, Purl", "desc": "Left-leaning decrease on purl side. Slip 2 knitwise, replace on left needle, purl together through back loops.", "craft": "knitting" },

{ "abbr": "k3tog", "full": "Knit 3 Together", "desc": "Double decrease. Insert needle through 3 stitches and knit as one. Leans right.", "craft": "knitting" },

{ "abbr": "cdd", "full": "Central Double Decrease", "desc": "Slip 2 tog knitwise, k1, pass both slipped sts over. Centered double decrease.", "craft": "knitting" },

{ "abbr": "RT", "full": "Right Twist", "desc": "Cable technique without a cable needle. K2tog leaving sts on needle, knit first st again.", "craft": "knitting" },

{ "abbr": "LT", "full": "Left Twist", "desc": "Cable technique without cable needle. Skip first st, knit second through back loop, knit skipped st.", "craft": "knitting" },

{ "abbr": "cn", "full": "Cable Needle", "desc": "Short auxiliary needle used to hold stitches temporarily while working cable crossings.", "craft": "knitting" },

{ "abbr": "C4F", "full": "Cable 4 Front", "desc": "Slip 2 to cable needle held in front, knit 2, knit 2 from cable needle. Creates left-crossing cable.", "craft": "knitting" },

{ "abbr": "C4B", "full": "Cable 4 Back", "desc": "Slip 2 to cable needle held in back, knit 2, knit 2 from cable needle. Creates right-crossing cable.", "craft": "knitting" },

{ "abbr": "sts", "full": "Stitches", "desc": "Plural of stitch. Used in counts: 'cast on 20 sts.'", "craft": "knitting" },

{ "abbr": "patt", "full": "Pattern", "desc": "Work the established stitch pattern as set up in previous rows.", "craft": "knitting" },

{ "abbr": "foll", "full": "Following", "desc": "The next occurrence of a specified row, round, or instruction.", "craft": "knitting" },

Crochet Abbreviations (40 terms):

{ "abbr": "ch", "full": "Chain", "desc": "Yarn over hook, pull through loop. Foundation of most crochet work.", "craft": "crochet" },

{ "abbr": "sc", "full": "Single Crochet", "desc": "Insert hook, yarn over pull through 2 loops twice. Shortest US crochet stitch.", "craft": "crochet" },

{ "abbr": "dc", "full": "Double Crochet", "desc": "Yarn over, insert hook, yarn over pull through, yarn over pull through 2 loops twice.", "craft": "crochet" },

{ "abbr": "hdc", "full": "Half Double Crochet", "desc": "Yarn over, insert hook, yarn over pull through all 3 loops. Medium height stitch.", "craft": "crochet" },

{ "abbr": "tr", "full": "Treble Crochet", "desc": "Yarn over twice, insert hook, \[yarn over pull through 2 loops\] 3 times. Tall stitch.", "craft": "crochet" },

{ "abbr": "dtr", "full": "Double Treble", "desc": "Yarn over 3 times, insert hook, \[yarn over pull through 2 loops\] 4 times.", "craft": "crochet" },

{ "abbr": "sl st", "full": "Slip Stitch", "desc": "Insert hook, yarn over, pull through both loops at once. Used to join rounds or move without adding height.", "craft": "crochet" },

{ "abbr": "sc2tog", "full": "Single Crochet 2 Together", "desc": "Crochet decrease. \[Insert hook, pull up loop\] twice, yarn over pull through all 3 loops.", "craft": "crochet" },

{ "abbr": "dc2tog", "full": "Double Crochet 2 Together", "desc": "Decrease. Work 2 dc to last yarn-over step, yarn over pull through all 3 loops.", "craft": "crochet" },

{ "abbr": "inc", "full": "Increase", "desc": "Work 2 stitches into the same stitch to increase stitch count by 1.", "craft": "crochet" },

{ "abbr": "dec", "full": "Decrease", "desc": "Join 2 stitches together to reduce stitch count by 1.", "craft": "crochet" },

{ "abbr": "BLO", "full": "Back Loop Only", "desc": "Insert hook through only the back loop of a stitch. Creates a ridge on the front.", "craft": "crochet" },

{ "abbr": "FLO", "full": "Front Loop Only", "desc": "Insert hook through only the front loop. Creates a ridge on the back.", "craft": "crochet" },

{ "abbr": "MR", "full": "Magic Ring", "desc": "Adjustable loop used to start rounds. Allows center hole to be closed completely.", "craft": "crochet" },

{ "abbr": "fpdc", "full": "Front Post Double Crochet", "desc": "Work dc around the post (vertical bar) of the stitch below from front to back to front.", "craft": "crochet" },

{ "abbr": "bpdc", "full": "Back Post Double Crochet", "desc": "Work dc around the post of the stitch below from back to front to back.", "craft": "crochet" },

{ "abbr": "fptr", "full": "Front Post Treble", "desc": "Work tr around the post from front to back to front.", "craft": "crochet" },

{ "abbr": "sc blo", "full": "SC in Back Loop Only", "desc": "Single crochet worked through the back loop only.", "craft": "crochet" },

{ "abbr": "puff", "full": "Puff Stitch", "desc": "\[Yarn over, insert hook, pull up long loop\] 3-5 times in same stitch, yarn over pull through all loops.", "craft": "crochet" },

{ "abbr": "bob", "full": "Bobble Stitch", "desc": "5 dc worked into same stitch, each left with 2 loops, then all joined with one yarn-over.", "craft": "crochet" },

{ "abbr": "popcorn", "full": "Popcorn Stitch", "desc": "Work 5 dc into same stitch, drop loop, insert hook through first dc, pull dropped loop through.", "craft": "crochet" },

{ "abbr": "ch-sp", "full": "Chain Space", "desc": "The space created by a chain loop in the previous row/round, used as an anchor point.", "craft": "crochet" },

{ "abbr": "t-ch", "full": "Turning Chain", "desc": "Chain(s) made at start of a new row to bring hook to height of first stitch.", "craft": "crochet" },

{ "abbr": "ch-3 sp", "full": "3-Chain Space", "desc": "A space formed by 3 chains in a previous row, typically in lace or granny square patterns.", "craft": "crochet" },

{ "abbr": "SS", "full": "Standing Stitch", "desc": "Method to start a new color or join without a slip knot, using a regular stitch directly.", "craft": "crochet" },

{ "abbr": "dc3tog", "full": "DC 3 Together", "desc": "Double decrease. Work 3 dc to last step simultaneously, yarn over through all loops.", "craft": "crochet" },

{ "abbr": "join", "full": "Join with Slip Stitch", "desc": "Insert hook in first stitch of round, yarn over, pull through both loops to close round.", "craft": "crochet" },

{ "abbr": "sp", "full": "Space", "desc": "The open area between stitches in a mesh or lace pattern, worked into rather than through.", "craft": "crochet" },

{ "abbr": "rnd", "full": "Round", "desc": "One complete circuit of stitches worked in the round.", "craft": "crochet" },

{ "abbr": "shell", "full": "Shell Stitch", "desc": "Group of stitches (typically 5 dc) worked into the same stitch or space to form a fan shape.", "craft": "crochet" },

Universal Abbreviations (30 terms):

{ "abbr": "st", "full": "Stitch", "desc": "A single loop on needle or hook.", "craft": "both" },

{ "abbr": "sts", "full": "Stitches", "desc": "Plural of stitch.", "craft": "both" },

{ "abbr": "rep", "full": "Repeat", "desc": "Work the bracketed or asterisk-marked instructions the number of times stated.", "craft": "both" },

{ "abbr": "RS", "full": "Right Side", "desc": "The public-facing side of the work, the side that will show when worn or displayed.", "craft": "both" },

{ "abbr": "WS", "full": "Wrong Side", "desc": "The interior or back side of the work.", "craft": "both" },

{ "abbr": "CO", "full": "Cast On", "desc": "Create foundation stitches on needle to begin knitting.", "craft": "both" },

{ "abbr": "BO", "full": "Bind Off", "desc": "Secure stitches at end of knitting to prevent unraveling. Also called cast off.", "craft": "both" },

{ "abbr": "beg", "full": "Beginning", "desc": "Start of row, round, or pattern section.", "craft": "both" },

{ "abbr": "cont", "full": "Continue", "desc": "Keep working in the established pattern without changes.", "craft": "both" },

{ "abbr": "rem", "full": "Remaining", "desc": "Stitches left to be worked or stitches left on needle after a decrease or bind-off.", "craft": "both" },

{ "abbr": "approx", "full": "Approximately", "desc": "Used with measurements - gauge or finished size is not exact to the stated number.", "craft": "both" },

{ "abbr": "alt", "full": "Alternate", "desc": "Work every other stitch, row, or round as specified.", "craft": "both" },

{ "abbr": "lp(s)", "full": "Loop(s)", "desc": "The circular structure of a stitch through which the hook or needle is inserted.", "craft": "both" },

{ "abbr": "pat(t)", "full": "Pattern", "desc": "The sequence of stitches being worked. 'Work in patt' means maintain the established sequence.", "craft": "both" },

{ "abbr": "prev", "full": "Previous", "desc": "Referring to the row, round, or stitch worked before the current one.", "craft": "both" },

{ "abbr": "tog", "full": "Together", "desc": "Work two or more stitches at the same time (for decreases).", "craft": "both" },

{ "abbr": "MC", "full": "Main Color", "desc": "The primary yarn color in a multi-color pattern.", "craft": "both" },

{ "abbr": "CC", "full": "Contrasting Color", "desc": "The secondary yarn color used for accents or colorwork.", "craft": "both" },

{ "abbr": "LH", "full": "Left Hand", "desc": "Instructions for or actions taken with the left hand.", "craft": "both" },

{ "abbr": "RH", "full": "Right Hand", "desc": "Instructions for or actions taken with the right hand.", "craft": "both" },

{ "abbr": "mult", "full": "Multiple", "desc": "Stitch count must be a multiple of this number for pattern to work evenly.", "craft": "both" },

{ "abbr": "pwise", "full": "Purlwise", "desc": "As if to purl - insert needle/hook from right to left.", "craft": "both" },

{ "abbr": "kwise", "full": "Knitwise", "desc": "As if to knit - insert needle/hook from left to right.", "craft": "both" },

{ "abbr": "tw", "full": "Twist", "desc": "Cross two stitches without a cable needle.", "craft": "both" },

{ "abbr": "fig", "full": "Figure", "desc": "Refers to a diagram or photo in the printed pattern.", "craft": "both" },

{ "abbr": "\*", "full": "Repeat Section", "desc": "Work instructions between \* and \* as many times as indicated.", "craft": "both" },

{ "abbr": "\[ \]", "full": "Repeat Brackets", "desc": "Repeat instructions inside brackets the number of times stated after the bracket.", "craft": "both" },

{ "abbr": "in", "full": "Inches", "desc": "Unit of measurement for finished dimensions or gauge.", "craft": "both" },

{ "abbr": "cm", "full": "Centimeters", "desc": "Metric unit of measurement for patterns using European sizing.", "craft": "both" },

{ "abbr": "g", "full": "Grams", "desc": "Weight of yarn skein. Used to estimate how much yarn a pattern requires.", "craft": "both" },

# **ADDENDUM H: Gamification + Streak System**

Neither LoopCraft nor LooseLoop has meaningful gamification. This is a significant retention gap you can exploit. Crafters are already motivated by progress - the app just needs to make that progress visible and rewarding.

## **H.1 - Streak System**

### **Logic**

- A "craft day" is logged when a user opens a project and counts at least 1 row (vision or manual).
- Streak = consecutive calendar days with at least 1 row counted.
- If the user misses a day, streak resets to 0.
- Store streak_days and streak_last_date in the user document (Addendum B.2 schema already includes these fields).

### **Milestone Notifications (Local Push)**

| **Streak** | **Notification Message**                                        |
| ---------- | --------------------------------------------------------------- |
| 3 days     | "3 days in a row! Your project is 3 rows closer to done.        |
| 7 days     | "One week straight! You're a dedicated crafter.                 |
| 14 days    | "Two weeks of daily crafting. Your hands are getting faster.    |
| 30 days    | "30-day streak. That's a finished object's worth of dedication. |
| 60 days    | "60 days. At this rate, nothing stops you.                      |
| 100 days   | "100 days. You're not a hobbyist - you're a craftsperson.       |

### **UI Integration**

- Dashboard: Show a small flame icon + streak count next to the user's active project. "🔥 12-day streak"
- Profile screen: Streak is the top stat. Show a mini calendar heatmap (GitHub-style) of craft activity for the last 30 days.
- Work Mode: When a row is counted that extends the streak, show a brief animation: "+1 Row. 🔥 Day 12."

## **H.2 - Milestone Badges**

Static achievements tied to lifetime totals. Display in the Profile screen under "My Milestones."

| **Badge Name** | **Trigger**                     | **Icon Concept**      |
| -------------- | ------------------------------- | --------------------- |
| First Loop     | Count first row ever            | Single loop icon      |
| Century Row    | Count 100 rows total (lifetime) | Number 100 with yarn  |
| Finisher       | Mark first project as finished  | Checkmark on knitting |
| Stitch Doctor  | Use Stitch Doctor 10 times      | Stethoscope           |
| Pattern Parser | Upload first PDF pattern        | Document with sparkle |
| Week Warrior   | Achieve a 7-day streak          | Flame 7               |
| Month Master   | Achieve a 30-day streak         | Calendar flame        |
| Prolific       | Finish 5 projects total         | Five-star badge       |
| The Thousand   | Count 1,000 rows total lifetime | Bold 1K badge         |
| Obsessed       | 100-day streak                  | Gold flame            |

_⚡ Dev Note: Badges are cosmetic only - no paywall gating. Free users can earn all badges. This drives engagement without creating resentment. Badges are also social proof when you add community features._

# **ADDENDUM I: Apple Watch App + iOS Home Screen Widget**

Neither LoopCraft nor LooseLoop has an Apple Watch app or iOS widget. These are the two highest-ROI differentiators available to you at low engineering cost.

## **I.1 - Apple Watch App (WatchOS Extension)**

### **Why This Wins**

- Knitters cannot look at their phone while working - their hands are full. A wrist glance is the natural interface.
- Competitor apps require picking up the phone to check the row count. This interrupts flow.
- Apple Watch app positions StitchVision as a premium, thoughtful product - not a cheap knockoff.

### **Watch App Feature Scope (v1.0)**

| **Feature**         | **Spec**                                                                           | **Priority** |
| ------------------- | ---------------------------------------------------------------------------------- | ------------ |
| Current Row Display | Large digital number, full-width. "Row 42"                                         | P0           |
| Increment Button    | Large + button (Digital Crown also increments). Haptic confirm on tap.             | P0           |
| Decrement Button    | Small - button (secondary action, requires 2-finger press to prevent accidents)    | P0           |
| Project Name        | Small subtitle under row number. "Ribbed Watch Cap"                                | P0           |
| Progress Bar        | If total_rows is known from pattern, show % completion ring (like Activity rings). | P1           |
| Battery Saver Note  | Display only - no camera. Watch is always manual mode.                             | N/A          |

### **Data Sync Architecture**

- Use WatchConnectivity (WCSession) for real-time sync between iPhone and Watch.
- When user increments on Watch: immediately update local Watch state. Send WCSession.transferUserInfo() to iPhone. iPhone receives it and updates Firestore.
- When user increments on iPhone: WCSession.sendMessage() pushes update to Watch immediately (if Watch is reachable) or queues it.
- Conflict resolution: last-write-wins by timestamp. The device that counted most recently is correct.

_⚡ Dev Note: WatchConnectivity has two modes: sendMessage (immediate, requires both devices reachable) and transferUserInfo (queued, reliable). Use transferUserInfo for count updates - it survives the phone going to background._

### **App Store Positioning**

When the Watch app ships, update the App Store subtitle to: "Row counter on your wrist." This is a hard differentiator that competitors cannot claim.

## **I.2 - iOS Home Screen Widget (WidgetKit)**

### **Widget Sizes to Support**

| **Size**     | **Content**                                                                  | **Update Frequency** |
| ------------ | ---------------------------------------------------------------------------- | -------------------- |
| Small (2x2)  | Project name + Row number (giant text). App icon in corner.                  | On each row count    |
| Medium (4x2) | Project name + Row N of Total + progress bar + "Open StitchVision" deep link | On each row count    |

### **Implementation Notes**

- Use WidgetKit + App Groups to share data between main app and widget extension.
- Store current project snapshot in UserDefaults(suiteName: "group.com.stitchvision.shared").
- Widget timeline: provide 1 entry. Refresh using WidgetCenter.shared.reloadAllTimelines() after each row count.
- Widget tap: deep link to the active project in Work Mode. URL scheme: stitchvision://project/{project_id}/work

_⚡ Dev Note: Widgets are on the home screen. Every time a user glances at their phone, they see their row progress. This is a passive retention tool - the app stays top of mind without a push notification._

# **ADDENDUM J: CraftEngine SDK - Multi-App Architecture**

This is the strategic document that multiplies the value of everything built for StitchVision. The goal: build 5 craft apps using 90% of the same code. Each app is a separate SKU in the App Store with its own brand, targeting a distinct hobbyist niche.

## **J.1 - The Business Case**

| **App**      | **Craft Niche**             | **Core Motion**                             | **Market Size (Est.)** | **Timeline**         |
| ------------ | --------------------------- | ------------------------------------------- | ---------------------- | -------------------- |
| StitchVision | Knitting + Crochet          | Needle turn / Hook pull                     | ~55M US practitioners  | v1.0 NOW             |
| WeavePilot   | Hand weaving + Loom weaving | Shuttle pass detection                      | ~8M US practitioners   | 3 months post-launch |
| BeadTrack    | Beading + Jewelry making    | Tap-to-count (vision less viable)           | ~20M US practitioners  | 4 months post-launch |
| EmbroidAI    | Cross-stitch + Embroidery   | Frame rotation detection                    | ~15M US practitioners  | 5 months post-launch |
| SpinLog      | Spinning + Fiber arts       | Wheel rotation detection (gyroscope assist) | ~3M US practitioners   | 6 months post-launch |

Revenue projection at 0.5% market conversion, \$39.99/year annual average, each app:

- StitchVision: 55M x 0.005 x \$39.99 = \$10.9M TAM at full penetration
- WeavePilot: 8M x 0.005 x \$39.99 = \$1.6M TAM
- BeadTrack: 20M x 0.005 x \$39.99 = \$4.0M TAM
- Combined portfolio TAM: ~\$20M+ at scale

Even at 5% of TAM capture, the portfolio generates meaningful ARR without building five separate codebases.

## **J.2 - Shared Module Inventory (The CraftEngine Core)**

These modules are built ONCE in StitchVision and reused across every app. Write them with zero app-specific logic.

| **Module**                | **What It Does**                                                                  | **App-Specific Config**              |
| ------------------------- | --------------------------------------------------------------------------------- | ------------------------------------ |
| CraftEngine/Auth          | Firebase Auth (Apple/Google), RevenueCat setup, anonymous → named user migration  | app_id, revenue_cat_key              |
| CraftEngine/Vision        | Optical flow pipeline (iOS + Android), calibration flow, debounce logic           | CraftProfile with motion thresholds  |
| CraftEngine/Paywall       | Paywall screen, downsell screen, RevenueCat integration, restore purchases        | Products array, paywall copy strings |
| CraftEngine/Onboarding    | Screen sequence manager, progress bar, skip logic, personalization storage        | screens array, brand colors          |
| CraftEngine/AIAssistant   | Cloud Function wrapper for chat assistant, usage limit enforcement, chat UI       | System prompt, bot name, avatar      |
| CraftEngine/PatternParser | PDF upload, parse-pattern API call, result display, pattern step navigation       | Craft-specific step terminology      |
| CraftEngine/Glossary      | Searchable JSON glossary UI, filter by craft type                                 | abbreviations.json per craft         |
| CraftEngine/Analytics     | All track() calls, event schema, Firebase setup                                   | App name prefix for event names      |
| CraftEngine/Gamification  | Streak logic, badge definitions, milestone notifications                          | Badge names, milestone copy          |
| CraftEngine/Widget        | WidgetKit + Watch extension base                                                  | App group ID, widget color tokens    |
| CraftEngine/DesignSystem  | Theme tokens (light/dark), typography, shared components (buttons, cards, modals) | Color palette per app                |

## **J.3 - App-Specific Layer (Only What Changes Per App)**

| **Layer**           | **StitchVision**                                | **WeavePilot**                     | **BeadTrack**              |
| ------------------- | ----------------------------------------------- | ---------------------------------- | -------------------------- |
| Brand name          | StitchVision                                    | WeavePilot                         | BeadTrack                  |
| Color palette       | Sage + Terracotta                               | Deep teal + Linen                  | Amethyst + Gold            |
| Vision CraftProfile | knitting: horizontal turn; crochet: flow valley | shuttle: lateral traversal         | N/A (tap-to-count)         |
| AI Bot name         | StitchBot                                       | LoomBot                            | BeadBot                    |
| AI System prompt    | Knitting/crochet expert                         | Weaving draft expert               | Bead pattern expert        |
| Glossary JSON       | abbreviations_knit_crochet.json                 | abbreviations_weaving.json         | abbreviations_beading.json |
| Pattern library     | 86 knit/crochet patterns                        | Draft patterns + weaving sequences | Bead chart patterns        |
| Counter paradigm    | Rows + Rounds                                   | Picks (horizontal threads)         | Bead count per row         |
| App Store keywords  | knitting row counter crochet AI                 | weaving loom draft counter         | beading pattern tracker    |

## **J.4 - Implementation Strategy**

### **Repository Structure**

craft-engine/

packages/

core/ # CraftEngine shared modules (npm package)

stitchvision/ # StitchVision app (imports core)

weavepilot/ # WeavePilot app (imports core)

beadtrack/ # BeadTrack app (imports core)

firebase/

functions/ # Shared Cloud Functions (one deploy, all apps)

firestore.rules # Shared security rules

### **Monorepo Tooling**

- Use Turborepo or pnpm workspaces to manage the monorepo.
- Each app is an independent Expo project that imports from the core package.
- One Firebase project can serve all apps (separate Firestore collections by app_id prefix, e.g. sv_users, wp_users). At scale, split into separate Firebase projects per app.

### **CraftProfile Object (The Vision Adapter)**

Each app passes a CraftProfile to the CraftEngine/Vision module at init. This is the only thing that changes:

// StitchVision CraftProfile:

const StitchVisionProfile = {

craftId: "stitchvision",

crafts: \["knitting", "crochet"\],

detectionModes: {

knitting: { type: "horizontal_flow", threshold: 2.5, debounce_ms: 5000 },

crochet: { type: "flow_valley_upward", threshold: 0.20, debounce_ms: 4000 }

},

calibrationInstructions: {

knitting: "Hold your knitting and turn normally for 30 seconds.",

crochet: "Crochet 2-3 rows normally. We'll learn your rhythm."

},

counterLabel: { row: "Row", round: "Round", repeat: "Repeat" }

};

// WeavePilot CraftProfile:

const WeavePilotProfile = {

craftId: "weavepilot",

crafts: \["weaving"\],

detectionModes: {

weaving: { type: "lateral_traversal", threshold: 3.0, debounce_ms: 3000 }

},

counterLabel: { row: "Pick", round: "Pass", repeat: "Repeat" }

};

## **J.5 - The Vision for New Craft Motions**

### **WeavePilot - Shuttle Detection**

Hand weaving involves a shuttle (bobbin holder) passing left to right and right to left through the warp threads. Each shuttle pass = one "pick" (equivalent to a row). The optical flow horizontal vector works here - similar to knitting but faster and lower amplitude. Threshold calibration handles the difference.

### **EmbroidAI - Frame Rotation**

Embroiderers rotate their hoop 90-180 degrees when moving between sections. This is a high-magnitude rotation event detectable via optical flow. However, embroidery counting is less about rows and more about sections completed - the counter paradigm shifts to "sections" not "rows."

### **SpinLog - Wheel Rotation (Gyroscope Assist)**

Spinning wheels rotate continuously. Optical flow alone cannot distinguish individual rotations well. SpinLog should use the phone's gyroscope (CoreMotion on iOS) in addition to optical flow: count rotations of the phone when it is placed near the wheel. This is a different sensor modality but the same CraftEngine/Vision interface.

_⚡ Dev Note: SpinLog is the most technically complex expansion and should be last in the pipeline. Validate the market with StitchVision + WeavePilot first._

## **J.6 - Shared Firebase Cloud Functions Architecture**

One set of Cloud Functions serves all apps. The app_id field in every API request routes logic correctly.

// POST /api/v1/ask-bot

{

"app_id": "stitchvision" | "weavepilot" | "beadtrack",

"question": "string",

"conversation_history": \[\],

"context": { "craft_type": "knitting", "current_step": "..." }

}

// Cloud Function routes by app_id:

const systemPrompts = {

stitchvision: "You are StitchBot, an expert knitting and crochet instructor...",

weavepilot: "You are LoomBot, an expert in hand weaving, loom drafts...",

beadtrack: "You are BeadBot, an expert in beading patterns and jewelry..."

};

const prompt = systemPrompts\[req.body.app_id\];

_⚡ Dev Note: The rate limiting logic checks users/{app_id}\_{uid}/usage_limits - namespacing by app_id ensures limits are per-app, not shared across your portfolio._

# **QUICK REFERENCE: Developer Checklist**

Use this as the single source of truth for what must be built before launch.

## **P0 - Launch Blockers**

| **Item**                                                                  | **Addendum Ref** | **Effort Est.** | **Done?** |
| ------------------------------------------------------------------------- | ---------------- | --------------- | --------- |
| Addendum A.1: 86 pattern JSON in starter_library.json                     | A.1              | 4 hrs (content) | \[ \]     |
| Addendum A.2: Rounds + Repeat counter logic + UI                          | A.2              | 6 hrs           | \[ \]     |
| Addendum A.3: Haptics + audio feedback                                    | A.3              | 3 hrs           | \[ \]     |
| Addendum A.4: Dark mode - all 12 color tokens + system-follow             | A.4              | 4 hrs           | \[ \]     |
| Addendum B.1: Screen 16 - Pro activation confirmation                     | B.1              | 2 hrs           | \[ \]     |
| Addendum B.2: Updated Firestore schema (add stitchbot_count + new fields) | B.2              | 1 hr            | \[ \]     |
| Addendum C: Crochet flow-valley detection in VisionCounter.swift          | C.2-C.3          | 8 hrs           | \[ \]     |
| Addendum D: Android VisionCounter.kt (OpenCV4Android)                     | D.2              | 12 hrs          | \[ \]     |
| Addendum E: StitchBot API + UI (session-level history, 6-turn max)        | E.2              | 6 hrs           | \[ \]     |
| Addendum F: Analytics track() utility + all events wired                  | F.5              | 4 hrs           | \[ \]     |
| Addendum G: abbreviations.json (100 terms) + searchable UI                | G.1              | 4 hrs           | \[ \]     |
| Fix "LoopCraft logo" copy error in onboarding table → "StitchVision"      | Brief Part 2     | 5 min           | \[ \]     |
| Clarify Free Tier: 1 LIFETIME pattern upload (not monthly)                | PRD 1.3          | 30 min (copy)   | \[ \]     |

## **P1 - High Impact, Ship if Time Allows in v1.0**

| **Item**                                          | **Addendum Ref** | **Effort Est.** | **Done?** |
| ------------------------------------------------- | ---------------- | --------------- | --------- |
| Addendum H: Streak system + Badges                | H.1-H.2          | 5 hrs           | \[ \]     |
| Addendum I.1: Apple Watch app (WatchOS extension) | I.1              | 16 hrs          | \[ \]     |
| Addendum I.2: iOS Home Screen Widget (WidgetKit)  | I.2              | 8 hrs           | \[ \]     |

## **v1.1 - Post-Launch (Do Not Delay Launch For These)**

| **Item**                                                  | **Addendum Ref** | **Effort Est.** | **Done?** |
| --------------------------------------------------------- | ---------------- | --------------- | --------- |
| Addendum A.5: Photo Journal                               | A.5              | 12 hrs          | \[ \]     |
| Addendum A.6: Due Date Reminders                          | A.6              | 4 hrs           | \[ \]     |
| Addendum J: Begin CraftEngine SDK extraction + WeavePilot | J.2-J.4          | 40+ hrs         | \[ \]     |

# **CRAFTENGINE DEVELOPER REFERENCE CARD**

Quick-reference for StitchVision configuration within the CraftEngine shared architecture. Every value here must match the shared Cloud Functions, Firestore rules, and CraftEngine core package config. If anything conflicts with another section of this PRD, this card is the authoritative source for app-specific identifiers.

| **Configuration**       | **Value**                                                                                                                                    |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| **App ID**              | "stitchvision"                                                                                                                               |
| **Firestore Root**      | sv_users/{uid}                                                                                                                               |
| **Analytics Prefix**    | sv\_                                                                                                                                         |
| **Bot Name**            | StitchBot                                                                                                                                    |
| **Bot Prompt Location** | Addendum E, Section E.2                                                                                                                      |
| **RevenueCat Products** | \$7.99/mo · \$39.99/yr (Annual primary CTA)                                                                                                  |
| **Free limits**         | 1 project/pattern · 3 photo checks/mo · 1 PDF (lifetime) · 10 assistant questions/mo                                                         |
| **Pro limits**          | Unlimited projects · 50 photo checks/mo · 5 PDFs/mo · Unlimited assistant                                                                    |
| **Primary CTA Color**   | #8FA888 (Sage) - white text on CTA; terracotta (#C96D5F) for high-emphasis CTAs                                                              |
| **Accent/Badge Color**  | #C96D5F (Terracotta) - badges, save tags                                                                                                     |
| **Dark Background**     | #1A1A1A (OLED black)                                                                                                                         |
| **Vision Module**       | On-device optical flow (iOS: Vision.framework / Android: OpenCV4Android). Knitting: horizontal vector. Crochet: flow-valley + upward vector. |
| **CraftEngine Phase**   | Phase 1 - Reference implementation for all CraftEngine apps                                                                                  |
| **Unique Features**     | Vision row counting · Stitch Doctor · StitchBot · Apple Watch widget · Calibration flow                                                      |
| **Cross-App Upsell**    | Show other live CraftEngine apps below paywall CTA. Use remote config - no release needed.                                                   |
| **Video to Cloud**      | NEVER. Still image only for photo-check. No continuous camera session. No video stream.                                                      |
| **AI Label Policy**     | Never expose model name (Gemini/GPT). Never stream conversation history to server.                                                           |
| **Monthly Reset**       | Shared Scheduled Function - 1st of each month 00:01 UTC. Covers all apps.                                                                    |

_This card was auto-generated from the CraftEngine alignment audit. Update all four PRDs simultaneously when any shared value changes._