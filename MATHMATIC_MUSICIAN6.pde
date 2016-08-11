/*
音源データのBPM:132
KEY:F メジャー
*/

import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import processing.video.*;

Minim minim;
AudioOutput out;
AudioPlayer[] player;
AudioPlayer gol ;
 


int sx, sy; //二次元セルを管理する縦と横の長さ
float density = 0.5; //初期状態の密度
int[][][] world;//各セルを管理する配列
int b_size = 50;//円の直径
int counter = 0;
int trackCount = 14; //オーディオトラックの数
int mutePlayNUM = 0;
int playingNumber = 0;//=y/b_size

int[] Xcircle = new int[trackCount];
int[] Ycircle = new int[trackCount];



Musician mu; //シーケンサ用のクラス

void setup() { 
  size(1244, 700);
  colorMode(HSB,360,100,100,100);
  background(0);
  frameRate((335*2)/3);//30(円の直径)で1小節となるfps=16.4835   131.8868
  sx = width; //二次元セルの管理配列の横の長さ
  sy = height;//二次元セルの管理配列の縦の長さ
  
  world = new int[sx][sy][2]; //0:現在の世代を管理する配列 1:次の世代を管理する配列
  stroke(255); 
  noStroke();
  smooth();
  
  minim = new Minim(this);
  out = minim.getLineOut();  //音を鳴らす準備
  player = new AudioPlayer[trackCount];//用意した音源分のAudioPlayerインスタンスを作成
  gol = minim.loadFile("gameoflife.mp3",512);
  
  
  mu = new Musician();//シーケンサ用クラスのインスタンスを作成
  mu.setup();//soundCounterを初期化
  mu.trackSet();//player配列に音源をセット
  for (int i = 0; i < sx * sy * density; i++) { //sx*sy*densityの分だけ、生きているセルにセット
    world[(int)random(sx)][(int)random(sy)][1] = 1; 
  }
} 
 
 
 
 
void draw() { 
  background(0);
  mutePlayNUM++; //このカウンター後に音楽がmuteで流れ始める
  mu.mutePlay();//muteの状態で再生する関数

  
  counter++;//時間カウンター

  if(counter >= width){
   counter = 0;
 }
 
 mu.playCheck();
 
  for (int x = b_size; x < width; x=x + b_size) { //円ごとにループ
    for (int y = b_size; y < height; y=y + b_size) { 
      strokeWeight(2); 
      noFill();
      stroke(110,20,100,15);
      playingNumber=y/b_size;
      
     //スリット部分    
      ellipse(x, y, b_size/2, b_size/2); 
      rect(x, y, b_size/2, b_size/2); 
      rect(x, y, -(b_size/2), -(b_size/2)); 
      rect(x, y, (b_size/3)*mu.d[playingNumber], (b_size/6)*mu.d[playingNumber]);
      rect(x, y, -(b_size/3)*mu.d[playingNumber], -(b_size/6)*mu.d[playingNumber]); 
      
      
      //各トラックのHP
      if(mu.d[playingNumber] != 0){    
      noStroke();
      fill(0,100,100,2.5);
      text("Playing..."+ (15-abs(mu.soundCounter[playingNumber])),5,playingNumber*b_size-5);
      rect(0,playingNumber*b_size,(mu.soundCounter[playingNumber]+5)*8,15);
      }else{
        noStroke();
        fill(210,100,100,2.5);
        text("Waiting..."+ abs(mu.soundCounter[playingNumber]),5,playingNumber*b_size-5);
        noStroke();
        fill(210,100,100,2.5);
        rect(0,playingNumber*b_size,(mu.soundCounter[playingNumber]+5)*8,15);
      }
      
     
     
     
     //セルの生死を描画
      
      if ((world[x][y][1] == 1) || (world[x][y][1] == 0 && world[x][y][0] == 1)) { 
        world[x][y][0] = 1; 
        int r = y/b_size;
        strokeWeight(3); 
        if(r <6){
          stroke(220,100,100,50);
        }else if(6<=r&&r<9){
          stroke(182,100,100,40);
        }else{
          stroke(160,100,80,40);
        }
        noFill();
        ellipse(x, y, b_size/1.7, b_size/1.7);//生きている円を描画
        playingNumber = y/b_size;
        //5重円でビジュアライズ
        for(int i =0;i<3;i++){
         strokeWeight(1.5); 
          ellipse(x, y, (b_size/2)+random(i,5)*(mu.d[playingNumber]), (b_size/2)+random(i,5)*(mu.d[playingNumber]));//音に反応している部分
         //  ellipse(x, y,((b_size+i)/2)*mu.d[playingNumber], ((b_size+i)/2)*mu.d[playingNumber]);//音に反応している部分
           
       
        }
        
        
        

      } 
      if (world[x][y][1] == -1){ 
        world[x][y][0] = 0; 
        
 
      } 
      world[x][y][1] = 0; 
    } 
  }
 
  
  //各セルの生死判定
  if(counter == 0 || counter == width/2 || counter == width/4 || counter == 3*width/4){
    background(255);
  for (int x = 0; x < width; x=x+b_size) { 
    for (int y = 0; y < height; y=y+b_size) { 
      int count = neighbors(x, y); //周囲の生死状態をカウント
      if (count == 3 && world[x][y][0] == 0) { //もし自分が死んでいて、周囲のセルが3つ以上生きていたら
        world[x][y][1] = 1; //復活する
      } 
      if ((count < 2 || count > 3) && world[x][y][0] == 1) {//もし自分が生きていて、周囲のセルが1個以下or4個以上の場合 
        world[x][y][1] = -1; //自分は死ぬ
      } 
    } 
  }
 }

  mu.draw();
    mu.drawCircle();
} 

 

int neighbors(int x, int y) 
{ 
  return world[(x + b_size) % sx][y][0] + 
         world[x][(y + b_size) % sy][0] + 
         world[(x + sx - b_size) % sx][y][0] + 
         world[x][(y + sy - b_size) % sy][0] + 
         world[(x + b_size) % sx][(y + b_size) % sy][0] + 
         world[(x + sx - b_size) % sx][(y + b_size) % sy][0] + 
         world[(x + sx - b_size) % sx][(y + sy - b_size) % sy][0] + 
         world[(x + b_size) % sx][(y + sy - b_size) % sy][0]; 
} 



//リセット
void mousePressed(){
 for (int x = b_size; x < width; x=x + b_size) { //円ごとにループ
    for (int y = b_size; y < height; y=y + b_size) { 
      world[x][y][0] = 0;
      world[x][y][1] = 0; 
    }
  } 
   for (int i = 0; i < sx * sy * density; i++) { //sx*sy*densityの分だけ、生きているセルにセット
    world[(int)random(sx)][(int)random(sy)][1] = 1; 
  } 
}

void keyPressed(){
  if( key == TAB){
    gol.play();
    gol.rewind();
  }
  
}

//停止の処理
void stop() {
  for(int i = 0;i<trackCount;i++){
  player[i].close();
  minim.stop();
  super.stop();
  }
}