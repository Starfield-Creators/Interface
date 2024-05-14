package
{
   import Shared.AS3.BSContainerEntry;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class CategoryList_Entry extends BSContainerEntry
   {
      
      public static const OPEN_ANIM_HALFWAY:String = "OpenAnimationHalfway";
      
      public static const OPEN_ANIM_FINISHED:String = "OpenAnimationFinished";
       
      
      public var LandingEntry_mc:LandingEntry;
      
      public var ResearchProgress_mc:ResearchProgress;
      
      public function CategoryList_Entry()
      {
         super();
      }
      
      override public function get animationClip() : MovieClip
      {
         return this.LandingEntry_mc;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         this.LandingEntry_mc.PopulateEntryData(param1);
         this.ResearchProgress_mc.UpdateProjectList(param1.aProjectsInProgress,param1.uNumAvailable);
      }
      
      public function Display(param1:Boolean) : void
      {
         if(param1)
         {
            this.gotoAndPlay(ResearchUtils.OPEN_FRAME_LABEL);
            this.LandingEntry_mc.PlayOpeningAnimation();
         }
         else if(selected)
         {
            this.LandingEntry_mc.PlayClosingAnimation();
            this.ResearchProgress_mc.PlayClosingAnimation();
         }
      }
   }
}
