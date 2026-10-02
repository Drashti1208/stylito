const express = require('express');
const router = express.Router();
const { run, get, all } = require('../db/database');

// 1. GET /api/notifications/vapid-key
router.get('/vapid-key', (req, res) => {
  res.json({
    success: true,
    publicKey: process.env.VAPID_PUBLIC_KEY || ''
  });
});

// 2. POST /api/notifications/subscribe (Save browser Web Push Subscription)
router.post('/subscribe', async (req, res) => {
  try {
    const { subscription, userId } = req.body;
    if (!subscription || !subscription.endpoint) {
      return res.status(400).json({ success: false, message: 'Invalid push subscription.' });
    }

    const id = 'sub_' + Date.now() + '_' + Math.random().toString(36).substring(2, 6);
    const p256dh = subscription.keys ? subscription.keys.p256dh : '';
    const auth = subscription.keys ? subscription.keys.auth : '';

    await run(`
      INSERT INTO push_subscriptions (id, user_id, endpoint, keys_p256dh, keys_auth)
      VALUES (?, ?, ?, ?, ?)
      ON CONFLICT(endpoint) DO UPDATE SET
        user_id = excluded.user_id,
        keys_p256dh = excluded.keys_p256dh,
        keys_auth = excluded.keys_auth
    `, [id, userId || null, subscription.endpoint, p256dh, auth]);

    res.json({ success: true, message: 'Push notification subscription active.' });
  } catch (err) {
    console.error('Subscription error:', err);
    res.status(500).json({ success: false, message: 'Failed to save subscription.' });
  }
});

// 3. POST /api/notifications/send-test (Send a test notification)
router.post('/send-test', async (req, res) => {
  try {
    const { title, body, userId } = req.body;
    const notifId = 'notif_' + Date.now() + '_' + Math.random().toString(36).substring(2, 6);

    await run(`
      INSERT INTO notifications (id, user_id, title, body, type, is_read)
      VALUES (?, ?, ?, ?, 'system', 0)
    `, [notifId, userId || null, title || 'Stylito VIP Drop Alert', body || 'Special 60% OFF unlocked on new arrivals!']);

    console.log(`🔔 Notification dispatched to user ${userId || 'all'}: "${title}"`);

    res.json({
      success: true,
      message: 'Notification dispatched and stored in SQLite.',
      notificationId: notifId
    });
  } catch (err) {
    console.error('Send test error:', err);
    res.status(500).json({ success: false, message: 'Failed to send notification.' });
  }
});

// 4. GET /api/notifications (List notifications)
router.get('/', async (req, res) => {
  try {
    const { userId } = req.query;
    let rows;
    if (userId) {
      rows = await all('SELECT * FROM notifications WHERE user_id = ? OR user_id IS NULL ORDER BY created_at DESC LIMIT 50', [userId]);
    } else {
      rows = await all('SELECT * FROM notifications ORDER BY created_at DESC LIMIT 50');
    }
    res.json({ success: true, count: rows.length, data: rows });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Failed to fetch notifications.' });
  }
});

module.exports = router;
