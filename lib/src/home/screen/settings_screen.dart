import 'package:fit_tracker/DB/backup_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  String version = '';
  @override
  void initState() {
    super.initState();
    initPackageInfo();
  }

  Future<void> initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Настройки",
            style: GoogleFonts.roboto(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          //TODO: Сделать переводы в intl
          ListTile(
            leading: Icon(Icons.backup),
            title: Text("Создать резервную копию"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () async {
              BackupService().exportDatabase();
            },
          ),
          ListTile(
            leading: Icon(Icons.cloud_download_rounded),
            title: Text("Восстановить данные"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () async {
              bool result = await BackupService().importDatabase();
              if (result) {
                if (context.mounted) {
                  Navigator.pop(context);
                  showTopSnackBar(
                    Overlay.of(context),
                    const CustomSnackBar.success(
                      backgroundColor: Color.fromRGBO(173, 198, 255, 0.9),
                      iconPositionLeft: 5,
                      icon: Icon(
                        Icons.check_circle_outlined,
                        size: 40,
                      ),
                      message: "Данные успешно восстановлены",
                    ),
                  );
                }
              }
            },
          ),
          Spacer(),
          Center(
              child: Opacity(
                  opacity: 0.5,
                  child: Text("Версия приложения: $version", style: GoogleFonts.roboto())))
        ],
      ),
    )));
  }
}
