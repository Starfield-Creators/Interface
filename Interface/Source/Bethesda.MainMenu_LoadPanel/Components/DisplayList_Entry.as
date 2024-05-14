package Components
{
   import flash.display.MovieClip;
   
   public class DisplayList_Entry extends MovieClip
   {
       
      
      public var Sizer_mc:MovieClip;
      
      private var _entryData:Object;
      
      public function DisplayList_Entry()
      {
         super();
      }
      
      public function SetEntryData(param1:Object) : *
      {
         this._entryData = param1;
      }
   }
}
