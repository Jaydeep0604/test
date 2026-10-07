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
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends BaseStatefulWidgetState<Homescreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _homeCubit = HomeCubit(repository: CryptoRepository());
    _homeCubit.loadInitialData();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _homeCubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _homeCubit.loadNextPage();
    }
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

    if (result != null && result != isWatchlisted) {
      _homeCubit.toggleWatchlist(coin.id);
    } else {
      _homeCubit.syncWatchlist();
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocProvider<HomeCubit>.value(
      value: _homeCubit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Title
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 4),
            child: Text(
              Strings.cryptoMarket,
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
              _homeCubit.searchCoins(value);
            },
          ),

          // Coin List or Loading or Error
          Expanded(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state.status == HomeStatus.loading && state.allCoins.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: colorPrimary),
                  );
                }

                if (state.status == HomeStatus.failure && state.allCoins.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: colorRed),
                          const SizedBox(height: 12),
                          Text(
                            state.errorMessage ?? Strings.somethingWentWrong,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: colorDarkGrey, fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _homeCubit.loadInitialData(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrimary,
                            ),
                            child: const Text(
                              Strings.retry,
                              style: TextStyle(color: colorWhite),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state.filteredCoins.isEmpty) {
                  return Center(
                    child: Text(
                      _searchController.text.isNotEmpty
                          ? Strings.noCoinsFound
                          : 'No coins available.',
                      style: const TextStyle(color: colorGrey, fontSize: 15),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: colorPrimary,
                  onRefresh: () async {
                    await _homeCubit.refreshData();
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: state.filteredCoins.length + (state.isPaginatedLoading ? 1 : 0),
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: colorBorder,
                    ),
                    itemBuilder: (context, index) {
                      if (index == state.filteredCoins.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: colorPrimary,
                              strokeWidth: 2.5,
                            ),
                          ),
                        );
                      }

                      final coin = state.filteredCoins[index];
                      final isWatchlisted = state.watchlistIds.contains(coin.id);

                      return CoinItemCard(
                        coin: coin,
                        isWatchlisted: isWatchlisted,
                        onTap: () => _navigateToDetail(coin, isWatchlisted),
                        onWatchlistTap: () => _homeCubit.toggleWatchlist(coin.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
