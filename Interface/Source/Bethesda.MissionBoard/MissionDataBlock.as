package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class MissionDataBlock extends MovieClip
   {
       
      
      public var DataHeader_mc:MovieClip;
      
      public var Data0_mc:MovieClip;
      
      public var Data1_mc:MovieClip;
      
      public var Data0Large_mc:MovieClip;
      
      public function MissionDataBlock()
      {
         super();
      }
      
      public function get DataHeaderTextField() : TextField
      {
         return this.DataHeader_mc.text_tf;
      }
      
      public function get Data0TextField() : TextField
      {
         return this.Data0_mc.text_tf;
      }
      
      public function get Data1TextField() : TextField
      {
         return this.Data1_mc.text_tf;
      }
      
      public function set TextField1(param1:String) : void
      {
         GlobalFunc.SetText(this.DataHeaderTextField,param1);
         this.Truncate(this.DataHeaderTextField);
      }
      
      public function set TextField2(param1:String) : void
      {
         GlobalFunc.SetText(this.Data0TextField,param1);
         GlobalFunc.SetText(this.Data0Large_mc.text_tf,"");
         this.Truncate(this.Data0TextField);
      }
      
      public function set TextField2Large(param1:String) : void
      {
         GlobalFunc.SetText(this.Data0Large_mc.text_tf,param1);
         GlobalFunc.SetText(this.Data0_mc.text_tf,"");
      }
      
      public function set TextField3(param1:String) : void
      {
         GlobalFunc.SetText(this.Data1TextField,param1);
         this.Truncate(this.Data1TextField);
      }
      
      private function Truncate(param1:TextField) : void
      {
         var _loc2_:int = 0;
         if(param1.maxScrollH > 0)
         {
            _loc2_ = param1.getCharIndexAtPoint(param1.width,0);
            if(_loc2_ > 0)
            {
               param1.replaceText(_loc2_ - 3,param1.length,"...");
            }
         }
      }
   }
}
