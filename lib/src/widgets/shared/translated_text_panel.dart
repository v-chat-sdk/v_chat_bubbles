import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/enums.dart';
import '../../core/modern_message_models.dart';
import '../../utils/text_parser.dart';
import '../bubble_scope.dart';

/// Controlled translation state rendered below the original message.
class VTranslatedTextPanel extends StatelessWidget {
  final String messageId;
  final VMessageTranslationData translation;
  final Color textColor;

  const VTranslatedTextPanel({
    super.key,
    required this.messageId,
    required this.translation,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.bubbleTheme;
    final callbacks = context.bubbleCallbacks;
    final languagePair =
        '${translation.sourceLanguageCode.toUpperCase()} → '
        '${translation.targetLanguageCode.toUpperCase()}';

    return Container(
      key: ValueKey('v-translation-$messageId'),
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: textColor.withValues(alpha: 0.18)),
        ),
      ),
      child: switch (translation.state) {
        VTranslationState.translating => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: BubbleSizes.iconSmall,
              height: BubbleSizes.iconSmall,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: textColor,
              ),
            ),
            BubbleSpacing.gapS,
            Text(
              context.bubbleConfig.translations.actionTranslate,
              style: theme.timeTextStyle.copyWith(color: textColor),
            ),
          ],
        ),
        VTranslationState.error => Row(
          children: [
            Expanded(
              child: Text(
                translation.errorMessage ?? 'Translation unavailable',
                style: theme.timeTextStyle.copyWith(color: textColor),
              ),
            ),
            TextButton(
              onPressed: callbacks.onTranslationRetry == null
                  ? null
                  : () => callbacks.onTranslationRetry!(messageId),
              child: Text(context.bubbleConfig.translations.viewerRetry),
            ),
          ],
        ),
        VTranslationState.translated => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.translate_rounded,
                  size: BubbleSizes.iconSmall,
                  color: textColor,
                ),
                BubbleSpacing.gapS,
                Expanded(
                  child: Text(
                    languagePair,
                    style: theme.timeTextStyle.copyWith(
                      color: textColor.withValues(alpha: 0.75),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: callbacks.onTranslationToggle == null
                      ? null
                      : () => callbacks.onTranslationToggle!(
                          messageId,
                          !translation.showTranslation,
                        ),
                  child: Text(
                    translation.showTranslation
                        ? 'Original'
                        : context.bubbleConfig.translations.actionTranslate,
                  ),
                ),
              ],
            ),
            if (translation.showTranslation)
              Text(
                translation.translatedText!,
                key: ValueKey('v-translated-text-$messageId'),
                style: theme.messageTextStyle.copyWith(color: textColor),
                textDirection: VTextParser.getTextDirection(
                  translation.translatedText!,
                ),
              ),
          ],
        ),
      },
    );
  }
}
