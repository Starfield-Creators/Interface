package
{
   import Shared.AS3.BSContainerEntry;
   import flash.display.MovieClip;
   
   public class KioskButtonListEntry extends BSContainerEntry
   {
       
      
      public var Label_mc:MovieClip;
      
      public var LockedIcon_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      private const DEFAULT_TEXT_SIZE:* = 34;
      
      public function KioskButtonListEntry()
      {
         super();
         gotoAndStop(unselectedFrameLabel);
      }
      
      public function set Label(param1:String) : *
      {
         GenesisTerminalShared.SetAndScaleTextfieldText(this.Label_mc.text_tf,param1,this.DEFAULT_TEXT_SIZE);
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         this.Label = param1.sIconName;
         this.LockedIcon_mc.visible = param1.bIsLocked;
      }
   }
}
