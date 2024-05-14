package Shared.AS3.ShipPower
{
   import Shared.GlobalFunc;
   import Shared.ShipInfoUtils;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ShipComponentBase extends MovieClip
   {
      
      public static const PARTIAL_DAMAGE_THRESHOLD:Number = 0.5;
       
      
      public var ComponentName_mc:MovieClip;
      
      private var LastName:String = "";
      
      private var LastFrameLabel:String = "";
      
      protected var componentObject:Object;
      
      public function ShipComponentBase()
      {
         super();
         this.Update();
      }
      
      protected function get Name_tf() : TextField
      {
         return this.ComponentName_mc.Name_mc.Name_tf;
      }
      
      public function set ComponentObject(param1:Object) : *
      {
         if(this.componentObject != null || param1 != null)
         {
            this.componentObject = param1;
            this.Update();
         }
      }
      
      public function get ComponentObject() : Object
      {
         return this.componentObject;
      }
      
      public function Update() : *
      {
         this.UpdateName();
         this.UpdateTimelineState();
      }
      
      protected function UpdateTimelineState() : *
      {
         var _loc2_:int = 0;
         var _loc1_:String = "Empty";
         if(this.ComponentObject != null && this.ComponentObject.type != ShipInfoUtils.MT_COUNT)
         {
            if(this.ComponentObject.bTargetComponent)
            {
               _loc1_ = "Targeted";
            }
            else
            {
               _loc2_ = this.componentObject.damagePhys + this.componentObject.damageEM;
               if(_loc2_ >= this.componentObject.componentMaxPower)
               {
                  _loc1_ = "Destroyed";
               }
               else if(_loc2_ >= this.componentObject.componentMaxPower * PARTIAL_DAMAGE_THRESHOLD)
               {
                  _loc1_ = "Damaged";
               }
               else
               {
                  _loc1_ = "Unselected";
               }
            }
         }
         if(this.LastFrameLabel != _loc1_)
         {
            gotoAndStop(_loc1_);
            this.LastFrameLabel = _loc1_;
         }
      }
      
      protected function UpdateName() : *
      {
         var _loc1_:String = null;
         if(this.ComponentObject != null)
         {
            _loc1_ = String(this.ComponentObject.abbreviation);
            if(!_loc1_ || _loc1_.length == 0)
            {
               _loc1_ = String(this.ComponentObject.componentName.slice(0,3));
            }
            if(this.ComponentName_mc != null && this.LastName != _loc1_)
            {
               GlobalFunc.SetText(this.Name_tf,_loc1_,true);
               this.LastName = _loc1_;
            }
         }
      }
   }
}
