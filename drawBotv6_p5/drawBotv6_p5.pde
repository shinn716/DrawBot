// Author: Shinn
// 2017/11/14
// Send to character each Point to Drawbot.
// You can change WriteDelay, but more fast, it's could miss data.
// Character Search http://linguistics.berkeley.edu/~rscook/cgi/zunihan.html

import geomerative.*;
import processing.serial.*;

Serial myPort;
boolean sendtoArd=false;

float xmag, ymag, newYmag, newXmag = 0;
String FilePath="data/kanji/";
boolean ignoringStyles = false;

float wid_min=3;      //0
float wid_max=70;     //70
float hei_min=60;      //60
float hei_max=20;      //20

ArrayList<String> pathv2 = new ArrayList<String>();

int z = 0;
boolean drawst=false;
float count=0;
float WriteDelay=8;            //8-20


//----20171102_東真
ArrayList<RShape> grp = new ArrayList<RShape>();
ArrayList<RPoint[][]> pointPaths = new ArrayList<RPoint[][]>();
int StringNumber=3;                                       //幾個文字
float offsetx = pow(1.0, StringNumber);                   // SonicSgner pow(1.8, StringNumber)                             
float offsety = pow(1.0, StringNumber);                   // SonicSgner pow(1.4, StringNumber)             

void setup()
{
  size(700, 400);
  background(220);

  noStroke();
  ellipse(width/2, height/2+200, 700, 700);

  RG.init(this);
  RG.ignoreStyles(ignoringStyles);
  RG.setPolygonizer(RG.ADAPTATIVE);

  //----20171102_東真
  //for (int i=0; i<StringNumber; i++)
  //{
  //  grp.add( RG.loadShape(FilePath + "....svg") );
  //  grp.get(i).centerIn(g, 100, 1, 1);
  //  pointPaths.add( grp.get(i).getPointsInPaths() );
  //}

  
  grp.add( RG.loadShape(FilePath + "08521.svg") );
  grp.get(0).centerIn(g, 100, 1, 1);
  pointPaths.add( grp.get(0).getPointsInPaths() );

  grp.add( RG.loadShape(FilePath + "06771.svg") );
  grp.get(1).centerIn(g, 100, 1, 1);
  pointPaths.add( grp.get(1).getPointsInPaths() );

  grp.add( RG.loadShape(FilePath + "0771f.svg") );
  grp.get(2).centerIn(g, 100, 1, 1);
  pointPaths.add( grp.get(2).getPointsInPaths() );

  grp.add( RG.loadShape(FilePath + "09999.svg") );
  grp.get(3).centerIn(g, 100, 1, 1);
  pointPaths.add( grp.get(3).getPointsInPaths() );

  grp.add( RG.loadShape(FilePath + "09999.svg") );
  grp.get(4).centerIn(g, 100, 1, 1);
  pointPaths.add( grp.get(4).getPointsInPaths() );

  grp.add( RG.loadShape(FilePath + "_f.svg") );
  grp.get(5).centerIn(g, 100, 1, 1);
  pointPaths.add( grp.get(5).getPointsInPaths() );
  
   grp.add( RG.loadShape(FilePath + "_g.svg") );
  grp.get(6).centerIn(g, 100, 1, 1);
  pointPaths.add( grp.get(6).getPointsInPaths() );
  
   grp.add( RG.loadShape(FilePath + "_h.svg") );
  grp.get(7).centerIn(g, 100, 1, 1);
  pointPaths.add( grp.get(7).getPointsInPaths() ); 
  
    grp.add( RG.loadShape(FilePath + "_j.svg") );
  grp.get(8).centerIn(g, 100, 1, 1);
  pointPaths.add( grp.get(8).getPointsInPaths() );
  
    grp.add( RG.loadShape(FilePath + "_k.svg") );
  grp.get(9).centerIn(g, 100, 1, 1);
  pointPaths.add( grp.get(9).getPointsInPaths() );
  
  
  if (sendtoArd)
  {
    printArray(Serial.list());
    myPort = new Serial(this, Serial.list()[0], 9600);
  }

  for (int i=0; i<StringNumber; i++)
  {
    PVector ChatacterPos = new PVector( (i+1)*width/(StringNumber+1)*offsetx, height/5+200*(offsety) );
    CharacterProcess(pointPaths.get(i), ChatacterPos);
  }
  ellipseMode(CORNER);
  
}

void draw()
{
  
  //----Send To Arduino
  if (frameCount%WriteDelay==0 && !drawst)
  {
    count++;

    if (count>30)
    {
      if (sendtoArd) 
      {
        println(z+" "+ pathv2.get(z) );
        myPort.write(pathv2.get(z));
        myPort.write('\n');

        if (z>=pathv2.size()-1 )
        {
          z=pathv2.size()-1 ;
          drawst=true;
          count=0;
        } else 
        {
          z++;
        }
      }
    }
  }
}

//----20171102_東真
String Encode(float tmpx, float tmpy, int dn, PVector targetPos, float offset) 
{
  // SVG x,y座標 存成同一組 String
  // 12.3 4.56 0 (前三碼x座標, 後三碼y座標, 最後1碼 0抬起, 1放下)

  float sax = (tmpx + targetPos.x)/offset ;
  float say = (tmpy + targetPos.y)/offset ;
  float mapDataPx = map(sax, 0, width, wid_min, wid_max);
  float mapDataPy = map(say, 0, height, hei_min, hei_max);
  String t1 = nf( mapDataPx, 2, 1);
  String t2 = nf( mapDataPy, 2, 1);
  String sendData = t1+""+t2+""+dn;

  return sendData;
}

void keyPressed()
{
  //----Redraw
  if (key==' ')
  {
    println("sp");
    z=0;
    drawst=false;
  }
}


//----20171102_東真
void CharacterProcess(RPoint[][] pathData, PVector targetPos) 
{
  stroke(0);
  noFill();

  for (int i = 0; i<pathData.length; i++) {        //pointPaths.length

    if (pathData[i] != null) {

      fill(255, 0, 0);
      strokeWeight(1/offsetx);
      ellipse( (pathData[i][0].x + targetPos.x)/offsetx, (pathData[i][0].y + targetPos.y)/offsetx, 10/offsetx, 10/offsetx);             //Start Point 
      pathv2.add( Encode(pathData[i][0].x, pathData[i][0].y, 0, targetPos, offsetx) );

      noFill();
      beginShape();
      for (int j = 0; j<pathData[i].length; j++) {
        strokeWeight(2/offsetx);
        vertex( (pathData[i][j].x + targetPos.x)/offsetx, (pathData[i][j].y + targetPos.y)/offsetx );
        pathv2.add( Encode(pathData[i][j].x, pathData[i][j].y, 1, targetPos, offsetx) );
      }
      endShape();

      fill(0, 255, 0);
      strokeWeight(1/offsetx);
      ellipse( (pathData[i][pathData[i].length-1].x + targetPos.x)/offsetx, (pathData[i][pathData[i].length-1].y + targetPos.y)/offsetx, 10/offsetx, 10/offsetx);       //End Point
      pathv2.add( Encode(pathData[i][pathData[i].length-1].x, pathData[i][pathData[i].length-1].y, 0, targetPos, offsetx) );
      noFill();
    }
  }
}