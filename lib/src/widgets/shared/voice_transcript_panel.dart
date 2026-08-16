import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/enums.dart';
import '../../core/modern_message_models.dart';
import '../../utils/text_parser.dart';
import '../bubble_scope.dart';

/// Controlled, optionally time-aligned voice transcript presentation.
class VVoiceTranscriptPanel extends StatelessWidget {
  final String messageId;
  final VVoiceTranscriptData transcript;
  final Color textColor;
  final String label;

  const VVoiceTranscriptPanel({
    super.key,
    required this.messageId,
    required this.transcript,
    required this.textColor,
    this.label = 'Transcript',
  });

  @override
  Widget build(BuildContext context) {
    final callbacks = context.bubbleCallbacks;
    final theme = context.bubbleTheme;
    if (transcript.state == VTranscriptState.unavailable) {
      return const SizedBox.shrink();
    }
    if (transcript.state == VTranscriptState.transcribing) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          key: ValueKey('v-transcript-loading-$messageId'),
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
            Text(label, style: theme.timeTextStyle.copyWith(color: textColor)),
          ],
        ),
      );
    }
    if (transcript.state == VTranscriptState.error) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton.icon(
          key: ValueKey('v-transcript-retry-$messageId'),
          onPressed: callbacks.onTranscriptRetry == null
              ? null
              : () => callbacks.onTranscriptRetry!(messageId),
          icon: const Icon(Icons.refresh_rounded),
          label: Text(transcript.errorMessage ?? label),
        ),
      );
    }

    return Container(
      key: ValueKey('v-transcript-$messageId'),
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: textColor.withValues(alpha: 0.18)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton.icon(
            onPressed: callbacks.onTranscriptToggle == null
                ? null
                : () => callbacks.onTranscriptToggle!(
                    messageId,
                    !transcript.isExpanded,
                  ),
            icon: Icon(
              transcript.isExpanded
                  ? Icons.expand_less_rounded
                  : Icons.subject_rounded,
            ),
            label: Text(label),
          ),
          if (transcript.isExpanded)
            if (transcript.segments.isEmpty)
              Text(
                transcript.text!,
                style: theme.captionTextStyle.copyWith(color: textColor),
                textDirection: VTextParser.getTextDirection(transcript.text!),
              )
            else
              ...transcript.segments.map(
                (segment) => InkWell(
                  onTap: callbacks.onTranscriptSegmentTap == null
                      ? null
                      : () => callbacks.onTranscriptSegmentTap!(
                          messageId,
                          segment.start,
                        ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      '${_formatTime(segment.start)}  ${segment.text}',
                      style: theme.captionTextStyle.copyWith(color: textColor),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  String _formatTime(Duration value) {
    final minutes = value.inMinutes;
    final seconds = value.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
