import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';
import '../core/constants.dart';
import '../core/enums.dart';
import '../core/models.dart';
import '../utils/format_utils.dart';
import '../utils/text_parser.dart';
import 'base_bubble.dart';
import 'bubble_scope.dart';
import 'bubble_wrapper.dart';

/// File attachment message bubble
///
/// Displays file information with:
/// - File type icon (based on extension)
/// - File name
/// - File size and extension
/// - Download/upload progress indicator
class VFileBubble extends BaseBubble {
  /// Platform file containing the file data
  final VPlatformFile file;

  /// Transfer state (idle, uploading, downloading, completed, error)
  final VTransferState transferState;

  /// Upload/download progress (0.0 to 1.0)
  final double? progress;
  @override
  String get messageType => 'file';
  const VFileBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.file,
    this.transferState = VTransferState.completed,
    this.progress,
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
    final textColor = selectTextColor(theme);
    final secondaryColor = selectSecondaryTextColor(theme);
    final header = buildBubbleHeader(context);
    final showTail = !isSameSender;
    final fileName = file.name;
    final extension = _getExtensionFromName(fileName);
    final fileSize = file.fileSize;
    return VBubbleWrapper(
      isMeSender: isMeSender,
      showTail: showTail,
      child: SizedBox(
        width: config.media.fileMessageWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (header != null) header,
            Row(
              children: [
                _buildFileIcon(context, extension),
                BubbleSpacing.gapXL,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        fileName,
                        style: theme.messageTextStyle.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: VTextParser.getTextDirection(fileName),
                      ),
                      BubbleSpacing.vGapXS,
                      Row(
                        children: [
                          Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (fileSize > 0)
                                  Flexible(
                                    child: Text(
                                      formatFileSize(fileSize),
                                      style: theme.timeTextStyle
                                          .copyWith(color: secondaryColor),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                if (extension.isNotEmpty) ...[
                                  Text(' • ',
                                      style: theme.timeTextStyle
                                          .copyWith(color: secondaryColor)),
                                  Text(
                                    extension.toUpperCase(),
                                    style: theme.timeTextStyle
                                        .copyWith(color: secondaryColor),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          BubbleSpacing.gapS,
                          buildMeta(context),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileIcon(BuildContext context, String extension) {
    final theme = context.bubbleTheme;
    final callbacks = context.bubbleCallbacks;
    final isSelectionMode = context.bubbleScope.isSelectionMode;
    final iconColor = selectLinkColor(theme);
    // Downloading/uploading state - show progress with cancel button
    if (transferState == VTransferState.downloading ||
        transferState == VTransferState.uploading) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: isSelectionMode
            ? null
            : () {
                callbacks.onTransferStateChanged?.call(
                  messageId,
                  VMediaTransferAction.cancel,
                );
              },
        child: SizedBox(
          width: BubbleSizes.iconContainerSize,
          height: BubbleSizes.iconContainerSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 2,
                color: iconColor,
                backgroundColor:
                    iconColor.withValues(alpha: BubbleOpacity.light2),
              ),
              Icon(
                Icons.close,
                size: BubbleSizes.smallMediumIconSize,
                color: iconColor,
              ),
            ],
          ),
        ),
      );
    }
    // Determine icon and action based on state
    IconData icon;
    VMediaTransferAction? action;
    switch (transferState) {
      case VTransferState.idle:
        icon = Icons.download;
        action = VMediaTransferAction.download;
      case VTransferState.error:
        icon = Icons.refresh;
        action = VMediaTransferAction.retry;
      default:
        icon = _getFileIcon(extension);
        action = null;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isSelectionMode
          ? null
          : () {
              if (action != null) {
                callbacks.onTransferStateChanged?.call(messageId, action);
              } else if (transferState == VTransferState.completed) {
                callbacks.onMediaTap?.call(VMediaTapData(messageId: messageId));
              }
            },
      child: Container(
        width: BubbleSizes.iconContainerSize,
        height: BubbleSizes.iconContainerSize,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: BubbleOpacity.light),
          borderRadius: BubbleRadius.small,
        ),
        child: Icon(icon, color: iconColor, size: BubbleSizes.iconLarge),
      ),
    );
  }

  /// Extract file extension from filename
  String _getExtensionFromName(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == fileName.length - 1) return '';
    final ext = fileName.substring(dotIndex + 1);
    // Filter out null/undefined text from improper serialization
    if (ext.toLowerCase() == 'null' || ext.toLowerCase() == 'undefined') {
      return '';
    }
    return ext;
  }

  IconData _getFileIcon(String? extension) {
    if (extension == null || extension.isEmpty) return Icons.insert_drive_file;
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.folder_zip;
      case 'mp3':
      case 'wav':
      case 'aac':
        return Icons.audio_file;
      case 'mp4':
      case 'mov':
      case 'avi':
        return Icons.video_file;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'txt':
        return Icons.text_snippet;
      case 'apk':
        return Icons.android;
      default:
        return Icons.insert_drive_file;
    }
  }
}
