import 'package:intl/intl.dart';

String dateFormatter(String type,String date){
return  DateFormat(type)
                                                          .format(DateTime(
                                                              int.parse(date
                                                                  .split(
                                                                      '-')[0]),
                                                              int.parse(date
                                                                  .split(
                                                                      '-')[1]),
                                                              int.parse(date
                                                                  .split(
                                                                      '-')[2]))) ;
}