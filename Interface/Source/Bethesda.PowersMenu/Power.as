package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class Power extends MovieClip
   {
      
      public static const POWER_SELECTION_CHANGE:String = "PowerSelectionChange";
      
      public static var bFavoriting:* = false;
       
      
      public var AnimContainer_mc:MovieClip;
      
      public var ArtifactInfo_mc:MovieClip;
      
      public var Highlight_mc:MovieClip;
      
      public var Selector_mc:MovieClip;
      
      public var HighlightRect_mc:MovieClip;
      
      public var PowerName_mc:MovieClip;
      
      private const SET_ACTIVE_EVENT:String = "PowersMenu_EquipPower";
      
      private const SET_FAVORITE_EVENT:String = "PowersMenu_FavoritePower";
      
      private const UNKNOWN:uint = 0;
      
      private const DISCOVERED:uint = 1;
      
      private const UNLOCKED:uint = 2;
      
      private const INFO_BACKGROUND_X_BUFFER:* = 16;
      
      private var sName:String = "";
      
      private var sRank:String = "";
      
      private var sKey:String = "";
      
      private var uId:uint = 0;
      
      private var sDescription:String = "";
      
      private var bIsEquipped:Boolean = false;
      
      private var bIsInitalized:Boolean = false;
      
      private var uState:uint = 0;
      
      private var uCost:uint = 0;
      
      private var bSelectorShouldBeVisible:* = false;
      
      private var bPowerNameShouldBeVisible:* = false;
      
      public function Power()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.ArtifactInfo_mc.Name_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.HighlightRect_mc.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.HighlightRect_mc.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.HighlightRect_mc.addEventListener(MouseEvent.CLICK,this.onClick);
         mouseEnabled = false;
         this.PowerName_mc.visible = false;
         this.PowerName_mc.mouseChildren = false;
         this.Selector_mc.mouseChildren = false;
         this.Highlight_mc.mouseChildren = false;
         this.PowerName_mc.mouseEnabled = false;
         this.Selector_mc.mouseEnabled = false;
         this.Highlight_mc.mouseEnabled = false;
      }
      
      public function get powerName() : String
      {
         return this.sName + this.sRank;
      }
      
      public function get description() : String
      {
         return this.sDescription;
      }
      
      public function get isEquipped() : Boolean
      {
         return this.bIsEquipped;
      }
      
      public function get key() : String
      {
         return this.sKey;
      }
      
      public function get cost() : uint
      {
         return this.uCost;
      }
      
      public function get powerID() : uint
      {
         return this.uId;
      }
      
      public function setData(param1:Object) : void
      {
         this.sName = param1.sName;
         this.sRank = param1.sRank;
         this.sKey = param1.sKey;
         this.uId = param1.uId;
         this.sDescription = param1.sDescription;
         this.uCost = param1.uCost;
         if(this.bIsInitalized && this.bIsEquipped != param1.bIsEquipped)
         {
            GlobalFunc.PlayMenuSound(!!param1.bIsEquipped ? this.sKey.replace("ArtifactPower","UIMenuArtifactPowersAnimation_Select") : PowersMenu.POWER_DISABLED_SOUND);
         }
         this.bIsEquipped = param1.bIsEquipped;
         if(param1.bIsUnlocked)
         {
            this.gotoAndStop(!!param1.bIsEquipped ? "active" : "unlocked");
            this.uState = this.UNLOCKED;
         }
         else if(param1.bIsTempleKnown)
         {
            this.gotoAndStop("discovered");
            GlobalFunc.SetText(this.ArtifactInfo_mc.Name_tf,param1.sTempleName);
            this.uState = this.DISCOVERED;
         }
         else
         {
            gotoAndStop("unknown");
            this.uState = this.UNKNOWN;
         }
         if(this.PowerName_mc)
         {
            GlobalFunc.SetText(this.PowerName_mc.Name_tf,this.sName);
         }
         this.bIsInitalized = true;
      }
      
      private function onMouseOver(param1:Event) : void
      {
         if(this.uState == this.UNLOCKED)
         {
            this.ShowSelector();
            this.PowerName_mc.visible = false;
         }
      }
      
      private function ShowSelector() : *
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
         this.AnimContainer_mc.gotoAndPlay("hover");
         this.Selector_mc.gotoAndPlay("on");
         this.bSelectorShouldBeVisible = true;
         GlobalFunc.SetText(this.Selector_mc.Info_mc.Name_mc.Text_tf,this.sName + this.sRank);
         var _loc1_:* = this.Selector_mc.Info_mc.Name_mc.Text_tf.textWidth;
         this.Selector_mc.Info_mc.BG_mc.width = _loc1_ + this.INFO_BACKGROUND_X_BUFFER * 2;
         this.Selector_mc.Info_mc.BG_mc.x = -this.Selector_mc.Info_mc.BG_mc.width * 0.5;
         dispatchEvent(new CustomEvent(POWER_SELECTION_CHANGE,{"sKeyName":this.sKey},true,true));
      }
      
      private function onMouseOut(param1:Event) : void
      {
         if(this.bPowerNameShouldBeVisible)
         {
            this.PowerName_mc.visible = true;
         }
         if(this.uState == this.UNLOCKED)
         {
            this.AnimContainer_mc.gotoAndStop("idle");
            this.Selector_mc.gotoAndStop("off");
            this.bSelectorShouldBeVisible = false;
            dispatchEvent(new CustomEvent(POWER_SELECTION_CHANGE,{"sKeyName":""},true,true));
         }
      }
      
      private function onClick(param1:Event) : void
      {
         this.setActive();
      }
      
      public function setActive() : void
      {
         if(this.uState == this.UNLOCKED)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(this.SET_ACTIVE_EVENT,{"uFormID":this.uId}));
         }
      }
      
      public function setFavorite() : void
      {
         if(this.uState == this.UNLOCKED)
         {
            bFavoriting = true;
            BSUIDataManager.dispatchEvent(new CustomEvent(this.SET_FAVORITE_EVENT,{"uFormID":this.uId}));
            this.Selector_mc.gotoAndStop("off");
         }
      }
      
      public function SetReturningFromFavoritesMenu() : void
      {
         this.ShowSelector();
      }
      
      public function setNameVisible(param1:Boolean) : void
      {
         if(Boolean(this.PowerName_mc) && this.uState == this.UNLOCKED)
         {
            if(!this.bSelectorShouldBeVisible || !param1)
            {
               this.PowerName_mc.visible = param1;
            }
            this.bPowerNameShouldBeVisible = param1;
            this.PowerName_mc.mouseEnabled = false;
         }
      }
   }
}
