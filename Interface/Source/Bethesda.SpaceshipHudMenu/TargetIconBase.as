package
{
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class TargetIconBase extends TargetIconFrameContainer
   {
      
      private static const RectBoundsPadding:Number = 4;
      
      protected static const NEUTRAL_SELECTED_FRAME_LABEL:String = "NeutralSelected";
      
      protected static const NEUTRAL_UNSELECTED_FRAME_LABEL:String = "NeutralUnselected";
      
      protected static const ECLIPSED_SELECTED_FRAME_LABEL:String = "EclipsedSelected";
      
      protected static const ECLIPSED_UNSELECTED_FRAME_LABEL:String = "EclipsedUnselected";
      
      protected static const DISTANCE_OFFSET_X:Number = 6;
      
      protected static const DISTANCE_OFFSET_Y:Number = 3;
      
      public static var ButtonBar_mc:ButtonBar;
       
      
      public var Internal_mc:MovieClip;
      
      public var Name_mc:MovieClip;
      
      public var Distance_mc:MovieClip;
      
      public var Name_tf:TextField;
      
      public var Distance_tf:TextField;
      
      public var QuestIcon_mc:MovieClip;
      
      public var Icon_mc:MovieClip;
      
      public var Glow_mc:MovieClip;
      
      public var Divider_mc:MovieClip;
      
      public var ButtonAnchor_mc:MovieClip;
      
      protected var IsStaticIndicator:Boolean = false;
      
      private var _blockedAlpha:Number = 1;
      
      private var LocalNameBounds:Rectangle = null;
      
      private var PositionAdjustedNameBounds:Rectangle = null;
      
      private var _bsv:Number = Infinity;
      
      protected var TargetLow:Object;
      
      protected var TargetOnlyData:Object;
      
      protected var TargetHigh:Object;
      
      protected var LatestPayloadData:Object;
      
      protected var ShowAsSelected:Boolean = false;
      
      private var LastFrame:String = "";
      
      private var LastDistanceText:String = "";
      
      protected var LastName:String = null;
      
      protected var MonocleMode:Boolean = false;
      
      private var NameDirty:Boolean = false;
      
      public function TargetIconBase()
      {
         super();
         this.Name_mc = this.Internal_mc.Name_mc;
         this.Distance_mc = this.Internal_mc.Distance_mc;
         this.Divider_mc = this.Internal_mc.Divider_mc;
         if(this.Divider_mc != null)
         {
            this.Divider_mc.visible = false;
         }
         if(this.Name_mc != null && this.Distance_mc != null)
         {
            this.Name_tf = this.Name_mc.Text_tf;
            this.Distance_tf = this.Distance_mc.Text_tf;
         }
         else
         {
            GlobalFunc.TraceWarning("TargetIconBase Internal_mc missing components");
         }
         this.LocalNameBounds = this.GetNameBounds();
         this.PositionAdjustedNameBounds = this.LocalNameBounds.clone();
         TextFieldEx.setVerticalAlign(this.Name_tf,TextFieldEx.VALIGN_BOTTOM);
         TextFieldEx.setVerticalAutoSize(this.Name_tf,TextFieldEx.VAUTOSIZE_BOTTOM);
         stop();
         if(ButtonBar_mc != null)
         {
            this.InitButtonData();
         }
      }
      
      public static function Compare(param1:TargetIconBase, param2:TargetIconBase) : Number
      {
         return param1._bsv - param2._bsv;
      }
      
      public function get BlockedAlpha() : Number
      {
         return this._blockedAlpha;
      }
      
      public function InitButtonData() : *
      {
         this.PopulateButtons();
      }
      
      override public function SetTargetLowInfo(param1:Object, param2:Object, param3:Boolean) : *
      {
         super.SetTargetLowInfo(param1,param2,param3);
         this.TargetLow = param1;
         var _loc4_:* = this.TargetOnlyData != null;
         this.TargetOnlyData = param2;
         this.MonocleMode = param3;
         this.ShowAsSelected = Boolean(this.TargetLow.isInfoTarget) || this.MonocleMode;
         this.SelectFrame();
         if(this.TryUpdateName())
         {
            this.Distance_tf.x = this.LastName != "" ? this.Name_tf.textWidth + DISTANCE_OFFSET_X : 0;
            this.NameDirty = true;
         }
         if(this.QuestIcon_mc != null)
         {
            this.QuestIcon_mc.visible = this.TargetLow.bHasQuestTarget;
         }
         this.UpdateButtons();
      }
      
      override public function SetTargetHighInfo(param1:Object) : *
      {
         var _loc3_:String = null;
         super.SetTargetHighInfo(param1);
         var _loc2_:* = false;
         if(this.Distance_mc.visible && this.Internal_mc.alpha > 0)
         {
            _loc3_ = GlobalFunc.FormatDistanceToString(param1.distance);
            if(this.LastDistanceText != _loc3_)
            {
               _loc2_ = this.LastDistanceText.length != _loc3_.length;
               GlobalFunc.SetText(this.Distance_tf,_loc3_);
               this.LastDistanceText = _loc3_;
            }
         }
         if(_loc2_ || this.NameDirty)
         {
            this.LocalNameBounds.width = this.Distance_tf.x + this.Distance_tf.textWidth - this.Name_tf.x + RectBoundsPadding * 2;
            this.PositionAdjustedNameBounds.width = this.LocalNameBounds.width;
            this.NameDirty = false;
         }
         this.TargetHigh = param1;
      }
      
      public function SetLatestPayloadData(param1:Object) : *
      {
         this.LatestPayloadData = param1;
      }
      
      protected function TryUpdateName() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.Name_mc.visible && this.LastName != this.TargetLow.name)
         {
            GlobalFunc.SetText(this.Name_tf,this.TargetLow.name);
            this.LastName = this.TargetLow.name;
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      protected function SelectFrame() : *
      {
         if(this.TargetLow.bBehindCelestialBody)
         {
            if(this.ShowAsSelected)
            {
               this.GoToFrame(ECLIPSED_SELECTED_FRAME_LABEL);
            }
            else
            {
               this.GoToFrame(ECLIPSED_UNSELECTED_FRAME_LABEL);
            }
         }
         else if(this.ShowAsSelected)
         {
            this.GoToFrame(NEUTRAL_SELECTED_FRAME_LABEL);
         }
         else
         {
            this.GoToFrame(NEUTRAL_UNSELECTED_FRAME_LABEL);
         }
      }
      
      protected function GoToFrame(param1:String) : *
      {
         if(this.LastFrame != param1)
         {
            gotoAndStop(param1);
            this.Internal_mc.gotoAndStop(param1);
            this.LastFrame = param1;
         }
      }
      
      protected function PopulateButtons() : *
      {
      }
      
      public function GetLocalBounds() : Rectangle
      {
         return this.LocalNameBounds;
      }
      
      public function GetPositionAdjustedBounds() : Rectangle
      {
         return this.PositionAdjustedNameBounds;
      }
      
      public function UpdatePositionAdjustedBounds() : *
      {
         this.PositionAdjustedNameBounds.x = this.LocalNameBounds.x + x;
         this.PositionAdjustedNameBounds.y = this.LocalNameBounds.y + y;
      }
      
      private function GetNameBounds() : Rectangle
      {
         var _loc1_:Rectangle = this.Name_mc.getBounds(this);
         var _loc2_:Rectangle = this.Distance_mc.getBounds(this);
         _loc1_ = _loc1_.union(_loc2_);
         var _loc3_:Number = RectBoundsPadding * 2;
         _loc1_.x -= RectBoundsPadding;
         _loc1_.y -= RectBoundsPadding;
         _loc1_.width += _loc3_;
         _loc1_.height += _loc3_;
         return _loc1_;
      }
      
      public function SetBlockedClipAlpha(param1:Number, param2:Boolean) : *
      {
         if(param2 || param1 < this._blockedAlpha)
         {
            this._blockedAlpha = param1;
         }
         this.Internal_mc.alpha = this._blockedAlpha;
      }
      
      public function TrySetAsStaticIndicator(param1:Boolean) : *
      {
         if(this.IsStaticIndicator != param1)
         {
            this.SetAsStaticIndicator(param1);
            this.IsStaticIndicator = param1;
         }
      }
      
      protected function SetAsStaticIndicator(param1:Boolean) : *
      {
         if(this.IsStaticIndicator != param1)
         {
            if(this.Icon_mc != null)
            {
               this.Icon_mc.visible = !param1;
            }
            if(this.Glow_mc != null)
            {
               this.Glow_mc.visible = !param1;
            }
         }
      }
      
      public function UpdateBSV() : *
      {
         if(this.TargetLow != null && Boolean(this.TargetLow.isInfoTarget))
         {
            this._bsv = -1;
         }
         else if(this.TargetHigh != null && Boolean(this.TargetHigh.distance))
         {
            this._bsv = this.TargetHigh.distance;
         }
         else
         {
            this._bsv = Number.POSITIVE_INFINITY;
         }
      }
      
      public function UpdateOnScreenStatus(param1:Boolean) : *
      {
      }
      
      public function GetShowAsSelected() : Boolean
      {
         return this.ShowAsSelected;
      }
      
      public function GetButtonBarPosition(param1:DisplayObject) : Point
      {
         var _loc2_:Rectangle = this.ButtonAnchor_mc.getBounds(param1);
         return new Point(_loc2_.x,_loc2_.y);
      }
      
      protected function UpdateButtons() : *
      {
         var _loc3_:uint = 0;
         var _loc4_:IButton = null;
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         if(this.TargetOnlyData != null)
         {
            _loc3_ = 0;
            while(_loc3_ < ButtonBar_mc.MyButtonManager.NumButtons)
            {
               _loc4_ = ButtonBar_mc.MyButtonManager.GetButtonByIndex(_loc3_) as IButton;
               _loc2_ = this.UpdateButton(_loc4_) || _loc2_;
               _loc1_ = _loc4_.Visible || _loc1_;
               _loc3_++;
            }
         }
         if(this.Divider_mc != null)
         {
            this.Divider_mc.visible = _loc1_;
         }
         if(_loc2_)
         {
            ButtonBar_mc.RefreshButtons();
         }
      }
      
      protected function UpdateButton(param1:IButton) : Boolean
      {
         var _loc2_:Boolean = param1.Visible || param1.Enabled;
         param1.Visible = false;
         param1.Enabled = false;
         return _loc2_;
      }
   }
}
