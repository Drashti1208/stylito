require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { initDatabase } = require('./db/database');

const authRoutes = require('./routes/auth');
const productRoutes = require('./routes/products');
const categoryRoutes = require('./routes/categories');
const orderRoutes = require('./routes/orders');
const inquiryRoutes = require('./routes/inquiries');
const adminRoutes = require('./routes/admin');

const app = express();
const PORT = process.env.PORT || 5000;

// Enable CORS for all incoming client origins (Flutter mobile, Web landing page, etc.)
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

app.use(express.json());

// Simple request logger
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.originalUrl} -> ${res.statusCode} (${duration}ms)`);
  });
  next();
});

// Root welcome & API documentation index
app.get('/', (req, res) => {
  res.json({
    name: 'Stylito Fashion REST API',
    status: 'online',
    version: '1.0.0',
    documentation: {
      health: 'GET /api/health',
      auth: {
        register: 'POST /api/auth/register',
        login: 'POST /api/auth/login',
        profile: 'GET /api/auth/profile',
        updateProfile: 'PUT /api/auth/profile'
      },
      products: {
        list: 'GET /api/products',
        deals: 'GET /api/products/deals',
        trending: 'GET /api/products/trending',
        byCategory: 'GET /api/products/category/:slug',
        details: 'GET /api/products/:id',
        create: 'POST /api/products',
        update: 'PUT /api/products/:id',
        delete: 'DELETE /api/products/:id'
      },
      categories: {
        list: 'GET /api/categories',
        create: 'POST /api/categories'
      },
      orders: {
        create: 'POST /api/orders',
        list: 'GET /api/orders',
        get: 'GET /api/orders/:id'
      },
      inquiries: {
        submit: 'POST /api/inquiries',
        list: 'GET /api/inquiries',
        realtimeStream: 'GET /api/inquiries/stream'
      }
    }
  });
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptimeSeconds: Math.floor(process.uptime()),
    database: 'SQLite 3 (ACID Relational)'
  });
});

// Mount modular routes
app.use('/api/auth', authRoutes);
app.use('/api/products', productRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/inquiries', inquiryRoutes);
app.use('/admin', adminRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({ success: false, message: `Route not found: ${req.method} ${req.path}` });
});

// Central error handler
app.use((err, req, res, next) => {
  console.error('Unhandled Server Error:', err);
  res.status(500).json({ success: false, message: 'Internal server error occurred.' });
});

// Start server after database initialization
initDatabase()
  .then(() => {
    app.listen(PORT, () => {
      console.log('========================================================');
      console.log(`🚀 Stylito REST API Server running on http://localhost:${PORT}`);
      console.log(`   Health Check: http://localhost:${PORT}/api/health`);
      console.log(`   Products API: http://localhost:${PORT}/api/products`);
      console.log(`   Inquiries API: http://localhost:${PORT}/api/inquiries`);
      console.log(`   Realtime SSE: http://localhost:${PORT}/api/inquiries/stream`);
      console.log('========================================================');
    });
  })
  .catch((err) => {
    console.error('❌ Failed to initialize database:', err);
    process.exit(1);
  });
