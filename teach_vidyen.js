const {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
  HeadingLevel, AlignmentType, BorderStyle, WidthType, ShadingType,
  VerticalAlign, PageBreak, TabStopType, TabStopPosition
} = require('docx');
const fs = require('fs');

// ── Helpers ────────────────────────────────────────────────────────────────
const BLUE       = '1E6FD9';
const DARK_BLUE  = '0A1628';
const GOLD       = 'C49A00';
const GREEN      = '1A7A3A';
const PURPLE     = '6B2FA0';
const GRAY       = '555555';
const LIGHT_GRAY = 'F2F4F7';
const HEADER_BG  = 'EBF2FF';
const CODE_BG    = 'F4F6F9';
const BORDER_CLR = 'CCCCCC';

const border = { style: BorderStyle.SINGLE, size: 1, color: BORDER_CLR };
const borders = { top: border, bottom: border, left: border, right: border };
const noBorders = {
  top: { style: BorderStyle.NONE, size: 0, color: 'FFFFFF' },
  bottom: { style: BorderStyle.NONE, size: 0, color: 'FFFFFF' },
  left: { style: BorderStyle.NONE, size: 0, color: 'FFFFFF' },
  right: { style: BorderStyle.NONE, size: 0, color: 'FFFFFF' },
};

function h1(text) {
  return new Paragraph({
    heading: HeadingLevel.HEADING_1,
    spacing: { before: 360, after: 160 },
    border: { bottom: { style: BorderStyle.SINGLE, size: 4, color: BLUE, space: 6 } },
    children: [new TextRun({ text, font: 'Arial', size: 34, bold: true, color: DARK_BLUE })]
  });
}

function h2(text) {
  return new Paragraph({
    heading: HeadingLevel.HEADING_2,
    spacing: { before: 300, after: 120 },
    children: [new TextRun({ text, font: 'Arial', size: 28, bold: true, color: BLUE })]
  });
}

function h3(text) {
  return new Paragraph({
    heading: HeadingLevel.HEADING_3,
    spacing: { before: 220, after: 80 },
    children: [new TextRun({ text, font: 'Arial', size: 24, bold: true, color: DARK_BLUE })]
  });
}

function h4(text) {
  return new Paragraph({
    spacing: { before: 180, after: 60 },
    children: [new TextRun({ text, font: 'Arial', size: 22, bold: true, color: PURPLE })]
  });
}

function p(runs) {
  if (typeof runs === 'string') {
    return new Paragraph({
      spacing: { before: 60, after: 100 },
      children: [new TextRun({ text: runs, font: 'Arial', size: 22, color: '222222' })]
    });
  }
  return new Paragraph({ spacing: { before: 60, after: 100 }, children: runs });
}

function bold(text, color = DARK_BLUE) {
  return new TextRun({ text, font: 'Arial', size: 22, bold: true, color });
}

function normal(text) {
  return new TextRun({ text, font: 'Arial', size: 22, color: '222222' });
}

function code(text) {
  return new TextRun({ text, font: 'Courier New', size: 19, color: '8B0000' });
}

function inlineCode(text) {
  return new TextRun({ text: ` ${text} `, font: 'Courier New', size: 19, color: '8B0000', highlight: 'yellow' });
}

function codeBlock(lines) {
  return lines.map(line => new Paragraph({
    spacing: { before: 0, after: 0 },
    shading: { fill: CODE_BG, type: ShadingType.CLEAR },
    indent: { left: 360 },
    children: [new TextRun({ text: line || ' ', font: 'Courier New', size: 18, color: '1a1a2e' })]
  }));
}

function note(text, color = '1557CC', bgColor = 'EBF2FF') {
  return new Paragraph({
    spacing: { before: 120, after: 120 },
    shading: { fill: bgColor, type: ShadingType.CLEAR },
    indent: { left: 360, right: 360 },
    border: { left: { style: BorderStyle.SINGLE, size: 12, color } },
    children: [new TextRun({ text, font: 'Arial', size: 20, color: '111111' })]
  });
}

function tip(text)     { return note('💡 ' + text, '1A7A3A', 'E8F5EE'); }
function warn(text)    { return note('⚠️  ' + text, 'C49A00', 'FFF8E1'); }
function important(text){ return note('🔑 ' + text, '6B2FA0', 'F3E8FF'); }

function bullet(text, level = 0) {
  return new Paragraph({
    spacing: { before: 40, after: 40 },
    indent: { left: 360 + level * 280, hanging: 200 },
    children: [
      new TextRun({ text: level === 0 ? '●  ' : '○  ', font: 'Arial', size: 20, color: BLUE }),
      new TextRun({ text, font: 'Arial', size: 21, color: '222222' })
    ]
  });
}

function numbered(text, num) {
  return new Paragraph({
    spacing: { before: 40, after: 40 },
    indent: { left: 440, hanging: 280 },
    children: [
      new TextRun({ text: `${num}.  `, font: 'Arial', size: 21, bold: true, color: BLUE }),
      new TextRun({ text, font: 'Arial', size: 21, color: '222222' })
    ]
  });
}

function divider() {
  return new Paragraph({
    spacing: { before: 200, after: 200 },
    border: { bottom: { style: BorderStyle.SINGLE, size: 2, color: 'DDDDDD', space: 1 } },
    children: [new TextRun({ text: '' })]
  });
}

function pageBreak() {
  return new Paragraph({ children: [new PageBreak()] });
}

function twoColTable(pairs) {
  return new Table({
    width: { size: 9360, type: WidthType.DXA },
    columnWidths: [3000, 6360],
    rows: pairs.map(([label, value]) => new TableRow({
      children: [
        new TableCell({
          borders,
          width: { size: 3000, type: WidthType.DXA },
          shading: { fill: HEADER_BG, type: ShadingType.CLEAR },
          margins: { top: 80, bottom: 80, left: 120, right: 120 },
          children: [new Paragraph({ children: [new TextRun({ text: label, font: 'Arial', size: 20, bold: true, color: BLUE })] })]
        }),
        new TableCell({
          borders,
          width: { size: 6360, type: WidthType.DXA },
          margins: { top: 80, bottom: 80, left: 120, right: 120 },
          children: [new Paragraph({ children: [new TextRun({ text: value, font: 'Arial', size: 20, color: '222222' })] })]
        }),
      ]
    }))
  });
}

function headerTable(cols, rows) {
  const totalWidth = 9360;
  const colWidth = Math.floor(totalWidth / cols.length);
  const colWidths = cols.map(() => colWidth);

  const headerRow = new TableRow({
    children: cols.map(col => new TableCell({
      borders,
      width: { size: colWidth, type: WidthType.DXA },
      shading: { fill: BLUE, type: ShadingType.CLEAR },
      margins: { top: 80, bottom: 80, left: 120, right: 120 },
      children: [new Paragraph({ children: [new TextRun({ text: col, font: 'Arial', size: 20, bold: true, color: 'FFFFFF' })] })]
    }))
  });

  const dataRows = rows.map((row, ri) => new TableRow({
    children: row.map(cell => new TableCell({
      borders,
      width: { size: colWidth, type: WidthType.DXA },
      shading: { fill: ri % 2 === 0 ? 'FFFFFF' : LIGHT_GRAY, type: ShadingType.CLEAR },
      margins: { top: 80, bottom: 80, left: 120, right: 120 },
      children: [new Paragraph({ children: [new TextRun({ text: cell, font: 'Arial', size: 20, color: '222222' })] })]
    }))
  }));

  return new Table({
    width: { size: totalWidth, type: WidthType.DXA },
    columnWidths: colWidths,
    rows: [headerRow, ...dataRows]
  });
}

function sectionBox(title, color = BLUE) {
  return new Paragraph({
    spacing: { before: 240, after: 100 },
    shading: { fill: color, type: ShadingType.CLEAR },
    indent: { left: 0 },
    children: [new TextRun({ text: `  ${title}  `, font: 'Arial', size: 24, bold: true, color: 'FFFFFF' })]
  });
}

// ═══════════════════════════════════════════════════════════════════════
// DOCUMENT CONTENT
// ═══════════════════════════════════════════════════════════════════════

