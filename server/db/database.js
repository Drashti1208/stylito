const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const fs = require('fs');

const dataDir = path.join(__dirname, '..', 'data');
if (!fs.existsSync(dataDir)) {
  fs.mkdirSync(dataDir, { recursive: true });
}

const dbPath = path.join(dataDir, 'stylito.db');
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('❌ Failed to connect to SQLite database:', err.message);
  } else {
    console.log(' Connected to SQLite database at:', dbPath);
  }
});

// Promisified wrappers
function run(sql, params = []) {
  return new Promise((resolve, reject) => {
    db.run(sql, params, function (err) {
      if (err) reject(err);
      else resolve({ lastID: this.lastID, changes: this.changes });
    });
  });
}

function get(sql, params = []) {
  return new Promise((resolve, reject) => {
    db.get(sql, params, (err, row) => {
      if (err) reject(err);
      else resolve(row);
    });
  });
}

function all(sql, params = []) {
  return new Promise((resolve, reject) => {
    db.all(sql, params, (err, rows) => {
      if (err) reject(err);
      else resolve(rows);
    });
  });
}

// Initialize tables & seed initial data
async function initDatabase() {
  await run(`PRAGMA foreign_keys = ON;`);

  // 1. Users Table
  await run(`
    CREATE TABLE IF NOT EXISTS users (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      password_hash TEXT NOT NULL,
      pincode TEXT DEFAULT '',
      address TEXT DEFAULT '',
      city TEXT DEFAULT '',
      state TEXT DEFAULT '',
      country TEXT DEFAULT 'India',
      bank_account_number TEXT DEFAULT '',
      account_holder_name TEXT DEFAULT '',
      ifsc_code TEXT DEFAULT '',
      phone TEXT DEFAULT '',
      google_id TEXT DEFAULT '',
      avatar_url TEXT DEFAULT '',
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);

  // Safe migrations for existing database
  try { await run(`ALTER TABLE users ADD COLUMN phone TEXT DEFAULT ''`); } catch (_) {}
  try { await run(`ALTER TABLE users ADD COLUMN google_id TEXT DEFAULT ''`); } catch (_) {}
  try { await run(`ALTER TABLE users ADD COLUMN avatar_url TEXT DEFAULT ''`); } catch (_) {}

  // 1b. OTPs Table (Real-time OTP storage without Firebase)
  await run(`
    CREATE TABLE IF NOT EXISTS otps (
      id TEXT PRIMARY KEY,
      contact TEXT NOT NULL,
      code TEXT NOT NULL,
      expires_at DATETIME NOT NULL,
      is_used INTEGER DEFAULT 0,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);

  // 2. Categories Table
  await run(`
    CREATE TABLE IF NOT EXISTS categories (
      id TEXT PRIMARY KEY,
      slug TEXT UNIQUE NOT NULL,
      name TEXT NOT NULL,
      image_url TEXT,
      description TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);

  // 3. Products Table
  await run(`
    CREATE TABLE IF NOT EXISTS products (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      subtitle TEXT,
      description TEXT,
      price REAL NOT NULL,
      original_price REAL NOT NULL,
      discount_percent INTEGER DEFAULT 0,
      rating REAL DEFAULT 4.5,
      review_count INTEGER DEFAULT 120,
      image_url TEXT NOT NULL,
      gallery_images TEXT, -- JSON array
      sizes TEXT,          -- JSON array
      category TEXT NOT NULL,
      delivery_time TEXT DEFAULT 'Delivery in 1 within Hour',
      is_deal_of_the_day INTEGER DEFAULT 0,
      is_trending INTEGER DEFAULT 0,
      is_new_arrival INTEGER DEFAULT 0,
      inventory_count INTEGER DEFAULT 50,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);

  // 4. Orders Table
  await run(`
    CREATE TABLE IF NOT EXISTS orders (
      id TEXT PRIMARY KEY,
      user_id TEXT,
      customer_name TEXT NOT NULL,
      customer_email TEXT NOT NULL,
      shipping_address TEXT NOT NULL,
      items TEXT NOT NULL, -- JSON array of items
      subtotal REAL NOT NULL,
      discount_amount REAL DEFAULT 0,
      delivery_fee REAL DEFAULT 0,
      total_amount REAL NOT NULL,
      payment_method TEXT NOT NULL,
      payment_status TEXT DEFAULT 'Completed',
      order_status TEXT DEFAULT 'Processing',
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL
    )
  `);

  // 5. Customer Inquiries / Direct Messages Table
  await run(`
    CREATE TABLE IF NOT EXISTS inquiries (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      email TEXT NOT NULL,
      subject TEXT DEFAULT 'Customer Inquiry',
      message TEXT NOT NULL,
      status TEXT DEFAULT 'New', -- 'New', 'In Review', 'Resolved'
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);

  // 6. Wishlist Table
  await run(`
    CREATE TABLE IF NOT EXISTS wishlists (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      product_id TEXT NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      UNIQUE(user_id, product_id),
      FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
      FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
    )
  `);

  console.log(' Database tables verified.');
  await seedInitialData();
}

async function seedInitialData() {
  // Check categories
  const catCount = await get(`SELECT COUNT(*) as count FROM categories`);
  if (catCount.count === 0) {
    const defaultCategories = [
      { id: 'cat_beauty', slug: 'beauty', name: 'Beauty', image_url: 'assets/images/beauty.png', description: 'Cosmetics & skincare essentials' },
      { id: 'cat_fashion', slug: 'fashion', name: 'Fashion', image_url: 'assets/images/fashion.png', description: 'Runway trends & statement wear' },
      { id: 'cat_kids', slug: 'kids', name: 'Kids', image_url: 'assets/images/kids.png', description: 'Playful outfits & everyday styles' },
      { id: 'cat_mens', slug: 'mens', name: 'Mens', image_url: 'assets/images/mens.png', description: 'Modern menswear & casual streetwear' },
      { id: 'cat_womens', slug: 'womens', name: 'Womens', image_url: 'assets/images/womens.png', description: 'Kurtas, dresses, & festive elegance' },
      { id: 'cat_heels', slug: 'flat-and-heels', name: 'Flat and Heels', image_url: 'assets/images/heels.png', description: 'Designer heels, sandals & flats' },
    ];

    for (const c of defaultCategories) {
      await run(
        `INSERT INTO categories (id, slug, name, image_url, description) VALUES (?, ?, ?, ?, ?)`,
        [c.id, c.slug, c.name, c.image_url, c.description]
      );
    }
    console.log(' Seeded 6 default categories.');
  }

  // Check products
  const prodCount = await get(`SELECT COUNT(*) as count FROM products`);
  if (prodCount.count === 0) {
    const sampleProducts = [
      {
        id: 'women_printed_kurta',
        title: 'Women Printed Kurta',
        subtitle: 'Neque porro quisquam est qui dolorem ipsum quia',
        description: 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...',
        price: 1500.0,
        original_price: 2499.0,
        discount_percent: 40,
        rating: 4.5,
        review_count: 56890,
        image_url: 'assets/images/kurta.png',
        gallery_images: JSON.stringify(['assets/images/kurta.png', 'assets/images/womens_casual.png']),
        sizes: JSON.stringify(['S', 'M', 'L', 'XL']),
        category: 'womens',
        is_deal_of_the_day: 1,
        is_trending: 1,
        is_new_arrival: 0,
        inventory_count: 85
      },
      {
        id: 'hrx_running_shoes',
        title: 'HRX by Hrithik Roshan',
        subtitle: 'Neque porro quisquam est qui dolorem ipsum quia',
        description: 'Engineered mesh running shoes featuring high-grip outsole and responsive foam cushioning.',
        price: 2499.0,
        original_price: 4999.0,
        discount_percent: 50,
        rating: 4.6,
        review_count: 34560,
        image_url: 'assets/images/shoes.png',
        gallery_images: JSON.stringify(['assets/images/shoes.png']),
        sizes: JSON.stringify(['6 UK', '7 UK', '8 UK', '9 UK', '10 UK']),
        category: 'mens',
        is_deal_of_the_day: 1,
        is_trending: 1,
        is_new_arrival: 0,
        inventory_count: 60
      },
      {
        id: 'philips_trimmer',
        title: 'Philips BT1232/15 Skin-friendly Trimmer',
        subtitle: 'DuraPower technology, 30 min cordless use',
        description: 'Self-sharpening stainless steel blades with USB charging and cordless run-time for precision grooming.',
        price: 899.0,
        original_price: 1495.0,
        discount_percent: 40,
        rating: 4.3,
        review_count: 12450,
        image_url: 'assets/images/philips_trimmer.png',
        gallery_images: JSON.stringify(['assets/images/philips_trimmer.png']),
        sizes: JSON.stringify(['Standard']),
        category: 'beauty',
        is_deal_of_the_day: 1,
        is_trending: 0,
        is_new_arrival: 0,
        inventory_count: 40
      },
      {
        id: 'womens_casual_wear',
        title: "Women's Casual Wear",
        subtitle: 'Checked Single-Breasted Blazer with peaked lapel',
        description: 'Contemporary structured oversized jacket crafted from breathable wool-blend fabric with classic notch lapels.',
        price: 3400.0,
        original_price: 4500.0,
        discount_percent: 24,
        rating: 4.8,
        review_count: 8920,
        image_url: 'assets/images/womens_casual.png',
        gallery_images: JSON.stringify(['assets/images/womens_casual.png']),
        sizes: JSON.stringify(['S', 'M', 'L', 'XL']),
        category: 'womens',
        is_deal_of_the_day: 0,
        is_trending: 1,
        is_new_arrival: 1,
        inventory_count: 35
      },
      {
        id: 'mens_jacket',
        title: "Men's Olive Jacket",
        subtitle: 'Water-resistant utility zip-up jacket',
        description: 'Military inspired olive field jacket with dual flap pockets, adjustable storm cuffs, and insulated lining.',
        price: 2800.0,
        original_price: 3999.0,
        discount_percent: 30,
        rating: 4.7,
        review_count: 5410,
        image_url: 'assets/images/mens_jacket.png',
        gallery_images: JSON.stringify(['assets/images/mens_jacket.png']),
        sizes: JSON.stringify(['M', 'L', 'XL', 'XXL']),
        category: 'mens',
        is_deal_of_the_day: 0,
        is_trending: 1,
        is_new_arrival: 1,
        inventory_count: 50
      },
      {
        id: 'luxe_stiletto_heels',
        title: 'Velora Luxe Stiletto 95mm',
        subtitle: 'Italian vegan leather pointed pumps',
        description: 'Sculpted high heels handcrafted with cushioned insole and non-slip sole for ultimate evening comfort.',
        price: 3890.0,
        original_price: 5990.0,
        discount_percent: 35,
        rating: 4.9,
        review_count: 3200,
        image_url: 'assets/images/heels.png',
        gallery_images: JSON.stringify(['assets/images/heels.png']),
        sizes: JSON.stringify(['36 EU', '37 EU', '38 EU', '39 EU', '40 EU']),
        category: 'flat-and-heels',
        is_deal_of_the_day: 1,
        is_trending: 1,
        is_new_arrival: 1,
        inventory_count: 25
      }
    ];

    for (const p of sampleProducts) {
      await run(`
        INSERT INTO products (
          id, title, subtitle, description, price, original_price, discount_percent,
          rating, review_count, image_url, gallery_images, sizes, category,
          is_deal_of_the_day, is_trending, is_new_arrival, inventory_count
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `, [
        p.id, p.title, p.subtitle, p.description, p.price, p.original_price, p.discount_percent,
        p.rating, p.review_count, p.image_url, p.gallery_images, p.sizes, p.category,
        p.is_deal_of_the_day, p.is_trending, p.is_new_arrival, p.inventory_count
      ]);
    }
  }
}

module.exports = {
  db,
  run,
  get,
  all,
  initDatabase,
};
