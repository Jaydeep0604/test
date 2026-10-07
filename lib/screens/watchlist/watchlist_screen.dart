import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../base/base_stateful_widget_state.dart';
import '../../common_widgets/coin_item_card.dart';
import '../../common_widgets/custom_search_bar.dart';
import '../../models/coin_model.dart';
import '../../repo/crypto_repository.dart';
import '../../resources/colors.dart';
import '../../resources/strings.dart';
import '../coin_detail/coin_detail_screen.dart';
import 'cubit/watchlist_cubit.dart';
import 'cubit/watchlist_state.dart';

class WatchlistScreen extends StatefulWidget {
  final List<CoinModel> availableCoins;

  const WatchlistScreen({
    super.key,
    this.availableCoins = const [],
  });

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends BaseStatefulWidgetState<WatchlistScreen> {
  final TextEditingController _searchController = TextEditingController();
  late WatchlistCubit _watchlistCubit;

  @override
  void initState() {
    super.initState();
    _watchlistCubit = WatchlistCubit(repository: CryptoRepository());
    _watchlistCubit.loadWatchlist(widget.availableCoins);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _watchlistCubit.close();
    super.dispose();
  }

  void _navigateToDetail(CoinModel coin, bool isWatchlisted) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => CoinDetailScreen(
          coin: coin,
          isWatchlisted: isWatchlisted,
        ),
      ),
    );

    if (result != null && !result) {
      _watchlistCubit.removeFromWatchlist(coin.id);
    } else {
      _watchlistCubit.loadWatchlist(widget.availableCoins);
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocProvider<WatchlistCubit>.value(
      value: _watchlistCubit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Title
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 4),
            child: Text(
              Strings.myWatchlist,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorBlack,
              ),
            ),
          ),

          // Search Bar
          CustomSearchBar(
            controller: _searchController,
            onChanged: (value) {
              _watchlistCubit.searchWatchlist(value);
            },
          ),

          // Content Area
          Expanded(
            child: BlocBuilder<WatchlistCubit, WatchlistState>(
              builder: (context, state) {
                if (state.status == WatchlistStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(color: colorPrimary),
                  );
                }

                // Empty Watchlist State
                if (state.allWatchlistCoins.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Large star empty icon illustration
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: colorLightGrey.withAlpha(150),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const Icon(
                                Icons.star_rounded,
                                size: 72,
                                color: Color(0xFFCBD5E1),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            Strings.watchlistEmpty,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorBlack,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            Strings.watchlistEmptySub,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: colorGrey,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state.filteredWatchlistCoins.isEmpty) {
                  return const Center(
                    child: Text(
                      Strings.noCoinsFound,
                      style: TextStyle(color: colorGrey, fontSize: 15),
                    ),
                  );
                }

                return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.filteredWatchlistCoins.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: colorBorder,
                  ),
                  itemBuilder: (context, index) {
                    final coin = state.filteredWatchlistCoins[index];
                    return CoinItemCard(
                      coin: coin,
                      isWatchlisted: true,
                      onTap: () => _navigateToDetail(coin, true),
                      onWatchlistTap: () => _watchlistCubit.removeFromWatchlist(coin.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
