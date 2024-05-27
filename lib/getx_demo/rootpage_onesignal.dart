import 'dart:async';

import 'package:animation_demo/common/debug.dart';
import 'package:animation_demo/getx_demo/root_page.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

extension RootPageOneSignal on RootPageState {
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState({required String? oneSignalAppId}) async {
    if (!mounted) {
      return;
    }
    unawaited(
      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none),
    );
    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared.setAppId(oneSignalAppId!);

    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);

    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      Debug.logMessage(
        message: 'NOTIFICATION OPENED HANDLER CALLED WITH: $result',
      );
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      Debug.logMessage(message: 'FOREGROUND HANDLER CALLED WITH: $event');

      /// Display Notification, send null to not display
      event.complete(event.notification);
    });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {});

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      Debug.logMessage(
        message: 'SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}',
      );
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      Debug.logMessage(
        message: 'PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}',
      );
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges changes) {
      Debug.logMessage(
        message:
            'EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}',
      );
    });

    OneSignal.shared
        .setSMSSubscriptionObserver((OSSMSSubscriptionStateChanges changes) {
      Debug.logMessage(
        message:
            'SMS SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}',
      );
    });

    // final requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

    // Some examples of how to use In App Messaging public methods with OneSignal SDK
    unawaited(oneSignalInAppMessagingTriggerExamples());

    unawaited(OneSignal.shared.disablePush(false));

    // Some examples of how to use Outcome Events public methods with OneSignal SDK
  }

  Future<void> oneSignalInAppMessagingTriggerExamples() async {
    /// Example addTrigger call for IAM
    /// This will add 1 trigger so if there are any IAM satisfying it, it
    /// will be shown to the user
    unawaited(OneSignal.shared.addTrigger('trigger_1', 'one'));

    /// Example addTriggers call for IAM
    /// This will add 2 triggers so if there are any IAM satisfying these, they
    /// will be shown to the user
    final triggers = <String, Object>{};
    triggers['trigger_2'] = 'two';
    triggers['trigger_3'] = 'three';
    unawaited(OneSignal.shared.addTriggers(triggers));

    // Removes a trigger by its key so if any future IAM are pulled with
    // these triggers they will not be shown until the trigger is added back
    unawaited(OneSignal.shared.removeTriggerForKey('trigger_2'));

    // Get the value for a trigger by its key
    final triggerValue =
        await OneSignal.shared.getTriggerValueForKey('trigger_3');
    Debug.logMessage(
      message: "'trigger_3' key trigger value: ${triggerValue?.toString()}",
    );

    // Create a list and bulk remove triggers based on keys supplied
    final keys = <String>['trigger_1', 'trigger_3'];
    unawaited(OneSignal.shared.removeTriggersForKeys(keys));

    // Toggle pausing (displaying or not) of IAMs
    unawaited(OneSignal.shared.pauseInAppMessages(false));
  }

  Future<void> oneSignalOutcomeEventsExamples() async {
    // Await example for sending outcomes
    unawaited(outcomeAwaitExample());

    // Send a normal outcome and get a reply with the name of the outcome
    unawaited(OneSignal.shared.sendOutcome('normal_1'));
    unawaited(OneSignal.shared.sendOutcome('normal_2').then((outcomeEvent) {
      Debug.logMessage(message: outcomeEvent.jsonRepresentation());
    }));

    // Send a unique outcome and get a reply with the name of the outcome
    unawaited(OneSignal.shared.sendUniqueOutcome('unique_1'));
    unawaited(
        OneSignal.shared.sendUniqueOutcome('unique_2').then((outcomeEvent) {
      Debug.logMessage(message: outcomeEvent.jsonRepresentation());
    }));

    // Send an outcome with a value and get a reply with the name of the outcome
    unawaited(OneSignal.shared.sendOutcomeWithValue('value_1', 3.2));
    unawaited(OneSignal.shared
        .sendOutcomeWithValue('value_2', 3.9)
        .then((outcomeEvent) {
      Debug.logMessage(message: outcomeEvent.jsonRepresentation());
    }));
  }

  Future<void> outcomeAwaitExample() async {
    final outcomeEvent = await OneSignal.shared.sendOutcome('await_normal_1');
    Debug.logMessage(message: outcomeEvent.jsonRepresentation());
  }
}
