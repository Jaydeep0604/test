import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../base/base_stateful_widget_state.dart';
import '../../models/coin_model.dart';
import '../../resources/colors.dart';
import '../../resources/strings.dart';
import '../../services/watchlist_service.dart';

class CoinDetailScreen extends StatefulWidget {
  final CoinModel coin;
  final bool isWatchlisted;

  const CoinDetailScreen({
    super.key,
    required this.coin,
    required this.isWatchlisted,
  });

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends BaseStatefulWidgetState<CoinDetailScreen> {
  late bool _isWatchlisted;

  @override
  void initState() {
    super.initState();
    _isWatchlisted = widget.isWatchlisted;
  }

  Future<void> _toggleWatchlist() async {
    final updatedList = await WatchlistService.instance.toggleWatchlist(widget.coin.id);
    setState(() {
      _isWatchlisted = updatedList.contains(widget.coin.id);
    });
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: colorWhite,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: colorBlack),
        onPressed: () => Navigator.of(context).pop(_isWatchlisted),
      ),
      title: const Text(
        Strings.coinDetails,
        style: TextStyle(
          color: colorBlack,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            _isWatchlisted ? Icons.star : Icons.star_border,
            color: _isWatchlisted ? colorStarYellow : colorGrey,
            size: 26,
          ),
          onPressed: _toggleWatchlist,
        ),
      ],
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final coin = widget.coin;
    final bool isPositive = coin.isPositiveChange;
    final Color changeColor = isPositive ? colorGreen : colorRed;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Info Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: coin.image,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SizedBox(
                          width: 56,
                          height: 56,
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 56,
                          height: 56,
                          color: colorLightGrey,
                          child: const Icon(Icons.currency_bitcoin, color: colorGrey, size: 30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coin.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colorBlack,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            coin.symbol,
                            style: const TextStyle(
                              fontSize: 14,
                              color: colorGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorPrimary.withAlpha(20),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Rank #${coin.marketCapRank}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colorPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(height: 1, color: colorBorder),
                const SizedBox(height: 20),

                // Price & 24h Change
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          Strings.currentPrice,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorGrey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          coin.currentPriceFormatted,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: colorBlack,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: changeColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPositive ? Icons.trending_up : Icons.trending_down,
                            color: changeColor,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            coin.priceChangePercentage24hFormatted,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: changeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Market Stats Title
          const Text(
            'Market Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorBlack,
            ),
          ),
          const SizedBox(height: 12),

          // Stats Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _buildStatTile(
                title: Strings.high24h,
                value: coin.high24hFormatted,
                icon: Icons.arrow_upward,
                iconColor: colorGreen,
              ),
              _buildStatTile(
                title: Strings.low24h,
                value: coin.low24hFormatted,
                icon: Icons.arrow_downward,
                iconColor: colorRed,
              ),
              _buildStatTile(
                title: Strings.marketCap,
                value: coin.marketCapFormatted,
                icon: Icons.account_balance_wallet_outlined,
                iconColor: Colors.blue,
              ),
              _buildStatTile(
                title: Strings.marketCapRank,
                value: '#${coin.marketCapRank}',
                icon: Icons.leaderboard_outlined,
                iconColor: Colors.orange,
              ),
              _buildStatTile(
                title: Strings.circulatingSupply,
                value: coin.circulatingSupplyFormatted,
                icon: Icons.donut_large_outlined,
                iconColor: Colors.purple,
              ),
              _buildStatTile(
                title: Strings.totalSupply,
                value: coin.totalSupplyFormatted,
                icon: Icons.pie_chart_outline,
                iconColor: Colors.teal,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: colorGrey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorBlack,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
