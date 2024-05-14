package
{
   import Shared.Components.ContentLoaders.LibraryLoaderConfig;
   import Shared.Components.ContentLoaders.SharedLibraryOwner;
   import Shared.Components.ContentLoaders.SharedLibraryUserLoaderClip;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public final class CrewSkillsWidget extends MovieClip
   {
       
      
      public var CrewIconHolder_mc:MovieClip;
      
      public var Name_mc:MovieClip;
      
      public var SkillsHolder_mc:MovieClip;
      
      private var SkillLibrary:SharedLibraryOwner = null;
      
      private const SKILLS_VERT_SPACING:Number = 2;
      
      public function CrewSkillsWidget()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStageEvent);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStageEvent);
         this.SkillLibrary = new SharedLibraryOwner(this,LibraryLoaderConfig.SKILL_PATCHES_LIBRARY_CONFIG,SharedLibraryUserLoaderClip.REQUEST_LIBRARY);
      }
      
      private function onAddedToStageEvent(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStageEvent);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStageEvent);
      }
      
      private function onRemoveFromStageEvent(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStageEvent);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStageEvent);
         this.SkillLibrary.RemoveEventListener();
      }
      
      public function SetCrewData(param1:Object) : void
      {
         var _loc4_:CrewSkillsContainer = null;
         var _loc5_:Object = null;
         GlobalFunc.SetText(this.Name_mc.text_tf,param1.sName,false);
         this.CrewIconHolder_mc.gotoAndStop(param1.uType);
         var _loc2_:Number = 0;
         GlobalFunc.ClearClipOfChildren(this.SkillsHolder_mc);
         var _loc3_:uint = 0;
         while(_loc3_ < param1.aSkills.length)
         {
            _loc4_ = new CrewSkillsContainer();
            _loc5_ = param1.aSkills[_loc3_];
            this.SkillsHolder_mc.addChild(_loc4_);
            _loc4_.name = "Skill" + _loc3_;
            _loc4_.SetType(_loc5_.uType);
            _loc4_.SetRank(_loc5_.uRank);
            _loc4_.SetIcon(_loc5_.sName,_loc5_.iconImage);
            _loc4_.y = _loc2_;
            _loc2_ += _loc4_.height + this.SKILLS_VERT_SPACING;
            _loc3_++;
         }
      }
   }
}
