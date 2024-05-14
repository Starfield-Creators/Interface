package LevelUpIcons
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   
   public class LevelUpIcon extends MovieClip
   {
       
      
      private var OnesA:Array;
      
      private var LastValidOnes:uint = 9;
      
      private var TensA:Array;
      
      private var HundredsA:Array;
      
      public function LevelUpIcon()
      {
         this.OnesA = ["Ones_0","Ones_1","Ones_2","Ones_3","Ones_4","Ones_5","Ones_6","Ones_7","Ones_8","Ones_9"];
         this.TensA = ["Tens_00_09","Tens_10_19","Tens_20_29","Tens_30_39","Tens_40_49","Tens_50_59","Tens_60_69","Tens_70_79","Tens_80_89","Tens_90_99"];
         this.HundredsA = ["Circle_Blue","Diamond_Blue","Polygon_Blue","Square_Blue","Triangle_Blue","Circle_Red","Diamond_Red","Polygon_Red","Square_Red","Triangle_Red","Circle_Yellow","Diamond_Yellow","Polygon_Yellow","Square_Yellow","Triangle_Yellow","Circle_Purple","Diamond_Purple","Polygon_Purple","Square_Purple","Triangle_Purple"];
         super();
      }
      
      public function Initialize(param1:uint, param2:Boolean = false, param3:Number = 1) : *
      {
         var _loc4_:uint = param1 % 10;
         param1 /= 10;
         var _loc5_:uint = param1 % 10;
         param1 /= 10;
         var _loc6_:uint = param1 % 100;
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         var _loc7_:String = String(this.HundredsA[this.HundredsA.length - 1]);
         if(_loc6_ < this.HundredsA.length)
         {
            _loc7_ = String(this.HundredsA[_loc6_]);
         }
         var _loc8_:String = String(this.TensA[_loc5_]);
         var _loc9_:String = String(this.OnesA[this.OnesA.length - 1]);
         if(_loc4_ < this.LastValidOnes)
         {
            _loc9_ = String(this.OnesA[_loc4_]);
         }
         var _loc10_:Class = getDefinitionByName(_loc7_ + (param2 ? "_Gray" : "")) as Class;
         var _loc11_:DisplayObject = null;
         (_loc11_ = this.addChild(new (_loc10_ as Class)())).scaleX = param3;
         _loc11_.scaleY = param3;
         _loc10_ = getDefinitionByName(_loc8_ + (param2 ? "_Gray" : "")) as Class;
         (_loc11_ = this.addChild(new (_loc10_ as Class)())).scaleX = param3;
         _loc11_.scaleY = param3;
         _loc10_ = getDefinitionByName(_loc9_ + (param2 ? "_Gray" : "")) as Class;
         (_loc11_ = this.addChild(new (_loc10_ as Class)())).scaleX = param3;
         _loc11_.scaleY = param3;
      }
   }
}
