package Components
{
   import Shared.AS3.BSDisplayObject;
   import flash.display.MovieClip;
   
   public class IconOrganizer extends BSDisplayObject
   {
      
      public static const ALIGN_LEFT:String = "LeftAlign";
      
      public static const ALIGN_CENTER:String = "CenterAlign";
      
      public static const ALIGN_RIGHT:String = "RightAlign";
      
      public static const ALIGN_TOP:String = "TopAlign";
      
      public static const ALIGN_MIDDLE:String = "MiddleAlign";
      
      public static const ALIGN_BOTTOM:String = "BottomAlign";
       
      
      public var Icons_mc:MovieClip;
      
      private var AlignType:String = "LeftAlign";
      
      private var IconSpacing:Number = 0;
      
      private var IconContainerInitialPosX:Number = 0;
      
      private var IconContainerInitialPosY:Number = 0;
      
      private var IconSize:Number = 36;
      
      public function IconOrganizer()
      {
         super();
         this.IconContainerInitialPosX = this.Icons_mc.x;
         this.IconContainerInitialPosY = this.Icons_mc.y;
      }
      
      public function get Align_Inspectable() : String
      {
         return this.AlignType;
      }
      
      public function set Align_Inspectable(param1:String) : *
      {
         this.AlignType = param1;
      }
      
      public function get IconSpacing_Inspectable() : *
      {
         return this.IconSpacing;
      }
      
      public function set IconSpacing_Inspectable(param1:Number) : *
      {
         this.IconSpacing = param1;
      }
      
      public function get IconSize_Inspectable() : Number
      {
         return this.IconSize;
      }
      
      public function set IconSize_Inspectable(param1:Number) : *
      {
         this.IconSize = param1;
      }
      
      private function IsHorizontallyAligned() : Boolean
      {
         return this.AlignType == ALIGN_LEFT || this.AlignType == ALIGN_CENTER || this.AlignType == ALIGN_RIGHT;
      }
      
      private function Organize() : *
      {
         var _loc6_:MovieClip = null;
         var _loc7_:Number = NaN;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = this.IconSize / 2;
         var _loc5_:* = 0;
         while(_loc5_ < this.Icons_mc.numChildren)
         {
            if((_loc6_ = this.Icons_mc.getChildAt(_loc5_) as MovieClip).visible)
            {
               _loc3_++;
               _loc7_ = 0;
               if(_loc3_ > 1)
               {
                  _loc7_ = _loc1_ + _loc4_ + this.IconSpacing_Inspectable;
               }
               _loc1_ = _loc4_;
               _loc2_ += _loc7_;
               if(this.IsHorizontallyAligned())
               {
                  _loc6_.x = _loc2_;
                  _loc6_.y = 0;
               }
               else
               {
                  _loc6_.x = 0;
                  _loc6_.y = _loc2_;
               }
            }
            _loc5_++;
         }
         if(this.AlignType == ALIGN_RIGHT)
         {
            this.Icons_mc.x = this.IconContainerInitialPosX - _loc2_;
         }
         else if(this.AlignType == ALIGN_CENTER)
         {
            this.Icons_mc.x = this.IconContainerInitialPosX - _loc2_ / 2;
         }
         else if(this.AlignType == ALIGN_BOTTOM)
         {
            this.Icons_mc.y = this.IconContainerInitialPosY - _loc2_;
         }
         else if(this.AlignType == ALIGN_MIDDLE)
         {
            this.Icons_mc.y = this.IconContainerInitialPosY - _loc2_ / 2;
         }
      }
      
      public function SetIconVisible(param1:String, param2:Boolean, param3:Number = 1) : *
      {
         var _loc4_:MovieClip;
         if((_loc4_ = this.Icons_mc[param1]) != null && (_loc4_.visible != param2 || _loc4_.alpha != param3))
         {
            _loc4_.alpha = param3;
            _loc4_.visible = param2;
            SetIsDirty();
         }
      }
      
      override public function redrawDisplayObject() : void
      {
         this.Organize();
      }
      
      public function ResetIcons() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.Icons_mc.numChildren)
         {
            this.Icons_mc.getChildAt(_loc1_).visible = false;
            _loc1_++;
         }
      }
   }
}
