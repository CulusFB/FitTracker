import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fit_tracker/DB/data_manager.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

class BackupService {
  static const String dbName = 'TestDB.fittracker';

  Future<void> exportDatabase() async {
    final dbPath = await getDatabasesPath();
    final sourcePath = join(dbPath, dbName);

    final sourceFile = File(sourcePath);

    if (!await sourceFile.exists()) {
      throw Exception('Database not found');
    }

    // Временная директория
    final tempDir = await getTemporaryDirectory();

    final backupPath = join(
      tempDir.path,
      'backup_${DateTime.now().millisecondsSinceEpoch}.fittracker',
    );

    // Создаем копию БД
    final backupFile = await sourceFile.copy(backupPath);

    // Открываем share sheet
    final params = ShareParams(
      files: [XFile(backupFile.path)],
    );
    await SharePlus.instance.share(params);
  }

  Future<void> importDatabase() async {
    final result =
        await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ["fittracker"]);

    if (result == null) {
      return;
    }

    final pickedFile = File(result.files.single.path!);

    final dbPath = await getDatabasesPath();
    final targetPath = join(dbPath, dbName);

    if (await File(targetPath).exists()) {
      await deleteDatabase(targetPath);
    }
    await pickedFile.copy(targetPath);
    await DataManager().reinit();
  }
}
