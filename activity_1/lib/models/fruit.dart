class Fruit {
  final String name;
  final String imageUrl;
  final String price;
  final String description;

  Fruit({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
  });
}

final List<Fruit> fruits = [
  Fruit(
    name: 'Apple',
    imageUrl:
        "https://images.everydayhealth.com/images/diet-nutrition/apples-101-about-1440x810.jpg?w=508",
    price: '₱130/kg',
    description: 'Fresh red apples',
  ),
  Fruit(
    name: 'Banana',
    imageUrl: "https://upload.wikimedia.org/wikipedia/commons/6/69/Banana.png",
    price: '₱145/kg',
    description: 'Yellow ripe bananas',
  ),
  Fruit(
    name: 'Orange',
    imageUrl:
        "https://upload.wikimedia.org/wikipedia/commons/4/43/Ambersweet_oranges.jpg",
    price: '₱50/kg',
    description: 'Juicy oranges',
  ),
  Fruit(
    name: 'Strawberry',
    imageUrl:
        "https://hips.hearstapps.com/clv.h-cdn.co/assets/15/22/1432664914-strawberry-facts1.jpg?crop=1xw:0.8332147937411095xh;center,center",
    price: '₱180/kg',
    description: 'Sweet strawberries',
  ),
  Fruit(
    name: 'Mango',
    imageUrl: "https://upload.wikimedia.org/wikipedia/commons/4/40/Mango_4.jpg",
    price: '₱200/kg',
    description: 'Tropical mangoes',
  ),
  Fruit(
    name: 'Grapes',
    imageUrl:
        "https://upload.wikimedia.org/wikipedia/commons/d/d0/Red_grapes_%281%29.jpg",
    price: '₱250/kg',
    description: 'Purple grapes',
  ),
];
