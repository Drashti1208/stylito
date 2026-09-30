const express = require('express');
const router = express.Router();
const crypto = require('crypto');
const bcrypt = require('bcryptjs');
const { all, get, run } = require('../db/database');

const VALID_TABLES = ['users', 'otps', 'products', 'categories', 'orders', 'inquiries'];

// POST /admin/clear/:tableName - Clear a specific table
router.post('/clear/:tableName', async (req, res) => {
  const { tableName } = req.params;
  if (!VALID_TABLES.includes(tableName)) {
    return res.status(400).send('Invalid table name');
  }

  try {
    await run(`DELETE FROM ${tableName}`);
    res.redirect(`/admin?tab=${tableName}&cleared=1`);
  } catch (err) {
    res.status(500).send(`Error clearing table: ${err.message}`);
  }
});

// POST /admin/delete-row/:tableName/:id - Delete a specific row
router.post('/delete-row/:tableName/:id', async (req, res) => {
  const { tableName, id } = req.params;
  if (!VALID_TABLES.includes(tableName)) {
    return res.status(400).json({ success: false, message: 'Invalid table name' });
  }

  try {
    const result = await run(`DELETE FROM ${tableName} WHERE id = ?`, [id]);
    const isJson = req.xhr || req.headers['content-type']?.includes('application/json') || req.headers.accept?.includes('application/json');
    if (isJson) {
      return res.json({ success: true, message: `Row ${id} deleted successfully`, changes: result.changes });
    }
    res.redirect(`/admin?tab=${tableName}&deleted=1`);
  } catch (err) {
    console.error(`Error deleting row from ${tableName}:`, err);
    res.status(500).json({ success: false, message: `Error deleting row: ${err.message}` });
  }
});

