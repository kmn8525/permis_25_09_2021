import 'dart:async';
import 'dart:io';
import 'dart:ui';


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
 import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permis/Acceuil.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:sp_util/sp_util.dart';
import 'package:toast/toast.dart';
import 'Dessiner.dart';
import 'EcranSolutions.dart';
import 'ListeConducteurPassager.dart';
import 'ListeDefinition.dart';
import 'ListeFavoris.dart';
import 'Constantes.dart';


import 'ListeResultats.dart';

import 'Option.dart';
import 'Question.dart';
import 'TrasitionPages.dart';
import 'Utility.dart';



var tampon  ;
var listecharger ;

String TitreTheme ;
int MoyennePoint = 0 ;


class EcranQuestions extends StatefulWidget  {

    String titrePage;
    int NumImage ;



  EcranQuestions({Key key , this.titrePage, this.NumImage}) : super(key: key);
  EcranQuestions.C1({Key key , this.titrePage}) : super(key: key);


  @override
  EcranQuestionsState createState() => EcranQuestionsState();


  Object chargementListesDeQuestion() {

    if (titrePage == 'DEFINITION') {
       tampon =   Definition.C1(NumImage);

     }

    else if (titrePage == 'CONDUCTEUR') {
      {
         tampon =    ConducteurPassager.C1(NumImage);

        }
    }
    else if (titrePage == 'FAVORIS') {
        tampon =    FavorisState();


    }
    else if (titrePage == 'INJONCTIONS') {
      {
        /*var i = () => Incjontion();
        tampon = i();*/
      }
    }
    else if (titrePage == 'FEUX') {
      {
       /* var f = () => Feux();
        tampon = f();*/
      }
    }

    return tampon ;

  }


    Object chargementTitreTheme() {

    if (titrePage == 'DEFINITION') {
      TitreTheme = 'DEFINITION' ;
    }

    else if (titrePage == 'CONDUCTEUR') {
      {
        TitreTheme = 'CONDUCTEUR' ;


      }
    }
    else if (titrePage == 'INJONCTIONS') {
      {
        TitreTheme = 'INJONCTIONS' ;


      }
    }
    else if (titrePage == 'FEUX') {
      {
        TitreTheme = 'FEUX' ;

      }

    }

    else if (titrePage ==  'disk') {

      TitreTheme = 'disk' ;
    }


    return TitreTheme ;

  }



}

enum TtsState { playing, stopped, paused, continued }


class EcranQuestionsState extends State<EcranQuestions>  with ChangeNotifier , SingleTickerProviderStateMixin {

   final  _screenshotController = ScreenshotController();

  bool verifi = false ;
  String cleNumQD = "qd";

  String cleNumCD = "cd";
  String cleNumQCO = "qco";

  String cleNumCCO = "cco";

  int nbCD  ;
  int nbQCO  ;
  int nbQCCO  ;
  int i ;
  String RecupereCleQuestionDefinition=""  ;
  String RecupereCleQuestionConducteurPass=""  ;

   bool verifExisteQuestion ;

  Color couleurPardefault_A = Color(0xffffffff) ;
  Color couleurPardefault_B =  Color(0xffffffff) ;
  Color couleurPardefault_C =  Color(0xffffffff) ;

  Color couleurPardefault_bouton_Explication =  Colors.blue;
  Color couleurApresSelection_bouton_Explication =  Colors.blue;
  Color couleurAvant_Sauvegarde =  Colors.grey;
  Color couleurApres_Sauvegarde  =  Colors.blue;


  Color couleurApresSelection_A = Colors.orange;
  Color couleurApresSelection_B = Colors.orange;
  Color couleurApresSelection_C = Colors.orange;

  Color couleurAnimation = Colors.white ;

   bool animer = false ;
   int t = 2 ;

  bool val = false ;
  String f ;

  bool choix_1;
  bool choix_2;
  bool choix_3;
  bool valeur_choisi;
  int  point ;

  int indice  ;


  bool clic_bouton_A = false;
  bool clic_bouton_B = false;
  bool clic_bouton_C = false;
  bool clic_bouton_explication = false;
  bool clic_bouton_sauvegarde = false;


  bool visibilite_bouton_Valider = true;
  bool visibilite_bouton_explication = false;
  bool visibilite_bouton_sauvegarde = false;

  bool visibilite_bouton_Suivant = false;
  bool visibilite_bouton_C = false;
  bool visibilite_zoneExplication = false ;


  bool visibilite_imageExplication_1 = false;
  bool visibilite_imageExplication_2 = true;
  bool visibilite_imageExplication_3 = true;
  bool visibilite_imageExplication_4 = true;
  bool visibilite_imageExplication_5 = true;


  bool desactive_boutonA = false;
  bool desactive_boutonB = false;
  bool desactive_boutonC = false;
  bool desactive_bouton_Explication= false;
  bool desactive_bouton_Sauvegarde = false;

  String _tf = 'Aucun texte saisi';
  String _tfS = 'Aucun texte soumis';
  String _cTf = 'Aucun texte saisi';
  String _cTfS = 'Aucun texte soumis';
  String selectedCurrency = "Il y a une erreur dans le contenue";

  String dropdownValue = 'One';




  FlutterTts flutterTts;
  dynamic languages;
  //String language;
  double volume = 1.0;
  double pitch = 1.1;
  double rate = 1.0;
  String _text_parler ;
  String  id = "";
  String RecuperCleListeFavoris=" " ;





       /////////////////////////////////////////////////////////////////////
        ///// ---------------   LISTE DE VARIABLE  QUI PERMETEENT DE ///////
                   // SAUVEGARDER LES QUESTION ET OPTION-------------- /////////
      /////////////////////////////////////////////////////////////////////

