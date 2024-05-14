package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class LandingEntry extends MovieClip
   {
      
      public static const SELECTED_CLOSE:String = "SelectedClose";
       
      
      public var EntryIcon_mc:MovieClip;
      
      public var AvailableProjectNum_mc:MovieClip;
      
      public var AvailableProjectText_mc:MovieClip;
      
      public var MainEntryText_mc:MovieClip;
      
      public var NewIcon_mc:MovieClip;
      
      private var _hasNew:Boolean = false;
      
      public function LandingEntry()
      {
         super();
         GlobalFunc.SetText(this.AvailableProjectText_mc.Text_tf,"$AVAILABLE PROJECTS:");
      }
      
      public function get hasNew() : Boolean
      {
         return this._hasNew;
      }
      
      public function set hasNew(param1:Boolean) : void
      {
         if(this._hasNew != param1)
         {
            this._hasNew = param1;
            if(this.hasNew)
            {
               this.NewIcon_mc.gotoAndStop(ResearchUtils.ON_FRAME_LABEL);
            }
            else
            {
               this.NewIcon_mc.gotoAndStop(ResearchUtils.OFF_FRAME_LABEL);
            }
         }
      }
      
      public function PopulateEntryData(param1:Object) : void
      {
         this.EntryIcon_mc.gotoAndStop(param1.sIconName);
         GlobalFunc.SetText(this.MainEntryText_mc.Text_tf,param1.sCategoryName);
         GlobalFunc.SetText(this.AvailableProjectNum_mc.Text_tf,GlobalFunc.PadNumber(param1.uNumAvailable,ResearchUtils.NUMBER_PADDING));
         this.hasNew = param1.bHasNew;
      }
      
      public function PlayOpeningAnimation() : void
      {
         if(this.hasNew)
         {
            this.NewIcon_mc.gotoAndPlay(ResearchUtils.OPEN_FRAME_LABEL);
         }
      }
      
      public function PlayClosingAnimation() : void
      {
         gotoAndPlay(SELECTED_CLOSE);
      }
   }
}
