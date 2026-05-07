import 'package:fit_tracker/DB/backup_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
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
            onTap: () {
              BackupService().importDatabase();
            },
          ),
        ],
      ),
    )));
  }
}
