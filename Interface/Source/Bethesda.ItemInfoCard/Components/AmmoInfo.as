package Components
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class AmmoInfo extends MovieClip
   {
       
      
      public var AmmoType_mc:MovieClip;
      
      public var AmmoCount_mc:DeltaTextValue;
      
      public function AmmoInfo()
      {
         super();
      }
      
      private function get AmmoName_tf() : TextField
      {
         return this.AmmoType_mc.Name_tf;
      }
      
      private function get AmmoIcon_mc() : MovieClip
      {
         return this.AmmoType_mc.Icon_mc;
      }
      
      public function Update(param1:String, param2:uint) : void
      {
         GlobalFunc.SetText(this.AmmoName_tf,param1);
         this.AmmoIcon_mc.gotoAndStop(param1);
         this.AmmoCount_mc.Update(param2);
      }
   }
}
