package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class TestScroll_Entry extends BSContainerEntry
   {
       
      
      public var Text_mc:MovieClip;
      
      public var ID_mc:MovieClip;
      
      public var BG_mc:MovieClip;
      
      public function TestScroll_Entry()
      {
         super();
         Extensions.enabled = true;
         if(this.ID_tf != null)
         {
            TextFieldEx.setTextAutoSize(this.ID_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.Text_mc.Name_tf;
      }
      
      protected function get ID_tf() : TextField
      {
         return this.ID_mc.ID_tf;
      }
      
      override protected function TryGetEntryText(param1:Object) : String
      {
         return param1.sName;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         super.SetEntryText(param1);
         if(this.ID_tf != null)
         {
            GlobalFunc.SetText(this.ID_tf,param1.uID,false);
         }
         this.BG_mc.Base_mc.height = Border_mc.height;
      }
   }
}
