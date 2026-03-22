/*
  Author - Kayla Thornton
  Purpose - Seed review data for testing UI functionality
 */
import '../models/review_model.dart';

final List<Review> sampleReviews = [
  // McDonald's reviews (foodId: 1)
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

  // Gustos reviews (foodId: 2)
  Review(
    name: 'Jessica Martinez',
    desc: 'Amazing tacos! The al pastor is to die for. A bit pricey but worth it.',
    date: 'Mar 18, 2026',
    foodId: 2,
  ),
  Review(
    name: 'Tyler Brown',
    desc: 'Best Mexican food near campus. The guacamole is fresh and delicious!',
    date: 'Mar 12, 2026',
    foodId: 2,
  ),
  Review(
    name: 'Amanda White',
    desc: 'Great atmosphere and friendly staff. Try the churros for dessert!',
    date: 'Mar 5, 2026',
    foodId: 2,
  ),
  Review(
    name: 'Chris Johnson',
    desc: 'Portions are generous! Can easily share a meal. Highly recommend.',
    date: 'Feb 25, 2026',
    foodId: 2,
  ),
  Review(
    name: 'Lisa Park',
    desc: 'The salsa bar is incredible. So many options! A must-try.',
    date: 'Feb 15, 2026',
    foodId: 2,
  ),

  // Moe's reviews (foodId: 3)
  Review(
    name: 'Jake Thompson',
    desc: 'Love the "Welcome to Moe\'s!" greeting. Burritos are huge and filling.',
    date: 'Mar 17, 2026',
    foodId: 3,
  ),
  Review(
    name: 'Rachel Green',
    desc: 'Free chips and salsa with every order! The queso is addictive.',
    date: 'Mar 8, 2026',
    foodId: 3,
  ),
  Review(
    name: 'Brandon Lee',
    desc: 'Quick service during busy lunch hours. Great for takeout.',
    date: 'Mar 1, 2026',
    foodId: 3,
  ),
  Review(
    name: 'Olivia Davis',
    desc: 'Customize everything the way you want. Vegetarian options are solid.',
    date: 'Feb 22, 2026',
    foodId: 3,
  ),

  // Hungry AF reviews (foodId: 4)
  Review(
    name: 'Marcus Williams',
    desc: 'Epic burgers! The bacon cheeseburger is massive. Come hungry!',
    date: 'Mar 16, 2026',
    foodId: 4,
  ),
  Review(
    name: 'Sophia Taylor',
    desc: 'Milkshakes are incredible. A bit expensive but perfect for cheat day.',
    date: 'Mar 11, 2026',
    foodId: 4,
  ),
  Review(
    name: 'Ethan Moore',
    desc: 'Best late-night food spot. Open until 2am on weekends!',
    date: 'Mar 4, 2026',
    foodId: 4,
  ),
  Review(
    name: 'Isabella Garcia',
    desc: 'The loaded fries are a meal by themselves. Split with a friend!',
    date: 'Feb 27, 2026',
    foodId: 4,
  ),
  Review(
    name: 'Noah Anderson',
    desc: 'Great place to grab food after a game. Service can be slow when busy.',
    date: 'Feb 18, 2026',
    foodId: 4,
  ),

  // Subway reviews (foodId: 5)
  Review(
    name: 'Mia Robinson',
    desc: 'Healthy option on campus. Love building my own sandwich exactly how I want it.',
    date: 'Mar 14, 2026',
    foodId: 5,
  ),
  Review(
    name: 'Liam Wilson',
    desc: 'Good for a quick, lighter meal. The subway club is my go-to.',
    date: 'Mar 9, 2026',
    foodId: 5,
  ),
  Review(
    name: 'Ava Martinez',
    desc: 'Fresh veggies and bread baked daily. Reliable and convenient.',
    date: 'Mar 2, 2026',
    foodId: 5,
  ),
  Review(
    name: 'William Jackson',
    desc: 'App has good deals. Cookie and drink combo is a steal!',
    date: 'Feb 24, 2026',
    foodId: 5,
  ),
  Review(
    name: 'Emma Thompson',
    desc: 'Fast service even during rush. Staff is always friendly.',
    date: 'Feb 16, 2026',
    foodId: 5,
  ),
];