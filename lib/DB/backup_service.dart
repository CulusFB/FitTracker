import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

class BackupService {
  static const String dbName = 'TestDB.db';

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
      'backup_${DateTime.now().millisecondsSinceEpoch}.db',
    );

    // Создаем копию БД
    final backupFile = await sourceFile.copy(backupPath);

    // Открываем share sheet
    await Share.shareXFiles(
      [XFile(backupFile.path)],
      text: 'Database backup',
    );
  }

  Future<void> importDatabase() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['db'],
    );

    if (result == null) {
      return;
    }

    final pickedFile = File(result.files.single.path!);

    final dbPath = await getDatabasesPath();
    final targetPath = join(dbPath, dbName);

    // Закрыть текущую БД
    await deleteDatabase(targetPath);

    await pickedFile.copy(targetPath);
  }
}
