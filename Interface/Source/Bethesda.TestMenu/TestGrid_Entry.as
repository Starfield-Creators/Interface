package
{
   import Shared.AS3.BSGridListEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class TestGrid_Entry extends BSGridListEntry
   {
       
      
      public var Text_mc:MovieClip;
      
      public var ID_mc:MovieClip;
      
      public function TestGrid_Entry()
      {
         super();
         Extensions.enabled = true;
         if(this.Name_tf != null)
         {
            TextFieldEx.setTextAutoSize(this.Name_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         if(this.ID_tf != null)
         {
            TextFieldEx.setTextAutoSize(this.ID_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
      }
      
      protected function get Name_tf() : TextField
      {
         return this.Text_mc.Name_tf;
      }
      
      protected function get ID_tf() : TextField
      {
         return this.ID_mc.ID_tf;
      }
      
      override public function SetEntryData(param1:Object) : *
      {
         if(this.Name_tf != null)
         {
            GlobalFunc.SetText(this.Name_tf,param1.sName,false);
         }
         if(this.ID_tf != null)
         {
            GlobalFunc.SetText(this.ID_tf,param1.uID,false);
         }
      }
   }
}