const children = [

  // ── COVER ──────────────────────────────────────────────────────────
  new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 1200, after: 200 },
    children: [new TextRun({ text: 'VIDYEN', font: 'Arial', size: 80, bold: true, color: BLUE })]
  }),
  new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 0, after: 120 },
    children: [new TextRun({ text: 'Conference Management App', font: 'Arial', size: 36, color: GRAY })]
  }),
  new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 0, after: 600 },
    children: [new TextRun({ text: 'Complete Developer Teaching Guide', font: 'Arial', size: 28, bold: true, color: GOLD })]
  }),
  new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 0, after: 80 },
    children: [new TextRun({ text: 'Flutter  ·  GetX  ·  Hive  ·  Dart', font: 'Arial', size: 24, color: GRAY })]
  }),
  new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 0, after: 1600 },
    children: [new TextRun({ text: 'From Zero to Production — Every Line Explained', font: 'Arial', size: 22, color: GRAY, italics: true })]
  }),
  pageBreak(),

  // ══════════════════════════════════════════════════════════════════
  // CHAPTER 1 — WHAT IS THIS PROJECT
  // ══════════════════════════════════════════════════════════════════
  h1('Chapter 1 — What Is This Project?'),

  p('VIDYEN is a fully offline conference management mobile application. It runs entirely on the device with no internet connection required for data. Every piece of data — users, submissions, certificates — is stored locally using the Hive database.'),
  p('The app has two completely separate portals running inside a single codebase:'),
  bullet('Admin Portal — The organising committee manages participants, reviews all submissions, approves or rejects them with written remarks, and issues certificates.'),
  bullet('Participant Portal — A conference delegate registers, submits abstracts, signs up for pre-conference sessions and workshops, and views their certificates.'),

  h2('1.1 — The Tech Stack'),
  p('Before reading a single line of code you need to understand why each technology was chosen.'),

  headerTable(
    ['Technology', 'Role', 'Why chosen'],
    [
      ['Flutter', 'UI framework', 'Single codebase runs on Android, iOS, Web, Desktop'],
      ['Dart', 'Programming language', 'Compiled, typed, fast — Flutter\'s native language'],
      ['GetX', 'State + routing + DI', 'Zero-boilerplate reactive state, named routes, dependency injection in one package'],
      ['Hive', 'Local database', 'Pure Dart NoSQL key-value store — fast, offline, no native code'],
      ['crypto', 'Password hashing', 'SHA-256 hashing for secure password storage'],
      ['google_fonts', 'Typography', 'Playfair Display (headings) + Inter (body)'],
      ['file_picker', 'File attachment', 'Lets user attach PDF/DOC files to submissions'],
      ['uuid', 'ID generation', 'Generates unique IDs for every record'],
    ]
  ),

  h2('1.2 — Application Architecture'),
  p('The app follows a layered architecture. Data only flows in one direction:'),

  ...codeBlock([
    '  UI Screens',
    '      │  calls methods on',
    '      ▼',
    '  GetX Controllers  (AuthController, SubmissionController)',
    '      │  calls static methods on',
    '      ▼',
    '  HiveService  (database layer)',
    '      │  reads/writes to',
    '      ▼',
    '  Hive Boxes  (on-device storage)',
  ]),

  important('This layered separation means: Screens never talk to the database directly. Controllers never talk to the database directly without going through HiveService. This makes the code easy to test and modify.'),

  h2('1.3 — Folder Structure Explained'),
  p('Every folder has a strict single responsibility:'),

  twoColTable([
    ['lib/main.dart',        'App entry point. Initialises everything and sets up routes.'],
    ['lib/models/',          'Plain Dart classes that represent data shapes. UserModel, SubmissionModel, CertificateModel.'],
    ['lib/services/',        'HiveService — the ONLY place that touches the Hive database.'],
    ['lib/controllers/',     'GetX controllers — business logic. AuthController handles login/register/logout. SubmissionController handles all submission operations.'],
    ['lib/utils/',           'Helpers that are not widgets. AppTheme (colors/theme), Responsive (screen sizing).'],
    ['lib/widgets/',         'Reusable UI building blocks used across multiple screens.'],
    ['lib/screens/',         'Every screen the user sees. Divided into /dashboard for user screens and /admin for admin screens.'],
  ]),

  pageBreak(),

  // ══════════════════════════════════════════════════════════════════
  // CHAPTER 2 — pubspec.yaml
  // ══════════════════════════════════════════════════════════════════
  h1('Chapter 2 — pubspec.yaml (Project Configuration)'),

  p('pubspec.yaml is the project manifest. Flutter reads it to know the project name, its dependencies, and its assets.'),

  ...codeBlock([
    'name: vidyen_hive',
    'description: VIDYEN Conference Management App',
    'publish_to: "none"         # Not publishing to pub.dev',
    'version: 1.0.0+1           # version+buildNumber',
    '',
    'environment:',
    '  sdk: ">=3.0.0 <4.0.0"   # Requires Dart 3',
    '',
    'dependencies:',
    '  flutter:',
    '    sdk: flutter',
    '  get: ^4.6.6              # GetX — state, routing, DI',
    '  hive: ^2.2.3             # NoSQL local database',
    '  hive_flutter: ^1.1.0     # Hive integration with Flutter path_provider',
    '  crypto: ^3.0.3           # SHA-256 password hashing',
    '  google_fonts: ^6.1.0     # Playfair Display + Inter fonts',
    '  file_picker: ^6.1.1      # File attachment picker',
    '  uuid: ^4.2.1             # UUID generation for IDs',
    '  path_provider: ^2.1.1    # File system access (needed by Hive)',
    '',
    'dev_dependencies:',
    '  hive_generator: ^2.0.1   # Generates .g.dart adapter files',
    '  build_runner: ^2.4.7     # Runs code generation',
    '',
    'flutter:',
    '  uses-material-design: true',
    '  assets:',
    '    - assets/images/       # Trailing slash = include entire folder',
  ]),

  tip('The ^ symbol means "compatible with". ^4.6.6 means any version >=4.6.6 and <5.0.0. This allows patch and minor updates but not breaking major version changes.'),

  h2('2.1 — Why Hive Needs Two Packages'),
  p('hive is the core database — it works in pure Dart with no Flutter dependency. hive_flutter adds one important thing: it calls path_provider internally to find the correct directory on each platform (Android, iOS, Desktop) to store the database files. You always need both.'),

  pageBreak(),

  // ══════════════════════════════════════════════════════════════════
  // CHAPTER 3 — MODELS
  // ══════════════════════════════════════════════════════════════════
  h1('Chapter 3 — Models (Data Shapes)'),

  p('A model is a Dart class that represents one type of data. Think of it like a database table schema. The project has three models.'),

  h2('3.1 — What is Hive and How It Stores Data'),
  p('Hive stores data in "boxes". A box is like a table in SQL, but it is just a key-value store. You give it a key (usually the record ID) and a value (your model object).'),
  p('Hive needs to know how to convert your Dart object into binary bytes (to save to disk) and back from bytes to a Dart object (to read). This conversion is done by a TypeAdapter. You write the model, and either generate the adapter with build_runner or write it manually (as we did in this project).'),

  h3('3.1.1 — UserModel'),
  ...codeBlock([
    'import "package:hive/hive.dart";',
    '',
    'part "user_model.g.dart";     // Links to the generated adapter file',
    '',
    '@HiveType(typeId: 0)          // typeId must be unique across ALL models',
    'class UserModel extends HiveObject {   // HiveObject gives .save() method',
    '  @HiveField(0)   // Field index — must be unique within this model',
    '  late String id;',
    '',
    '  @HiveField(1)',
    '  late String name;',
    '',
    '  @HiveField(2)',
    '  late String email;',
    '',
    '  @HiveField(3)',
    '  late String passwordHash;    // NEVER store plain password',
    '',
    '  @HiveField(4)',
    '  late String regCode;         // e.g. VID-2025-AB1C2D',
    '',
    '  @HiveField(5)',
    '  late String delegateType;    // Speaker, Delegate, etc.',
    '',
    '  @HiveField(6)',
    '  late String designation;     // Job title',
    '',
    '  @HiveField(7)',
    '  late String institution;',
    '',
    '  @HiveField(8)',
    '  late String city;',
    '',
    '  @HiveField(9)',
    '  late String country;',
    '',
    '  @HiveField(10)',
    '  late String phone;',
    '',
    '  @HiveField(11)',
    '  late String status;          // "pending", "approved", "rejected"',
    '',
    '  @HiveField(12)',
    '  late bool isAdmin;',
    '',
    '  @HiveField(13)',
    '  late DateTime createdAt;',
    '',
    '  UserModel({ required this.id, required this.name, ... });',
    '}',
  ]),

  important('CRITICAL RULE — @HiveField numbers: Once you assign a number to a field, NEVER change it or reuse a deleted number. Hive uses these numbers to match bytes on disk to fields. If you change them, old data will be corrupted.'),

  tip('HiveObject gives your model a .save() method. After you change a field on an object that is already in a box, just call object.save() and Hive will persist the change without you needing to put() it again.'),

  h3('3.1.2 — SubmissionModel'),
  p('One model handles all three submission types (abstract, preconf, workshop). The type field is a string that identifies which kind it is. This avoids creating three separate models with nearly identical fields.'),

  ...codeBlock([
    '@HiveType(typeId: 1)          // Different typeId from UserModel',
    'class SubmissionModel extends HiveObject {',
    '  @HiveField(0)  late String id;',
    '  @HiveField(1)  late String userId;      // Who submitted this',
    '  @HiveField(2)  late String userName;    // Denormalised for display',
    '  @HiveField(3)  late String type;        // "abstract","preconf","workshop"',
    '  @HiveField(4)  late String title;',
    '  @HiveField(5)  late String description;',
    '  @HiveField(6)  late String? filePath;   // ? means nullable',
    '  @HiveField(7)  late String status;      // "pending","approved","rejected"',
    '  @HiveField(8)  late String? adminRemark;',
    '  @HiveField(9)  late DateTime submittedAt;',
    '  @HiveField(10) late String? coAuthors;',
    '  @HiveField(11) late String? keywords;',
    '  @HiveField(12) late String? category;',
    '}',
  ]),

  h3('3.1.3 — CertificateModel'),
  ...codeBlock([
    '@HiveType(typeId: 2)          // typeId 2',
    'class CertificateModel extends HiveObject {',
    '  @HiveField(0)  late String id;',
    '  @HiveField(1)  late String userId;',
    '  @HiveField(2)  late String userName;',
    '  @HiveField(3)  late String title;       // Certificate title',
    '  @HiveField(4)  late String type;        // "Participation", "Presentation"...',
    '  @HiveField(5)  late DateTime issuedAt;',
    '  @HiveField(6)  late String issuedBy;    // Admin name who issued it',
    '  @HiveField(7)  late String? filePath;',
    '}',
  ]),

  h2('3.2 — The .g.dart Adapter File'),
  p('The file user_model.g.dart is the TypeAdapter. It tells Hive exactly how to read and write a UserModel. Normally this is generated by build_runner but in this project it was written manually so build_runner is not needed to run the app.'),

  ...codeBlock([
    'class UserModelAdapter extends TypeAdapter<UserModel> {',
    '  @override',
    '  final int typeId = 0;       // Must match @HiveType(typeId: 0)',
    '',
    '  // READ — called when loading from disk',
    '  @override',
    '  UserModel read(BinaryReader reader) {',
    '    final numOfFields = reader.readByte();  // How many fields were saved',
    '    final fields = <int, dynamic>{',
    '      // Read each field index and its value',
    '      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),',
    '    };',
    '    return UserModel(',
    '      id:   fields[0] as String,   // field index 0 = id',
    '      name: fields[1] as String,   // field index 1 = name',
    '      // ... all other fields',
    '    );',
    '  }',
    '',
    '  // WRITE — called when saving to disk',
    '  @override',
    '  void write(BinaryWriter writer, UserModel obj) {',
    '    writer',
    '      ..writeByte(14)          // We are saving 14 fields total',
    '      ..writeByte(0)           // Field index 0',
    '      ..write(obj.id)          // Field value',
    '      ..writeByte(1)           // Field index 1',
    '      ..write(obj.name)        // Field value',
    '      // ... continues for all 14 fields',
    '  }',
    '}',
  ]),

  tip('The .. (cascade operator) in Dart lets you call multiple methods on the same object without repeating the variable name. writer..writeByte(14)..writeByte(0)..write(obj.id) is the same as writer.writeByte(14); writer.writeByte(0); writer.write(obj.id);'),

  pageBreak(),

  // ══════════════════════════════════════════════════════════════════
  // CHAPTER 4 — HIVE SERVICE
  // ══════════════════════════════════════════════════════════════════
  h1('Chapter 4 — HiveService (Database Layer)'),

  p('HiveService is a static utility class. "Static" means you never create an instance of it with new HiveService(). Every method is called directly on the class: HiveService.login(...), HiveService.register(...). This is intentional — there should only ever be one database connection, so an instance is unnecessary.'),

  h2('4.1 — Initialisation'),
  ...codeBlock([
    'static Future<void> init() async {',
    '  await Hive.initFlutter();         // Sets up the storage path for the platform',
    '',
    '  // Register adapters BEFORE opening boxes',
    '  Hive.registerAdapter(UserModelAdapter());',
    '  Hive.registerAdapter(SubmissionModelAdapter());',
    '  Hive.registerAdapter(CertificateModelAdapter());',
    '',
    '  // Open all boxes — loads them into memory',
    '  await Hive.openBox<UserModel>("users");',
    '  await Hive.openBox<SubmissionModel>("submissions");',
    '  await Hive.openBox<CertificateModel>("certificates");',
    '  await Hive.openBox("session");   // Untyped box for simple key-value',
    '',
    '  await _seedAdmin();    // Create default admin if none exists',
    '}',
  ]),

  important('Always register adapters before opening boxes. Hive needs to know how to read data before it opens the file that contains that data. If you swap the order, you get an error.'),

  h2('4.2 — Password Hashing'),
  ...codeBlock([
    'static String hashPassword(String password) {',
    '  final bytes = utf8.encode(password);    // Convert String to bytes',
    '  final digest = sha256.convert(bytes);   // Run SHA-256 algorithm',
    '  return digest.toString();               // Return hex string e.g. "5e884898..."',
    '}',
  ]),

  p('SHA-256 is a one-way hash function. You cannot reverse it to get the original password. When the user logs in, you hash what they typed and compare hashes — you never compare plain text passwords.'),

  h2('4.3 — Admin Seeding'),
  ...codeBlock([
    'static Future<void> _seedAdmin() async {',
    '  final box = Hive.box<UserModel>("users");',
    '  final existing = box.values.where((u) => u.isAdmin).toList();',
    '  if (existing.isEmpty) {      // Only create if no admin exists',
    '    final admin = UserModel(',
    '      id: "admin_001",',
    '      email: "admin@vidyen.org",',
    '      passwordHash: hashPassword("Admin@123"),',
    '      isAdmin: true,',
    '      status: "approved",',
    '      // ... other fields',
    '    );',
    '    await box.put(admin.id, admin);  // key=id, value=UserModel',
    '  }',
    '}',
  ]),

  tip('This runs every time the app starts, but the if (existing.isEmpty) check means the admin is only created once — on the very first launch when the box is empty.'),

  h2('4.4 — Box Getters'),
  ...codeBlock([
    '// Convenience getters so you don\'t write Hive.box<UserModel>("users") every time',
    'static Box<UserModel> get usersBox =>',
    '    Hive.box<UserModel>(AppConstants.usersBox);',
    '',
    'static Box<SubmissionModel> get submissionsBox =>',
    '    Hive.box<SubmissionModel>(AppConstants.submissionsBox);',
    '',
    'static Box get sessionBox =>',
    '    Hive.box(AppConstants.sessionBox);  // No type = dynamic box',
  ]),

  h2('4.5 — Login'),
  ...codeBlock([
    'static Future<UserModel?> login(String email, String password) async {',
    '  final hash = hashPassword(password);',
    '  try {',
    '    return usersBox.values.firstWhere(',
    '      (u) => u.email.toLowerCase() == email.toLowerCase()',
    '           && u.passwordHash == hash,',
    '    );',
    '  } catch (_) {',
    '    return null;   // firstWhere throws if no match — catch returns null',
    '  }',
    '}',
  ]),

  p('usersBox.values gives you an Iterable of all UserModel objects. firstWhere searches through them and returns the first one matching the condition. If none matches, it throws a StateError which we catch and return null instead.'),

  h2('4.6 — Session Management'),
  ...codeBlock([
    '// Save — called after successful login/register',
    'static void saveSession(String userId) {',
    '  sessionBox.put("currentUserId", userId);',
    '}',
    '',
    '// Clear — called on logout',
    'static void clearSession() {',
    '  sessionBox.delete("currentUserId");',
    '}',
    '',
    '// Read — called on app start to restore session',
    'static String? get currentUserId =>',
    '    sessionBox.get("currentUserId");',
    '',
    'static UserModel? get currentUser {',
    '  final id = currentUserId;',
    '  if (id == null) return null;',
    '  return usersBox.get(id);  // Hive.get(key) returns null if not found',
    '}',
  ]),

  p('This is how the app stays logged in when you close and reopen it. The user ID is stored in the session box. On next launch, AuthController reads it and restores the user.'),

  h2('4.7 — Updating Records (The .save() pattern)'),
  ...codeBlock([
    'static Future<void> updateUserStatus(String userId, String status) async {',
    '  final user = usersBox.get(userId);  // Get the live object from box',
    '  if (user != null) {',
    '    user.status = status;              // Modify the field',
    '    await user.save();                 // HiveObject.save() persists change',
    '  }',
    '}',
    '',
    'static Future<void> updateSubmissionStatus(',
    '    String submissionId, String status, String? remark) async {',
    '  final submission = submissionsBox.get(submissionId);',
    '  if (submission != null) {',
    '    submission.status = status;',
    '    submission.adminRemark = remark;',
    '    await submission.save();   // Save both changes in one call',
    '  }',
    '}',
  ]),

  tip('The .save() method only works because UserModel extends HiveObject. If you just used a plain Dart class, you would need to call box.put(id, object) again after each change.'),

  pageBreak(),

  // ══════════════════════════════════════════════════════════════════
  // CHAPTER 5 — GETX CONTROLLERS
  // ══════════════════════════════════════════════════════════════════
  h1('Chapter 5 — GetX Controllers (Business Logic)'),

  p('A GetX controller is a class that extends GetxController. It holds reactive state and business logic. Screens observe the controller\'s reactive variables and rebuild automatically when they change. The controller is the bridge between the screen and the database.'),

  h2('5.1 — Reactive Variables in GetX'),
  p('GetX has three ways to make a variable reactive (observable):'),

  headerTable(
    ['Type', 'Declaration', 'Usage in UI'],
    [
      ['Single value', 'final name = "".obs', 'Obx(() => Text(ctrl.name.value))'],
      ['Object', 'final user = Rx<UserModel?>(null)', 'Obx(() => Text(ctrl.user.value?.name ?? ""))'],
      ['List', 'final items = <String>[].obs', 'Obx(() => ListView(children: ctrl.items.map(...)))'],
      ['Bool', 'final isLoading = false.obs', 'Obx(() => ctrl.isLoading.value ? Spinner() : Button())'],
    ]
  ),

  h2('5.2 — AuthController'),
  ...codeBlock([
    'class AuthController extends GetxController {',
    '  // Reactive — screens watch this with Obx()',
    '  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);',
    '  final RxBool isLoading = false.obs;',
    '',
    '  @override',
    '  void onInit() {',
    '    super.onInit();',
    '    _checkSession();   // Runs once when controller is created',
    '  }',
    '',
    '  // Restore session on app start',
    '  void _checkSession() {',
    '    final user = HiveService.currentUser;   // Read from Hive session box',
    '    if (user != null) {',
    '      currentUser.value = user;             // Set reactive variable',
    '    }',
    '  }',
    '',
    '  // Computed getters — derived from currentUser',
    '  bool get isLoggedIn => currentUser.value != null;',
    '  bool get isAdmin    => currentUser.value?.isAdmin ?? false;',
    '',
    '  Future<bool> login(String email, String password) async {',
    '    isLoading.value = true;   // Triggers UI to show spinner',
    '    try {',
    '      final user = await HiveService.login(email, password);',
    '      if (user != null) {',
    '        currentUser.value = user;          // Reactive update',
    '        HiveService.saveSession(user.id);  // Persist session',
    '        return true;',
    '      }',
    '      return false;',
    '    } finally {',
    '      isLoading.value = false;  // Always runs — even if error thrown',
    '    }',
    '  }',
    '',
    '  Future<String?> register({ required String name, ... }) async {',
    '    isLoading.value = true;',
    '    try {',
    '      final uuid = const Uuid().v4();',
    '      final regCode = "VID-\${DateTime.now().year}-\${uuid.substring(0,6).toUpperCase()}";',
    '      final user = UserModel(id: uuid, regCode: regCode, ...);',
    '      final success = await HiveService.register(user);',
    '      if (success) {',
    '        currentUser.value = user;',
    '        HiveService.saveSession(user.id);',
    '        return null;   // null = success',
    '      }',
    '      return "Email already registered";  // Non-null = error message',
    '    } finally {',
    '      isLoading.value = false;',
    '    }',
    '  }',
    '',
    '  void logout() {',
    '    HiveService.clearSession();',
    '    currentUser.value = null;          // Clears reactive state',
    '    Get.offAllNamed("/login");         // Navigate and clear stack',
    '  }',
    '}',
  ]),

  important('The try/finally pattern ensures isLoading.value = false always runs, even if an exception is thrown inside the try block. Without finally, a thrown error would leave the button stuck in loading state.'),

  h2('5.3 — SubmissionController'),
  ...codeBlock([
    'class SubmissionController extends GetxController {',
    '  final AuthController _auth = Get.find<AuthController>();',
    '',
    '  // User-facing reactive lists',
    '  final RxList<SubmissionModel> abstracts  = <SubmissionModel>[].obs;',
    '  final RxList<SubmissionModel> preconfs   = <SubmissionModel>[].obs;',
    '  final RxList<SubmissionModel> workshops  = <SubmissionModel>[].obs;',
    '  final RxList<CertificateModel> certificates = <CertificateModel>[].obs;',
    '',
    '  // Admin-facing reactive lists',
    '  final RxList<SubmissionModel> allAbstracts = <SubmissionModel>[].obs;',
    '  // ... allPreconfs, allWorkshops, allCertificates',
    '',
    '  @override',
    '  void onInit() {',
    '    super.onInit();',
    '    loadAll();',
    '  }',
    '',
    '  // Decides what to load based on who is logged in',
    '  void loadAll() {',
    '    final user = _auth.currentUser.value;',
    '    if (user == null) return;',
    '    if (user.isAdmin) {',
    '      allAbstracts.value = HiveService.getAllSubmissionsByType("abstract");',
    '      // ... loads all admin lists',
    '    } else {',
    '      abstracts.value = HiveService.getUserSubmissions(user.id, "abstract");',
    '      // ... loads user-specific lists',
    '    }',
    '  }',
    '',
    '  // Submit a new abstract',
    '  Future<void> submitAbstract({ required String title, ... }) async {',
    '    isLoading.value = true;',
    '    try {',
    '      final submission = SubmissionModel(',
    '        id: const Uuid().v4(),',
    '        userId: _auth.currentUser.value!.id,',
    '        userName: _auth.currentUser.value!.name,',
    '        type: "abstract",',
    '        status: "pending",',
    '        submittedAt: DateTime.now(),',
    '        title: title,',
    '        // ...',
    '      );',
    '      await HiveService.addSubmission(submission);',
    '      loadAll();   // Refresh all lists so UI updates immediately',
    '    } finally {',
    '      isLoading.value = false;',
    '    }',
    '  }',
    '',
    '  // Admin: update status and add remark',
    '  Future<void> updateStatus(String id, String status, String? remark) async {',
    '    await HiveService.updateSubmissionStatus(id, status, remark);',
    '    loadAll();   // Refresh so admin sees updated status immediately',
    '  }',
    '}',
  ]),

  tip('Every submit/update method calls loadAll() after writing to Hive. This re-reads from Hive and updates all reactive lists. Since screens use Obx() to watch these lists, they automatically rebuild to show the new data.'),

  pageBreak(),

  // ══════════════════════════════════════════════════════════════════
  // CHAPTER 6 — MAIN.DART
  // ══════════════════════════════════════════════════════════════════
  h1('Chapter 6 — main.dart (App Entry Point)'),

  p('main.dart is the first file Flutter runs. It does four things in order: initialise, configure, inject dependencies, start the app.'),

  ...codeBlock([
    'void main() async {',
    '  // 1. Must be called before anything that uses platform channels',
    '  WidgetsFlutterBinding.ensureInitialized();',
    '',
    '  // 2. Tell Google Fonts to load from internet, not from local assets',
    '  //    Prevents 404 errors for fonts from other projects in dev cache',
    '  GoogleFonts.config.allowRuntimeFetching = true;',
    '',
    '  // 3. Lock the app to portrait mode only',
    '  await SystemChrome.setPreferredOrientations([',
    '    DeviceOrientation.portraitUp,',
    '    DeviceOrientation.portraitDown,',
    '  ]);',
    '',
    '  // 4. Make status bar transparent with white icons',
    '  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(',
    '    statusBarColor: Colors.transparent,',
    '    statusBarIconBrightness: Brightness.light,',
    '  ));',
    '',
    '  // 5. Initialise Hive — MUST complete before runApp',
    '  await HiveService.init();',
    '',
    '  runApp(const VidyenApp());',
    '}',
  ]),

  h2('6.1 — VidyenApp Widget'),
  ...codeBlock([
    'class VidyenApp extends StatelessWidget {',
    '  @override',
    '  Widget build(BuildContext context) {',
    '    return GetMaterialApp(           // GetX\'s replacement for MaterialApp',
    '      title: "VIDYEN",',
    '      debugShowCheckedModeBanner: false,',
    '      theme: AppTheme.dark,          // Our custom theme',
    '      initialBinding: AppBindings(), // Inject controllers before first screen',
    '      initialRoute: "/splash",       // First screen',
    '      getPages: [                    // Route definitions',
    '        GetPage(name: "/splash",   page: () => const SplashScreen()),',
    '        GetPage(name: "/login",    page: () => const LoginScreen()),',
    '        GetPage(name: "/register", page: () => const RegisterScreen()),',
    '        GetPage(name: "/home",     page: () => const HomeScreen(),',
    '                                   transition: Transition.fadeIn),',
    '        GetPage(name: "/admin-home", page: () => const AdminHomeScreen(),',
    '                                     transition: Transition.fadeIn),',
    '        GetPage(name: "/profile",  page: () => const ProfileScreen()),',
    '      ],',
    '      defaultTransition: Transition.cupertino,  // iOS-style slide',
    '      transitionDuration: const Duration(milliseconds: 250),',
    '    );',
    '  }',
    '}',
  ]),

  h2('6.2 — AppBindings'),
  ...codeBlock([
    'class AppBindings extends Bindings {',
    '  @override',
    '  void dependencies() {',
    '    // permanent: true means these controllers are NEVER deleted from memory',
    '    Get.put<AuthController>(AuthController(), permanent: true);',
    '    Get.put<SubmissionController>(SubmissionController(), permanent: true);',
    '  }',
    '}',
  ]),

  p('Bindings run before the first screen appears. This ensures AuthController is ready so that when SplashScreen checks auth.isLoggedIn, the controller already has the session restored from Hive.'),

  tip('Get.put() creates the controller and stores it in GetX\'s dependency container. Any screen or other controller can then retrieve it with Get.find<AuthController>(). The permanent: true flag prevents GetX from deleting the controller when you navigate away from a screen.'),

  pageBreak(),

  // ══════════════════════════════════════════════════════════════════
  // CHAPTER 7 — THEME AND COLORS
  // ══════════════════════════════════════════════════════════════════
  h1('Chapter 7 — AppTheme & AppColors (app_theme.dart)'),

  p('app_theme.dart contains three classes: AppColors (color constants), AppTheme (the ThemeData), and AppConstants (string constants and data lists). Centralising all styling here means you change a color in one place and it updates everywhere.'),

  h2('7.1 — AppColors'),
  ...codeBlock([
    'class AppColors {',
    '  // All colors are static const — compile-time constants, zero memory',
    '  static const Color primary    = Color(0xFF0A1628); // Deep navy background',
    '  static const Color accent     = Color(0xFF1E6FD9); // Blue — primary actions',
    '  static const Color accentLight= Color(0xFF4A9FFF); // Light blue — links',
    '  static const Color gold       = Color(0xFFD4A843); // Gold — admin theme',
    '  static const Color goldLight  = Color(0xFFF0C96A); // Light gold',
    '  static const Color surface    = Color(0xFF0F2040); // AppBar/nav background',
    '  static const Color cardBg     = Color(0xFF162848); // Card backgrounds',
    '  static const Color white      = Color(0xFFFFFFFF);',
    '  static const Color white70    = Color(0xB3FFFFFF); // 70% opacity white',
    '  static const Color white50    = Color(0x80FFFFFF); // 50% opacity white',
    '  static const Color white20    = Color(0x33FFFFFF); // 20% opacity white',
    '  static const Color white10    = Color(0x1AFFFFFF); // 10% opacity white',
    '  static const Color success    = Color(0xFF2ECC71); // Green — approved',
    '  static const Color warning    = Color(0xFFF39C12); // Orange — pending',
    '  static const Color error      = Color(0xFFE74C3C); // Red — rejected',
    '}',
  ]),

  p('Color(0xFF0A1628): The 0xFF prefix is the alpha channel (FF = fully opaque). The next 6 digits are the hex RGB values. So 0xFF0A1628 = alpha:FF, red:0A, green:16, blue:28.'),
  p('Color(0xB3FFFFFF): B3 in hex = 179 in decimal. 179/255 = 70% opacity. This is how white70 is 70% transparent white.'),

  h2('7.2 — AppTheme'),
  p('AppTheme.dark returns a ThemeData that styles every Flutter widget globally. You define it once, and all TextFormFields, ElevatedButtons, AppBars in the entire app automatically use it.'),

  ...codeBlock([
    'static ThemeData get dark {',
    '  return ThemeData(',
    '    brightness: Brightness.dark,',
    '    scaffoldBackgroundColor: AppColors.primary,',
    '',
    '    // inputDecorationTheme — styles ALL TextFormField widgets globally',
    '    inputDecorationTheme: InputDecorationTheme(',
    '      filled: true,',
    '      fillColor: AppColors.white10,         // Subtle input background',
    '      border: OutlineInputBorder(',
    '        borderRadius: BorderRadius.circular(12),',
    '        borderSide: const BorderSide(color: AppColors.white20),',
    '      ),',
    '      focusedBorder: OutlineInputBorder(',
    '        borderRadius: BorderRadius.circular(12),',
    '        borderSide: const BorderSide(color: AppColors.accent, width: 2),',
    '      ),',
    '      // labelStyle, hintStyle also set here globally',
    '    ),',
    '',
    '    // elevatedButtonTheme — styles ALL ElevatedButton widgets globally',
    '    elevatedButtonTheme: ElevatedButtonThemeData(',
    '      style: ElevatedButton.styleFrom(',
    '        backgroundColor: AppColors.accent,',
    '        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),',
    '      ),',
    '    ),',
    '    useMaterial3: true,',
    '  );',
    '}',
  ]),

  h2('7.3 — AppConstants'),
  ...codeBlock([
    'class AppConstants {',
    '  static const String appName = "VIDYEN";',
    '',
    '  // Hive box names — use constants to avoid typos',
    '  static const String usersBox        = "users";',
    '  static const String submissionsBox  = "submissions";',
    '  static const String certificatesBox = "certificates";',
    '  static const String sessionBox      = "session";',
    '',
    '  // Dropdown options used in forms',
    '  static const List<String> delegateTypes = [',
    '    "Speaker", "Delegate", "Presenter",',
    '    "Workshop Facilitator", "Moderator", "Observer",',
    '  ];',
    '',
    '  static const List<String> abstractCategories = [',
    '    "Clinical Research", "Basic Science", "Public Health",',
    '    "Technology & Innovation", "Education & Training", "Policy & Advocacy",',
    '  ];',
    '}',
  ]),

  pageBreak(),

  // ══════════════════════════════════════════════════════════════════
  // CHAPTER 8 — RESPONSIVE SYSTEM
  // ══════════════════════════════════════════════════════════════════
  h1('Chapter 8 — Responsive System (responsive.dart)'),

  p('The Responsive class makes the UI adapt to different screen sizes — mobile phone, tablet, and desktop. It must be initialised in every build() method with Responsive.init(context) before its properties are used.'),

  h2('8.1 — Breakpoints'),
  ...codeBlock([
    'static bool get isMobile  => screenWidth < 600;',
    'static bool get isTablet  => screenWidth >= 600 && screenWidth < 1024;',
    'static bool get isDesktop => screenWidth >= 1024;',
  ]),

  headerTable(
    ['Breakpoint', 'Width', 'Devices'],
    [
      ['Mobile',  '< 600px',        'Phones — most Android/iPhone devices'],
      ['Tablet',  '600–1023px',     'iPads, Android tablets, small windows'],
      ['Desktop', '>= 1024px',      'Laptops, large tablets in landscape'],
    ]
  ),

  h2('8.2 — Safe Sizing Methods'),
  p('On mobile, all sizing methods return the raw value unchanged. This prevents overflow. On larger screens they add a small fixed amount.'),

  ...codeBlock([
    'static double font(double size) {',
    '  if (isDesktop) return size + 2;   // e.g. font(14) = 16 on desktop',
    '  if (isTablet)  return size + 1;   // e.g. font(14) = 15 on tablet',
    '  return size;                       // e.g. font(14) = 14 on mobile',
    '}',
    '',
    'static double sp(double size) {     // Spacing/padding',
    '  if (isDesktop) return size + 4;',
    '  if (isTablet)  return size + 2;',
    '  return size;',
    '}',
    '',
    'static double icon(double size) {',
    '  if (isDesktop) return size + 3;',
    '  if (isTablet)  return size + 1;',
    '  return size;',
    '}',
  ]),

  warn('DO NOT multiply size values. Old code like size * (screenWidth/390) caused overflow because on a 430px phone the multiplier was >1, and on narrow screens it was <1 in unpredictable ways. Fixed additive increments are safe and predictable.'),

  h2('8.3 — Layout Helpers'),
  ...codeBlock([
    '// Returns double.infinity on mobile — never constrains mobile content',
    'static double get maxContentWidth {',
    '  if (isDesktop) return 960;',
    '  if (isTablet)  return 720;',
    '  return double.infinity;',
    '}',
    '',
    '// How to use in a screen:',
    'Center(',
    '  child: ConstrainedBox(',
    '    constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),',
    '    child: myContent,',
    '  ),',
    ')',
  ]),

  h2('8.4 — Adaptive Layouts'),
  p('Use Responsive.isMobile to switch between layouts:'),

  ...codeBlock([
    '// Different navigation style per platform:',
    'body: Responsive.isMobile',
    '    ? _buildBody()                   // Body fills full width on mobile',
    '    : Row(children: [',
    '        _buildNavRail(),             // Side navigation on tablet/desktop',
    '        const VerticalDivider(...),',
    '        Expanded(child: _buildBody()),',
    '      ]),',
    'bottomNavigationBar: Responsive.isMobile ? _buildBottomNavBar() : null,',
    '',
    '// Different grid column count:',
    'GridView.count(',
    '  crossAxisCount: Responsive.gridCrossAxisCount(',
    '    mobile: 2, tablet: 3, desktop: 4,',
    '  ),',
    '  ...',
    ')',
    '',
    '// Different form layout:',
    'if (Responsive.isMobile)',
    '  Column(children: [fieldA, fieldB])    // Stacked',
    'else',
    '  Row(children: [                        // Side by side',
    '    Expanded(child: fieldA),',
    '    Expanded(child: fieldB),',
    '  ])',
  ]),

  pageBreak(),

  // ══════════════════════════════════════════════════════════════════
  // CHAPTER 9 — COMMON WIDGETS
  // ══════════════════════════════════════════════════════════════════
  h1('Chapter 9 — Common Widgets (common_widgets.dart)'),

  p('This file contains reusable UI components used across multiple screens. Building shared widgets avoids repeating the same decoration code everywhere and ensures a consistent look.'),

  h2('9.1 — StatusBadge'),
  p('Displays a coloured pill badge showing Approved, Pending, or Rejected. Used on submission cards and user cards.'),

  ...codeBlock([
    'class StatusBadge extends StatelessWidget {',
    '  final String status;',
    '  const StatusBadge(this.status, {super.key});',
    '',
    '  @override',
    '  Widget build(BuildContext context) {',
    '    Color color;',
    '    String label;',
    '    switch (status.toLowerCase()) {',
    '      case "approved": color = AppColors.success; label = "Approved"; break;',
    '      case "rejected": color = AppColors.error;   label = "Rejected"; break;',
    '      default:         color = AppColors.warning; label = "Pending";',
    '    }',
    '    return Container(',
    '      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),',
    '      decoration: BoxDecoration(',
    '        color: color.withOpacity(0.15),   // Translucent background',
    '        borderRadius: BorderRadius.circular(20),',
    '        border: Border.all(color: color.withOpacity(0.4)),',
    '      ),',
    '      child: Text(label, style: GoogleFonts.inter(color: color, ...)),',
    '    );',
    '  }',
    '}',
  ]),

  h2('9.2 — GradientButton'),
  p('The primary action button with a blue gradient background and optional loading state.'),

  ...codeBlock([
    'class GradientButton extends StatelessWidget {',
    '  final String label;',
    '  final VoidCallback onTap;',
    '  final IconData? icon;',
    '  final bool isLoading;',
    '',
    '  @override',
    '  Widget build(BuildContext context) {',
    '    return GestureDetector(',
    '      onTap: isLoading ? null : onTap,  // Disable tap while loading',
    '      child: Container(',
    '        width: double.infinity,',
    '        padding: const EdgeInsets.symmetric(vertical: 15),',
    '        decoration: BoxDecoration(',
    '          gradient: const LinearGradient(',
    '            colors: [AppColors.accent, Color(0xFF1052A8)],',
    '          ),',
    '          borderRadius: BorderRadius.circular(12),',
    '          boxShadow: [BoxShadow(            // Glow effect',
    '            color: AppColors.accent.withOpacity(0.35),',
    '            blurRadius: 16,',
    '            offset: const Offset(0, 6),',
    '          )],',
    '        ),',
    '        child: isLoading',
    '            ? const CircularProgressIndicator(color: AppColors.white)',
    '            : Row(mainAxisAlignment: MainAxisAlignment.center, children: [',
    '                if (icon != null) Icon(icon, ...),',
    '                Text(label, ...),',
    '              ]),',
    '      ),',
    '    );',
    '  }',
    '}',
  ]),

  h2('9.3 — SubmissionCard'),
  p('Displays a single submission with its title, status badge, category, description, optional admin remark, and date. Used in both user screens and admin screens.'),

  h2('9.4 — StatCard'),
  p('A small card with an icon, a big number, and a label. Used in the dashboard stats grid. The icon has a coloured background matching the card\'s accent colour.'),

  pageBreak(),

  // ══════════════════════════════════════════════════════════════════
  // CHAPTER 10 — SCREENS
  // ══════════════════════════════════════════════════════════════════
  h1('Chapter 10 — Screens (User Flow)'),

  h2('10.1 — SplashScreen'),
  p('The first screen. Shows an animated logo for 3 seconds then redirects automatically.'),

  ...codeBlock([
    'class _SplashScreenState extends State<SplashScreen>',
    '    with SingleTickerProviderStateMixin {',
    '',
    '  // SingleTickerProviderStateMixin provides the vsync for AnimationController',
    '  late AnimationController _controller;',
    '  late Animation<double> _fadeAnim;   // 0.0 → 1.0 (opacity)',
    '  late Animation<double> _scaleAnim; // 0.7 → 1.0 (zoom in)',
    '  late Animation<double> _slideAnim; // 30 → 0 (slide up)',
    '',
    '  @override',
    '  void initState() {',
    '    super.initState();',
    '    _controller = AnimationController(',
    '      vsync: this,',
    '      duration: const Duration(milliseconds: 1800),',
    '    );',
    '',
    '    // Interval(0, 0.6) = runs during first 60% of animation duration',
    '    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(',
    '      CurvedAnimation(parent: _controller,',
    '          curve: const Interval(0, 0.6)),',
    '    );',
    '',
    '    // Curves.elasticOut = overshoots then settles = bouncy feel',
    '    _scaleAnim = Tween<double>(begin: 0.7, end: 1).animate(',
    '      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),',
    '    );',
    '',
    '    _controller.forward();  // Start animation',
    '    _navigate();            // Schedule redirect',
    '  }',
    '',
    '  void _navigate() async {',
    '    await Future.delayed(const Duration(seconds: 3));',
    '    final auth = Get.find<AuthController>();',
    '    if (auth.isLoggedIn) {',
    '      // Send to correct portal based on role',
    '      Get.offAllNamed(auth.isAdmin ? "/admin-home" : "/home");',
    '    } else {',
    '      Get.offAllNamed("/login");',
    '    }',
    '  }',
    '',
    '  @override',
    '  void dispose() {',
    '    _controller.dispose();  // ALWAYS dispose controllers to prevent memory leaks',
    '    super.dispose();',
    '  }',
    '}',
  ]),

  tip('Get.offAllNamed() navigates to a new route AND removes all previous routes from the stack. This means the user cannot press the back button to return to the splash screen.'),

  h2('10.2 — LoginScreen'),
  p('Email and password form with validation. Uses GlobalKey<FormState> to trigger validation on all fields at once.'),

  ...codeBlock([
    '// Form validation pattern:',
    'final _formKey = GlobalKey<FormState>();',
    '',
    '// Wrap all fields in Form widget:',
    'Form(',
    '  key: _formKey,',
    '  child: Column(children: [',
    '    TextFormField(',
    '      validator: (v) {',
    '        if (v == null || v.isEmpty) return "Email is required";',
    '        if (!GetUtils.isEmail(v))   return "Enter valid email";',
    '        return null;   // null means valid',
    '      },',
    '    ),',
    '    ElevatedButton(',
    '      onPressed: () {',
    '        if (_formKey.currentState!.validate()) {  // Runs all validators',
    '          _login();  // Only called if all validators return null',
    '        }',
    '      },',
    '    ),',
    '  ]),',
    ')',
    '',
    '// Obx watches isLoading and rebuilds the button:',
    'Obx(() => GradientButton(',
    '  isLoading: _auth.isLoading.value,  // .value reads the reactive variable',
    '  onTap: _login,',
    '))',
  ]),

  h2('10.3 — RegisterScreen'),
  p('Two-step registration. Step 1 collects personal info. Step 2 collects professional details. The _step variable controls which step is shown.'),

  ...codeBlock([
    '// Step state — triggers a rebuild when changed:',
    'int _step = 0;',
    '',
    '// In build():',
    '_step == 0 ? _buildStep1() : _buildStep2()',
    '',
    '// Step 1 validation before allowing to proceed:',
    'bool _validateStep1() {',
    '  if (_nameCtrl.text.trim().isEmpty) {',
    '    _snack("Missing Fields", "Please fill all fields", AppColors.error);',
    '    return false;',
    '  }',
    '  if (_passCtrl.text != _confirmCtrl.text) {',
    '    _snack("Password Mismatch", "Passwords do not match", AppColors.error);',
    '    return false;',
    '  }',
    '  return true;',
    '}',
    '',
    'GradientButton(',
    '  label: "Next",',
    '  onTap: () {',
    '    if (_validateStep1()) setState(() => _step = 1);',
    '  },',
    ')',
  ]),

  h2('10.4 — HomeScreen (User Portal Shell)'),
  p('HomeScreen is a shell — it contains the navigation structure but renders child screens based on the selected tab index. It switches between bottom navigation bar (mobile) and navigation rail (tablet/desktop).'),

  ...codeBlock([
    '// Tab index controls which screen is shown:',
    'int _selectedIndex = 0;',
    '',
    'Widget _buildBody() {',
    '  switch (_selectedIndex) {',
    '    case 0: return const DashboardHomeTab();',
    '    case 1: return const AbstractScreen();',
    '    case 2: return const PreconfScreen();',
    '    case 3: return const WorkshopScreen();',
    '    case 4: return const CertificateScreen();',
    '    default: return const DashboardHomeTab();',
    '  }',
    '}',
    '',
    '// AnimatedSwitcher gives a smooth fade when tabs change:',
    'AnimatedSwitcher(',
    '  duration: const Duration(milliseconds: 250),',
    '  child: KeyedSubtree(',
    '    key: ValueKey(_selectedIndex),  // Key change triggers animation',
    '    child: _buildBody(),',
    '  ),',
    ')',
    '',
    '// Mobile bottom nav — tap updates _selectedIndex:',
    'GestureDetector(',
    '  onTap: () => setState(() => _selectedIndex = i),',
    '  behavior: HitTestBehavior.opaque,  // Tap anywhere in the area',
    '  child: Column(children: [icon, label]),',
    ')',
    '',
    '// Tablet/Desktop nav rail:',
    'NavigationRail(',
    '  extended: Responsive.isDesktop,   // Shows labels when extended',
    '  selectedIndex: _selectedIndex,',
    '  onDestinationSelected: (i) => setState(() => _selectedIndex = i),',
    '  destinations: [...],',
    ')',
  ]),

  pageBreak(),

  // ══════════════════════════════════════════════════════════════════
  // CHAPTER 11 — DASHBOARD TABS
  // ══════════════════════════════════════════════════════════════════
  h1('Chapter 11 — Dashboard Tab Screens'),

  h2('11.1 — DashboardHomeTab'),
  p('The main home tab. Shows a welcome banner with the user\'s details, stat cards, quick action grid, and conference info.'),

  ...codeBlock([
    '// Obx watches currentUser — rebuilds when login/logout happens:',
    'Obx(() {',
    '  final user = auth.currentUser.value;',
    '  return Container(',
    '    child: Column(children: [',
    '      Text(user?.name ?? "Participant"),',
    '      Text(user?.regCode ?? "N/A"),',
    '      StatusBadge(user?.status ?? "pending"),',
    '    ]),',
    '  );',
    '})',
    '',
    '// Stat cards in a Row — each Expanded takes equal width:',
    'Obx(() => Row(children: [',
    '  Expanded(child: StatCard(',
    '    value: sub.abstracts.length.toString(),  // Reacts to list changes',
    '    label: "Abstracts",',
    '    icon: Icons.article_rounded,',
    '    color: AppColors.accent,',
    '  )),',
    '  const SizedBox(width: 10),',
    '  Expanded(child: StatCard(value: sub.preconfs.length.toString(), ...)),',
    '  // ... workshops, certificates',
    ']))',
  ]),

  h2('11.2 — AbstractScreen / PreconfScreen / WorkshopScreen'),
  p('These three screens follow the exact same pattern — only the type string and color differ. A FAB (FloatingActionButton) at the bottom opens the submission form sheet.'),

  ...codeBlock([
    '// Obx watches the user\'s submission list:',
    'Obx(() {',
    '  final list = sub.abstracts;',
    '  if (list.isEmpty) return _emptyState();',
    '  return ListView.builder(',
    '    itemCount: list.length,',
    '    itemBuilder: (_, i) => SubmissionCard(submission: list[i]),',
    '  );',
    '})',
    '',
    '// FAB opens the bottom sheet form:',
    'FloatingActionButton.extended(',
    '  onPressed: () => Get.bottomSheet(',
    '    SubmissionFormSheet(',
    '      type: "abstract",',
    '      title: "Abstract",',
    '      categories: AppConstants.abstractCategories,',
    '      onSubmit: ({required title, required description, ...}) =>',
    '          sub.submitAbstract(title: title, description: description, ...),',
    '    ),',
    '    isScrollControlled: true,    // Sheet can go full height',
    '    backgroundColor: Colors.transparent,',
    '  ),',
    ')',
  ]),

  h2('11.3 — SubmissionFormSheet'),
  p('A DraggableScrollableSheet wrapped in a Container. The user can drag it up to make it taller, or it starts at 92% of screen height.'),

  ...codeBlock([
    'DraggableScrollableSheet(',
    '  initialChildSize: 0.92,   // Starts at 92% of screen height',
    '  minChildSize: 0.5,        // Can drag down to 50%',
    '  maxChildSize: 0.95,       // Can drag up to 95%',
    '  expand: false,            // Does not force full height',
    '  builder: (_, scrollController) => Column(',
    '    children: [',
    '      // Drag handle',
    '      Container(width: 40, height: 4, ...),',
    '      // Title and close button',
    '      // Scrollable form content',
    '      Expanded(child: SingleChildScrollView(',
    '        controller: scrollController,  // Connects to DraggableScrollableSheet',
    '        child: Form(...),',
    '      )),',
    '    ],',
    '  ),',
    ')',
    '',
    '// File picker:',
    'Future<void> _pickFile() async {',
    '  final result = await FilePicker.platform.pickFiles(',
    '    type: FileType.custom,',
    '    allowedExtensions: ["pdf", "doc", "docx", "ppt", "pptx"],',
    '  );',
    '  if (result != null) {',
    '    setState(() {',
    '      _filePath = result.files.single.path;',
    '      _fileName = result.files.single.name;',
    '    });',
    '  }',
    '}',
  ]),

  pageBreak(),

  // ══════════════════════════════════════════════════════════════════
  // CHAPTER 12 — ADMIN SCREENS
  // ══════════════════════════════════════════════════════════════════
  h1('Chapter 12 — Admin Screens'),

  h2('12.1 — AdminHomeScreen'),
  p('The admin portal shell. Has 6 tabs: Dashboard, Users, Abstract, Pre-Conf, Workshop, Certificates. On mobile, a scrollable horizontal bottom nav holds all 6. On tablet/desktop, a NavigationRail is used.'),

  ...codeBlock([
    '// 6 tabs defined:',
    'final List<_NavItem> _navItems = [',
    '  _NavItem("Dashboard", Icons.dashboard_outlined, Icons.dashboard_rounded),',
    '  _NavItem("Users",     Icons.people_outlined,    Icons.people_rounded),',
    '  _NavItem("Abstract",  Icons.article_outlined,   Icons.article_rounded),',
    '  _NavItem("Pre-Conf",  Icons.event_outlined,     Icons.event_rounded),',
    '  _NavItem("Workshop",  Icons.build_circle_outlined, Icons.build_circle_rounded),',
    '  _NavItem("Certs",     Icons.workspace_premium_outlined, Icons.workspace_premium_rounded),',
    '];',
    '',
    'Widget _buildBody() {',
    '  switch (_selectedIndex) {',
    '    case 0: return const AdminDashboardTab();',
    '    case 1: return const AdminUsersTab();',
    '    case 2: return const AdminSubmissionsTab(type: "abstract", label: "Abstracts");',
    '    case 3: return const AdminSubmissionsTab(type: "preconf",  label: "Pre-Conference");',
    '    case 4: return const AdminSubmissionsTab(type: "workshop", label: "Workshops");',
    '    case 5: return const AdminCertificatesTab();',
    '    default: return const AdminDashboardTab();',
    '  }',
    '}',
    '',
    '// Mobile: scrollable horizontal nav for 6 items',
    'SizedBox(',
    '  height: 58,',
    '  child: SingleChildScrollView(',
    '    scrollDirection: Axis.horizontal,',
    '    physics: const BouncingScrollPhysics(),',
    '    child: Row(children: [...navItems each 68px wide...]),',
    '  ),',
    ')',
  ]),

  h2('12.2 — AdminUsersTab'),
  p('Shows all participants (non-admin users). Features search by name/email, filter by status, approve/reject buttons, and a detail dialog.'),

  ...codeBlock([
    '// Filter + search logic:',
    'List<UserModel> get _filteredUsers {',
    '  var users = HiveService.getAllUsers();',
    '  if (_filter != "all")',
    '    users = users.where((u) => u.status == _filter).toList();',
    '  if (_searchQuery.isNotEmpty)',
    '    users = users.where((u) =>',
    '      u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||',
    '      u.email.toLowerCase().contains(_searchQuery.toLowerCase())',
    '    ).toList();',
    '  return users;',
    '}',
    '',
    '// Approve/Reject:',
    '_UserCard(',
    '  user: _filteredUsers[i],',
    '  onStatusChange: (status) async {',
    '    await HiveService.updateUserStatus(_filteredUsers[i].id, status);',
    '    setState(() {});  // Refresh list',
    '  },',
    ')',
  ]),

  h2('12.3 — AdminSubmissionsTab'),
  p('One widget handles Abstract, Pre-Conf and Workshop review — the type and label are passed as constructor parameters. Tapping a submission card opens a review dialog.'),

  ...codeBlock([
    '// Reusable for all 3 submission types:',
    'class AdminSubmissionsTab extends StatefulWidget {',
    '  final String type;    // "abstract", "preconf", "workshop"',
    '  final String label;   // "Abstracts", "Pre-Conference", "Workshops"',
    '}',
    '',
    '// Review dialog — approve/reject/pending + remarks:',
    'void _showReview(BuildContext context) {',
    '  final remarkCtrl = TextEditingController(text: submission.adminRemark ?? "");',
    '  String selectedStatus = submission.status;',
    '',
    '  Get.dialog(StatefulBuilder(builder: (_, setState) => AlertDialog(',
    '    // StatefulBuilder lets the dialog have its own setState',
    '    content: Column(children: [',
    '      // Submission details',
    '      // 3 status option buttons (approve/reject/pending)',
    '      Row(children: [',
    '        _statusOpt("approve",  "Approve", AppColors.success, ...),',
    '        _statusOpt("rejected", "Reject",  AppColors.error,   ...),',
    '        _statusOpt("pending",  "Pending", AppColors.warning, ...),',
    '      ]),',
    '      // Remarks text field',
    '      TextField(controller: remarkCtrl),',
    '    ]),',
    '    actions: [',
    '      ElevatedButton(',
    '        onPressed: () async {',
    '          Get.back();',
    '          final status = selectedStatus == "approve" ? "approved" : selectedStatus;',
    '          await onAction(status, remarkCtrl.text.trim());',
    '        },',
    '        child: Text("Save Decision"),',
    '      ),',
    '    ],',
    '  )));',
    '}',
  ]),

  h2('12.4 — AdminCertificatesTab'),
  p('Two sub-tabs managed by a TabController. Issue Certificate tab and Issued tab.'),

  ...codeBlock([
    '// TabController for the two sub-tabs:',
    'late TabController _tabCtrl;',
    '',
    '@override',
    'void initState() {',
    '  super.initState();',
    '  _tabCtrl = TabController(length: 2, vsync: this);',
    '}',
    '',
    '@override',
    'void dispose() {',
    '  _tabCtrl.dispose();   // MUST dispose — prevents memory leak',
    '  super.dispose();',
    '}',
    '',
    '// Issue certificate:',
    'Future<void> _issue() async {',
    '  if (_selectedUser == null) { _showError("Select User"); return; }',
    '  if (_titleCtrl.text.isEmpty) { _showError("Enter Title"); return; }',
    '',
    '  await widget.sub.issueCertificate(',
    '    userId:   _selectedUser!.id,',
    '    userName: _selectedUser!.name,',
    '    title:    _titleCtrl.text.trim(),',
    '    type:     _certType,',
    '  );',
    '',
    '  // Reset form after issuing',
    '  setState(() { _selectedUser = null; _titleCtrl.clear(); });',
    '}',
  ]),

  pageBreak(),

  // ══════════════════════════════════════════════════════════════════
  // CHAPTER 13 — KEY PATTERNS
  // ══════════════════════════════════════════════════════════════════
  h1('Chapter 13 — Key Dart & Flutter Patterns Used'),

  h2('13.1 — Null Safety'),
  p('Dart 3 has sound null safety. Every variable is either nullable (String?) or non-nullable (String). You must handle nullable values explicitly.'),

  ...codeBlock([
    'String? name;           // Can be null',
    'String email;           // Cannot be null — must be initialised',
    '',
    '// The ?. operator — safe access on nullable:',
    'user?.name              // Returns null if user is null',
    '',
    '// The ?? operator — default if null:',
    'user?.name ?? "Guest"   // Returns "Guest" if user is null or name is null',
    '',
    '// The ! operator — assert non-null (crashes if null):',
    'user!.name              // Use only when you are 100% sure user is not null',
    '',
    '// Null-aware assignment:',
    'user ??= UserModel(...) // Only assigns if user is currently null',
  ]),

  h2('13.2 — async / await'),
  ...codeBlock([
    '// async marks a function that runs asynchronously',
    '// await pauses execution until the Future completes',
    '',
    'Future<bool> login(String email, String password) async {',
    '  isLoading.value = true;',
    '  try {',
    '    // await pauses here until HiveService.login() finishes',
    '    final user = await HiveService.login(email, password);',
    '    return user != null;',
    '  } finally {',
    '    isLoading.value = false;  // Runs whether success or error',
    '  }',
    '}',
    '',
    '// Calling an async function:',
    'final success = await _auth.login(email, pass);',
    'if (success) { Get.offAllNamed("/home"); }',
  ]),

  h2('13.3 — GetX Navigation'),
  ...codeBlock([
    'Get.toNamed("/profile")          // Push — adds to stack, can go back',
    'Get.offNamed("/home")            // Replace current — removes this screen',
    'Get.offAllNamed("/login")        // Go to route and clear entire stack',
    'Get.back()                       // Pop — go back to previous screen',
    '',
    'Get.snackbar(                    // Show a snackbar notification',
    '  "Title", "Message",',
    '  backgroundColor: AppColors.success,',
    '  snackPosition: SnackPosition.BOTTOM,',
    ')',
    '',
    'Get.dialog(AlertDialog(...))     // Show a dialog',
  ]),

  h2('13.4 — GetX Reactive State (Obx)'),
  ...codeBlock([
    '// In controller — declare reactive variable:',
    'final RxBool isLoading = false.obs;',
    'final Rx<UserModel?> currentUser = Rx<UserModel?>(null);',
    'final RxList<SubmissionModel> abstracts = <SubmissionModel>[].obs;',
    '',
    '// Change the value:',
    'isLoading.value = true;',
    'currentUser.value = userObject;',
    'abstracts.value = HiveService.getUserSubmissions(...);',
    '',
    '// In screen — Obx rebuilds when .value changes:',
    'Obx(() => Text(auth.currentUser.value?.name ?? "Guest"))',
    'Obx(() => isLoading.value ? CircularProgressIndicator() : Button())',
    'Obx(() => ListView.builder(',
    '  itemCount: sub.abstracts.length,',
    '  itemBuilder: (_, i) => SubmissionCard(submission: sub.abstracts[i]),',
    '))',
  ]),

  h2('13.5 — StatefulWidget vs StatelessWidget'),
  ...codeBlock([
    '// StatelessWidget — no internal state, just displays data',
    '// Use when: the widget only depends on external data (props)',
    'class StatusBadge extends StatelessWidget {',
    '  final String status;  // External data',
    '  const StatusBadge(this.status, {super.key});',
    '  @override Widget build(BuildContext context) { ... }',
    '}',
    '',
    '// StatefulWidget — has internal mutable state',
    '// Use when: widget manages its own state (form inputs, toggles, step index)',
    'class RegisterScreen extends StatefulWidget {',
    '  @override State<RegisterScreen> createState() => _RegisterScreenState();',
    '}',
    '',
    'class _RegisterScreenState extends State<RegisterScreen> {',
    '  int _step = 0;  // Internal state',
    '  TextEditingController _nameCtrl = TextEditingController();',
    '',
    '  @override',
    '  Widget build(BuildContext context) { ... }',
    '',
    '  @override',
    '  void dispose() {',
    '    _nameCtrl.dispose();  // Free resources when widget is removed',
    '    super.dispose();',
    '  }',
    '}',
  ]),

  h2('13.6 — The Cascade Operator (..)'),
  ...codeBlock([
    '// Without cascade:',
    'writer.writeByte(14);',
    'writer.writeByte(0);',
    'writer.write(obj.id);',
    '',
    '// With cascade — same object, chained calls:',
    'writer',
    '  ..writeByte(14)',
    '  ..writeByte(0)',
    '  ..write(obj.id);',
  ]),

  h2('13.7 — Named Constructor Parameters'),
  ...codeBlock([
    '// Named parameters with required keyword:',
    'UserModel({',
    '  required this.id,          // Must be provided by caller',
    '  required this.name,',
    '  this.status = "pending",   // Optional — has default value',
    '  this.isAdmin = false,      // Optional — has default value',
    '});',
    '',
    '// Calling it:',
    'UserModel(',
    '  id: uuid,',
    '  name: "John",',
    '  // status and isAdmin use defaults',
    ')',
  ]),

  pageBreak(),

  // ══════════════════════════════════════════════════════════════════
  // CHAPTER 14 — DATA FLOW WALKTHROUGH
  // ══════════════════════════════════════════════════════════════════
  h1('Chapter 14 — Complete Data Flow Walkthroughs'),

  h2('14.1 — Login Flow'),
  ...codeBlock([
    '1. User types email + password → taps Sign In',
    '2. LoginScreen._login() runs:',
    '   - _formKey.currentState!.validate() checks all fields',
    '   - Calls await _auth.login(email, password)',
    '',
    '3. AuthController.login() runs:',
    '   - Sets isLoading.value = true  →  button shows spinner',
    '   - Calls await HiveService.login(email, password)',
    '',
    '4. HiveService.login() runs:',
    '   - hashPassword(password) converts to SHA-256',
    '   - usersBox.values.firstWhere() searches all users',
    '   - Returns UserModel if found, null if not',
    '',
    '5. Back in AuthController:',
    '   - If user != null:',
    '       currentUser.value = user   →  all Obx() watching currentUser rebuild',
    '       HiveService.saveSession(user.id)  →  saved to Hive session box',
    '       returns true',
    '   - Sets isLoading.value = false →  button shows normal',
    '',
    '6. Back in LoginScreen:',
    '   - if (success) Get.offAllNamed(isAdmin ? "/admin-home" : "/home")',
    '   - else shows snackbar error',
  ]),

  h2('14.2 — Submit Abstract Flow'),
  ...codeBlock([
    '1. User taps FAB on AbstractScreen',
    '2. Get.bottomSheet(SubmissionFormSheet(...)) opens the form',
    '3. User fills title, description, category, optional file',
    '4. User taps "Submit Abstract"',
    '',
    '5. SubmissionFormSheet._submit() runs:',
    '   - _formKey.currentState!.validate() checks required fields',
    '   - Sets _isLoading = true',
    '   - Calls await widget.onSubmit(title: ..., description: ...)',
    '   - This calls sub.submitAbstract(title: ...) in the controller',
    '',
    '6. SubmissionController.submitAbstract() runs:',
    '   - Creates SubmissionModel with new UUID, current user info, "pending" status',
    '   - Calls await HiveService.addSubmission(submission)',
    '   - Calls loadAll() which reads from Hive and updates abstracts list',
    '   - abstracts is RxList — AbstractScreen\'s Obx() rebuilds showing new card',
    '',
    '7. Back in SubmissionFormSheet:',
    '   - Get.back() closes the sheet',
    '   - Get.snackbar("Submitted!", ...) shows success message',
  ]),

  h2('14.3 — Admin Review Flow'),
  ...codeBlock([
    '1. Admin is on AdminSubmissionsTab (type: "abstract")',
    '2. Obx() watches sub.allAbstracts — shows all submissions',
    '3. Admin taps a submission card',
    '4. _showReview(context) opens AlertDialog via Get.dialog()',
    '',
    '5. Admin selects "Approve" and types a remark',
    '6. Taps "Save Decision"',
    '',
    '7. onAction("approved", "Great work!") is called:',
    '   - sub.updateStatus(id, "approved", "Great work!")',
    '',
    '8. SubmissionController.updateStatus() runs:',
    '   - Calls HiveService.updateSubmissionStatus(id, "approved", "Great work!")',
    '',
    '9. HiveService.updateSubmissionStatus() runs:',
    '   - submissionsBox.get(id) retrieves the live object',
    '   - submission.status = "approved"',
    '   - submission.adminRemark = "Great work!"',
    '   - await submission.save()  →  persists to disk',
    '',
    '10. Back in SubmissionController:',
    '    - loadAll() refreshes allAbstracts from Hive',
    '    - allAbstracts is RxList — AdminSubmissionsTab\'s Obx() rebuilds',
    '    - Card now shows green "Approved" badge',
    '',
    '11. The participant\'s AbstractScreen also shows the updated status',
    '    because loadAll() also updates abstracts (user list)',
  ]),

  pageBreak(),

  // ══════════════════════════════════════════════════════════════════
  // CHAPTER 15 — COMMON MISTAKES AND HOW TO AVOID THEM
  // ══════════════════════════════════════════════════════════════════
  h1('Chapter 15 — Common Mistakes & How to Avoid Them'),

  headerTable(
    ['Mistake', 'Symptom', 'Fix'],
    [
      ['Changing @HiveField numbers', 'App crashes or shows wrong data after update', 'Never change or reuse field index numbers'],
      ['Not calling Responsive.init(context)', 'Null exception on screenWidth', 'Call Responsive.init(context) at the top of every build()'],
      ['Calling sp()/font() inside Obx without init', 'Stale screen size values', 'Use plain const values inside Obx — no Responsive calls'],
      ['Not disposing AnimationController', 'Memory leak warning in console', 'Always call _controller.dispose() in dispose()'],
      ['Not disposing TabController', 'Memory leak, animation errors', 'Always call _tabCtrl.dispose() in dispose()'],
      ['Using Get.find() before Get.put()', 'GetX "not found" exception', 'Ensure AppBindings runs before any screen accesses a controller'],
      ['Not calling loadAll() after write', 'UI shows stale data', 'Always call loadAll() after any HiveService write operation'],
      ['Forgetting finally in try/catch', 'Button stuck in loading state', 'Always use try/finally for isLoading.value = false'],
      ['Using usersBox.values as a List directly', 'Type error or cast exception', 'Call .toList() to convert Iterable to List'],
      ['Opening a Hive box before registering adapter', 'HiveError on startup', 'Register all adapters before calling openBox()'],
    ]
  ),

  pageBreak(),

  // ══════════════════════════════════════════════════════════════════
  // CHAPTER 16 — HOW TO EXTEND THE PROJECT
  // ══════════════════════════════════════════════════════════════════
  h1('Chapter 16 — How to Extend This Project'),

  h2('16.1 — Adding a New Model'),
  numbered('Create the model file with @HiveType(typeId: N) — use a new unique typeId', 1),
  numbered('Write the .g.dart adapter file manually (or run build_runner)', 2),
  numbered('Register the adapter in HiveService.init()', 3),
  numbered('Open a new box for it', 4),
  numbered('Add CRUD methods in HiveService', 5),
  numbered('Add reactive lists in SubmissionController', 6),
  numbered('Build the screen', 7),

  h2('16.2 — Adding a New Screen'),
  numbered('Create the screen file in lib/screens/', 1),
  numbered('Add a GetPage entry in main.dart getPages list', 2),
  numbered('Navigate to it with Get.toNamed("/your-route")', 3),

  h2('16.3 — Adding a New Navigation Tab (User)'),
  numbered('Add a _NavItem to the _navItems list in home_screen.dart', 1),
  numbered('Add a case in _buildBody() switch statement', 2),
  numbered('Create the screen widget', 3),

  h2('16.4 — Replacing Local Storage with a Backend'),
  p('Because all database access goes through HiveService, replacing Hive with an API requires changes in only one file:'),
  bullet('Replace HiveService methods with HTTP calls (using http or dio package)'),
  bullet('Controllers remain identical — they still call the same method names'),
  bullet('Screens remain identical — they still observe the same reactive lists'),

  h2('16.5 — Adding Push Notifications'),
  bullet('Add firebase_messaging or flutter_local_notifications package'),
  bullet('Trigger notifications in HiveService after status changes'),
  bullet('Controllers and screens need no changes'),

  pageBreak(),

  // ══════════════════════════════════════════════════════════════════
  // CHAPTER 17 — RUNNING THE PROJECT
  // ══════════════════════════════════════════════════════════════════
  h1('Chapter 17 — Running & Building the Project'),

  h2('17.1 — First Run'),
  ...codeBlock([
    '# Navigate to project folder',
    'cd vidyen_hive',
    '',
    '# Install all dependencies from pubspec.yaml',
    'flutter pub get',
    '',
    '# Run on connected device or emulator',
    'flutter run',
    '',
    '# Run on specific platform',
    'flutter run -d android',
    'flutter run -d ios',
    'flutter run -d chrome      # Web',
    'flutter run -d windows',
  ]),

  h2('17.2 — Default Login'),
  twoColTable([
    ['Admin email',    'admin@vidyen.org'],
    ['Admin password', 'Admin@123'],
    ['User',          'Register a new account from the Register screen'],
  ]),

  h2('17.3 — Common Run Issues'),
  twoColTable([
    ['Font 404 errors',     'Run: flutter clean && flutter pub get && flutter run'],
    ['Hive type not found', 'Ensure all adapters are registered before openBox()'],
    ['Build runner needed', 'Run: flutter pub run build_runner build --delete-conflicting-outputs'],
    ['Null check failed',   'Ensure Responsive.init(context) is called at top of build()'],
  ]),

  h2('17.4 — Build for Release'),
  ...codeBlock([
    '# Android APK',
    'flutter build apk --release',
    '',
    '# Android App Bundle (Play Store)',
    'flutter build appbundle --release',
    '',
    '# iOS (requires Mac + Xcode)',
    'flutter build ios --release',
    '',
    '# Web',
    'flutter build web --release',
  ]),

  pageBreak(),

  // ══════════════════════════════════════════════════════════════════
  // QUICK REFERENCE
  // ══════════════════════════════════════════════════════════════════
  h1('Quick Reference — All Files'),

  headerTable(
    ['File', 'Purpose', 'Key exports'],
    [
      ['main.dart',                  'Entry point',         'VidyenApp, AppBindings'],
      ['models/user_model.dart',     'User data shape',     'UserModel'],
      ['models/submission_model.dart','Submission shape',   'SubmissionModel'],
      ['models/certificate_model.dart','Certificate shape', 'CertificateModel'],
      ['services/hive_service.dart', 'All DB operations',   'HiveService'],
      ['controllers/auth_controller.dart', 'Auth logic',    'AuthController'],
      ['controllers/submission_controller.dart', 'Submission logic', 'SubmissionController'],
      ['utils/app_theme.dart',       'Colors + theme',      'AppColors, AppTheme, AppConstants'],
      ['utils/responsive.dart',      'Screen sizing',       'Responsive, ResponsiveContainer'],
      ['widgets/common_widgets.dart', 'Shared UI',          'StatusBadge, GradientButton, SubmissionCard, StatCard, SectionHeader'],
      ['screens/splash_screen.dart', 'Animated splash',     'SplashScreen'],
      ['screens/login_screen.dart',  'Login form',          'LoginScreen'],
      ['screens/register_screen.dart','2-step register',    'RegisterScreen'],
      ['screens/home_screen.dart',   'User nav shell',      'HomeScreen'],
      ['screens/profile_screen.dart','User profile',        'ProfileScreen'],
      ['screens/dashboard/dashboard_home_tab.dart', 'User home',  'DashboardHomeTab'],
      ['screens/dashboard/abstract_screen.dart', 'Abstracts',     'AbstractScreen'],
      ['screens/dashboard/preconf_screen.dart',  'Pre-Conf',       'PreconfScreen'],
      ['screens/dashboard/workshop_screen.dart', 'Workshops',      'WorkshopScreen'],
      ['screens/dashboard/certificate_screen.dart', 'Certificates','CertificateScreen'],
      ['screens/dashboard/submission_form_sheet.dart','Submit form','SubmissionFormSheet'],
      ['screens/admin/admin_home_screen.dart',   'Admin nav shell','AdminHomeScreen'],
      ['screens/admin/admin_dashboard_tab.dart', 'Admin stats',    'AdminDashboardTab'],
      ['screens/admin/admin_users_tab.dart',     'User management','AdminUsersTab'],
      ['screens/admin/admin_submissions_tab.dart','Review submissions','AdminSubmissionsTab'],
      ['screens/admin/admin_certificates_tab.dart','Issue certs',  'AdminCertificatesTab'],
    ]
  ),

  new Paragraph({ spacing: { before: 600, after: 200 }, alignment: AlignmentType.CENTER,
    children: [new TextRun({ text: '— End of Guide —', font: 'Arial', size: 24, color: GRAY, italics: true })] }),
  new Paragraph({ alignment: AlignmentType.CENTER,
    children: [new TextRun({ text: 'VIDYEN  ·  Flutter + GetX + Hive', font: 'Arial', size: 20, color: BLUE })] }),
    new Paragraph({ alignment: AlignmentType.CENTER,
    children: [new TextRun({ text: 'Damish-7', font: 'Arial', size: 20, color: BLUE })] }),
];

// ═══════════════════════════════════════════════════════════════════════
// BUILD DOCUMENT
// ═══════════════════════════════════════════════════════════════════════

const doc = new Document({
  sections: [{
    properties: {
      page: {
        size: { width: 12240, height: 15840 },
        margin: { top: 1080, right: 1080, bottom: 1080, left: 1080 }
      }
    },
    children
  }]
});

Packer.toBuffer(doc).then(buffer => {
  fs.writeFileSync("VIDYEN_Teaching_Guide.docx", buffer);
  console.log('Done');
});
