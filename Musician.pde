//音源管理用のクラス
class Musician{
  int x = 0;
  int clr = 0; 
  int[] soundCounter = new int[trackCount];
  int number = 0;
  int stopCount = 5;
  int playingCount =0; //このカウンター数の音源が再生中
  
  int[] r = new int[trackCount]; //直径
  
  float[] d = new float[trackCount];
  
 void setup(){
   for(int i = 0;i<trackCount;i++){
     soundCounter[i] = -5;    //0:音源流れる,1:音源ストップ
     Xcircle [i]=0;
     Ycircle[i]=0; 
     r[i]=0;
   }
 }
 void trackSet(){
   for(int i =0;i<trackCount;i++) {
    switch(i){
      case 0:
      player[i] = minim.loadFile("Main_Drums.mp3",512); 
      break;
      case 1:
      player[i] = minim.loadFile("Drums1.mp3",512);
      break;
      case 2:
      player[i] = minim.loadFile("Drums2.mp3",512); 
      break;
      case 3:
      player[i] = minim.loadFile("Drums3.mp3",512); 
      break;
      case 4:
      player[i] = minim.loadFile("Drums4.mp3",512); 
      break;
      case 5:
      player[i] = minim.loadFile("Drums5.mp3",512);
      break;
      case 6:
      player[i] = minim.loadFile("Bass1.mp3",512);
      break;
      case 7:
      player[i] = minim.loadFile("Bass2.mp3",512);
      break;
      case 8:
      player[i] = minim.loadFile("Bass3.mp3",512); 
      break;
      case 9:
      player[i] = minim.loadFile("Lead1.mp3",512); 
      break;
      case 10:
      player[i] = minim.loadFile("Lead2.mp3",512); 
      break;
      case 11:
      player[i] = minim.loadFile("Lead3.mp3",512); 
      break;
      case 12:
      player[i] = minim.loadFile("Lead4.mp3",256); 
      break;
      case 13:
      player[i] = minim.loadFile("Lead5.mp3",512); 
      break;
      default:
      break;
      
    }
  }
 }
 void mutePlay(){
   if(mutePlayNUM ==80){
     for(int i = 0;i<14;i++){
       player[i].play();
       player[i].mute();
     }
   }
   
 }
 
  void draw(){ 
    pushMatrix();
    translate(counter,0);//lineをcounter++ごとに移動
    stroke(0,0,100,100);
    line(0,0,0,height);
    popMatrix();
    
    if((counter % b_size )== 0){//xが円の中心にきたら
      x = counter;
     /// pushMatrix();
      for (int y = b_size; y < height; y=y+b_size){
         if ((world[x][y][1] == 1) || (world[x][y][1] == 0 && world[x][y][0] == 1)) {
           number = y / b_size; //セルの番号に対応
  
          switch(number){
            case 0:
             soundPlay();
             break;
            case 1:
             soundPlay();
             break;
            case 2:
             soundPlay();
             break;
            case 3:
            soundPlay();
             break;
            case 4:
            soundPlay();
             break;
            case 5:
             soundPlay();
             break;
            case 6:
             soundPlay();
             break;
            case 7:
             soundPlay();
             break;
            case 8:
             soundPlay();
             break;
            case 9:
             soundPlay();
             break;
            case 10:
             soundPlay();
             break;
            case 11:
            soundPlay();
             break;
            case 12:
             soundPlay(); 
             break;
            case 13:
             soundPlay();
             break;
            default:
             break;
          }
         }
      }
       //popMatrix();
    }
    //stroke(0,0,100,100);
    //line(0,0,0,height);
    //popMatrix();
    
  }
  
  void soundPlay(){    
    if(soundCounter[number] == 0){//各セル番号(number)のカウンターが0だったら音源を再生
      player[number].unmute();
      soundCounter[number] ++;
      


      if(playingCount>=5){//再生トラック数が5以上だったら
        player[number].mute();
        soundCounter[number] = -1;//カウンターを1戻す
      
      }else{
         playingCount++;
         Xcircle[number]=x;
         Ycircle[number]=number*b_size;
         r[number] =int(random(2,6));
      }
      
    }else if(soundCounter[number]==stopCount){  //カウンターがstopCountだったら音源を停止
      player[number].mute();//音停止
      soundCounter[number] = -5;//カウント初期化
      playingCount--;
      Xcircle[number]=0;
      Ycircle[number]=0;
    
    }else{
      soundCounter[number]++;
    }
        
  }
  
  void drawCircle(){
    for(int i =0;i<trackCount;i++){
      if(Xcircle[i] != 0 && Ycircle[i] != 0){
        strokeWeight(1); 
        if(i <6){
          stroke(220,100,100,40);
          fill(220,100,100,2);
          
        }else if(6<=i&&i<9){
          stroke(182,100,100,30);
          fill(182,100,100,2);
        }else{
          stroke(160,100,80,30);
          fill(160,100,80,2);
        }
        
       //鳴り始めた円
        
        for(int j = 0;j<4;j++){
          ellipse(Xcircle[i],Ycircle[i], b_size*r[i]+random(j,20), b_size*r[i]+random(j,20));
          ellipse(Xcircle[i],Ycircle[i], (b_size*r[i]+random(j,10))*(d[i]/4), (b_size*r[i]+random(j,10))*d[i]/4);
        }
        
        //アクセントの赤い円
        for(int j = 0;j<3;j++){
          stroke(0,100,70,20);
          strokeWeight(4);
          ellipse(Xcircle[i],Ycircle[i], b_size*r[i]+random(j,20), b_size*r[i]+random(j,20));
        } 
    }
    }
  }
  
  
 
 
  void playCheck(){
    for(int i = 0; i <trackCount ; i++){
     d[i] = player[i].mix.level() * 15; //音のレベルに応じた直径で
     if(player[i].isMuted()){//もしmute状態だったら
       d[i]=0;//円のエフェクトはしない
     }
    }
  }
  

  
  
  
 
}