package
{
   import Components.ComponentResourceIcon;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class ResourceEntry extends MovieClip
   {
       
      
      public var Name_mc:MovieClip;
      
      public var ComponentResourceIcon_mc:ComponentResourceIcon;
      
      public var Checkmark_mc:MovieClip;
      
      public var Continue_mc:MovieClip;
      
      public var Tagged_mc:MovieClip;
      
      private var _neededResource:Boolean = false;
      
      private var _taggedItem:Boolean = false;
      
      private var _showAsContinue:Boolean = false;
      
      public function ResourceEntry()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Name_mc.text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public function get neededResource() : Boolean
      {
         return this._neededResource;
      }
      
      public function set neededResource(param1:Boolean) : void
      {
         this._neededResource = param1;
         this.Checkmark_mc.visible = !this.showAsContinue && this.neededResource;
      }
      
      public function get taggedItem() : Boolean
      {
         return this._taggedItem;
      }
      
      public function set taggedItem(param1:Boolean) : void
      {
         this._taggedItem = param1;
         this.Tagged_mc.visible = !this.showAsContinue && this.taggedItem;
      }
      
      public function get showAsContinue() : Boolean
      {
         return this._showAsContinue;
      }
      
      public function set showAsContinue(param1:Boolean) : void
      {
         this._showAsContinue = param1;
         this.Name_mc.visible = !this.showAsContinue;
         this.ComponentResourceIcon_mc.visible = !this.showAsContinue;
         this.Checkmark_mc.visible = !this.showAsContinue && this.neededResource;
         this.Continue_mc.visible = this.showAsContinue;
         this.Checkmark_mc.visible = !this.showAsContinue && this.taggedItem;
      }
      
      public function SetResourceData(param1:Object) : void
      {
         this.ComponentResourceIcon_mc.UpdateData(param1.resourceInfo);
         GlobalFunc.SetText(this.Name_mc.text_tf,param1.sName);
         this.neededResource = param1.bNeeded;
         this.taggedItem = param1.bTracking;
      }
   }
}
