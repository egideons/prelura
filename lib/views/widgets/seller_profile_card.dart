import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prelura_app/core/router/router.gr.dart';
import 'package:prelura_app/core/utils/theme.dart';
import 'package:prelura_app/views/widgets/gap.dart';
import 'package:sizer/sizer.dart';

import '../../controller/user/user_controller.dart';
import '../../model/user/user_model.dart';
import '../../res/colors.dart';
import '../../res/utils.dart';
import '../shimmers/grid_shimmer.dart';
import 'rating.dart';

class SellerProfileCard extends ConsumerWidget {
  const SellerProfileCard({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedUser = ref.watch(userProvider).valueOrNull;
    return GestureDetector(
      onTap: () {
        if (loggedUser?.username == user.username) {
          context.router.push(UserProfileDetailsRoute());
        } else {
          context.router.push(ProfileDetailsRoute(username: user.username));
        }
      },
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user.profilePictureUrl == null) ...[
              Stack(
                children: [
                  Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Center(
                        child: Text(
                          user.username.split('').first.toUpperCase() ?? '--',
                          style: context.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 44),
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //     bottom: -2,
                  //     right: 0,
                  //     child: RenderSvgWithoutColor(
                  //       svgPath: PreluraIcons.trusted_svg,
                  //       svgHeight: 18,
                  //       svgWidth: 18,
                  //     ))
                ],
              )
            ] else ...[
              Stack(
                children: [
                  if (user.profilePictureUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(
                        errorWidget: (context, url, error) => Container(
                          color: PreluraColors.grey,
                          child: Center(
                            child: Text(
                              user.username.split('').first.toUpperCase() ??
                                  '--',
                              style: context.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 44),
                            ),
                          ),
                        ),
                        imageUrl: user.profilePictureUrl ?? "",
                        height: 130,
                        width: 130,
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return ShimmerBox(
                            height: 16.h,
                            width: double.infinity,
                          );
                        },
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                      ),
                    ),
                  // Positioned(
                  //     bottom: -2,
                  //     right: 0,
                  //     child: RenderSvgWithoutColor(
                  //       svgPath: PreluraIcons.trusted_svg,
                  //       svgHeight: 18,
                  //       svgWidth: 18,
                  //     ))
                ],
              ),
            ],
            10.verticalSpacing,
            Text(
              user.username,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: getDefaultSize(),
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            3.verticalSpacing,
            Text(
              "${user.noOfFollowers} ${(user.noOfFollowers != null && (user.noOfFollowers!.toInt() > 1 || user.noOfFollowers?.toInt() == 0)) ? " followers" : " follower"}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: PreluraColors.grey,
                    fontSize: getDefaultSize(),
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Ratings(),
                const SizedBox(
                  width: 4,
                ),
                InkWell(
                  onTap: () {},
                  child: Text("(300)",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: PreluraColors.activeColor,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            3.verticalSpacing,
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     const RenderSvgWithoutColor(
            //       svgPath: PreluraIcons.trusted_svg,
            //       svgHeight: 18,
            //       svgWidth: 18,
            //     ),
            //     const SizedBox(
            //       width: 4,
            //     ),
            //     Text(
            //       "Trusted",
            //       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            //             color: PreluraColors.grey,
            //             fontWeight: FontWeight.w600,
            //             fontSize: getDefaultSize(size: 12),
            //           ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
