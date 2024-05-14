package
{
   import flash.display.MovieClip;
   
   public class XPGroup extends MovieClip
   {
       
      
      public var XPTextAnim_mc:XPIncreaseWidget;
      
      private const VERTICAL_OFFSET:Number = -80;
      
      private var _fHPOriginalYPos:Number;
      
      private var _fXPOriginalYPos:Number;
      
      private var _bAdjustVertically:Boolean = false;
      
      public function XPGroup()
      {
         super();
         this._fXPOriginalYPos = this.XPTextAnim_mc.y;
      }
      
      public function get adjustVertically() : Boolean
      {
         return this._bAdjustVertically;
      }
      
      public function set adjustVertically(param1:Boolean) : *
      {
         if(this._bAdjustVertically != param1)
         {
            this._bAdjustVertically = param1;
            this.AdjustPositioningAndSize();
         }
      }
      
      private function AdjustPositioningAndSize() : *
      {
         if(this.adjustVertically)
         {
            this.XPTextAnim_mc.y = this._fXPOriginalYPos + this.VERTICAL_OFFSET;
         }
         else
         {
            this.XPTextAnim_mc.y = this._fXPOriginalYPos;
         }
      }
      
      public function SetVisible(param1:Boolean) : void
      {
         this.visible = param1;
         this.XPTextAnim_mc.SetVisible(param1);
      }
   }
}
