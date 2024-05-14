package Components
{
   import Shared.AS3.BSDisplayObject;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class SystemEntry extends BSDisplayObject
   {
      
      private static const PADDING:int = 4;
       
      
      public var SystemName_mc:MovieClip;
      
      public var SystemTypeName_mc:MovieClip;
      
      public const SELECTED:String = "Selected";
      
      public const UNSELECTED:String = "Unselected";
      
      public const DISABLED:String = "Disabled";
      
      private var m_Index:uint;
      
      private var m_disabled:Boolean = false;
      
      public function SystemEntry()
      {
         super();
      }
      
      public function set Disabled(param1:Boolean) : void
      {
         this.m_disabled = param1;
         if(param1)
         {
            gotoAndStop(this.DISABLED);
         }
         else
         {
            gotoAndStop(this.UNSELECTED);
         }
      }
      
      public function get Disabled() : Boolean
      {
         return this.m_disabled;
      }
      
      override public function onAddedToStage() : void
      {
         this.SetSelected(false);
      }
      
      public function SetSelected(param1:Boolean) : void
      {
         if(this.m_disabled)
         {
            return;
         }
         if(param1)
         {
            gotoAndStop(this.SELECTED);
         }
         else
         {
            gotoAndStop(this.UNSELECTED);
         }
      }
      
      public function set Name(param1:String) : void
      {
         GlobalFunc.SetText(this.SystemName_mc.text_tf,param1);
      }
      
      public function set Type(param1:String) : void
      {
         GlobalFunc.SetText(this.SystemTypeName_mc.text_tf,param1);
      }
      
      public function set Index(param1:uint) : void
      {
         this.m_Index = param1;
      }
      
      public function get Index() : uint
      {
         return this.m_Index;
      }
      
      public function get Selected() : Boolean
      {
         return currentFrameLabel == this.SELECTED;
      }
   }
}
