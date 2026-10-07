import 'package:intl/intl.dart';

class CoinModel {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double marketCap;
  final int marketCapRank;
  final double? high24h;
  final double? low24h;
  final double? priceChange24h;
  final double priceChangePercentage24h;
  final double? circulatingSupply;
  final double? totalSupply;
  final double? maxSupply;
  final double? ath;

  CoinModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    this.high24h,
    this.low24h,
    this.priceChange24h,
    required this.priceChangePercentage24h,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.ath,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'] ?? '',
      symbol: (json['symbol'] ?? '').toString().toUpperCase(),
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      currentPrice: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      marketCap: (json['market_cap'] as num?)?.toDouble() ?? 0.0,
      marketCapRank: (json['market_cap_rank'] as num?)?.toInt() ?? 0,
      high24h: (json['high_24h'] as num?)?.toDouble(),
      low24h: (json['low_24h'] as num?)?.toDouble(),
      priceChange24h: (json['price_change_24h'] as num?)?.toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
      circulatingSupply: (json['circulating_supply'] as num?)?.toDouble(),
      totalSupply: (json['total_supply'] as num?)?.toDouble(),
      maxSupply: (json['max_supply'] as num?)?.toDouble(),
      ath: (json['ath'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'current_price': currentPrice,
      'market_cap': marketCap,
      'market_cap_rank': marketCapRank,
      'high_24h': high24h,
      'low_24h': low24h,
      'price_change_24h': priceChange24h,
      'price_change_percentage_24h': priceChangePercentage24h,
      'circulating_supply': circulatingSupply,
      'total_supply': totalSupply,
      'max_supply': maxSupply,
      'ath': ath,
    };
  }

  String formatCurrency(double amount) {
    if (amount >= 1000) {
      final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
      return formatter.format(amount);
    } else if (amount >= 1) {
      final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
      return formatter.format(amount);
    } else {
      final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 4);
      return formatter.format(amount);
    }
  }

  String get currentPriceFormatted => formatCurrency(currentPrice);
  String get high24hFormatted => high24h != null ? formatCurrency(high24h!) : 'N/A';
  String get low24hFormatted => low24h != null ? formatCurrency(low24h!) : 'N/A';
  String get marketCapFormatted => formatCurrency(marketCap);

  String get priceChangePercentage24hFormatted {
    final prefix = priceChangePercentage24h >= 0 ? '+' : '';
    return '$prefix${priceChangePercentage24h.toStringAsFixed(2)}%';
  }

  bool get isPositiveChange => priceChangePercentage24h >= 0;

  String _formatNumber(double? val) {
    if (val == null) return 'N/A';
    final formatter = NumberFormat('#,##0.##', 'en_IN');
    return formatter.format(val);
  }

  String get circulatingSupplyFormatted => '${_formatNumber(circulatingSupply)} $symbol';
  String get totalSupplyFormatted => totalSupply != null ? '${_formatNumber(totalSupply)} $symbol' : 'N/A';

  CoinModel copyWith({
    String? id,
    String? symbol,
    String? name,
    String? image,
    double? currentPrice,
    double? marketCap,
    int? marketCapRank,
    double? high24h,
    double? low24h,
    double? priceChange24h,
    double? priceChangePercentage24h,
    double? circulatingSupply,
    double? totalSupply,
    double? maxSupply,
    double? ath,
  }) {
    return CoinModel(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      image: image ?? this.image,
      currentPrice: currentPrice ?? this.currentPrice,
      marketCap: marketCap ?? this.marketCap,
      marketCapRank: marketCapRank ?? this.marketCapRank,
      high24h: high24h ?? this.high24h,
      low24h: low24h ?? this.low24h,
      priceChange24h: priceChange24h ?? this.priceChange24h,
      priceChangePercentage24h: priceChangePercentage24h ?? this.priceChangePercentage24h,
      circulatingSupply: circulatingSupply ?? this.circulatingSupply,
      totalSupply: totalSupply ?? this.totalSupply,
      maxSupply: maxSupply ?? this.maxSupply,
      ath: ath ?? this.ath,
    );
  }
}
