package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonBar.ConstrainedButtonBar;
   import Shared.Components.ButtonControls.ButtonBar.PipButtonBar;
   import Shared.Components.ButtonControls.ButtonBar.TabButtonBar;
   import Shared.Components.ButtonControls.ButtonData.PipButtonData;
   import Shared.Components.ButtonControls.ButtonData.TabButtonBarEvent;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.GlobalFunc;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class ColorPopup extends BSDisplayObject
   {
       
      
      public var NavigationBar_mc:TabButtonBar;
      
      public var PipBar_mc:PipButtonBar;
      
      public var Hue_mc:ColorControlEntry;
      
      public var Saturation_mc:ColorControlEntry;
      
      public var Brightness_mc:ColorControlEntry;
      
      public var RecentSwatches_mc:ColorControlEntry;
      
      private const PIP_SPACING:Number = 5;
      
      private var ActiveControl:ColorControlEntry = null;
      
      private var _currentControl:int = -1;
      
      private var _active:Boolean = false;
      
      private var _contextName:String = "";
      
      private var NavigationTabsA:Array;
      
      private var _blockInput:Boolean = false;
      
      public function ColorPopup()
      {
         this.NavigationTabsA = new Array();
         super();
         this.NavigationBar_mc.SetButtonSpacing(ConstrainedButtonBar.BUTTONS_PIXEL_PERFECT);
         this.PipBar_mc.Initialize(ButtonBar.JUSTIFY_CENTER,this.PIP_SPACING);
         this.PipBar_mc.SetButtonSpacing(ConstrainedButtonBar.BUTTONS_SCALE_TO_FIT);
         this.Hue_mc.controlID = ColorControlEntry.HUE;
         this.Saturation_mc.controlID = ColorControlEntry.SATURATION;
         this.Brightness_mc.controlID = ColorControlEntry.BRIGHTNESS;
         this.RecentSwatches_mc.controlID = ColorControlEntry.RECENT_COLORS;
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
      }
      
      private function set currentControl(param1:int) : *
      {
         if(this._currentControl != param1)
         {
            this._currentControl = param1;
            switch(this._currentControl)
            {
               case ColorControlEntry.HUE:
                  this.ActiveControl = this.Hue_mc;
                  break;
               case ColorControlEntry.SATURATION:
                  this.ActiveControl = this.Saturation_mc;
                  break;
               case ColorControlEntry.BRIGHTNESS:
                  this.ActiveControl = this.Brightness_mc;
                  break;
               case ColorControlEntry.RECENT_COLORS:
                  this.ActiveControl = this.RecentSwatches_mc;
            }
            this.Hue_mc.SetActive(this._currentControl == ColorControlEntry.HUE);
            this.Saturation_mc.SetActive(this._currentControl == ColorControlEntry.SATURATION);
            this.Brightness_mc.SetActive(this._currentControl == ColorControlEntry.BRIGHTNESS);
            this.RecentSwatches_mc.SetActive(this._currentControl == ColorControlEntry.RECENT_COLORS);
         }
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : *
      {
         this._active = param1;
         this.visible = this._active;
      }
      
      public function set contextName(param1:String) : *
      {
         this._contextName = param1;
      }
      
      public function get currentTabIndex() : int
      {
         return this.NavigationBar_mc.GetSelectedIndex();
      }
      
      public function get blockInput() : Boolean
      {
         return this._blockInput;
      }
      
      public function set blockInput(param1:Boolean) : *
      {
         this._blockInput = this.blockInput;
      }
      
      override public function onAddedToStage() : void
      {
         addEventListener(ColorControlEntry.VALUE_CHANGE,this.OnValueChange);
         BSUIDataManager.Subscribe("WorkshopColorTabsData",this.OnColorTabsDataUpdate);
         BSUIDataManager.Subscribe("WorkshopColorSettingData",this.OnColorSettingDataUpdate);
         BSUIDataManager.Subscribe("WorkshopColorHueData",function(param1:FromClientDataEvent):*
         {
            Hue_mc.SetColors(param1.data.aColors);
         });
         BSUIDataManager.Subscribe("WorkshopColorSaturationData",function(param1:FromClientDataEvent):*
         {
            Saturation_mc.SetColors(param1.data.aColors);
         });
         BSUIDataManager.Subscribe("WorkshopColorBrightnessData",function(param1:FromClientDataEvent):*
         {
            Brightness_mc.SetColors(param1.data.aColors);
         });
         BSUIDataManager.Subscribe("WorkshopRecentColorsData",function(param1:FromClientDataEvent):*
         {
            RecentSwatches_mc.SetColors(param1.data.aColors);
         });
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.NavigationBar_mc.ProcessUserEvent(param1,param2);
      }
      
      private function InitPipBar(param1:int) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:* = undefined;
         this.PipBar_mc.ClearButtons();
         _loc2_ = 0;
         while(_loc2_ < this.NavigationTabsA.length)
         {
            _loc3_ = this.NavigationTabsA[_loc2_];
            ButtonFactory.AddToButtonBar("PipTab",new PipButtonData(_loc2_,new UserEventData("click",this.OnPipButtonClicked)),this.PipBar_mc);
            _loc2_++;
         }
         this.PipBar_mc.SetSelectedIndex(param1);
         this.PipBar_mc.RefreshButtons();
      }
      
      private function OnPipButtonClicked(param1:int) : void
      {
         if(!this.blockInput)
         {
            this.NavigationBar_mc.SetSelectedIndex(param1);
            this.PipBar_mc.SetSelectedIndex(param1);
         }
      }
      
      private function OnColorTabChanged(param1:TabButtonBarEvent) : void
      {
         if(this.NavigationBar_mc.GetSelected() != null)
         {
            GlobalFunc.PlayMenuSound("UIOutpostModeMenuCategory");
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopColorMode_SelectedTab",{"tabIndex":this.currentTabIndex}));
         }
         this.PipBar_mc.SetSelectedIndex(this.currentTabIndex);
         this.currentControl = ColorControlEntry.HUE;
      }
      
      private function OnValueChange(param1:CustomEvent) : void
      {
         if(param1.params.type == ColorControlEntry.SLIDER)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopColorMode_SliderChanged",{
               "fValue":param1.params.value,
               "uControlID":param1.params.id
            }));
         }
         else if(param1.params.type == ColorControlEntry.SWATCHES)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopColorMode_SwatchChanged",{
               "uIndex":param1.params.value,
               "uControlID":param1.params.id
            }));
         }
      }
      
      private function OnEntryRolledOver(param1:CustomEvent) : void
      {
         this.currentControl = param1.params.id;
      }
      
      private function onKeyDownHandler(param1:KeyboardEvent) : void
      {
         if(!this.blockInput)
         {
            if(param1.keyCode == Keyboard.UP)
            {
               this.SelectControl(-1);
               param1.stopPropagation();
            }
            else if(param1.keyCode == Keyboard.DOWN)
            {
               this.SelectControl(1);
               param1.stopPropagation();
            }
            else if(param1.keyCode == Keyboard.LEFT || param1.keyCode == Keyboard.RIGHT)
            {
               if(this.ActiveControl != null)
               {
                  this.ActiveControl.onKeyDownHandler(param1);
               }
               param1.stopPropagation();
            }
         }
      }
      
      private function SelectControl(param1:int) : void
      {
         var _loc2_:int = this._currentControl + param1;
         if(_loc2_ < ColorControlEntry.HUE)
         {
            _loc2_ = ColorControlEntry.CONTROL_COUNT - 1;
         }
         else if(_loc2_ >= ColorControlEntry.CONTROL_COUNT)
         {
            _loc2_ = ColorControlEntry.HUE;
         }
         this.currentControl = _loc2_;
      }
      
      private function OnColorTabsDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc4_:uint = 0;
         this.NavigationBar_mc.removeEventListener(TabButtonBarEvent.TAB_CHANGED,this.OnColorTabChanged);
         this.NavigationTabsA = new Array();
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < param1.data.aColorTabs.length)
         {
            _loc4_ = uint(param1.data.aColorTabs[_loc3_]);
            this.NavigationTabsA.push(new ColorTabData(_loc4_));
            _loc3_++;
         }
         this.NavigationBar_mc.SetTabs("ColorTab",this.NavigationTabsA,ButtonBar.JUSTIFY_CENTER,_loc2_,this._contextName + "LShoulder",this._contextName + "RShoulder");
         this.NavigationBar_mc.addEventListener(TabButtonBarEvent.TAB_CHANGED,this.OnColorTabChanged);
         this.InitPipBar(_loc2_);
         this.currentControl = ColorControlEntry.HUE;
      }
      
      private function OnColorSettingDataUpdate(param1:FromClientDataEvent) : void
      {
         this.Hue_mc.SetValue(param1.data.fHue);
         this.Saturation_mc.SetValue(param1.data.fSaturation);
         this.Brightness_mc.SetValue(param1.data.fBrightness);
         this.RecentSwatches_mc.SetValue(param1.data.iRecentIndex);
      }
   }
}
