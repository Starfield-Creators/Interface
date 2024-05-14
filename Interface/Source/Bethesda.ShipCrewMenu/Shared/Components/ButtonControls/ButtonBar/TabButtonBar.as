package Shared.Components.ButtonControls.ButtonBar
{
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.TabButtonBarEvent;
   import Shared.Components.ButtonControls.ButtonData.TabButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.ButtonBase;
   import Shared.Components.ButtonControls.Buttons.IButtonUtils;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   
   public class TabButtonBar extends MovieClip
   {
       
      
      public var TabsBar_mc:ConstrainedButtonBar;
      
      public var TabMoveLeftButton_mc:ButtonBase;
      
      public var TabMoveRightButton_mc:ButtonBase;
      
      public var Wrap:Boolean = true;
      
      public var Enabled:Boolean = true;
      
      protected var TabButtonManager:ButtonManager;
      
      protected var SelectedTab:TabTextButton;
      
      protected var SelectedTabIndex:int = -1;
      
      protected var ScrollIndexOffset:int = 0;
      
      protected var Tabs:Vector.<TabTextButton>;
      
      protected var TabLookupData:Dictionary;
      
      public function TabButtonBar()
      {
         this.TabButtonManager = new ButtonManager();
         this.Tabs = new Vector.<TabTextButton>();
         this.TabLookupData = new Dictionary();
         super();
         if(!this.TabsBar_mc)
         {
            GlobalFunc.TraceWarning("TabButtonBar requires \'TabsBar_mc\' clips on the timeline");
         }
      }
      
      public function SetTabs(param1:String, param2:Array, param3:uint = 0, param4:uint = 0, param5:String = "LShoulder", param6:String = "RShoulder", param7:int = 5) : void
      {
         var _loc8_:uint = 0;
         var _loc9_:* = undefined;
         var _loc10_:int = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:Boolean = false;
         var _loc14_:TabTextButton = null;
         var _loc15_:TabButtonData = null;
         this.TabsBar_mc.Initialize(param3,param7);
         this.TabMoveLeftButton_mc.SetButtonData(new ButtonBaseData("",new UserEventData(param5,this.MoveSelectionLeft),true,true,"",GlobalFunc.CANCEL_SOUND,GlobalFunc.FOCUS_SOUND,null,false));
         this.TabMoveLeftButton_mc.justification = IButtonUtils.ICON_FIRST;
         this.TabMoveRightButton_mc.SetButtonData(new ButtonBaseData("",new UserEventData(param6,this.MoveSelectionRight),true,true,"",GlobalFunc.CANCEL_SOUND,GlobalFunc.FOCUS_SOUND,null,false));
         if(this.TabButtonManager.NumButtons <= 0)
         {
            this.TabButtonManager.AddButton(this.TabMoveLeftButton_mc);
            this.TabButtonManager.AddButton(this.TabMoveRightButton_mc);
         }
         _loc8_ = 0;
         while(_loc8_ < param2.length)
         {
            _loc9_ = param2[_loc8_];
            _loc10_ = -1;
            _loc12_ = this.Tabs.length;
            _loc11_ = 0;
            while(_loc11_ < _loc12_)
            {
               if((_loc15_ = (_loc14_ = this.Tabs[_loc11_]).GetData()).sButtonText == _loc9_.Text)
               {
                  _loc10_ = int(_loc11_);
                  break;
               }
               _loc11_++;
            }
            _loc13_ = !_loc9_.hasOwnProperty("Enabled") || Boolean(_loc9_.Enabled);
            if(_loc10_ == -1)
            {
               this.Tabs.push(ButtonFactory.AddToButtonBar(param1,new TabButtonData("",_loc8_,new UserEventData("click",this.onTabSelected),_loc9_,_loc13_),this.TabsBar_mc));
            }
            else if(_loc13_ != this.Tabs[_loc10_].Enabled)
            {
               this.Tabs[_loc10_].Enabled = _loc13_;
            }
            _loc8_++;
         }
         dispatchEvent(new TabButtonBarEvent(TabButtonBarEvent.TAB_DATA_SET,this.SelectedTabIndex,_loc9_,true,true));
         this.SelectedTabIndex = -1;
         this.SetSelectedIndex(param4,true);
         this.TabsBar_mc.RefreshButtons();
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.Enabled)
         {
            _loc3_ = this.TabButtonManager.ProcessUserEvent(param1,param2);
            _loc3_ = this.TabsBar_mc.ProcessUserEvent(param1,param2) || _loc3_;
         }
         return _loc3_;
      }
      
      public function GetSelected() : TabButtonData
      {
         var _loc1_:* = null;
         if(this.SelectedTabIndex !== -1)
         {
            _loc1_ = this.SelectedTab.GetData();
         }
         return _loc1_;
      }
      
      public function GetSelectedIndex() : int
      {
         return this.SelectedTabIndex;
      }
      
      public function SetSelectedIndex(param1:int = 0, param2:Boolean = false) : void
      {
         var _loc7_:int = 0;
         var _loc8_:TabTextButton = null;
         var _loc3_:int = param1;
         var _loc4_:int = this.SelectedTabIndex;
         var _loc5_:int = int(this.Tabs.length);
         var _loc6_:int = param2 ? this.TabsBar_mc.WillBeVisibleButtons : this.TabsBar_mc.NumVisibleButtons;
         if(this.Wrap)
         {
            _loc3_ = (param1 + _loc5_) % _loc5_;
         }
         if(!this.Enabled || _loc3_ === this.SelectedTabIndex || _loc3_ < 0 || _loc3_ >= _loc5_)
         {
            return;
         }
         if(_loc3_ < this.ScrollIndexOffset)
         {
            this.ScrollIndexOffset -= this.ScrollIndexOffset - _loc3_;
         }
         else if(_loc3_ - this.ScrollIndexOffset > _loc6_ - 1)
         {
            this.ScrollIndexOffset += _loc3_ - this.ScrollIndexOffset - (_loc6_ - 1);
         }
         _loc7_ = 0;
         while(_loc7_ < _loc5_)
         {
            _loc8_ = this.Tabs[_loc7_];
            if(_loc7_ === _loc3_)
            {
               this.SelectedTabIndex = _loc3_;
               this.SelectedTab = _loc8_;
               _loc8_.SetSelected(true);
            }
            else
            {
               _loc8_.SetSelected(false);
            }
            _loc7_++;
         }
         this.TabsBar_mc.SetScrollOffset(this.ScrollIndexOffset);
         dispatchEvent(new TabButtonBarEvent(TabButtonBarEvent.TAB_CHANGED,_loc3_,this.SelectedTab.GetPayloadData(),true,true));
      }
      
      public function GetTabCount() : uint
      {
         return this.Tabs != null ? this.Tabs.length : 0;
      }
      
      public function SetButtonSpacing(param1:*) : void
      {
         this.TabsBar_mc.SetButtonSpacing(param1);
      }
      
      public function MoveSelectionRight() : void
      {
         var _loc1_:int = this.SelectedTabIndex;
         var _loc2_:int = int(this.Tabs.length);
         do
         {
            _loc1_++;
            if(this.Wrap)
            {
               _loc1_ %= _loc2_;
            }
            else if(_loc1_ == this.Tabs.length)
            {
               _loc1_ = this.SelectedTabIndex;
            }
         }
         while(!this.Tabs[_loc1_].Enabled && _loc1_ != this.SelectedTabIndex);
         
         this.SetSelectedIndex(_loc1_);
      }
      
      public function MoveSelectionLeft() : void
      {
         var _loc1_:int = this.SelectedTabIndex;
         var _loc2_:int = int(this.Tabs.length);
         do
         {
            _loc1_--;
            if(this.Wrap)
            {
               _loc1_ = (_loc1_ + _loc2_) % _loc2_;
            }
            else if(_loc1_ < 0)
            {
               _loc1_ = this.SelectedTabIndex;
            }
         }
         while(!this.Tabs[_loc1_].Enabled && _loc1_ != this.SelectedTabIndex);
         
         this.SetSelectedIndex(_loc1_);
      }
      
      protected function onTabSelected(param1:ButtonBaseData = null) : void
      {
         var _loc2_:TabButtonData = null;
         if(param1 is TabButtonData)
         {
            _loc2_ = param1 as TabButtonData;
            this.SetSelectedIndex(_loc2_.TabIndex);
         }
      }
   }
}
