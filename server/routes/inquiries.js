const express = require('express');
const router = express.Router();
const { run, get, all } = require('../db/database');

// Active Server-Sent Event (SSE) clients for real-time live streaming
const sseClients = new Set();

function broadcastRealtimeInquiry(inquiry) {
  const data = `data: ${JSON.stringify(inquiry)}\n\n`;
  for (const client of sseClients) {
    try {
      client.write(data);
    } catch (e) {
      sseClients.delete(client);
    }
  }
}

// GET /api/inquiries/stream (Real-time SSE event stream)
router.get('/stream', (req, res) => {
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.setHeader('Access-Control-Allow-Origin', '*');

  res.write(`data: ${JSON.stringify({ type: 'CONNECTED', message: 'Real-time inquiry stream active' })}\n\n`);
  sseClients.add(res);

  req.on('close', () => {
    sseClients.delete(res);
  });
});

// POST /api/inquiries (Submit Direct Message / Inquiry from Form)
router.post('/', async (req, res) => {
  try {
    const { name, email, subject, message } = req.body;

    if (!name || !email || !message) {
      return res.status(400).json({
        success: false,
        message: 'Name, email, and message are required.'
      });
    }

    // Basic email format check
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({
        success: false,
        message: 'Please provide a valid email address.'
      });
    }

    const id = 'inq_' + Date.now() + '_' + Math.random().toString(36).substring(2, 6);
    const inqSubject = subject && subject.trim() ? subject.trim() : 'Customer Direct Message';

    await run(`
      INSERT INTO inquiries (id, name, email, subject, message, status)
      VALUES (?, ?, ?, ?, ?, ?)
    `, [id, name.trim(), email.trim(), inqSubject, message.trim(), 'New']);

    const created = await get('SELECT * FROM inquiries WHERE id = ?', [id]);

    // Broadcast in real-time to all connected listening clients
    broadcastRealtimeInquiry({ type: 'NEW_INQUIRY', data: created });

    console.log(` Real-time inquiry received from ${name} (${email}): "${inqSubject}"`);

    res.status(201).json({
      success: true,
      message: 'Inquiry received successfully! Our team will contact you soon.',
      data: created
    });
  } catch (err) {
    console.error('Inquiry submission error:', err);
    res.status(500).json({ success: false, message: 'Failed to submit inquiry.' });
  }
});

// GET /api/inquiries (List all customer inquiries)
router.get('/', async (req, res) => {
  try {
    const rows = await all('SELECT * FROM inquiries ORDER BY created_at DESC');
    res.json({
      success: true,
      count: rows.length,
      data: rows
    });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Failed to fetch inquiries.' });
  }
});

// PUT /api/inquiries/:id/status (Update inquiry status: New -> In Review -> Resolved)
router.put('/:id/status', async (req, res) => {
  try {
    const { status } = req.body;
    if (!status) {
      return res.status(400).json({ success: false, message: 'status is required.' });
    }

    await run('UPDATE inquiries SET status = ? WHERE id = ?', [status, req.params.id]);
    const updated = await get('SELECT * FROM inquiries WHERE id = ?', [req.params.id]);

    if (!updated) {
      return res.status(404).json({ success: false, message: 'Inquiry not found.' });
    }

    broadcastRealtimeInquiry({ type: 'STATUS_UPDATE', data: updated });

    res.json({ success: true, message: 'Status updated.', data: updated });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Failed to update status.' });
  }
});

module.exports = router;
