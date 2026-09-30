# VELORA by Stylito — Luxury Fashion Landing Page

A high-fashion, editorial landing page website created in a dedicated standalone folder (d:\stylito\landing_page\), formatted like the modular structure of the BiteBox project.

## Reference Design Features Included:
1. **Top Announcement Strip**: Black bar highlighting "FREE SHIPPING ON ORDERS OVER  | EASY RETURNS WITHIN 30 DAYS".
2. **Luxury Header**: Elegant serif branding (**VELORA**), menu links (New In, Clothing, Dresses, Tops, Bottoms, Accessories, Sale), search, account, live wishlist counter, and live shopping bag counter.
3. **Hero Section**: Eyebrow "NEW SEASON COLLECTION", serif title "Elevated Style. Everyday You.", description, and "SHOP NEW ARRIVALS" button paired with high-fashion model portrait.
4. **Shop by Category**: 6 circular cards (DRESSES, TOPS, BOTTOMS, ACCESSORIES, OUTERWEAR, SALE) with hover zoom and click-to-filter interaction.
5. **New Arrivals Grid**: 4-column product cards with wishlist heart toggle, color swatches, and quick add-to-bag button.
6. **Trust & Value Propositions Strip**: 4 badges with line icons (Free Shipping, Easy Returns, Secure Payment, Quality Guarantee).
7. **Summer Refresh Promotional Banner**: Inset sand/stone banner with limited-time discount tag and CTA.
8. **Instagram / Social Community**: "#VELORASTYLE" 6-tile curated lookbook gallery.
9. **Newsletter Strip**: "STAY IN THE KNOW" subscription box with input validation and instant feedback.
10. **Multi-Column Luxury Footer**: Brand story, navigation columns, customer care, legal links, and payment badges (Visa, Mastercard, Amex, PayPal, Apple Pay).
11. **Interactive Drawers**:
    - Slide-out Cart Drawer with item list, quantity adjustment (+/-), remove, subtotal, and checkout.
    - Wishlist toggling saved in localStorage.
    - Real-time search modal.
    - Mobile responsive hamburger menu drawer.

## Files

| File | Description |
| --- | --- |
| index.html | Semantic HTML5 structure containing all 10 visual sections |
| styles.css | High-fashion editorial styling, responsive grid & flexbox layouts, animations |
| pp.js | Interactive shopping bag, wishlist, search filter, and mobile drawer |
| bout.html | Brand story, values, and craftsmanship page |
| privacy-policy.html | Complete e-commerce privacy policy documentation |
| 	erms.html | Terms of service, shipping, and return policies |
| ssets/ | High-resolution images and SVG assets |

## How to Run Locally

### Option 1: Direct File Open
Simply double-click index.html or open it in any modern browser (Chrome, Edge, Firefox, Safari).

### Option 2: Static HTTP Server (Recommended)
Open a terminal in this directory:
`ash
cd d:\stylito\landing_page
python -m http.server 8000
`
Then navigate to http://localhost:8000/.

Or with Node.js:
`ash
npx serve .
`

## Deployment
This static landing page has zero external build dependencies and can be deployed directly to:
- **Firebase Hosting**
- **Vercel / Netlify**
- **GitHub Pages**
- **AWS S3 / CloudFront**
