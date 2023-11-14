import 'package:intl/intl.dart';

class FormatDate {
  String konversiFormatTanggal(String tanggal) {
    // Ubah string ke dalam format DateTime
    DateTime date = DateTime.parse(tanggal).toUtc();

    // Ubah format DateTime ke format yang diinginkan (dd-MMM-yyyy)
    String formattedDate = DateFormat("dd-MMM-yyyy").format(date);

    return formattedDate;
  }
}