  String idQuestion ;
  String idOption;
  String explication ;
  String q;
  bool g;
  String e;
  bool repA;
  bool repB;
  bool repC;
  String  cheminImageSource;
  int numeroImagesource;
  String  cheminQuestionAnimationExplication;
  int numeroQuestionAnimationExplication;

  String optionA;
  String optionB;
  String optionC;
  /////////////////////////////////////////////////////////////////////
  //---------/////////////////////////////////------------//


 bool etatIdQuestion ;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  Color couleurChoix = Colors.red;

   Future _getLanguages() async {
     languages = await flutterTts.setLanguage("fr-FR");
     // flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
     if (languages != null) setState(() => languages);
   }

  String liensImageImageSource (){

    return tampon.getCheminImageSourceQuestion() ;
  }


  String ChargeTitrePages (){

    return widget.titrePage ;
  }

  Future<dynamic> awaitSpeakCompletion(bool awaitCompletion) async {
    await flutterTts.awaitSpeakCompletion(awaitCompletion);

  }


   void _captureEcran() async {
     final imageFile = await _screenshotController.capture();
     Share.shareFiles([imageFile.path] , subject :'envoie de la question $idQuestion' , text : 'voici de la question ');
   }

  void ActulisationDesvaleurAsauvegarder(){
   idQuestion = tampon.getIdQuestion();
  q = tampon.getQuestionText();
  g = tampon.getFauteGrave() ;
   repA = tampon.getReponseA() ;
  repB = tampon.getReponseB() ;
  repC = tampon.getReponseC() ;
  explication = tampon.getExplication();

  cheminImageSource = tampon.getCheminImageSourceQuestion() ;
  numeroImagesource = tampon.getNumeroImageSourceQuestion() ;
  cheminQuestionAnimationExplication = tampon.getCheminQuestionAnimationExplication() ;
  numeroQuestionAnimationExplication = tampon.getNumeroQuestionAnimationExplication() ;



  idOption = tampon.getIdOption() ;
  optionA = tampon.getOptionA() ;
  optionB = tampon.getOptionB();
  optionC = tampon.getOptionC();
}

var d ;

   bool   StatutQuestionSauvegarder(){





      verifExisteQuestion =  Provider.of<FavorisState>(context , listen: false).VerificationQuestionFavoris(idQuestion) ;


return  verifExisteQuestion ;

   }



void load(){


}

