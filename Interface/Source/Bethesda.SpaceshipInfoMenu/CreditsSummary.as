package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class CreditsSummary extends BSDisplayObject
   {
      
      private static const CREDITS_NORMAL:String = "Normal";
      
      private static const CREDITS_RED:String = "Red";
      
      private static const CREDITS_BLUE:String = "Blue";
       
      
      public var VendorLabel_mc:MovieClip;
      
      public var VendorCredits_mc:MovieClip;
      
      public var PlayerLabel_mc:MovieClip;
      
      public var PlayerCredits_mc:MovieClip;
      
      public function CreditsSummary()
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
      
      private function get VendorCreditsText() : TextField
      {
         return this.VendorCredits_mc.Text_mc.text_tf;
      }
      
      private function get PlayerCreditsText() : TextField
      {
         return this.PlayerCredits_mc.Text_mc.text_tf;
      }
      
      override public function onAddedToStage() : void
      {
         BSUIDataManager.Subscribe("ShipMenuCreditsSummary",this.UpdateValues);
      }
      
      public function UpdateValues(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         GlobalFunc.SetText(this.VendorCreditsText,GlobalFunc.FormatNumberToString(_loc2_.uVendorCredits));
         GlobalFunc.SetText(this.PlayerCreditsText,GlobalFunc.FormatNumberToString(_loc2_.uPlayerCredits));
         GlobalFunc.SetText(this.PlayerLabelText,_loc2_.sPlayerName);
      }
   }
}
