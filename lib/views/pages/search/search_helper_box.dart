import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prelura_app/controller/search_history_provider.dart';
import 'package:prelura_app/core/graphql/__generated/schema.graphql.dart';
import 'package:prelura_app/res/colors.dart';
import 'package:prelura_app/views/pages/search_result/provider/search_provider.dart';
import 'package:prelura_app/views/widgets/loading_widget.dart';

class SearchHelperBox extends HookConsumerWidget {
  final Function? onItemSelected;
  const SearchHelperBox({super.key, this.onItemSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      log("::::You called used 0");
      WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
        log("::::You called used 1");
        ref.invalidate(
          userSearchHistoryProvider(
            Enum$SearchTypeEnum.PRODUCT,
          ),
        );
      });
      return null;
    }, []);
    final searchHistories = ref.watch(
      userSearchHistoryProvider(
        Enum$SearchTypeEnum.PRODUCT,
      ),
    );
    log(":::::${searchHistories.value?.length}");
    final searchSuggestions = ref.watch(
      searchHistoryProvider(
        Enum$SearchTypeEnum.PRODUCT,
      ),
    );
    final searchQuery = ref.watch(searchHistoryQueryProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: [
        if (searchQuery?.isEmpty ?? true)
          searchHistories.when(
            data: (searches) {
              log(":::The data length is ${searches.length}");
              return Column(
                children: [
                  if (searches.length > 0)
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          ref.watch(deleteUserSearchHistoryProvider(
                            DeleteHistoryParams(
                              clearAll: true,
                            ),
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "Clear all",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: PreluraColors.greyColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: searches.take(10).toList().length,
                    itemBuilder: (context, index) {
                      return SearchHintItemBox(
                        label: searches[index].query,
                        id: searches[index].id.toString(),
                        onItemSelected: onItemSelected,
                      );
                    },
                  ),
                ],
              );
            },
            error: (a, b) {
              return SizedBox.shrink();
            },
            loading: () => Center(
              child: LoadingWidget(),
              // CircularProgressIndicator.adaptive(
              //   backgroundColor: PreluraColors.greyColor,
              // ),
            ),
          )
        else
          searchSuggestions.when(
            data: (searches) {
              searches.isEmpty ? searches.add(searchQuery) : null;
              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: searches.length,
                itemBuilder: (context, index) {
                  return SearchHintItemBox(
                    label: searches[index] ?? "",
                    showCloseIcon: false,
                  );
                },
              );
            },
            error: (a, b) {
              return SizedBox.shrink();
            },
            loading: () => Center(
              child: LoadingWidget(),
              // CircularProgressIndicator.adaptive(
              //   backgroundColor: PreluraColors.greyColor,
              // ),
            ),
          ),
      ]),
    );
  }
}

class SearchHintItemBox extends ConsumerWidget {
  final String label;
  final String? id;
  final bool showCloseIcon;
  final Function? onClose, onItemSelected;
  const SearchHintItemBox({
    super.key,
    required this.label,
    this.id,
    this.onItemSelected,
    this.showCloseIcon = true,
    this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(searchTextController.notifier).state.text = label;
        ref.read(showSearchProducts.notifier).state = true;
        // ref
        //     .read(searchFilterProvider.notifier)
        //     .updateFilter(FilterTypes.category, label);
      },
      child: Container(
        height: 40,
        width: double.infinity,
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: PreluraColors.greyColor,
                ),
              ),
              if (showCloseIcon)
                GestureDetector(
                  onTap: () async {
                    ref.watch(deleteUserSearchHistoryProvider(
                      DeleteHistoryParams(
                        searchId: id,
                      ),
                    ));
                  },
                  child: SvgPicture.asset(
                    "assets/icons/CloseIcon.svg",
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      PreluraColors.greyColor,
                      BlendMode.srcIn,
                    ),
                  ),
                )
            ]),
      ),
    );
  }
}
