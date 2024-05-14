package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class FolderView extends MovieClip
   {
      
      public static const CLOSE_CLICK_EVENT:String = "FolderView::closeClickEvent";
      
      private static const DEFAULT_FILE_NAME_FONT_SIZE:* = 30;
       
      
      public var HeaderText_mc:MovieClip;
      
      public var FolderIconHolder_mc:DesktopIconHolder;
      
      public var PopupCloseBtn_mc:MovieClip;
      
      public function FolderView()
      {
         super();
         this.PopupCloseBtn_mc.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function set headerText(param1:String) : void
      {
         name = param1;
         GenesisTerminalShared.SetAndScaleTextfieldText(this.HeaderText_mc.text_tf,param1,DEFAULT_FILE_NAME_FONT_SIZE);
      }
      
      public function SetFocus() : void
      {
         stage.focus = this.FolderIconHolder_mc;
      }
      
      public function get HasFocus() : Boolean
      {
         return stage.focus == this.FolderIconHolder_mc;
      }
      
      public function onClick() : void
      {
         dispatchEvent(new Event(CLOSE_CLICK_EVENT,true,true));
      }
      
      public function ProcessUserEvent(param1:*, param2:*) : Boolean
      {
         return this.FolderIconHolder_mc.ProcessUserEvent(param1,param2);
      }
      
      public function UpdateFaction(param1:String) : void
      {
         gotoAndStop(param1);
         this.FolderIconHolder_mc.Faction = param1;
      }
      
      public function Refresh(param1:Array, param2:Boolean = false) : *
      {
         this.FolderIconHolder_mc.InitializeDesktopIcons(param1,param2);
      }
   }
}
