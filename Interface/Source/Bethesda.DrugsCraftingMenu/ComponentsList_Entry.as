package
{
   import Components.ComponentResourceIcon;
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class ComponentsList_Entry extends BSContainerEntry
   {
      
      public static var nameCutOffLength:uint = 0;
       
      
      public var Name_mc:MovieClip;
      
      public var ComponentResourceIcon_mc:ComponentResourceIcon;
      
      public var Count_mc:MovieClip;
      
      public var Tagged_mc:MovieClip;
      
      private const MAX_AMOUNT:uint = 999;
      
      public function ComponentsList_Entry()
      {
         super();
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         this.ComponentResourceIcon_mc.UpdateData(param1.resourceInfo);
         this.Tagged_mc.visible = param1.bTracking;
         GlobalFunc.SetText(this.Name_mc.Text_tf,param1.sName,false,false,nameCutOffLength);
         var _loc2_:String = param1.uCurrentAmt > this.MAX_AMOUNT ? this.MAX_AMOUNT.toString() + "+" : String(param1.uCurrentAmt.toString());
         var _loc3_:String = _loc2_ + "/" + param1.uRequiredAmt;
         GlobalFunc.SetText(this.Count_mc.Text_tf,_loc3_);
      }
   }
}
