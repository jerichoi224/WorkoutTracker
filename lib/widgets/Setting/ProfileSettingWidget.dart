import 'dart:io';

import 'package:flutter/material.dart';
import 'package:workout_tracker/util/StringTool.dart';
import 'package:workout_tracker/util/objectbox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:workout_tracker/widgets/UIComponents.dart';

class ProfileSettingsWidget extends StatefulWidget {
  late ObjectBox objectbox;
  ProfileSettingsWidget({Key? key, required this.objectbox,}) : super(key: key);

  @override
  State createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettingsWidget> {

  ImagePicker picker = ImagePicker();
  TextEditingController nameController = new TextEditingController();
  File? img_file;
  Image? img;

  @override
  void initState() {
    super.initState();
    String initName = widget.objectbox.getPref("user_name");
    nameController.text = initName != null ? initName : "";
    getUserImage();
  }

  getUserImage() async {
    String? profileImage = widget.objectbox.getPref('profile_image');
    if(profileImage == null || profileImage.isEmpty)
      return;

    img = imageFromBase64String(profileImage);
    setState(() {});
  }

  Future<Null> _cropImage(String path) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
        ]
            : [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: AppLocalizations.of(context)!.settings_crop_image,
              toolbarColor: Colors.amberAccent,
              toolbarWidgetColor: Colors.black,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true
          ),
          IOSUiSettings(
            title: AppLocalizations.of(context)!.settings_crop_image,
          ),
          WebUiSettings(
            context: context,
          ),
        ]
    );
    if (croppedFile != null) {
      setState(() {
        img_file = File(croppedFile.path);
        img = Image.file(img_file!);
      });
    }
  }

  void getImage() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if(image == null)
      return;
    _cropImage(image.path);
  }

  void saveChanges()
  {
    if(nameController.text.trim().isEmpty) {
      final snackBar = SnackBar(
        content: Text(AppLocalizations.of(context)!.settings_name_msg),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if(img_file != null)
    {
      String profile_image = base64toString(img_file!.readAsBytesSync());
      widget.objectbox.setPref("profile_image", profile_image);
    }

    widget.objectbox.setPref("user_name", nameController.text);
    Navigator.pop(context, true);
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
                  title: Text(AppLocalizations.of(context)!.settings_edit_profile),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                    [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 5),
                        child:Center(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              CircleAvatar(
                                radius: 63,
                               backgroundColor: Colors.amberAccent,
                                child: CircleAvatar(
                                  radius: 60,
                                  child: (img_file != null || img != null) ?
                                  ClipOval(
                                      child: img
                                  ):
                                  Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              Container(
                                width: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 2,
                                      offset: Offset(0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  iconSize: 18,
                                  onPressed: (){
                                    getImage();
                                  },
                                  icon: Icon(
                                    Icons.add_a_photo,
                                    color: Color.fromRGBO(0, 0, 0, 0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Text(AppLocalizations.of(context)!.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                            ),
                          )
                      ),
                      Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          margin: EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                  title: new Row(
                                    children: <Widget>[
                                      new Flexible(
                                          child: new TextField(
                                            controller: nameController,
                                            decoration: InputDecoration(
                                              border:InputBorder.none,
                                              hintText: AppLocalizations.of(context)!.enter_name
                                            ),
                                          )
                                      )
                                    ],
                                  )
                              ),
                            ],
                          )
                      ),
                      CardButton(
                          Theme.of(context).colorScheme.primary,
                          AppLocalizations.of(context)!.save_changes,
                              () {saveChanges();}
                      ),
                    ]),
              ),
            ],
          ),
        )
    );
  }
}