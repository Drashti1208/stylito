import '../core/constants/app_assets.dart';

class ProductModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final double price;
  final double originalPrice;
  final int discountPercent;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final List<String> galleryImages;
  final List<String> sizes;
  final String category;
  final String deliveryTime;
  final bool isDealOfTheDay;
  final bool isTrending;
  final bool isNewArrival;

  const ProductModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    this.galleryImages = const [],
    this.sizes = const ['6 UK', '7 UK', '8 UK', '9 UK', '10 UK'],
    required this.category,
    this.deliveryTime = 'Delivery in 1 within Hour',
    this.isDealOfTheDay = false,
    this.isTrending = false,
    this.isNewArrival = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['original_price'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          0.0,
      discountPercent: (json['discount_percent'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      imageUrl: json['image_url']?.toString() ?? '',
      galleryImages: json['gallery_images'] != null
          ? List<String>.from(json['gallery_images'])
          : [],
      sizes: json['sizes'] != null
          ? List<String>.from(json['sizes'])
          : const ['6 UK', '7 UK', '8 UK', '9 UK', '10 UK'],
      category: json['category']?.toString() ?? 'fashion',
      deliveryTime: json['delivery_time']?.toString() ?? 'Delivery in 1 within Hour',
      isDealOfTheDay:
          json['is_deal_of_the_day'] == true || json['is_deal_of_the_day'] == 1,
      isTrending: json['is_trending'] == true || json['is_trending'] == 1,
      isNewArrival:
          json['is_new_arrival'] == true || json['is_new_arrival'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'price': price,
      'original_price': originalPrice,
      'discount_percent': discountPercent,
      'rating': rating,
      'review_count': reviewCount,
      'image_url': imageUrl,
      'gallery_images': galleryImages,
      'sizes': sizes,
      'category': category,
      'delivery_time': deliveryTime,
      'is_deal_of_the_day': isDealOfTheDay,
      'is_trending': isTrending,
      'is_new_arrival': isNewArrival,
    };
  }

  static List<ProductModel> get sampleProducts => [
    // 1. Women Printed Kurta (Deal of the Day Card 1)
    const ProductModel(
      id: 'women_printed_kurta',
      title: 'Women Printed Kurta',
      subtitle: 'Neque porro quisquam est qui dolorem ipsum quia',
      description: 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...',
      price: 1500.00,
      originalPrice: 2499.00,
      discountPercent: 40,
      rating: 4.5,
      reviewCount: 56890,
      imageUrl: AppAssets.productKurta,
      galleryImages: [AppAssets.productKurta, AppAssets.womensCasual],
      sizes: ['S', 'M', 'L', 'XL'],
      category: 'womens',
      isDealOfTheDay: true,
      isTrending: true,
    ),

    // 2. HRX by Hrithik Roshan (Deal of the Day Card 2)
    const ProductModel(
      id: 'hrx_sneakers',
      title: 'HRX by Hrithik Roshan',
      subtitle: 'Neque porro quisquam est qui dolorem ipsum quia',
      description: 'Court-ready lightweight sneakers designed for active running, agility, and streetwear performance.',
      price: 2499.00,
      originalPrice: 4999.00,
      discountPercent: 50,
      rating: 4.8,
      reviewCount: 344567,
      imageUrl: AppAssets.productHrx,
      galleryImages: [AppAssets.productHrx, AppAssets.productNikeShop],
      sizes: ['6 UK', '7 UK', '8 UK', '9 UK', '10 UK'],
      category: 'mens',
      isDealOfTheDay: true,
      isTrending: true,
    ),

    // 3. IWC Schaffhausen 2021 Pilot's Watch (Trending Col 1 in Figma image)
    const ProductModel(
      id: 'iwc_watch',
      title: 'IWC Schaffhausen',
      subtitle: "2021 Pilot's Watch \"SIHH 2019\" 44mm",
      description: "Precision engineered pilot's chronometer with rotating bezel, dual timezone indicator, and olive NATO strap.",
      price: 650.00,
      originalPrice: 1599.00,
      discountPercent: 60,
      rating: 4.8,
      reviewCount: 28450,
      imageUrl: AppAssets.productCamera,
      category: 'mens',
      isTrending: true,
      isNewArrival: true,
    ),

    // 4. Labbin White Sneakers (Trending Col 2 in Figma image)
    const ProductModel(
      id: 'labbin_white_sneakers',
      title: 'Labbin White Sneakers',
      subtitle: 'For Men and Female Casual Daily Streetwear',
      description: 'Clean monochrome triple-white chunky platform sneakers engineered for cloud comfort and durability.',
      price: 650.00,
      originalPrice: 1250.00,
      discountPercent: 70,
      rating: 4.6,
      reviewCount: 19430,
      imageUrl: AppAssets.productBrownLoafers,
      sizes: ['6 UK', '7 UK', '8 UK', '9 UK', '10 UK'],
      category: 'mens',
      isTrending: true,
      isNewArrival: true,
    ),

    // 5. Black Winter...
    const ProductModel(
      id: 'black_winter_jacket',
      title: 'Black Winter...',
      subtitle: 'Autumn And Winter Casual cotton-padded jacket...',
      description: 'Heavyweight cozy cotton hoodie designed with modern streetwear graphics and insulated lining.',
      price: 499.00,
      originalPrice: 999.00,
      discountPercent: 50,
      rating: 4.0,
      reviewCount: 6890,
      imageUrl: AppAssets.productBlackWinter,
      sizes: ['M', 'L', 'XL'],
      category: 'mens',
      isTrending: true,
    ),

    // 6. Mens Starry
    const ProductModel(
      id: 'mens_starry_shirt',
      title: 'Mens Starry',
      subtitle: 'Mens Starry Sky Printed Shirt 100% Cotton Fabric',
      description: 'Abstract starry sky print casual short-sleeve shirt crafted from 100% pure breathable cotton.',
      price: 399.00,
      originalPrice: 799.00,
      discountPercent: 50,
      rating: 4.5,
      reviewCount: 152344,
      imageUrl: AppAssets.productMensStarry,
      sizes: ['S', 'M', 'L', 'XL'],
      category: 'mens',
      isTrending: true,
    ),

    // 5. Black Dress (Trending Col 1 Row 2)
    const ProductModel(
      id: 'black_dress',
      title: 'Black Dress',
      subtitle: 'Solid Black Dress for Women, Sexy Chain Shorts Ladi...',
      description: 'Sensational black bodycon evening dress featuring delicate chain straps and figure-hugging stretch fabric.',
      price: 2000.00,
      originalPrice: 3500.00,
      discountPercent: 43,
      rating: 4.5,
      reviewCount: 523456,
      imageUrl: AppAssets.productBlackDress,
      sizes: ['XS', 'S', 'M', 'L'],
      category: 'womens',
      isTrending: true,
    ),

    // 6. Pink Embroide... (Trending Col 2 Row 2)
    const ProductModel(
      id: 'pink_embroidered',
      title: 'Pink Embroide...',
      subtitle: 'EARTHEN Rose Pink Embroidered Tiered Max...',
      description: 'Tiered flowy rose pink maxi dress with artisanal neckline embroidery and breezy tiered skirt.',
      price: 1900.00,
      originalPrice: 2800.00,
      discountPercent: 32,
      rating: 4.5,
      reviewCount: 45678,
      imageUrl: AppAssets.productPinkDress,
      sizes: ['S', 'M', 'L', 'XL'],
      category: 'womens',
      isTrending: true,
    ),

    // 7. Flare Dress (Trending Col 1 Row 3)
    const ProductModel(
      id: 'flare_dress',
      title: 'Flare Dress',
      subtitle: 'Antheaa Black & Rust Orange Floral Print Tiered Midi F...',
      description: 'Classic fit and flare tiered floral midi dress in deep black and rust orange tones.',
      price: 1990.00,
      originalPrice: 2999.00,
      discountPercent: 33,
      rating: 4.5,
      reviewCount: 335566,
      imageUrl: AppAssets.productFlareDress,
      sizes: ['S', 'M', 'L'],
      category: 'womens',
      isTrending: true,
    ),

    // 8. denim dress (Trending Col 2 Row 3)
    const ProductModel(
      id: 'denim_dress',
      title: 'denim dress',
      subtitle: 'Blue cotton denim dress Look 2 Printed cotton dr...',
      description: 'Casual blue wash denim dress with button-front closure and functional twin pockets.',
      price: 999.00,
      originalPrice: 1999.00,
      discountPercent: 50,
      rating: 4.5,
      reviewCount: 27344,
      imageUrl: AppAssets.productDenimDress,
      sizes: ['S', 'M', 'L'],
      category: 'womens',
      isTrending: true,
    ),

    // 9. Nike Sneakers (Shop page hero)
    const ProductModel(
      id: 'nike_sneakers_1',
      title: 'Nike Sneakers',
      subtitle: "Vision Alta Men's Shoes (All Colours)",
      description:
          "Perhaps the most iconic sneaker of all-time, this original 'Chicago' colorway is the cornerstone to any sneaker collection. Made famous in 1985 by Michael Jordan, the shoe has stood the test of time, becoming the most famous colorway of the Air Jordan 1.",
      price: 2999.00,
      originalPrice: 5999.00,
      discountPercent: 50,
      rating: 4.5,
      reviewCount: 56890,
      imageUrl: AppAssets.productNikeShop,
      galleryImages: [
        AppAssets.productNikeShop,
        AppAssets.productHrx,
        AppAssets.nikeSneakers,
      ],
      sizes: ['6 UK', '7 UK', '8 UK', '9 UK', '10 UK'],
      category: 'mens',
    ),

    // 10. Jordan Stay
    const ProductModel(
      id: 'jordan_stay',
      title: 'Jordan Stay',
      subtitle: 'Nike Air Jordan Retro High Top Sneaker',
      description: 'Iconic heritage court sneaker with premium leather accents.',
      price: 4999.00,
      originalPrice: 8999.00,
      discountPercent: 44,
      rating: 4.9,
      reviewCount: 8920,
      imageUrl: AppAssets.productJordanThumb,
      category: 'mens',
    ),

    // 11. Sony PS4
    const ProductModel(
      id: 'sony_ps4',
      title: 'Sony PS4',
      subtitle: 'Sony PlayStation 4 1TB Gaming Console with DualShock',
      description: 'Experience blockbuster entertainment with immersive HDR gaming and DualShock controller.',
      price: 29999.00,
      originalPrice: 34999.00,
      discountPercent: 14,
      rating: 4.9,
      reviewCount: 14500,
      imageUrl: AppAssets.productPs4,
      category: 'electronics',
    ),

    // 12. Black Jacket
    const ProductModel(
      id: 'black_leather_jacket',
      title: 'Black Jacket 12..',
      subtitle: 'Mens Biker Slim Fit Faux Leather Jacket',
      description: 'Sleek asymmetric zip biker jacket crafted from supple faux leather with quilted shoulders.',
      price: 2499.00,
      originalPrice: 4999.00,
      discountPercent: 50,
      rating: 4.6,
      reviewCount: 2310,
      imageUrl: AppAssets.productLeatherJacket,
      sizes: ['M', 'L', 'XL'],
      category: 'mens',
    ),

    // 13. D7200 Digital Camera
    const ProductModel(
      id: 'd7200_camera',
      title: 'D7200 Digital C...',
      subtitle: 'Nikon D7200 Digital SLR with 18-140mm VR Kit Lens',
      description: 'Versatile 24.2 MP DX-format sensor with EXPEED 4 processing engine and 51-point AF system.',
      price: 35099.00,
      originalPrice: 48999.00,
      discountPercent: 28,
      rating: 4.7,
      reviewCount: 980,
      imageUrl: AppAssets.productCamera,
      category: 'electronics',
    ),

    // 14. men's & boys loafers
    const ProductModel(
      id: 'mens_brown_loafers',
      title: "men's & boys s...",
      subtitle: 'Casual Tan Brown Penny Driving Shoes Loafers',
      description: 'Slip-on handcrafted tan leather moccasins with durable traction rubber driving soles.',
      price: 999.00,
      originalPrice: 1999.00,
      discountPercent: 50,
      rating: 4.4,
      reviewCount: 1720,
      imageUrl: AppAssets.productBrownLoafers,
      sizes: ['6 UK', '7 UK', '8 UK', '9 UK', '10 UK'],
      category: 'mens',
    ),

    // 15. Classic Suede Loafers (New Added Product)
    const ProductModel(
      id: 'classic_suede_loafers',
      title: 'Classic Suede Loafers',
      subtitle: 'Premium Tan Brown Handcrafted Driving Shoes',
      description: 'Handcrafted luxury Italian tan suede slip-on driving loafers with cushioned memory foam insole and non-slip rubber outsoles. Perfect for casual, smart-casual, and formal occasions.',
      price: 1499.00,
      originalPrice: 2999.00,
      discountPercent: 50,
      rating: 4.8,
      reviewCount: 4210,
      imageUrl: 'assets/images/shoes_crisp.png',
      galleryImages: [
        'assets/images/shoes_crisp.png',
        AppAssets.productBrownLoafers,
      ],
      sizes: ['6 UK', '7 UK', '8 UK', '9 UK', '10 UK'],
      category: 'mens',
      deliveryTime: 'Delivery within 2 Hours',
      isTrending: true,
      isNewArrival: true,
    ),

    // 16. Luxury Stiletto Heels (New Added Product)
    const ProductModel(
      id: 'luxury_stiletto_heels',
      title: 'Luxury Stiletto Heels',
      subtitle: 'White Patent Pointed-Toe Ankle Strap Pumps',
      description: 'Ultra-glamorous pointed-toe white patent leather stilettos featuring delicate buckle ankle straps and high-gloss designer finish. Ideal for weddings, parties, and evening galas.',
      price: 2199.00,
      originalPrice: 4499.00,
      discountPercent: 51,
      rating: 4.9,
      reviewCount: 11840,
      imageUrl: AppAssets.heelsBanner,
      galleryImages: [
        AppAssets.heelsBanner,
        AppAssets.productFlareDress,
      ],
      sizes: ['4 UK', '5 UK', '6 UK', '7 UK', '8 UK'],
      category: 'womens',
      deliveryTime: 'Free Express Delivery in 1 Day',
      isTrending: true,
      isDealOfTheDay: true,
      isNewArrival: true,
    ),

    // 17. Floral Summer Bohemian Dress (New Added Product)
    const ProductModel(
      id: 'floral_summer_boho_dress',
      title: 'Boho Floral Dress',
      subtitle: 'Botanical Garden Printed Deep V-Neck Maxi Dress',
      description: 'Breezy romantic floral maxi dress crafted in flowy georgette chiffon with long bishop sleeves and flattering empire waistline.',
      price: 1799.00,
      originalPrice: 3299.00,
      discountPercent: 45,
      rating: 4.7,
      reviewCount: 9630,
      imageUrl: AppAssets.productFlareDress,
      galleryImages: [
        AppAssets.productFlareDress,
        AppAssets.productPinkDress,
      ],
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      category: 'womens',
      deliveryTime: 'Delivery in 1 Day',
      isTrending: true,
      isNewArrival: true,
    ),

    // 18. MARS High Coverage Foundation SPF 50
    const ProductModel(
      id: 'beauty_mars_foundation',
      title: 'MARS High Coverage Foundation',
      subtitle: 'Liquid Matte Finish Foundation SPF 50 PA++++',
      description: 'Ultra-lightweight yet full-coverage liquid matte foundation enriched with SPF 50 PA++++ sun defense. Blurs imperfections, evens tone, and controls excess sebum all day without feeling cakey or settling into fine lines.',
      price: 349.00,
      originalPrice: 499.00,
      discountPercent: 30,
      rating: 4.8,
      reviewCount: 14280,
      imageUrl: AppAssets.beautyMarsFoundation,
      galleryImages: [
        AppAssets.beautyMarsFoundation,
        AppAssets.beautyBerryConcealer,
      ],
      sizes: ['Ivory Glow', 'Warm Beige', 'Natural Sand', 'Golden Honey'],
      category: 'beauty',
      deliveryTime: 'Express Delivery in 24 Hours',
      isTrending: true,
      isDealOfTheDay: true,
      isNewArrival: true,
    ),

    // 19. INSIGHT Matte Lipstick
    const ProductModel(
      id: 'beauty_insight_lipstick',
      title: 'INSIGHT Matte Lipstick',
      subtitle: 'Twist to Open Ultra-Pigmented Velvet Finish',
      description: 'Luxe twist-to-open velvet matte lipstick with rich pigment concentration. Non-drying hydrating formula infused with antioxidants and vitamin E for comfortable 12-hour wear without flaking.',
      price: 180.00,
      originalPrice: 240.00,
      discountPercent: 25,
      rating: 4.7,
      reviewCount: 28450,
      imageUrl: AppAssets.beautyInsightLipstick,
      galleryImages: [
        AppAssets.beautyInsightLipstick,
        AppAssets.beautyMarsEyeshadow,
      ],
      sizes: ['Berry Crush', 'Mocha Nude', 'Ruby Velvet', 'Chili Sunset'],
      category: 'beauty',
      deliveryTime: 'Delivery in 2 Days',
      isTrending: true,
      isDealOfTheDay: true,
    ),

    // 20. MARS 16-Pan Eyeshadow Palette
    const ProductModel(
      id: 'beauty_mars_eyeshadow',
      title: 'MARS Eyeshadow Palette',
      subtitle: '16-Shade MesmerEyes Shimmer & Matte Palette',
      description: 'Exquisite 16-shade compact eyeshadow palette featuring buttery mattes, intense foiled metallics, and sparkling glitters. Effortless blendability and crease-proof pigmentation for soft day looks to dramatic night smokey eyes.',
      price: 299.00,
      originalPrice: 449.00,
      discountPercent: 33,
      rating: 4.9,
      reviewCount: 19630,
      imageUrl: AppAssets.beautyMarsEyeshadow,
      galleryImages: [
        AppAssets.beautyMarsEyeshadow,
        AppAssets.beautyKevynEyeliner,
      ],
      sizes: ['16 Shades Palette', 'Pro Makeup Kit'],
      category: 'beauty',
      deliveryTime: 'Delivery in 1 Day',
      isTrending: true,
      isNewArrival: true,
    ),

    // 21. KEVYN AUCOIN The Precision Eye Definer
    const ProductModel(
      id: 'beauty_kevyn_eyeliner',
      title: 'KEVYN AUCOIN Eye Definer',
      subtitle: 'The Precision Eye Definer & Waterproof Kajal',
      description: 'Professional-grade mechanical eyeliner pencil delivering jet-black waterproof pigmentation. Glides on like silk with zero tugging, featuring a built-in precision sharpener and blending tip for effortless winged lines.',
      price: 899.00,
      originalPrice: 1499.00,
      discountPercent: 40,
      rating: 4.8,
      reviewCount: 8920,
      imageUrl: AppAssets.beautyKevynEyeliner,
      galleryImages: [
        AppAssets.beautyKevynEyeliner,
        AppAssets.beautyMarsEyeshadow,
      ],
      sizes: ['Carbon Black', 'Smokey Charcoal'],
      category: 'beauty',
      deliveryTime: 'Delivery in 1 Day',
      isTrending: true,
    ),

    // 22. BEAUTY BERRY HD Liquid Concealer
    const ProductModel(
      id: 'beauty_berry_concealer',
      title: 'Beauty Berry HD Concealer',
      subtitle: 'High Definition Liquid Flawless Coverage',
      description: 'Breathable HD liquid concealer designed for maximum under-eye brightness and total spot correction. Lightweight, transfer-resistant, and non-creasing with a cushy doe-foot applicator for seamless blending.',
      price: 220.00,
      originalPrice: 350.00,
      discountPercent: 37,
      rating: 4.6,
      reviewCount: 11520,
      imageUrl: AppAssets.beautyBerryConcealer,
      galleryImages: [
        AppAssets.beautyBerryConcealer,
        AppAssets.beautyMarsFoundation,
      ],
      sizes: ['Light Porcelain', 'Medium Warm', 'Deep Almond'],
      category: 'beauty',
      deliveryTime: 'Delivery in 2 Days',
      isTrending: true,
      isNewArrival: true,
    ),

    // 23. Girls Blue Damask Co-ord Set
    const ProductModel(
      id: 'kids_blue_damask_set',
      title: 'Girls Damask Co-ord Set',
      subtitle: 'Vintage Floral Porcelain Print Halter Top & Shorts',
      description: 'Charming 2-piece summer outfit featuring a Mediterranean blue and white damask porcelain print. Includes a chic high-neck halter top with keyhole back and comfy elasticated flare shorts in breathable cotton-linen blend.',
      price: 799.00,
      originalPrice: 1299.00,
      discountPercent: 38,
      rating: 4.8,
      reviewCount: 3840,
      imageUrl: AppAssets.kidsBlueDamaskSet,
      galleryImages: [
        AppAssets.kidsBlueDamaskSet,
        AppAssets.kidsHeartsTshirtSet,
      ],
      sizes: ['2-3Y', '3-4Y', '4-5Y', '5-6Y', '7-8Y'],
      category: 'kids',
      deliveryTime: 'Delivery in 2 Days',
      isTrending: true,
      isDealOfTheDay: true,
      isNewArrival: true,
    ),

    // 24. Toddler Heart Graphic Tees
    const ProductModel(
      id: 'kids_hearts_tshirt_set',
      title: 'Toddler Heart Graphic Tees',
      subtitle: 'Mama’s Girl & Leopard Heart 3-Pack Tops',
      description: 'Adorable pack of ultra-soft 100% combed cotton t-shirts with warm earthy tones, cute leopard heart illustrations, and "Mama’s Girl" slogan. Gentle on delicate skin with tagless neckline and durable stretch.',
      price: 649.00,
      originalPrice: 999.00,
      discountPercent: 35,
      rating: 4.9,
      reviewCount: 5120,
      imageUrl: AppAssets.kidsHeartsTshirtSet,
      galleryImages: [
        AppAssets.kidsHeartsTshirtSet,
        AppAssets.kidsBlueDamaskSet,
      ],
      sizes: ['1-2Y', '2-3Y', '3-4Y', '4-5Y'],
      category: 'kids',
      deliveryTime: 'Delivery in 1 Day',
      isTrending: true,
      isNewArrival: true,
    ),

    // 25. Cute Panda Portable Mini Fan
    const ProductModel(
      id: 'kids_panda_mini_fan',
      title: 'Cute Panda Pocket Cooler',
      subtitle: 'Rechargeable Mini Mist Fan with Lanyard',
      description: 'Ultra-cute pocket-sized portable panda cooling fan and gentle mist sprayer with safety blades. USB rechargeable with convenient wrist lanyard, perfect for kids outdoor play, school picnics, and summer trips.',
      price: 399.00,
      originalPrice: 599.00,
      discountPercent: 33,
      rating: 4.7,
      reviewCount: 4290,
      imageUrl: AppAssets.kidsPandaMiniFan,
      galleryImages: [
        AppAssets.kidsPandaMiniFan,
        AppAssets.kidsRoundSunglasses,
      ],
      sizes: ['Panda White', 'Cute Edition'],
      category: 'kids',
      deliveryTime: 'Delivery in 2 Days',
      isTrending: true,
    ),

    // 26. Unicorn Magic Kids Trolley Set
    const ProductModel(
      id: 'kids_unicorn_luggage',
      title: 'Unicorn Kids Trolley Set',
      subtitle: '2-Piece Spinner Suitcase with Vanity Case',
      description: 'Dreamy pink Unicorn Magic travel set including an 18-inch 360° spinner wheel trolley suitcase and an 11-inch matching shoulder vanity case. Waterproof, scratch-resistant ABS hard shell with telescopic push-button handle.',
      price: 2499.00,
      originalPrice: 3999.00,
      discountPercent: 37,
      rating: 4.9,
      reviewCount: 6830,
      imageUrl: AppAssets.kidsUnicornLuggage,
      galleryImages: [
        AppAssets.kidsUnicornLuggage,
        AppAssets.kidsBlueDamaskSet,
      ],
      sizes: ['18" Trolley + 11" Vanity Set', 'Standard Kids Size'],
      category: 'kids',
      deliveryTime: 'Delivery in 3 Days',
      isTrending: true,
      isDealOfTheDay: true,
      isNewArrival: true,
    ),

    // 27. Retro Round Kids Sunglasses
    const ProductModel(
      id: 'kids_round_sunglasses',
      title: 'Retro Round Kids Sunglasses',
      subtitle: 'FIRST LENS UV400 Flexible Matte Black Shades',
      description: 'Trendy retro circular matte black sunglasses with UV400 polarized eye protection. Crafted from bendable, unbreakable kid-friendly silicone-TPE frame that is lightweight and shock-proof.',
      price: 349.00,
      originalPrice: 499.00,
      discountPercent: 30,
      rating: 4.8,
      reviewCount: 2970,
      imageUrl: AppAssets.kidsRoundSunglasses,
      galleryImages: [
        AppAssets.kidsRoundSunglasses,
        AppAssets.kidsPandaMiniFan,
      ],
      sizes: ['Universal Fit (Age 2-8Y)'],
      category: 'kids',
      deliveryTime: 'Delivery in 1 Day',
      isTrending: true,
    ),
  ];

  static List<ProductModel> get beautyProducts =>
      sampleProducts.where((p) => p.category == 'beauty').toList();

  static List<ProductModel> get kidsProducts =>
      sampleProducts.where((p) => p.category == 'kids').toList();

  static List<ProductModel> get womensProducts =>
      sampleProducts.where((p) => p.category == 'womens').toList();

  static List<ProductModel> get mensProducts =>
      sampleProducts.where((p) => p.category == 'mens').toList();

  static List<ProductModel> get fashionProducts =>
      sampleProducts.where((p) => p.category == 'womens' || p.category == 'mens' || p.category == 'fashion').toList();
}
