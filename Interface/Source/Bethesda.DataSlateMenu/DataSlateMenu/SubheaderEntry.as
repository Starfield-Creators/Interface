package DataSlateMenu
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class SubheaderEntry extends MovieClip implements IDataSlateEntry
   {
       
      
      public var LeftText_tf:TextField;
      
      public var RightText_tf:TextField;
      
      public function SubheaderEntry()
      {
         super();
      }
      
      public function SetData(param1:Object) : void
      {
         GlobalFunc.SetText(this.LeftText_tf,param1.arg0);
         GlobalFunc.SetText(this.RightText_tf,param1.arg1);
      }
   }
}
