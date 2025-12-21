import 'package:flutter/material.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';
import '../models/demo_message.dart';

class SampleMessages {
  SampleMessages._();
  // Avatars for group chat
  static final _aliceAvatar = VPlatformFile.fromUrl(
    networkUrl: 'https://i.pravatar.cc/150?img=1',
  );
  static final _bobAvatar = VPlatformFile.fromUrl(
    networkUrl: 'https://i.pravatar.cc/150?img=3',
  );
  static final _charlieAvatar = VPlatformFile.fromUrl(
    networkUrl: 'https://i.pravatar.cc/150?img=5',
  );
  static final _dianaAvatar = VPlatformFile.fromUrl(
    networkUrl: 'https://i.pravatar.cc/150?img=9',
  );
  static final _eveAvatar = VPlatformFile.fromUrl(
    networkUrl: 'https://i.pravatar.cc/150?img=16',
  );
  // Colors for senders
  static const _aliceColor = Color(0xFF4CAF50);
  static const _bobColor = Color(0xFF2196F3);
  static const _charlieColor = Color(0xFFFF9800);
  static const _dianaColor = Color(0xFF9C27B0);
  static const _eveColor = Color(0xFFE91E63);
  // Sample images
  static const _sampleImages = [
    'https://picsum.photos/400/300?random=1',
    'https://picsum.photos/400/300?random=2',
    'https://picsum.photos/400/300?random=3',
    'https://picsum.photos/400/300?random=4',
    'https://picsum.photos/400/300?random=5',
    'https://picsum.photos/400/300?random=6',
  ];

