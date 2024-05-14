package Components.PlanetInfoCard
{
   import Shared.AS3.BSDisplayObject;
   
   public class Planet extends BSDisplayObject
   {
      
      private static const NONE_STR:String = "None";
      
      private static const FONT_TAG_NORMAL_OPEN:String = "<font size=\'12\'>";
      
      private static const FONT_TAG_SUBSCRIPT_OPEN:String = "<font size=\'8\'>";
      
      private static const FONT_TAG_CLOSE:String = "</font>";
      
      private static const DISABLED_COLOR:uint = 3752531;
       
      
      public var BodyDataInfo_mc:BodyDataInfo;
      
      public function Planet()
      {
         super();
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.BodyDataInfo_mc.SetBackgroundVisible(false);
      }
      
      public function Open() : *
      {
         gotoAndPlay("Open");
         this.BodyDataInfo_mc.Open();
      }
      
      public function Close() : *
      {
         gotoAndPlay("Close");
         this.BodyDataInfo_mc.Close();
      }
      
      public function SetBodyInfo(param1:Object) : *
      {
         this.BodyDataInfo_mc.SetBodyInfo(param1);
      }
   }
}
