const express = require('express');
const router = express.Router();
const { run, get, all } = require('../db/database');

function parseProduct(row) {
  if (!row) return null;
  return {
    ...row,
    gallery_images: row.gallery_images ? JSON.parse(row.gallery_images) : [],
    sizes: row.sizes ? JSON.parse(row.sizes) : [],
    is_deal_of_the_day: Boolean(row.is_deal_of_the_day),
    is_trending: Boolean(row.is_trending),
    is_new_arrival: Boolean(row.is_new_arrival),
  };
}

// GET /api/products (supports ?category=..., ?search=..., ?deal=1, ?trending=1)
router.get('/', async (req, res) => {
  try {
    const { category, search, deal, trending, limit = 50, offset = 0 } = req.query;
    let query = 'SELECT * FROM products WHERE 1=1';
    const params = [];

    if (category && category.toLowerCase() !== 'all') {
      query += ' AND LOWER(category) = LOWER(?)';
      params.push(category);
    }

    if (search) {
      query += ' AND (LOWER(title) LIKE ? OR LOWER(description) LIKE ? OR LOWER(category) LIKE ?)';
      const s = `%${search.toLowerCase().trim()}%`;
      params.push(s, s, s);
    }

    if (deal === '1' || deal === 'true') {
      query += ' AND is_deal_of_the_day = 1';
    }

    if (trending === '1' || trending === 'true') {
      query += ' AND is_trending = 1';
    }

    query += ' ORDER BY created_at DESC LIMIT ? OFFSET ?';
    params.push(Number(limit), Number(offset));

    const rows = await all(query, params);
    const products = rows.map(parseProduct);

    res.json({
      success: true,
      count: products.length,
      data: products
    });
  } catch (err) {
    console.error('Products fetch error:', err);
    res.status(500).json({ success: false, message: 'Failed to fetch products.' });
  }
});

// GET /api/products/deals
router.get('/deals', async (req, res) => {
  try {
    const rows = await all('SELECT * FROM products WHERE is_deal_of_the_day = 1');
    res.json({ success: true, count: rows.length, data: rows.map(parseProduct) });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Failed to fetch deals.' });
  }
});

// GET /api/products/trending
router.get('/trending', async (req, res) => {
  try {
    const rows = await all('SELECT * FROM products WHERE is_trending = 1');
    res.json({ success: true, count: rows.length, data: rows.map(parseProduct) });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Failed to fetch trending products.' });
  }
});

// GET /api/products/category/:slug
router.get('/category/:slug', async (req, res) => {
  try {
    const rows = await all('SELECT * FROM products WHERE LOWER(category) = LOWER(?)', [req.params.slug]);
    res.json({ success: true, count: rows.length, data: rows.map(parseProduct) });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Failed to fetch category products.' });
  }
});

// GET /api/products/:id
router.get('/:id', async (req, res) => {
  try {
    const row = await get('SELECT * FROM products WHERE id = ?', [req.params.id]);
    if (!row) {
      return res.status(404).json({ success: false, message: 'Product not found.' });
    }
    res.json({ success: true, data: parseProduct(row) });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Failed to fetch product details.' });
  }
});

// POST /api/products (Create Product)
router.post('/', async (req, res) => {
  try {
    const {
      title, subtitle, description, price, original_price,
      discount_percent = 0, rating = 4.5, review_count = 1,
      image_url, gallery_images = [], sizes = ['6 UK', '7 UK', '8 UK'],
      category, delivery_time = 'Delivery in 1 within Hour',
      is_deal_of_the_day = 0, is_trending = 0, is_new_arrival = 1,
      inventory_count = 50
    } = req.body;

    if (!title || price === undefined || !image_url || !category) {
      return res.status(400).json({
        success: false,
        message: 'title, price, image_url, and category are required.'
      });
    }

    const id = 'prod_' + Date.now() + '_' + Math.random().toString(36).substring(2, 6);

    await run(`
      INSERT INTO products (
        id, title, subtitle, description, price, original_price, discount_percent,
        rating, review_count, image_url, gallery_images, sizes, category,
        delivery_time, is_deal_of_the_day, is_trending, is_new_arrival, inventory_count
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `, [
      id, title, subtitle || '', description || '', Number(price),
      Number(original_price || price), Number(discount_percent),
      Number(rating), Number(review_count), image_url,
      JSON.stringify(gallery_images), JSON.stringify(sizes), category,
      delivery_time, is_deal_of_the_day ? 1 : 0, is_trending ? 1 : 0,
      is_new_arrival ? 1 : 0, Number(inventory_count)
    ]);

    const created = await get('SELECT * FROM products WHERE id = ?', [id]);
    res.status(201).json({ success: true, message: 'Product created successfully.', data: parseProduct(created) });
  } catch (err) {
    console.error('Create product error:', err);
    res.status(500).json({ success: false, message: 'Failed to create product.' });
  }
});

// PUT /api/products/:id (Update product or inventory)
router.put('/:id', async (req, res) => {
  try {
    const existing = await get('SELECT * FROM products WHERE id = ?', [req.params.id]);
    if (!existing) {
      return res.status(404).json({ success: false, message: 'Product not found.' });
    }

    const b = req.body;
    await run(`
      UPDATE products SET
        title = COALESCE(?, title),
        subtitle = COALESCE(?, subtitle),
        description = COALESCE(?, description),
        price = COALESCE(?, price),
        original_price = COALESCE(?, original_price),
        discount_percent = COALESCE(?, discount_percent),
        inventory_count = COALESCE(?, inventory_count),
        category = COALESCE(?, category)
      WHERE id = ?
    `, [
      b.title, b.subtitle, b.description, b.price, b.original_price,
      b.discount_percent, b.inventory_count, b.category, req.params.id
    ]);

    const updated = await get('SELECT * FROM products WHERE id = ?', [req.params.id]);
    res.json({ success: true, message: 'Product updated.', data: parseProduct(updated) });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Failed to update product.' });
  }
});

// DELETE /api/products/:id
router.delete('/:id', async (req, res) => {
  try {
    const result = await run('DELETE FROM products WHERE id = ?', [req.params.id]);
    if (result.changes === 0) {
      return res.status(404).json({ success: false, message: 'Product not found.' });
    }
    res.json({ success: true, message: 'Product deleted.' });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Failed to delete product.' });
  }
});

module.exports = router;
