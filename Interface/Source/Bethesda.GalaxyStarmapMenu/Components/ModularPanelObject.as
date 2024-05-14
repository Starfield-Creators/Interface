package Components
{
   import Shared.AS3.BSDisplayObject;
   import Shared.BSEaze;
   import flash.display.MovieClip;
   
   public class ModularPanelObject extends BSDisplayObject
   {
      
      private static const PANEL_OPEN_TIME:Number = 0.5;
      
      private static const PERECENTAGE_UNTIL_OPEN:Number = 0.8;
       
      
      public var InfoPanelArray:Array;
      
      public var NextInQueue:int = 0;
      
      public var BackgroundHeight:Number = 0;
      
      private var _BackgroundHeightPadding:Number = 0;
      
      public function ModularPanelObject()
      {
         super();
         this.InfoPanelArray = [];
      }
      
      public function set BackgroundHeightPadding(param1:Number) : void
      {
         this._BackgroundHeightPadding = param1;
      }
      
      public function get BackgroundHeightPadding() : Number
      {
         return this._BackgroundHeightPadding;
      }
      
      public function AddToInfoPanelArray(param1:MovieClip) : *
      {
         this.InfoPanelArray.push(param1);
      }
      
      public function OpenBackgroundAnimation(param1:MovieClip) : *
      {
         var i:*;
         var backgroundClip:MovieClip = param1;
         backgroundClip.visible = true;
         this.BackgroundHeight += this._BackgroundHeightPadding;
         i = 0;
         while(i < this.InfoPanelArray.length)
         {
            this.BackgroundHeight += this.InfoPanelArray[i].height;
            i++;
         }
         BSEaze(backgroundClip).ExpandClipFromZero(PANEL_OPEN_TIME,backgroundClip.width,this.BackgroundHeight).eaze.onUpdate(function():*
         {
            if(backgroundClip.height > BackgroundHeight * PERECENTAGE_UNTIL_OPEN && NextInQueue == 0)
            {
               PlayNextAnimation();
            }
         });
      }
      
      public function PlayNextAnimation() : *
      {
         if(this.NextInQueue < this.InfoPanelArray.length)
         {
            this.InfoPanelArray[this.NextInQueue].gotoAndPlay("Open");
            ++this.NextInQueue;
         }
      }
      
      public function OnClose(param1:MovieClip) : *
      {
         param1.visible = false;
         this.Clear();
      }
      
      private function Clear() : void
      {
         this.NextInQueue = 0;
         this.BackgroundHeight = 0;
         this.InfoPanelArray.splice(0,this.InfoPanelArray.length);
      }
      
      public function ContractBackground(param1:MovieClip) : *
      {
         BSEaze(param1).ContractClip(PANEL_OPEN_TIME);
         this.Clear();
      }
      
      public function ContractBackgroundHeight(param1:MovieClip) : *
      {
         BSEaze(param1).ContractClipHeight(PANEL_OPEN_TIME);
         this.Clear();
      }
   }
}
