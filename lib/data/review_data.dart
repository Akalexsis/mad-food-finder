/*
  Author - Kayla Thornton
  Purpose - Seed review data for testing UI functionality
 */
import '../models/review_model.dart';

final List<Review> sampleReviews = [
  // McDonalds reviews (foodId: 1)
  Review(
    name: 'Sarah Johnson',
    desc: 'Quick service and consistent quality. The fries are always fresh!',
    date: 'Mar 15, 2026',
    foodId: 1,
  ),
  Review(
    name: 'Mike Chen',
    desc: 'Great for a quick bite between classes. Can get crowded during lunch though.',
    date: 'Mar 10, 2026',
    foodId: 1,
  ),
  Review(
    name: 'Emily Rodriguez',
    desc: 'Love their breakfast menu! The hash browns are my favorite.',
    date: 'Feb 28, 2026',
    foodId: 1,
  ),
  Review(
    name: 'David Kim',
    desc: 'Good value for money. The app deals make it even better!',
    date: 'Feb 20, 2026',
    foodId: 1,
  ),

  // Chick-fil-A reviews (foodId: 2)
  Review(
    name: 'Jessica Martinez',
    desc: 'The chicken sandwich is legendary! Always fresh and the service is so friendly.',
    date: 'Mar 18, 2026',
    foodId: 2,
  ),
  Review(
    name: 'Tyler Brown',
    desc: 'Best fast food chain hands down. The waffle fries are perfect every time.',
    date: 'Mar 12, 2026',
    foodId: 2,
  ),
  Review(
    name: 'Amanda White',
    desc: 'Love their lemonade and Chick-fil-A sauce. Always a pleasant experience!',
    date: 'Mar 5, 2026',
    foodId: 2,
  ),
  Review(
    name: 'Chris Johnson',
    desc: 'Super clean restaurant and staff actually cares about customers.',
    date: 'Feb 25, 2026',
    foodId: 2,
  ),

  // Five Guys reviews (foodId: 3)
  Review(
    name: 'Jake Thompson',
    desc: 'Best burgers in town! Love that you can customize with unlimited toppings.',
    date: 'Mar 17, 2026',
    foodId: 3,
  ),
  Review(
    name: 'Rachel Green',
    desc: 'The cajun fries are amazing! A bit pricey but worth every penny.',
    date: 'Mar 8, 2026',
    foodId: 3,
  ),
  Review(
    name: 'Brandon Lee',
    desc: 'Peanuts while you wait is a nice touch. Burgers are always juicy.',
    date: 'Mar 1, 2026',
    foodId: 3,
  ),
  Review(
    name: 'Olivia Davis',
    desc: 'Generous portions! A little messy to eat but that\'s part of the charm.',
    date: 'Feb 22, 2026',
    foodId: 3,
  ),

  // Zaxby's reviews (foodId: 4)
  Review(
    name: 'Marcus Williams',
    desc: 'The Zax sauce is incredible! Chicken fingers are always crispy and hot.',
    date: 'Mar 16, 2026',
    foodId: 4,
  ),
  Review(
    name: 'Sophia Taylor',
    desc: 'Great buffalo wings and Texas toast. Perfect for game day.',
    date: 'Mar 11, 2026',
    foodId: 4,
  ),
  Review(
    name: 'Ethan Moore',
    desc: 'Salads are actually really good here. The fried chicken salad is a winner.',
    date: 'Mar 4, 2026',
    foodId: 4,
  ),
  Review(
    name: 'Isabella Garcia',
    desc: 'Kickin\' chicken sandwich has the perfect amount of spice!',
    date: 'Feb 27, 2026',
    foodId: 4,
  ),

  // Wingstop reviews (foodId: 5)
  Review(
    name: 'Mia Robinson',
    desc: 'Best wings in town! Lemon pepper and atomic are my go-to flavors.',
    date: 'Mar 14, 2026',
    foodId: 5,
  ),
  Review(
    name: 'Liam Wilson',
    desc: 'The fries are perfectly seasoned. Great for takeout and delivery.',
    date: 'Mar 9, 2026',
    foodId: 5,
  ),
  Review(
    name: 'Ava Martinez',
    desc: 'So many sauce options! Always cooked fresh and crispy.',
    date: 'Mar 2, 2026',
    foodId: 5,
  ),
  Review(
    name: 'William Jackson',
    desc: 'Good spot to watch the game. Ranch and blue cheese dips are top tier.',
    date: 'Feb 24, 2026',
    foodId: 5,
  ),

  // Olive Garden reviews (foodId: 6)
  Review(
    name: 'Emma Thompson',
    desc: 'Never ending pasta bowl is a fantastic deal! The breadsticks are addicting.',
    date: 'Mar 19, 2026',
    foodId: 6,
  ),
  Review(
    name: 'Noah Anderson',
    desc: 'Great family restaurant. The chicken alfredo is always creamy and delicious.',
    date: 'Mar 13, 2026',
    foodId: 6,
  ),
  Review(
    name: 'Sophia Wilson',
    desc: 'Perfect for date night. Love the salad and breadsticks combo!',
    date: 'Mar 6, 2026',
    foodId: 6,
  ),
  Review(
    name: 'James Brown',
    desc: 'Portions are huge! Definitely worth the price for Italian cravings.',
    date: 'Feb 28, 2026',
    foodId: 6,
  ),

  // Carrabba's Italian Grill reviews (foodId: 7)
  Review(
    name: 'Olivia Martinez',
    desc: 'Authentic Italian food. The chicken marsala is amazing!',
    date: 'Mar 20, 2026',
    foodId: 7,
  ),
  Review(
    name: 'Lucas Garcia',
    desc: 'Great atmosphere for a nice dinner. Service is always top notch.',
    date: 'Mar 14, 2026',
    foodId: 7,
  ),
  Review(
    name: 'Mia Johnson',
    desc: 'The calamari appetizer is a must-try. Perfectly cooked every time.',
    date: 'Mar 7, 2026',
    foodId: 7,
  ),
  Review(
    name: 'Ethan Davis',
    desc: 'A bit pricey but quality ingredients. Their pasta is always fresh.',
    date: 'Feb 26, 2026',
    foodId: 7,
  ),

  // Fazoli's reviews (foodId: 8)
  Review(
    name: 'Isabella Rodriguez',
    desc: 'Quick and affordable Italian fix. Love the unlimited breadsticks!',
    date: 'Mar 18, 2026',
    foodId: 8,
  ),
  Review(
    name: 'Alexander White',
    desc: 'Great value for students. The baked ziti is my favorite.',
    date: 'Mar 11, 2026',
    foodId: 8,
  ),
  Review(
    name: 'Charlotte Thomas',
    desc: 'Fast food Italian done right. Pizza slices are surprisingly good.',
    date: 'Mar 4, 2026',
    foodId: 8,
  ),
  Review(
    name: 'Benjamin Anderson',
    desc: 'Perfect for when you want Italian but don\'t want to spend a lot.',
    date: 'Feb 25, 2026',
    foodId: 8,
  ),

  // Chipotle reviews (foodId: 9)
  Review(
    name: 'Amelia Taylor',
    desc: 'My go-to for quick Mexican food. The burrito bowls are massive!',
    date: 'Mar 19, 2026',
    foodId: 9,
  ),
  Review(
    name: 'Daniel Moore',
    desc: 'Love that you can customize everything. The guacamole is extra but worth it.',
    date: 'Mar 12, 2026',
    foodId: 9,
  ),
  Review(
    name: 'Evelyn Jackson',
    desc: 'Fresh ingredients and fast service. Always consistent quality.',
    date: 'Mar 5, 2026',
    foodId: 9,
  ),
  Review(
    name: 'Michael Lee',
    desc: 'The barbacoa is so flavorful. Great for meal prep too!',
    date: 'Feb 27, 2026',
    foodId: 9,
  ),

  // Taco Bell reviews (foodId: 10)
  Review(
    name: 'Sofia Hernandez',
    desc: 'Perfect late night food! The cravings box is such a good deal.',
    date: 'Mar 17, 2026',
    foodId: 10,
  ),
  Review(
    name: 'Matthew Young',
    desc: 'Doritos Locos Tacos changed my life. Addicted to the Baja Blast!',
    date: 'Mar 10, 2026',
    foodId: 10,
  ),
  Review(
    name: 'Victoria King',
    desc: 'Cheap eats that hit the spot. The crunchwrap supreme is iconic.',
    date: 'Mar 3, 2026',
    foodId: 10,
  ),
  Review(
    name: 'Joseph Wright',
    desc: 'Open late when nothing else is. Perfect for study breaks at 1am!',
    date: 'Feb 23, 2026',
    foodId: 10,
  ),

  // Moe's Southwest Grill reviews (foodId: 11)
  Review(
    name: 'Grace Scott',
    desc: 'Love the "Welcome to Moe\'s!" greeting. The queso is the best!',
    date: 'Mar 16, 2026',
    foodId: 11,
  ),
  Review(
    name: 'Andrew Green',
    desc: 'Free chips and salsa with every meal. Stacked burritos are huge!',
    date: 'Mar 9, 2026',
    foodId: 11,
  ),
  Review(
    name: 'Chloe Adams',
    desc: 'Great vegetarian options. The tofu is actually seasoned well.',
    date: 'Mar 2, 2026',
    foodId: 11,
  ),
  Review(
    name: 'David Baker',
    desc: 'Quick lunch spot. Love that they have multiple salsa options.',
    date: 'Feb 24, 2026',
    foodId: 11,
  ),

  // Qdoba reviews (foodId: 12)
  Review(
    name: 'Natalie Nelson',
    desc: 'Free queso is a game changer! Love that they don\'t charge extra.',
    date: 'Mar 18, 2026',
    foodId: 12,
  ),
  Review(
    name: 'Christopher Hill',
    desc: 'Great alternative to Chipotle. The 3-cheese queso is amazing.',
    date: 'Mar 11, 2026',
    foodId: 12,
  ),
  Review(
    name: 'Madison Ramirez',
    desc: 'Loaded nachos are perfect for sharing. Good portion sizes.',
    date: 'Mar 4, 2026',
    foodId: 12,
  ),
  Review(
    name: 'Joshua Roberts',
    desc: 'Fresh ingredients and friendly staff. My go-to for Mexican bowls.',
    date: 'Feb 26, 2026',
    foodId: 12,
  ),

  // Panda Express reviews (foodId: 13)
  Review(
    name: 'Abigail Mitchell',
    desc: 'Orange chicken is a classic! Always crispy and saucy.',
    date: 'Mar 20, 2026',
    foodId: 13,
  ),
  Review(
    name: 'Ryan Phillips',
    desc: 'Great for quick Chinese food. The Beijing beef is my favorite.',
    date: 'Mar 13, 2026',
    foodId: 13,
  ),
  Review(
    name: 'Ella Campbell',
    desc: 'Love the bowl deal. Chow mein and orange chicken every time!',
    date: 'Mar 6, 2026',
    foodId: 13,
  ),
  Review(
    name: 'Nathan Stewart',
    desc: 'Fast service and consistent quality. Honey walnut shrimp is worth the splurge.',
    date: 'Feb 27, 2026',
    foodId: 13,
  ),

  // Teriyaki Madness reviews (foodId: 14)
  Review(
    name: 'Avery Turner',
    desc: 'Best teriyaki in town! The spicy chicken bowl is so flavorful.',
    date: 'Mar 19, 2026',
    foodId: 14,
  ),
  Review(
    name: 'Hannah Mitchell',
    desc: 'Fresh veggies and perfectly cooked meat. The sauce is amazing!',
    date: 'Mar 12, 2026',
    foodId: 14,
  ),
  Review(
    name: 'Samuel Cooper',
    desc: 'Great portion sizes for the price. Love the edamame as a side.',
    date: 'Mar 5, 2026',
    foodId: 14,
  ),
  Review(
    name: 'Lily Richardson',
    desc: 'Quick and healthy option. The grilled chicken bowl is my go-to.',
    date: 'Feb 26, 2026',
    foodId: 14,
  ),

  // Ginger Kitchen reviews (foodId: 15)
  Review(
    name: 'Zoey Bailey',
    desc: 'Hidden gem! The ginger chicken is incredible. Fresh ingredients.',
    date: 'Mar 18, 2026',
    foodId: 15,
  ),
  Review(
    name: 'Dylan Rivera',
    desc: 'Great local spot. The pad thai is surprisingly authentic.',
    date: 'Mar 11, 2026',
    foodId: 15,
  ),
  Review(
    name: 'Leah Wood',
    desc: 'Friendly staff and generous portions. Love the vegetable spring rolls.',
    date: 'Mar 4, 2026',
    foodId: 15,
  ),
  Review(
    name: 'Caleb Watson',
    desc: 'Solid Asian fusion spot. The curry dishes are flavorful and filling.',
    date: 'Feb 25, 2026',
    foodId: 15,
  ),
];