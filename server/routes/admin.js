const express = require('express');
const router = express.Router();
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
      ? `<div class="mb-4 p-3 bg-emerald-950/80 border border-emerald-500/50 rounded-xl text-emerald-300 text-xs font-semibold flex items-center gap-2">
           ✅ Table "${activeTab}" has been completely cleared!
         </div>`
      : '';

    const html = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Stylito SQLite Database Viewer</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    body { font-family: 'Plus Jakarta Sans', sans-serif; background: #0b0f19; color: #f1f5f9; }
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
            <h1 class="text-2xl font-bold text-white tracking-tight">Stylito SQLite Database Viewer</h1>
            <p class="text-slate-400 text-sm mt-0.5">Live records stored inside <code class="text-pink-400 bg-slate-900 px-2 py-0.5 rounded text-xs">server/data/stylito.db</code></p>
          </div>
        </div>
      </div>
      <div class="flex items-center gap-3">
        <a href="/admin?tab=${activeTab}" class="px-4 py-2 bg-pink-600 hover:bg-pink-500 text-white rounded-lg text-sm font-semibold flex items-center gap-2 transition shadow-lg shadow-pink-600/20">
          🔄 Refresh
        </a>
      </div>
    </div>

    ${clearedMessage}

    <!-- Stats Cards -->
    <div class="grid grid-cols-2 md:grid-cols-6 gap-3 my-6">
      ${VALID_TABLES.map((tbl) => {
        const isSelected = activeTab === tbl;
        return `
          <a href="/admin?tab=${tbl}" class="p-4 rounded-xl border transition ${
            isSelected
              ? 'bg-pink-950/40 border-pink-500 shadow-lg shadow-pink-500/10'
              : 'bg-slate-900/60 border-slate-800 hover:border-slate-700'
          }">
            <p class="text-slate-400 text-xs font-semibold uppercase">${tbl}</p>
            <p class="text-2xl font-bold text-white mt-1">${counts[tbl]}</p>
          </a>
        `;
      }).join('')}
    </div>

    <!-- Table Container -->
    <div class="bg-slate-900/80 rounded-2xl border border-slate-800 overflow-hidden shadow-2xl">
      <div class="p-4 border-b border-slate-800 flex flex-wrap items-center justify-between gap-3">
        <h2 class="text-lg font-semibold text-white capitalize flex items-center gap-2">
          <span>Table:</span>
          <span class="text-pink-400">${activeTab}</span>
          <span class="text-xs bg-slate-800 px-2 py-1 rounded text-slate-400 font-normal">${rows.length} rows</span>
        </h2>
        ${
          rows.length > 0
            ? `<form method="POST" action="/admin/clear/${activeTab}" onsubmit="return confirm('Are you sure you want to clear all data in ${activeTab}?');">
                 <button type="submit" class="px-3 py-1.5 bg-red-950/60 hover:bg-red-900 border border-red-800/80 text-red-300 text-xs font-semibold rounded-lg transition flex items-center gap-1.5">
                   🗑️ Clear Table
                 </button>
               </form>`
            : ''
        }
      </div>

      <div class="overflow-x-auto max-h-[600px] overflow-y-auto">
        ${
          rows.length === 0
            ? `
          <div class="text-center py-16 text-slate-500">
            <p class="text-4xl mb-2">📭</p>
            <p class="text-base font-medium">No records found in table "${activeTab}"</p>
            <p class="text-xs mt-1 text-slate-600">Real-time data created by the app will appear here automatically.</p>
          </div>
        `
            : `
          <table class="w-full text-left border-collapse text-xs">
            <thead class="bg-slate-950 sticky top-0 text-slate-400 border-b border-slate-800">
              <tr>
                ${columns
                  .map(
                    (col) =>
                      `<th class="p-3 font-semibold uppercase tracking-wider text-[11px] whitespace-nowrap">${col}</th>`
                  )
                  .join('')}
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-800/60">
              ${rows
                .map(
                  (row) => `
                <tr class="hover:bg-slate-800/40 transition">
                  ${columns
                    .map((col) => {
                      const val = row[col];
                      const isId = col === 'id' || col === 'user_id';
                      const isPass = col === 'password_hash';
                      if (isPass) {
                        return `<td class="p-3 whitespace-nowrap text-slate-600 font-mono text-[10px]">••••••••</td>`;
                      }
                      return `<td class="p-3 whitespace-nowrap ${
                        isId ? 'font-mono text-pink-300' : 'text-slate-300'
                      }">${
                        val !== null && val !== undefined
                          ? String(val)
                          : '<span class="text-slate-600">null</span>'
                      }</td>`;
                    })
                    .join('')}
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
</body>
</html>`;

    res.send(html);
  } catch (err) {
    res.status(500).send(`<h3>Error loading admin viewer: ${err.message}</h3>`);
  }
});

module.exports = router;
