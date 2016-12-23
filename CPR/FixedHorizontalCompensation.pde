import java.util.HashMap;

class FixedHorizontalCompensation{
  boolean compensateLeft = false,
          compensateRight = false;
  float leftCompensation,
        rightCompensation;

   void putL(float l){
     leftCompensation  = l;
     compensateLeft = true;
   }
   void putR(float r){
     rightCompensation  = r;
     compensateRight = true;
   }
   
   void putB(float l, float r){
     leftCompensation  = l;
     rightCompensation = r;
     compensateLeft = true;
     compensateRight = true;
   }
}

class FixedHorizontalCompensationMap{
  HashMap<Character, FixedHorizontalCompensation> hm;
  
  FixedHorizontalCompensationMap(){
    hm = new HashMap<Character, FixedHorizontalCompensation>();
  }
  
  FixedHorizontalCompensation get(char c){
    return hm.get(c);
  }
  int size(){
    return hm.size();
  }
  
  void putB(char c, float l, float r){
    FixedHorizontalCompensation fhc = new FixedHorizontalCompensation();
    fhc.putB(l,r);
    hm.put(c,fhc);
  }
  void putL(char c, float v){    
    putA(c,v,true);
  }
  void putR(char c, float v){    
    putA(c,v,false);
  }
  void putA(char c, float v, boolean left){    
    FixedHorizontalCompensation fhc = find(c);
    if (left){
      fhc.putL(v);
    }
    else{
      fhc.putR(v);
    }
  } 
  FixedHorizontalCompensation find(char c){
    FixedHorizontalCompensation fhc = hm.get(c);
    if (fhc == null){
      fhc = new FixedHorizontalCompensation();
    }
    hm.put(c,fhc);
    return fhc;
  }
}


  