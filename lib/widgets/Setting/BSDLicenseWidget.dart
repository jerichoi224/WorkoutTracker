import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BSDLicenseWidget extends StatefulWidget {
  BSDLicenseWidget({Key? key}) : super(key: key);

  @override
  State createState() => _BSDLicenseState();
}

class _BSDLicenseState extends State<BSDLicenseWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                snap: false,
                floating: false,
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.05),
                expandedHeight: 100.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(AppLocalizations.of(context)!.settings_bsd_license),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                    [
                      Container(
                        padding: EdgeInsets.all(15),
                        child: RichText(text:
                        TextSpan(
                            children: [
                              TextSpan(
                                  text: BSD_3_Clause,
                                  style: TextStyle(
                                      color: Colors.grey
                                  )
                              )
                            ]
                        )),
                      )
                    ]),
              ),
            ],
          ),
        )
    );
  }
  String BSD_3_Clause = "Copyright 2013, the Dart project authors. All rights reserved. "
      "Redistribution and use in source and binary forms, with or without "
      "modification, are permitted provided that the following conditions are "
      "met: \n\n"
      "* Redistributions of source code must retain the above copyright "
      "notice, this list of conditions and the following disclaimer. \n"
      "* Redistributions in binary form must reproduce the above "
      "copyright notice, this list of conditions and the following "
      "disclaimer in the documentation and/or other materials provided "
      "with the distribution. \n"
      "* Neither the name of Google Inc. nor the names of its "
      "contributors may be used to endorse or promote products derived "
      "from this software without specific prior written permission.\n\n "
      "THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "
      "\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT "
      "LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR "
      "A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT "
      "OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, "
      "SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT "
      "LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, "
      "DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY "
      "THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT "
      "(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE "
      "OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.";
}