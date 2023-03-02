import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inshorts/controllers/authentication_controller.dart';
import 'package:inshorts/controllers/providers/user_provider.dart';
import 'package:inshorts/screens/common/components/MyCupertinoAlertDialogWidget.dart';
import 'package:inshorts/screens/common/components/app_bar.dart';
import 'package:inshorts/screens/common/components/modal_progress_hud.dart';
import 'package:inshorts/utils/SizeConfig.dart';
import 'package:inshorts/utils/my_print.dart';
import 'package:inshorts/utils/styles.dart';
import 'package:provider/provider.dart';

import '../../../controllers/user_controller.dart';
import '../../../models/user_model.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isLoading = false;
TextEditingController editingController=TextEditingController();




  Future<void> logout() async {
    MyPrint.printOnConsole("logout");
    setState(() {
      isLoading = true;
    });
    bool? isLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyCupertinoAlertDialogWidget(
          title: "Logout",
          description: "Are you sure want to logout?",
          negativeCallback: () {
            Navigator.pop(context, false);
          },
          positiviCallback: () {
            Navigator.pop(context, true);
          },
        );
      },
    );

    if(isLogout != null && isLogout) {
      await AuthenticationController().logout(context);
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3),(){
      editingController.text=  Provider.of<UserProvider>(context,).userModel!.name??"";
      setState(() {

      });
    });


  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Styles.background,
        body: Column(
          children: [
            MyAppBar(title: "User Profile", color: Colors.white, backbtnVisible: false,),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: MySize.size20!),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getProfileDetails(),

                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          singleOption1(
                            iconData: Icons.logout,
                            option: "Logout",
                            ontap: () async {
                              logout();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getProfileDetails() {
    UserProvider userProvider = Provider.of<UserProvider>(context,);
    return Container(
      margin: EdgeInsets.only(bottom: MySize.getScaledSizeHeight(250)),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: MySize.size8!),
            width: MySize.getScaledSizeHeight(120),
            height: MySize.getScaledSizeHeight(120),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(300),
              child: (userProvider.userModel?.image.isNotEmpty ?? false)
                  ? CachedNetworkImage(imageUrl: userProvider.userModel!.image, fit: BoxFit.fill,)
                  : Image.asset("assets/male profile vector.png", fit: BoxFit.fill,),
            ),
          ),
          Text(userProvider.userModel?.name ?? "", style: const TextStyle(color: Colors.black),),
          Visibility(
            visible: (userProvider.userModel?.house ?? "").isNotEmpty,
            child: Text("House : ${userProvider.userModel?.house}"),
          ),
          Visibility(
            visible: (userProvider.userModel?.email ?? "").isNotEmpty,
            child: Text(userProvider.userModel?.email ?? "", style: const TextStyle(color: Colors.black),),
          ),
          Visibility(
            visible: (userProvider.userModel?.mobile ?? "").isNotEmpty,
            child: Text(userProvider.userModel?.mobile ?? ""),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller:editingController,
                  decoration: InputDecoration(
                      hintText: "Update Name",
                    suffix: InkWell(
                        onTap: ()async{

                           UserModel userModel= Provider.of<UserProvider>(context,listen: false).userModel!;
                           userModel.name=editingController.text;

                            bool uopdat=await UserController().updateUser(context, userModel);
                            print("update $uopdat");

                            Provider.of<UserProvider>(context,listen: false).userModel=userModel;

                        },
                        child: Icon(Icons.update)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget singleOption1({required IconData iconData, required String option, Function? ontap}) {
    return InkWell(
      onTap: ()async {
        if(ontap != null) ontap();
      },
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: MySize.size10!),
        decoration: BoxDecoration(
          color: Styles.bottomAppbarColor,
          borderRadius: BorderRadius.circular(MySize.size10!),
        ),
        padding: EdgeInsets.symmetric(vertical: MySize.size16!, horizontal: MySize.size10!),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Icon(
                iconData,
                size: MySize.size22,
                color: Styles.onBackground,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: MySize.size16!),
                child: Text(option,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Container(
              child: Icon(Icons.arrow_forward_ios_rounded,
                size: MySize.size22,
                color: Styles.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
