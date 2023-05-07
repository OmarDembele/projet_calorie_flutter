
        import 'package:flutter/material.dart';

        class MyHomePage extends StatefulWidget {
          const MyHomePage({super.key, required this.title});

          final String title;

          @override
          State<MyHomePage> createState() => _MyHomePageState();
        }

        class _MyHomePageState extends State<MyHomePage> {

          double poids = 0.0;
          bool genre = false;
          double? age = null;
          double taille = 170.0;
          Object? radioSelectionnee = 0;
          int calorieBase = 0;
          int calorieAvecActivite = 0;

          Map maActivite = {
            0: "Faible",
            1: "Moderer",
            2: "Forte"
          };

          Widget textAvecStyle(String data, {color = Colors.black, fontSize = 15.0}){
              return Text(
                data,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: fontSize
                )
              );
          }

          MaterialColor setColor(){
            if(genre==true){
              return Colors.blue;
            }else{
              return Colors.pink;
            }
          }

          Future<Null> montrerDate() async{
            DateTime? choice = await showDatePicker(
                context: context,
                initialDatePickerMode: DatePickerMode.year,
                initialDate: DateTime(1998),
                firstDate: DateTime(1900),
                lastDate: DateTime.now()
            );
            if(choice != null){
               var difference = DateTime.now().difference(choice);
               var jour = difference.inDays;
               var an = (jour / 365);
               setState(() {
                 age = an;
               });
            }
          }

          Widget padding(){
            return const Padding(
                padding: EdgeInsets.only(top: 20));
          }

          Widget radio(){
            List<Widget> l = [];
            maActivite.forEach((key, value) {
              Column colonne = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<Object>(
                      value: key,
                      groupValue: radioSelectionnee,
                      onChanged: (Object? i){
                        setState(() {
                          radioSelectionnee = i;
                        });
                      }),
                  textAvecStyle(value, color: setColor()),
                ],
              );
              l.add(colonne);
            });
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: l,
            );
          }

          void calculerNombreDeCalorie(){
            if(age!=null && poids!=null && radioSelectionnee!=null){
              if (genre) {
                calorieBase = (66.4730 + (13.7516 * poids) + (5.0033 * taille) - (6.7550 * age!)).toInt();
              } else {
                calorieBase = (655.0955 + (9.5634 * poids) + (1.8496 * taille) - (4.6756 * age!)).toInt();
              }
              switch(radioSelectionnee) {
                case 0:
                  calorieAvecActivite = (calorieBase * 1.2).toInt();
                  break;
                case 1:
                  calorieAvecActivite = (calorieBase * 1.5).toInt();
                  break;
                case 2:
                  calorieAvecActivite = (calorieBase * 1.8).toInt();
                  break;
                default:
                  calorieAvecActivite = calorieBase;
                  break;
              }

              setState(() {
                dialogue();
              });
            }
            else{
              alert();
            }
          }

          Future<Null> alert() async {
            return showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext buildContext) {
                  return AlertDialog(
                    title: textAvecStyle("Error", ),
                    content: textAvecStyle("Tous les champs ne sont pas remplie"),
                    actions: [
                      TextButton(
                          onPressed: (){
                            Navigator.pop(buildContext);
                          },
                          child: textAvecStyle("OK", color: Colors.red))
                    ],
                  );
                }
            );
        }

        Future<Null> dialogue() async{
            return showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext builderContext){
                  return SimpleDialog(
                    title: textAvecStyle("Votre besoin en calorie", color: setColor()),
                    contentPadding: const EdgeInsets.all(15.0),
                      children: [
                        textAvecStyle("Vote besoin de base est de: $calorieBase"),
                        padding(),
                        textAvecStyle("Votre besoin en Activité sportive est de : $calorieAvecActivite"),
                        ElevatedButton(
                            onPressed: (){
                              Navigator.pop(builderContext);
                            },
                            child: textAvecStyle("OK", color: Colors.black))
                      ],
                  );
                });
        }

          @override
          Widget build (BuildContext context) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
              child: Scaffold(
                appBar: AppBar(
                  title: Text(widget.title),
                  backgroundColor: setColor(),
                  centerTitle: true,
                  elevation: 10.0,
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    padding(),
                    textAvecStyle("Remplissez toute les champs pour obtenir votre besoin en calorie", fontSize: 17.0),
                    padding(),
                    Card(
                      elevation: 10.0,
                      child: Column(
                        children: [
                          padding(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              padding(),
                              textAvecStyle("Femme", color: Colors.pink),
                              padding(),
                              Switch(
                                  value: genre,
                                  inactiveTrackColor: Colors.pink,
                                  activeColor: Colors.blue,
                                  onChanged: (bool b){
                                    setState(() {
                                      genre = b;
                                    });
                                  },),
                              padding(),
                              textAvecStyle("Homme", color: Colors.blue),
                            ],
                          ),
                          padding(),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(setColor()),
                            ),
                            onPressed: (){
                              montrerDate();
                            },
                            child: textAvecStyle( (age ==null)? "Appuyer pour entrer votre age": "Votre age est: ${age?.toInt()}",
                                color: Colors.white
                            ),
                          ),
                          padding(),
                          textAvecStyle("Vote taille est: ${taille.toInt()} cm", color: setColor(), ),
                          padding(),
                          padding(),
                          Slider(
                              value: taille,
                              activeColor: setColor(),
                              min: 100,
                              max: 215.0,
                              onChanged: (double d){
                                setState(() {
                                  taille = d;
                                });
                              }),
                          padding(),
                          TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (String string){
                              setState(() {
                                poids = double.tryParse(string)!;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: "Entrer votre poids en Kilo"
                            ),
                            ),
                          padding(),
                          textAvecStyle("Quel est votre activite sportive?", color: setColor()),
                          padding(),
                          radio(),
                          padding(),
                          ],
                        ),
                      ),
                    padding(),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(setColor()),
                        ),
                        onPressed: calculerNombreDeCalorie,
                        child: textAvecStyle("Calculer", color: Colors.white))
                    ],
                  ),
                ),
              ),
            );
          }
        }
