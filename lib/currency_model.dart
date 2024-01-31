class Currency {
  final String name;
  final String buyingPrice;
  final String sellingPrice;
  final String change;
  final String changeDirection;

  Currency({
    required this.name,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.change,
    required this.changeDirection,
  });
}