import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/theme/text.dart';
import 'package:teatalk/view/widget/link_btn.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: kTextStyle.copyWith(
              fontFamily: 'Graphie', fontSize: 16, color: Colors.black),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kMarginMedium2,
        ),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: kMarginMedium2,
              ),
              Center(
                child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Privacy Policy of TeaTalk App',
                          style: kTextStyle.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 20))
                    ])),
              ),
              const SizedBox(
                height: kMarginMedium2,
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(children: [
                  TextSpan(
                      text: 'What is TeaTalk?',
                      style: kTextStyle.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 16))
                ]),
              ),
              const SizedBox(
                height: 6,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(children: [
                  TextSpan(
                      text: whatIsTeaTalkDes,
                      style: kTextStyle.copyWith(
                          fontWeight: FontWeight.w400, fontSize: 14))
                ]),
              ),
              const SizedBox(
                height: kMarginMedium2,
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(children: [
                  TextSpan(
                      text:
                          'Privacy Policy for TeaTalk Social Media Application',
                      style: kTextStyle.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 16))
                ]),
              ),
              const SizedBox(
                height: 6,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(children: [
                  TextSpan(
                      text: privacyPolicyForTTSMA,
                      style: kTextStyle.copyWith(
                          fontWeight: FontWeight.w400, fontSize: 14))
                ]),
              ),
              const SizedBox(
                height: kMarginMedium2,
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(children: [
                  TextSpan(
                      text: 'Information We Collect (KYC)',
                      style: kTextStyle.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 16))
                ]),
              ),
              const SizedBox(
                height: 6,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(children: [
                  TextSpan(
                      text: kycDes,
                      style: kTextStyle.copyWith(
                          fontWeight: FontWeight.w400, fontSize: 14))
                ]),
              ),
              const SizedBox(
                height: kMarginMedium2,
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(children: [
                  TextSpan(
                      text: 'Information Collection and Use',
                      style: kTextStyle.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 16))
                ]),
              ),
              const SizedBox(
                height: 6,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(children: [
                  TextSpan(
                      text: infomationCollectionAndUse,
                      style: kTextStyle.copyWith(
                          fontWeight: FontWeight.w400, fontSize: 14))
                ]),
              ),
              const SizedBox(
                height: kMarginMedium2,
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(children: [
                  TextSpan(
                      text: 'Information You Provide to Us',
                      style: kTextStyle.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 16))
                ]),
              ),
              const SizedBox(
                height: 6,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(children: [
                  TextSpan(
                      text: infoYouProviedToUs,
                      style: kTextStyle.copyWith(
                          fontWeight: FontWeight.w400, fontSize: 14))
                ]),
              ),
              const SizedBox(
                height: kMarginMedium2,
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(children: [
                  TextSpan(
                      text: 'Information We Collect Automatically',
                      style: kTextStyle.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 16))
                ]),
              ),
              const SizedBox(
                height: 6,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(children: [
                  TextSpan(
                      text: infoWeCollectAutomatically,
                      style: kTextStyle.copyWith(
                          fontWeight: FontWeight.w400, fontSize: 14))
                ]),
              ),
              const SizedBox(
                height: kMarginMedium2,
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(children: [
                  TextSpan(
                      text: 'Information Collected by Third Parties',
                      style: kTextStyle.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 16))
                ]),
              ),
              const SizedBox(
                height: 6,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(children: [
                  TextSpan(
                      text: infoCollectByThirdParties,
                      style: kTextStyle.copyWith(
                          fontWeight: FontWeight.w400, fontSize: 14))
                ]),
              ),
              const SizedBox(
                height: kMarginMedium2,
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(children: [
                  TextSpan(
                      text:
                          'Information Collected from Advertisers and Potential Advertisers',
                      style: kTextStyle.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 16))
                ]),
              ),
              const SizedBox(
                height: 6,
              ),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(children: [
                  TextSpan(
                      text: infoCollectedFromAdvertiserAndPotentialAdv,
                      style: kTextStyle.copyWith(
                          fontWeight: FontWeight.w400, fontSize: 14))
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kMarginMedium2),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Use of Information',
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(children: [
                    TextSpan(
                        text: useOfInfomationDes,
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kMarginMedium2),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Information Sharing and Disclosure:',
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(children: [
                    TextSpan(
                        text: infoSharingAndDisclosure,
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kMarginMedium2),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Your Rights, Choices, and Controls:',
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(children: [
                    TextSpan(
                        text: yourRightsChoicesAndControls,
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kMarginMedium2),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Data Security and Protection:',
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(children: [
                    TextSpan(
                        text: dataSecurityAndProtection,
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kMarginMedium2),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Cookies and Tracking Technologies:',
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(children: [
                    TextSpan(
                        text: cookiesAndTracking,
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kMarginMedium2),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: [
                    TextSpan(
                        text:
                            'Third-Party Links, Services, and Service Providers:',
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(children: [
                    TextSpan(
                        text: thirdPartiesLinksServicesAndProviders,
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kMarginMedium2),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Log Data:',
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(children: [
                    TextSpan(
                        text: logData,
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kMarginMedium2),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Consent and Acceptance',
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(children: [
                    TextSpan(
                        text: consentAndAcceptance,
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kMarginMedium2),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Children’s Privacy',
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(children: [
                    TextSpan(
                        text: childrenPrivacy,
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kMarginMedium2),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Refund Policy for TeaTalk App',
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(children: [
                    TextSpan(
                        text: refundPolicy,
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kMarginMedium2),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Promotion Policies',
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(children: [
                    TextSpan(
                        text: promotionPolicy,
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kMarginMedium2),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'AI Machine Translation',
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(children: [
                    TextSpan(
                        text: aiMachineTranslation,
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kMarginMedium2),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Changes to this Policy',
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(children: [
                    TextSpan(
                        text: changesToThisPolicy,
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kMarginMedium2),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Contact Us',
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(children: [
                    TextSpan(
                        children: [
                          const TextSpan(text: contactUs),
                          linkButtonWidget('teatalk.umg.dev@gmail.com',
                              () async {
                            print('ON TAP EMAIL');
                            await Clipboard.setData(const ClipboardData(
                                    text: 'teatalk.umg.dev@gmail.com'))
                                .then((value) => AoLib.instance
                                    .showToast("Copy To Clipboard"));
                          }),
                       
                        ],
                        // text: contactUs,
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14))
                  ]),
                ),
              ),
              const SizedBox(
                height: 64,
              )
            ],
          ),
        ),
      ),
    );
  }
}

const contactUs =
    "If you have any questions or concerns about our privacy policy, please contact us at ";

const String changesToThisPolicy =
    "We reserve the right to make changes to this Privacy Policy at any time and for any reason. We will alert you about any changes by updating the “Latest Updated” date of this Privacy Policy. Any changes or modifications will be effective immediately upon posting the updated Privacy Policy on the Application, and you waive the right to receive specific notice of each such change or modification.\n\nThis policy is effective as of 2023-04-03.";

const String aiMachineTranslation =
    "Data Collection: When you use the machine translation feature in TeaTalk Community, the text you enter may be collected and processed by our machine translation software. This data may include personal information if you have entered any in the text.\n\nData Usage: The data collected by the machine translation feature is used solely for the purpose of providing the translation service to you. The translated text may be stored in our system for a certain period of time to improve the quality of the translation service.\n\nData Sharing: We do not share your translated data with any third parties unless required by law. However, we may use the data to improve our machine translation software and service.\n\nData Security: We take reasonable measures to protect your data from unauthorized access, use, and disclosure. However, we cannot guarantee the security of your data as no method of transmission over the internet or method of electronic storage is completely secure.\n\nOpt-Out: You can opt-out of using the machine translation feature at any time by not using the feature or disabling it in your TeaTalk Community settings.\n\nAccuracy of translations: While we strive to provide accurate translations, please note that translations may not be perfect and may contain errors or missions. We are not responsible for any inaccuracies or errors in translations.\n\nUser responsibility: Users are responsible for reviewing translations and verifying their accuracy before using or relying on them.\n\nData privacy: We will take all reasonable measures to ensure the privacy and security of any data that is processed or transmitted through our AI Machine Translation features.\n\nTermination of service: We reserve the right to terminate or modify our AI Machine Translation features at any time, without notice or liability.";

const String promotionPolicy =
    "Purpose: This Policy outlines the guideline for promoting content on our social media platform in a fair and ethical manner.\nPromotion Guidelines: We allow our users to promote their content on our platform, provided they adhere to the following guidelines:\n•	Content promoted mush comply with our term of service, community guidelines, and other applicable laws and regulations.\n•	Promoted content must not contain false or misleading information or make false claims.\n•	Promoted content must be transparently labeled as “promoted” or sponsored” to clearly distinguish it from organic content.\n•	Promotions must not target minors or vulnerable groups.\n•	Promotions must not be deceptive or use tactics to trick or mislead users into taking a particular action.\n•	Promotions must not contain hate speech, discriminatory content, or any other type of offensive content.\n•	Promotions must not infringe upon the intellectual property rights of others.\n\nReview Process: All promoted content will be subject to review by our team before it is approved to be displayed on our platform. We reserve the right to reject any content that violates our guidelines or standards.\n\nPromotion fees: We charge fees for promoting content on our platform. Fees vary depending on the type and duration of the promotion. Users will be notified of the fees at the time of promotion.\n\nRefunds: Promotion fees are non-refundable, except in cases where a promotion has been rejected by our team or canceled by the user before it has been published.\n\nChanges to the Promotion Policy: We reserve the right to modify this promotion policy at any time. Uses will be notified of any changes through our website or by email.\n\nBy using our platform, users agree to comply with this promotion policy and all other applicable policies and guidelines. Failure to comply with this policy may result in the removal of promoted content and/or suspension or termination of a user’s account.";

const String refundPolicy =
    "At TeaTalk, we strive to provide the best possible user experience on our platform. If for any reason you are not satisfied with your purchase of ICE (in-app currency) or Stickers on our TeaTalk Platform, we offer a refund policy as follows:\n●	If you wish to request a refund, you must do so within 24 hours of your purchase (in terms of internet confirmation, server error, or any other risks).\n●	Refund requests made after 24 hours of your purchase will not be accepted.\n●	To request a refund, please contact our customer support team with your purchase details.\n●	Refunds will be issued using the same payment method used for the original purchase through (e.g. KBZPay, AYAPay, or other payment method).\n●	No-refund for deleted stickers, thus we would like to suggest to consider carefully before delete any stickers.\n";

const String childrenPrivacy =
    "These Services do not address anyone under the age of 18. We do not knowingly collect personally identifiable information from children under 18 years of age. In the case we discover that a child under 18 has provided us with personal information, we immediately delete this information from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do the necessary actions.";

const String consentAndAcceptance =
    "By using our TeaTalk platform, you consent to the terms of this privacy policy, collection data and use of this information in accordance with this Policy.";

const String logData =
    "Our Platform collects log data when you use our Service, including information such as your device's IP address, browser type, browser version, visited pages, timestamps, unique device identifiers, and other diagnostic data. This data is utilized to monitor platform performance, analyze usage patterns, and address technical issues. In case of app errors, we may also collect Log Data, including your device's IP address, device name, operating system version, app configuration, timestamps, and other statistics. Log Data may be shared with our service providers and business partners. By combining these passages, the information regarding the collection and use of Log Data is presented concisely. The purpose of collecting log data, its various components, and the sharing practices are explained, providing a comprehensive understanding of how this information is utilized within the platform.";

const String thirdPartiesLinksServicesAndProviders =
    "Third-Party Links and Services:\n•	Our app may include links to third-party websites or services.\n•	These third-party entities have their own privacy policies and practices.\n•	Before using them, it is recommended to review their privacy policies.\n•	We are not responsible for the privacy practices of these third-party websites or services.\n\nService Providers:\n•	We may engage third-party companies and individuals for various reasons.\n•	They may facilitate, provide, or perform services related to our app.\n•	These service providers may have access to users' Personal Information.\n•	Their access is limited to fulfilling assigned tasks and obligations.\nLinks to Other Sites:\n•	The app may contain links to external sites not operated by us.\n•	Clicking on a third-party link will redirect you to that site.\n•	We advise reviewing the privacy policies of these websites.\n•	We have no control over the content, privacy policies, or practices of third-party sites";

const String cookiesAndTracking =
    "Use of Cookies and Tracking Technologies:\n•	We utilize cookies and other tracking technologies to gather information about your app usage.\n•	The collected information includes browsing history, search queries, and device details.\n•	This data is used to personalize your app experience, display relevant content and advertisements, and analyze usage patterns.\n\nDefinition and Function of Cookies:\n•	Cookies are small data files commonly used as anonymous identifiers.\n•	They are sent to your browser from visited websites and stored in your device's memory.\n•	While this app itself does not use cookies explicitly, third-party code and libraries incorporated in the app may employ cookies to enhance their services.\n\nUser Control over Cookies:\n•	You have the choice to accept or decline cookies.\n•	By refusing our cookies, certain parts of the app may become inaccessible.\n•	You can configure your device to notify you when a cookie is being sent.";

const String dataSecurityAndProtection =
    "Measures Taken to Protect Information:\n•	We implement reasonable measures to safeguard your information against unauthorized access, use, or disclosure.\n•	Information about you is protected from loss, theft, misuse, unauthorized access, alteration, and destruction.\n•	Technical and administrative access controls are enforced to limit employee access to nonpublic personal information.\n•	During transmission, HTTPS is utilized to ensure secure data transfer.\n\nLimitations of Security:\n•	While we strive to use commercially acceptable means of protecting your Personal Information, no method of transmission or electronic storage is 100% secure.\n•	Absolute security and reliability cannot be guaranteed over the internet.\n\nUser Responsibility for Account Security:\n•	You can contribute to the security of your account by configuring two-factor authentication.\n\nData Retention:\n•	Information collected is stored for the duration necessary for the original purpose(s) of collection.\n•	Certain information may be retained for legitimate business purposes or as required by law.\nWe take reasonable measures to protect your information from unauthorized access, use, or disclosure. However, no method of transmission over the internet or electronic storage is completely secure, and we cannot guarantee absolute security.";

const String yourRightsChoicesAndControls =
    "Accessing and Changing Information:\n•	You can access and modify certain information through the Services.\n•	Instructions can be found in the Help Center page.\n•	You can request a copy of your personal information or deletion of your account following the described process.\n\nDeleting Your Account:\n•	You can delete your account information from the My Diary page.\n•	Deleting your account makes your profile invisible to others and dissociates your posted content, except for reactions, stickers, posts, comments, and messages.\n•	It may take up to 90 days for complete deletion, and certain information may be retained as required by law or for legitimate purposes.\n\nControlling Linked Services' Access:\n•	Review and revoke access to individual services through the Apps page and Connected Accounts section in Account Settings.\n\nOpting Out of Targeted Advertising:\nOpt out of personalized ads by visiting the Safety & Privacy section in User Settings (desktop) or Account Settings (mobile app).\nControlling the Use of Cookies:\n•	Adjust your browser settings to remove or reject first- and third-party cookies.\n•	Note that this may affect the availability and functionality of our Services.\n•	See our Cookie Notice for more information.\n\nControlling Advertising and Analytics:\n•	Some analytics providers offer opt-out mechanisms, and additional tools and services are available to manage information collection.\n•	Examples include the Google Analytics Opt-out Browser Add-on and opting out of Audience Measurement services by Nielsen and Quantcast.\n•	Visit the Digital Advertising Alliance and the Network Advertising Initiative for personalized ad opt-out options.\n\nDo Not Track:\n•	Sending a Do Not Track signal via web browsers is not responded to directly.\n•	Instead, the choices described in this policy help manage information collection and use.\n•	Controlling Promotional Communications:\n•	Opt out of promotional communications by following instructions in the communications or updating email options in account preferences.\n•	Non-promotional communications related to account or Service usage may still be received.\n\nControlling Mobile Notifications:\n•	Manage push notifications or alerts by adjusting notification settings on your mobile device.\n\nControlling Location Information:\n•	Manage the use of location information inferred from your IP address via Safety and Privacy settings.\n\nRequesting Assistance or Appeals:\n•	For questions or assistance with rights, contact teatalk.umg.dev@gmail.com or submit a request.\n•	Verification of requests may be required through TeaTalk account access or verified email address.\n•	If a request is denied, appeals can be made by contacting teatalk.umg.dev@gmail.com.\n\nNote: The information you provide will be retained and used as described in the privacy policy. The TeaTalk app utilizes third-party services, and their privacy policies should be referenced.\n\nYour Choices:\n•	Update account information in the Application.\n•	Adjust device settings to limit information collection.\n•	Opt out of personalized ads using instructions from the ads network.\n";

const String infoSharingAndDisclosure =
    "We share information in the following ways:\n\nPublic Sharing:\n•	Information on the Services is public and accessible to all TeaTalk account holders.\n•	When you submit content to public parts of the Services, it can be seen by other users, including the content, associated username, and submission date and time.\n•	TeaTalk allows embedding of public content on other sites and grants access to public content through the TeaTalk API.\n\nProfile Information:\n•	Your TeaTalk profile page is public and contains information such as your username, previous posts and comments, shared media, friend list, bio, date of birth, marital status, region, current city, gender, and membership duration.\n\nSocial Sharing:\n•	We provide social sharing features that allow you to share content or actions from our Services with other platforms.\n•	Your use of these features may share information with your friends or the public based on the settings you establish with the third-party social sharing service.\n\nConsent and Linked Services:\n•	We may share information about you with your consent or as directed by you.\n•	If you link your TeaTalk account with a third-party service, authorized information will be shared with that service, and you can control this sharing.\n\nService Providers:\n•	We share information with vendors, consultants, and service providers who require access to carry out work on our behalf.\n•	Examples include payment processors, cloud providers, and third-party ad measurement providers.\n\nLegal Compliance and Emergencies:\n•	We may share information in response to a request complying with applicable laws, regulations, legal processes, or governmental requirements.\n•	In emergency situations to prevent imminent harm or protect rights, property, and safety.\n•	To enforce our policies, User Agreement, rules, or protect ourselves and others.\n\nAffiliates:\n•	We may share information between TeaTalk and our parent, affiliate, subsidiary, and related companies.\nAggregated or De-identified Information:\n•	We may share aggregated or anonymized information that cannot reasonably identify you, such as total post reactions or ad impressions.\n\nBusiness Transfers:\n•	In connection with a merger, acquisition, or sale of our assets, your information may be shared.\n\nLaw Enforcement and Government Authorities:\n•	We may share information when required by law or in response to a subpoena or other legal process.\n\nPlease note that we do not sell your personal information.\n";

const String useOfInfomationDes =
    "We collect information to:\n•	Provide and improve the Application and our services.\n•	Customize your experience on the Application.\n•	Communicate with you about your account, app updates, and other important information.\n•	Respond to your comments and questions and provide customer service.\n•	Conduct research and analytics.\n•	Comply with legal and regulatory requirements.\n•	Personalize services, content, and features that match your activities, preferences, and settings.\n•	Help protect the safety of TeaTalk and our users, including blocking suspected spammers and addressing abuse.\n•	Enforce the TeaTalk User Agreement and our other policies.\n•	Provide, optimize, target, and measure the effectiveness of ads shown on our Services.\n•	Research and develop new services.\n•	Send you technical notices, updates, security alerts, invoices, and other support and administrative messages.\n•	Provide customer service.\n•	Communicate with you about products, services, offers, promotions, and events, and provide other news and information we think will be of interest to you.\n•	Monitor and analyze trends, usage, and activities in connection with our Services.\n";

const String whatIsTeaTalkDes =
    "TeaTalk app is online social media platform which committed to protecting the privacy of our users. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our TeaTalk application.\n\nPlease read this Privacy Policy carefully. If you do not agree with the terms of this Privacy Policy, please do not access the Application.";

const String privacyPolicyForTTSMA =
    "Media One Co., Ltd built the TeaTalk app as a Freemium Social Media App. This SERVICE is provided by Media One Co., Ltd at no cost and is intended for use as is.This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.\nThe terms used in this Privacy Policy have the same meaning as in our Terms and Conditions, which are accessible at TeaTalk unless otherwise defined in this Privacy Policy.";

const String kycDes =
    "We collect information about you in several ways when you use the Application. For example, we collect:\n•	Personal Information, such as your name, email address, and other contact information when you register for an account.\n•	Profile Data, such as your profile picture, interests, and other information you provide in your profile.\n•	User-generated content, such as photos, videos and posts, that you submit to the Application.\n•	Information about your device and internet connection, such as your IP address, browser version and operating system, when you access the Application.\n•	Usage Data, such as your activity on the Application, when you use the Application.";

const String infomationCollectionAndUse =
    "For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information. If you want to create an account to participate in TeaTalk, we don't require you to give us your real name. We don't automatically track your precise location. You can share as much or as little about yourself as you want. You can create multiple accounts, update information as you see fit, or ask us to delete your information. Any data we collect is used primarily to provide our services, which are focused on allowing people to come together and form communities, the vast majority of which are public. If you have questions about how we use your data, you can always ask us for more information.";

const String infoYouProviedToUs =
    "We collect information you provide to us directly when you use the Services. This includes: \n\nAccount information\n\nYou need an account to use TeaTalk. If you create a TeaTalk account, your account will have a username, which you need to provide. Your username is public, and it doesn't have to be related to your real name. You may also need to provide a password too.\n\nWhen you use TeaTalk, you may provide other optional information. You may also provide other information, such as a bio, gender, age, location, or profile picture. This information is optional and may be removed at any time. We also store your user account preferences and settings. We may ask for such information prior to you creating a username or account to help improve your experience exploring TeaTalk.\n\nContent you submit\n\nWe collect the content you submit to the Services. This includes your posts and comments including photo and videos you post and videos you live broadcast, your messages with other users (e.g., private messages, chats), and your reports and other communications with moderators and with us. Your content may include text, links, images, gifs, audio, and videos.\n\nActions you take\n\nWe collect information about the actions you take when using the Services. This includes your interactions with content, like giving reacts, sending stickers, giving comments, and sharing. It also includes your interactions with other users, such as add friend, unfriend and blocking.\n\nTransactional information\n\nIf you purchase products or services from us (e.g., In-App Digital Currency (ICE) or Paid Stickers), we will collect certain information from you, including your name, address, email address, phone number, and information about the product or service you are purchasing. TeaTalk uses industry-standard payment processor services (for example, KBZ Pay, Wave Money, CB Pay, OK Dollar) to handle payment information.\n\nOther information\n\nYou may choose to provide other information directly to us. For example, we may collect information when you fill out a form, participate in TeaTalk-sponsored activities or promotions, apply for a job, request customer support, or otherwise communicate with us.";

const String infoWeCollectAutomatically =
    'When you access or use our Services, we may also automatically collect information about you. This includes:\n\nLog and usage data\n\nWe may log information when you access and use the Services. This may include your IP address, user-agent string, browser type, operating system, referral URLs, device information (e.g., device IDs), device settings, mobile carrier name, pages visited, links clicked, the requested URL, and search terms. Except for the IP address used to create your account, TeaTalk will delete any IP addresses collected after 100 days.\n\nInformation collected from cookies and similar technologies\n\nWe may receive information from cookies, which are pieces of data your browser stores and sends back to us when making requests, and similar technologies. We use this information to deliver and maintain our services and our site, improve your experience, understand user activity, personalize content and advertisements, measure the effectiveness of advertising, and improve the quality of our Services. For example, we store and retrieve information about your preferred language and other settings. See our Cookie Notice for more information about how TeaTalk uses cookies. For more information on how you can disable cookies, please see "Your Choices” below.\n\nLocation information\n\nWe may receive and process information about your location. We may receive location information from you when you choose to share such information on our Services, including by associating your content with a location, or we may derive an approximate location based on your IP address.\n\nInformation Collected from Other Sources\n\nWe may receive information about you from other sources, including from other users and third parties, and combine that information with the other information we have about you. For example, we may receive demographic or interest information about you from third parties, including advertisers (such as the fact that an advertiser is interested in showing you an ad), and combine it with data you have provided to TeaTalk, using a common account identifier such as a phone number or a mobile-device ID. You can control how we use this information to personalize the Services for you by visiting the Safety & Privacy section of the User Settings menu in your account, as described in the section titled "Your Rights and Choices” below.\n\nInformation collected from integrations\n\nWe also may receive information about you, including log and usage data and cookie information, from third-party sites that integrate our Services, including our embeds and advertising technology. For example, when you visit a site that uses TeaTalk embeds, we may receive information about the web page you visited. Similarly, if an advertiser incorporates TeaTalk\u00ads ad technology, TeaTalk may receive limited information about your activity on the advertiser\u00ads site or app, such as whether you bought something from the advertiser. You can control how we use this information to personalize the Services for you as described in "Your Choices - Controlling Advertising and Analytics” below.';

const String infoCollectByThirdParties =
    'Embedded content\n\nTeaTalk displays some linked content in-line on the TeaTalk services via "embeds.” For example, TeaTalk posts that link to YouTube or Twitter may load the linked video or tweet within TeaTalk directly from those services to your device so you don\u00adt have to leave TeaTalk to see it. In general, TeaTalk does not control how third-party services collect data when they serve you their content directly via these embeds. As a result, embedded content is not covered by this privacy policy but by the policies of the service from which the content is embedded.\n\nAudience measurement\n\nWe partner with service providers that perform audience measurement to learn demographic information about the population that uses TeaTalk. To provide this demographic information, these companies collect cookie information to recognize your device.';

const String infoCollectedFromAdvertiserAndPotentialAdv =
    "If you use TeaTalk Ads (TeaTalk's self-serve ads platform at teatalk.io) we collect some additional information. To sign up for TeaTalk Ads, you must provide your name, email address, and information about your company. If you purchase advertising services, you will need to provide transactional information as described above, and we may also require additional documentation to verify your identity. When using TeaTalk Ads, we may record a session replay of your visit for customer service, troubleshooting, and usability research purposes.";