  @override
  void initState() {


    RecupereCleQuestionDefinition =  Provider.of<Definition>(context , listen: false).getCleNumQueDef ;

     RecupereCleQuestionConducteurPass =  Provider.of<ConducteurPassager>(context , listen: false).getCleNumQueCondPass ;

    widget.chargementListesDeQuestion();
    widget.chargementTitreTheme();
    StatutQuestionSauvegarder();

    masqueBouton( ) ;


    ChargeTitrePages () ;
    resetColor();
    initTts();
    _speak() ;
    visibilite_bouton_explication = false ;
    visibilite_bouton_sauvegarde = false ;



    super.initState();


  }





  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }



    textFini(){

    flutterTts = FlutterTts();
     flutterTts.setCompletionHandler(() {
     });


    return  ;
  }


  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    if (isAndroid || isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          ttsState = TtsState.paused;
        });
      });
      flutterTts.setStartHandler(() {
        setState(() {
          ttsState = TtsState.playing;

         });
      });

      flutterTts.setCompletionHandler(() {
        setState(() {
          ttsState = TtsState.stopped;
        });
       });
      flutterTts.setContinueHandler(() {
        setState(() {
          ttsState = TtsState.continued;
        });
      });
    }



    flutterTts.setErrorHandler((msg) {
      setState(() {


        ttsState = TtsState.stopped;
      });
    });
    flutterTts.setProgressHandler(
            (String text, int startOffset, int endOffset, String word) {



              setState(() {


                if (word == "boire" ) {
                  /*visibilite_imageExplication_1 = true ;
                  flutterTts.pause();
                  flutterTts.continueHandler();
                  print("0----------") ;
                  print(_text_parler);*/

                  _text_parler = _text_parler.replaceAll("boire", " ") ;

                  for ( int i = 0 ; i <_text_parler.length ; i++ ) {

                    print(_text_parler[i]);

                  }


                 }

                if (word == ".." ) {

                  print("deux") ;
                }


              });
        });


  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_text_parler != null) {
      if (_text_parler.isNotEmpty) {
        var result = await flutterTts.speak(_text_parler);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  Future _arretDeLaVOix() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }
  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }


  int getIndiceTotal()
  {
    return indice ;
  }

  String statut =" " ;

  Future   <String> _finDeLaVoix() async {
    var result = await flutterTts.stop();
    if (result == 1) {
      return "oui" ;
    }
    else {
      return "non" ;
    }

  }





  Color verificationDesReponse(bool a, bool b, bool c) {
    bool verif_a;
    bool verif_b;
    bool verif_c;


    setState(() {
      // --------------------------------------//
      // ----- ON TESTE SI TOUTES LES VALEUR NE SONT SELECTIONNER  ---- //
      // --------------------------------------//

      if ((a == null) & (b == null) & (c == null))
      {
        verif_a = tampon.getReponseA();
        verif_b = tampon.getReponseB();
        verif_c = tampon.getReponseC();
        point  = tampon.getPoint();
        couleurChoix = Colors.red ;

        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionA(couleurPardefault_A);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionB(couleurPardefault_B);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionC(couleurPardefault_C);

        if ((verif_a == true) & (verif_b == true)) {
          couleurPardefault_A = Colors.green;
          couleurPardefault_B = Colors.green;
        } else if ((verif_a == true) & (verif_c == true)) {
          couleurPardefault_A = Colors.green;
          couleurPardefault_C = Colors.green;
        } else if ((verif_b == true) & (verif_c == true)) {
          couleurPardefault_B = Colors.green;
          couleurPardefault_C = Colors.green;
        } else if (verif_a == true) {
          couleurPardefault_A = Colors.green;
        } else if (verif_b == true) {
          couleurPardefault_B = Colors.green;
        } else {
          couleurPardefault_C = Colors.green;
        }



        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonA(couleurPardefault_A);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonB(couleurPardefault_B);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonC(couleurPardefault_C);





      }

      // --------------------------------------//
// ----- ON TESTE SI TOUTE LES VALEURS  SONT SELECTIONNER ---- //
      // --------------------------------------//

      else if ((a != null) & (b != null) & (c != null))
      {

        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionA (couleurApresSelection_A);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionB (couleurApresSelection_B);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionC (couleurApresSelection_C);

        couleurChoix = Colors.red ;

        verif_a = tampon.getReponseA();
        verif_b = tampon.getReponseB();
        verif_c = tampon.getReponseC();

        if ((verif_a == a) & (verif_b == b)) {
          couleurApresSelection_A = Colors.green;
          couleurApresSelection_B = Colors.green;
          couleurApresSelection_C = Colors.red;

        } else if ((verif_a == a) & (verif_c == c)) {
          couleurApresSelection_A = Colors.green;
          couleurApresSelection_C = Colors.green;
          couleurApresSelection_B = Colors.red;

        } else if ((verif_b == b) & (verif_c == c)) {
          couleurApresSelection_B = Colors.green;
          couleurApresSelection_C = Colors.green;
          couleurApresSelection_A = Colors.red;

        } else if (verif_a == a) {
          couleurApresSelection_A = Colors.green;
          couleurApresSelection_B = Colors.red;
          couleurApresSelection_C = Colors.red;


        } else if (verif_b == b) {
          couleurApresSelection_B = Colors.green;
          couleurApresSelection_C = Colors.red;
          couleurApresSelection_A = Colors.red;


        } else {
          couleurApresSelection_C = Colors.green;
          couleurApresSelection_B = Colors.red;
          couleurApresSelection_A = Colors.red;

        }


        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonA(couleurApresSelection_A);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonB(couleurApresSelection_B);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonC(couleurApresSelection_C);


      }

      // --------------------------------------//
// ----- ON TESTE SI   A ET B  SONT SELECTIONNER ---- //
      // --------------------------------------//
      else if ((a != null) & (b != null) )
      {

        verif_a = tampon.getReponseA();
        verif_b = tampon.getReponseB();
        verif_c = tampon.getReponseC();
        couleurChoix = Colors.red ;


        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionA (couleurApresSelection_A);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionB (couleurApresSelection_B);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionC (Colors.white);

        if ((verif_a == a) & (verif_b == b)) {
          couleurApresSelection_A = Colors.green;
          couleurApresSelection_B = Colors.green;
          couleurApresSelection_C = Colors.white;

          couleurChoix = Colors.green ;



        }

        else if (verif_a == a)
        {
          couleurApresSelection_A = Colors.green;
          couleurApresSelection_B = Colors.red;
          couleurPardefault_C = Colors.white;



        }
        else if (verif_b == b )
        {
          couleurApresSelection_B = Colors.green;
          couleurApresSelection_A = Colors.red;
          couleurPardefault_C = Colors.white;

        }
        else
        {
          couleurApresSelection_B = Colors.red;
          couleurApresSelection_A = Colors.red;

          couleurPardefault_C = Colors.green;

        }


        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonA(couleurApresSelection_A);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonB(couleurApresSelection_B);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonC(couleurPardefault_C);


      }

      // --------------------------------------//
// ----- ON TESTE SI   A ET C  SONT SELECTIONNER ---- //
      // --------------------------------------//

      else if ((a != null) & (c != null) )
      {

        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionA (couleurApresSelection_A);

        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionC (couleurApresSelection_C);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionB (Colors.white);

        verif_a = tampon.getReponseA();
        verif_b = tampon.getReponseB();
        verif_c = tampon.getReponseC();
        couleurChoix = Colors.red ;


        if ((verif_a == a) & (verif_c == c)) {
          couleurApresSelection_A = Colors.green;
          couleurApresSelection_C = Colors.green;
          couleurPardefault_B = Colors.white;


          couleurChoix = Colors.green ;

        }

        else if (verif_a == a)
        {
          couleurApresSelection_A = Colors.green;
          couleurApresSelection_C = Colors.red;
          couleurPardefault_B = Colors.white;


        }
        else if (verif_c == c)
        {
          couleurApresSelection_C = Colors.green;
          couleurApresSelection_A = Colors.red;
          couleurPardefault_B = Colors.white;

        }
        else {
          couleurPardefault_B = Colors.green;
          couleurApresSelection_C = Colors.red;
          couleurApresSelection_A = Colors.red;


        }


        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonA(couleurApresSelection_A);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonB(couleurPardefault_B);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonC(couleurApresSelection_C);

      }

      // --------------------------------------//
// ----- ON TESTE SI   B ET C  SONT SELECTIONNER ---- //
      // --------------------------------------//
      else if ((b != null) & (c != null) )
      {

        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionB (couleurApresSelection_B);

        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionC (couleurApresSelection_C);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionA (Colors.white);

        verif_a = tampon.getReponseA();
        verif_b = tampon.getReponseB();
        verif_c = tampon.getReponseC();
        couleurChoix = Colors.red ;


        if ((verif_b == b) & (verif_c == c)) {
          couleurApresSelection_B = Colors.green;
          couleurApresSelection_C = Colors.green;
          couleurPardefault_C = Colors.white;


          couleurChoix = Colors.green ;

        }

        else if (verif_b == b)
        {
          couleurApresSelection_B = Colors.green;
          couleurApresSelection_C = Colors.red;
          couleurPardefault_A = Colors.white;


        }
        else if (verif_c == c)
        {
          couleurApresSelection_C = Colors.green;
          couleurApresSelection_B = Colors.red;
          couleurPardefault_A = Colors.white;


        }
        else {
          couleurPardefault_A = Colors.green;
          couleurApresSelection_B = Colors.red;
          couleurApresSelection_C = Colors.red;

        }


        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonA(couleurPardefault_A);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonB(couleurApresSelection_B);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonC(couleurApresSelection_C);


      }

      // --------------------------------------//
// ----- ON SELECTIONNE A  ET   B , C SONT NULL---- //
      // --------------------------------------//

      else if ((a != null) & (b == null) & (c == null))
      {
        verif_a = tampon.getReponseA();
        verif_b = tampon.getReponseB();
        verif_c = tampon.getReponseC();
        couleurChoix = Colors.red ;

        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionA (couleurApresSelection_A);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionB (Colors.white);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionC (Colors.white);


        if ((verif_a == a) & (verif_b == true)) {
          couleurApresSelection_A = Colors.green;
          couleurPardefault_B = Colors.green;
          couleurPardefault_C = Colors.white;

          couleurChoix = Colors.green ;

        } else if ((verif_b == true) & (verif_c == true)) {
          couleurApresSelection_A = Colors.red;
          couleurPardefault_B = Colors.green;
          couleurPardefault_C = Colors.green;

        } else if ((verif_a == a) & (verif_c == true)) {
          couleurApresSelection_A = Colors.green;
          couleurPardefault_B = Colors.white;
          couleurPardefault_C = Colors.green;


          couleurChoix = Colors.green ;


        } else  if (verif_a == a)  {
          couleurApresSelection_A = Colors.green;
          couleurPardefault_B = Colors.white;
          couleurPardefault_C = Colors.white;
          couleurChoix = Colors.green ;


          couleurChoix = Colors.green ;

        }
        else  if (verif_b == true)  {
          couleurApresSelection_A = Colors.red;
          couleurPardefault_B = Colors.green;
          couleurPardefault_C = Colors.white;

        }
        else {
          couleurApresSelection_A = Colors.red;
          couleurPardefault_B = Colors.white;
          couleurPardefault_C = Colors.green;


        }



        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonA(couleurApresSelection_A);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonB(couleurPardefault_B);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonC(couleurPardefault_C);

      }

      // --------------------------------------//
// ----- ON  SELECTIONNE B  ET   A , C SONT NULL ---- //
      // --------------------------------------//

      else if ((b != null) & (a == null) & (c == null))
      {


        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionB (couleurApresSelection_B);

        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionC (Colors.white);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionA (Colors.white);

        verif_a = tampon.getReponseA();
        verif_b = tampon.getReponseB();
        verif_c = tampon.getReponseC();

        couleurChoix = Colors.red ;


        if ((verif_b == b) & (verif_a == true)) {
          couleurApresSelection_B = Colors.green;
          couleurPardefault_A = Colors.green;
          couleurPardefault_C = Colors.white;

          couleurChoix = Colors.green ;

        } else if ((verif_b == true) & (verif_c == true)) {
          couleurApresSelection_B = Colors.red;
          couleurPardefault_A = Colors.green;
          couleurPardefault_C = Colors.green;
        } else if ((verif_b == b) & (verif_c == true)) {
          couleurApresSelection_B = Colors.green;
          couleurPardefault_A = Colors.white;
          couleurPardefault_C = Colors.green;

          couleurChoix = Colors.green ;

        }  else  if (verif_b == b)  {
          couleurApresSelection_B = Colors.green;
          couleurPardefault_B = Colors.green;
          couleurPardefault_C = Colors.white;


          couleurChoix = Colors.green ;

        }
        else  if (verif_a == true)  {
          couleurApresSelection_B = Colors.red;
          couleurPardefault_A = Colors.green;
          couleurPardefault_C = Colors.white;
        }
        else {
          couleurApresSelection_B = Colors.red;
          couleurPardefault_A = Colors.white;
          couleurPardefault_C = Colors.green;

        }

        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonA(couleurPardefault_A);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonB(couleurApresSelection_B);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonC(couleurPardefault_C);


      }
      // --------------------------------------//
// ----- ON  SELECTIONNE C  ET   A , B SONT NULL---- //
      // --------------------------------------//

      else if ((c != null) & (a == null) & (b == null))
      {
        verif_a = tampon.getReponseA();
        verif_b = tampon.getReponseB();
        verif_c = tampon.getReponseC();

        couleurChoix = Colors.red ;

        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionC (couleurApresSelection_C);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionB (Colors.white);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurSelectionA (Colors.white);



        if ((verif_c == c) & (verif_a == true)) {
          couleurApresSelection_C = Colors.green;
          couleurPardefault_A = Colors.green;
          couleurPardefault_B = Colors.white;

          couleurChoix = Colors.green ;

        } else if ((verif_b == true) & (verif_a == true)) {
          couleurApresSelection_C = Colors.red;
          couleurPardefault_A = Colors.green;
          couleurPardefault_B = Colors.green;
        } else if ((verif_c == c) & (verif_a == true)) {
          couleurApresSelection_C = Colors.green;
          couleurPardefault_B = Colors.white;
          couleurPardefault_A = Colors.green;

          couleurChoix = Colors.green ;

        }  else  if (verif_c == c)  {
          couleurApresSelection_C = Colors.green;
          couleurPardefault_B = Colors.white;
          couleurPardefault_A = Colors.white;

          couleurChoix = Colors.green ;

        }
        else  if (verif_a == true)  {
          couleurApresSelection_C = Colors.red;
          couleurPardefault_A = Colors.green;
          couleurPardefault_B = Colors.white;
        }
        else {
          couleurApresSelection_C = Colors.red;
          couleurPardefault_A = Colors.white;
          couleurPardefault_B = Colors.green;

        }

        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonA(couleurPardefault_A);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonB(couleurPardefault_B);
        Provider.of<Resultats>(context , listen: false).ajouterColoueurBoutonC(couleurApresSelection_C);


      }

    });





    return couleurChoix ;
  }

