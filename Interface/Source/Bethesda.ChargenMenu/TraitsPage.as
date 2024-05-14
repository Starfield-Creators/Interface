package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import scaleform.gfx.TextFieldEx;
   
   public class TraitsPage extends MovieClip implements IChargenPage
   {
      
      private static const IMAGE_SCALE:Number = 1;
       
      
      public var TraitsList_mc:BSScrollingContainer;
      
      public var SelectedEntry1_mc:MovieClip;
      
      public var SelectedEntry2_mc:MovieClip;
      
      public var SelectedEntry3_mc:MovieClip;
      
      public var TraitDesc_mc:MovieClip;
      
      public var TraitsIcon_mc:MovieClip;
      
      public var TraitHeader_mc:MovieClip;
      
      public var UnselectableTrait_mc:MovieClip;
      
      public var TraitsHeader_mc:MovieClip;
      
      private var TraitName_tf:TextField;
      
      private var TraitDesc_tf:TextField;
      
      internal var Data:Object;
      
      private var TraitCount:uint = 0;
      
      private var sTraitsText:String = "";
      
      private const NumText:Array = ["$FIRST","$SECOND","$THIRD"];
      
      internal var TraitTextField:TextField = null;
      
      public function TraitsPage()
      {
         var _loc3_:* = undefined;
         this.Data = new Object();
         super();
         this.UnselectableTrait_mc.visible = false;
         this.TraitName_tf = this.TraitHeader_mc.text_tf;
         this.TraitDesc_tf = this.TraitDesc_mc.text_tf;
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 0;
         _loc1_.EntryClassName = "TraitsEntry";
         _loc1_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.TraitsList_mc.Configure(_loc1_);
         this.TraitsList_mc.addEventListener(ScrollingEvent.SELECTION_CHANGE,this.OnListSelectionChange);
         this.TraitsList_mc.addEventListener(ScrollingEvent.ITEM_PRESS,this.OnItemPress);
         this.TraitsList_mc.addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
         var _loc2_:uint = 1;
         while(_loc2_ <= 3)
         {
            _loc3_ = this["SelectedEntry" + _loc2_ + "_mc"];
            if(_loc3_)
            {
               _loc3_.gotoAndStop("Unselected");
               GlobalFunc.SetText(_loc3_.SelectNextTraitText_mc.text_tf,"$TraitSelection");
            }
            _loc2_++;
         }
         GlobalFunc.SetText(this.TraitsHeader_mc.text_tf,"$TRAITS",false,false,0,false,0,["0/3"]);
         BSUIDataManager.Subscribe("TraitsData",this.OnTraitsDataChanged);
      }
      
      public function SetTraitCountTextField(param1:TextField) : *
      {
         this.TraitTextField = param1;
         GlobalFunc.SetText(this.TraitTextField,"$TRAITS",false,false,0,false,0,["0/3"]);
      }
      
      private function OnTraitsDataChanged(param1:FromClientDataEvent) : *
      {
         var count:uint;
         var index:uint;
         var clip:MovieClip = null;
         var ClassReference:Class = null;
         var patchClip:MovieClip = null;
         var selectedEntryClip:* = undefined;
         var aEvent:FromClientDataEvent = param1;
         this.TraitsList_mc.InitializeEntries(aEvent.data.TraitsA);
         this.Data = aEvent.data.TraitsA;
         this.SetData(this.TraitsList_mc.selectedEntry);
         count = 1;
         this.sTraitsText = "";
         index = 0;
         while(index < aEvent.data.TraitsA.length)
         {
            if(aEvent.data.TraitsA[index].bSelected)
            {
               clip = this["SelectedEntry" + count++ + "_mc"];
               if(clip)
               {
                  clip.gotoAndStop("Selected");
                  GlobalFunc.SetText(clip.SelectedTraitName_mc.text_tf,aEvent.data.TraitsA[index].sName);
                  clip.TraitsIcon_mc.SelectedTraitIconHolder_mc.removeChildren(0);
                  try
                  {
                     ClassReference = getDefinitionByName(aEvent.data.TraitsA[index].sArtName) as Class;
                     patchClip = new ClassReference();
                     patchClip.scaleX = IMAGE_SCALE;
                     patchClip.scaleY = IMAGE_SCALE;
                     clip.TraitsIcon_mc.SelectedTraitIconHolder_mc.addChild(patchClip);
                     clip.TraitsIcon_mc.TraitsDefault_mc.visible = false;
                  }
                  catch(e:ReferenceError)
                  {
                     clip.TraitsIcon_mc.TraitsDefault_mc.visible = true;
                  }
               }
               if(this.sTraitsText.length > 0)
               {
                  this.sTraitsText += ", ";
               }
               this.sTraitsText += aEvent.data.TraitsA[index].sName;
            }
            if(count > 3)
            {
               break;
            }
            index++;
         }
         this.TraitCount = count - 1;
         index = count;
         while(index <= 3)
         {
            selectedEntryClip = this["SelectedEntry" + count + "_mc"];
            if(selectedEntryClip)
            {
               selectedEntryClip.gotoAndStop("Unselected");
            }
            index++;
         }
         GlobalFunc.SetText(this.TraitsHeader_mc.text_tf,"$TRAITS",false,false,0,false,0,[this.TraitCount.toString() + "/3"]);
         if(this.TraitTextField != null)
         {
            GlobalFunc.SetText(this.TraitTextField,"$TRAITS",false,false,0,false,0,[this.TraitCount.toString() + "/3"]);
         }
      }
      
      public function QTraitCount() : uint
      {
         return this.TraitCount;
      }
      
      public function QTraitsText() : String
      {
         return this.sTraitsText;
      }
      
      private function OnItemPress() : *
      {
         var _loc1_:MovieClip = this.TraitsList_mc.FindClipForEntry(this.TraitsList_mc.selectedIndex);
         (_loc1_ as TraitsEntry).onClick();
      }
      
      private function SetData(param1:Object) : *
      {
         if(param1 != null)
         {
            GlobalFunc.SetText(this.TraitName_tf,param1.sName);
            GlobalFunc.SetText(this.TraitDesc_tf,param1.sDescription);
         }
         else
         {
            GlobalFunc.SetText(this.TraitName_tf,"");
            GlobalFunc.SetText(this.TraitDesc_tf,"");
         }
      }
      
      private function OnListSelectionChange(param1:ScrollingEvent) : *
      {
         this.SetData(param1.EntryObject);
      }
      
      public function UpdateData(param1:Object) : *
      {
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return false;
      }
      
      public function onEnterPage() : *
      {
         gotoAndPlay("Open");
         stage.focus = this.TraitsList_mc;
         this.TraitsList_mc.selectedIndex = 0;
         BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_SetCameraPosition",{"uNewCameraPositions":CharGenMenu.TRAITS_CAMERA_POSITION}));
      }
      
      public function onExitPage() : *
      {
         gotoAndPlay("Close");
      }
      
      public function OnControlMapChanged(param1:Object) : void
      {
      }
      
      public function InitFocus() : *
      {
         stage.focus = this.TraitsList_mc;
      }
      
      private function PlayFocusSound() : *
      {
         GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_FOCUS);
      }
   }
}
