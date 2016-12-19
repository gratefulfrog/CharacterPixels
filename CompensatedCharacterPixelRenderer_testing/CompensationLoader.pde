import java.io.FileNotFoundException;
import java.io.IOException;

import com.csvreader.CsvReader;

CsvReader compReader;

FixedHorizontalCompensationMap loadHorizontalCompensation(){
  FixedHorizontalCompensationMap fhcm = new FixedHorizontalCompensationMap();
  try {
    compReader = new CsvReader(dataPath("") + g_separator + g_compensationFileName);

    compReader.readHeaders();
    while (compReader.readRecord()){
      String chart = compReader.get("Character");
      String left = compReader.get("Left");
      String right = compReader.get("Right");
      char c = chart.charAt(0);
      float l = float(left),
            r = float(right);
      if (!Float.isNaN(l)){
        fhcm.putL(c,l);
      }
      if (!Float.isNaN(r)){
        fhcm.putR(c,r);
      }
    }
    compReader.close();
  }
  catch (FileNotFoundException e) {
    return fhcm;
  }
  catch (IOException e) {
    return fhcm;
  } 
  return fhcm;
}