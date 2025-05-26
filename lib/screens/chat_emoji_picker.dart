import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:horoscopeguruapp/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatEmojiPicker extends StatelessWidget {
  final VoidCallback onBackspacePressed;
  final Function(Category?, Emoji) onEmojiSelected;

  // Assuming AppColors and AppLocalizations are accessible
  // If not, you might need to pass them as parameters or access them globally

  const ChatEmojiPicker({
    Key? key,
    required this.onBackspacePressed,
    required this.onEmojiSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // It's good practice to define colors and other constants outside the build method
    // or access them from a theme or a dedicated constants file.
    // For this example, I'll keep them as they are but you should consider refactoring.

    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade800,
        // You might want to make the borderRadius configurable as well
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: SizedBox(
        height: 250, // This height could also be a parameter
        child: EmojiPicker(
          onBackspacePressed: onBackspacePressed,
          onEmojiSelected: onEmojiSelected,
          config: Config(
            height: 250,
            viewOrderConfig: const ViewOrderConfig(),
            // Use const if possible
            checkPlatformCompatibility: true,
            emojiSet: null,
            // Consider making this configurable
            emojiTextStyle: const TextStyle(fontSize: 32, color: Colors.white),
            // Use const
            customSearchIcon: const Icon(Icons.search, color: Colors.white),
            // Use const
            customBackspaceIcon: const Icon(Icons.close, color: Colors.white),
            // Use const
            emojiViewConfig: EmojiViewConfig(
              columns: 7,
              emojiSizeMax: 32.0,
              backgroundColor: AppColors.primaryDark,
              verticalSpacing: 0,
              horizontalSpacing: 0,
              gridPadding: EdgeInsets.zero,
              recentsLimit: 28,
              replaceEmojiOnLimitExceed: false,
              // Ensure AppLocalizations.of(context) is available and not null
              noRecents: Text(
                AppLocalizations.of(context)?.noRecents ??
                    "No Recents", // Provide a fallback
                style: TextStyle(fontSize: 20, color: Colors.grey.shade400),
                textAlign: TextAlign.center,
              ),
              loadingIndicator: const SizedBox.shrink(),
              // Use const
              buttonMode: ButtonMode.MATERIAL,
            ),
            categoryViewConfig: const CategoryViewConfig(
              // Use const
              backgroundColor: AppColors.primaryDarkE,
              iconColor: AppColors.textColor,
              iconColorSelected: AppColors.accent,
              indicatorColor: AppColors.accent,
            ),
            bottomActionBarConfig: const BottomActionBarConfig(
              // Use const
              backgroundColor: AppColors.primaryDarkE,
              buttonColor: AppColors.primaryDarkE,
              buttonIconColor: Colors.white,
            ),
            searchViewConfig: const SearchViewConfig(
              // Use const
              backgroundColor: AppColors.primaryDarkE,
              hintTextStyle: TextStyle(color: AppColors.textColor),
            ),
          ),
        ),
      ),
    );
  }
}
