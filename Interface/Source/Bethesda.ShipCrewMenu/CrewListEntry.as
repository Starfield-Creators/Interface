package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextLineMetrics;
   import scaleform.gfx.TextFieldEx;
   
   public class CrewListEntry extends BSContainerEntry
   {
      
      public static var CurrentCrewListFilter:uint = 0;
      
      public static const TEXT_FADE_COLOR:uint = 8947848;
      
      private static const LocationTextBuffer:int = 4;
      
      private static var LargeTextMode:Boolean = false;
       
      
      public var Icon_mc:MovieClip;
      
      public var NameAndAssignmentType_mc:MovieClip;
      
      public var New_mc:MovieClip;
      
      public var Assignment_mc:MovieClip;
      
      public var Location_mc:MovieClip;
      
      public var SkillHolder_mc:MovieClip;
      
      public var BG1_mc:MovieClip;
      
      private var CurrentFilterExactMatch:Boolean = false;
      
      private var BaseHeight:Number = 0;
      
      private var NumSkills:uint = 0;
      
      public function CrewListEntry()
      {
         super();
         this.BaseHeight = this.BG1_mc.height;
         TextFieldEx.setVerticalAutoSize(this.Name_tf,TextFieldEx.TEXTAUTOSZ_FIT);
         TextFieldEx.setVerticalAutoSize(this.Assignment_tf,TextFieldEx.TEXTAUTOSZ_FIT);
         TextFieldEx.setVerticalAutoSize(this.Location_tf,TextFieldEx.TEXTAUTOSZ_FIT);
         this.onRollout();
      }
      
      public static function set largeTextMode(param1:Boolean) : *
      {
         LargeTextMode = param1;
      }
      
      public function get Name_tf() : TextField
      {
         return this.NameAndAssignmentType_mc.Name_tf;
      }
      
      public function get Assignment_tf() : TextField
      {
         return this.Assignment_mc.Text_tf;
      }
      
      public function get AssignmentType_tf() : TextField
      {
         return this.NameAndAssignmentType_mc.AssignmentType_tf;
      }
      
      public function get Location_tf() : TextField
      {
         return this.Location_mc.Text_tf;
      }
      
      private function GetSkillAtIndex(param1:int) : SkillClip
      {
         return this.SkillHolder_mc["Skill" + param1 + "_mc"];
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         var _loc6_:Object = null;
         var _loc7_:SkillClip = null;
         this.NumSkills = param1.aSkills.length;
         if(LargeTextMode)
         {
            gotoAndStop(this.NumSkills > 2 ? "double_unselected" : "unselected");
         }
         Border_mc.height = this.BG1_mc.height;
         this.CurrentFilterExactMatch = CurrentCrewListFilter == ShipCrewUtils.AssignmentTypeToFlag(param1.uAssignmentType);
         switch(param1.uType)
         {
            case ShipCrewUtils.CREW_TYPE_NONE:
            case ShipCrewUtils.CREW_TYPE_CREW:
               this.Icon_mc.gotoAndStop("Crew");
               break;
            case ShipCrewUtils.CREW_TYPE_ELITE:
               this.Icon_mc.gotoAndStop("EliteCrew");
               break;
            case ShipCrewUtils.CREW_TYPE_COMPANION:
               this.Icon_mc.gotoAndStop("Companion");
         }
         GlobalFunc.SetText(this.Name_tf,param1.sName);
         this.Name_tf.y = (this.BaseHeight - (this.Name_tf.height + this.AssignmentType_tf.height)) / 2;
         this.AssignmentType_tf.y = this.Name_tf.y + this.Name_tf.height;
         GlobalFunc.SetText(this.Assignment_tf,param1.sAssignment);
         var _loc2_:String = "$Unknown Location";
         if(param1.sParentStarName != "")
         {
            _loc2_ = String(param1.sParentStarName);
            if(param1.sParentBodyName != "" && param1.sParentBodyName != param1.sParentStarName)
            {
               _loc2_ = param1.sParentBodyName + ", " + _loc2_;
            }
         }
         else if(param1.sFallbackLocationName != "")
         {
            _loc2_ = String(param1.sFallbackLocationName);
         }
         GlobalFunc.SetText(this.Location_tf,_loc2_);
         GlobalFunc.SetText(this.AssignmentType_tf,ShipCrewUtils.AssignmentTypeToLocString(param1.uAssignmentType));
         var _loc3_:TextLineMetrics = this.Assignment_tf.getLineMetrics(0);
         this.Location_tf.y = this.Assignment_tf.y + LocationTextBuffer + _loc3_.height * (this.Assignment_tf.numLines - 1);
         this.New_mc.visible = param1.bNew;
         var _loc4_:int = 0;
         while(_loc4_ < param1.aSkills.length)
         {
            _loc6_ = param1.aSkills[_loc4_];
            if((_loc7_ = this.GetSkillAtIndex(_loc4_)) != null)
            {
               _loc7_.SetActive(param1.uAssignmentType == _loc6_.uAssignmentType);
               _loc7_.LoadClip(_loc6_);
               _loc7_.visible = true;
            }
            _loc4_++;
         }
         var _loc5_:SkillClip = this.GetSkillAtIndex(_loc4_);
         while(_loc5_ != null)
         {
            _loc5_.visible = false;
            _loc4_++;
            _loc5_ = this.GetSkillAtIndex(_loc4_);
         }
      }
      
      override public function onRollover() : void
      {
         var _loc1_:String = "selected";
         if(this.New_mc.currentFrameLabel != _loc1_)
         {
            this.New_mc.gotoAndStop(_loc1_);
         }
         if(LargeTextMode && this.NumSkills > 2)
         {
            _loc1_ = "double_" + _loc1_;
         }
         if(currentFrameLabel != _loc1_)
         {
            gotoAndStop(_loc1_);
         }
      }
      
      override public function onRollout() : void
      {
         var _loc1_:String = "unselected";
         if(this.New_mc.currentFrameLabel != _loc1_)
         {
            this.New_mc.gotoAndStop(_loc1_);
         }
         if(LargeTextMode && this.NumSkills > 2)
         {
            _loc1_ = "double_" + _loc1_;
         }
         if(currentFrameLabel != _loc1_)
         {
            gotoAndStop(_loc1_);
         }
      }
   }
}
