package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class ModulePaletteCategories extends BSDisplayObject
   {
      
      private static const NORMAL:String = "Normal";
      
      private static const ACTIVE:String = "Active";
       
      
      public var CategoryTab1_mc:MovieClip;
      
      public var CategoryTab2_mc:MovieClip;
      
      public var CategoryTab3_mc:MovieClip;
      
      public var CategoryLeftButton:ChangeCategoryButton;
      
      public var CategoryRightButton:ChangeCategoryButton;
      
      public var CategoryLeftButtonMKB:ChangeCategoryButton;
      
      public var CategoryRightButtonMKB:ChangeCategoryButton;
      
      public var Bar1_mc:MovieClip;
      
      public var Bar2_mc:MovieClip;
      
      public var Bar3_mc:MovieClip;
      
      public var Bar4_mc:MovieClip;
      
      public var Bar5_mc:MovieClip;
      
      public var Bar6_mc:MovieClip;
      
      public var Bar7_mc:MovieClip;
      
      public var Bar8_mc:MovieClip;
      
      public var Bar9_mc:MovieClip;
      
      public var Bar10_mc:MovieClip;
      
      public var Bar11_mc:MovieClip;
      
      public var Bar12_mc:MovieClip;
      
      public var Bar13_mc:MovieClip;
      
      public var Bar14_mc:MovieClip;
      
      private var ActiveBarIndex:int = 0;
      
      private var CategoryBars:Vector.<MovieClip>;
      
      public function ModulePaletteCategories()
      {
         super();
         this.CategoryBars = new <MovieClip>[this.Bar1_mc,this.Bar2_mc,this.Bar3_mc,this.Bar4_mc,this.Bar5_mc,this.Bar6_mc,this.Bar7_mc,this.Bar8_mc,this.Bar9_mc,this.Bar10_mc,this.Bar11_mc,this.Bar12_mc,this.Bar13_mc,this.Bar14_mc];
         var _loc1_:ChangeCategoryButton = this.CategoryTab1_mc as ChangeCategoryButton;
         _loc1_.CategoryOffset = -1;
         var _loc2_:ChangeCategoryButton = this.CategoryTab2_mc as ChangeCategoryButton;
         _loc2_.CategoryOffset = 0;
         _loc2_.SetAlwaysHighlight(true);
         var _loc3_:ChangeCategoryButton = this.CategoryTab3_mc as ChangeCategoryButton;
         _loc3_.CategoryOffset = 1;
         this.CategoryLeftButton.CategoryOffset = -1;
         this.CategoryLeftButtonMKB.CategoryOffset = -1;
         this.CategoryLeftButtonMKB.EventName = "PrevCategory";
         this.CategoryRightButton.CategoryOffset = 1;
         this.CategoryRightButtonMKB.CategoryOffset = 1;
         this.CategoryRightButtonMKB.EventName = "NextCategory";
      }
      
      private function get CategoryTab1Text() : TextField
      {
         return this.CategoryTab1_mc.Text_mc.text_tf;
      }
      
      private function get CategoryTab2Text() : TextField
      {
         return this.CategoryTab2_mc.Text_mc.text_tf;
      }
      
      private function get CategoryTab3Text() : TextField
      {
         return this.CategoryTab3_mc.Text_mc.text_tf;
      }
      
      override public function onAddedToStage() : void
      {
      }
      
      public function SetCategoryNames(param1:String, param2:String, param3:String) : void
      {
         GlobalFunc.SetText(this.CategoryTab1Text,param2);
         this.CategoryTab1Text.y = this.CategoryTab1_mc.Text_mc.y - this.CategoryTab1Text.textHeight * 0.5;
         TextFieldEx.setTextAutoSize(this.CategoryTab1Text,TextFieldEx.TEXTAUTOSZ_SHRINK);
         GlobalFunc.SetText(this.CategoryTab2Text,param1);
         this.CategoryTab2Text.y = this.CategoryTab2_mc.Text_mc.y - this.CategoryTab2Text.textHeight * 0.5;
         TextFieldEx.setTextAutoSize(this.CategoryTab2Text,TextFieldEx.TEXTAUTOSZ_SHRINK);
         GlobalFunc.SetText(this.CategoryTab3Text,param3);
         this.CategoryTab3Text.y = this.CategoryTab3_mc.Text_mc.y - this.CategoryTab3Text.textHeight * 0.5;
         TextFieldEx.setTextAutoSize(this.CategoryTab3Text,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public function SetCategoryIndex(param1:int) : void
      {
         param1 = Math.min(this.CategoryBars.length - 1,param1);
         this.CategoryBars[this.ActiveBarIndex].gotoAndStop(NORMAL);
         this.ActiveBarIndex = param1;
         this.CategoryBars[this.ActiveBarIndex].gotoAndStop(ACTIVE);
      }
      
      override protected function OnControlMapChanged(param1:Object) : void
      {
         super.OnControlMapChanged(param1);
         this.CategoryLeftButton.visible = uiController != PlatformUtils.PLATFORM_PC_KB_MOUSE;
         this.CategoryLeftButtonMKB.visible = uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE;
         this.CategoryRightButton.visible = uiController != PlatformUtils.PLATFORM_PC_KB_MOUSE;
         this.CategoryRightButtonMKB.visible = uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE;
      }
   }
}
