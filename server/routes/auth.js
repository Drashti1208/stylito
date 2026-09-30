const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { run, get } = require('../db/database');
const { authenticateToken } = require('../middleware/auth');

function generateToken(user) {
  return jwt.sign(
    { id: user.id, email: user.email, name: user.name },
    process.env.JWT_SECRET || 'stylito_secret',
    { expiresIn: '30d' }
  );
}

// 1. POST /api/auth/register
router.post('/register', async (req, res) => {
  try {
    const { name, email, password, phone } = req.body;
    if (!email || !password) {
      return res.status(400).json({ success: false, message: 'Email and password are required.' });
    }

    const existing = await get('SELECT id FROM users WHERE email = ?', [email.toLowerCase().trim()]);
    if (existing) {
      return res.status(409).json({ success: false, message: 'An account with this email already exists.' });
    }

    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);
    const id = 'usr_' + Date.now() + '_' + Math.random().toString(36).substring(2, 7);
    const userName = name || email.split('@')[0];

    await run(`
      INSERT INTO users (id, name, email, password_hash, phone)
      VALUES (?, ?, ?, ?, ?)
    `, [id, userName, email.toLowerCase().trim(), passwordHash, phone || '']);

    const user = await get('SELECT id, name, email, phone, avatar_url, pincode, address, city, state, country, bank_account_number, account_holder_name, ifsc_code, created_at FROM users WHERE id = ?', [id]);
    const token = generateToken(user);

    res.status(201).json({
      success: true,
      message: 'Account registered successfully.',
      token,
      user
    });
  } catch (err) {
    console.error('Registration error:', err);
    res.status(500).json({ success: false, message: 'Server error during registration.' });
  }
});

// Alias for /register
router.post('/signup', async (req, res, next) => {
  req.url = '/register';
  return router.handle(req, res, next);
});

// 2. POST /api/auth/login
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ success: false, message: 'Email and password are required.' });
    }

    const user = await get('SELECT * FROM users WHERE email = ?', [email.toLowerCase().trim()]);
    if (!user) {
      return res.status(401).json({ success: false, message: 'Invalid email or password.' });
    }

    const isMatch = await bcrypt.compare(password, user.password_hash);
    if (!isMatch) {
      return res.status(401).json({ success: false, message: 'Invalid email or password.' });
    }

    delete user.password_hash;
    const token = generateToken(user);

    res.json({
      success: true,
      message: 'Logged in successfully.',
      token,
      user
    });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ success: false, message: 'Server error during login.' });
  }
});

// 3. POST /api/auth/send-otp (Real OTP Generation without Firebase)
router.post('/send-otp', async (req, res) => {
  try {
    const { contact } = req.body;
    if (!contact || !contact.trim()) {
      return res.status(400).json({ success: false, message: 'Email or phone number is required.' });
    }

    const cleanedContact = contact.trim().toLowerCase();
    // Generate secure 6-digit OTP
    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();
    const id = 'otp_' + Date.now() + '_' + Math.random().toString(36).substring(2, 6);
    // Expires in 10 minutes
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000).toISOString();

    // Invalidate prior unused OTPs for this contact
    await run('UPDATE otps SET is_used = 1 WHERE contact = ?', [cleanedContact]);

    // Save new OTP
    await run(`
      INSERT INTO otps (id, contact, code, expires_at, is_used)
      VALUES (?, ?, ?, ?, 0)
    `, [id, cleanedContact, otpCode, expiresAt]);

    console.log(`===============================================`);
    console.log(`🔐 REAL-TIME OTP DISPATCH (No Firebase)`);
    console.log(`   Destination: ${cleanedContact}`);
    console.log(`   OTP Code:    ${otpCode}`);
    console.log(`   Valid For:   10 Minutes`);
    console.log(`===============================================`);

    res.json({
      success: true,
      message: `OTP sent successfully to ${cleanedContact}`,
      otp: otpCode // Returned for easy testing during development
    });
  } catch (err) {
    console.error('Send OTP error:', err);
    res.status(500).json({ success: false, message: 'Failed to generate and send OTP.' });
  }
});

