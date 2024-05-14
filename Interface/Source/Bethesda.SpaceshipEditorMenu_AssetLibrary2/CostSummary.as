package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class CostSummary extends BSDisplayObject
   {
      
      public static const X_OFFSET_PADDING:int = 25;
      
      private static const CREDITS_NORMAL:String = "Normal";
      
      private static const CREDITS_RED:String = "Red";
      
      private static const CREDITS_BLUE:String = "Blue";
       
      
      public var VendorLabel_mc:MovieClip;
      
      public var VendorCredits_mc:MovieClip;
      
      public var PlayerLabel_mc:MovieClip;
      
      public var PlayerCredits_mc:MovieClip;
      
      public var TotalLabel_mc:MovieClip;
      
      public var TotalCredits_mc:MovieClip;
      
      private var OriginalX:int = 0;
      
      public function CostSummary()
      {
         super();
      }
      
      private function get VendorLabelText() : TextField
      {
         return this.VendorLabel_mc.text_tf;
      }
      
      private function get PlayerLabelText() : TextField
      {
         return this.PlayerLabel_mc.text_tf;
      }
      
      private function get TotalLabelText() : TextField
      {
         return this.TotalLabel_mc.text_tf;
      }
      
      private function get VendorCreditsText() : TextField
      {
         return this.VendorCredits_mc.Text_mc.text_tf;
      }
      
      private function get PlayerCreditsText() : TextField
      {
         return this.PlayerCredits_mc.Text_mc.text_tf;
      }
      
      private function get TotalCreditsText() : TextField
      {
         return this.TotalCredits_mc.Text_mc.text_tf;
      }
      
      public function set TotalCreditsVisible(param1:Boolean) : void
      {
         this.TotalLabel_mc.visible = param1;
         this.TotalCredits_mc.visible = param1;
      }
      
      override public function onAddedToStage() : void
      {
         this.OriginalX = x;
         BSUIDataManager.Subscribe("CostSummaryData",this.UpdateValues);
      }
      
      public function SetOffsetX(param1:Number) : void
      {
         var _loc2_:Number = param1 > 0 ? param1 + X_OFFSET_PADDING : 0;
         x = this.OriginalX - _loc2_;
      }
      
      public function UpdateValues(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         GlobalFunc.SetText(this.VendorCreditsText,GlobalFunc.FormatNumberToString(_loc2_.uVendorCredits));
         GlobalFunc.SetText(this.PlayerCreditsText,GlobalFunc.FormatNumberToString(_loc2_.uPlayerCredits));
         GlobalFunc.SetText(this.TotalCreditsText,GlobalFunc.FormatNumberToString(_loc2_.uTotalCredits));
         if(_loc2_.uTotalCredits == 0)
         {
            this.TotalCredits_mc.gotoAndStop(CREDITS_NORMAL);
         }
         else if(_loc2_.bBuying)
         {
            this.TotalCredits_mc.gotoAndStop(CREDITS_RED);
         }
         else
         {
            this.TotalCredits_mc.gotoAndStop(CREDITS_BLUE);
         }
      }
   }
}
