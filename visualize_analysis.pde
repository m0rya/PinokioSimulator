class vis_ana {

  String[] inpt;
  int[][] inpt_result;
  int inpt_count=0;
  boolean show = true;


  int[][] diff;

  vis_ana() {
  }

  void input_txtfile(int num) {
    String s = "mem_" + num + ".txt";
    inpt = loadStrings(s);

    int n=0;
    while (int (inpt[n]) != 100) {
      n++;
    }

    inpt_result = new int[n][3];

    while (true) {

      String[] inpt_angl = split(inpt[inpt_count], '/');

      //println(inpt_angl[inpt_count]);
      inpt_result[inpt_count][0] =  int(inpt_angl[0]);
      inpt_result[inpt_count][1] = int(inpt_angl[1]);
      inpt_result[inpt_count][2] = int(inpt_angl[2]);

      inpt_count++;

      if (int(inpt[inpt_count]) == 100) {
        println(inpt_count);
        inpt_count=0;
        break;
      }
    }

    println("input end(vis)" + s);
  }



  void show_input(int num) {
    if (pre != num) {
      pre = num;
      show = false;
    }

    if (!show) {
      input_txtfile(num);
      show = true;
    }

    for (int i=1; i<inpt_result.length; i++) {
      strokeWeight(1);
      stroke(255, 0, 0);
      //point(i, inpt_result[i][0]+150);
      line(i-1, inpt_result[i-1][0]+150, i,inpt_result[i][0]+150);
      
      stroke(0, 255, 0);
      //point(i, inpt_result[i][1]+350);
      line(i-1, inpt_result[i-1][1]+350, i,inpt_result[i][1]+350);
      
    }
  }


  void check_diff(int num) {

    input_txtfile(num);
    int tmp = inpt_result.length;
    diff = new int[tmp-1][3];

    for (int i=0; i<tmp-1; i++) {
      diff[i][0] = (inpt_result[i+1][0] - inpt_result[i][0])*3;
      diff[i][1] = (inpt_result[i+1][1] - inpt_result[i][1])*3;
      diff[i][2] = (inpt_result[i+1][2] - inpt_result[i][2])*3;
    }
  }


  int pre=-1;
  void show_diff(int num) {

    if (pre != num) {
      pre = num;
      show = false;
    }

    if (!show) {
      check_diff(num);
      show = true;
    }

    for (int i=0; i<diff.length; i++) {
      strokeWeight(2);
      if (diff[i][0] == 0) {
        stroke(255, 0, 0);
      } else if (abs(diff[i][0]) >0 && abs(diff[i][0]) < 10) {
        stroke(0, 255, 0);
      } else if (abs(diff[i][0]) >10 && abs(diff[i][0]) < 20) {
        stroke(0, 0, 255);
      } else {
        stroke(0);
      }
      point(i, diff[i][0]+150);


      if (abs(diff[i][1]) == 0) {
        stroke(255, 0, 0);
      } else if (abs(diff[i][1]) >0 && abs(diff[i][1]) < 10) {
        stroke(0, 255, 0);
      } else if (abs(diff[i][1]) >10 && abs(diff[i][1]) < 20) {
        stroke(0, 0, 255);
      } else {
        stroke(0);
      }


      point(i, diff[i][1]+250);
    }
  }

  int[] cor;
  void correlation_1_2(int num) {
    check_diff(num);
    cor = new int[diff.length];

    for (int i=0; i<diff.length; i++) {
      cor[i] = (diff[i][0]+diff[i][1])/2;
    }
  }


  void show_corl(int num) {
    if (pre != num) {
      pre = num;
      correlation_1_2(num);
      show = false;
    }
    if (!show) {
      for (int i=1; i<cor.length; i++) {
        strokeWeight(1);
        stroke(100, 100, 0);
        //point(i, cor[i]+150);
        line(i-1, cor[i-1]+150, i, cor[i]+150);
      }
    }
  }
}