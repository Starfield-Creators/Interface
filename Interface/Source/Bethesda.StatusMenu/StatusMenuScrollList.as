package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   
   public class StatusMenuScrollList extends MovieClip
   {
       
      
      public var InfoComponents_mc:MovieClip;
      
      public var ScrollBar_mc:MovieClip;
      
      private var ScrollPercent:Number = 0;
      
      private var bDragging:Boolean = false;
      
      private var bUpHeld:Boolean = false;
      
      private var bDownHeld:Boolean = false;
      
      private var StartingMousePosition:Number = 0;
      
      private var StartingScrollPositionOnDrag:Number = 0;
      
      private var StartingScrollWidgetHeight:Number = 0;
      
      private var PanelModularHeight:Number = 0;
      
      private var ModularMovieClip:MovieClip = null;
      
      private var bIsLeftSidePanel:Boolean = false;
      
      private var fPanelTopPosition:Number = 0;
      
      private var fModularItemStartingPosition:Number = 0;
      
      private var fPanelStartingPosition:Number = 0;
      
      private var pScrollBoundPositions:Point;
      
      private var pMouseWheelThresholds:Point;
      
      private const PANEL_SPACING:Number = 25;
      
      private const PANEL_SPACING_SMALL:Number = 12;
      
      private const SCROLLBAR_SPACING:Number = 18;
      
      private const SCROLL_DELTA:Number = 30;
      
      private const STICK_DELTA:Number = 15;
      
      private const DIVIDER_LINE:String = "DividerLine";
      
      private const FACTION_STANDING_ENTRY:String = "FactionStandingEntryClip";
      
      private const HEADER:String = "StatusMenuHeader";
      
      private const EFFECT_GROUP_HEADER_ENTRY:String = "EffectGroupHeaderEntryClip";
      
      private const BUFF_ENTRY:String = "BuffEntryClip";
      
      private const TRAIT_ENTRY:String = "TraitEntryClip";
      
      private const EXPLORATION_ENTRY:String = "ExplorationEntryClip";
      
      private const FACTION_AND_EXPLORATION_ENTRY:String = "FactionAndExplorationEntryClip";
      
      private const MISC_INFO_ENTRY:String = "MiscInfoEntry";
      
      private const DAMAGE_RESISTANCES:String = "DamageResistances";
      
      public function StatusMenuScrollList()
      {
         this.pScrollBoundPositions = new Point(0,0);
         this.pMouseWheelThresholds = new Point(0,0);
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function set IsLeftSidePanel(param1:Boolean) : *
      {
         this.bIsLeftSidePanel = param1;
      }
      
      public function get IsLeftSidePanel() : Boolean
      {
         return this.bIsLeftSidePanel;
      }
      
      public function set PanelTopPosition(param1:Number) : *
      {
         this.fPanelTopPosition = param1;
      }
      
      public function get PanelTopPosition() : Number
      {
         return this.fPanelTopPosition;
      }
      
      public function set ModularItemStartingPosition(param1:Number) : *
      {
         this.fModularItemStartingPosition = param1;
      }
      
      public function get ModularItemStartingPosition() : Number
      {
         return this.fModularItemStartingPosition;
      }
      
      public function set PanelStartingPosition(param1:Number) : *
      {
         this.fPanelStartingPosition = param1;
      }
      
      public function get PanelStartingPosition() : Number
      {
         return this.fPanelStartingPosition;
      }
      
      public function set ScrollBoundPositions(param1:Point) : *
      {
         this.pScrollBoundPositions = param1;
      }
      
      public function get ScrollBoundPositions() : Point
      {
         return this.pScrollBoundPositions;
      }
      
      public function set MouseWheelThresholds(param1:Point) : *
      {
         this.pMouseWheelThresholds = param1;
      }
      
      public function get MouseWheelThresholds() : Point
      {
         return this.pMouseWheelThresholds;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.StartingScrollWidgetHeight = this.ScrollBar_mc.ScrollWidget_mc.height;
         this.ScrollBar_mc.ScrollWidget_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel);
         addEventListener(Event.ENTER_FRAME,this.OnEnterFrame);
      }
      
      public function ClearList() : void
      {
         this.InfoComponents_mc.removeChildren();
         this.PanelModularHeight = 0;
      }
      
      protected function CreateMovieClip(param1:String, param2:Boolean = false) : MovieClip
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Class;
         if(_loc4_ = getDefinitionByName(param1) as Class)
         {
            _loc3_ = new _loc4_();
            this.InfoComponents_mc.addChild(_loc3_);
            _loc3_.x = this.ModularItemStartingPosition;
            _loc3_.y = this.PanelStartingPosition + this.PanelModularHeight;
            this.PanelModularHeight += param2 ? this.PANEL_SPACING_SMALL : this.PANEL_SPACING;
         }
         return _loc3_;
      }
      
      protected function get PanelBottomPosition() : Number
      {
         return this.PanelTopPosition - (this.PanelModularHeight + this.PANEL_SPACING * 2 - this.ScrollBar_mc.height);
      }
      
      protected function UpdateScrollPosition() : void
      {
         this.ScrollPercent = GlobalFunc.Clamp(this.ScrollPercent,0,1);
         this.ScrollBar_mc.ScrollWidget_mc.y = (this.ScrollBoundPositions.y - this.ScrollBoundPositions.x) * this.ScrollPercent + this.ScrollBoundPositions.x;
         this.InfoComponents_mc.y = -(this.PanelModularHeight - this.ScrollBar_mc.height) * this.ScrollPercent;
         if(this.ScrollBar_mc.height < this.PanelModularHeight)
         {
            this.ScrollBar_mc.ScrollWidget_mc.height = this.ScrollBar_mc.height * this.ScrollBar_mc.height / this.PanelModularHeight;
            this.ScrollBoundPositions.y = this.ScrollBar_mc.height - this.SCROLLBAR_SPACING - this.ScrollBar_mc.ScrollWidget_mc.height;
         }
      }
      
      protected function handleMouseDown(param1:MouseEvent) : void
      {
         if(this.ScrollBar_mc.visible)
         {
            this.bDragging = true;
            this.StartingMousePosition = globalToLocal(new Point(0,param1.stageY)).y;
            this.StartingScrollPositionOnDrag = this.ScrollBar_mc.ScrollWidget_mc.y;
         }
      }
      
      protected function handleMouseUp(param1:MouseEvent) : void
      {
         this.bDragging = false;
      }
      
      protected function handleMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.bDragging)
         {
            _loc2_ = globalToLocal(new Point(0,param1.stageY)).y;
            _loc3_ = _loc2_ - this.StartingMousePosition;
            _loc4_ = this.StartingScrollPositionOnDrag + _loc3_;
            this.ScrollBar_mc.ScrollWidget_mc.y = GlobalFunc.Clamp(_loc4_,this.ScrollBoundPositions.x,this.ScrollBoundPositions.y);
            this.ScrollPercent = (this.ScrollBar_mc.ScrollWidget_mc.y - this.ScrollBoundPositions.x) / (this.ScrollBoundPositions.y - this.ScrollBoundPositions.x);
            this.InfoComponents_mc.y = (this.PanelBottomPosition - this.ScrollBoundPositions.x) * this.ScrollPercent + this.ScrollBoundPositions.x;
         }
      }
      
      protected function handleMouseWheel(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1.delta != 0 && !this.bDragging && this.ScrollBar_mc.visible && stage.mouseX >= this.MouseWheelThresholds.x && stage.mouseX <= this.MouseWheelThresholds.y)
         {
            _loc2_ = this.PanelModularHeight - this.ScrollBar_mc.height;
            _loc3_ = this.SCROLL_DELTA / _loc2_;
            this.ScrollPercent += param1.delta > 0 ? -1 * _loc3_ : _loc3_;
            this.UpdateScrollPosition();
            param1.stopPropagation();
         }
      }
      
      public function onStickDataChanged(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.ScrollBar_mc.visible)
         {
            if(Math.abs(param1) > 0.1)
            {
               _loc2_ = this.PanelModularHeight - this.ScrollBar_mc.height;
               _loc3_ = this.STICK_DELTA / _loc2_;
               this.ScrollPercent += _loc3_ * (param1 < 0 ? -1 : 1);
               this.UpdateScrollPosition();
            }
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.ScrollBar_mc.visible && this.IsLeftSidePanel)
         {
            if(param1 == "Up")
            {
               this.bUpHeld = param2;
               _loc3_ = true;
            }
            else if(param1 == "Down")
            {
               this.bDownHeld = param2;
               _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      private function OnEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = this.PanelModularHeight - this.ScrollBar_mc.height;
         var _loc3_:Number = this.SCROLL_DELTA / _loc2_;
         if(this.bUpHeld)
         {
            this.ScrollPercent -= _loc3_;
            this.UpdateScrollPosition();
         }
         else if(this.bDownHeld)
         {
            this.ScrollPercent += _loc3_;
            this.UpdateScrollPosition();
         }
      }
      
      public function CheckScrollBar() : void
      {
         this.ScrollBar_mc.visible = this.PanelModularHeight - this.PANEL_SPACING > this.ScrollBar_mc.BackgroundBar_mc.height;
         this.ScrollPercent = 0;
         this.UpdateScrollPosition();
      }
      
      public function AddDivider() : void
      {
         var _loc1_:MovieClip = this.CreateMovieClip(this.DIVIDER_LINE);
         this.PanelModularHeight += _loc1_.height;
      }
      
      public function AddHeader(param1:String) : void
      {
         var _loc2_:MovieClip = this.CreateMovieClip(this.HEADER);
         GlobalFunc.SetText(_loc2_.Text_tf,param1);
         this.PanelModularHeight += _loc2_.height;
      }
      
      public function AddEffectGroupHeader(param1:Object) : void
      {
         var _loc2_:EffectGroupHeaderEntry = this.CreateMovieClip(this.EFFECT_GROUP_HEADER_ENTRY,true) as EffectGroupHeaderEntry;
         this.PanelModularHeight += _loc2_.height;
         _loc2_.SetEntry(param1);
      }
      
      public function AddActiveEffect(param1:Object, param2:Boolean = true) : void
      {
         var _loc3_:BuffEntry = this.CreateMovieClip(this.BUFF_ENTRY,param2) as BuffEntry;
         _loc3_.SetEntry(param1);
         this.PanelModularHeight += _loc3_.height;
      }
      
      public function AddExploration(param1:Object) : void
      {
         var _loc2_:FactionAndExplorationEntry = this.CreateMovieClip(this.FACTION_AND_EXPLORATION_ENTRY) as FactionAndExplorationEntry;
         param1.sType = FactionAndExplorationEntry.FEE_EXPLORATION;
         _loc2_.SetEntry(param1);
         this.PanelModularHeight += _loc2_.height;
      }
      
      public function AddTrait(param1:Object) : void
      {
         var _loc2_:TraitEntry = this.CreateMovieClip(this.TRAIT_ENTRY) as TraitEntry;
         _loc2_.SetEntry(param1);
         this.PanelModularHeight += _loc2_.height;
      }
      
      public function AddMiscEntries(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MiscInfoEntry = null;
         if(Boolean(param1) && param1.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = this.CreateMovieClip(this.MISC_INFO_ENTRY) as MiscInfoEntry;
               _loc3_.SetEntry(param1[_loc2_]);
               this.PanelModularHeight += _loc3_.height;
               _loc2_++;
            }
         }
      }
      
      public function AddDamageResistances(param1:Object) : void
      {
         var _loc2_:DamageResistances = this.CreateMovieClip(this.DAMAGE_RESISTANCES) as DamageResistances;
         _loc2_.SetEntry(param1);
         this.PanelModularHeight += _loc2_.height;
      }
   }
}
