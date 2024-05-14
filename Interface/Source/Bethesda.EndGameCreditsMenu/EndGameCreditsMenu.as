package
{
   import Components.SWFLoaderClip;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.IMenu;
   import Shared.GlobalFunc;
   import flash.display.DisplayObject;
   
   public class EndGameCreditsMenu extends IMenu
   {
       
      
      public var CreditsLoader_mc:SWFLoaderClip;
      
      private var AllowClose:Boolean = false;
      
      private var IsClosing:Boolean = false;
      
      private var CreditsSWFName:String = "CreditsMenu";
      
      public function EndGameCreditsMenu()
      {
         super();
         BSUIDataManager.Subscribe("CreditsMenuData",this.onCreditsDataLoaded);
         BSUIDataManager.Subscribe("FireForgetEventData",this.onFireForgetEvent);
      }
      
      private function get creditsMenu() : CreditsMenu
      {
         return this.CreditsLoader_mc.content != null ? this.CreditsLoader_mc.content["Menu_mc"] as CreditsMenu : null;
      }
      
      private function onCreditsDataLoaded() : void
      {
         this.CreditsLoader_mc.SWFLoad(this.CreditsSWFName,this.onCreditsSWFLoaded);
      }
      
      private function onCreditsSWFLoaded(param1:DisplayObject) : void
      {
         if(this.creditsMenu != null)
         {
            this.creditsMenu.buttonVisible = false;
         }
         gotoAndPlay("fadeIn");
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.AllowClose && !this.IsClosing && param1 == "Cancel" && !param2)
         {
            gotoAndPlay("fadeOut");
            this.IsClosing = true;
            _loc3_ = true;
         }
         else if(this.creditsMenu != null)
         {
            _loc3_ = this.creditsMenu.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function onFireForgetEvent(param1:FromClientDataEvent) : void
      {
         if(this.creditsMenu != null && GlobalFunc.HasFireForgetEvent(param1.data,"EndGameCredits_AllowMenuClose"))
         {
            this.AllowClose = true;
            this.creditsMenu.buttonVisible = true;
         }
      }
      
      public function onFadeOutAnimComplete() : void
      {
         GlobalFunc.CloseMenu("EndGameCreditsMenu");
      }
   }
}
