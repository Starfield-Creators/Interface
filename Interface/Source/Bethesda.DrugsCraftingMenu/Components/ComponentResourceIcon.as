package Components
{
   import Shared.Components.ContentLoaders.SharedLibraryUserLoaderClip;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class ComponentResourceIcon extends MovieClip
   {
       
      
      public var Symbol_mc:MovieClip;
      
      public var Icon_mc:SharedLibraryUserLoaderClip;
      
      private const SYMBOL_WIDTH_SPACING:Number = 8;
      
      private var _resourceSymbol:String = "";
      
      private var _resourceColor:uint = 0;
      
      public function ComponentResourceIcon()
      {
         super();
         this.Icon_mc.centerClip = true;
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Symbol_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      private function get resourceSymbol() : String
      {
         return this._resourceSymbol;
      }
      
      private function get resourceColor() : uint
      {
         return this._resourceColor;
      }
      
      public function UpdateData(param1:Object) : void
      {
         this._resourceSymbol = param1.sSymbol;
         this._resourceColor = param1.uResourceColor;
         this.UpdateSymbol();
         this.Icon_mc.LoadClip(this.resourceColor == 0 && param1.sArtName == "" ? "Generic" : param1.sArtName);
      }
      
      private function UpdateSymbol() : void
      {
         var _loc1_:* = undefined;
         if(this.resourceColor != 0)
         {
            GlobalFunc.SetText(this.Symbol_mc.Text_tf,this.resourceSymbol);
            this.Symbol_mc.ResourceColor_mc.width = this.Symbol_mc.Text_tf.getLineMetrics(0).width + this.SYMBOL_WIDTH_SPACING;
            _loc1_ = new ColorTransform();
            _loc1_.color = this.resourceColor;
            this.Symbol_mc.ResourceColor_mc.transform.colorTransform = _loc1_;
            this.Symbol_mc.visible = true;
            this.Icon_mc.visible = false;
         }
         else
         {
            GlobalFunc.SetText(this.Symbol_mc.Text_tf,"");
            this.Symbol_mc.visible = false;
            this.Icon_mc.visible = true;
         }
      }
   }
}
