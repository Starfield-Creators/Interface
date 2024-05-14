package Components
{
   public class LabeledMeterColorConfig
   {
      
      public static const DEFAULT_NORMAL:uint = 12040119;
      
      public static const DEFAULT_DELTA_POS:uint = 6857145;
      
      public static const DEFAULT_DELTA_NEG:uint = 12794665;
      
      public static const DEFAULT_BACKGROUND:uint = 16777215;
      
      public static const WEIGHT_OVERFLOW:uint = 15146020;
      
      public static const WEIGHT_DELTA_POS:uint = 2794682;
      
      public static const WEIGHT_DELTA_NEG:uint = 4210752;
      
      public static const SHIELDED_NORMAL:uint = 9599269;
      
      public static const SHIELDED_DELTA_POS:uint = 16501539;
      
      public static const SHIELDED_DELTA_NEG:uint = 5590315;
      
      public static const CONFIG_DEFAULT_DELTA:LabeledMeterColorConfig = new LabeledMeterColorConfig(DEFAULT_NORMAL,DEFAULT_NORMAL,DEFAULT_DELTA_POS,DEFAULT_DELTA_NEG,DEFAULT_DELTA_POS,DEFAULT_NORMAL,DEFAULT_NORMAL,DEFAULT_NORMAL,DEFAULT_NORMAL,DEFAULT_NORMAL,DEFAULT_NORMAL,DEFAULT_BACKGROUND);
      
      public static const CONFIG_DEFAULT_WEIGHT:LabeledMeterColorConfig = new LabeledMeterColorConfig(DEFAULT_NORMAL,WEIGHT_OVERFLOW,WEIGHT_DELTA_POS,WEIGHT_DELTA_NEG,WEIGHT_OVERFLOW,DEFAULT_NORMAL,DEFAULT_DELTA_POS,DEFAULT_NORMAL,WEIGHT_OVERFLOW,DEFAULT_NORMAL,DEFAULT_NORMAL,DEFAULT_BACKGROUND);
      
      public static const CONFIG_SHIELDED_WEIGHT:LabeledMeterColorConfig = new LabeledMeterColorConfig(SHIELDED_NORMAL,WEIGHT_OVERFLOW,SHIELDED_DELTA_POS,SHIELDED_DELTA_NEG,WEIGHT_OVERFLOW,SHIELDED_NORMAL,SHIELDED_DELTA_POS,SHIELDED_NORMAL,WEIGHT_OVERFLOW,DEFAULT_NORMAL,DEFAULT_NORMAL,DEFAULT_BACKGROUND);
       
      
      private var fillNormal:uint;
      
      private var fillOverflow:uint;
      
      private var deltaPositive:uint;
      
      private var deltaNegative:uint;
      
      private var deltaOverflow:uint;
      
      private var currTextNormal:uint;
      
      private var currTextPositive:uint;
      
      private var currTextNegative:uint;
      
      private var currTextOverflow:uint;
      
      private var maxTextNormal:uint;
      
      private var nameTextNormal:uint;
      
      private var backgroundNormal:uint;
      
      public function LabeledMeterColorConfig(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint, param8:uint, param9:uint, param10:uint, param11:uint, param12:uint)
      {
         super();
         this.fillNormal = param1;
         this.fillOverflow = param2;
         this.deltaPositive = param3;
         this.deltaNegative = param4;
         this.deltaOverflow = param5;
         this.currTextNormal = param6;
         this.currTextPositive = param7;
         this.currTextNegative = param8;
         this.currTextOverflow = param9;
         this.maxTextNormal = param10;
         this.nameTextNormal = param11;
         this.backgroundNormal = param12;
      }
      
      public function get FillNormal() : uint
      {
         return this.fillNormal;
      }
      
      public function get FillOverflow() : uint
      {
         return this.fillOverflow;
      }
      
      public function get DeltaPositive() : uint
      {
         return this.deltaPositive;
      }
      
      public function get DeltaNegative() : uint
      {
         return this.deltaNegative;
      }
      
      public function get DeltaOverflow() : uint
      {
         return this.deltaOverflow;
      }
      
      public function get CurrTextNormal() : uint
      {
         return this.currTextNormal;
      }
      
      public function get CurrTextPositive() : uint
      {
         return this.currTextPositive;
      }
      
      public function get CurrTextNegative() : uint
      {
         return this.currTextNegative;
      }
      
      public function get CurrTextOverflow() : uint
      {
         return this.currTextOverflow;
      }
      
      public function get MaxTextNormal() : uint
      {
         return this.maxTextNormal;
      }
      
      public function get NameTextNormal() : uint
      {
         return this.nameTextNormal;
      }
      
      public function get BackgroundNormal() : uint
      {
         return this.backgroundNormal;
      }
   }
}