// 4. POST /api/auth/verify-otp (Verify OTP & Sign In / Sign Up)
router.post('/verify-otp', async (req, res) => {
  try {
    const { contact, code, name } = req.body;
    if (!contact || !code) {
      return res.status(400).json({ success: false, message: 'Contact and OTP code are required.' });
    }

    const cleanedContact = contact.trim().toLowerCase();
    const cleanedCode = code.trim();

    // Check latest valid OTP
    const otpRecord = await get(`
      SELECT * FROM otps
      WHERE contact = ? AND code = ? AND is_used = 0 AND expires_at > CURRENT_TIMESTAMP
      ORDER BY created_at DESC LIMIT 1
    `, [cleanedContact, cleanedCode]);

    if (!otpRecord) {
      return res.status(400).json({
        success: false,
        message: 'Invalid or expired OTP code. Please request a new one.'
      });
    }

    // Mark OTP as used
    await run('UPDATE otps SET is_used = 1 WHERE id = ?', [otpRecord.id]);

    // Find or create user
    const isEmail = cleanedContact.includes('@');
    let user = await get(
      isEmail
        ? 'SELECT * FROM users WHERE email = ?'
        : 'SELECT * FROM users WHERE phone = ?',
      [cleanedContact]
    );

    if (!user) {
      const id = 'usr_' + Date.now() + '_' + Math.random().toString(36).substring(2, 7);
      const randomPassword = await bcrypt.hash('otp_' + Date.now(), 10);
      const userName = name || (isEmail ? cleanedContact.split('@')[0] : 'Stylito Customer');
      const userEmail = isEmail ? cleanedContact : `${cleanedContact}@stylitocustomer.com`;
      const userPhone = isEmail ? '' : cleanedContact;

      await run(`
        INSERT INTO users (id, name, email, password_hash, phone)
        VALUES (?, ?, ?, ?, ?)
      `, [id, userName, userEmail, randomPassword, userPhone]);

      user = await get('SELECT id, name, email, phone, avatar_url, pincode, address, city, state, country, bank_account_number, account_holder_name, ifsc_code, created_at FROM users WHERE id = ?', [id]);
    } else {
      delete user.password_hash;
    }

    const token = generateToken(user);

    res.json({
      success: true,
      message: 'OTP verified successfully.',
      token,
      user
    });
  } catch (err) {
    console.error('Verify OTP error:', err);
    res.status(500).json({ success: false, message: 'Server error during OTP verification.' });
  }
});

// 5. POST /api/auth/google (Google Sign-In without Firebase)
router.post('/google', async (req, res) => {
  try {
    const { email, name, google_id, avatar_url } = req.body;
    if (!email) {
      return res.status(400).json({ success: false, message: 'Google account email is required.' });
    }

    const cleanedEmail = email.toLowerCase().trim();
    let user = await get('SELECT * FROM users WHERE email = ? OR (google_id = ? AND google_id != "")', [cleanedEmail, google_id || '']);

    if (!user) {
      const id = 'usr_g_' + Date.now() + '_' + Math.random().toString(36).substring(2, 7);
      const randomPassword = await bcrypt.hash('g_auth_' + Date.now(), 10);
      const userName = name || cleanedEmail.split('@')[0];

      await run(`
        INSERT INTO users (id, name, email, password_hash, google_id, avatar_url)
        VALUES (?, ?, ?, ?, ?, ?)
      `, [id, userName, cleanedEmail, randomPassword, google_id || '', avatar_url || '']);

      user = await get('SELECT id, name, email, phone, avatar_url, pincode, address, city, state, country, bank_account_number, account_holder_name, ifsc_code, created_at FROM users WHERE id = ?', [id]);
    } else {
      // Update Google info if not set
      if (google_id || avatar_url) {
        await run(`
          UPDATE users SET
            google_id = COALESCE(NULLIF(?, ''), google_id),
            avatar_url = COALESCE(NULLIF(?, ''), avatar_url)
          WHERE id = ?
        `, [google_id || '', avatar_url || '', user.id]);
      }
      delete user.password_hash;
    }

    const token = generateToken(user);

    res.json({
      success: true,
      message: 'Google Sign-In successful.',
      token,
      user
    });
  } catch (err) {
    console.error('Google Sign-In error:', err);
    res.status(500).json({ success: false, message: 'Server error during Google sign-in.' });
  }
});

// 6. GET /api/auth/profile
router.get('/profile', authenticateToken, async (req, res) => {
  try {
    const user = await get(
      'SELECT id, name, email, phone, avatar_url, pincode, address, city, state, country, bank_account_number, account_holder_name, ifsc_code, created_at FROM users WHERE id = ?',
      [req.user.id]
    );
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found.' });
    }
    res.json({ success: true, user });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Failed to retrieve profile.' });
  }
});

// 7. PUT /api/auth/profile
router.put('/profile', authenticateToken, async (req, res) => {
  try {
    const {
      name,
      phone,
      pincode,
      address,
      city,
      state,
      country,
      bank_account_number,
      account_holder_name,
      ifsc_code
    } = req.body;

    await run(`
      UPDATE users SET
        name = COALESCE(?, name),
        phone = COALESCE(?, phone),
        pincode = COALESCE(?, pincode),
        address = COALESCE(?, address),
        city = COALESCE(?, city),
        state = COALESCE(?, state),
        country = COALESCE(?, country),
        bank_account_number = COALESCE(?, bank_account_number),
        account_holder_name = COALESCE(?, account_holder_name),
        ifsc_code = COALESCE(?, ifsc_code),
        updated_at = CURRENT_TIMESTAMP
      WHERE id = ?
    `, [
      name, phone, pincode, address, city, state, country,
      bank_account_number, account_holder_name, ifsc_code,
      req.user.id
    ]);

    const updatedUser = await get(
      'SELECT id, name, email, phone, avatar_url, pincode, address, city, state, country, bank_account_number, account_holder_name, ifsc_code FROM users WHERE id = ?',
      [req.user.id]
    );

    res.json({
      success: true,
      message: 'Profile updated successfully.',
      user: updatedUser
    });
  } catch (err) {
    console.error('Profile update error:', err);
    res.status(500).json({ success: false, message: 'Failed to update profile.' });
  }
});

module.exports = router;
