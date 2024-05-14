package Shared.AS3
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class BSTabbedSelectionEntry extends MovieClip
   {
       
      
      public var Text_mc:MovieClip;
      
      public var iIndex:int;
      
      protected var bLockedWidth:Boolean = true;
      
      public function BSTabbedSelectionEntry()
      {
         super();
         Extensions.enabled = true;
      }
      
      protected function get SelectedFrameLabel() : String
      {
         return "selected";
      }
      
      protected function get UnselectedFrameLabel() : String
      {
         return "unselected";
      }
      
      protected function get baseTextField() : TextField
      {
         return this.Text_mc.Text_tf;
      }
      
      public function get LockedWidth() : Boolean
      {
         return this.bLockedWidth;
      }
      
      public function SetWidth(param1:Number) : *
      {
         width = param1;
      }
      
      public function GetWidth() : Number
      {
         return width;
      }
      
      public function Update(param1:Object, param2:Boolean, param3:String) : *
      {
         var _loc4_:String = " ";
         if(param1 != null)
         {
            if(param1.text != undefined)
            {
               _loc4_ = String(param1.text);
            }
         }
         this.UpdateBaseData(_loc4_,param2,param3);
      }
      
      protected function UpdateBaseData(param1:String, param2:Boolean, param3:String) : *
      {
         if(this.baseTextField != null)
         {
            TextFieldEx.setTextAutoSize(this.baseTextField,param3);
            GlobalFunc.SetText(this.baseTextField,param1,true);
         }
         if(currentLabel == this.SelectedFrameLabel)
         {
            if(!param2)
            {
               gotoAndPlay(this.UnselectedFrameLabel);
            }
         }
         else if(currentLabel == this.UnselectedFrameLabel)
         {
            if(param2)
            {
               gotoAndPlay(this.SelectedFrameLabel);
            }
         }
         else
         {
            gotoAndPlay(param2 ? this.SelectedFrameLabel : this.UnselectedFrameLabel);
         }
      }
   }
}
