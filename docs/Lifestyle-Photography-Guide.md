# Lifestyle Photography Generation Guide

This guide provides prompts for generating 6 lifestyle photography images for the StitchVision onboarding flow.

## Image Specifications

- **Aspect Ratio:** 9:16 (portrait/mobile)
- **Resolution:** 1080x1920px
- **Format:** WebP or PNG
- **Max File Size:** 300KB per image

---

## Midjourney Prompts

### Image 1: Value Carousel Screen 1 ("Never Lose Your Place")

**Purpose:** Background for "Never Lose Your Place" value prop

```
Close-up photo of hands holding knitting needles mid-stitch, warm afternoon light streaming through window, shallow depth of field, cozy home interior blurred in background, cream and sage green yarn, Canon 5D Mark IV, f/2.8, lifestyle photography, Pinterest aesthetic, warm tones, intimate moment --ar 9:16 --style raw --v 6
```

**Text Overlay:**
- Headline: "Never Lose Your Place"
- Subtitle: "AI-powered row counter tracks your progress"

---

### Image 2: Value Carousel Screen 2 ("AI Stitch Doctor")

**Purpose:** Background for "AI Stitch Doctor" value prop

```
Overhead flat lay of colorful yarn balls (terracotta, sage green, cream, mustard yellow), wooden knitting needles, in-progress knitted swatch with visible stitch detail, natural wood table surface, soft natural lighting, Instagram craft aesthetic, warm inviting color palette, organized chaos --ar 9:16 --style raw --v 6
```

**Text Overlay:**
- Headline: "Catch Mistakes Instantly"
- Subtitle: "AI spots dropped stitches before you do"

---

### Image 3: Value Carousel Screen 3 ("80+ Free Patterns")

**Purpose:** Background for "80+ Free Patterns" value prop

```
Person's hands holding colorful granny square crochet work in vibrant colors (pink, orange, blue, green), warm cozy lighting, comfortable home setting, shallow focus on the handmade squares, feeling of pride and accomplishment, lifestyle photography, Canon EOS R5, authentic moment --ar 9:16 --style raw --v 6
```

**Text Overlay:**
- Headline: "Start Your Next Project"
- Subtitle: "Beginner to advanced patterns included"

---

### Image 4: Camera Permission Screen

**Purpose:** Background for camera permission request

```
Close-up of hands knitting with cream-colored yarn, knitting needles in motion, soft focus on the working stitches, warm indirect sunlight, inviting peaceful atmosphere, detailed stitch texture visible, shallow depth of field, professional lifestyle photography --ar 9:16 --style raw --v 6
```

**Text Overlay:**
- Headline: "Enable Your AI Counter"
- Subtitle: "Allow camera access for automatic row tracking"

---

### Image 5: Calibration Screen

**Purpose:** Background for calibration instructions

```
First-person POV looking down at hands knitting on lap, needles mid-turn at end of row, work-in-progress scarf in sage green yarn, cozy chair visible at edge of frame, natural window light, personal intimate perspective, Canon RF 50mm f/1.2, warm welcoming tones --ar 9:16 --style raw --v 6
```

**Text Overlay:**
- Headline: "Knit Normally for 30 Seconds"
- Subtitle: "We'll calibrate your AI counter"

---

### Image 6: Splash Screen Background

**Purpose:** App logo background on launch

```
Minimalist flat lay of single ball of sage green yarn on matching fabric background, soft shadows, clean modern aesthetic, studio lighting, texture visible, calming zen atmosphere --ar 9:16 --style raw --v 6
```

**Design:**
- Solid sage green background (#8FA888)
- App icon centered
- Tagline: "Your AI Knitting Companion"

---

## Ideogram 2.0 Alternative Prompts

If using Ideogram instead of Midjourney, add typography hints:

```
A warm lifestyle photograph of hands knitting with sage green yarn, soft natural lighting, cozy atmosphere, with space for text overlay at the bottom, mobile wallpaper vertical composition
```

---

## Fallback: Stock Photo Sources

If AI generation is unavailable, use Unsplash search terms:

1. **knitting hands close up** - Filter for warm lighting
2. **yarn ball flat lay** - Look for colorful arrangements
3. **crochet work hands** - Find authentic craft moments
4. **knitting needles action** - Seek motion/progress shots

**Diversity Note:** Ensure images show variety in skin tones across the 6 images.

---

## Post-Processing

After generating/sourcing images:

### 1. Export Settings
- Resolution: 1080x1920px
- Format: WebP (smaller file size)
- Compression: <300KB

### 2. Create @2x and @3x Variants

```bash
# Using sips (macOS)
sips -z 2160 3840 original.png --out image@2x.webp
sips -z 3240 5760 original.png --out image@3x.webp
```

### 3. Add to Xcode Assets

Location: `StitchVision/Resources/Assets.xcassets/OnboardingImages/`

### 4. Test Text Readability

- Minimum 4.5:1 contrast ratio for text
- Apply gradient overlay to ensure readability:

```swift
LinearGradient(
    colors: [
        Color.black.opacity(0),
        Color.black.opacity(0.6)
    ],
    startPoint: .top,
    endPoint: .bottom
)
```

---

## File Naming Convention

```
onboarding-value-1@2x.webp
onboarding-value-1@3x.webp
onboarding-value-2@2x.webp
onboarding-value-2@3x.webp
onboarding-value-3@2x.webp
onboarding-value-3@3x.webp
onboarding-camera-permission@2x.webp
onboarding-camera-permission@3x.webp
onboarding-calibration@2x.webp
onboarding-calibration@3x.webp
splash-background@2x.webp
splash-background@3x.webp
```

---

## Using Images in Code

Update `ValuePropCarouselView.swift`:

```swift
struct ValuePropPageView: View {
    let page: ValuePropPage

    var body: some View {
        VStack(spacing: 24) {
            // Replace placeholder with actual image
            Image(page.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 280, height: 380)
                .clipped()
                .cornerRadius(24)

            // Text content...
        }
    }
}
```

---

## Timeline

| Task | Time |
|------|------|
| Generate 6 images with AI | 2 hours |
| Source fallback stock photos | 1 hour |
| Process & compress images | 1 hour |
| Add to Xcode assets | 30 min |
| Test in app | 30 min |
| **Total** | **5 hours** |

---

## Quality Checklist

- [ ] All images are 1080x1920px
- [ ] All images are under 300KB
- [ ] Text overlays have 4.5:1 contrast
- [ ] @2x and @3x variants created
- [ ] Images added to Assets.xcassets
- [ ] ValuePropCarouselView updated to use real images
- [ ] Tested on multiple device sizes
