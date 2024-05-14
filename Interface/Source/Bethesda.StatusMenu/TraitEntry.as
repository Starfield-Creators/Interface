package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getDefinitionByName;
   
   public class TraitEntry extends MovieClip
   {
       
      
      public var Icon_mc:MovieClip;
      
      public var Name_mc:MovieClip;
      
      public var Desc_mc:MovieClip;
      
      private const IMAGE_SCALE:Number = 0.5;
      
      private const OFFSET:Number = -50;
      
      public function TraitEntry()
      {
         super();
         this.Name_tf.autoSize = TextFieldAutoSize.LEFT;
         this.Desc_tf.multiline = true;
         this.Desc_tf.wordWrap = true;
         this.Desc_tf.autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function get Name_tf() : TextField
      {
         return this.Name_mc.Text_tf;
      }
      
      public function get Desc_tf() : TextField
      {
         return this.Desc_mc.Text_tf;
      }
      
      public function SetEntry(param1:Object) : *
      {
         var _loc2_:Class = null;
         var _loc3_:MovieClip = null;
         GlobalFunc.SetText(this.Name_tf,param1.sName.toUpperCase());
         GlobalFunc.SetText(this.Desc_tf,param1.sDescription);
         this.Desc_tf.height = this.Desc_tf.textHeight;
         if(param1.sArtName.length > 0)
         {
            _loc2_ = getDefinitionByName(param1.sArtName) as Class;
            _loc3_ = new _loc2_();
            _loc3_.scaleX = this.IMAGE_SCALE;
            _loc3_.scaleY = this.IMAGE_SCALE;
            this.Icon_mc.removeChildren();
            this.Icon_mc.addChild(_loc3_);
         }
         else
         {
            this.Icon_mc.removeChildren();
            x += this.OFFSET;
         }
      }
   }
}