  /// Build messages for direct (1:1) chat
  static List<DemoMessage> buildDirectChat() {
    return [
      // Date chip - Yesterday
      DemoMessage.dateChip(
        id: 'date_1',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      // === TEXT MESSAGES ===
      // Short outgoing
      DemoMessage.text(
        id: 'd_msg_1',
        text: 'Hey! How are you doing?',
        time: '09:00',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // Short incoming
      DemoMessage.text(
        id: 'd_msg_2',
        text: 'I\'m doing great, thanks for asking!',
        time: '09:01',
        isOutgoing: false,
      ),
      // Medium outgoing
      DemoMessage.text(
        id: 'd_msg_3',
        text:
            'That\'s awesome! I was wondering if you\'re free this weekend for a coffee?',
        time: '09:02',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // Long expandable text
      DemoMessage.text(
        id: 'd_msg_4',
        text:
            '''This is a really long message that demonstrates the "See more" expansion feature. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.

Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. This text continues to show how the gradient fade appears at the bottom when text is truncated.''',
        time: '09:03',
        isOutgoing: false,
      ),
      // === TEXT FORMATTING TESTS ===
      // Inline formatting: Bold, Italic, Strikethrough, Code
      DemoMessage.text(
        id: 'd_msg_format_1',
        text:
            'Testing *bold text*, _italic text_, ~strikethrough~, and `inline code`!',
        time: '09:04',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // Combined inline formatting
      DemoMessage.text(
        id: 'd_msg_format_2',
        text:
            'You can combine *bold* with _italic_ and even `code` in the same message!',
        time: '09:04',
        isOutgoing: false,
      ),
      // Custom mention pattern test: [@username:userId] -> displays @username
      DemoMessage.text(
        id: 'd_msg_mention_1',
        text:
            'Hey [@John:user_123] and [@Sarah:user_456], can you check this out? Also cc [@Admin:user_001]',
        time: '09:05',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // Code block with language
      DemoMessage.text(
        id: 'd_msg_format_3',
        text: '''Here is a Flutter code example:
```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
```
Try this in your project!''',
        time: '09:04',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // Code block without language
      DemoMessage.text(
        id: 'd_msg_format_4',
        text: '''Simple code block:
```
npm install
npm run dev
```
That's it!''',
        time: '09:04',
        isOutgoing: false,
      ),
      // Blockquote
      DemoMessage.text(
        id: 'd_msg_format_5',
        text: '''Here's a famous quote:
> The only way to do great work is to love what you do.
> - Steve Jobs

What do you think?''',
        time: '09:04',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // Bullet list
      DemoMessage.text(
        id: 'd_msg_format_6',
        text: '''Shopping list:
- Milk
- Eggs
- Bread
- Cheese
- Butter

Don't forget anything!''',
        time: '09:04',
        isOutgoing: false,
      ),
      // Numbered list
      DemoMessage.text(
        id: 'd_msg_format_7',
        text: '''Steps to setup:
1. Clone the repository
2. Run flutter pub get
3. Configure your API keys
4. Run flutter run

Let me know if you need help!''',
        time: '09:04',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // Mixed formatting with inline in lists
      DemoMessage.text(
        id: 'd_msg_format_8',
        text: '''Todo list with *priorities*:
- *HIGH*: Fix the _critical_ bug
- *MEDIUM*: Update `README.md`
- *LOW*: ~Refactor old code~ Done!

> Remember: Always write tests!

Check out https://flutter.dev for more info.''',
        time: '09:04',
        isOutgoing: false,
      ),
      // === PATTERN DETECTION TESTS ===
      // URL pattern
      DemoMessage.text(
        id: 'd_msg_5',
        text:
            'Check out this article: https://flutter.dev/docs/get-started and let me know what you think!',
        time: '09:05',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // Email pattern
      DemoMessage.text(
        id: 'd_msg_6',
        text: 'You can reach me at john.doe@example.com for any questions.',
        time: '09:06',
        isOutgoing: false,
      ),
      // Phone pattern
      DemoMessage.text(
        id: 'd_msg_7',
        text: 'Call me at +1-555-123-4567 or +44 20 7946 0958 anytime!',
        time: '09:07',
        isOutgoing: true,
        status: VMessageStatus.delivered,
      ),
      // Multiple patterns in one message
      DemoMessage.text(
        id: 'd_msg_8',
        text:
            'Contact info:\nWebsite: https://example.com\nEmail: contact@example.com\nPhone: +1-800-555-0123',
        time: '09:08',
        isOutgoing: false,
      ),
      // Custom patterns (ticket, order, invoice)
      DemoMessage.text(
        id: 'd_msg_9',
        text:
            'Your support ticket TKT-12345 has been created. Reference number: ORD#98765',
        time: '09:10',
        isOutgoing: false,
      ),
      DemoMessage.text(
        id: 'd_msg_10',
        text:
            'Invoice INV-2024-001 is ready. Please check your order ORD#55555.',
        time: '09:11',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // === ARABIC TEXT (RTL) ===
      DemoMessage.text(
        id: 'd_msg_11',
        text: 'مرحبا! كيف حالك؟',
        time: '09:12',
        isOutgoing: false,
      ),
      DemoMessage.text(
        id: 'd_msg_12',
        text: 'أنا بخير، شكرا لسؤالك!',
        time: '09:13',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // Long Arabic text
      DemoMessage.text(
        id: 'd_msg_13',
        text:
            '''هذا نص طويل باللغة العربية لاختبار دعم اللغات من اليمين إلى اليسار. يجب أن يظهر النص بشكل صحيح ومنسق. الكتابة العربية جميلة ولها تاريخ عريق في الخط والتصميم. نأمل أن يعمل كل شيء بشكل جيد.''',
        time: '09:14',
        isOutgoing: false,
      ),
      // Mixed Arabic and English
      DemoMessage.text(
        id: 'd_msg_14',
        text: 'مرحبا, Check out this link: https://flutter.dev - إنه رائع!',
        time: '09:15',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // === REPLY MESSAGES ===
      DemoMessage.text(
        id: 'd_msg_15',
        text: 'Sure, Saturday works for me!',
        time: '09:20',
        isOutgoing: false,
        replyTo: const VReplyData(
          originalMessageId: 'd_msg_14',
          senderId: 'me',
          senderName: 'You',
          previewText:
              'That\'s awesome! I was wondering if you\'re free this weekend for a coffee?',
        ),
      ),
      // === EDITED MESSAGE ===
      DemoMessage.text(
        id: 'd_msg_16',
        text: 'This message was edited to fix a typo.',
        time: '09:22',
        isOutgoing: true,
        status: VMessageStatus.read,
        isEdited: true,
      ),
      // === MESSAGE WITH REACTIONS ===
      DemoMessage.text(
        id: 'd_msg_17',
        text: 'Great news! The project is approved!',
        time: '09:25',
        isOutgoing: false,
        reactions: const [
          VBubbleReaction(emoji: '🎉', count: 1, isSelected: true),
          VBubbleReaction(emoji: '👍', count: 1),
        ],
      ),
      // === FORWARDED MESSAGE ===
      DemoMessage.text(
        id: 'd_msg_18',
        text: 'Important announcement: The meeting is rescheduled to 3 PM.',
        time: '09:30',
        isOutgoing: true,
        status: VMessageStatus.read,
        forwardedFrom: VForwardData(
          originalMessageId: 'original_001',
          originalSenderName: 'Team Lead',
          originalTime: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ),
      // Date chip - Today
      DemoMessage.dateChip(id: 'date_2', date: DateTime.now()),
      // === MEDIA MESSAGES ===
      // Single image
      DemoMessage.image(
        id: 'd_msg_19',
        imageUrl: _sampleImages[0],
        time: '10:00',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // Image with caption
      DemoMessage.image(
        id: 'd_msg_20',
        imageUrl: _sampleImages[1],
        caption: 'Look at this beautiful sunset I captured yesterday!',
        time: '10:02',
        isOutgoing: false,
      ),
      // Gallery with 2 images
      DemoMessage.gallery(
        id: 'd_msg_21',
        galleryUrls: [_sampleImages[2], _sampleImages[3]],
        time: '10:05',
        isOutgoing: true,
        status: VMessageStatus.delivered,
      ),
      // Gallery with 4+ images
      DemoMessage.gallery(
        id: 'd_msg_22',
        galleryUrls: _sampleImages,
        time: '10:08',
        isOutgoing: false,
      ),
      // Video
      DemoMessage.video(
        id: 'd_msg_23',
        videoUrl: 'https://example.com/video.mp4',
        thumbnailUrl: _sampleImages[0],
        duration: const Duration(minutes: 2, seconds: 45),
        fileSize: 45875200, // 43.7 MB
        time: '10:10',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // Voice message
      DemoMessage.voice(
        id: 'd_msg_24',
        voiceUrl: 'https://example.com/voice.mp3',
        duration: const Duration(seconds: 35),
        time: '10:12',
        isOutgoing: false,
      ),
      // === FILE MESSAGES ===
      // PDF file
      DemoMessage.file(
        id: 'd_msg_25',
        file: VPlatformFile.fromUrl(
          networkUrl: 'https://example.com/Report_2024.pdf',
          fileSize: 2457600, // 2.4 MB
        ),
        time: '10:15',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // File with download progress
      DemoMessage.file(
        id: 'd_msg_26',
        file: VPlatformFile.fromUrl(
          networkUrl: 'https://example.com/presentation.pptx',
          fileSize: 15728640, // 15 MB
        ),
        transferState: VTransferState.downloading,
        transferProgress: 0.65,
        time: '10:17',
        isOutgoing: false,
      ),
      // === LOCATION ===
      DemoMessage.location(
        id: 'd_msg_27',
        locationData: const VLocationData(
          latitude: 40.7128,
          longitude: -74.0060,
          address: 'Central Park, New York, NY',
        ),
        time: '10:20',
        isOutgoing: false,
      ),
      // === CONTACT CARD ===
      DemoMessage.contact(
        id: 'd_msg_28',
        contactData: VContactData(
          name: 'John Smith',
          phoneNumber: '+1-555-987-6543',
          avatar: VPlatformFile.fromUrl(
            networkUrl: 'https://i.pravatar.cc/150?img=8',
          ),
        ),
        time: '10:22',
        isOutgoing: true,
        status: VMessageStatus.delivered,
      ),
      // === PRODUCT BUBBLE (Custom Bubble Example) ===
      DemoMessage.product(
        id: 'd_msg_product_1',
        productData: VProductData(
          productId: 'SKU-12345',
          name: 'Wireless Noise-Cancelling Headphones',
          description: 'Premium audio with 30-hour battery life',
          price: 249.99,
          originalPrice: 349.99,
          image: VPlatformFile.fromUrl(
            networkUrl: 'https://picsum.photos/400/200?random=100',
          ),
          actionLabel: 'View Product',
          rating: 4.5,
          reviewCount: 2847,
        ),
        time: '10:23',
        isOutgoing: false,
      ),
      // === LINK PREVIEW ===
      DemoMessage.linkPreview(
        id: 'd_msg_29',
        text: 'Have you seen the new Flutter docs?',
        linkPreviewData: VLinkPreviewData(
          url: 'https://docs.flutter.dev',
          siteName: 'Flutter',
          title: 'Flutter Documentation',
          description: 'Build beautiful native apps in record time.',
          image: VPlatformFile.fromUrl(
            networkUrl:
                'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
          ),
        ),
        time: '10:25',
        isOutgoing: false,
      ),
      // === QUOTED CONTENT (Story/Product Reply) ===
      // Story reply with image and text
      DemoMessage.quotedContent(
        id: 'd_msg_29a',
        quotedContentData: QuotedContentData(
          title: 'Summer Vibes 2024',
          subtitle: 'Posted 2h ago',
          image: VPlatformFile.fromUrl(networkUrl: _sampleImages[3]),
          contentId: 'story_001',
          extraData: {'type': 'story', 'author': 'john_doe'},
        ),
        text: 'This looks amazing! Where was this taken? 🌅',
        time: '10:26',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // Product share without text
      DemoMessage.quotedContent(
        id: 'd_msg_29b',
        quotedContentData: QuotedContentData(
          title: 'Nike Air Max 2024',
          subtitle: '\$199.99 • Free Shipping',
          image: VPlatformFile.fromUrl(
            networkUrl: 'https://picsum.photos/200/200?random=10',
          ),
          contentId: 'product_001',
          extraData: {'type': 'product', 'sku': 'NK-AM-2024'},
        ),
        time: '10:27',
        isOutgoing: false,
      ),
      // Post share with parsed text (contains URL)
      DemoMessage.quotedContent(
        id: 'd_msg_29c',
        quotedContentData: const QuotedContentData(
          title: 'Flutter 3.20 Released!',
          subtitle: 'flutter.dev • Tech News',
          contentId: 'post_001',
        ),
        text: 'Check this out! More info at https://flutter.dev/whats-new',
        time: '10:28',
        isOutgoing: true,
        status: VMessageStatus.delivered,
      ),
      // === CALL MESSAGES ===
      DemoMessage.call(
        id: 'd_msg_30',
        callData: const VCallData(
          type: VCallType.voice,
          status: VCallStatus.outgoing,
          duration: Duration(minutes: 5, seconds: 32),
        ),
        time: '10:30',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      DemoMessage.call(
        id: 'd_msg_31',
        callData: const VCallData(
          type: VCallType.video,
          status: VCallStatus.missed,
        ),
        time: '10:35',
        isOutgoing: false,
      ),
      // === DELETED MESSAGE ===
      DemoMessage.deleted(id: 'd_msg_32', time: '10:40', isOutgoing: false),
      // === MESSAGE STATUS EXAMPLES ===
      DemoMessage.text(
        id: 'd_msg_33',
        text: 'This message is being sent...',
        time: '10:45',
        isOutgoing: true,
        status: VMessageStatus.sending,
      ),
      DemoMessage.text(
        id: 'd_msg_34',
        text: 'This message was sent.',
        time: '10:46',
        isOutgoing: true,
        status: VMessageStatus.sent,
      ),
      DemoMessage.text(
        id: 'd_msg_35',
        text: 'This message was delivered.',
        time: '10:47',
        isOutgoing: true,
        status: VMessageStatus.delivered,
      ),
      DemoMessage.text(
        id: 'd_msg_36',
        text: 'This message was read.',
        time: '10:48',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
    ];
  }

  /// Build messages for group chat
  static List<DemoMessage> buildGroupChat() {
    return [
      // Date chip - Yesterday
      DemoMessage.dateChip(
        id: 'date_1',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      // System message
      DemoMessage.system(
        id: 'sys_1',
        text: 'Alice created the group "Flutter Devs"',
      ),
      DemoMessage.system(id: 'sys_2', text: 'Bob joined the group'),
      DemoMessage.system(id: 'sys_3', text: 'Charlie joined the group'),
      // === GROUP CONVERSATION ===
      DemoMessage.text(
        id: 'g_msg_1',
        text: 'Hey everyone! Welcome to the Flutter Devs group!',
        time: '09:00',
        isOutgoing: false,
        senderName: 'Alice',
        avatar: _aliceAvatar,
        senderColor: _aliceColor,
      ),
      DemoMessage.text(
        id: 'g_msg_2',
        text: 'Thanks for adding me! Excited to be here.',
        time: '09:01',
        isOutgoing: false,
        senderName: 'Bob',
        avatar: _bobAvatar,
        senderColor: _bobColor,
      ),
      DemoMessage.text(
        id: 'g_msg_3',
        text: 'Hello everyone! Looking forward to learning together.',
        time: '09:02',
        isOutgoing: false,
        senderName: 'Charlie',
        avatar: _charlieAvatar,
        senderColor: _charlieColor,
      ),
      // Outgoing message (me)
      DemoMessage.text(
        id: 'g_msg_4',
        text: 'Great to have you all here! Let\'s build something amazing!',
        time: '09:03',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // Long text from group member
      DemoMessage.text(
        id: 'g_msg_5',
        text:
            '''I've been working on a new Flutter package for chat bubbles. It supports multiple styles like Telegram, WhatsApp, Messenger, and iMessage.

The package includes features like:
- Custom bubble shapes and colors
- Message reactions with emojis
- Reply previews
- Forward indicators
- Text expansion for long messages
- RTL language support
- And much more!

Let me know if you want to test it out!''',
        time: '09:05',
        isOutgoing: false,
        senderName: 'Alice',
        avatar: _aliceAvatar,
        senderColor: _aliceColor,
      ),
      // Reactions on message
      DemoMessage.text(
        id: 'g_msg_6',
        text: 'That sounds amazing! Count me in!',
        time: '09:07',
        isOutgoing: false,
        senderName: 'Bob',
        avatar: _bobAvatar,
        senderColor: _bobColor,
        reactions: const [
          VBubbleReaction(emoji: '👍', count: 3, isSelected: true),
          VBubbleReaction(emoji: '🎉', count: 2),
          VBubbleReaction(emoji: '❤️', count: 1),
        ],
      ),
      // === PATTERN TESTS IN GROUP ===
      DemoMessage.text(
        id: 'g_msg_7',
        text:
            'Check out the documentation: https://docs.flutter.dev/ui/widgets',
        time: '09:10',
        isOutgoing: false,
        senderName: 'Charlie',
        avatar: _charlieAvatar,
        senderColor: _charlieColor,
      ),
      DemoMessage.text(
        id: 'g_msg_8',
        text:
            'For any issues, email us at support@flutterdevs.com or call +1-800-FLUTTER',
        time: '09:12',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // Custom patterns
      DemoMessage.text(
        id: 'g_msg_9',
        text:
            'Bug report TKT-54321 has been filed. Related to order ORD#12345.',
        time: '09:15',
        isOutgoing: false,
        senderName: 'Diana',
        avatar: _dianaAvatar,
        senderColor: _dianaColor,
      ),
      DemoMessage.text(
        id: 'g_msg_10',
        text: 'Invoice INV-2024-999 sent. Multiple refs: TKT-11111, ORD#22222',
        time: '09:17',
        isOutgoing: false,
        senderName: 'Eve',
        avatar: _eveAvatar,
        senderColor: _eveColor,
      ),
      // === ARABIC TEXT IN GROUP ===
      DemoMessage.text(
        id: 'g_msg_11',
        text: 'مرحبا بالجميع! أنا سعيد بالانضمام إلى هذه المجموعة.',
        time: '09:20',
        isOutgoing: false,
        senderName: 'Charlie',
        avatar: _charlieAvatar,
        senderColor: _charlieColor,
      ),
      DemoMessage.text(
        id: 'g_msg_12',
        text:
            '''هذه رسالة طويلة باللغة العربية لاختبار كيفية عرض النصوص الطويلة من اليمين إلى اليسار في المحادثات الجماعية. يجب أن يظهر اسم المرسل والصورة الرمزية بشكل صحيح بجانب الفقاعة.

الكتابة العربية من أقدم أنظمة الكتابة في العالم، وتستخدم في العديد من اللغات بما في ذلك العربية والفارسية والأردية.''',
        time: '09:22',
        isOutgoing: false,
        senderName: 'Bob',
        avatar: _bobAvatar,
        senderColor: _bobColor,
      ),
      // Mixed language
      DemoMessage.text(
        id: 'g_msg_13',
        text:
            'أنا أعمل على Flutter project جديد - إنه رائع! Check it out: https://github.com/example',
        time: '09:25',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // === REPLY IN GROUP ===
      DemoMessage.text(
        id: 'g_msg_14',
        text: 'I\'d love to help test this!',
        time: '09:30',
        isOutgoing: false,
        senderName: 'Diana',
        avatar: _dianaAvatar,
        senderColor: _dianaColor,
        replyTo: const VReplyData(
          originalMessageId: 'g_msg_5',
          senderId: 'alice',
          senderName: 'Alice',
          senderColor: _aliceColor,
          previewText:
              'I\'ve been working on a new Flutter package for chat bubbles...',
        ),
      ),
      // Reply to yourself
      DemoMessage.text(
        id: 'g_msg_15',
        text: 'Here\'s the GitHub link!',
        time: '09:32',
        isOutgoing: true,
        status: VMessageStatus.read,
        replyTo: const VReplyData(
          originalMessageId: 'g_msg_2',
          senderId: 'me',
          senderName: 'You',
          previewText:
              'Great to have you all here! Let\'s build something amazing!',
        ),
      ),
      // === FORWARDED MESSAGE ===
      DemoMessage.text(
        id: 'g_msg_16',
        text:
            'IMPORTANT: Flutter 3.19 is now released with major performance improvements!',
        time: '09:35',
        isOutgoing: false,
        senderName: 'Eve',
        avatar: _eveAvatar,
        senderColor: _eveColor,
        forwardedFrom: VForwardData(
          originalMessageId: 'flutter_news_001',
          originalSenderName: 'Flutter Official',
          originalTime: DateTime.now().subtract(const Duration(hours: 5)),
        ),
      ),
      // === EDITED MESSAGE ===
      DemoMessage.text(
        id: 'g_msg_17',
        text: 'Fixed the typo in my previous message (edited)',
        time: '09:38',
        isOutgoing: false,
        senderName: 'Alice',
        avatar: _aliceAvatar,
        senderColor: _aliceColor,
        isEdited: true,
      ),
      // Date chip - Today
      DemoMessage.dateChip(id: 'date_2', date: DateTime.now()),
      DemoMessage.system(id: 'sys_4', text: 'Diana added Eve to the group'),
      // === MEDIA IN GROUP ===
      // Image with sender info
      DemoMessage.image(
        id: 'g_msg_18',
        imageUrl: _sampleImages[0],
        time: '10:00',
        isOutgoing: false,
        senderName: 'Bob',
        avatar: _bobAvatar,
        senderColor: _bobColor,
      ),
      // Image with caption
      DemoMessage.image(
        id: 'g_msg_19',
        imageUrl: _sampleImages[1],
        caption: 'Check out this new UI design I made for the app!',
        time: '10:02',
        isOutgoing: false,
        senderName: 'Alice',
        avatar: _aliceAvatar,
        senderColor: _aliceColor,
        reactions: const [
          VBubbleReaction(emoji: '😍', count: 2),
          VBubbleReaction(emoji: '🔥', count: 3, isSelected: true),
        ],
      ),
      // Outgoing image
      DemoMessage.image(
        id: 'g_msg_20',
        imageUrl: _sampleImages[2],
        caption: 'Here\'s my contribution!',
        time: '10:05',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // Gallery from group member
      DemoMessage.gallery(
        id: 'g_msg_21',
        galleryUrls: [_sampleImages[3], _sampleImages[4], _sampleImages[5]],
        time: '10:10',
        isOutgoing: false,
        senderName: 'Charlie',
        avatar: _charlieAvatar,
        senderColor: _charlieColor,
      ),
      // Video
      DemoMessage.video(
        id: 'g_msg_22',
        videoUrl: 'https://example.com/tutorial.mp4',
        thumbnailUrl: _sampleImages[0],
        duration: const Duration(minutes: 15, seconds: 30),
        fileSize: 157286400, // 150 MB
        caption: 'Flutter tutorial on state management',
        time: '10:15',
        isOutgoing: false,
        senderName: 'Diana',
        avatar: _dianaAvatar,
        senderColor: _dianaColor,
      ),
      // Voice message
      DemoMessage.voice(
        id: 'g_msg_23',
        voiceUrl: 'https://example.com/voice.mp3',
        duration: const Duration(minutes: 1, seconds: 15),
        time: '10:20',
        isOutgoing: false,
        senderName: 'Eve',
        avatar: _eveAvatar,
        senderColor: _eveColor,
      ),
      // === FILES IN GROUP ===
      DemoMessage.file(
        id: 'g_msg_24',
        file: VPlatformFile.fromUrl(
          networkUrl: 'https://example.com/Flutter_Guidelines.pdf',
          fileSize: 1048576, // 1 MB
        ),
        time: '10:25',
        isOutgoing: false,
        senderName: 'Alice',
        avatar: _aliceAvatar,
        senderColor: _aliceColor,
      ),
      DemoMessage.file(
        id: 'g_msg_25',
        file: VPlatformFile.fromUrl(
          networkUrl: 'https://example.com/project.zip',
          fileSize: 52428800, // 50 MB
        ),
        transferState: VTransferState.downloading,
        transferProgress: 0.45,
        time: '10:27',
        isOutgoing: false,
        senderName: 'Bob',
        avatar: _bobAvatar,
        senderColor: _bobColor,
      ),
      // === POLL IN GROUP ===
      DemoMessage.poll(
        id: 'g_msg_26',
        pollData: const VPollData(
          question: 'Which state management solution do you prefer?',
          options: [
            VPollOption(
              id: '1',
              text: 'Riverpod',
              voteCount: 8,
              percentage: 0.40,
              isSelected: true,
            ),
            VPollOption(id: '2', text: 'BLoC', voteCount: 6, percentage: 0.30),
            VPollOption(
              id: '3',
              text: 'Provider',
              voteCount: 4,
              percentage: 0.20,
            ),
            VPollOption(id: '4', text: 'GetX', voteCount: 2, percentage: 0.10),
          ],
          mode: VPollMode.single,
          totalVotes: 20,
          hasVoted: true,
        ),
        time: '10:30',
        isOutgoing: false,
        senderName: 'Charlie',
        avatar: _charlieAvatar,
        senderColor: _charlieColor,
      ),
      // Quiz poll
      DemoMessage.poll(
        id: 'g_msg_27',
        pollData: const VPollData(
          question: 'What is the correct syntax for a stateless widget?',
          options: [
            VPollOption(
              id: '1',
              text: 'class MyWidget extends Widget',
              voteCount: 2,
              percentage: 0.10,
            ),
            VPollOption(
              id: '2',
              text: 'class MyWidget extends StatelessWidget',
              voteCount: 16,
              percentage: 0.80,
              isCorrect: true,
              isSelected: true,
            ),
            VPollOption(
              id: '3',
              text: 'class MyWidget implements Widget',
              voteCount: 2,
              percentage: 0.10,
            ),
          ],
          mode: VPollMode.quiz,
          totalVotes: 20,
          hasVoted: true,
        ),
        time: '10:35',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // === LOCATION ===
      DemoMessage.location(
        id: 'g_msg_28',
        locationData: const VLocationData(
          latitude: 37.7749,
          longitude: -122.4194,
          address: 'Moscone Center, San Francisco, CA',
        ),
        time: '10:40',
        isOutgoing: false,
        senderName: 'Diana',
        avatar: _dianaAvatar,
        senderColor: _dianaColor,
      ),
      // === CONTACT CARD ===
      DemoMessage.contact(
        id: 'g_msg_29',
        contactData: VContactData(
          name: 'Flutter Team',
          phoneNumber: '+1-555-FLUTTER',
          avatar: VPlatformFile.fromUrl(
            networkUrl: 'https://i.pravatar.cc/150?img=10',
          ),
        ),
        time: '10:42',
        isOutgoing: false,
        senderName: 'Eve',
        avatar: _eveAvatar,
        senderColor: _eveColor,
      ),
      // === LINK PREVIEW ===
      DemoMessage.linkPreview(
        id: 'g_msg_30',
        text: 'Check out the official Flutter YouTube channel!',
        linkPreviewData: VLinkPreviewData(
          url: 'https://youtube.com/c/flutterdev',
          siteName: 'YouTube',
          title: 'Flutter - YouTube',
          description:
              'Official Flutter YouTube channel with tutorials and updates.',
          image: VPlatformFile.fromUrl(
            networkUrl: 'https://picsum.photos/400/200?random=10',
          ),
        ),
        time: '10:45',
        isOutgoing: false,
        senderName: 'Alice',
        avatar: _aliceAvatar,
        senderColor: _aliceColor,
      ),
      // === QUOTED CONTENT (Story/Product Reply) ===
      // Story reply from group member
      DemoMessage.quotedContent(
        id: 'g_msg_30a',
        quotedContentData: QuotedContentData(
          title: 'FlutterConf 2024 Highlights',
          subtitle: 'Posted by @flutterdev',
          image: VPlatformFile.fromUrl(networkUrl: _sampleImages[4]),
          contentId: 'story_flutter_conf',
        ),
        text: 'Who else is attending this year? 🎉',
        time: '10:46',
        isOutgoing: false,
        senderName: 'Bob',
        avatar: _bobAvatar,
        senderColor: _bobColor,
      ),
      // Product recommendation
      DemoMessage.quotedContent(
        id: 'g_msg_30b',
        quotedContentData: QuotedContentData(
          title: 'Flutter Complete Reference',
          subtitle: '\$49.99 • eBook',
          image: VPlatformFile.fromUrl(
            networkUrl: 'https://picsum.photos/200/200?random=15',
          ),
          contentId: 'product_book',
          extraData: {'type': 'product', 'category': 'books'},
        ),
        text: 'This book is great for beginners!',
        time: '10:47',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      // === CALL MESSAGES ===
      DemoMessage.call(
        id: 'g_msg_31',
        callData: const VCallData(
          type: VCallType.video,
          status: VCallStatus.outgoing,
          duration: Duration(minutes: 45),
        ),
        time: '10:50',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      DemoMessage.call(
        id: 'g_msg_32',
        callData: const VCallData(
          type: VCallType.voice,
          status: VCallStatus.missed,
        ),
        time: '10:55',
        isOutgoing: false,
        senderName: 'Bob',
        avatar: _bobAvatar,
        senderColor: _bobColor,
      ),
      // === DELETED MESSAGE ===
      DemoMessage.deleted(id: 'g_msg_33', time: '11:00', isOutgoing: false),
      // System message
      DemoMessage.system(
        id: 'sys_5',
        text: 'Charlie changed the group name to "Flutter Masters"',
      ),
      // === FINAL MESSAGES ===
      DemoMessage.text(
        id: 'g_msg_34',
        text:
            'That\'s all the message types! Try switching styles and themes to see how they look.',
        time: '11:05',
        isOutgoing: true,
        status: VMessageStatus.read,
      ),
      DemoMessage.text(
        id: 'g_msg_35',
        text:
            'This demo shows the full capabilities of v_chat_bubbles package!',
        time: '11:06',
        isOutgoing: false,
        senderName: 'Alice',
        avatar: _aliceAvatar,
        senderColor: _aliceColor,
        reactions: const [
          VBubbleReaction(emoji: '🎉', count: 5, isSelected: true),
          VBubbleReaction(emoji: '👏', count: 4),
          VBubbleReaction(emoji: '❤️', count: 3),
        ],
      ),
    ];
  }

  /// Build all messages (legacy method - uses group chat)
  static List<DemoMessage> buildAll() {
    return buildGroupChat();
  }
}
