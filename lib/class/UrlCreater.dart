import 'package:connectivity/connectivity.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:itea_green_d/class/htpResponce.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetUrl {
  String mainUrl;
  GetUrl() {
    mainUrl = "https://live.slcodemaster.com/formAplication/ded/";
  }
  GetUrl.coustom(String mainUrl) {
    this.mainUrl = mainUrl;
  }

  String deviceCheck(String emi) {
    return mainUrl + "deviceCheck/" + emi;
  }

  String loginURL(String emi, String email, String pass) {
    return mainUrl + "login/" + emi + "/" + email + "/" + pass;
  }

  String getJobs(String emi, int collectorID) {
    return mainUrl + "getJob/" + emi + "/" + collectorID.toString();
  }

  String acseptJobs(String emi, int jobID) {
    return mainUrl + "AcseptJob/" + emi + "/" + jobID.toString();
  }

  String getSupliers(int root, int company) {
    return mainUrl +
        "GetSupliers/" +
        root.toString() +
        "/" +
        company.toString();
  }
}
