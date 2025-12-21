1. inside the class OptimizedNetworkImage extends StatelessWidget { 
change the  final String url; to user the VPlatformFile and do your conditions to render it correct inside 
this widget like if isFromFIle is From url render correspond image source to it 

2. inside  the class ReplyData { update the  final String? previewImageUrl; to use VPlatformFile and render it by the widget of OptimizedNetworkImage give it the previewImageUrl as VPlatformFile and it will render it correct we should use it to render all like avatar or any images  als do it for the  String? avatarUrl, for all to be  VPlatformFile? avatarUrl, 

3. to class ForwardData { add originalMessageId  and remove the   final String originalSenderId; we dont need it 

4. for class LinkPreviewData { update the   final  String? imageUrl;  to be VPlatformFile and the render of it will be by the OptimizedNetworkImage which takes the VPlatformFile and render the correspond image 
also for  /// Avatar URL for automatic avatar generation
   final String? avatarUrl; update it to use the  VPlatformFile
5. class ContactData {  final String? avatarUrl; to use VPlatformFile avatarUrl

6. for /// Message delivery status
       enum MessageStatus { we need to delete pending, the sending is enough to use 
7. inside the abstract class BaseBubble extends StatelessWidget {   /// Sender avatar widget (for incoming messages in groups)
   final Widget? avatar; also change the   Widget _buildLinkPreviewImage({ to be OptimizedNetworkImage so we unify every image render to be OptimizedNetworkImage with take the param of VPlatformFile imageSource
/// Avatar URL for automatic avatar generation
final String? avatarUrl; keep only one of theme keep the  
final String? avatarUrl; and use VPlatformFile? avatarUrl 

8. i need to do big change here support user to enter a custom pattern for TextParser.parse( so it be color as he want current we support fixed parser regex like enableLinks
   enablePhone
   enableEmail
   enableMentions 
we need to take list of regex from the user with the color of it, and internally we match it for the text bubble then render text span correspond to the match of it and when it clicked there are callback to retrun back to him the pattern and the name of the pattern and the text itself which matched the click on it so he can do what he want and we will provide per build pattern you you show now so user can set it to the list of detections this will be very great ultra think   
9. the colors of the buttons and speed builder not appear it seem to be the same color with the background voice color it should be different so i can see it fix its ui/ux based on each style for whatsapp,telegram etc... also study the voice package more and more to understand it well ! 
10. there are problem with the tap of the bubble it appears to be as the opening of the context menu we should difference between the tap on the item and the long press to show the context menu 

11. add full map to the ui update and theme and config for the VVoiceMessageView
    VVoiceMessageView(
    controller: controller,
    colorConfig: VoiceColorConfig(
    activeSliderColor: isMeSender
    ? theme.outgoingWaveformPlayedColor
    : theme.incomingWaveformPlayedColor,
    notActiveSliderColor: isMeSender
    ? theme.outgoingWaveformColor
    : theme.incomingWaveformColor,
    ),
    containerConfig: const VoiceContainerConfig(
    backgroundColor: Colors.transparent,
    containerPadding: EdgeInsets.zero,
    borderRadius: 0,
    ),
              visualizerConfig: VoiceVisualizerConfig(barCount: 25),
            ),
so the user can see and update it very well 

12. we need to add page for full see the media for image to open the image and for video to  open a page to play the video use the video_player: ^2.10.1 if the user not provide the callback of it if he provide then not open the internal player 
13. we need to add a way so user can add there custom bubble based on the theme of abstract class BaseBubble extends StatelessWidget { so create custom bubble widget user can extends it to create his bubble version and pass it 
14. when i change the language to be AR which is RTL you should not apply this to the message itself inside the bubble for example there are english text inside the bubble you force the RTL to it which is never good you should do the RTL based on the text inside the bubble so fix all ! =>DONE 
15. add click action tab to the user profile and the name of it to callback which is the user clicked 
16. we need to inverstage more time inside the longpress function of show the context menu tell me how it works 
