package
{
   import Components.DisplayList;
   import Components.ModularPanelObject;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ProjectCompletePopup extends ModularPanelObject implements IResearchComponent
   {
      
      public static const CLOSE_COMPLETE:String = "CloseComplete";
       
      
      public var Header_mc:MovieClip;
      
      public var NewIcon_mc:MovieClip;
      
      public var Completed_mc:MovieClip;
      
      public var Line1_mc:MovieClip;
      
      public var UnlockedText_mc:MovieClip;
      
      public var ListHolder_mc:MovieClip;
      
      public var Line2_mc:MovieClip;
      
      public var ButtonSection_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      public var Blur_mc:MovieClip;
      
      private const BACKGROUND_PADDING_LRG:Number = 30;
      
      public function ProjectCompletePopup()
      {
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.ButtonSection_mc.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,ResearchUtils.BUTTON_SPACING);
         this.ButtonSection_mc.ButtonBar_mc.ButtonBarColor = ResearchMenu.BUTTON_COLOR;
         ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$OK",new UserEventData("Accept",this.OnAccept)),this.ButtonSection_mc.ButtonBar_mc);
         this.ButtonSection_mc.ButtonBar_mc.RefreshButtons();
         addEventListener("OpenBackground",this.SetBackground);
         addEventListener("NextAnimation",PlayNextAnimation);
         addEventListener(CLOSE_COMPLETE,this.CloseComplete);
         this.UnlockedList_mc.Configure(ProjectName_Entry,ResearchUtils.TREE_COLUMNS,ResearchUtils.TREE_ROWS,ResearchUtils.TREE_COLUMNS_SPACING,ResearchUtils.TREE_ROWS_SPACING,0,10);
      }
      
      public function get ProjectCompleted_mc() : MovieClip
      {
         return this.Completed_mc.ProjectCompleted_mc;
      }
      
      public function get UnlockedList_mc() : DisplayList
      {
         return this.ListHolder_mc.UnlockedList_mc;
      }
      
      public function UpdateData(param1:Object) : void
      {
         GlobalFunc.SetText(this.ProjectCompleted_mc.Text_tf,"$Research_ProjectCompleted",false,false,0,false,0,new Array(param1.sName));
         this.UnlockedList_mc.entryData = param1.aUnlockedProjects;
         if(this.UnlockedList_mc.entryCount > 0)
         {
            this.ButtonSection_mc.y = this.ListHolder_mc.y + this.ListHolder_mc.height;
         }
         else
         {
            this.ButtonSection_mc.y = this.Completed_mc.y + this.Completed_mc.height;
         }
         this.Line2_mc.y = this.ButtonSection_mc.y;
      }
      
      public function Open() : void
      {
         this.mouseChildren = true;
         this.mouseEnabled = true;
         AddToInfoPanelArray(this.Header_mc);
         AddToInfoPanelArray(this.NewIcon_mc);
         AddToInfoPanelArray(this.Completed_mc);
         AddToInfoPanelArray(this.Line1_mc);
         if(this.UnlockedList_mc.entryCount > 0)
         {
            AddToInfoPanelArray(this.UnlockedText_mc);
            AddToInfoPanelArray(this.ListHolder_mc);
            AddToInfoPanelArray(this.Line2_mc);
         }
         AddToInfoPanelArray(this.ButtonSection_mc);
         GlobalFunc.PlayMenuSound(ResearchUtils.PROJECT_COMPLETE_SOUND);
         this.gotoAndPlay(ResearchUtils.OPEN_FRAME_LABEL);
      }
      
      private function SetBackground() : *
      {
         OpenBackgroundAnimation(this.Background_mc);
      }
      
      public function Close() : void
      {
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.gotoAndPlay(ResearchUtils.CLOSE_FRAME_LABEL);
      }
      
      public function CloseComplete() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < InfoPanelArray.length)
         {
            InfoPanelArray[_loc1_].gotoAndPlay(ResearchUtils.CLOSE_FRAME_LABEL);
            _loc1_++;
         }
         OnClose(this.Background_mc);
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.ButtonSection_mc.ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      private function OnAccept() : void
      {
         dispatchEvent(new Event(ResearchUtils.CLOSE_POPUP,true,true));
      }
   }
}
