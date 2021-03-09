import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:itea_green_d/Screen/SpalshScreen.dart';
import 'package:itea_green_d/Screen/home.dart';
import 'package:itea_green_d/class/Alert.dart';
import 'package:itea_green_d/class/DB.dart';
import 'package:itea_green_d/class/htpResponce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:itea_green_d/class/UrlCreater.dart';

class jobSelect extends StatefulWidget {
  @override
  _jobSelectState createState() => _jobSelectState();
}

class _jobSelectState extends State<jobSelect> {
  List jobs = [];
  bool isProscessing = true;
  bool noJobs = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkJobISActive();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHieght = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Job List"),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app), onPressed: () => {logout()}),
          IconButton(icon: Icon(Icons.close), onPressed: () => {}),
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Image(image: AssetImage("images/jobhunt.jpg")),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.warning,
                color: Colors.deepOrange,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Multiple Job Ditected",
                style: GoogleFonts.aldrich(color: Colors.red),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Select Your Job",
            style: GoogleFonts.alfaSlabOne(color: Colors.green, fontSize: 25),
          ),
          SizedBox(
            height: 8,
          ),
          Divider(
            color: Colors.teal,
          ),
          Expanded(
            child: isProscessing
                ? Container(
                    child: SpinKitCubeGrid(
                      color: Colors.teal[200],
                      size: deviceWidth / 2,
                    ),
                  )
                : EasyRefresh(
                    onRefresh: () async {
                      getJobsFromSerVER();
                    },
                    child: noJobs
                        ? Container(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Image(
                                    image:
                                        AssetImage("images/error/NoJob.png")),
                                Text(
                                  "You does not has any job",
                                  style: GoogleFonts.actor(fontSize: 30),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: jobs.length,
                            itemBuilder: (context, count) {
                              return ListTile(
                                onTap: () => {selectedJob(jobs[count])},
                                leading: Image(
                                    image: AssetImage("images/jobCase.png")),
                                title:
                                    Text(jobs[count]['RouteName'].toString()),
                                subtitle: jobs[count]['IsActive'] == 1
                                    ? Text(jobs[count]['StartTime'].toString())
                                    : Text(jobs[count]['EndTime'].toString()),
                                trailing: jobs[count]['IsActive'] == 1
                                    ? jobs[count]['IsAcsepted'] == 1
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.access_time,
                                            color: Colors.orange,
                                          )
                                    : Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                              );
                            }),
                  ),
          )
        ],
      )),
    );
  }

  getJobsFromSerVER() async {
    final prefs = await SharedPreferences.getInstance();
    int collectorID = prefs.getInt("idCollector") ?? 0;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      GetUrl getUrl = GetUrl();
      String emi = await ImeiPlugin.getImei();
      String url = getUrl.getJobs(emi, collectorID);
      HtpResponce httpReq = HtpResponce(url);
      setState(() {
        isProscessing = false;
      });
      httpReq.getData().then((value) => {
            if (value['DeviceVerified'] == 1)
              {
                if (value['hasJob'])
                  {
                    setState(() {
                      setDataToList(value['jobs']);
                      noJobs = false;
                    })
                  }
                else
                  {
                    setState(() {
                      noJobs = true;
                    })
                  }
              }
            else
              {notVerifiedDevice()}
          });
    } else {
      setState(() {
        noJobs = true;
      });
      ErrorToster("Please Check Internet Connection");
    }
  }

  setDataToList(List jobSet) {
    setState(() {
      jobs = jobSet;
    });
    SusccesToster("Data Received from Server");
  }

  selectedJob(job) async {
    setState(() {
      isProscessing = true;
    });
    if (job['IsAcsepted'] == 0) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        GetUrl getUrl = GetUrl();
        String emi = await ImeiPlugin.getImei();
        String url = getUrl.acseptJobs(emi, job['idDeductionJob']);
        HtpResponce httpReq = HtpResponce(url);
        httpReq.getData().then((value) => {
              if (value['DeviceVerified'] == 1)
                {
                  if (value['IsAcsepted'])
                    {SusccesToster("Your Job Now Accepted")}
                  else
                    {ErrorToster("Error When Accepting Job")}
                }
              else
                {notVerifiedDevice()}
            });
      } else {
        ErrorToster("Please Check Internet Connection");
      }
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("hasJob", true);
    prefs.setInt("rootID", job['Route_idRoute']);
    prefs.setString("rootName", job['RouteName']);
    prefs.setInt("JobID", job['idDeductionJob']);

    if (job['IsActive'] == 1) {
      prefs.setBool("IsActiveJob", true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => home(),
        ),
      );
    } else if (job['IsActive'] == 0) {
      prefs.setBool("IsActiveJob", true);
      ErrorToster("no active --should remove");
    } else {
      ErrorToster("Exception bouned");
    }
  }

  notVerifiedDevice() async {
    final prefs = await SharedPreferences.getInstance();
    ErrorToster("Un-Autharized Device");

    prefs.setBool("IsDeviceComform", false);
    prefs.setBool("isUserLogin", false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SpalshScreen(),
      ),
    );
  }

  checkJobISActive() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasJob = prefs.getBool("hasJob") ?? false;

    if (hasJob) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => home(),
        ),
      );
    } else {
      getJobsFromSerVER();
    }
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    SusccesToster("Log Out ....");
    deleteDB();
    prefs.setBool("IsDeviceComform", false);
    prefs.setBool("isUserLogin", false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SpalshScreen(),
      ),
    );
  }
}
