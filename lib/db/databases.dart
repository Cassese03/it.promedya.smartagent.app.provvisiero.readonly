// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, unused_local_variable

import 'dart:developer';

import 'package:path/path.dart';
import 'package:provvisiero_readonly/model/agente.dart';
import 'package:provvisiero_readonly/model/dms.dart';
import 'package:provvisiero_readonly/model/dotes_prov.dart';
import 'package:provvisiero_readonly/model/lsarticolo.dart';
import 'package:provvisiero_readonly/model/mggiac.dart';
import 'package:provvisiero_readonly/model/provvisiero.dart';
import 'package:provvisiero_readonly/model/sc.dart';
import 'package:provvisiero_readonly/model/xveicolo.dart';
import 'package:sqflite/sqflite.dart';
import '../model/aliquota.dart';
import '../model/ar.dart';
import '../model/aralias.dart';
import '../model/ararmisura.dart';
import '../model/arclasse1.dart';
import '../model/arclasse2.dart';
import '../model/arclasse3.dart';
import '../model/argruppo1.dart';
import '../model/argruppo2.dart';
import '../model/argruppo3.dart';
import '../model/cart.dart';
import '../model/cf.dart';
import '../model/cfdest.dart';
import '../model/cfsede.dart';
import '../model/dorig.dart';
import '../model/dotes.dart';
import '../model/dototali.dart';
import '../model/ls.dart';
import '../model/lsscaglione.dart';
import '../model/lsrevisione.dart';

class ProvDatabase {
  static final ProvDatabase instance = ProvDatabase.init();

  static Database? _database;

  ProvDatabase.init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('provvisiero.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future check_database(String table_name, String column_name) async {
    final db = await instance.database;

    var data = await db.rawQuery('PRAGMA table_info($table_name);');

    bool exists = false;
    for (int i = 0; i < data.length; i++) {
      if (data[i]["name"] == (column_name)) {
        exists = true;
        break;
      }
    }

    if (!exists) {
      await db.rawQuery("ALTER TABLE $table_name ADD $column_name;");
      log('Tabella MODIFICATA');
    }
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = '';
    const integerType = '';
    const floatType = '';

    await db.execute('''
    CREATE TABLE provvisiero(
      ${ProvvisieroField.id} $idType, 
      ${ProvvisieroField.isImportant} $boolType,
      ${ProvvisieroField.number} $integerType
        )
    ''');

    await db.execute('''CREATE TABLE IF NOT EXISTS licenza(
      token 
        )
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS agente(id $idType,id_ditta,cd_agente,descrizione,provvigione,sconto,xpassword)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS aliquota(id $idType,id_ditta,cd_aliquota,aliquota)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS ar (id $idType,id_ditta,cd_ar,descrizione,cd_aliquota_v,cd_arclasse1,cd_arclasse2,cd_arclasse3,cd_argruppo1,cd_argruppo2,cd_argruppo3,immagine, xcd_xcalibro, xcd_xvarieta, giacenza, id_ar,dms)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS aralias (id $idType,id_ditta,cd_ar,alias)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS ararmisura (id $idType,id_ditta,cd_ar,cd_armisura,umfatt)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS arclasse1 (id $idType,id_ditta,cd_arclasse1,descrizione)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS arclasse2 (id $idType,id_ditta,cd_arclasse1,cd_arclasse2,descrizione)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS arclasse3 (id $idType,id_ditta,cd_arclasse1,cd_arclasse2,cd_arclasse3,descrizione)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS argruppo1 (id $idType,id_ditta,cd_argruppo1,descrizione)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS argruppo2 (id $idType,id_ditta,cd_argruppo1,cd_argruppo2,descrizione)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS argruppo3 (id $idType,id_ditta,cd_argruppo1,cd_argruppo2,cd_argruppo3,descrizione)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS cart (id $idType,id_ditta,cd_cf,cd_cfsede,cd_cfdest,cd_ar,cd_agente_1,qta,xcolli ,xbancali ,prezzo_unitario ,cd_aliquota,aliquota,totale ,imposta ,da_inviare,note,stato,sconto_riga,confezione, datadoc,dataconsegna, cd_pg, linkcart,note_dotes, send_mail,note_agg)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS cf (id $idType,id_ditta,cd_cf,descrizione,indirizzo,localita,cap,cd_nazione,cd_provincia,cd_agente_1,cd_agente_2,cliente,fornitore,mail,telefono)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS cfdest (id $idType,id_ditta,cd_cf,cd_cfdest,descrizione,indirizzo,localita,cap,cd_nazione,cd_provincia,numero)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS cfsede (id $idType,id_ditta,cd_cf,cd_cfsede,descrizione,indirizzo,localita,cap,cd_nazione,cd_provincia)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS dorig (id $idType,id_ditta,id_dorig,id_dotes,cd_ar,cd_arlotto,cd_cf,qta $floatType,qtaevadibile $floatType,descrizione,prezzounitariov $floatType,cd_aliquota,scontoriga $floatType,prezzounitarioscontatov $floatType,prezzototalev $floatType, id_dorig_evade , linkcf,noteriga,xcolli,xconfezione,noteagg,cd_mg_p,xlega_doc,stato)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS dotes (id $idType,id_dotes,id_ditta,righeevadibili,numerodoc,numerodocrif,datadoc,cd_cf,cd_do,dataconsegna,cd_cfdest,cd_cfsede,cd_agente_1,cd_agente_2,cd_ls_1,tipodocumento)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS dototali (id $idType,id_ditta,id_dotes,totimponibilev $floatType,totimpostav $floatType,totdocumentov $floatType)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS ls (id $idType,id_ditta,cd_ls,descrizione)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS lsarticolo (id $idType,id_ditta,id_lsrevisione,cd_ar,prezzo $floatType,sconto $floatType,provvigione $floatType)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS lsrevisione (id $idType,id_ditta,id_lsrevisione,cd_ls,descrizione)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS lsscaglione (id $idType,id_ditta,id_lsarticolo,finoaqta $floatType,prezzo $floatType)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS mggiac (id $idType,id_ditta,cd_ar,cd_mg,giacenza,disponibile)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS sc (id $idType,id_ditta,cd_cf,datascadenza,importoe,numfattura,datafattura,datapagamento,pagata,insoluta,id_dotes)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS dotes_prov (id $idType,id_ditta,id_dotes,xcd_xveicolo,xautista,ximb,xacconto,xaccontof,xsettimana,xtipoveicolo,xmodifica,xurgente,xpagata,xriford,xriffatra ,ximpfat,ximppag,xpagatat,xpagataf,xclidest,linkcart,xnumerodocrif,datadocrif)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS xVeicolo (id $idType,id_ditta,cd_xveicolo,descrizione,cd_cf)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS xdms (id $idType,id_ditta,filename,id_dmsclass1,id_dmsclass2,id_dmsclass3,entityid,link)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS donota (id $idType,id_ditta,id_nota,nota,id_dotes)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS arcodcf (id $idType,id_ditta,cd_ar,cd_cf,codicealternativo,fornitorepreferenziale)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS regoledms (id $idType,id_ditta,id_dmsclass1,id_dmsclass2,dmsclass3)
    ''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS dovettore (id $idType,id_ditta,id_dovettore,cd_dovettore,descrizione,indirizzo,cap,localita,cd_nazione,cd_provincia,telefono,email)
    ''');
  }

