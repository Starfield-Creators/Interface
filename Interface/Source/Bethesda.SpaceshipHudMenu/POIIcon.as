package
{
   import Components.Icons.DynamicPoiIcon;
   import Shared.GlobalFunc;
   
   public class POIIcon extends FarTravelIconBase
   {
       
      
      public var PoiIcon_mc:DynamicPoiIcon;
      
      public function POIIcon()
      {
         super();
      }
      
      override public function SetTargetLowInfo(param1:Object, param2:Object, param3:Boolean) : *
      {
         super.SetTargetLowInfo(param1,param2,param3);
         this.PoiIcon_mc.SetLocation(TargetLow.uPoiType,TargetLow.uPoiCategory,DynamicPoiIcon.GetSpaceMarkerState(TargetLow.bMarkerDiscovered));
      }
      
      override protected function TryUpdateName() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:String = DynamicPoiIcon.GetSpacePOIName(TargetLow.name,TargetLow.bMarkerDiscovered,TargetLow.uPoiCategory);
         if(LastName != _loc2_)
         {
            GlobalFunc.SetText(Name_tf,_loc2_);
            LastName = _loc2_;
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      override protected function SetAsStaticIndicator(param1:Boolean) : *
      {
         super.SetAsStaticIndicator(param1);
         this.PoiIcon_mc.visible = !param1;
      }
   }
}
