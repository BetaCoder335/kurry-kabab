-- ═══════════════════════════════════════════════════
-- Kurry & Kabab — Supabase Schema
-- Run this in your Supabase SQL editor
-- ═══════════════════════════════════════════════════

-- ── Enable UUID extension ──
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ════════════════════════════════
-- TABLE: menu_items
-- ════════════════════════════════
CREATE TABLE IF NOT EXISTS menu_items (
  id            TEXT        PRIMARY KEY DEFAULT uuid_generate_v4()::text,
  name          TEXT        NOT NULL,
  category      TEXT        NOT NULL,
  sub_category  TEXT,
  is_veg        BOOLEAN     NOT NULL DEFAULT true,
  calories      INTEGER     NOT NULL DEFAULT 0,
  price         TEXT        NOT NULL,   -- stored as "280" or "280/370"
  description   TEXT,
  tags          TEXT[]      DEFAULT '{}',
  is_active     BOOLEAN     NOT NULL DEFAULT true,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER menu_items_updated_at
  BEFORE UPDATE ON menu_items
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ════════════════════════════════
-- TABLE: bookings
-- ════════════════════════════════
CREATE TABLE IF NOT EXISTS bookings (
  id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  name        TEXT        NOT NULL,
  phone       TEXT        NOT NULL,
  date        DATE        NOT NULL,
  time        TEXT        NOT NULL,
  guests      TEXT        NOT NULL DEFAULT '2',
  request     TEXT,
  status      TEXT        NOT NULL DEFAULT 'pending'
                          CHECK (status IN ('pending','confirmed','cancelled')),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ════════════════════════════════
-- ROW LEVEL SECURITY
-- ════════════════════════════════
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings   ENABLE ROW LEVEL SECURITY;

-- Public can read active menu items
CREATE POLICY "Public read active menu"
  ON menu_items FOR SELECT
  USING (is_active = true);

-- Authenticated users (admin) can do everything
CREATE POLICY "Admin full access to menu"
  ON menu_items FOR ALL
  USING (auth.role() = 'authenticated');

-- Anyone can insert a booking (table reservation form)
CREATE POLICY "Public insert bookings"
  ON bookings FOR INSERT
  WITH CHECK (true);

-- Only authenticated users can read/update bookings
CREATE POLICY "Admin read bookings"
  ON bookings FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Admin update bookings"
  ON bookings FOR UPDATE
  USING (auth.role() = 'authenticated');

-- ════════════════════════════════
-- INDEXES
-- ════════════════════════════════
CREATE INDEX idx_menu_items_category  ON menu_items (category);
CREATE INDEX idx_menu_items_is_veg    ON menu_items (is_veg);
CREATE INDEX idx_menu_items_is_active ON menu_items (is_active);
CREATE INDEX idx_bookings_date        ON bookings (date);
CREATE INDEX idx_bookings_status      ON bookings (status);

-- ════════════════════════════════
-- SEED: Insert all menu items
-- ════════════════════════════════
INSERT INTO menu_items (id, name, category, sub_category, is_veg, calories, price, description, tags) VALUES

-- SOUPS
('s1',  'Cream Soup (Tomato/Veg/Mushroom)', 'Soups', NULL, true,  120, '140',      NULL, '{}'),
('s2',  'Murgh Shorba',                    'Soups', NULL, false,  95, '170',      NULL, '{}'),
('s3',  'Mutton Paya Shorba',              'Soups', NULL, false, 180, '180',      NULL, '{}'),
('s4',  'Sweetcorn Veg',                   'Soups', NULL, true,  150, '140',      NULL, '{}'),
('s5',  'Sweetcorn Chicken',               'Soups', NULL, false, 180, '175',      NULL, '{}'),
('s6',  'Hot n Sour Veg',                  'Soups', NULL, true,  110, '140',      NULL, '{}'),
('s7',  'Hot n Sour Chicken',              'Soups', NULL, false, 140, '175',      NULL, '{}'),
('s8',  'Manchow Veg',                     'Soups', NULL, true,  130, '150',      NULL, '{}'),
('s9',  'Manchow Chicken',                 'Soups', NULL, false, 160, '180',      NULL, '{}'),
('s10', 'Thukpa Veg',                      'Soups', NULL, true,  200, '220',      NULL, '{}'),
('s11', 'Thukpa Chicken',                  'Soups', NULL, false, 240, '260',      NULL, '{}'),
('s12', 'Lemon Coriander Veg',             'Soups', NULL, true,   80, '180',      NULL, '{}'),
('s13', 'Lemon Coriander Chicken',         'Soups', NULL, false, 110, '210',      NULL, '{}'),
('s14', 'Prawn n Noodle',                  'Soups', NULL, false, 220, '250',      NULL, '{"Seafood"}'),

-- STARTERS NON-VEG
('nv1',  'Murgh Tandoori',           'Starters', 'Non-Veg', false, 320, '325/575', NULL, '{"Tandoor"}'),
('nv2',  'Murgh Afghani',            'Starters', 'Non-Veg', false, 380, '350/610', NULL, '{"Tandoor"}'),
('nv3',  'Murgh Tikka',              'Starters', 'Non-Veg', false, 320, '350',     NULL, '{"Tandoor"}'),
('nv4',  'Murgh Malai Tikka',        'Starters', 'Non-Veg', false, 380, '380',     NULL, '{"Tandoor"}'),
('nv5',  'Murgh Haryali Tikka',      'Starters', 'Non-Veg', false, 300, '350',     NULL, '{"Tandoor"}'),
('nv9',  'Mutton Shaami Kabab (6pc)','Starters', 'Non-Veg', false, 420, '380',     NULL, '{"Kabab"}'),
('nv10', 'Mutton Seekh Kabab (2pc)', 'Starters', 'Non-Veg', false, 280, '380',     NULL, '{"Kabab"}'),
('nv11', 'Chicken Seekh Kabab (2pc)','Starters', 'Non-Veg', false, 240, '300',     NULL, '{"Kabab"}'),
('nv12', 'Crab Claws (6pc)',         'Starters', 'Non-Veg', false, 200, '280',     NULL, '{"Seafood"}'),
('nv13', 'Surmai Fry (4pc)',         'Starters', 'Non-Veg', false, 360, '480',     NULL, '{"Seafood"}'),
('nv14', 'Fish Tikka (6pc)',         'Starters', 'Non-Veg', false, 380, '420',     NULL, '{"Seafood","Tandoor"}'),
('nv17', 'Non Veg Platter (21pc)',   'Starters', 'Non-Veg', false, 900, '1199',    NULL, '{"Platter","Bestseller"}'),
('nv18', 'Seafood Platter (21pc)',   'Starters', 'Non-Veg', false, 850, '1399',    NULL, '{"Platter","Seafood"}'),

-- STARTERS VEG
('v1', 'Paneer Angare (6pc)',          'Starters', 'Veg', true, 380, '370', NULL, '{"Tandoor"}'),
('v2', 'Paneer Haryali Tikka (6pc)',   'Starters', 'Veg', true, 360, '370', NULL, '{"Tandoor"}'),
('v3', 'Paneer Afghani Tikka (6pc)',   'Starters', 'Veg', true, 400, '390', NULL, '{"Tandoor"}'),
('v4', 'Paneer Malai Tikka (6pc)',     'Starters', 'Veg', true, 420, '390', NULL, '{"Tandoor"}'),
('v5', 'Hara Bhara Kabab (8pc)',       'Starters', 'Veg', true, 320, '300', NULL, '{"Kabab"}'),
('v6', 'Tandoori Soya Chaap (10pc)',   'Starters', 'Veg', true, 380, '300', NULL, '{"Tandoor"}'),
('v9', 'Veg Tandoori Platter (21pc)',  'Starters', 'Veg', true, 750, '899', NULL, '{"Platter"}'),

-- MAIN COURSE VEG
('mc1',  'Paneer Makhani',       'Main Course', 'Veg', true, 420, '280/370', NULL, '{"Bestseller"}'),
('mc2',  'Paneer Tikka Masala',  'Main Course', 'Veg', true, 440, '280/370', NULL, '{}'),
('mc4',  'Mutter Paneer',        'Main Course', 'Veg', true, 360, '210/350', NULL, '{}'),
('mc8',  'Kadhai Paneer',        'Main Course', 'Veg', true, 420, '280/370', NULL, '{}'),
('mc9',  'Shahi Paneer',         'Main Course', 'Veg', true, 480, '345/420', NULL, '{"Rich"}'),
('mc24', 'Chole Bhature',        'Main Course', 'Veg', true, 550, '190',     NULL, '{"Bestseller"}'),

-- MAIN COURSE NON-VEG
('mn1',  'Gosht Roganjosh',      'Main Course', 'Non-Veg', false, 450, '300/500', NULL, '{"Bestseller"}'),
('mn12', 'Chicken Tikka Masala', 'Main Course', 'Non-Veg', false, 460, '285/450', NULL, '{"Bestseller"}'),
('mn13', 'Chicken Makhani',      'Main Course', 'Non-Veg', false, 480, '410/600', NULL, '{"Bestseller"}'),
('mn20', 'Jhinga Masala',        'Main Course', 'Non-Veg', false, 350, '295/475', NULL, '{"Seafood"}'),
('mn21', 'Fish Curry',           'Main Course', 'Non-Veg', false, 320, '295/475', NULL, '{"Seafood"}'),
('mn22', 'Egg Curry (2 eggs)',   'Main Course', 'Non-Veg', false, 280, '190',     NULL, '{}'),

-- BIRYANI & RICE
('r9',  'Awadhi Biryani',        'Biryani & Rice', NULL, false, 580, '295/530', NULL, '{"Bestseller"}'),
('r14', 'Tandoori Biryani',      'Biryani & Rice', NULL, false, 600, '295/530', NULL, '{"Bestseller"}'),
('r18', 'Mutton Biryani',        'Biryani & Rice', NULL, false, 640, '400/620', NULL, '{"Bestseller"}'),
('r16', 'Chicken Tikka Biryani', 'Biryani & Rice', NULL, false, 580, '280/540', NULL, '{}'),
('r21', 'Paneer Tikka Biryani',  'Biryani & Rice', NULL, true,  500, '225/420', NULL, '{}'),

-- LENTILS
('l1', 'Dal Tadka',        'Lentils', NULL, true, 280, '160/260', NULL, '{}'),
('l2', 'Dal Makhni',       'Lentils', NULL, true, 340, '190/290', NULL, '{"Bestseller"}'),
('l4', 'Rajma Masala',     'Lentils', NULL, true, 320, '170/270', NULL, '{}'),
('l5', 'Chole Amritsari',  'Lentils', NULL, true, 380, '135/230', NULL, '{}'),

-- BREADS
('b1',  'Garlic Naan',         'Breads', NULL, true, 220, '50', NULL, '{}'),
('b4',  'Garlic Butter Naan',  'Breads', NULL, true, 240, '60', NULL, '{}'),
('b8',  'Aloo Paratha',        'Breads', NULL, true, 280, '85', NULL, '{}'),
('b12', 'Keema Paratha',       'Breads', NULL, false,380, '150', NULL, '{}'),

-- ORIENTAL STARTERS
('or1',  'Chilly Chicken',            'Oriental', 'Starters', false, 380, '300', NULL, '{"Spicy"}'),
('or4',  'Chicken 65',                'Oriental', 'Starters', false, 400, '320', NULL, '{"Spicy","Bestseller"}'),
('or6',  'Chicken Lollypop (Fry)',    'Oriental', 'Starters', false, 350, '230', NULL, '{}'),
('or17', 'Paneer Chilly',             'Oriental', 'Starters', true,  380, '300', NULL, '{}'),
('or21', 'Gobi Manchurian',           'Oriental', 'Starters', true,  320, '250', NULL, '{}'),
('or25', 'Veg Momo',                  'Oriental', 'Starters', true,  240, '120', NULL, '{}'),
('or28', 'Honey Chilli Potato',       'Oriental', 'Starters', true,  320, '250', NULL, '{}'),

-- NOODLES
('n1',  'Veg Hakka Noodles',             'Noodles', NULL, true,  340, '175/260', NULL, '{}'),
('n7',  'Chicken Hakka Noodles',         'Noodles', NULL, false, 420, '195/295', NULL, '{}'),
('n8',  'Chicken Schezwan Noodles',      'Noodles', NULL, false, 440, '200/310', NULL, '{"Spicy"}'),
('n13', 'Veg Fried Rice',                'Noodles', NULL, true,  340, '185/270', NULL, '{}'),
('n18', 'Chicken Fried Rice',            'Noodles', NULL, false, 420, '190/290', NULL, '{}'),
('n23', 'Egg Fried Rice',                'Noodles', NULL, false, 380, '155/240', NULL, '{}'),

-- THALI
('th1', 'Veg Thali',     'Thali', NULL, true,  700, '90',  'Subji + Dal + Rice + Roti + Salad + Papad', '{}'),
('th2', 'Paneer Thali',  'Thali', NULL, true,  780, '110', 'Paneer Gravy + Dal + Rice + Roti + Salad + Papad', '{}'),
('th4', 'Chicken Thali', 'Thali', NULL, false, 900, '130', 'Chicken Curry + Subji + Rice + Roti + Salad + Papad', '{"Bestseller"}'),
('th6', 'Mutton Thali',  'Thali', NULL, false, 950, '160', 'Mutton Curry + Subji + Rice + Roti + Salad + Papad', '{}'),

-- COMBO MEALS
('cm9',  'Butter Chicken with Dal Makhni Meal', 'Combo Meals', NULL, false, 920, '330', 'Butter Chicken + Dal Makhni + Rice + 2 Butter Roti', '{"Bestseller"}'),
('cm14', 'Chicken Overload Meal',               'Combo Meals', NULL, false, 980, '340', 'Butter Chicken + 2pc Chicken Tikka + Jeera Rice + 1 Butter Naan', '{"Bestseller"}'),
('cm1',  'Paneer Makhni with Jeera Aloo Meal',  'Combo Meals', NULL, true,  820, '305', 'Paneer Makhni + Jeera Aloo + Rice + 2 Butter Roti', '{}'),
('cm8',  'Veg Biryani Meal',                    'Combo Meals', NULL, true,  900, '330', 'Veg Biryani + 2pc Paneer Tikka + Raita', '{}'),

-- DRINKS
('d1', 'Blue Lagoon',             'Drinks', NULL, true,  80,  '100', NULL, '{}'),
('d2', 'Virgin Mojito',           'Drinks', NULL, true,  90,  '100', NULL, '{}'),
('d5', 'Milk Shake',              'Drinks', NULL, true,  250, '130', NULL, '{}'),
('d6', 'Milk Shake with Ice Cream','Drinks', NULL, true, 320, '140', NULL, '{}'),
('d7', 'Fresh Lime Soda',         'Drinks', NULL, true,  40,  '50',  NULL, '{}'),
('d9', 'Tea',                     'Drinks', NULL, true,  30,  '20',  NULL, '{}'),
('d10','Coffee',                  'Drinks', NULL, true,  50,  '30',  NULL, '{}')

ON CONFLICT (id) DO NOTHING;