  Future<int> deletealldovettore() async {
    final db = await instance.database;

    return await db.delete(
      'dovettore',
    );
  }

  Future<int> deleteallregoledms() async {
    final db = await instance.database;

    return await db.delete(
      'regoledms',
    );
  }

  Future<int> deletealldonota() async {
    final db = await instance.database;

    return await db.delete(
      'donota',
    );
  }

  Future<int> deleteallarcodcf() async {
    final db = await instance.database;

    return await db.delete(
      'arcodcf',
    );
  }

  Future<xdms> createdms(xdms dms) async {
    final db = await instance.database;
    final id = await db.insert('dms', dms.toJson());
    return dms.copy(id: id);
  }

  Future adddms(
      String id_ditta,
      String filename,
      String id_dmsclass1,
      String id_dmsclass2,
      String id_dmsclass3,
      String entityid,
      String link) async {
    final dms = xdms(
      id_ditta: '7',
      filename: filename,
      id_dmsclass1: id_dmsclass1,
      id_dmsclass2: id_dmsclass2,
      id_dmsclass3: id_dmsclass3,
      entityid: entityid,
      link: link,
    );

    await ProvDatabase.instance.createdms(dms);
  }

  Future<int> deleteallxdms() async {
    final db = await instance.database;
    return await db.delete(
      'xdms',
    );
  }

  Future<xVeicolo> createxVeicolo(xVeicolo xveicolo) async {
    final db = await instance.database;
    final id = await db.insert('xveicolo', xveicolo.toJson());
    return xveicolo.copy(id: id);
  }

  Future<int> deleteallxVeicolo() async {
    final db = await instance.database;

    return await db.delete(
      'xveicolo',
    );
  }

  Future addxVeicolo(
    String id_ditta,
    String cd_cf,
    String descrizione,
    String cd_xveicolo,
  ) async {
    final xveicolo = xVeicolo(
      id_ditta: '7',
      cd_cf: cd_cf,
      descrizione: descrizione,
      cd_xveicolo: cd_xveicolo,
    );

    await ProvDatabase.instance.createxVeicolo(xveicolo);
  }

  Future<SC> createSC(SC sc) async {
    final db = await instance.database;
    final id = await db.insert('sc', sc.toJson());

    // final json = note.toJson();
    // final columns =
    // '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    // '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json [NoteFiel
    // final id = await db
    // .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');
    return sc.copy(id: id);
  }

  Future addSC(
    String id_ditta,
    String cd_cf,
    String datascadenza,
    String importoe,
    String numfattura,
    String datafattura,
    String datapagamento,
    String pagata,
    String insoluta,
    String id_dotes,
  ) async {
    final sc = SC(
      id_ditta: '7',
      cd_cf: cd_cf,
      datafattura: datafattura,
      importoe: importoe,
      datapagamento: datapagamento,
      datascadenza: datascadenza,
      insoluta: insoluta,
      numfattura: numfattura,
      pagata: pagata,
      id_dotes: id_dotes,
    );

    await ProvDatabase.instance.createSC(sc);
  }

