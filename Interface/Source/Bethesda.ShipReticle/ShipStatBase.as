package
{
   import Components.DeltaTextValue;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ShipStatBase extends MovieClip
   {
       
      
      public var Label_tf:TextField;
      
      public var Value_mc:DeltaTextValue;
      
      private var LastName:String = "";
      
      private var LastValue:Number = NaN;
      
      private var LastDelta:Number = NaN;
      
      private var Defaulted:Boolean = false;
      
      public function ShipStatBase()
      {
         super();
      }
      
      public function SetLabel(param1:String) : *
      {
         if(this.LastName != param1)
         {
            GlobalFunc.SetText(this.Label_tf,param1);
            this.LastName = param1;
         }
      }
      
      public function SetValueAndDelta(param1:Number, param2:Number) : *
      {
         if(this.LastValue != param1)
         {
            this.Value_mc.Update(param1,param2,0);
            this.LastValue = param1;
            this.LastDelta = param2;
            this.Defaulted = false;
         }
      }
      
      public function DefaultValueAndDelta(param1:String) : *
      {
         if(!this.Defaulted)
         {
            this.Value_mc.UpdateToDefaultText(param1);
            this.LastValue = Number.NaN;
            this.LastDelta = Number.NaN;
            this.Defaulted = true;
         }
      }
   }
}
