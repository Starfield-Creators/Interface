package
{
   import Components.ComponentResourceIcon;
   import Components.DisplayList_Entry;
   import Shared.WorkshopUtils;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class CargoLinkResourceEntry extends DisplayList_Entry
   {
       
      
      public var Name_mc:MovieClip;
      
      public var ComponentResourceIcon_mc:ComponentResourceIcon;
      
      public var Continue_mc:MovieClip;
      
      public var Tagged_mc:MovieClip;
      
      private var _showAsContinue:Boolean = false;
      
      private var _taggedItem:Boolean = false;
      
      private var _largeTextMode:Boolean = false;
      
      public function CargoLinkResourceEntry()
      {
         super();
         if(!this._largeTextMode)
         {
            Extensions.enabled = true;
            TextFieldEx.setTextAutoSize(this.Name_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
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
         this.Continue_mc.visible = this.showAsContinue;
         this.Tagged_mc.visible = !this.showAsContinue && this.taggedItem;
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
      
      override public function SetEntryData(param1:Object) : *
      {
         this.ComponentResourceIcon_mc.UpdateData(param1.resourceInfo);
         WorkshopUtils.SetSingleLineText(this.Name_mc.Text_tf,param1.sName,this._largeTextMode);
         this.taggedItem = param1.bTracking;
      }
   }
}
