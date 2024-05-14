package
{
   import Components.ModularPanelObject;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class SuddenDevelopmentPopup extends ModularPanelObject implements IResearchComponent
   {
      
      public static const CLOSE_COMPLETE:String = "CloseComplete";
       
      
      public var HeaderSection_mc:MovieClip;
      
      public var InputSection_mc:MovieClip;
      
      public var Line1_mc:MovieClip;
      
      public var AmountsSection_mc:MovieClip;
      
      public var Line2_mc:MovieClip;
      
      public var DetailsSection_mc:MovieClip;
      
      public var Line3_mc:MovieClip;
      
      public var ButtonSection_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      public var Blur_mc:MovieClip;
      
      private const AMOUNT_PADDING:Number = 20;
      
      public function SuddenDevelopmentPopup()
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
         this.AmountsSection_mc.OverflowList_mc.Configure(SuddenDevelopment_Entry,1,ResearchUtils.MAX_MATERIALS,0,ResearchUtils.MATERIAL_LIST_SPACING,0,this.AMOUNT_PADDING);
         this.AmountsSection_mc.RemainingList_mc.Configure(SuddenDevelopment_Entry,1,ResearchUtils.MAX_MATERIALS,0,ResearchUtils.MATERIAL_LIST_SPACING,0,this.AMOUNT_PADDING);
      }
      
      public function UpdateData(param1:Object) : void
      {
         GlobalFunc.SetText(this.InputSection_mc.Input_mc.Name_mc.Text_tf,param1.contributedItem.sName);
         GlobalFunc.SetText(this.InputSection_mc.Input_mc.Amount_mc.Text_tf,"$$Input: " + param1.contributedItem.uCountAdded);
         this.AmountsSection_mc.OverflowList_mc.entryData = param1.aOverflowedItems;
         this.AmountsSection_mc.RemainingList_mc.entryData = param1.aRemainingItems;
         this.Line2_mc.y = this.AmountsSection_mc.y + this.AmountsSection_mc.height;
         this.DetailsSection_mc.y = this.Line2_mc.y + 1;
         this.Line3_mc.y = this.DetailsSection_mc.y + this.DetailsSection_mc.height;
         this.ButtonSection_mc.y = this.Line3_mc.y + 1;
      }
      
      public function Open() : void
      {
         this.mouseChildren = true;
         this.mouseEnabled = true;
         AddToInfoPanelArray(this.HeaderSection_mc);
         AddToInfoPanelArray(this.InputSection_mc);
         AddToInfoPanelArray(this.Line1_mc);
         AddToInfoPanelArray(this.AmountsSection_mc);
         AddToInfoPanelArray(this.Line2_mc);
         AddToInfoPanelArray(this.DetailsSection_mc);
         AddToInfoPanelArray(this.Line3_mc);
         AddToInfoPanelArray(this.ButtonSection_mc);
         GlobalFunc.PlayMenuSound(ResearchUtils.SUDDEN_DEV_SOUND);
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
