// setup_create_wallet.dart

import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/wallet_provider.dart';
import '../../tools/app_localizations.dart';
import '../../tools/app_routes.dart';
import '../../tools/share_wrapper.dart';
import '../../widgets/buttons.dart';
import '../../widgets/loading_indicator.dart';
import 'setup_landing.dart';
import '../../widgets/logout_dialog_dummy.dart'
    if (dart.library.html) '../../widgets/logout_dialog.dart';

class SetupCreateWalletScreen extends StatefulWidget {
  const SetupCreateWalletScreen({Key? key}) : super(key: key);

  static String seed = ''; // Static variable to store the seed on users device

  @override
  State<SetupCreateWalletScreen> createState() => _SetupCreateWalletScreenState();
}

class _SetupCreateWalletScreenState extends State<SetupCreateWalletScreen> {
  bool _sharedYet = false;
  bool _initial = true;
  bool _isLoading = false;
  String _seed = '';
  late WalletProvider _walletProvider;

  Future<void> shareSeed(seed) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (kIsWeb) {
      await Clipboard.setData(ClipboardData(text: seed));
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.instance.translate('snack_copied'), textAlign: TextAlign.center),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      await ShareWrapper.share(context: context, message: seed);
    }
    Timer(const Duration(seconds: kIsWeb ? 2 : 1), () => setState(() => _sharedYet = true));
  }

  Future<void> createWallet(context) async {
    setState(() => _isLoading = true);
    try {
      await _walletProvider.init();
      await _walletProvider.createPhrase(null, 256); // 24 words - 256 entropy default creation for security
      _seed = await _walletProvider.seedPhrase;
      SetupCreateWalletScreen.seed = _seed; // Store the seed in the static variable
    } catch (e) {
      await LogoutDialog.clearData();
      await createWallet(context);
    }
    setState(() => _isLoading = false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initial) {
      _walletProvider = Provider.of<WalletProvider>(context);
      createWallet(context);
      _initial = false;
    }
  }

  Future<void> handleContinue() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.instance.translate('setup_continue_alert_title'), textAlign: TextAlign.center),
          content: Text(AppLocalizations.instance.translate('setup_continue_alert_content')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.instance.translate('server_settings_alert_cancel')),
            ),
            TextButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                var prefs = await SharedPreferences.getInstance();
                await prefs.setBool('importedSeed', false);
                navigator.pop();
                await navigator.pushNamed(Routes.setupAuth);
              },
              child: Text(AppLocalizations.instance.translate('continue')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, toolbarHeight: 0, automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Container(
          height: SetupLandingScreen.calcContainerHeight(context),
          color: Theme.of(context).primaryColor,
          child: _isLoading
              ? const Center(child: LoadingIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const PeerProgress(step: 2),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const PeerButtonSetupBack(),
                                AutoSizeText(
                                  AppLocalizations.instance.translate('setup_save_title'),
                                  maxFontSize: 28,
                                  minFontSize: 25,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(width: 40),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  width: MediaQuery.of(context).size.width > 1200
                                      ? MediaQuery.of(context).size.width / 2
                                      : MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    color: Theme.of(context).shadowColor,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(24),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.vpn_key_rounded, color: Theme.of(context).primaryColor, size: 40),
                                            const SizedBox(width: 24),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width > 1200
                                                  ? MediaQuery.of(context).size.width / 2.5
                                                  : MediaQuery.of(context).size.width / 1.9,
                                              child: Text(
                                                AppLocalizations.instance.translate('setup_save_text1'),
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.primaryContainer,
                                                  fontSize: 15,
                                                ),
                                                textAlign: TextAlign.left,
                                                maxLines: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onDoubleTap: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(AppLocalizations.instance.translate('snack_copied'), textAlign: TextAlign.center),
                                              duration: const Duration(seconds: 1),
                                            ),
                                          );
                                          Clipboard.setData(ClipboardData(text: _seed));
                                          setState(() => _sharedYet = true);
                                        },
                                        child: Container(
                                          height: 250,
                                          padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                                            color: Theme.of(context).colorScheme.background,
                                            border: Border.all(
                                              width: 2,
                                              color: _sharedYet ? Theme.of(context).shadowColor : Theme.of(context).primaryColor,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width > 1200
                                                    ? MediaQuery.of(context).size.width / 3
                                                    : MediaQuery.of(context).size.width * 0.7,
                                                child: Text(
                                                  _seed,
                                                  style: TextStyle(fontSize: 16, wordSpacing: 16, color: Theme.of(context).colorScheme.primaryContainer),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_sharedYet)
                      PeerButtonSetup(
                        action: () async => await handleContinue(),
                        text: AppLocalizations.instance.translate('continue'),
                      )
                    else
                      PeerButtonSetup(
                        action: () async => await shareSeed(_seed),
                        text: AppLocalizations.instance.translate('export_now'),
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
        ),
      ),
    );
  }
}