  Future<int> update(Provvisiero provvisiero) async {
    final db = await instance.database;

    return db.update(
      'provvisiero',
      provvisiero.toJson(),
      where: '${ProvvisieroField.id} = ?',
      whereArgs: [provvisiero.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'provvisiero',
      where: '${ProvvisieroField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<Provvisiero>> readAllProvvisiero() async {
    final db = await instance.database;

    final result = await db.query('provvisiero');

    // final result = await db.rawQuery('SELECT * FROM $'provvisiero' ORDER BY $orderBy');

    // final orderBy = '${ProvvisieroField.campo} ASC';

    // final result = await db.query('provvisiero' , orderBy: orderBy);

    return result.map((json) => Provvisiero.fromJson(json)).toList();
  }

  Future<Null> readAllTables() async {
    /*final db = await instance.database;

    //final result = await db.query('provvisiero');
    final result = (await db
            .query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
        .map((row) => row['name'] as String)
        .toList(growable: false);*/

    //print(result);

    // final result = await db.rawQuery('SELECT * FROM $'provvisiero' ORDER BY $orderBy');

    // final orderBy = '${ProvvisieroField.campo} ASC';

    // final result = await db.query('provvisiero' , orderBy: orderBy);

    // return result.map((json) => Provvisiero.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future<Provvisiero> readProvvisiero(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'provvisiero',
      columns: ProvvisieroField.values,
      where: '${ProvvisieroField.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Provvisiero.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future addProvvisiero(int number) async {
    final provvisiero = Provvisiero(isImportant: true, number: number);

    await ProvDatabase.instance.create(provvisiero);
  }

  Future<Provvisiero> create(Provvisiero provvisiero) async {
    final db = await instance.database;
    final id = await db.insert('provvisiero', provvisiero.toJson());

    // final json = note.toJson();
    // final columns =
    // '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    // '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json [NoteFiel
    // final id = await db
    // .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');
    return provvisiero.copy(id: id);
  }

// Inizio Agente

  Future addAgente(
      String cd_agente, String descrizione, String xpassword) async {
    final agente = Agente(
        id_ditta: '7',
        cd_agente: cd_agente,
        descrizione: descrizione,
        provvigione: 0.00,
        sconto: 0.00,
        xpassword: xpassword);

    await ProvDatabase.instance.createagente(agente);
  }

  Future<List<Agente>> readAllAgente() async {
    final db = await instance.database;

    final result = await db.query('agente');

    // final result = await db.rawQuery('SELECT * FROM $'provvisiero' ORDER BY $orderBy');

    // final orderBy = '${ProvvisieroField.campo} ASC';

    // final result = await db.query('provvisiero' , orderBy: orderBy);

    return result.map((json) => Agente.fromJson(json)).toList();
  }

  Future<int> deleteAgente(int id) async {
    final db = await instance.database;

    return await db.delete(
      'agente',
      where: '${AgenteField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<Agente> createagente(Agente agente) async {
    final db = await instance.database;
    final id = await db.insert('agente', agente.toJson());

    /*final json = agente.toJson();
    final columns =
        '${AgenteField.id_ditta}, ${AgenteField.cd_agente}, ${AgenteField.descrizione}, ${AgenteField.provvigione}, ${AgenteField.sconto}, ${AgenteField.xpassword}';
    final values =
        '${json[AgenteField.id_ditta]}, ${json[AgenteField.cd_agente]}, ${json[AgenteField.descrizione]}, ${json[AgenteField.provvigione]}, ${json[AgenteField.sconto]}, ${json[AgenteField.xpassword]}';
    final id =
        await db.rawInsert('INSERT INTO agente ($columns) VALUES ($values)');*/

    return agente.copy(id: id);
  }

  // Inizio Aliquota
  Future addAliquota(
      String cd_aliquota, String aliquota, String id_ditta) async {
    final aliquota_end =
        Aliquota(id_ditta: '7', cd_aliquota: cd_aliquota, aliquota: aliquota);

    await ProvDatabase.instance.createAliquota(aliquota_end);
  }

  Future<List<Aliquota>> readAllAliquota() async {
    final db = await instance.database;

    final result = await db.query('aliquota');

    // final result = await db.rawQuery('SELECT * FROM $'provvisiero' ORDER BY $orderBy');

    // final orderBy = '${ProvvisieroField.campo} ASC';

    // final result = await db.query('provvisiero' , orderBy: orderBy);

    return result.map((json) => Aliquota.fromJson(json)).toList();
  }

  Future<int> deleteAliquota(int id) async {
    final db = await instance.database;

    return await db.delete(
      'aliquota',
      where: '${AliquotaField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<Aliquota> createAliquota(Aliquota aliquota) async {
    final db = await instance.database;
    final id = await db.insert('aliquota', aliquota.toJson());

    return aliquota.copy(id: id);
  }

  // Inizio Ar
  Future addAR(
      String cd_AR,
      String descrizione,
      String cd_aliquota_v,
      String cd_arclasse1,
      String cd_arclasse2,
      String cd_arclasse3,
      String cd_argruppo1,
      String cd_argruppo2,
      String cd_argruppo3,
      String immagine,
      String xcd_xcalibro,
      String xcd_xvarieta,
      String giacenza,
      String id_ar,
      String dms) async {
    final ar = AR(
        id_ditta: '7',
        cd_AR: cd_AR,
        descrizione: descrizione,
        cd_aliquota_v: cd_aliquota_v,
        cd_arclasse1: cd_arclasse1,
        cd_arclasse2: cd_arclasse2,
        cd_arclasse3: cd_arclasse3,
        cd_argruppo1: cd_argruppo1,
        cd_argruppo2: cd_argruppo2,
        cd_argruppo3: cd_argruppo3,
        immagine: immagine,
        xcd_xcalibro: xcd_xcalibro,
        xcd_xvarieta: xcd_xvarieta,
        giacenza: giacenza,
        id_ar: id_ar,
        dms: dms);

    await ProvDatabase.instance.createAr(ar);
  }

  Future<List<AR>> readAllAR() async {
    final db = await instance.database;

    final result = await db.query('ar');

    return result.map((json) => AR.fromJson(json)).toList();
  }

  Future<List<AR>> readAllARFilter({required String filtro}) async {
    final db = await instance.database;

    var result = await db.query(
      'ar',
      where: '${ARField.cd_AR} like ?',
      whereArgs: ['%$filtro%'],
    );
    if (result.isEmpty) {
      result = await db.query(
        'ar',
        where: '${ARField.descrizione} like ?',
        whereArgs: ['%$filtro%'],
      );
    }

    return result.map((json) => AR.fromJson(json)).toList();
  }

  Future<int> deleteallAR() async {
    final db = await instance.database;

    return await db.delete(
      'ar',
    );
  }

  Future<int> deleteallCF() async {
    final db = await instance.database;

    return await db.delete(
      'cf',
    );
  }

  Future<int> deleteallCFDest() async {
    final db = await instance.database;

    return await db.delete(
      'cfdest',
    );
  }

  Future<int> deleteAR(int id) async {
    final db = await instance.database;

    return await db.delete(
      'ar',
      where: '${ARField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<AR> createAr(AR ar) async {
    final db = await instance.database;
    final id = await db.insert('ar', ar.toJson());

    /*final json = agente.toJson();
    final columns =
        '${AgenteField.id_ditta}, ${AgenteField.cd_agente}, ${AgenteField.descrizione}, ${AgenteField.provvigione}, ${AgenteField.sconto}, ${AgenteField.xpassword}';
    final values =
        '${json[AgenteField.id_ditta]}, ${json[AgenteField.cd_agente]}, ${json[AgenteField.descrizione]}, ${json[AgenteField.provvigione]}, ${json[AgenteField.sconto]}, ${json[AgenteField.xpassword]}';
    final id =
        await db.rawInsert('INSERT INTO agente ($columns) VALUES ($values)');*/

    return ar.copy(id: id);
  }

  //Inizio ARAlias
  Future addARAlias(String cd_ar, String alias) async {
    final aralias_end = ARAlias(id_ditta: '7', cd_ar: cd_ar, alias: alias);

    await ProvDatabase.instance.createARAlias(aralias_end);
  }

  Future<List<ARAlias>> readAllARAlias() async {
    final db = await instance.database;

    final result = await db.query('aralias');

    // final result = await db.rawQuery('SELECT * FROM $'provvisiero' ORDER BY $orderBy');

    // final orderBy = '${ProvvisieroField.campo} ASC';

    // final result = await db.query('provvisiero' , orderBy: orderBy);

    return result.map((json) => ARAlias.fromJson(json)).toList();
  }

  Future<int> deleteARAlias(int id) async {
    final db = await instance.database;

    return await db.delete(
      'aralias',
      where: '${ARAliasField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<ARAlias> createARAlias(ARAlias aralias) async {
    final db = await instance.database;
    final id = await db.insert('aralias', aralias.toJson());
    return aralias.copy(id: id);
  }

  //Inizio ARARMisura

  Future addARARMisura(
    String cd_ar,
    String cd_armisura,
    String umfatt,
  ) async {
    final ararmisura = ARARMisura(
        id_ditta: '7', cd_ar: cd_ar, cd_armisura: cd_armisura, umfatt: umfatt);

    await ProvDatabase.instance.createARARMisura(ararmisura);
  }

  Future<List<ARARMisura>> readAllARARMisura() async {
    final db = await instance.database;

    final result = await db.query('ararmisura');

    // final result = await db.rawQuery('SELECT * FROM $'provvisiero' ORDER BY $orderBy');

    // final orderBy = '${ProvvisieroField.campo} ASC';

    // final result = await db.query('provvisiero' , orderBy: orderBy);

    return result.map((json) => ARARMisura.fromJson(json)).toList();
  }

  Future<int> deleteARARMisura(int id) async {
    final db = await instance.database;

    return await db.delete(
      'ararmisura',
      where: '${ARARMisuraField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<ARARMisura> createARARMisura(ARARMisura ararmisura) async {
    final db = await instance.database;
    final id = await db.insert('ararmisura', ararmisura.toJson());

    return ararmisura.copy(id: id);
  }

  // Inizio Arclasse 1

  Future addARClasse1(
    String cd_arclasse1,
    String descrizione,
  ) async {
    final arclasse1 = ARClasse1(
        id_ditta: '7', cd_arclasse1: cd_arclasse1, descrizione: descrizione);

    await ProvDatabase.instance.createARClasse1(arclasse1);
  }

  Future<List<ARClasse1>> readAllARClasse1() async {
    final db = await instance.database;

    final result = await db.query('arclasse1');

    // final result = await db.rawQuery('SELECT * FROM $'provvisiero' ORDER BY $orderBy');

    // final orderBy = '${ProvvisieroField.campo} ASC';

    // final result = await db.query('provvisiero' , orderBy: orderBy);

    return result.map((json) => ARClasse1.fromJson(json)).toList();
  }

  Future<int> deleteARClasse1(int id) async {
    final db = await instance.database;

    return await db.delete(
      'arclasse1',
      where: '${ARClasse1Field.id} = ?',
      whereArgs: [id],
    );
  }

  Future<ARClasse1> createARClasse1(ARClasse1 arclasse1) async {
    final db = await instance.database;
    final id = await db.insert('arclasse1', arclasse1.toJson());
    return arclasse1.copy(id: id);
  }

// Inizio Arclasse 2
  Future addARClasse2(
    String cd_ARClasse1,
    String cd_ARClasse2,
    String descrizione,
  ) async {
    final arclasse2 = ARClasse2(
        id_ditta: '7',
        cd_ARClasse2: cd_ARClasse2,
        cd_ARClasse1: cd_ARClasse1,
        descrizione: descrizione);

    await ProvDatabase.instance.createARClasse2(arclasse2);
  }

  Future<List<ARClasse2>> readAllARClasse2() async {
    final db = await instance.database;

    final result = await db.query('ARClasse2');

    return result.map((json) => ARClasse2.fromJson(json)).toList();
  }

  Future<int> deleteARClasse2(int id) async {
    final db = await instance.database;

    return await db.delete(
      'ARClasse2',
      where: '${ARClasse2Field.id} = ?',
      whereArgs: [id],
    );
  }

  Future<ARClasse2> createARClasse2(ARClasse2 ARClasse2) async {
    final db = await instance.database;
    final id = await db.insert('ARClasse2', ARClasse2.toJson());
    return ARClasse2.copy(id: id);
  }

// Inizio Arclasse 3
  Future addARClasse3(
    String cd_ARClasse1,
    String cd_ARClasse2,
    String cd_ARClasse3,
    String descrizione,
  ) async {
    final arclasse3 = ARClasse3(
        id_ditta: '7',
        cd_ARClasse3: cd_ARClasse3,
        cd_ARClasse2: cd_ARClasse2,
        cd_ARClasse1: cd_ARClasse1,
        descrizione: descrizione);

    await ProvDatabase.instance.createARClasse3(arclasse3);
  }

  Future<List<ARClasse3>> readAllARClasse3() async {
    final db = await instance.database;

    final result = await db.query('ARClasse3');

    return result.map((json) => ARClasse3.fromJson(json)).toList();
  }

  Future<int> deleteARClasse3(int id) async {
    final db = await instance.database;

    return await db.delete(
      'ARClasse3',
      where: '${ARClasse3Field.id} = ?',
      whereArgs: [id],
    );
  }

  Future<ARClasse3> createARClasse3(ARClasse3 ARClasse3) async {
    final db = await instance.database;
    final id = await db.insert('ARClasse3', ARClasse3.toJson());

    return ARClasse3.copy(id: id);
  }

  // Inizio ARgruppo 1

  Future addARGruppo1(
    String cd_arGruppo1,
    String descrizione,
  ) async {
    final argruppo1 = ARGruppo1(
        id_ditta: '7', cd_arGruppo1: cd_arGruppo1, descrizione: descrizione);

    await ProvDatabase.instance.createARGruppo1(argruppo1);
  }

  Future<List<ARGruppo1>> readAllARGruppo1() async {
    final db = await instance.database;

    final result = await db.query('argruppo1');

    return result.map((json) => ARGruppo1.fromJson(json)).toList();
  }

  Future<int> deleteARGruppo1(int id) async {
    final db = await instance.database;

    return await db.delete(
      'argruppo1',
      where: '${ARGruppo1Field.id} = ?',
      whereArgs: [id],
    );
  }

  Future<ARGruppo1> createARGruppo1(ARGruppo1 argruppo1) async {
    final db = await instance.database;
    final id = await db.insert('argruppo1', argruppo1.toJson());

    return argruppo1.copy(id: id);
  }

  // Inizio ARgruppo 2

  Future addARGruppo2(
    String cd_arGruppo1,
    String cd_arGruppo2,
    String descrizione,
  ) async {
    final argruppo2 = ARGruppo2(
        id_ditta: '7',
        cd_arGruppo1: cd_arGruppo1,
        cd_arGruppo2: cd_arGruppo2,
        descrizione: descrizione);

    await ProvDatabase.instance.createARGruppo2(argruppo2);
  }

  Future<List<ARGruppo2>> readAllARGruppo2() async {
    final db = await instance.database;

    final result = await db.query('argruppo2');

    return result.map((json) => ARGruppo2.fromJson(json)).toList();
  }

  Future<int> deleteARGruppo2(int id) async {
    final db = await instance.database;

    return await db.delete(
      'argruppo2',
      where: '${ARGruppo2Field.id} = ?',
      whereArgs: [id],
    );
  }

  Future<ARGruppo2> createARGruppo2(ARGruppo2 argruppo2) async {
    final db = await instance.database;
    final id = await db.insert('argruppo2', argruppo2.toJson());
    return argruppo2.copy(id: id);
  }

  // Inizio ARgruppo 3

  Future addARGruppo3(
    String cd_arGruppo1,
    String cd_arGruppo2,
    String cd_arGruppo3,
    String descrizione,
  ) async {
    final cd_arGruppo3_end = ARGruppo3(
        id_ditta: '7',
        cd_arGruppo1: cd_arGruppo1,
        cd_arGruppo2: cd_arGruppo2,
        descrizione: descrizione,
        cd_arGruppo3: cd_arGruppo3);

    await ProvDatabase.instance.createARGruppo3(cd_arGruppo3_end);
  }

  Future<List<ARGruppo3>> readAllARGruppo3() async {
    final db = await instance.database;

    final result = await db.query('argruppo3');
    return result.map((json) => ARGruppo3.fromJson(json)).toList();
  }

  Future<int> deleteARGruppo3(int id) async {
    final db = await instance.database;

    return await db.delete(
      'argruppo3',
      where: '${ARGruppo3Field.id} = ?',
      whereArgs: [id],
    );
  }

  Future<ARGruppo3> createARGruppo3(ARGruppo3 argruppo3) async {
    final db = await instance.database;
    final id = await db.insert('argruppo3', argruppo3.toJson());

    return argruppo3.copy(id: id);
  }

  // Inizio Cart

  Future addCart(
    String cd_cf,
    String cd_ar,
    String qta,
    String cd_cfsede,
    String cd_cfdest,
    String cd_agente_1,
    String xcolli,
    String xbancali,
    String prezzo_unitario,
    String totale,
    String imposta,
    String da_inviare,
    String sconto_riga,
    String cd_aliquota,
    String aliquota,
    String note,
    String stato,
    String confezione,
    String datadoc,
    String dataconsegna,
    String cd_pg,
    String linkcart,
    String send_mail,
    String note_dotes,
    String note_agg,
    String xlegato,
  ) async {
    final cart_end = Cart(
      cd_cf: cd_cf,
      cd_cfsede: cd_cfsede,
      cd_cfdest: cd_cfdest,
      cd_ar: cd_ar,
      cd_agente_1: cd_agente_1,
      qta: qta,
      xcolli: xcolli,
      xbancali: xbancali,
      prezzo_unitario: prezzo_unitario,
      totale: totale,
      imposta: imposta,
      da_inviare: da_inviare,
      sconto_riga: sconto_riga,
      cd_aliquota: cd_aliquota,
      aliquota: aliquota,
      note: note,
      stato: stato,
      confezione: confezione,
      datadoc: datadoc,
      dataconsegna: dataconsegna,
      cd_pg: cd_pg,
      linkcart: linkcart,
      send_mail: send_mail,
      note_dotes: note_dotes,
      note_agg: note_agg,
      xlegato: xlegato,
    );

    await ProvDatabase.instance.createCart(cart_end);
  }

  Future<List<Cart>> readAllCart() async {
    final db = await instance.database;

    final result = await db.query('cart');

    return result.map((json) => Cart.fromJson(json)).toList();
  }

  Future<List<Cart>> readAllCartFilter() async {
    final db = await instance.database;

    final result = await db.query(
      'cart',
      where: '${CartField.stato} = ?',
      whereArgs: ['send'],
    );
    List<Cart> vuoto = [];
    if (result.isNotEmpty) {
      return result.map((json) => Cart.fromJson(json)).toList();
    } else {
      return vuoto;
    }
  }

  Future<int> deleteCart(int id) async {
    final db = await instance.database;

    return await db.delete(
      'cart',
      where: '${CartField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCartSend(
      String cd_ar, String cd_cf, String prezzo_unitario, String qta) async {
    final db = await instance.database;
    return await db.delete(
      'cart',
      where:
          '${CartField.cd_ar} = ? and ${CartField.cd_cf} = ? and ${CartField.prezzo_unitario} = ? and ${CartField.qta} = ?',
      whereArgs: [cd_ar, cd_cf, prezzo_unitario, qta],
    );
  }

  Future<int> deleteallCart() async {
    final db = await instance.database;

    return await db.delete(
      'cart',
      where: '${CartField.stato} = ?',
      whereArgs: ['send'],
    );
  }

  Future<Cart> createCart(Cart cart) async {
    final db = await instance.database;
    final id = await db.insert('cart', cart.toJson());

    return cart.copy(id: id);
  }

  // Inizio CF

  Future addCF(
    String cd_cf,
    String id_ditta,
    String descrizione,
    String indirizzo,
    String localita,
    String cap,
    String cd_nazione,
    String cliente,
    String fornitore,
    String cd_provincia,
    String cd_agente_1,
    String cd_agente_2,
    String mail,
    String telefono,
  ) async {
    final cf_end = CF(
      id_ditta: id_ditta,
      cd_cf: cd_cf,
      descrizione: descrizione,
      indirizzo: indirizzo,
      localita: localita,
      cap: cap,
      cd_nazione: cd_nazione,
      cliente: cliente,
      fornitore: fornitore,
      cd_provincia: cd_provincia,
      cd_agente_1: cd_agente_1,
      cd_agente_2: cd_agente_2,
      mail: mail,
      telefono: telefono,
    );

    await ProvDatabase.instance.createCF(cf_end);
  }

  Future<List<CF>> readAllCF() async {
    final db = await instance.database;

    final result = await db.query('cf');

    return result.map((json) => CF.fromJson(json)).toList();
  }

  Future<List<CF>> readAllCF_NOPAG() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT DISTINCT * FROM CF WHERE cd_cf in (SELECT cd_cf FROM sc where pagata  = \'0\') and cd_cf like \'C%\' Order by descrizione asc ',
    );
    return result.map((json) => CF.fromJson(json)).toList();
  }

  Future<double> valAllCF_NOPAG() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT SUM(importoe) as tot FROM sc where pagata  = \'0\' and cd_cf like \'C%\'',
    );
    return double.parse(result[0]["tot"].toString());
  }

  Future<List<CF>> readAllCF_NODOC() async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT DISTINCT * FROM CF WHERE  cd_cf like \'C%\' and cd_cf in (SELECT cd_cf FROM dotes where cd_do != \'CTC\' AND cd_do != \'SOC\' AND cd_do != \'NDC\' AND id_dotes in (SELECT id_dotes from dorig  GROUP BY id_dotes HAVING SUM(qta) = sum(qtaevadibile) and sum(qta) != 0 and sum(qtaevadibile) != 0) and  cd_do != \'NAE\' and cd_do != \'NCC\' and cd_do not like \'F%\') Order by descrizione asc');
    return result.map((json) => CF.fromJson(json)).toList();
  }

  Future<double> valAllCF_NODOC() async {
    final db = await instance.database;
    final result = await db.rawQuery(
        '''SELECT SUM(prezzounitariov * qta) as tot FROM dorig where id_dotes in (
           SELECT id_dotes FROM dotes where cd_cf like 'C%' and id_dotes in (SELECT id_dotes from dorig  GROUP BY id_dotes HAVING SUM(qta) = sum(qtaevadibile) and sum(qta) != 0 and sum(qtaevadibile) != 0)
           and cd_do != 'CTC' AND cd_do != 'SOC' AND cd_do != 'NDC' AND cd_do != 'NAE' and cd_do != 'NCC' and cd_do not like 'F%')
        ''');
    return double.parse(
      (result[0]["tot"].toString() != 'null')
          ? result[0]["tot"].toString()
          : '0',
    );
  }

  Future<List<CF>> readAllCF_NOPAGF() async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT DISTINCT * FROM CF WHERE cd_cf in (SELECT cd_cf FROM sc where pagata  = \'0\') and cd_cf like \'F%\' Order by descrizione asc');
    return result.map((json) => CF.fromJson(json)).toList();
  }

  Future<double> valAllCF_NOPAGF() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT SUM(importoe) as tot FROM sc where pagata  = \'0\' and cd_cf like \'F%\'',
    );
    return double.parse(result[0]["tot"].toString());
  }

