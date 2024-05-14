package Shared.Components.ButtonControls.Buttons
{
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class AnchoredButton extends ButtonBase
   {
      
      public static const LEFT:int = EnumHelper.GetEnum(0);
      
      public static const RIGHT:int = EnumHelper.GetEnum();
      
      public static const TOP:int = EnumHelper.GetEnum();
      
      public static const BOTTOM:int = EnumHelper.GetEnum();
      
      public static const ANCHOR_BUTTON:int = EnumHelper.GetEnum(0);
      
      public static const ANCHOR_LABEL:int = EnumHelper.GetEnum();
      
      private static const ROUNDING_PRECISION:uint = 2;
       
      
      public var AnchorPoint_mc:MovieClip;
      
      public var ButtonInfo_mc:MovieClip;
      
      private var _anchorSide:int;
      
      private var _anchoringClip:int;
      
      public function AnchoredButton()
      {
         super();
         this._anchorSide = LEFT;
         this._anchoringClip = ANCHOR_BUTTON;
         PCButton_mc = this.ButtonInfo_mc.PCButton_mc;
         ConsoleButton_mc = this.ButtonInfo_mc.ConsoleButton_mc;
         Label_mc = this.ButtonInfo_mc.Label_mc;
         SetupAlignment();
      }
      
      public function get anchorSide() : int
      {
         return this._anchorSide;
      }
      
      public function get anchoringClip() : int
      {
         return this._anchoringClip;
      }
      
      public function SetAnchorData(param1:int, param2:int) : void
      {
         this._anchorSide = param1;
         this._anchoringClip = param2;
         this.UpdateClipsAroundAnchor();
      }
      
      protected function UpdateClipsAroundAnchor() : void
      {
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc1_:MovieClip = null;
         var _loc2_:Point = new Point(0,0);
         var _loc3_:Point = new Point(0,0);
         switch(this.anchoringClip)
         {
            case ANCHOR_BUTTON:
               if(KeyHelper.usingController)
               {
                  _loc1_ = ConsoleButton_mc;
               }
               else
               {
                  _loc1_ = PCButton_mc;
               }
               break;
            case ANCHOR_LABEL:
               if(Label_mc != null)
               {
                  _loc1_ = Label_mc;
               }
         }
         if(_loc1_ != null)
         {
            _loc3_.x = _loc1_.x;
            _loc3_.y = _loc1_.y;
            _loc2_.x = _loc1_.width;
            _loc2_.y = _loc1_.height;
            _loc4_ = this.globalToLocal(this.ButtonInfo_mc.localToGlobal(new Point(_loc3_.x,_loc3_.y)));
            _loc5_ = new Point(_loc4_.x,_loc4_.y);
            switch(this.anchorSide)
            {
               case LEFT:
                  _loc5_.x = this.AnchorPoint_mc.x;
                  break;
               case RIGHT:
                  _loc5_.x = this.AnchorPoint_mc.x - _loc2_.x;
                  break;
               case TOP:
                  _loc5_.y = this.AnchorPoint_mc.y;
                  break;
               case BOTTOM:
                  _loc5_.y = this.AnchorPoint_mc.y - _loc2_.y;
            }
            _loc6_ = GlobalFunc.RoundDecimal(_loc5_.x - _loc4_.x,ROUNDING_PRECISION);
            _loc7_ = GlobalFunc.RoundDecimal(_loc5_.y - _loc4_.y,ROUNDING_PRECISION);
            if(Label_mc != null)
            {
               Label_mc.x += _loc6_;
               Label_mc.y += _loc7_;
            }
            if(ConsoleButton_mc != null)
            {
               ConsoleButton_mc.x += _loc6_;
               ConsoleButton_mc.y += _loc7_;
            }
            if(PCButton_mc != null)
            {
               PCButton_mc.x += _loc6_;
               PCButton_mc.y += _loc7_;
            }
         }
      }
      
      override protected function UpdateButtonText() : void
      {
         super.UpdateButtonText();
         this.UpdateClipsAroundAnchor();
      }
   }
}
