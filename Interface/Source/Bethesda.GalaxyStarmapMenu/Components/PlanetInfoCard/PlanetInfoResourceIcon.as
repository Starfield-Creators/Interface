package Components.PlanetInfoCard
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class PlanetInfoResourceIcon extends MovieClip
   {
      
      private static const FONT_TAG_NORMAL_OPEN:String = "<font size=\'12\'>";
      
      private static const FONT_TAG_NORMAL_OPEN_LRG:String = "<font size=\'22\'>";
      
      private static const FONT_TAG_SUBSCRIPT_OPEN:String = "<font size=\'8\'>";
      
      private static const FONT_TAG_SUBSCRIPT_OPEN_LRG:String = "<font size=\'16\'>";
      
      private static const FONT_TAG_CLOSE:String = "</font>";
      
      private static const NAMEPLATE_X_OFFSET:Number = 25;
      
      private static const NAMEPLATE_X_OFFSET_LRG:Number = 35;
      
      private static const DISABLED_COLOR:uint = 3752531;
       
      
      public var Rarity_mc:MovieClip;
      
      public var ResourceName_mc:MovieClip;
      
      public var Tagged_mc:MovieClip;
      
      public var BackgroundColor_mc:MovieClip;
      
      public var PlanetInfoHoverNameplate_mc:HoverNameplate;
      
      private var ResourceFullName:String = "";
      
      public function PlanetInfoResourceIcon()
      {
         super();
         addEventListener(MouseEvent.ROLL_OVER,this.onHoverOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onHoverOff);
      }
      
      public function get ResourceName_tf() : TextField
      {
         return this.ResourceName_mc.Text_tf;
      }
      
      internal function get FontTagNormalOpen() : String
      {
         return FONT_TAG_NORMAL_OPEN;
      }
      
      internal function get FontTagSubscriptOpen() : String
      {
         return FONT_TAG_SUBSCRIPT_OPEN;
      }
      
      internal function get NameplateXOffset() : Number
      {
         return NAMEPLATE_X_OFFSET;
      }
      
      private function onHoverOver(param1:Event) : *
      {
         if(this.PlanetInfoHoverNameplate_mc != null)
         {
            this.PlanetInfoHoverNameplate_mc.Open(this.ResourceFullName,localToGlobal(new Point(0,0)),this.NameplateXOffset);
         }
      }
      
      private function onHoverOff(param1:Event) : *
      {
         if(this.PlanetInfoHoverNameplate_mc != null)
         {
            this.PlanetInfoHoverNameplate_mc.Close();
         }
      }
      
      public function SetResource(param1:Object) : *
      {
         this.ResourceFullName = param1.sName;
         GlobalFunc.SetText(this.ResourceName_tf,this.FormatResourceShortName(param1.sSymbol),true);
         var _loc2_:* = new ColorTransform();
         _loc2_.color = !param1.bShowColor ? DISABLED_COLOR : param1.uColor;
         this.BackgroundColor_mc.transform.colorTransform = _loc2_;
         gotoAndStop(!!param1.bDisabled ? "Unknown" : "Known");
         this.Rarity_mc.gotoAndStop(param1.uRarity + 1);
         this.Tagged_mc.visible = param1.bTagged;
      }
      
      private function FormatResourceShortName(param1:String) : String
      {
         var _loc5_:String = null;
         var _loc6_:* = false;
         var _loc2_:String = this.FontTagNormalOpen;
         var _loc3_:Boolean = false;
         var _loc4_:Number = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1.charAt(_loc4_);
            if((_loc6_ = !isNaN(Number(_loc5_))) && !_loc3_)
            {
               _loc2_ += FONT_TAG_CLOSE + this.FontTagSubscriptOpen;
            }
            else if(!_loc6_ && _loc3_)
            {
               _loc2_ += FONT_TAG_CLOSE + this.FontTagNormalOpen;
            }
            _loc2_ += _loc5_;
            _loc3_ = _loc6_;
            _loc4_++;
         }
         return _loc2_ + FONT_TAG_CLOSE;
      }
   }
}
