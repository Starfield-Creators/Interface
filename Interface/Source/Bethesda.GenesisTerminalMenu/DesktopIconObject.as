package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Events.CustomEvent;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DesktopIconObject extends BSDisplayObject
   {
      
      public static const ICON_HIGHLIGHTED_EVENT:String = "Terminal_DesktopIconHighlighted";
      
      private static const ICON_STYLE_DOCUMENT:int = EnumHelper.GetEnum(1);
      
      private static const ICON_STYLE_FOLDER:int = EnumHelper.GetEnum();
      
      private static const ICON_STYLE_KIOSK:int = EnumHelper.GetEnum();
      
      private static const ICON_STYLE_CUSTOM:int = EnumHelper.GetEnum();
      
      private static const DEFAULT_FILE_NAME_FONT_SIZE:* = 20;
       
      
      public var IconName_mc:MovieClip;
      
      public var IconImage_mc:MovieClip;
      
      public var MinimizedIcon_mc:MovieClip;
      
      public var FolderType_mc:MovieClip;
      
      public var Locked_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      public var IsLocked:Boolean = false;
      
      private var _iconId:int = 0;
      
      private var _parentStackLevel:int = 0;
      
      private var Name:String = "";
      
      private var IconStyle:int = 0;
      
      public function DesktopIconObject(param1:int, param2:String = "", param3:Boolean = false, param4:int = 0, param5:int = 0)
      {
         super();
         this._iconId = param1;
         this.IsLocked = param3;
         this.ParentStackLevel = param5;
         this.Name = param2;
         this.IconStyle = param4;
         this.Dehighlight();
      }
      
      private function get ShouldTruncate() : Boolean
      {
         return false;
      }
      
      public function set FileNameTextField(param1:String) : *
      {
         if(this.ShouldTruncate)
         {
            GlobalFunc.SetTruncatedMultilineText(this.IconName_mc.Item_FileName_tx,param1);
         }
         else
         {
            GenesisTerminalShared.SetAndScaleTextfieldText(this.IconName_mc.Item_FileName_tx,param1,DEFAULT_FILE_NAME_FONT_SIZE);
         }
      }
      
      public function set IconLabelTextField(param1:String) : *
      {
         GlobalFunc.SetText(this.FolderType_mc.IconLabel_tf,param1);
      }
      
      public function set id(param1:int) : void
      {
         this._iconId = param1;
      }
      
      public function get id() : int
      {
         return this._iconId;
      }
      
      public function set ParentStackLevel(param1:int) : void
      {
         this._parentStackLevel = param1;
      }
      
      public function get ParentStackLevel() : int
      {
         return this._parentStackLevel;
      }
      
      public function set ShowMinimized(param1:Boolean) : void
      {
         this.MinimizedIcon_mc.visible = param1;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         addEventListener(MouseEvent.ROLL_OUT,this.Dehighlight);
         addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         addEventListener(MouseEvent.CLICK,this.onClick);
         this.ShowMinimized = false;
         this.Refresh();
         this.UpdateLockedArt();
      }
      
      private function UpdateLockedArt() : *
      {
         this.Locked_mc.visible = this.IsLocked;
         if(this.Locked_mc.visible)
         {
            this.Locked_mc.gotoAndStop("Locked");
         }
      }
      
      public function onRollOver() : void
      {
         GlobalFunc.PlayMenuSound("UITerminalGeneralFocus");
         dispatchEvent(new Event(ICON_HIGHLIGHTED_EVENT,true,true));
         this.Highlight();
      }
      
      public function Highlight() : void
      {
         this.Background_mc.gotoAndStop("RollOn");
      }
      
      public function Dehighlight() : void
      {
         this.Background_mc.gotoAndStop("RollOff");
      }
      
      public function onClick() : void
      {
         dispatchEvent(new CustomEvent(GenesisTerminalShared.MENU_ITEM_CLICK_EVENT,{
            "iconId":this.id,
            "parentStackLevel":this.ParentStackLevel
         },true,true));
      }
      
      private function GetLabelText(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case ICON_STYLE_DOCUMENT:
               _loc2_ = "$ICON_LABEL_DOCUMENT";
               break;
            case ICON_STYLE_FOLDER:
               _loc2_ = "$ICON_LABEL_FOLDER";
               break;
            case ICON_STYLE_CUSTOM:
               _loc2_ = "$ICON_LABEL_CUSTOM";
               break;
            case ICON_STYLE_KIOSK:
               _loc2_ = "$ICON_LABEL_KIOSK";
         }
         return _loc2_;
      }
      
      private function Refresh() : void
      {
         this.FileNameTextField = this.Name;
         this.IconImage_mc.gotoAndStop(this.IconStyle);
         this.IconLabelTextField = this.GetLabelText(this.IconStyle);
      }
      
      public function UpdateFaction(param1:String) : void
      {
         gotoAndStop(param1);
         this.Refresh();
      }
   }
}
