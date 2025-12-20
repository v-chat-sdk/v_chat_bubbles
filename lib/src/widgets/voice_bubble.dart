import 'package:flutter/material.dart';
import 'package:v_chat_voice_player/v_chat_voice_player.dart';

import 'base_bubble.dart';
import 'bubble_scope.dart';
import 'bubble_wrapper.dart';

/// Voice message bubble using v_chat_voice_player
///
/// Features:
/// - Waveform display with playback progress
/// - Play/pause controls
/// - Duration display with playback position
/// - Playback speed control (1x, 1.25x, 1.5x, 2x)
/// - Automatic transfer state handling
class VVoiceBubble extends BaseBubble {
  /// Voice message controller from v_chat_voice_player
  final VVoiceMessageController controller;
  @override
  String get messageType => 'voice message';
  const VVoiceBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.controller,
    super.status,
    super.isSameSender,
    super.avatar,
    super.senderName,
    super.senderColor,
    super.replyTo,
    super.forwardedFrom,
    super.reactions,
    super.isEdited,
    super.isPinned,
    super.isStarred,
    super.isHighlighted,
  });
  @override
  Widget buildContent(BuildContext context) {
    final theme = context.bubbleTheme;
    final config = context.bubbleConfig;
    final voiceTheme = theme.voice;
    final header = buildBubbleHeader(context);
    return VBubbleWrapper(
      isMeSender: isMeSender,
      showTail: !isSameSender,
      child: SizedBox(
        width: config.media.voiceMessageWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (header != null) header,
            VVoiceMessageView(
              controller: controller,
              colorConfig: VoiceColorConfig(
                activeSliderColor: voiceTheme.waveformPlayedColor(isMeSender),
                notActiveSliderColor:
                    voiceTheme.waveformUnplayedColor(isMeSender),
              ),
              buttonConfig: VoiceButtonConfig(
                buttonColor: voiceTheme.buttonColor(isMeSender),
                buttonIconColor: voiceTheme.buttonIconColor(isMeSender),
                buttonSize: voiceTheme.buttonSize,
                useSimplePlayIcon: voiceTheme.useSimplePlayIcon,
                simpleIconSize: voiceTheme.simpleIconSize,
              ),
              speedConfig: VoiceSpeedConfig(
                showSpeedControl: voiceTheme.showSpeedControl,
                speedButtonColor: voiceTheme.speedButtonColor(isMeSender),
                speedButtonTextColor:
                    voiceTheme.speedButtonTextColor(isMeSender),
                speedButtonBorderRadius: voiceTheme.speedButtonBorderRadius,
                speedButtonPadding: voiceTheme.speedButtonPadding,
              ),
              textConfig: VoiceTextConfig(
                counterTextStyle: voiceTheme.durationTextStyle.copyWith(
                  color: voiceTheme.durationTextColor(isMeSender),
                ),
              ),
              containerConfig: const VoiceContainerConfig(
                backgroundColor: Colors.transparent,
                containerPadding: EdgeInsets.zero,
                borderRadius: 0,
              ),
              visualizerConfig: VoiceVisualizerConfig(
                showVisualizer: voiceTheme.showVisualizer,
                height: voiceTheme.visualizerHeight,
                barCount: voiceTheme.visualizerBarCount,
                barSpacing: voiceTheme.visualizerBarSpacing,
                minBarHeight: voiceTheme.visualizerMinBarHeight,
                enableBarAnimations: voiceTheme.enableBarAnimations,
              ),
            ),
            const SizedBox(height: 4),
            Align(alignment: Alignment.centerRight, child: buildMeta(context)),
          ],
        ),
      ),
    );
  }
}