// ----- REINITIALISATION DES COULEUR APRES LA PROCHAINE QUESTION ---- //

  void resetColor() {
    setState(() {
      visibilite_imageExplication_1 = false ;
      couleurPardefault_B = Colors.white;
      couleurPardefault_A = Colors.white;
      couleurPardefault_C = Colors.white;

      couleurApresSelection_A = Colors.orange;
      couleurApresSelection_B = Colors.orange;
      couleurApresSelection_C = Colors.orange;
    });
  }

  void BoutonSuivant() {


    resetColor();
    setState(() {

      if (tampon.FinTheme() == true) {

        _arretDeLaVOix();
         Utility.instance
            .setIntegerValue(RecupereCleQuestionDefinition, 0);
        Utility.instance
            .setIntegerValue(RecupereCleQuestionConducteurPass, 0);


        var alertStyle = AlertStyle(
          animationType: AnimationType.fromTop,
          isCloseButton: false,
          isOverlayTapDismiss: false,
          descStyle: TextStyle(fontWeight: FontWeight.bold),
          descTextAlign: TextAlign.start,
          animationDuration: Duration(milliseconds: 500),
          alertBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: Colors.grey,
            ),
          ),
          titleStyle: TextStyle(
            color: Colors.green,
          ),
          alertAlignment: Alignment.center,
        );
        Alert(
          context: context,
          style: alertStyle,
          image: SvgPicture.asset(
            'assets/emoji/happy.svg',
            height: 43.0,
            width: 43.0,
            allowDrawingOutsideViewBox: true,
          ),
          // type: AlertType.info,
          title: "FIN DE LA SERIE",

          // desc: "Voulez-vous continuez ?.",

          buttons: [


            DialogButton(
              margin: EdgeInsets.all(15),

              child: Text(

                "THEMES",
                style: TextStyle(color: Colors.white, fontSize: 8),
              ),


              onPressed:  () {
                _arretDeLaVOix();
                Provider.of<Resultats>(context , listen: false).SuprimerLesResultat();

                Provider.of<Resultats>(context , listen: false).reset();


                Navigator.of(context, rootNavigator: true ).push(TransitionHaut(

                    page :  Accueil( 1 )));



              },


              color: Colors.deepOrangeAccent,

            ) ,

            DialogButton(
              //  padding: EdgeInsets.all(15),

              child: Text(
                "CORRECTION",
                style: TextStyle(color: Colors.white, fontSize: 8),
              ),


              onPressed:  () {

                _arretDeLaVOix();
                Navigator.of(context, rootNavigator: false ).push(MaterialPageRoute(
                    builder: (BuildContext context  ) =>
                        EcranSolutions(TitreTheme: '${TitreTheme}' )));

              },

              gradient: LinearGradient(colors: [
                Color.fromRGBO(116, 116, 191, 1.0),
                Color.fromRGBO(52, 138, 199, 1.0)
              ]),
            )

          ],



        ).show();

      }
      else {

        visibilite_bouton_Valider = !visibilite_bouton_Valider; // le bouton valider est desactiver
        visibilite_bouton_Suivant = !visibilite_bouton_Suivant; // le bouton suivant est afficher
        visibilite_zoneExplication  = ! visibilite_zoneExplication ;
        desactive_boutonA = !desactive_boutonA;
        desactive_boutonB = !desactive_boutonB;
        desactive_boutonC = !desactive_boutonC;

        clic_bouton_A = false;
        clic_bouton_B = false;
        clic_bouton_C = false;

        tampon.questionSuivante();
        tampon.optionSuivante();


        masqueBouton( ) ;
        resetColor();



      }

    });


  }

  void BoutonValider() {

    setState(() {
      choix_1 = null;
      choix_2 = null;
      choix_3 = null;


      visibilite_bouton_Valider = !visibilite_bouton_Valider;
      visibilite_bouton_Suivant = !visibilite_bouton_Suivant;
      visibilite_zoneExplication = ! visibilite_zoneExplication ;


    });


  }

  void _aChoisi(int value) {
  }

  bool valeurChoisiA() {
    if (clic_bouton_A == true) {
      valeur_choisi = true;
    } else {
      valeur_choisi = null;
    }

    return valeur_choisi;
  }

  bool valeurChoisiB() {
    if (clic_bouton_B == true) {
      valeur_choisi = true;
    } else {
      valeur_choisi = null;
    }

    return valeur_choisi;
  }

  bool valeurChoisiC() {
    if (clic_bouton_C == true) {
      valeur_choisi = true;
    } else {
      valeur_choisi = null;
    }

    return valeur_choisi;
  }

  void masqueBouton( ) {

    setState(() {

      if ( tampon.getOptionC()   == 'null' ) {
         visibilite_bouton_C = false ;

        _text_parler  = tampon.getQuestionText() +  ":" + "," + tampon.getOptionA() + " , Reponse A ,  "  + tampon.getOptionB() + " , Reponse B , "   ;

        _speak();

      }


      else {
        visibilite_bouton_C = true ;
        _text_parler  = tampon.getQuestionText()  + "," +tampon.getOptionA() + " ,  Reponse A , " +  tampon.getOptionB() + " , Reponse B , " +  tampon.getOptionC()+ " , Reponse C ";
        _speak();


      }


    });



  }




  var IconSongAlumer =   Icon(
    Icons.volume_up,
    color: Colors.black ,
    size: 20,
  );
  var IconSongEteind = Icon(
    Icons.volume_mute,
    color: Colors.black ,
    size: 20,
  );




  static const List<String> currenciesList = <String>[
    'Il y a une erreur dans le contenue',
    'Autre',
    'Probleme image',
  ];
  Widget materialTextField() {

    return  Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Saisissez ce que vous voulez !',
        ),
        onChanged: (value) {
          setState(() {
            _tf = value;
          });
        },
        onSubmitted: (value) {
          setState(() {
            _tfS = value;
          });
        },
      ),
    );

  }

  Widget cupertinoTextField() {

    return   Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: CupertinoTextField(
        placeholder: 'Saisissez ce que vous voulez !',
        onChanged: (value) {
          setState(() {
            _cTf = value;
          });
        },
        onSubmitted: (value) {
          setState(() {
            _cTfS = value;
          });
        },
      ),
    );

  }


  Widget EcranFormulaireTextField(BuildContext context) {

    return Platform.isIOS ? cupertinoTextField() : materialTextField();

  }


  Widget EcranFormulairePicker(BuildContext context) {

    return Platform.isIOS ? iOSPicker() : androidDropdown(context);

  }
  String newValue ;

  @override
  Widget androidDropdown(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (  newValue) {
        setState(() {

          dropdownValue =  newValue;


        });
      },
      items: <String>['One', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }



  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
      },
      children: pickerItems,
    );
  }


  void showToast(String msg, {int duration, int gravity   }) {
    Toast.show(msg, context, duration: duration, gravity: gravity    );
  }
  Widget BoutonPlayStop(BuildContext context) {

    return  GestureDetector(
      child: SizedBox(
        width: 70,
        height: 70 ,

        child: Row(
          children: [
            Visibility(
              visible: visibilite_bouton_Valider,

              child: Expanded(
                child: FlatButton(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),

                  child: Container(

                    child: SvgPicture.asset(
                      'assets/icons/play.svg',
                      height: 35.0,
                      width:  35.0,
                      allowDrawingOutsideViewBox: true,
                    ),
                  ),
                  onPressed: () {


                    Color CouleurAchoisi =  verificationDesReponse(choix_1, choix_2, choix_3);

                    Provider.of<Resultats>(context , listen: false).ajouterCouleurResultats(CouleurAchoisi);


                    if (  widget.titrePage   == "CONDUCTEUR" ) {

                    setState(() {
                      Utility.instance
                          .setIntegerValue(RecupereCleQuestionConducteurPass ,  tampon.getNumQuestionCondPass);

                    });

                    }

                    else if (widget.titrePage   == "DEFINITION"  ) {

                     setState(() {
                       Utility.instance
                           .setIntegerValue(RecupereCleQuestionDefinition, tampon.getNumQueDef);

                     });

                    }


                    BoutonValider();


                    _arretDeLaVOix();
                    setState(() {
                      visibilite_bouton_explication = true ;
                      visibilite_bouton_sauvegarde = true ;

                    });




                    Provider.of<Resultats>(context , listen: false).ajoutQuestionResultat(
                        idQuestion , q ,repA , repB , repC , g
                        , explication ,point , cheminImageSource , numeroImagesource  , cheminQuestionAnimationExplication , numeroQuestionAnimationExplication);

                    Provider.of<Resultats>(context , listen: false).ajoutOptionResultat(idOption ,optionA, optionB, optionC);

                    setState(() {
                      desactive_boutonA = !desactive_boutonA;
                      desactive_boutonB = !desactive_boutonB;
                      desactive_boutonC = !desactive_boutonC;
                    });
                  },
                ),


              ),

            ),
            Visibility(
              visible: visibilite_bouton_Suivant,
              child: Expanded(
                child: FlatButton(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child:  Container(

                child: SvgPicture.asset(
                'assets/icons/suivant.svg',
                  height: 35.0,
                  width:  35.0,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
                  onPressed: () {

                    setState(() {
                       visibilite_bouton_explication = false ;
                      visibilite_bouton_sauvegarde = false ;


                    });
                    BoutonSuivant();



                  },
                  // color: Colors.blueAccent,
                ),

              ),
            ),
          ],
        ),


      ),


    );

  }

  messageSupression() {
    showToast("Message Supprimer 😥", duration : Toast.LENGTH_SHORT, gravity: Toast.CENTER  ) ;
  }

  messageSauvegarder() {
     showToast("Message Sauvegarde 👌🏾", duration : Toast.LENGTH_SHORT, gravity: Toast.CENTER  ) ;

  }




  Widget build(BuildContext context) {
    double hauteur = MediaQuery.of(context).size.height;
    final Size size = MediaQuery.of(context).size;

    ActulisationDesvaleurAsauvegarder();

    verifExisteQuestion =   StatutQuestionSauvegarder();






    //StatutFavoris() ;
     return Scaffold(
      extendBody: true,

      appBar: AppBar(

        leading:   IconButton(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            icon:   Icon(
              Icons.arrow_back,
              color: Colors.blueAccent ,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true ).push(TransitionGauche(

                  page :   Accueil(0)));


              _arretDeLaVOix() ;
            }
        ),


        title: Row(
          children: <Widget> [

            Container(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(widget.titrePage) ,


            ),

    Container(
      margin: EdgeInsets.only(left: 50),
      child: IconButton(

          icon:   Icon(
      Icons.ios_share,
      color: Colors.black ,
      size: 30,
      ),
      onPressed: () {
        _captureEcran();
        _arretDeLaVOix() ;


      }
      ),
    ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10),

                child: IconButton(
                     icon:   Icon(
                      Icons.bug_report_outlined,
                      color: Colors.black ,
                      size: 30,
                    ),
                    onPressed: () {
                       _arretDeLaVOix() ;


                    }
                ),
              ),
            ),


          ],
        ),
      ),
      body: Screenshot(
        controller: _screenshotController,

        child: Container(

          color:  Color(0xfff3f8ff),


          height: hauteur,
          child: Stack(
            children: <Widget>[


              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[

                        /////////////////////////////////////////////////////////////////////
                        ///// ---------------   ZONE  IMAGE QUESTION -------------- /////////
                        /////////////////////////////////////////////////////////////////////

                        Expanded(
                          child: Container(

                          child: Image.asset(
                              'assets/${tampon.getCheminImageSourceQuestion()}/source/${tampon.getNumeroImageSourceQuestion()}.webp',
                              height: 223,

                            ),
                          ),
                        ),


                      ],
                    ),
                  ),



                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB( 0, 20, 0, 150),

                      child: Column(
                        children: <Widget>[
                          Wrap(
                            // spacing: 2,
                            runSpacing: -70,
                            children: <Widget>[



                              /////////////////////////////////////////////////////////////////////
                              ///// ---------------   ZONE  QUESTION  -------------- /////////
                              /////////////////////////////////////////////////////////////////////

                              Container(
                                   margin: EdgeInsets.fromLTRB(10, 1, 10, 60),

                                  child: Column(
                                    children: [
                                      Center(
                                        child: Text(
                                          tampon.getQuestionText() /*+ '$d '*/    ,
                                          textAlign : TextAlign.center ,


                                           style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),


                                    ],
                                  )),
                              /////////////////////////////////////////////////////////////////////
                              ///// ---------------   BOUTON  1  -------------- /////////
                              /////////////////////////////////////////////////////////////////////

                              Row(
                                children: <Widget>[
                                  Center(
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(40, 40, 30, 50),

                                      child: Container(
                                        child: AbsorbPointer(
                                          absorbing: desactive_boutonA,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                              // side: BorderSide(color: Colors.red)
                                            ),
                                            elevation: 3,
                                            textColor: Colors.black,
                                            child: Text(
                                              tampon.getOptionA(),
                                              textAlign : TextAlign.center ,

                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                clic_bouton_A = !clic_bouton_A;
                                              });

                                              choix_1 = valeurChoisiA();



                                            },
                                            color: clic_bouton_A
                                                ? couleurApresSelection_A
                                                : couleurPardefault_A,
                                          ),
                                        ),
                                        height: 60.0,
                                        width: 260,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),

                                    child: Container(
                                      child: AbsorbPointer(
                                        absorbing: desactive_boutonA,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            // side: BorderSide(color: Colors.red)
                                          ),
                                          elevation: 3,
                                          textColor: Colors.black,
                                          child: Text(
                                            'A',
                                            textAlign : TextAlign.center ,

                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              clic_bouton_A = !clic_bouton_A;
                                            });


                                            choix_1 = valeurChoisiA();

                                          },
                                          color: clic_bouton_A
                                              ? couleurApresSelection_A
                                              : couleurPardefault_A,

                                        ),
                                      ),
                                      height: 40.0,
                                      width: 40,
                                    ),
                                  ),
                                ],
                              ),


                              /////////////////////////////////////////////////////////////////////
                              ///// ---------------   BOUTON  2  -------------- /////////
                              /////////////////////////////////////////////////////////////////////
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: Container(
                                      //margin: EdgeInsets.all(40),
                                      //  padding: EdgeInsets.fromLTRB(0, 0, 30, 0),

                                      margin: EdgeInsets.fromLTRB(40, 40, 20, 50),
                                      child: AbsorbPointer(
                                        absorbing: desactive_boutonB,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            // side: BorderSide(color: Colors.red)
                                          ),
                                          elevation: 3,
                                          textColor: Colors.black,
                                          child: Text(
                                            tampon.getOptionB(),
                                            textAlign : TextAlign.center ,

                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15 ,
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              clic_bouton_B = !clic_bouton_B;
                                            });


                                            choix_2 = valeurChoisiB();
                                          },
                                          color: clic_bouton_B ? couleurApresSelection_B : couleurPardefault_B,
                                        ),
                                      ),
                                      height: 60.0,
                                      width: 260,
                                    ),
                                  ),
                                  Container(
                                    // margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                                    child: Container(

                                      child: AbsorbPointer(
                                        absorbing: desactive_boutonB,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                            // side: BorderSide(color: Colors.red)
                                          ),
                                          elevation: 3,
                                          textColor: Colors.black,
                                          child: Center(
                                            child: Text(
                                              'B',
                                              textAlign : TextAlign.center ,

                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              clic_bouton_B = !clic_bouton_B;
                                            });

                                            choix_2 = valeurChoisiB();
                                          },
                                          color: clic_bouton_B ? couleurApresSelection_B : couleurPardefault_B,
                                        ),
                                      ),
                                      height: 40.0,
                                      width: 40,
                                    ),
                                  ),
                                ],
                              ),


                              /////////////////////////////////////////////////////////////////////
                              ///// ---------------   BOUTON  3  -------------- /////////
                              /////////////////////////////////////////////////////////////////////

                              Row(
                                children: <Widget>[
                                  Center(
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(40, 40, 20, 50),

                                      child: Visibility(
                                        visible: visibilite_bouton_C,
                                        child: Container(
                                          child: AbsorbPointer(
                                            absorbing: desactive_boutonC,
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8.0),
                                                // side: BorderSide(color: Colors.red)
                                              ),
                                              elevation: 3,
                                              textColor: Colors.black,
                                              child: Text(
                                                tampon.getOptionC() ,
                                                textAlign : TextAlign.center ,

                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {

                                                  clic_bouton_C = !clic_bouton_C;
                                                });
                                                choix_3 = valeurChoisiC();

                                              },
                                              color: clic_bouton_C ? couleurApresSelection_C : couleurPardefault_C,
                                            ),
                                          ),
                                          height: 60,
                                          width: 260,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Visibility(
                                    visible: visibilite_bouton_C,
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(10, 0, 0, 10),

                                      child: AbsorbPointer(
                                        absorbing: desactive_boutonC,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            // side: BorderSide(color: Colors.red)
                                          ),
                                          elevation: 3,
                                          textColor: Colors.black,
                                          child: Text(
                                            'C',
                                            textAlign : TextAlign.center ,

                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {

                                              clic_bouton_C = !clic_bouton_C;
                                            });
                                            choix_3 = valeurChoisiC();

                                          },
                                          color: clic_bouton_C
                                              ? couleurApresSelection_C
                                              : couleurPardefault_C,
                                        ),
                                      ),
                                      height: 52.0,
                                      width:  52,
                                    ),
                                  ),
                                ],
                              ),

                              /////////////////////////////////////////////////////////////////////
                              ///// ---------------   ZONE  Explication  -------------- /////////
                              /////////////////////////////////////////////////////////////////////

                              Visibility(
                                visible: visibilite_zoneExplication,

                                child: Container(
                                    margin: EdgeInsets.fromLTRB(10, 50, 10, 20),

                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            '$explication + $verifExisteQuestion',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),


                                      ],
                                    )),
                              ),




                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: visibilite_imageExplication_1,
                child: Positioned(
                  bottom: 600 ,
                  left: 100,
                  child :  SvgPicture.asset(
                    'assets/profil/nuage.svg',
                    height: 100.0,
                    width: 100.0,
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
              ) ,

              Positioned(
                bottom: -10,
                child: Stack(
                  alignment :  AlignmentDirectional.topCenter,

                  children:<Widget> [

                    CustomPaint(
                      size: Size(size.width, 90),
                      painter:  DessinBasBarNavigation(),
                    ),
                    Center(
                      heightFactor: 0.5,
                      child: RawMaterialButton(
                        elevation: 25 ,
                        fillColor: Colors.blueAccent,
                        shape: CircleBorder(),
                        child:   BoutonPlayStop(context),


                      ),

                    ),
                    Visibility(
                      visible: visibilite_bouton_explication,

                      child: AbsorbPointer(
                        absorbing: desactive_bouton_Explication,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 200, 0),
                          child: IconButton(
                            icon: Icon(
                              Icons.info_outline_rounded,
                              size : 30 ,
                              color: clic_bouton_explication
                                  ? couleurApresSelection_bouton_Explication
                                  : couleurPardefault_bouton_Explication,
                              //color: currentIndex == 0 ? Colors.white : Colors.blue,
                            ),
                            onPressed: () {

                              setState(() {
                                clic_bouton_explication = !clic_bouton_explication;
                               });

                            },
                            splashColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: visibilite_bouton_sauvegarde,

                      child: AbsorbPointer(
                        absorbing: desactive_bouton_Sauvegarde,

                        child: Container(
                          padding: EdgeInsets.fromLTRB(200, 10, 0, 0),
                          child: IconButton(
                            icon: Icon(


                                Icons.save,
                                size : 30 ,
                                color:  verifExisteQuestion ? couleurApres_Sauvegarde : couleurAvant_Sauvegarde

                              // color:currentIndex == 1 ? Colors.white : Colors.blue,
                            ),
                            onPressed: () {



                                if (verifExisteQuestion == false ) {





                                  Provider.of<FavorisState>(context , listen: false).ajoutQuestionFavoris(idQuestion , q ,repA , repB , repC , g
                                      , explication ,point , cheminImageSource , numeroImagesource  , cheminQuestionAnimationExplication , numeroQuestionAnimationExplication);




                                  Provider.of<FavorisState>(context , listen: false).ajoutOptionFavoris(idOption ,optionA, optionB, optionC);


                                  setState(() {

                                    verifExisteQuestion != verifExisteQuestion ;


                                  });



                                  messageSauvegarder() ;

                                }

                                else {




                                  int indexQuestionAsuprimer = Provider.of<FavorisState>(context , listen: false).retourneIndiceQuestion(idQuestion) ;
                                  int indexOptionAsuprimer = Provider.of<FavorisState>(context , listen: false).retourneIndiceOption(idOption) ;

                                   Provider.of<FavorisState>(context , listen: false).SuprimerQuestionsFavoris(indexQuestionAsuprimer) ;
                                  Provider.of<FavorisState>(context , listen: false).SuprimerOptionFavoris(indexOptionAsuprimer) ;

                                   messageSupression() ;

                                  setState(() {

                                    verifExisteQuestion != verifExisteQuestion ;


                                  });





                                }



                              //   Provider.of<Favoris>(context , listen: false).ajouterQuestion( idQuestion , q ,  reponse_A , reponse_B , reponse_C , g , e , point , chemin_image , NumeroImage) ;




                              setBottomBarIndex(1);
                            },
                          ),
                        ),
                      ),
                    ),


                  ] ,

                ),
              ) ,
            ],
          ),
        ),
      ),
      backgroundColor: null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,



    );
  }




}