// POST /admin/api/insert - Dynamically insert record into selected SQLite table
router.post('/api/insert', async (req, res) => {
  try {
    const { table } = req.body;
    if (!VALID_TABLES.includes(table)) {
      return res.status(400).json({ success: false, message: `Invalid table: ${table}` });
    }

    const isJsonRequest = req.xhr || req.headers['content-type']?.includes('application/json') || req.headers.accept?.includes('application/json');

    if (table === 'users') {
      const {
        name,
        email,
        password,
        phone,
        address,
        city,
        state,
        country,
        pincode
      } = req.body;

      if (!name || !email) {
        return res.status(400).json({ success: false, message: 'Name and Email are required for users' });
      }

      const id = `usr_${Date.now()}_${Math.floor(Math.random() * 1000)}`;
      const passwordHash = await bcrypt.hash(password || 'Stylito@123', 10);

      await run(
        `INSERT INTO users (id, name, email, password_hash, phone, address, city, state, country, pincode)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [
          id,
          name.trim(),
          email.trim().toLowerCase(),
          passwordHash,
          phone ? phone.trim() : '',
          address ? address.trim() : '',
          city ? city.trim() : '',
          state ? state.trim() : '',
          country ? country.trim() : 'India',
          pincode ? pincode.trim() : ''
        ]
      );

      if (isJsonRequest) return res.json({ success: true, id, table });
      return res.redirect(`/admin?tab=users&added=1`);
    }

    if (table === 'otps') {
      const { contact, code, expires_minutes, is_used } = req.body;
      if (!contact || !code) {
        return res.status(400).json({ success: false, message: 'Contact (Phone/Email) and Code are required for OTPs' });
      }

      const id = `otp_${Date.now()}_${Math.floor(Math.random() * 1000)}`;
      const expiryMinutes = parseInt(expires_minutes, 10) || 10;
      const expiresAt = new Date(Date.now() + expiryMinutes * 60 * 1000).toISOString();
      const usedFlag = is_used === '1' || is_used === 1 ? 1 : 0;

      await run(
        `INSERT INTO otps (id, contact, code, expires_at, is_used) VALUES (?, ?, ?, ?, ?)`,
        [id, contact.trim(), String(code).trim(), expiresAt, usedFlag]
      );

      if (isJsonRequest) return res.json({ success: true, id, table });
      return res.redirect(`/admin?tab=otps&added=1`);
    }

    if (table === 'products') {
      const {
        title,
        subtitle,
        category,
        price,
        original_price,
        discount_percent,
        image_url,
        sizes,
        description,
        rating,
        review_count
      } = req.body;

      if (!title || !price || !category) {
        return res.status(400).json({ success: false, message: 'Title, Price, and Category are required for products' });
      }

      const id = `prod_${Date.now()}_${Math.floor(Math.random() * 1000)}`;
      const numPrice = parseFloat(price) || 0;
      const numOrig = parseFloat(original_price) || numPrice;
      const discount = parseInt(discount_percent, 10) || (numOrig > numPrice ? Math.round(((numOrig - numPrice) / numOrig) * 100) : 0);

      let parsedSizes = sizes;
      if (typeof sizes === 'string') {
        if (!sizes.startsWith('[')) {
          parsedSizes = JSON.stringify(sizes.split(',').map((s) => s.trim()).filter(Boolean));
        }
      } else if (Array.isArray(sizes)) {
        parsedSizes = JSON.stringify(sizes);
      } else {
        parsedSizes = JSON.stringify(['S', 'M', 'L', 'XL']);
      }

      await run(
        `INSERT INTO products (
          id, title, subtitle, description, price, original_price, discount_percent,
          rating, review_count, image_url, category, sizes
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [
          id,
          title.trim(),
          subtitle ? subtitle.trim() : 'Designer Collection',
          description ? description.trim() : '',
          numPrice,
          numOrig,
          discount,
          parseFloat(rating) || 4.5,
          parseInt(review_count, 10) || 120,
          image_url ? image_url.trim() : 'assets/images/fashion.png',
          category.trim(),
          parsedSizes
        ]
      );

      if (isJsonRequest) return res.json({ success: true, id, table });
      return res.redirect(`/admin?tab=products&added=1`);
    }

    if (table === 'categories') {
      const { name, slug, image_url, description } = req.body;
      if (!name) {
        return res.status(400).json({ success: false, message: 'Category Name is required' });
      }

      const categorySlug = (slug || name).toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
      const id = `cat_${categorySlug}`;

      await run(
        `INSERT INTO categories (id, slug, name, image_url, description) VALUES (?, ?, ?, ?, ?)`,
        [
          id,
          categorySlug,
          name.trim(),
          image_url ? image_url.trim() : 'assets/images/fashion.png',
          description ? description.trim() : ''
        ]
      );

      if (isJsonRequest) return res.json({ success: true, id, table });
      return res.redirect(`/admin?tab=categories&added=1`);
    }

    if (table === 'orders') {
      const {
        customer_name,
        customer_email,
        user_id,
        shipping_address,
        items,
        total_amount,
        payment_method,
        payment_status,
        order_status
      } = req.body;

      if (!customer_name || !customer_email || !total_amount) {
        return res.status(400).json({ success: false, message: 'Customer Name, Email, and Total Amount are required for orders' });
      }

      const id = `ord_${Date.now()}_${Math.floor(Math.random() * 1000)}`;
      let parsedItems = items;
      if (typeof items === 'string' && !items.trim().startsWith('[')) {
        parsedItems = JSON.stringify([{ title: items.trim(), qty: 1, price: parseFloat(total_amount) || 0 }]);
      } else if (!items) {
        parsedItems = JSON.stringify([{ title: 'Fashion Order', qty: 1, price: parseFloat(total_amount) || 0 }]);
      }

      const totalNum = parseFloat(total_amount) || 0;

      await run(
        `INSERT INTO orders (
          id, user_id, customer_name, customer_email, shipping_address,
          items, subtotal, total_amount, payment_method, payment_status, order_status
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [
          id,
          user_id ? user_id.trim() : null,
          customer_name.trim(),
          customer_email.trim().toLowerCase(),
          shipping_address ? shipping_address.trim() : 'Standard Delivery Address',
          parsedItems,
          totalNum,
          totalNum,
          payment_method ? payment_method.trim() : 'UPI / QR',
          payment_status ? payment_status.trim() : 'Completed',
          order_status ? order_status.trim() : 'Processing'
        ]
      );

      if (isJsonRequest) return res.json({ success: true, id, table });
      return res.redirect(`/admin?tab=orders&added=1`);
    }

    if (table === 'inquiries') {
      const { name, email, subject, message, status } = req.body;
      if (!name || !email || !message) {
        return res.status(400).json({ success: false, message: 'Name, Email, and Message are required for inquiries' });
      }

      const id = `inq_${Date.now()}_${Math.floor(Math.random() * 1000)}`;

      await run(
        `INSERT INTO inquiries (id, name, email, subject, message, status) VALUES (?, ?, ?, ?, ?, ?)`,
        [
          id,
          name.trim(),
          email.trim().toLowerCase(),
          subject ? subject.trim() : 'Customer Direct Message',
          message.trim(),
          status ? status.trim() : 'New'
        ]
      );

      if (isJsonRequest) return res.json({ success: true, id, table });
      return res.redirect(`/admin?tab=inquiries&added=1`);
    }

    return res.status(400).json({ success: false, message: 'Unhandled table operation' });
  } catch (err) {
    console.error('Error inserting data via admin API:', err);
    res.status(500).json({ success: false, message: err.message });
  }
});

// GET /admin - SQLite Database Visual Viewer Dashboard
router.get('/', async (req, res) => {
  try {
    let activeTab = (req.query.tab || 'users').toLowerCase();
    if (!VALID_TABLES.includes(activeTab)) {
      activeTab = 'users';
    }

    // Counts for all valid tables
    const counts = {};
    for (const tbl of VALID_TABLES) {
      try {
        const countRes = await get(`SELECT COUNT(*) as count FROM ${tbl}`);
        counts[tbl] = countRes?.count || 0;
      } catch (_) {
        counts[tbl] = 0;
      }
    }

    // Get columns dynamically from SQLite PRAGMA
    const tableInfo = await all(`PRAGMA table_info(${activeTab})`);
    const columns = tableInfo.map((c) => c.name);

    // Get rows safely
    const rows = await all(`SELECT * FROM ${activeTab} ORDER BY rowid DESC LIMIT 100`);

    const clearedMessage = req.query.cleared
      ? `<div class="mb-4 p-3 bg-rose-950/80 border border-rose-500/50 rounded-xl text-rose-300 text-xs font-semibold flex items-center justify-between">
           <div class="flex items-center gap-2">
             <span>🗑️</span>
             <span>Table "${activeTab}" has been completely cleared!</span>
           </div>
           <a href="/admin?tab=${activeTab}" class="text-rose-400 hover:underline">Dismiss</a>
         </div>`
      : '';

    const addedMessage = req.query.added
      ? `<div class="mb-4 p-3.5 bg-emerald-950/80 border border-emerald-500/50 rounded-xl text-emerald-300 text-xs font-semibold flex items-center justify-between shadow-lg shadow-emerald-950/40 animate-pulse">
           <div class="flex items-center gap-2">
             <span class="text-base">✨</span>
             <span>Record successfully added to <strong>"${activeTab}"</strong> in SQLite real-time storage!</span>
           </div>
           <a href="/admin?tab=${activeTab}" class="text-emerald-400 hover:underline">Dismiss</a>
         </div>`
      : '';

    const deletedMessage = req.query.deleted
      ? `<div class="mb-4 p-3.5 bg-rose-950/80 border border-rose-500/50 rounded-xl text-rose-300 text-xs font-semibold flex items-center justify-between shadow-lg shadow-rose-950/40">
           <div class="flex items-center gap-2">
             <span class="text-base">🗑️</span>
             <span>Row successfully deleted from <strong>"${activeTab}"</strong> in SQLite database!</span>
           </div>
           <a href="/admin?tab=${activeTab}" class="text-rose-400 hover:underline">Dismiss</a>
         </div>`
      : '';

    const html = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Stylito SQLite Database Viewer & Manager</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    body { font-family: 'Plus Jakarta Sans', sans-serif; background: #0b0f19; color: #f1f5f9; }
    /* Custom scrollbar for table container */
    ::-webkit-scrollbar { width: 6px; height: 6px; }
    ::-webkit-scrollbar-track { background: #0f172a; }
    ::-webkit-scrollbar-thumb { background: #334155; border-radius: 4px; }
    ::-webkit-scrollbar-thumb:hover { background: #475569; }
  </style>
</head>
<body class="min-h-screen p-6">
  <div class="max-w-7xl mx-auto">
    <!-- Header -->
    <div class="flex flex-wrap items-center justify-between pb-6 border-b border-slate-800 gap-4">
      <div>
        <div class="flex items-center gap-3">
          <span class="text-3xl">🗄️</span>
          <div>
            <h1 class="text-2xl font-bold text-white tracking-tight flex items-center gap-2.5">
              <span>Stylito SQLite Database Viewer</span>
              <span class="text-[11px] font-semibold tracking-wider uppercase px-2 py-0.5 rounded-full bg-emerald-500/20 text-emerald-400 border border-emerald-500/30">Live Sync</span>
            </h1>
            <p class="text-slate-400 text-sm mt-0.5">Real-time relational data stored in <code class="text-pink-400 bg-slate-900 px-2 py-0.5 rounded text-xs">server/data/stylito.db</code></p>
          </div>
        </div>
      </div>
      <div class="flex items-center gap-3">
        <!-- Add Data Button with Plus Icon -->
        <button onclick="openAddDataModal('${activeTab}')" class="px-4 py-2 bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-500 hover:to-teal-500 text-white rounded-lg text-sm font-semibold flex items-center gap-2 transition shadow-lg shadow-emerald-600/25 active:scale-95 cursor-pointer">
          <span class="text-base font-bold">➕</span>
          <span>Add Data</span>
        </button>

        <!-- Refresh Button -->
        <a href="/admin?tab=${activeTab}" class="px-4 py-2 bg-pink-600 hover:bg-pink-500 text-white rounded-lg text-sm font-semibold flex items-center gap-2 transition shadow-lg shadow-pink-600/20 active:scale-95">
          <span>🔄</span>
          <span>Refresh</span>
        </a>
      </div>
    </div>

    ${clearedMessage}
    ${addedMessage}
    ${deletedMessage}

    <!-- Stats Cards / Table Tabs -->
    <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-6 gap-3 my-6">
      ${VALID_TABLES.map((tbl) => {
        const isSelected = activeTab === tbl;
        const iconMap = {
          users: '👤',
          otps: '📱',
          products: '👗',
          categories: '🏷️',
          orders: '📦',
          inquiries: '💬'
        };
        return `
          <a href="/admin?tab=${tbl}" class="p-3.5 rounded-xl border transition ${
            isSelected
              ? 'bg-pink-950/40 border-pink-500 shadow-lg shadow-pink-500/10 ring-1 ring-pink-500/40'
              : 'bg-slate-900/60 border-slate-800 hover:border-slate-700 hover:bg-slate-900'
          }">
            <div class="flex items-center justify-between">
              <span class="text-lg">${iconMap[tbl] || '📄'}</span>
              <span class="text-slate-400 text-[11px] font-semibold uppercase tracking-wider">${tbl}</span>
            </div>
            <p class="text-2xl font-bold text-white mt-1.5">${counts[tbl]}</p>
          </a>
        `;
      }).join('')}
    </div>

    <!-- Table Container -->
    <div class="bg-slate-900/80 rounded-2xl border border-slate-800 overflow-hidden shadow-2xl">
      <div class="p-4 border-b border-slate-800 flex flex-wrap items-center justify-between gap-3">
        <h2 class="text-lg font-semibold text-white capitalize flex items-center gap-2">
          <span>Table:</span>
          <span class="text-pink-400 font-bold">${activeTab}</span>
          <span class="text-xs bg-slate-800 px-2.5 py-1 rounded-full text-slate-400 font-normal">${rows.length} rows loaded</span>
        </h2>
        <div class="flex items-center gap-3">
          <button onclick="openAddDataModal('${activeTab}')" class="px-3 py-1.5 bg-emerald-950/60 hover:bg-emerald-900 border border-emerald-800/80 text-emerald-300 text-xs font-semibold rounded-lg transition flex items-center gap-1.5 cursor-pointer">
            <span>➕</span>
            <span>Add ${activeTab.slice(0, -1)}</span>
          </button>
          ${
            rows.length > 0
              ? `<form method="POST" action="/admin/clear/${activeTab}" onsubmit="return confirm('Are you sure you want to clear all data in ${activeTab}?');">
                   <button type="submit" class="px-3 py-1.5 bg-red-950/60 hover:bg-red-900 border border-red-800/80 text-red-300 text-xs font-semibold rounded-lg transition flex items-center gap-1.5 cursor-pointer">
                     🗑️ Clear Table
                   </button>
                 </form>`
              : ''
          }
        </div>
      </div>

      <div class="overflow-x-auto max-h-[600px] overflow-y-auto">
        ${
          rows.length === 0
            ? `
          <div class="text-center py-16 text-slate-500">
            <p class="text-4xl mb-2">📭</p>
            <p class="text-base font-medium">No records found in table "${activeTab}"</p>
            <p class="text-xs mt-1 text-slate-600">Click the <strong>[ + Add Data ]</strong> button above to insert real-time data into SQLite.</p>
          </div>
        `
            : `
          <table class="w-full text-left border-collapse text-xs">
            <thead class="bg-slate-950 sticky top-0 text-slate-400 border-b border-slate-800 z-10">
              <tr>
                ${columns
                  .map(
                    (col) =>
                      `<th class="p-3 font-semibold uppercase tracking-wider text-[11px] whitespace-nowrap bg-slate-950">${col}</th>`
                  )
                  .join('')}
                <th class="p-3 font-semibold uppercase tracking-wider text-[11px] whitespace-nowrap bg-slate-950 text-center sticky right-0 z-20 border-l border-slate-800 shadow-[-5px_0_10px_rgba(0,0,0,0.5)]">Action</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-800/60">
              ${rows
                .map(
                  (row) => `
                <tr class="hover:bg-slate-800/40 transition group">
                  ${columns
                    .map((col) => {
                      const val = row[col];
                      const isId = col === 'id' || col === 'user_id';
                      const isPass = col === 'password_hash';
                      if (isPass) {
                        return `<td class="p-3 whitespace-nowrap text-slate-600 font-mono text-[10px]">••••••••</td>`;
                      }
                      let displayVal = val !== null && val !== undefined ? String(val) : '<span class="text-slate-600">null</span>';
                      if (col === 'is_used') {
                        displayVal = val === 1 ? '<span class="text-emerald-400 font-semibold">1 (Verified)</span>' : '<span class="text-amber-400 font-semibold">0 (Unused)</span>';
                      }
                      return `<td class="p-3 whitespace-nowrap ${
                        isId ? 'font-mono text-pink-300' : 'text-slate-300'
                      }">${displayVal}</td>`;
                    })
                    .join('')}
                  <td class="p-2 whitespace-nowrap text-center sticky right-0 bg-slate-900 group-hover:bg-slate-800/95 border-l border-slate-800 shadow-[-5px_0_10px_rgba(0,0,0,0.3)] z-10">
                    <button
                      type="button"
                      onclick="deleteSingleRow('${activeTab}', '${row.id}', this)"
                      title="Delete this row"
                      class="inline-flex items-center justify-center gap-1.5 px-2.5 py-1 rounded-lg bg-red-950/50 hover:bg-red-900 border border-red-800/70 hover:border-red-600 text-red-400 hover:text-red-200 text-xs font-medium transition active:scale-95 cursor-pointer shadow-sm"
                    >
                      <span>🗑️</span>
                      <span class="hidden sm:inline">Delete</span>
                    </button>
                  </td>
                </tr>
              `
                )
                .join('')}
            </tbody>
          </table>
        `
        }
      </div>
    </div>
  </div>

  <!-- DYNAMIC MODAL: ADD DATA TO SQLITE -->
  <div id="addDataModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/75 backdrop-blur-sm p-4 hidden opacity-0 transition-opacity duration-200">
    <div class="bg-slate-900 border border-slate-700 rounded-2xl w-full max-w-2xl max-h-[90vh] flex flex-col shadow-2xl overflow-hidden transform scale-95 transition-transform duration-200" id="addDataModalContent">
      <!-- Modal Header -->
      <div class="p-5 border-b border-slate-800 flex items-center justify-between bg-slate-950/60">
        <div class="flex items-center gap-2.5">
          <div class="w-8 h-8 rounded-lg bg-emerald-500/20 text-emerald-400 flex items-center justify-center font-bold text-lg">
            ➕
          </div>
          <div>
            <h3 class="text-base font-bold text-white tracking-tight">Add Dynamic Data to SQLite</h3>
            <p class="text-xs text-slate-400">Stores real data directly into <code class="text-pink-400">server/data/stylito.db</code></p>
          </div>
        </div>
        <button onclick="closeAddDataModal()" class="w-8 h-8 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 flex items-center justify-center text-lg transition">
          ✕
        </button>
      </div>

      <!-- Modal Body -->
      <form id="addDataForm" onsubmit="submitAddDataForm(event)" class="p-6 overflow-y-auto space-y-4 flex-1">
        <!-- Table Selection Box -->
        <div>
          <label class="block text-xs font-semibold uppercase tracking-wider text-slate-400 mb-1.5">
            Select Database Table
          </label>
          <select id="selectedTable" name="table" onchange="renderDynamicFields(this.value)" class="w-full bg-slate-950 border border-slate-700 rounded-xl px-3.5 py-2.5 text-sm text-white focus:outline-none focus:border-pink-500 transition">
            <option value="users">👤 users (Users, Phone & Passwords)</option>
            <option value="otps">📱 otps (Phone & Email OTP Verification)</option>
            <option value="products">👗 products (Clothing, Footwear & Fashion)</option>
            <option value="categories">🏷️ categories (Categories & Slugs)</option>
            <option value="orders">📦 orders (Customer Orders & Shipments)</option>
            <option value="inquiries">💬 inquiries (Customer Messages & Contact)</option>
          </select>
        </div>

        <!-- Dynamic Form Fields Injected Here -->
        <div id="dynamicFormFields" class="space-y-4 pt-2 border-t border-slate-800">
          <!-- Populated by JavaScript -->
        </div>

        <div id="formErrorMessage" class="p-3 bg-red-950/80 border border-red-500/50 rounded-xl text-red-300 text-xs font-medium hidden"></div>

        <!-- Actions -->
        <div class="pt-4 border-t border-slate-800 flex items-center justify-end gap-3">
          <button type="button" onclick="closeAddDataModal()" class="px-4 py-2 bg-slate-800 hover:bg-slate-700 text-slate-300 rounded-lg text-sm font-medium transition">
            Cancel
          </button>
          <button type="submit" id="saveDataBtn" class="px-5 py-2 bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-500 hover:to-teal-500 text-white rounded-lg text-sm font-semibold flex items-center gap-2 transition shadow-lg shadow-emerald-600/30">
            <span>💾</span>
            <span>Save to SQLite</span>
          </button>
        </div>
      </form>
    </div>
  </div>

  <script>
    // Templates for each table
    const tableFieldTemplates = {
      users: \`
        <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Full Name *</label>
            <input type="text" name="name" required placeholder="e.g. Drashti Patel" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Email Address *</label>
            <input type="email" name="email" required placeholder="e.g. drashti@example.com" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Phone Number (Real Store Sync) *</label>
            <input type="tel" name="phone" placeholder="+91 9876543210" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Password (Auto-hashed)</label>
            <input type="password" name="password" placeholder="Defaults to Stylito@123" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div class="md:col-span-2">
            <label class="block text-xs font-semibold text-slate-300 mb-1">Address</label>
            <input type="text" name="address" placeholder="e.g. 102, Royal Heritage Apt" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">City</label>
            <input type="text" name="city" placeholder="Surat" value="Surat" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">State</label>
            <input type="text" name="state" placeholder="Gujarat" value="Gujarat" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Pincode</label>
            <input type="text" name="pincode" placeholder="395007" value="395007" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Country</label>
            <input type="text" name="country" placeholder="India" value="India" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
        </div>
      \`,
      otps: \`
        <div class="space-y-3">
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Contact (Phone Number or Email) *</label>
            <input type="text" name="contact" required placeholder="+91 9876543210 or user@stylito.com" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <div class="flex items-center justify-between mb-1">
              <label class="block text-xs font-semibold text-slate-300">6-Digit Verification OTP Code *</label>
              <button type="button" onclick="generateOtpCode()" class="text-xs text-pink-400 hover:text-pink-300 font-semibold cursor-pointer">
                🎲 Auto-Generate OTP
              </button>
            </div>
            <input type="text" id="otpCodeInput" name="code" required maxlength="8" placeholder="e.g. 582910" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white font-mono tracking-widest focus:outline-none focus:border-pink-500">
          </div>
          <div class="grid grid-cols-2 gap-3">
            <div>
              <label class="block text-xs font-semibold text-slate-300 mb-1">Expires In</label>
              <select name="expires_minutes" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
                <option value="10">10 Minutes</option>
                <option value="30">30 Minutes</option>
                <option value="60">1 Hour</option>
                <option value="1440">24 Hours</option>
              </select>
            </div>
            <div>
              <label class="block text-xs font-semibold text-slate-300 mb-1">Verification Status</label>
              <select name="is_used" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
                <option value="0">0 - Pending / Unused</option>
                <option value="1">1 - Verified & Used</option>
              </select>
            </div>
          </div>
        </div>
      \`,
      products: \`
        <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
          <div class="md:col-span-2">
            <label class="block text-xs font-semibold text-slate-300 mb-1">Product Title *</label>
            <input type="text" name="title" required placeholder="e.g. Premium Silk Anarkali Gown" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Subtitle / Tagline</label>
            <input type="text" name="subtitle" placeholder="e.g. Festive Luxury Edition" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Category *</label>
            <select name="category" required class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
              <option value="Womens">Womens</option>
              <option value="Mens">Mens</option>
              <option value="Beauty">Beauty</option>
              <option value="Fashion">Fashion</option>
              <option value="Kids">Kids</option>
              <option value="Flat and Heels">Flat and Heels</option>
            </select>
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Selling Price (₹) *</label>
            <input type="number" step="0.01" name="price" required placeholder="1499" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Original MRP (₹)</label>
            <input type="number" step="0.01" name="original_price" placeholder="2499" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Available Sizes (Comma Separated)</label>
            <input type="text" name="sizes" value="S, M, L, XL" placeholder="S, M, L, XL" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Image URL / Path</label>
            <input type="text" name="image_url" value="assets/images/fashion.png" placeholder="assets/images/womens.png" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div class="md:col-span-2">
            <label class="block text-xs font-semibold text-slate-300 mb-1">Description</label>
            <textarea name="description" rows="2" placeholder="Crafted with pure fabrics and intricate embroidery..." class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500"></textarea>
          </div>
        </div>
      \`,
      categories: \`
        <div class="space-y-3">
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Category Name *</label>
            <input type="text" name="name" required placeholder="e.g. Summer Essentials" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Slug (URL identifier)</label>
            <input type="text" name="slug" placeholder="e.g. summer-essentials" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Banner Image URL</label>
            <input type="text" name="image_url" value="assets/images/fashion.png" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Description</label>
            <textarea name="description" rows="2" placeholder="Vibrant seasonal curation for sunny days" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500"></textarea>
          </div>
        </div>
      \`,
      orders: \`
        <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Customer Name *</label>
            <input type="text" name="customer_name" required placeholder="e.g. Ananya Sharma" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Customer Email *</label>
            <input type="email" name="customer_email" required placeholder="e.g. ananya@gmail.com" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div class="md:col-span-2">
            <label class="block text-xs font-semibold text-slate-300 mb-1">Shipping Address</label>
            <input type="text" name="shipping_address" placeholder="e.g. Flat 402, Lotus Tower, Ahmedabad, Gujarat 380015" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Total Amount (₹) *</label>
            <input type="number" step="0.01" name="total_amount" required placeholder="2499" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Payment Method</label>
            <select name="payment_method" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
              <option value="UPI / QR">UPI / QR (Instant)</option>
              <option value="Cash on Delivery">Cash on Delivery</option>
              <option value="Credit / Debit Card">Credit / Debit Card</option>
            </select>
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Payment Status</label>
            <select name="payment_status" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
              <option value="Completed">Completed</option>
              <option value="Pending">Pending</option>
              <option value="Failed">Failed</option>
            </select>
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Order Status</label>
            <select name="order_status" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
              <option value="Processing">Processing</option>
              <option value="Shipped">Shipped</option>
              <option value="Delivered">Delivered</option>
              <option value="Cancelled">Cancelled</option>
            </select>
          </div>
          <div class="md:col-span-2">
            <label class="block text-xs font-semibold text-slate-300 mb-1">Items Description or JSON</label>
            <input type="text" name="items" value='[{"title":"Embroidered Kurta","qty":1,"price":2499}]' class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white font-mono focus:outline-none focus:border-pink-500">
          </div>
        </div>
      \`,
      inquiries: \`
        <div class="space-y-3">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
            <div>
              <label class="block text-xs font-semibold text-slate-300 mb-1">Customer Name *</label>
              <input type="text" name="name" required placeholder="e.g. Rahul Mehta" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
            </div>
            <div>
              <label class="block text-xs font-semibold text-slate-300 mb-1">Email Address *</label>
              <input type="email" name="email" required placeholder="e.g. rahul@example.com" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
            </div>
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Subject</label>
            <input type="text" name="subject" placeholder="e.g. Order Delivery Query" value="Customer Inquiry" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Message Content *</label>
            <textarea name="message" required rows="3" placeholder="Write the inquiry or customer message..." class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500"></textarea>
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 mb-1">Status</label>
            <select name="status" class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none focus:border-pink-500">
              <option value="New">New</option>
              <option value="In Review">In Review</option>
              <option value="Resolved">Resolved</option>
            </select>
          </div>
        </div>
      \`
    };

    function renderDynamicFields(table) {
      const container = document.getElementById('dynamicFormFields');
      container.innerHTML = tableFieldTemplates[table] || '<p class="text-xs text-slate-400">No template available for this table.</p>';
      if (table === 'otps') {
        generateOtpCode();
      }
    }

    function generateOtpCode() {
      const input = document.getElementById('otpCodeInput');
      if (input) {
        const randomOtp = Math.floor(100000 + Math.random() * 900000);
        input.value = randomOtp;
      }
    }

    function openAddDataModal(defaultTable) {
      const modal = document.getElementById('addDataModal');
      const content = document.getElementById('addDataModalContent');
      const select = document.getElementById('selectedTable');
      const errorBox = document.getElementById('formErrorMessage');
      if (errorBox) errorBox.classList.add('hidden');

      if (defaultTable && tableFieldTemplates[defaultTable]) {
        select.value = defaultTable;
      }

      renderDynamicFields(select.value);

      modal.classList.remove('hidden');
      setTimeout(() => {
        modal.classList.remove('opacity-0');
        content.classList.remove('scale-95');
        content.classList.add('scale-100');
      }, 10);
    }

    function closeAddDataModal() {
      const modal = document.getElementById('addDataModal');
      const content = document.getElementById('addDataModalContent');
      modal.classList.add('opacity-0');
      content.classList.add('scale-95');
      content.classList.remove('scale-100');
      setTimeout(() => {
        modal.classList.add('hidden');
      }, 200);
    }

    async function submitAddDataForm(e) {
      e.preventDefault();
      const form = document.getElementById('addDataForm');
      const submitBtn = document.getElementById('saveDataBtn');
      const errorBox = document.getElementById('formErrorMessage');
      const formData = new FormData(form);
      const data = Object.fromEntries(formData.entries());

      errorBox.classList.add('hidden');
      submitBtn.disabled = true;
      submitBtn.innerHTML = '<span>⏳</span><span>Saving...</span>';

      try {
        const res = await fetch('/admin/api/insert', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
          body: JSON.stringify(data)
        });

        const result = await res.json();
        if (result.success) {
          window.location.href = '/admin?tab=' + encodeURIComponent(result.table) + '&added=1';
        } else {
          errorBox.textContent = '❌ ' + (result.message || 'Failed to save record.');
          errorBox.classList.remove('hidden');
          submitBtn.disabled = false;
          submitBtn.innerHTML = '<span>💾</span><span>Save to SQLite</span>';
        }
      } catch (err) {
        errorBox.textContent = '❌ Network error: ' + err.message;
        errorBox.classList.remove('hidden');
        submitBtn.disabled = false;
        submitBtn.innerHTML = '<span>💾</span><span>Save to SQLite</span>';
      }
    }

    async function deleteSingleRow(table, id, btn) {
      if (!confirm('Are you sure you want to delete this row (' + id + ') from table "' + table + '"?')) {
        return;
      }

      const row = btn.closest('tr');
      btn.disabled = true;
      btn.innerHTML = '<span>⏳</span>';

      try {
        const res = await fetch('/admin/delete-row/' + encodeURIComponent(table) + '/' + encodeURIComponent(id), {
          method: 'POST',
          headers: { 'Accept': 'application/json' }
        });

        const data = await res.json();
        if (data.success) {
          row.style.transition = 'all 0.3s ease';
          row.style.opacity = '0';
          row.style.transform = 'translateX(20px)';
          setTimeout(() => {
            window.location.href = '/admin?tab=' + encodeURIComponent(table) + '&deleted=1';
          }, 250);
        } else {
          alert('Error deleting row: ' + (data.message || 'Failed to delete row'));
          btn.disabled = false;
          btn.innerHTML = '<span>🗑️</span><span class="hidden sm:inline">Delete</span>';
        }
      } catch (err) {
        // Fallback form submit
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '/admin/delete-row/' + encodeURIComponent(table) + '/' + encodeURIComponent(id);
        document.body.appendChild(form);
        form.submit();
      }
    }

    // Close on backdrop click
    document.getElementById('addDataModal').addEventListener('click', function(e) {
      if (e.target === this) {
        closeAddDataModal();
      }
    });

    // Close on ESC
    window.addEventListener('keydown', function(e) {
      if (e.key === 'Escape') {
        closeAddDataModal();
      }
    });
  </script>
</body>
</html>`;

    res.send(html);
  } catch (err) {
    res.status(500).send(`<h3>Error loading admin viewer: ${err.message}</h3>`);
  }
});

module.exports = router;
