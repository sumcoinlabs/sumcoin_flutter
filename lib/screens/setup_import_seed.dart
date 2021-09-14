import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peercoin/providers/activewallets.dart';
import 'package:peercoin/providers/unencryptedOptions.dart';
import 'package:peercoin/screens/setup.dart';
import 'package:peercoin/tools/app_localizations.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:peercoin/tools/app_routes.dart';
import 'package:peercoin/widgets/buttons.dart';
import 'package:provider/provider.dart';

class SetupImportSeedScreen extends StatefulWidget {
  @override
  _SetupImportSeedState createState() => _SetupImportSeedState();
}

class _SetupImportSeedState extends State<SetupImportSeedScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void createWallet(context) async {
    setState(() {
      _loading = true;
    });
    var _activeWallets = Provider.of<ActiveWallets>(context, listen: false);
    try {
      await _activeWallets.init();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          AppLocalizations.instance.translate('setup_securebox_fail'),
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 10),
      ));
    }
    await _activeWallets.createPhrase(_controller.text);
    var prefs =
        await Provider.of<UnencryptedOptions>(context, listen: false).prefs;
    await prefs.setBool('importedSeed', true);
    await Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.SetUpPin, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(width: 2, color: Colors.transparent,),
    );

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, automaticallyImplyLeading: false,),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PeerProgress(2),
              Image.asset(
                'assets/images/59-Cybersecurity.png',
                height: MediaQuery.of(context).size.height/3,
              ),
              Text(
                AppLocalizations.instance.translate(
                  'import_seed_button',
                ),
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Theme.of(context).shadowColor,
                        ),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.keyboard_rounded, color: Theme.of(context).primaryColor, size: 40,),
                                SizedBox(width: 24,),
                                Container(
                                  width: MediaQuery.of(context).size.width/1.8,
                                  child: Text(
                                    AppLocalizations.instance.translate('setup_import_note'),
                                    style: TextStyle(
                                        color: const Color(0xFF2A7A3A), fontSize: 15),
                                    textAlign: TextAlign.left,
                                    maxLines: 5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: Theme.of(context).backgroundColor,
                              border: Border.all(
                                width: 2,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                textInputAction: TextInputAction.done,
                                key: Key('importTextField'),
                                controller: _controller,
                                validator: (value) {
                                  if (value!.split(' ').length < 12) {
                                    return AppLocalizations.instance.translate(
                                      'import_seed_error_1',
                                    );
                                  }
                                  if (bip39.validateMnemonic(value) == false) {
                                    return AppLocalizations.instance.translate(
                                      'import_seed_error_2',
                                    );
                                  }
                                  return null;
                                },
                                style: TextStyle(color: Theme.of(context).dividerColor, fontSize: 16),
                                decoration: InputDecoration(
                                  hintText: 'e.g. mushrooms pepper courgette onion asparagus garlic sweetcorn nut pumpkin potato bean spinach',
                                  hintStyle: TextStyle(color: Theme.of(context).accentColor, fontSize: 16),
                                  filled: true,
                                  fillColor: Theme.of(context).backgroundColor,
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      var data = await Clipboard.getData('text/plain');
                                      if (data != null) {
                                        _controller.text = data.text!;
                                      }
                                      FocusScope.of(context).unfocus(); //hide keyboard
                                    },
                                    icon: Icon(Icons.paste,
                                        color: Color(0xFF2A7A3A)),
                                  ),
                                  border: border,
                                  focusedBorder: border,
                                  enabledBorder: border,
                                  errorStyle: TextStyle(color: Theme.of(context).errorColor),
                                  errorBorder: border,
                                  focusedErrorBorder: border,
                                ),
                                keyboardType: TextInputType.multiline,
                                minLines: 5,
                                maxLines: 5,
                              ),
                            ),
                          ),
                        ],),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PeerButtonSetupBack(),
                          PeerButtonSetupLoading(
                            small: true,
                            action: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                createWallet(context);
                              }
                            },
                            text: AppLocalizations.instance.translate(
                              'import_button',
                            ),
                            loading: _loading,
                          ),
                          SizedBox(
                            width: 40,
                          ),
                        ],
                      ),
                      SizedBox(height: 8,),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
