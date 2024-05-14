package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class MainLanding extends MovieClip
   {
       
      
      public var CategoriesList_mc:CategoriesList;
      
      public function MainLanding()
      {
         var _loc1_:BSScrollingConfigParams = null;
         super();
         _loc1_ = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = ResearchUtils.CATEGORY_LIST_SPACING;
         _loc1_.EntryClassName = "CategoryList_Entry";
         this.CategoriesList_mc.Configure(_loc1_);
         addEventListener(ScrollingEvent.ITEM_PRESS,this.CategoryPressed);
         addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
      }
      
      public function UpdateCategoriesList(param1:Array) : void
      {
         this.CategoriesList_mc.InitializeEntries(param1);
         if(this.CategoriesList_mc.selectedIndex < 0 || this.CategoriesList_mc.selectedIndex >= param1.length)
         {
            this.CategoriesList_mc.selectedIndex = 0;
         }
      }
      
      public function SetSelectedCategory(param1:uint) : void
      {
         this.CategoriesList_mc.SetSelectedCategory(param1);
      }
      
      public function Open() : void
      {
         this.CategoriesList_mc.DisplayList(true);
         this.gotoAndPlay(ResearchUtils.OPEN_FRAME_LABEL);
      }
      
      public function TransitionToCategoryPage() : void
      {
         this.CategoriesList_mc.DisplayList(false);
         this.Close();
      }
      
      public function Close() : void
      {
         this.gotoAndPlay(ResearchUtils.CLOSE_FRAME_LABEL);
      }
      
      public function CategoryPressed() : void
      {
         if(this.CategoriesList_mc.selectedEntry != null)
         {
            GlobalFunc.PlayMenuSound(ResearchUtils.OK_SOUND);
            dispatchEvent(new CustomEvent(ResearchUtils.CATEGORY_PRESSED,{"categoryID":this.CategoriesList_mc.selectedEntry.uID},true,true));
         }
      }
      
      private function PlayFocusSound() : void
      {
         GlobalFunc.PlayMenuSound(ResearchUtils.FOCUS_SOUND);
      }
   }
}
