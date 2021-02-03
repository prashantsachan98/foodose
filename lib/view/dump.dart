/*
SizedBox(
                        height: 20,
                      ),

Card(
                        //elevation: 7,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 1,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(450),
                            color: Colors.white10,
                            boxShadow: kElevationToShadow[12],
                            //gradient:
                            //   LinearGradient(colors: [Colors.green, Colors.blue]),
                            //borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: NetworkImage(snapshot.data.image),
                              //fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.center,
                          height: 40,
                          width: MediaQuery.of(context).size.width * 1,
                          child: Text(
                            snapshot.data.title,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppins'),
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            snapshot.data.instructions[0].steps[2].step,
                            style: TextStyle(
                              //fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          //height: 400,
                          padding: EdgeInsets.all(10),
                          child: ListView.separated(
                              padding: EdgeInsets.zero,
                              separatorBuilder:
                                  (BuildContext context, int index) => Divider(
                                        height: 10,
                                      ),
                              itemCount:
                                  snapshot.data.ingredients[0].name.length,
                              itemBuilder: (context, index) {
                                int count = index + 1;
                                return Text('$count' +
                                    ' ' +
                                    snapshot.data.ingredients[0].name[index]);
                              }),
                        ),
                      ),
                      Card(
                          child: Container(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          child: ListView.separated(
                              padding: EdgeInsets.zero,
                              separatorBuilder:
                                  (BuildContext context, int index) => Divider(
                                        height: 10,
                                      ),
                              itemCount:
                                  snapshot.data.instructions[0].steps.length,
                              itemBuilder: (context, index) {
                                int count = index + 1;
                                return Text('$count' +
                                    ' ' +
                                    snapshot.data.instructions[0].steps[index]
                                        .step);
                              }),
                        ),
                      )),

 */
