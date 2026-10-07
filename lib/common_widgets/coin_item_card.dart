import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/coin_model.dart';
import '../resources/colors.dart';

class CoinItemCard extends StatelessWidget {
  final CoinModel coin;
  final bool isWatchlisted;
  final VoidCallback onTap;
  final VoidCallback onWatchlistTap;

  const CoinItemCard({
    super.key,
    required this.coin,
    required this.isWatchlisted,
    required this.onTap,
    required this.onWatchlistTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPositive = coin.isPositiveChange;
    final Color changeColor = isPositive ? colorGreen : colorRed;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Rank Number
            SizedBox(
              width: 24,
              child: Text(
                '${coin.marketCapRank}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorGrey,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Coin Image
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: coin.image,
                width: 38,
                height: 38,
                fit: BoxFit.cover,
                placeholder: (context, url) => const SizedBox(
                  width: 38,
                  height: 38,
                  child: Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 38,
                  height: 38,
                  color: colorLightGrey,
                  child: const Icon(Icons.currency_bitcoin, color: colorGrey),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Coin Name & Symbol
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colorBlack,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    coin.symbol,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: colorGrey,
                    ),
                  ),
                ],
              ),
            ),

            // Current Price & 24h Change
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  coin.currentPriceFormatted,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colorBlack,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  coin.priceChangePercentage24hFormatted,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: changeColor,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),

            // Watchlist Star Toggle
            IconButton(
              icon: Icon(
                isWatchlisted ? Icons.star : Icons.star_border,
                color: isWatchlisted ? colorStarYellow : colorGrey,
                size: 24,
              ),
              onPressed: onWatchlistTap,
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(4),
            ),
          ],
        ),
      ),
    );
  }
}