  Future<List<CF>> readAllCF_NODOCF() async {
    final db = await instance.database;
    // final result2 = await db.rawQuery(
    //     'SELECT * FROM dotes where righeevadibili != \'0\' and cd_do not like \'F%\'');
    final result = await db.rawQuery(
        'SELECT DISTINCT * FROM CF WHERE cd_cf like \'F%\' and cd_cf in (SELECT cd_cf FROM dotes where cd_do != \'SOC\' AND cd_do != \'AUF\' AND cd_do != \'NCF\' AND cd_do != \'CTF\' AND id_dotes in (SELECT id_dotes from dorig  GROUP BY id_dotes HAVING SUM(qta) = sum(qtaevadibile) and sum(qta) != 0 and sum(qtaevadibile) != 0) and cd_do != \'NAE\'  and cd_do != \'NCC\' and cd_do != \'AUF\' and cd_do != \'NCF\' and cd_do not like \'F%\') Order by descrizione asc');
    return result.map((json) => CF.fromJson(json)).toList();
  }

  Future<double> valAllCF_NODOCF() async {
    final db = await instance.database;
    final result = await db.rawQuery(
        '''SELECT SUM(prezzounitariov * qta) as tot FROM dorig where id_dotes in (
           SELECT id_dotes FROM dotes where  cd_cf like 'F%' and id_dotes in (SELECT id_dotes from dorig  GROUP BY id_dotes HAVING SUM(qta) = sum(qtaevadibile) and sum(qta) != 0 and sum(qtaevadibile) != 0)
           and cd_do != 'CTF' AND cd_do != 'SOC' AND cd_do != 'NCC' AND cd_do != 'AUF' AND cd_do != 'NAE' and cd_do != 'NCF' and cd_do not like 'F%')
        ''');
    return double.parse(
      (result[0]["tot"].toString() != 'null')
          ? result[0]["tot"].toString()
          : '0',
    );
  }

