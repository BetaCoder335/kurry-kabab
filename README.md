# 🍛 Kurry & Kabab — Restaurant Website

**Premium modern restaurant website** for Kurry & Kabab, Waholi, Pune.

> Discover a new level of taste.

---

## ✨ Features

| Feature | Details |
|---|---|
| **Full Digital Menu** | 200+ dishes extracted from PDF, organised by category |
| **Calorie Estimates** | Every dish shows estimated kcal |
| **Menu Filters** | Veg / Non-Veg / Category / Search |
| **Table Booking** | Glass-form with Supabase backend |
| **QR Menu Page** | `/menu` — scan-friendly mobile menu |
| **Admin Panel** | `/admin` — add / edit / delete dishes & view bookings |
| **Google Map** | Embedded location section |
| **Glassmorphism UI** | Premium dark theme, ember-orange accents |
| **Animations** | Framer Motion page transitions, scroll reveals |

---

## 🗂 Project Structure

```
kurry-kabab/
├── src/
│   ├── app/
│   │   ├── layout.tsx          # Root layout + metadata
│   │   ├── globals.css         # All CSS variables, glass, animations
│   │   ├── page.tsx            # Homepage (Hero → Menu → Book → Location)
│   │   ├── menu/
│   │   │   └── page.tsx        # /menu — QR code landing page
│   │   └── admin/
│   │       └── page.tsx        # /admin — password-protected dashboard
│   ├── components/
│   │   ├── Navigation.tsx      # Sticky glass nav + mobile drawer
│   │   ├── Hero.tsx            # Full-screen hero with floating words
│   │   ├── MenuSection.tsx     # Filtered & grouped menu grid
│   │   ├── MenuCard.tsx        # Individual dish card
│   │   ├── MenuFilters.tsx     # Scrollable filter pills
│   │   ├── BookingForm.tsx     # Glass reservation form
│   │   ├── LocationSection.tsx # Map + hours + contact details
│   │   └── Footer.tsx          # Footer with links
│   ├── data/
│   │   └── menuData.ts         # All 200+ dishes with calories
│   └── lib/
│       └── supabase.ts         # Supabase client + helper functions
├── supabase/
│   └── schema.sql              # Full DB schema + seed data
├── .env.local.example          # Environment variables template
├── tailwind.config.js
├── next.config.js
├── tsconfig.json
└── package.json
```

---

## 🚀 Quick Start (Local Development)

### 1. Install dependencies
```bash
npm install
```

### 2. Configure environment variables
```bash
cp .env.local.example .env.local
# Edit .env.local with your Supabase credentials
```

### 3. Set up Supabase
1. Create a project at [supabase.com](https://supabase.com)
2. Go to **SQL Editor** → paste contents of `supabase/schema.sql` → Run
3. Copy your **Project URL** and **anon key** into `.env.local`

### 4. Run development server
```bash
npm run dev
# Open http://localhost:3000
```

---

## 🌐 Deployment (Vercel — Recommended)

### One-click deploy
```bash
npm install -g vercel
vercel
```

### Or via Vercel Dashboard
1. Push this project to GitHub
2. Go to [vercel.com](https://vercel.com) → New Project → Import your repo
3. Add environment variables:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `NEXT_PUBLIC_ADMIN_PASSWORD`
4. Deploy → your site is live!

### Custom domain
In Vercel dashboard → Settings → Domains → Add `kurryandkabab.com`

---

## 🗄 Supabase Setup (Detailed)

### Tables created by `schema.sql`:

**`menu_items`**
| Column | Type | Notes |
|---|---|---|
| id | TEXT | Primary key |
| name | TEXT | Dish name |
| category | TEXT | e.g. "Main Course" |
| sub_category | TEXT | "Veg" or "Non-Veg" |
| is_veg | BOOLEAN | |
| calories | INTEGER | Estimated kcal |
| price | TEXT | "280" or "280/370" |
| description | TEXT | Optional |
| tags | TEXT[] | ["Bestseller","Spicy"] |
| is_active | BOOLEAN | Soft delete |
| created_at | TIMESTAMPTZ | |
| updated_at | TIMESTAMPTZ | Auto-updated |

**`bookings`**
| Column | Type | Notes |
|---|---|---|
| id | UUID | Primary key |
| name | TEXT | Guest name |
| phone | TEXT | |
| date | DATE | |
| time | TEXT | "07:30 PM" |
| guests | TEXT | "2" |
| request | TEXT | Special requests |
| status | TEXT | pending/confirmed/cancelled |
| created_at | TIMESTAMPTZ | |

---

## 📱 QR Code Menu

The `/menu` page is designed for QR code scanning:
- Sticky search + filter header
- Lightweight list layout (not grid)
- Shows calories, price, veg indicator

**Generate QR Code:**
Use [qr-code-generator.com](https://www.qr-code-generator.com/) with URL:
`https://yourdomain.com/menu`

Print and place on tables.

---

## 🔐 Admin Panel

Access at `/admin` with your password (default: `kurry2024`).

**Capabilities:**
- 🔍 Search & filter dishes
- ✏️ Edit name, price, calories inline
- ➕ Add new dishes
- 🗑️ Remove dishes
- 📅 View bookings (requires Supabase connected)

**Change password:**
Update `NEXT_PUBLIC_ADMIN_PASSWORD` in `.env.local`

---

## 🎨 Design System

| Element | Value |
|---|---|
| Primary color | `#f97316` (Ember Orange) |
| Accent | `#d4a843` (Gold) |
| Background | `#0d0d0d` (Near-black) |
| Display font | Cormorant Garamond |
| Body font | DM Sans |
| Border radius (cards) | 12px |
| Glass bg | `rgba(255,255,255,0.04)` |
| Glass border | `rgba(255,255,255,0.08)` |

---

## 📞 Restaurant Info

| | |
|---|---|
| **Name** | Kurry & Kabab |
| **Address** | Kurry n Kabab, Mauli Market, Opp. Rohan Abhilasha, Wagholi, Pune – 412207 |
| **Phone** | +91 98814 76738, +91 94153 88672 |
| **Hours** | Mon–Sun (Tuesday Closed) · 12:00 PM – 3:00 PM & 7:00 PM – 11:00 PM |
| **GST** | 27AOMPS4087D1ZJ |
| **FSSAI** | 21521182002712 |

---



## 📊 Menu Data

All 200+ dishes are in `src/data/menuData.ts`. Calories are estimated based on standard restaurant serving sizes.

**Categories:**
- Soups (14 items)
- Starters Veg (9) + Non-Veg (18)
- Main Course Veg (24) + Non-Veg (23)
- Biryani & Rice (25)
- Lentils (5)
- Breads (17)
- Sizzlers (6)
- Marinades (7)
- Oriental Starters (28)
- Oriental Main Course (11)
- Noodles & Fried Rice (24)
- Rice Bowl Veg (10) + Non-Veg (8)
- Combo Meals (15)
- Thali (6)
- Drinks (10)

**Total: ~240 items**

---

*Built with ❤️ for Kurry & Kabab, Pune*
