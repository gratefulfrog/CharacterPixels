/////////////////////////////////////////////////////////////////////////////////////
///////////  Manual Font Horizontal Spacing Compensation  ///////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/*
 * What does it do?
 * First, this is only active if the variable 'useCompensatedWidth' is set to 'true'
 * Next, for the given font, the values that are provided BY HAND in the sections 
 * below, are added to the character's standard left/right spacing. That means that
 * the algorithmically computed spacing is NOT USED !
 *
 * How to set this up?
 * Setp 1: Be sure the user configuration variables (in main tab) are correct!
 *       : final String fontFamily
 *       : final int fntSize
 *       : final int fontIndex
 *       : If a new font is needed, contact Character Pixel Support!!!
 * Step 2: input the manual spacing values
 *       : at the end of this tab, you will see a section called
 *       : 'Spacing Compensation VALUES'
 *       : copy/paste the examples lines to create the appropriate
 *       : left and/or right compensation values for the required fonts and sizes
 *       : Note: values may be positive or negative and MUST contain a decimal point.
 * Step 3: Pray to the God of Hacking that it works!
 * Step 4: Carefully observer the results and refine any values as needed.
 */

/////////////////////////////////////////////////////////////////////////////////////
////////////////   NO-GO ZONE :  DON'T TOUCH THIS CODE !!   /////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

import java.util.HashMap;

class FontConf{
  HashMap<Character, Float>  INfR22_LEFT= new HashMap<Character, Float>(),
                             INfR22_RIGHT= new HashMap<Character, Float>(),
                             INfR220_LEFT= new HashMap<Character, Float>(),
                             INfR220_RIGHT= new HashMap<Character, Float>();

  FixedHorizontalCompensationMap fHC;

  FontConf(FixedHorizontalCompensationMap fhc, int fontIndex){
    fHC = fhc;
    INfR22_LEFT= new HashMap<Character, Float>();
    INfR22_RIGHT= new HashMap<Character, Float>();
    INfR220_LEFT= new HashMap<Character, Float>();
    INfR220_RIGHT= new HashMap<Character, Float>();
    
    init_INfR22_LEFT();
    init_INfR22_RIGHT();
    init_INfR220_LEFT();
    init_INfR220_RIGHT();
 
    initCompensation(fontIndex);
  }
  
  void initCompensation(int fontInd){
    switch(fontInd){
      case 0: // Ingeborg-New-f-Regular-22
        addCompensation(INfR22_LEFT,true);
        addCompensation(INfR22_RIGHT,false);
        break;
     case 1: // Ingeborg-New-f-Regular-22
        addCompensation(INfR220_LEFT,true);
        addCompensation(INfR220_RIGHT,false);
        break;
    }
  }
  
  void addCompensation(HashMap<Character, Float> incoming, boolean left){
    if (left){
      for (HashMap.Entry<Character, Float> entry : incoming.entrySet()) {
        fHC.putL(entry.getKey(), entry.getValue());
        println("L_Key = " + entry.getKey() + ", Value = " + entry.getValue());
      }
    }
    else{
      for (HashMap.Entry<Character, Float> entry : incoming.entrySet()) {
        fHC.putR(entry.getKey(), entry.getValue());
        println("R_Key = " + entry.getKey() + ", Value = " + entry.getValue());
      }
    }
  }

/////////////////////////////////////////////////////////////////////////////////////
////////////////             END OF NO-GO ZONE            ///////////////////////////
/////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////
////////////////      Spacing Compensation VALUES         ///////////////////////////
/////////////////////////////////////////////////////////////////////////////////////


   /* for a given character:
    *  if no value is present, then automatic compensation is used,
    *  if a value is present, then this value will be added to
    *     the standard horizontal space to the left or right of the character.
    *  Note: all values must contain a decimal point!!!
    */

  // Ingeborg-New-f-Regular-22 left compensations
  void init_INfR22_LEFT(){
    INfR22_LEFT.put('f',-1.0);
    INfR22_LEFT.put('g',-0.5);
    INfR22_LEFT.put('w',-1.5); 
    
  }
  // Ingeborg-New-f-Regular-22 right compensations
  void init_INfR22_RIGHT(){
    //INfR22_RIGHT.put('w',0.0); 
  }
  // Ingeborg-New-f-Regular-220 left compensations
  void init_INfR220_LEFT(){
    //INfR220_LEFT.put('w',0.0); 
  }
  // Ingeborg-New-f-Regular-220 right compensations
  void init_INfR220_RIGHT(){
    //INfR220_LEFT.put('w',0.0); 
  }
}