const express = require('express');
const router = express.Router();
const { run, get, all } = require('../db/database');

// POST /api/orders (Create an order from cart)
router.post('/', async (req, res) => {
  try {
    const {
      user_id = null,
      customer_name,
      customer_email,
      shipping_address,
      items,
      subtotal,
      discount_amount = 0,
      delivery_fee = 0,
      total_amount,
      payment_method = 'Online / Card'
    } = req.body;

    if (!customer_name || !customer_email || !shipping_address || !items || !items.length) {
      return res.status(400).json({
        success: false,
        message: 'customer_name, customer_email, shipping_address, and items are required.'
      });
    }

    const orderId = 'ORD-' + Math.floor(100000 + Math.random() * 900000);

    // Deduct inventory for ordered items
    for (const item of items) {
      if (item.product && item.product.id) {
        await run(`
          UPDATE products
          SET inventory_count = MAX(0, inventory_count - ?)
          WHERE id = ?
        `, [item.quantity || 1, item.product.id]);
      }
    }

    await run(`
      INSERT INTO orders (
        id, user_id, customer_name, customer_email, shipping_address,
        items, subtotal, discount_amount, delivery_fee, total_amount, payment_method, payment_status, order_status
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `, [
      orderId, user_id, customer_name, customer_email, shipping_address,
      JSON.stringify(items), Number(subtotal || 0), Number(discount_amount || 0),
      Number(delivery_fee || 0), Number(total_amount || 0), payment_method,
      'Completed', 'Confirmed'
    ]);

    const createdOrder = await get('SELECT * FROM orders WHERE id = ?', [orderId]);
    createdOrder.items = JSON.parse(createdOrder.items);

    res.status(201).json({
      success: true,
      message: 'Order placed successfully!',
      order: createdOrder
    });
  } catch (err) {
    console.error('Order creation error:', err);
    res.status(500).json({ success: false, message: 'Failed to place order.' });
  }
});

// GET /api/orders (List all orders or user orders)
router.get('/', async (req, res) => {
  try {
    const { user_id, email } = req.query;
    let query = 'SELECT * FROM orders WHERE 1=1';
    const params = [];

    if (user_id) {
      query += ' AND user_id = ?';
      params.push(user_id);
    } else if (email) {
      query += ' AND LOWER(customer_email) = LOWER(?)';
      params.push(email);
    }

    query += ' ORDER BY created_at DESC';
    const rows = await all(query, params);

    const orders = rows.map(r => ({
      ...r,
      items: JSON.parse(r.items)
    }));

    res.json({ success: true, count: orders.length, orders });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Failed to fetch orders.' });
  }
});

// GET /api/orders/:id
router.get('/:id', async (req, res) => {
  try {
    const order = await get('SELECT * FROM orders WHERE id = ?', [req.params.id]);
    if (!order) {
      return res.status(404).json({ success: false, message: 'Order not found.' });
    }
    order.items = JSON.parse(order.items);
    res.json({ success: true, order });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Failed to fetch order.' });
  }
});

module.exports = router;
