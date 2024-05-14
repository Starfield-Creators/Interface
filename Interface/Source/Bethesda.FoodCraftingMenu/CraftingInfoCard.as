package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import flash.display.MovieClip;
   
   public class CraftingInfoCard extends InfoCard
   {
       
      
      public var Treatments_mc:MovieClip;
      
      public var EffectsList_mc:BSScrollingContainer;
      
      public function CraftingInfoCard()
      {
         var _loc1_:BSScrollingConfigParams = null;
         super();
         _loc1_ = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = CraftingUtils.LIST_SPACING;
         _loc1_.MultiLine = true;
         _loc1_.EntryClassName = "EffectsList_Entry";
         this.EffectsList_mc.Configure(_loc1_);
         this.EffectsList_mc.disableInput = true;
         this.EffectsList_mc.disableSelection = true;
      }
      
      override public function PopulateCard(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         super.PopulateCard(param1);
         this.EffectsList_mc.InitializeEntries(param1.aEffects);
         if(this.Treatments_mc != null)
         {
            _loc2_ = 5;
            param1.aTreatments.sort();
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this.Treatments_mc["Icon" + _loc3_];
               if(_loc3_ < param1.aTreatments.length)
               {
                  _loc4_.gotoAndStop(param1.aTreatments[_loc3_]);
                  _loc4_.visible = true;
               }
               else
               {
                  _loc4_.visible = false;
               }
               _loc3_++;
            }
         }
      }
   }
}
