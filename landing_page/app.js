/* ==========================================================================
   VELORA by Stylito — Interactive App Scripts
   Handles Cart, Wishlist, Category Filtering, Search, and Mobile Drawer
   ========================================================================== */

(function () {
  'use strict';

  // Sample Product Database
  const PRODUCTS = [
    {
      id: 'prod-black-dress',
      name: 'Black Dress',
      subtitle: 'Solid Black Dress for Women, Sexy Chain Shorts Ladi...',
      description: 'Sensational solid black bodycon dress for women, featuring delicate gold chain straps and figure-accentuating stretch fabric. Perfect for night outs and evening luxury.',
      price: 2000.00,
      originalPrice: 3500.00,
      discount: '43% OFF',
      rating: 4.5,
      reviewCount: '5,23,456',
      category: 'Dresses',
      image: 'assets/images/product_black_dress.png',
      sizes: ['XS', 'S', 'M', 'L', 'XL']
    },
    {
      id: 'prod-pink-embroidered',
      name: 'Pink Embroidered Maxi',
      subtitle: 'EARTHEN Rose Pink Embroidered Tiered Max...',
      description: 'EARTHEN collection rose pink tiered maxi dress adorned with intricate artisanal thread embroidery on the bodice and a breezy flowing silhouette.',
      price: 1900.00,
      originalPrice: 2800.00,
      discount: '32% OFF',
      rating: 4.5,
      reviewCount: '45,678',
      category: 'Dresses',
      image: 'assets/images/product_pink_dress.png',
      sizes: ['S', 'M', 'L', 'XL']
    },
    {
      id: 'prod-flare-dress',
      name: 'Flare Dress',
      subtitle: 'Antheaa Black & Rust Orange Floral Print Tiered Midi F...',
      description: 'Antheaa signature black and rust orange floral print tiered midi dress, with gentle flutter ruffles and a flared hem for graceful everyday elegance.',
      price: 1990.00,
      originalPrice: 2999.00,
      discount: '33% OFF',
      rating: 4.5,
      reviewCount: '3,35,566',
      category: 'Dresses',
      image: 'assets/images/product_flare_dress.png',
      sizes: ['S', 'M', 'L']
    },
    {
      id: 'prod-denim-dress',
      name: 'Denim Dress',
      subtitle: 'Blue cotton denim dress',
      description: 'Premium light-wash blue cotton denim shorts dress with an elasticized smocked waist, front buttons, and durable breathable finish.',
      price: 1499.00,
      originalPrice: 2499.00,
      discount: '40% OFF',
      rating: 4.6,
      reviewCount: '89,120',
      category: 'Dresses',
      image: 'assets/images/product_denim_dress.png',
      sizes: ['XS', 'S', 'M', 'L']
    },
    {
      id: 'prod-mens-starry',
      name: '100% Cotton Fabric Shirt',
      subtitle: 'Mens Starry Sky Printed Shirt 100% Cotton Fabric',
      description: '100% pure organic cotton fabric casual shirt featuring a modern starry sky print, breathable summer weave, and crisp spread collar.',
      price: 399.00,
      originalPrice: 799.00,
      discount: '50% OFF',
      rating: 4.5,
      reviewCount: '1,52,344',
      category: 'Tops',
      image: 'assets/images/product_mens_starry.png',
      sizes: ['S', 'M', 'L', 'XL']
    },
    {
      id: 'prod-black-winter',
      name: 'Black Winter Overcoat',
      subtitle: 'Autumn And Winter Casual cotton-padded jacket...',
      description: 'Heavyweight cozy autumn and winter padded overcoat with insulated thermal lining, high collar, zip closure, and weather-resistant finish.',
      price: 2499.00,
      originalPrice: 4999.00,
      discount: '50% OFF',
      rating: 4.7,
      reviewCount: '68,900',
      category: 'Outerwear',
      image: 'assets/images/product_black_winter.png',
      sizes: ['M', 'L', 'XL']
    },
    {
      id: 'prod-leather-jacket',
      name: 'Leather Biker Jacket',
      subtitle: 'Premium Slim-Fit Faux Leather Jacket with Metal Zips',
      description: 'Tailored moto biker jacket crafted from rich textured faux leather with metallic hardware, zip pockets, and timeless rock-and-roll silhouette.',
      price: 2999.00,
      originalPrice: 5999.00,
      discount: '50% OFF',
      rating: 4.8,
      reviewCount: '1,12,400',
      category: 'Outerwear',
      image: 'assets/images/product_leather_jacket.png',
      sizes: ['S', 'M', 'L', 'XL']
    },
    {
      id: 'prod-hrx-sneakers',
      name: 'HRX Sports Sneakers',
      subtitle: 'Court-ready lightweight sneakers designed for active running',
      description: 'Court-ready lightweight performance sneakers designed with shock-absorbing soles, engineered mesh upper, and high-traction grip.',
      price: 2499.00,
      originalPrice: 4999.00,
      discount: '50% OFF',
      rating: 4.8,
      reviewCount: '3,44,567',
      category: 'Accessories',
      image: 'assets/images/product_hrx.png',
      sizes: ['6 UK', '7 UK', '8 UK', '9 UK', '10 UK']
    }
  ];

  // State
  let cart = JSON.parse(localStorage.getItem('velora_cart') || '[]');
  let wishlist = JSON.parse(localStorage.getItem('velora_wishlist') || '[]');

  // DOM Elements
  const cartTriggerBtn = document.getElementById('cartTriggerBtn');
  const cartDrawer = document.getElementById('cartDrawer');
  const cartDrawerClose = document.getElementById('cartDrawerClose');
  const drawerBackdrop = document.getElementById('drawerBackdrop');
  const cartItemsContainer = document.getElementById('cartItemsContainer');
  const cartSubtotal = document.getElementById('cartSubtotal');
  const cartCountEl = document.getElementById('cartCount');
  const drawerCartCountEl = document.getElementById('drawerCartCount');
  const wishlistCountEl = document.getElementById('wishlistCount');
  const searchTriggerBtn = document.getElementById('searchTriggerBtn');
  const searchModal = document.getElementById('searchModal');
  const searchModalClose = document.getElementById('searchModalClose');
  const globalSearchInput = document.getElementById('globalSearchInput');
  const searchResultsPreview = document.getElementById('searchResultsPreview');
  const mobileMenuToggle = document.getElementById('mobileMenuToggle');
  const mobileDrawer = document.getElementById('mobileDrawer');
  const mobileDrawerClose = document.getElementById('mobileDrawerClose');
  const toastNotice = document.getElementById('toastNotice');

  // Bottom Details / Contact Us Sheet Elements
  const bottomDetailsSheet = document.getElementById('bottomDetailsSheet');
  const bottomDetailsBackdrop = document.getElementById('bottomDetailsBackdrop');
  const bottomDetailsClose = document.getElementById('bottomDetailsClose');
  const brandLogoBtn = document.getElementById('brandLogoBtn');
  const profileTriggerBtn = document.getElementById('profileTriggerBtn');
  const contactNavBtn = document.getElementById('contactNavBtn');

  // Initialization
  function init() {
    updateCartUI();
    updateWishlistUI();
    setupEventListeners();
    initAuthSession();
  }

  // Event Listeners Setup
  function setupEventListeners() {
    // Cart Drawer Toggle
    if (cartTriggerBtn) {
      cartTriggerBtn.addEventListener('click', openCart);
    }
    if (cartDrawerClose) {
      cartDrawerClose.addEventListener('click', closeCart);
    }
    if (drawerBackdrop) {
      drawerBackdrop.addEventListener('click', () => {
        closeCart();
        closeMobileDrawer();
        closeSearch();
      });
    }

    // Bottom Details / Contact Sheet Listeners
    if (bottomDetailsClose) {
      bottomDetailsClose.addEventListener('click', closeBottomDetails);
    }
    if (bottomDetailsBackdrop) {
      bottomDetailsBackdrop.addEventListener('click', closeBottomDetails);
    }
    if (brandLogoBtn) {
      brandLogoBtn.addEventListener('click', (e) => {
        e.preventDefault();
        openBottomDetails();
      });
    }
    if (profileTriggerBtn) {
      profileTriggerBtn.addEventListener('click', (e) => {
        e.preventDefault();
        openBottomDetails();
      });
    }
    if (contactNavBtn) {
      contactNavBtn.addEventListener('click', (e) => {
        e.preventDefault();
        openBottomDetails();
      });
    }
    document.querySelectorAll('.open-bottom-contact').forEach(btn => {
      btn.addEventListener('click', (e) => {
        e.preventDefault();
        closeMobileDrawer();
        openBottomDetails();
      });
    });
    document.querySelectorAll('.mobile-nav-links a:not(.open-bottom-contact)').forEach(link => {
      link.addEventListener('click', () => {
        closeMobileDrawer();
      });
    });

    // Search Modal Toggle
    if (searchTriggerBtn) {
      searchTriggerBtn.addEventListener('click', openSearch);
    }
    if (searchModalClose) {
      searchModalClose.addEventListener('click', closeSearch);
    }

    // Inline Search Bar Trigger (if present)
    const inlineSearchInput = document.getElementById('inlineSearchInput');
    const inlineSearchBtn = document.getElementById('inlineSearchBtn');
    if (inlineSearchInput) {
      inlineSearchInput.addEventListener('focus', openSearch);
      inlineSearchInput.addEventListener('click', openSearch);
    }
    if (inlineSearchBtn) {
      inlineSearchBtn.addEventListener('click', openSearch);
    }

    // Mobile Navigation Drawer Toggle
    if (mobileMenuToggle) {
      mobileMenuToggle.addEventListener('click', openMobileDrawer);
    }
    if (mobileDrawerClose) {
      mobileDrawerClose.addEventListener('click', closeMobileDrawer);
    }

    // Product Details Modal Listeners
    const productModalClose = document.getElementById('productModalClose');
    const productModalBackdrop = document.getElementById('productModalBackdrop');
    if (productModalClose) {
      productModalClose.addEventListener('click', closeProductDetails);
    }
    if (productModalBackdrop) {
      productModalBackdrop.addEventListener('click', closeProductDetails);
    }

    // Close on Escape Key
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        closeCart();
        closeSearch();
        closeMobileDrawer();
        closeBottomDetails();
        closeProductDetails();
      }
    });
  }

  // Cart Functions
  function openCart() {
    cartDrawer.classList.add('active');
    drawerBackdrop.classList.add('active');
    document.body.style.overflow = 'hidden';
  }

  function closeCart() {
    cartDrawer.classList.remove('active');
    if (!mobileDrawer.classList.contains('active')) {
      drawerBackdrop.classList.remove('active');
      document.body.style.overflow = '';
    }
  }

  window.addToCart = function (id, name, price, image) {
    const existing = cart.find(item => item.id === id);
    if (existing) {
      existing.quantity += 1;
    } else {
      cart.push({ id, name, price, image, quantity: 1 });
    }
    saveCart();
    updateCartUI();
    openCart();
    showToast('Added "' + name + '" to your bag');
  };

  window.changeQty = function (id, delta) {
    const item = cart.find(item => item.id === id);
    if (!item) return;
    item.quantity += delta;
    if (item.quantity <= 0) {
      cart = cart.filter(i => i.id !== id);
    }
    saveCart();
    updateCartUI();
  };

  window.removeFromCart = function (id) {
    cart = cart.filter(item => item.id !== id);
    saveCart();
    updateCartUI();
    showToast('Item removed from shopping bag');
  };

  function saveCart() {
    localStorage.setItem('velora_cart', JSON.stringify(cart));
  }

  function updateCartUI() {
    const totalQty = cart.reduce((sum, item) => sum + item.quantity, 0);
    const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);

    if (cartCountEl) cartCountEl.textContent = totalQty;
    if (drawerCartCountEl) drawerCartCountEl.textContent = totalQty;
    if (cartSubtotal) cartSubtotal.textContent = '$' + subtotal.toFixed(2);

    if (!cartItemsContainer) return;

    if (cart.length === 0) {
      cartItemsContainer.innerHTML = 
        '<div class="empty-cart-message">' +
          '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor">' +
            '<path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path>' +
            '<line x1="3" y1="6" x2="21" y2="6"></line>' +
            '<path d="M16 10a4 4 0 0 1-8 0"></path>' +
          '</svg>' +
          '<p>Your shopping bag is currently empty.</p>' +
        '</div>';
    } else {
      cartItemsContainer.innerHTML = cart.map(item => 
        '<div class="cart-item">' +
          '<img src="' + item.image + '" alt="' + item.name + '" class="cart-item-img" />' +
          '<div class="cart-item-details">' +
            '<h4>' + item.name + '</h4>' +
            '<p class="cart-price">$' + item.price.toFixed(2) + '</p>' +
            '<div class="qty-control">' +
              '<button class="qty-btn" onclick="changeQty(\'' + item.id + '\', -1)" aria-label="Decrease">&minus;</button>' +
              '<span class="qty-number">' + item.quantity + '</span>' +
              '<button class="qty-btn" onclick="changeQty(\'' + item.id + '\', 1)" aria-label="Increase">+</button>' +
            '</div>' +
          '</div>' +
          '<button class="cart-item-remove" onclick="removeFromCart(\'' + item.id + '\')" title="Remove item" aria-label="Remove">&times;</button>' +
        '</div>'
      ).join('');
    }
  }

  window.proceedToCheckout = function () {
    if (cart.length === 0) {
      showToast('Your shopping bag is empty.');
      return;
    }
    alert('Thank you for choosing VELORA! Seamless checkout gateway integration will initiate here.');
  };

  // Wishlist Functions
  window.toggleWishlist = function (id, name, price, image, btnEl) {
    const index = wishlist.findIndex(item => item.id === id);
    if (index > -1) {
      wishlist.splice(index, 1);
      if (btnEl) btnEl.classList.remove('active');
      showToast('Removed "' + name + '" from wishlist');
    } else {
      wishlist.push({ id, name, price, image });
      if (btnEl) btnEl.classList.add('active');
      showToast('Saved "' + name + '" to wishlist');
    }
    localStorage.setItem('velora_wishlist', JSON.stringify(wishlist));
    updateWishlistUI();
  };

  function updateWishlistUI() {
    if (wishlistCountEl) {
      wishlistCountEl.textContent = wishlist.length;
    }
    // Update button states on current page
    document.querySelectorAll('.wishlist-btn').forEach(btn => {
      const card = btn.closest('.product-card');
      if (card) {
        const id = card.getAttribute('data-id');
        if (wishlist.some(item => item.id === id)) {
          btn.classList.add('active');
        } else {
          btn.classList.remove('active');
        }
      }
    });
  }

  // Filter Products by Category
  window.filterProducts = function (category) {
    const section = document.getElementById('new-arrivals');
    if (section) {
      section.scrollIntoView({ behavior: 'smooth' });
    }

    const cards = document.querySelectorAll('.product-card');
    cards.forEach(card => {
      const prodCategory = card.getAttribute('data-category');
      if (category === 'Sale' || !category || prodCategory.toLowerCase() === category.toLowerCase()) {
        card.style.display = 'flex';
      } else {
        card.style.display = 'none';
      }
    });

    showToast('Showing category: ' + (category || 'All'));
  };

  window.showAllProducts = function () {
    const cards = document.querySelectorAll('.product-card');
    cards.forEach(card => card.style.display = 'flex');
    showToast('Showing all new arrivals');
  };

  // Search Modal Functions
  function openSearch() {
    searchModal.classList.add('active');
    setTimeout(() => {
      if (globalSearchInput) globalSearchInput.focus();
    }, 150);
  }

  function closeSearch() {
    searchModal.classList.remove('active');
    if (globalSearchInput) globalSearchInput.value = '';
    if (searchResultsPreview) searchResultsPreview.innerHTML = '';
  }

  window.handleSearch = function (query) {
    if (!searchResultsPreview) return;
    const clean = query.trim().toLowerCase();
    if (!clean) {
      searchResultsPreview.innerHTML = '';
      return;
    }

    const matches = PRODUCTS.filter(p => 
      p.name.toLowerCase().includes(clean) || 
      p.category.toLowerCase().includes(clean)
    );

    if (matches.length === 0) {
      searchResultsPreview.innerHTML = '<p style="padding: 12px 0; color: #888; font-size: 0.85rem;">No products found matching "' + clean + '".</p>';
    } else {
      searchResultsPreview.innerHTML = matches.map(item => 
        '<div style="display:flex; align-items:center; gap:16px; padding:10px 0; border-bottom:1px solid #f0ede8; cursor:pointer;" onclick="addToCart(\'' + item.id + '\', \'' + item.name.replace(/'/g, "\\'") + '\', ' + item.price + ', \'' + item.image + '\'); closeSearch();">' +
          '<img src="' + item.image + '" alt="' + item.name + '" style="width:48px; height:58px; object-fit:cover; border-radius:2px;" />' +
          '<div style="flex:1;">' +
            '<div style="font-size:0.85rem; font-weight:600;">' + item.name + '</div>' +
            '<div style="font-size:0.8rem; color:#888;">' + item.category + ' &bull; $' + item.price.toFixed(2) + '</div>' +
          '</div>' +
          '<button class="btn btn-outline" style="padding:6px 14px; font-size:0.7rem;">+ Add</button>' +
        '</div>'
      ).join('');
    }
  };

  // Mobile Drawer
  function openMobileDrawer() {
    mobileDrawer.classList.add('active');
    drawerBackdrop.classList.add('active');
    document.body.style.overflow = 'hidden';
  }

  function closeMobileDrawer() {
    mobileDrawer.classList.remove('active');
    if (!cartDrawer.classList.contains('active') && !bottomDetailsSheet.classList.contains('active')) {
      drawerBackdrop.classList.remove('active');
      document.body.style.overflow = '';
    }
  }

  // Bottom Details / Contact Us Sheet Functions
  function openBottomDetails() {
    if (bottomDetailsSheet) bottomDetailsSheet.classList.add('active');
    if (bottomDetailsBackdrop) bottomDetailsBackdrop.classList.add('active');
    document.body.style.overflow = 'hidden';
  }

  function closeBottomDetails() {
    if (bottomDetailsSheet) bottomDetailsSheet.classList.remove('active');
    if (bottomDetailsBackdrop) bottomDetailsBackdrop.classList.remove('active');
    if (!mobileDrawer.classList.contains('active') && !cartDrawer.classList.contains('active')) {
      document.body.style.overflow = '';
    }
  }

  window.openBottomDetails = openBottomDetails;
  window.closeBottomDetails = closeBottomDetails;

  window.handleBottomContactSubmit = async function (e) {
    e.preventDefault();
    const name = document.getElementById('bottomContactName')?.value?.trim() || 'Valued Customer';
    const email = document.getElementById('bottomContactEmail')?.value?.trim() || '';
    const subject = document.getElementById('bottomContactSubject')?.value?.trim() || 'Direct Inquiry';
    const message = document.getElementById('bottomContactMessage')?.value?.trim() || '';

    const submitBtn = e.target.querySelector('button[type="submit"]');
    const originalText = submitBtn ? submitBtn.innerText : 'SEND MESSAGE';
    if (submitBtn) {
      submitBtn.disabled = true;
      submitBtn.innerText = 'SENDING...';
    }

    try {
      const response = await fetch('http://localhost:5000/api/inquiries', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, email, subject, message }),
      });

      const result = await response.json();
      if (response.ok && result.success) {
        showToast(` Message received in real-time! Thank you, ${name}.`);
        const form = document.getElementById('bottomContactForm');
        if (form) form.reset();
        setTimeout(closeBottomDetails, 1800);
      } else {
        showToast(` ${result.message || 'Could not send message. Please try again.'}`);
      }
    } catch (err) {
      // Offline fallback: save locally and acknowledge
      try {
        const localInquiries = JSON.parse(localStorage.getItem('stylito_offline_inquiries') || '[]');
        localInquiries.push({ name, email, subject, message, date: new Date().toISOString() });
        localStorage.setItem('stylito_offline_inquiries', JSON.stringify(localInquiries));
      } catch (_) {}
      showToast(` Saved! Thank you, ${name}. Our styling team will review your inquiry.`);
      const form = document.getElementById('bottomContactForm');
      if (form) form.reset();
      setTimeout(closeBottomDetails, 1800);
    } finally {
      if (submitBtn) {
        submitBtn.disabled = false;
        submitBtn.innerText = originalText;
      }
    }
  };

  // Product Details Quick-View Modal Functions
  let currentModalProductId = null;
  const productDetailsModal = document.getElementById('productDetailsModal');
  const productModalBackdrop = document.getElementById('productModalBackdrop');

  function openProductDetails(id) {
    const prod = PRODUCTS.find(p => p.id === id);
    if (!prod) return;
    currentModalProductId = id;

    const imgEl = document.getElementById('modalProductImage');
    const titleEl = document.getElementById('modalProductTitle');
    const subtitleEl = document.getElementById('modalProductSubtitle');
    const descEl = document.getElementById('modalProductDescription');
    const priceEl = document.getElementById('modalProductPrice');
    const origPriceEl = document.getElementById('modalProductOrigPrice');
    const discountEl = document.getElementById('modalProductDiscount');
    const reviewsEl = document.getElementById('modalProductReviews');
    const categoryEl = document.getElementById('modalProductCategory');
    const ratingScoreEl = document.getElementById('modalProductRatingScore');

    if (imgEl) {
      imgEl.src = prod.image;
      imgEl.alt = prod.name;
      imgEl.onerror = function () {
        if (!this.dataset.retry) {
          this.dataset.retry = '1';
          this.src = 'landing_page/' + prod.image;
        }
      };
    }
    if (titleEl) titleEl.textContent = prod.name;
    if (subtitleEl) subtitleEl.textContent = prod.subtitle || '';
    if (descEl) descEl.textContent = prod.description || '';
    if (priceEl) priceEl.textContent = '₹' + prod.price.toLocaleString('en-IN');
    if (origPriceEl) origPriceEl.textContent = '₹' + prod.originalPrice.toLocaleString('en-IN');
    if (discountEl) discountEl.textContent = prod.discount || '';
    if (ratingScoreEl) ratingScoreEl.textContent = prod.rating || '4.5';
    if (reviewsEl) reviewsEl.textContent = '(' + (prod.reviewCount || '50,000+') + ' ratings)';
    if (categoryEl) categoryEl.textContent = (prod.category || 'FASHION').toUpperCase();

    // Render selectable sizes
    const sizesContainer = document.getElementById('modalProductSizes');
    if (sizesContainer && prod.sizes) {
      sizesContainer.innerHTML = prod.sizes.map((s, idx) => 
        '<button type="button" class="size-chip' + (idx === 0 ? ' active' : '') + '" onclick="selectSize(this)">' + s + '</button>'
      ).join('');
    }

    if (productDetailsModal) productDetailsModal.classList.add('active');
    if (productModalBackdrop) productModalBackdrop.classList.add('active');
    document.body.style.overflow = 'hidden';
  }

  function closeProductDetails() {
    if (productDetailsModal) productDetailsModal.classList.remove('active');
    if (productModalBackdrop) productModalBackdrop.classList.remove('active');
    if (!mobileDrawer.classList.contains('active') && !cartDrawer.classList.contains('active') && !bottomDetailsSheet.classList.contains('active')) {
      document.body.style.overflow = '';
    }
  }

  window.openProductDetails = openProductDetails;
  window.closeProductDetails = closeProductDetails;

  window.selectSize = function (btn) {
    const parent = btn.parentElement;
    if (parent) {
      parent.querySelectorAll('.size-chip').forEach(b => b.classList.remove('active'));
    }
    btn.classList.add('active');
  };

  window.addModalProductToBag = function () {
    if (!currentModalProductId) return;
    const prod = PRODUCTS.find(p => p.id === currentModalProductId);
    if (!prod) return;
    addToCart(prod.id, prod.name, prod.price, prod.image);
    closeProductDetails();
  };

  window.buyModalProductNow = function () {
    if (!currentModalProductId) return;
    const prod = PRODUCTS.find(p => p.id === currentModalProductId);
    if (!prod) return;
    addToCart(prod.id, prod.name, prod.price, prod.image);
    closeProductDetails();
    proceedToCheckout();
  };

  window.toggleModalProductWishlist = function (btn) {
    if (!currentModalProductId) return;
    const prod = PRODUCTS.find(p => p.id === currentModalProductId);
    if (!prod) return;
    toggleWishlist(prod.id, prod.name, prod.price, prod.image, btn);
  };

  // Horizontal Scroll Carousel Controls
  window.scrollProductsHorizontal = function (direction) {
    const track = document.getElementById('productsTrack');
    if (!track) return;
    const scrollAmount = 310 * direction;
    track.scrollBy({ left: scrollAmount, behavior: 'smooth' });
  };

  // Newsletter Submit
  window.handleNewsletterSubmit = function (e) {
    e.preventDefault();
    const emailInput = document.getElementById('newsletterEmail');
    if (emailInput && emailInput.value) {
      showToast('Thank you! You have been subscribed to exclusive updates.');
      emailInput.value = '';
    }
  };

  // Toast Notification
  let toastTimer = null;
  function showToast(message) {
    if (!toastNotice) return;
    toastNotice.textContent = message;
    toastNotice.classList.add('show');
    if (toastTimer) clearTimeout(toastTimer);
    toastTimer = setTimeout(() => {
      toastNotice.classList.remove('show');
    }, 3200);
  }

  // ==========================================================================
  // AUTHENTICATION (GOOGLE & REAL PHONE OTP) & PLAY STORE DOWNLOAD LOGIC
  // ==========================================================================

  function escapeHtml(text) {
    if (!text) return '';
    return String(text)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }

  function initAuthSession() {
    try {
      const stored = localStorage.getItem('stylito_user');
      if (stored) {
        const user = JSON.parse(stored);
        updateAuthUI(user);
      }
    } catch (e) {
      console.warn('Error reading stored user session', e);
    }
  }

  function updateAuthUI(user) {
    const greeting = document.getElementById('navUserGreeting');
    const userNameText = document.getElementById('navUserName');
    const navAvatarInitial = document.getElementById('navAvatarInitial');
    const profileBtn = document.getElementById('profileTriggerBtn');
    const navProfileLoginBtn = document.getElementById('navProfileLoginBtn');
    const sheetAuthLoggedOut = document.getElementById('sheetAuthLoggedOut');
    const sheetStatus = document.getElementById('sheetUserStatus');

    if (user && user.name) {
      if (greeting && userNameText) {
        userNameText.textContent = 'Hi, ' + user.name.split(' ')[0];
        greeting.style.display = 'inline-flex';
      }
      if (navAvatarInitial) {
        navAvatarInitial.textContent = (user.name || 'U').charAt(0).toUpperCase();
      }
      // Hide the LOGIN button in header when logged in
      if (navProfileLoginBtn) {
        navProfileLoginBtn.style.display = 'none';
      }
      if (profileBtn) {
        profileBtn.style.display = 'none';
      }
      if (sheetAuthLoggedOut) {
        sheetAuthLoggedOut.style.display = 'none';
      }
      if (sheetStatus) {
        sheetStatus.style.display = 'flex';
        sheetStatus.innerHTML = `
          <div style="display:flex; align-items:center; justify-content:space-between; width:100%; gap:12px;">
            <div style="display:flex; align-items:center; gap:10px; min-width:0;">
              <div style="width:36px; height:36px; border-radius:50%; background:linear-gradient(135deg, #10b981, #059669); color:#fff; display:flex; align-items:center; justify-content:center; font-weight:700; font-size:15px; flex-shrink:0;">
                ${escapeHtml((user.name || 'U').charAt(0).toUpperCase())}
              </div>
              <div style="min-width:0; text-align:left;">
                <div style="font-weight:700; font-size:0.88rem; color:#065f46; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">${escapeHtml(user.name)}</div>
                <div style="font-size:0.75rem; color:#047857; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">${escapeHtml(user.email || user.phone || 'Verified User')}</div>
              </div>
            </div>
            <div style="display:flex; gap:6px; flex-shrink:0;">
              <button type="button" onclick="openUserAccountModal()" style="background:#e0f2fe; border:1px solid #7dd3fc; color:#0369a1; border-radius:6px; padding:6px 10px; font-size:0.78rem; font-weight:600; cursor:pointer;">Change</button>
              <button type="button" onclick="logoutUser()" style="background:#fee2e2; border:1px solid #fca5a5; color:#b91c1c; border-radius:6px; padding:6px 10px; font-size:0.78rem; font-weight:600; cursor:pointer;">Sign Out</button>
            </div>
          </div>
        `;
      }
    } else {
      if (greeting) greeting.style.display = 'none';
      // Show the LOGIN button in header when logged out
      if (navProfileLoginBtn) {
        navProfileLoginBtn.style.display = 'inline-flex';
      }
      if (profileBtn) {
        profileBtn.style.display = 'inline-flex';
      }
      if (sheetAuthLoggedOut) {
        sheetAuthLoggedOut.style.display = 'block';
      }
      if (sheetStatus) {
        sheetStatus.style.display = 'none';
        sheetStatus.innerHTML = '';
      }
    }
  }

  // Auth modals, Google and Phone OTP containers temporarily deleted per user request
  window.openUserAccountModal = () => {};
  window.closeUserAccountModal = () => {};
  window.logoutUser = () => {};
  window.openGoogleAccountPicker = () => {};
  window.closeGoogleAccountPicker = () => {};
  window.triggerGoogleSignInFlow = () => {};
  window.submitCustomGoogleAccount = () => {};
  window.selectGoogleAccount = () => {};
  window.openPhoneOtpModal = () => {};
  window.closePhoneOtpModal = () => {};
  window.sendPhoneOtp = () => {};
  window.verifyPhoneOtp = () => {};
  window.autofillTestOtp = () => {};
  window.resetPhoneStep = () => {};
  window.updateLinkedBadges = () => {};

  // Google Play Store Download Modal & Animation
  let playDownloadTimer = null;

  window.openPlayStoreModal = function () {
    const modal = document.getElementById('playStoreModal');
    const backdrop = document.getElementById('playStoreBackdrop');
    if (modal) modal.classList.add('active');
    if (backdrop) backdrop.classList.add('active');
    document.body.style.overflow = 'hidden';
  };

  window.closePlayStoreModal = function () {
    const modal = document.getElementById('playStoreModal');
    const backdrop = document.getElementById('playStoreBackdrop');
    if (modal) modal.classList.remove('active');
    if (backdrop) backdrop.classList.remove('active');
    document.body.style.overflow = '';
  };

  window.startPlayStoreDownload = function () {
    const installBtn = document.getElementById('btnPlayInstall');
    const progressWrap = document.getElementById('playDownloadProgress');
    const fill = document.getElementById('playProgressBarFill');
    const percentEl = document.getElementById('playProgressPercent');
    const mbEl = document.getElementById('playProgressMb');
    const statusEl = document.getElementById('playProgressStatus');
    const openBtn = document.getElementById('btnPlayOpen');

    if (installBtn) installBtn.style.display = 'none';
    if (progressWrap) progressWrap.style.display = 'block';
    if (openBtn) openBtn.style.display = 'none';

    let progress = 0;
    const totalMb = 24.0;
    if (playDownloadTimer) clearInterval(playDownloadTimer);

    playDownloadTimer = setInterval(() => {
      progress += Math.floor(Math.random() * 8) + 4;
      if (progress >= 100) {
        progress = 100;
        clearInterval(playDownloadTimer);
        if (fill) fill.style.width = '100%';
        if (percentEl) percentEl.textContent = '100%';
        if (mbEl) mbEl.textContent = '24.0 MB / 24.0 MB';
        if (statusEl) statusEl.textContent = 'Installing Stylito App...';

        setTimeout(() => {
          if (progressWrap) progressWrap.style.display = 'none';
          if (openBtn) openBtn.style.display = 'block';
          showToast('Stylito Fashion App installed successfully from Play Store!');
        }, 800);
      } else {
        if (fill) fill.style.width = progress + '%';
        if (percentEl) percentEl.textContent = progress + '%';
        const currentMb = ((progress / 100) * totalMb).toFixed(1);
        if (mbEl) mbEl.textContent = currentMb + ' MB / ' + totalMb + ' MB';
      }
    }, 120);
  };

  window.openInstalledApp = function () {
    showToast('Launching Stylito Android app preview!');
    closePlayStoreModal();
  };

  // ==========================================================================
  // Auth & login modals and containers temporarily deleted per user request
  // ==========================================================================
  window.openStylishAuthModal = () => {};
  window.closeStylishAuthModal = () => {};
  window.switchStylishAuthTab = () => {};
  window.togglePasswordVisibility = () => {};
  window.handleForgotPasswordClick = () => {};
  window.handleStylishLoginSubmit = (e) => { if (e && e.preventDefault) e.preventDefault(); };
  window.handleStylishSignupSubmit = (e) => { if (e && e.preventDefault) e.preventDefault(); };

  // Kickoff on DOM Ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
