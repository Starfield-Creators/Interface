package
{
   import Components.ComponentResourceIcon;
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class TestResource_Entry extends BSContainerEntry
   {
       
      
      public var ComponentResourceIcon_mc:ComponentResourceIcon;
      
      public var ArtName_mc:MovieClip;
      
      public var ResourceName_mc:MovieClip;
      
      public function TestResource_Entry()
      {
         super();
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         GlobalFunc.SetText(this.ResourceName_mc.Text_tf,param1.sName);
         GlobalFunc.SetText(this.ArtName_mc.Text_tf,param1.resourceInfo.sArtName);
         this.ComponentResourceIcon_mc.UpdateData(param1.resourceInfo);
      }
   }
}
