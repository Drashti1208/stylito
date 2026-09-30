const express = require('express');
const router = express.Router();
const { run, all } = require('../db/database');

// GET /api/categories
router.get('/', async (req, res) => {
  try {
    const categories = await all(`
      SELECT c.*, COUNT(p.id) as product_count
      FROM categories c
      LEFT JOIN products p ON LOWER(p.category) = LOWER(c.slug) OR LOWER(p.category) = LOWER(c.name)
      GROUP BY c.id
      ORDER BY c.created_at ASC
    `);

    res.json({
      success: true,
      count: categories.length,
      data: categories
    });
  } catch (err) {
    console.error('Categories fetch error:', err);
    res.status(500).json({ success: false, message: 'Failed to fetch categories.' });
  }
});

// POST /api/categories
router.post('/', async (req, res) => {
  try {
    const { name, slug, image_url, description } = req.body;
    if (!name || !slug) {
      return res.status(400).json({ success: false, message: 'name and slug are required.' });
    }

    const id = 'cat_' + Date.now();
    await run(
      'INSERT INTO categories (id, slug, name, image_url, description) VALUES (?, ?, ?, ?, ?)',
      [id, slug.toLowerCase().trim(), name, image_url || '', description || '']
    );

    res.status(201).json({ success: true, message: 'Category created.', data: { id, slug, name, image_url, description } });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Failed to create category.' });
  }
});

module.exports = router;