  Future<List<CF>> readAllCFFilter({required String filtro}) async {
    final db = await instance.database;

    final result = await db.rawQuery(
        'SELECT DISTINCT * FROM cf where (${CFField.descrizione} like ? or ${CFField.cd_cf} like ? ) and Cd_CF like \'C%\' Order by descrizione asc',
        ['%$filtro%', '%$filtro%']);

    return result.map((json) => CF.fromJson(json)).toList();
  }

  Future<List<CF>> readAllCFFilterF({required String filtro}) async {
    final db = await instance.database;

    final result = await db.query(
      'cf',
      where: '${CFField.descrizione} like ? and Cd_CF like \'F%\'',
      whereArgs: ['%$filtro%'],
    );
    if (result.isEmpty) {
      final result = await db.query(
        'cf',
        where: '${CFField.cd_cf} like ? and Cd_CF like \'F%\'',
        whereArgs: ['%$filtro%'],
      );
    }

    return result.map((json) => CF.fromJson(json)).toList();
  }

  Future<int> deleteCF(int id) async {
    final db = await instance.database;

    return await db.delete(
      'cf',
      where: '${CFField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<CF> createCF(CF cf) async {
    final db = await instance.database;
    final id = await db.insert('cf', cf.toJson());

    return cf.copy(id: id);
  }

  // Inizio CF Dest
  Future addCFDest(
    String cd_cf,
    String cd_cfdest,
    String id_ditta,
    String descrizione,
    String indirizzo,
    String localita,
    String cap,
    String cd_nazione,
    String cd_provincia,
    String numero,
  ) async {
    final cfdest_end = CFDest(
      id_ditta: id_ditta,
      cd_cf: cd_cf,
      cd_cfdest: cd_cfdest,
      descrizione: descrizione,
      indirizzo: indirizzo,
      localita: localita,
      cap: cap,
      cd_nazione: cd_nazione,
      cd_provincia: cd_provincia,
      numero: numero,
    );

    await ProvDatabase.instance.createCFDest(cfdest_end);
  }

  Future<List<CFDest>> readAllCFDest() async {
    final db = await instance.database;

    final result = await db.query('cfdest');

    return result.map((json) => CFDest.fromJson(json)).toList();
  }

  Future<int> deleteCFDest(int id) async {
    final db = await instance.database;

    return await db.delete(
      'cfdest',
      where: '${CFDestField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<CFDest> createCFDest(CFDest cfdest) async {
    final db = await instance.database;
    final id = await db.insert('cfdest', cfdest.toJson());
    return cfdest.copy(id: id);
  }

  // Inizio CF Sede
  Future addCFSede(
    String cd_cf,
    String cd_cfsede,
    String id_ditta,
    String descrizione,
    String indirizzo,
    String localita,
    String cap,
    String cd_nazione,
    String cd_provincia,
  ) async {
    final cfsede_end = CFSede(
      id_ditta: id_ditta,
      cd_cf: cd_cf,
      cd_cfsede: cd_cfsede,
      descrizione: descrizione,
      indirizzo: indirizzo,
      localita: localita,
      cap: cap,
      cd_nazione: cd_nazione,
      cd_provincia: cd_provincia,
    );

    await ProvDatabase.instance.createCFSede(cfsede_end);
  }

  Future<List<CFSede>> readAllCFSede() async {
    final db = await instance.database;

    final result = await db.query('cfsede');

    return result.map((json) => CFSede.fromJson(json)).toList();
  }

  Future<int> deleteCFSede(int id) async {
    final db = await instance.database;

    return await db.delete(
      'cfsede',
      where: '${CFSedeField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<CFSede> createCFSede(CFSede cfsede) async {
    final db = await instance.database;
    final id = await db.insert('cfsede', cfsede.toJson());
    return cfsede.copy(id: id);
  }

  // Inizio Dorig
  Future addDorig(
    String id_dotes,
    String id_dorig,
    String id_ditta,
    String cd_cf,
    String cd_ar,
    String cd_arlotto,
    String qta,
    String qtaevadibile,
    String descrizione,
    String prezzounitariov,
    String cd_aliquota,
    String scontoriga,
    String prezzounitarioscontatov,
    String prezzototalev,
    String id_dorig_evade,
    String linkcf,
    String noteriga,
    String xcolli,
    String xconfezione,
    String noteagg,
    String cd_mg_p,
    String stato,
    String xlega_doc,
  ) async {
    final dorig_end = DORig(
      id_ditta: id_ditta,
      cd_cf: cd_cf,
      descrizione: descrizione,
      id_dotes: id_dotes,
      id_dorig: id_dorig,
      cd_ar: cd_ar,
      cd_arlotto: cd_arlotto,
      qta: qta,
      qtaevadibile: qtaevadibile,
      cd_aliquota: cd_aliquota,
      prezzounitariov: prezzounitariov,
      scontoriga: scontoriga,
      prezzototalev: prezzototalev,
      prezzounitarioscontatov: prezzounitarioscontatov,
      id_dorig_evade: id_dorig_evade,
      linkcf: linkcf,
      noteriga: noteriga,
      xcolli: xcolli,
      xconfezione: xconfezione,
      noteagg: noteagg,
      cd_mg_p: cd_mg_p,
      stato: 'false',
      xlega_doc: xlega_doc,
    );

    await ProvDatabase.instance.createDORig(dorig_end);
  }

  Future<List<DORig>> readAllDORig() async {
    final db = await instance.database;

    final result = await db.query('dorig');

    return result.map((json) => DORig.fromJson(json)).toList();
  }

  Future<int> deleteDORig(int id) async {
    final db = await instance.database;

    return await db.delete(
      'dorig',
      where: '${DORigField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<DORig> createDORig(DORig dorig) async {
    final db = await instance.database;
    final id = await db.insert('dorig', dorig.toJson());

    return dorig.copy(id: id);
  }

  Future<int> deleteallDORig() async {
    final db = await instance.database;

    return await db.delete(
      'dorig',
    );
  }

  Future addDOTes_Prov(
    String id_ditta,
    String id_dotes,
    String xriffatra,
    String xcd_xveicolo,
    String ximppag,
    String xautista,
    String ximpfat,
    String xsettimana,
    String ximb,
    String xacconto,
    String xaccontoF,
    String xtipoveicolo,
    String xmodifica,
    String xurgente,
    String xpagata,
    String xriford,
    String xpagatat,
    String xpagataf,
    String xclidest,
    String linkcart,
    String xnumerodocrif,
    String datadocrif,
  ) async {
    final dotes_prov_end = DOTes_Prov(
      id_ditta: id_ditta,
      id_dotes: id_dotes,
      xriffatra: xriffatra,
      xcd_xveicolo: xcd_xveicolo,
      ximppag: ximppag,
      xautista: xautista,
      ximpfat: ximpfat,
      xsettimana: xsettimana,
      ximb: ximb,
      xacconto: xacconto,
      xaccontoF: xaccontoF,
      xtipoveicolo: xtipoveicolo,
      xmodifica: xmodifica,
      xurgente: xurgente,
      xpagata: xpagata,
      xriford: xriford,
      xpagatat: xpagatat,
      xpagataf: xpagataf,
      xclidest: xclidest,
      linkcart: linkcart,
      xnumerodocrif: xnumerodocrif,
      datadocrif: datadocrif,
    );

    await ProvDatabase.instance.createDOTes_Prov(dotes_prov_end);
  }

  Future<DOTes_Prov> createDOTes_Prov(DOTes_Prov DOTesProv) async {
    final db = await instance.database;
    final id = await db.insert('dotes_prov', DOTesProv.toJson());

    return DOTesProv.copy(id: id);
  }

  // Inizio DOTes

  Future addDOTes(
    String cd_cf,
    String cd_do,
    String id_ditta,
    String id_dotes,
    String numerodoc,
    String tipodocumento,
    String datadoc,
    String cd_cfdest,
    String cd_cfsede,
    String cd_ls_1,
    String cd_agente_1,
    String cd_agente_2,
    String righeevadibili,
    String dataconsegna,
    String numerodocrif,
  ) async {
    final dotes_end = DOTes(
      id_ditta: id_ditta,
      id_dotes: id_dotes,
      cd_cf: cd_cf,
      cd_do: cd_do,
      numerodoc: numerodoc,
      tipodocumento: tipodocumento,
      datadoc: datadoc,
      cd_cfdest: cd_cfdest,
      cd_cfsede: cd_cfsede,
      cd_ls_1: cd_ls_1,
      cd_agente_1: cd_agente_1,
      cd_agente_2: cd_agente_2,
      righeevadibili: righeevadibili,
      dataconsegna: dataconsegna,
      numerodocrif: numerodocrif,
    );

    await ProvDatabase.instance.createDOTes(dotes_end);
  }

  Future<List<DOTes>> readAllDOTes() async {
    final db = await instance.database;

    final result = await db.query('dotes');

    return result.map((json) => DOTes.fromJson(json)).toList();
  }

  Future<int> deleteDOTes(int id) async {
    final db = await instance.database;

    return await db.delete(
      'dotes',
      where: '${DOTesField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<DOTes> createDOTes(DOTes dotes) async {
    final db = await instance.database;
    final id = await db.insert('dotes', dotes.toJson());

    return dotes.copy(id: id);
  }

  Future<int> deleteallDOTes() async {
    final db = await instance.database;

    return await db.delete(
      'dotes',
    );
  }

  Future<int> deleteallDOTes_Prov() async {
    final db = await instance.database;

    return await db.delete(
      'dotes_prov',
    );
  }

  // Inizio dototali

  Future addDOTotali(
    String id_dotes,
    String id_ditta,
    String totimponibilev,
    String totimpostav,
    String totdocumentov,
  ) async {
    final dototali_end = DOTotali(
      id_dotes: id_dotes,
      id_ditta: id_ditta,
      totimponibilev: totimponibilev,
      totimpostav: totimpostav,
      totdocumentov: totdocumentov,
    );

    await ProvDatabase.instance.createDOTotali(dototali_end);
  }

  Future<List<DOTotali>> readAllDOTotali() async {
    final db = await instance.database;

    final result = await db.query('DOTotali');

    return result.map((json) => DOTotali.fromJson(json)).toList();
  }

  Future<int> deleteDOTotali(int id) async {
    final db = await instance.database;

    return await db.delete(
      'dototali',
      where: '${DOTotaliField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<DOTotali> createDOTotali(DOTotali dototali) async {
    final db = await instance.database;
    final id = await db.insert('DOTotali', dototali.toJson());

    return dototali.copy(id: id);
  }

  Future<int> deleteallDOTotali() async {
    final db = await instance.database;

    return await db.delete(
      'dototali',
    );
  }
  // Inizio LS

  Future addLS(
    String id_ditta,
    String cd_ls,
    String descrizione,
  ) async {
    final ls_end = LS(
      cd_ls: cd_ls,
      id_ditta: id_ditta,
      descrizione: descrizione,
    );

    await ProvDatabase.instance.createLS(ls_end);
  }

  Future<List<LS>> readAllLS() async {
    final db = await instance.database;

    final result = await db.query('ls');

    return result.map((json) => LS.fromJson(json)).toList();
  }

  Future<int> deleteLS(int id) async {
    final db = await instance.database;

    return await db.delete(
      'ls',
      where: '${LSField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<LS> createLS(LS ls) async {
    final db = await instance.database;
    final id = await db.insert('ls', ls.toJson());

    return ls.copy(id: id);
  }

  Future<int> deleteallLS() async {
    final db = await instance.database;

    return await db.delete(
      'ls',
    );
  }

  // Inizio LSarticolo

  Future addLSArticolo(
    String id_ditta,
    String id_lsrevisione,
    String cd_ar,
    String prezzo,
    String sconto,
    String provvigione,
  ) async {
    final lsarticolo_end = LSArticolo(
      id_ditta: id_ditta,
      id_lsrevisione: id_lsrevisione,
      cd_ar: cd_ar,
      prezzo: prezzo,
      sconto: sconto,
      provvigione: provvigione,
    );

    await ProvDatabase.instance.createLSArticolo(lsarticolo_end);
  }

  Future<List<LSArticolo>> readAllLSArticolo() async {
    final db = await instance.database;

    final result = await db.query('lsarticolo');

    return result.map((json) => LSArticolo.fromJson(json)).toList();
  }

  Future<int> deleteLSArticolo(int id) async {
    final db = await instance.database;

    return await db.delete(
      'lsarticolo',
      where: '${LSArticoloField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<LSArticolo> createLSArticolo(LSArticolo lsarticolo) async {
    final db = await instance.database;
    final id = await db.insert('lsarticolo', lsarticolo.toJson());

    return lsarticolo.copy(id: id);
  }

  Future<int> deleteallLSArticolo() async {
    final db = await instance.database;

    return await db.delete(
      'lsarticolo',
    );
  }
  // Inizio Ls Revisione

  Future addLSRevisione(
    String id_ditta,
    String id_lsrevisione,
    String cd_ls,
    String descrizione,
  ) async {
    final lsrevisione_end = LSRevisione(
      cd_ls: cd_ls,
      id_ditta: id_ditta,
      descrizione: descrizione,
      id_lsrevisione: id_lsrevisione,
    );

    await ProvDatabase.instance.createLSRevisione(lsrevisione_end);
  }

  Future<List<LSRevisione>> readAllLSRevisione() async {
    final db = await instance.database;

    final result = await db.query('lsrevisione');

    return result.map((json) => LSRevisione.fromJson(json)).toList();
  }

  Future<int> deleteLSRevisione(int id) async {
    final db = await instance.database;

    return await db.delete(
      'lsrevisione',
      where: '${LSRevisioneField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<LSRevisione> createLSRevisione(LSRevisione lsrevisione) async {
    final db = await instance.database;
    final id = await db.insert('lsrevisione', lsrevisione.toJson());

    return lsrevisione.copy(id: id);
  }

  Future<int> deleteallLSRevisione() async {
    final db = await instance.database;

    return await db.delete(
      'lsrevisione',
    );
  }
// Inizio LSScaglione

  Future addLSScaglione(
    String id_ditta,
    String id_lsarticolo,
    String prezzo,
    String finoaqta,
  ) async {
    final lsscaglione_end = LSScaglione(
      id_lsarticolo: id_lsarticolo,
      id_ditta: id_ditta,
      prezzo: prezzo,
      finoaqta: finoaqta,
    );

    await ProvDatabase.instance.createLSScaglione(lsscaglione_end);
  }

  Future<List<LSScaglione>> readAllLSScaglione() async {
    final db = await instance.database;

    final result = await db.query('lsscaglione');

    return result.map((json) => LSScaglione.fromJson(json)).toList();
  }

  Future<int> deleteLSScaglione(int id) async {
    final db = await instance.database;

    return await db.delete(
      'lsscaglione',
      where: '${LSScaglioneField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<LSScaglione> createLSScaglione(LSScaglione lsScaglione) async {
    final db = await instance.database;
    final id = await db.insert('lsScaglione', lsScaglione.toJson());

    return lsScaglione.copy(id: id);
  }

  Future<int> deleteallLSScaglione() async {
    final db = await instance.database;

    return await db.delete(
      'lsscaglione',
    );
  }
  //Inizio MGGIAC

  Future addMGGIAC(
    String id_ditta,
    String cd_ar,
    String disponibile,
    String giacenza,
    String cd_mg,
  ) async {
    final mggiac_end = MGGiac(
      cd_ar: cd_ar,
      id_ditta: id_ditta,
      disponibile: disponibile,
      cd_mg: cd_mg,
      giacenza: giacenza,
    );

    await ProvDatabase.instance.createMGGIAC(mggiac_end);
  }

  Future<MGGiac> createMGGIAC(MGGiac mggiac) async {
    final db = await instance.database;
    final id = await db.insert('mggiac', mggiac.toJson());

    return mggiac.copy(id: id);
  }

  Future<int> deleteallMGGIAC() async {
    final db = await instance.database;

    return await db.delete(
      'mggiac',
    );
  }

  Future<int> deleteallSC() async {
    final db = await instance.database;

    return await db.delete(
      'sc',
    );
  }
}
