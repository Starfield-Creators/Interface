package Components
{
   import Shared.ColorUtils;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import aze.motion.EazeTween;
   import aze.motion.eaze;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class LabeledMeterMC extends MovieClip
   {
      
      public static const MODE_DEFAULT:uint = EnumHelper.GetEnum(0);
      
      public static const MODE_WEIGHT:uint = EnumHelper.GetEnum();
      
      public static const MODE_PERCENTAGE:uint = EnumHelper.GetEnum();
       
      
      public var NameLabel_tf:TextField;
      
      public var Max_tf:TextField;
      
      public var Current_tf:TextField;
      
      public var Background_mc:MovieClip;
      
      public var Weight_mc:MovieClip;
      
      private var FillBar:Meter;
      
      private var DeltaFillBar:Meter = null;
      
      internal var FillBarColor:uint = 0;
      
      internal var DeltaBarColor:uint = 0;
      
      private var FillBarClip:Shape;
      
      private var DeltaBarClip:Shape;
      
      private var MyTargetFillValue:Number = 0;
      
      private var CurrentFillObject:Object;
      
      private var TargetFillShown:Number = 0;
      
      private var TargetDeltaValue:Number = 0;
      
      private var CurrentDeltaObject:Object;
      
      private var TargetDeltaShown:Number = 0;
      
      private var FillAnimation:EazeTween = null;
      
      private var DeltaAnimation:EazeTween = null;
      
      private var MaxValue:Number = 100;
      
      private var InitializedMaxValue:Boolean = false;
      
      private var LabelPrecision:uint;
      
      private var Suffix:String;
      
      private var FillSpeed:Number = 1.75;
      
      private var EmptySpeed:Number = 1.75;
      
      private var ColorConfig:LabeledMeterColorConfig;
      
      private var CurrentMode:uint = 4294967295;
      
      private var MaxTfVisible:Boolean = true;
      
      public function LabeledMeterMC()
      {
         this.FillBarClip = new Shape();
         this.DeltaBarClip = new Shape();
         this.CurrentFillObject = {"CurrentValue":0};
         this.CurrentDeltaObject = {"CurrentValue":0};
         this.ColorConfig = LabeledMeterColorConfig.CONFIG_DEFAULT_DELTA;
         super();
         this.Max_tf.autoSize = TextFieldAutoSize.RIGHT;
         this.SetMaxValue(this.MaxValue);
         this.SetCurrentValue(0);
         this.SetMode(MODE_DEFAULT);
         this.CorrectInternalScale();
         this.FillBarClip.name = "FillBar";
         this.DeltaBarClip.name = "DeltaBar";
         addChildAt(this.FillBarClip,0);
         addChildAt(this.DeltaBarClip,0);
         this.FillBarClip.x = this.Background_mc.x;
         this.FillBarClip.y = this.Background_mc.y;
         this.DeltaBarClip.x = this.Background_mc.x;
         this.DeltaBarClip.y = this.Background_mc.y;
      }
      
      public function get TargetFillValue() : Number
      {
         return this.MyTargetFillValue;
      }
      
      private function get CurrentFillValue() : Number
      {
         return this.CurrentFillObject.CurrentValue;
      }
      
      private function set CurrentFillValue(param1:Number) : *
      {
         this.CurrentFillObject.CurrentValue = param1;
      }
      
      private function get CurrentDeltaValue() : Number
      {
         return this.CurrentDeltaObject.CurrentValue;
      }
      
      private function set CurrentDeltaValue(param1:Number) : *
      {
         this.CurrentDeltaObject.CurrentValue = param1;
      }
      
      public function get MaximumValue() : Number
      {
         return this.MaxValue;
      }
      
      public function CorrectInternalScale() : *
      {
         var _loc1_:Number = scaleY / scaleX;
         this.NameLabel_tf.scaleX = _loc1_;
         this.Max_tf.scaleX = _loc1_;
         this.Max_tf.x = getBounds(this).right - this.Max_tf.width;
         this.Weight_mc.scaleX = _loc1_;
         this.Current_tf.scaleX = _loc1_;
      }
      
      public function SetColorConfig(param1:LabeledMeterColorConfig) : *
      {
         this.ColorConfig = param1;
         var _loc2_:Number = this.MaxValue != 0 ? this.MyTargetFillValue / this.MaxValue : 0;
         var _loc3_:Number = this.MaxValue != 0 ? this.TargetDeltaValue / this.MaxValue : 0;
         this.SetColorOnClip(this.Background_mc,this.ColorConfig.BackgroundNormal);
         this.Max_tf.textColor = this.ColorConfig.MaxTextNormal;
         this.NameLabel_tf.textColor = this.ColorConfig.NameTextNormal;
         this.UpdateBarColors(_loc2_,_loc3_);
      }
      
      public function SetMode(param1:uint) : *
      {
         if(this.CurrentMode != param1)
         {
            this.CurrentMode = param1;
            this.SetMaxText();
         }
      }
      
      protected function SetMaxText() : void
      {
         switch(this.CurrentMode)
         {
            case MODE_DEFAULT:
               this.SetText(this.Max_tf,this.MaxValue);
               if(this.Weight_mc != null)
               {
                  this.Weight_mc.visible = false;
               }
               break;
            case MODE_WEIGHT:
               GlobalFunc.SetText(this.Max_tf,this.GetMaxWeightString(),true);
               if(this.Weight_mc != null)
               {
                  this.Weight_mc.visible = this.MyTargetFillValue > this.MaxValue;
                  this.Weight_mc.x = this.Max_tf.x - this.Weight_mc.width;
               }
               break;
            case MODE_PERCENTAGE:
               GlobalFunc.SetText(this.Max_tf,this.GetMaxPercentString());
               if(this.Weight_mc != null)
               {
                  this.Weight_mc.visible = false;
               }
         }
      }
      
      private function GetMaxWeightString() : String
      {
         var _loc2_:* = null;
         var _loc1_:String = "";
         if(this.MaxTfVisible)
         {
            _loc1_ = "/" + GlobalFunc.FormatNumberToString(this.MaxValue,this.LabelPrecision);
            _loc2_ = GlobalFunc.FormatNumberToString(this.MyTargetFillValue,this.LabelPrecision);
            if(this.MyTargetFillValue > this.MaxValue)
            {
               _loc2_ = "<font color=\"#" + ColorUtils.UIntToHex(this.ColorConfig.MaxTextNormal) + "\">" + _loc2_ + "</font>";
            }
            _loc1_ = _loc2_ + _loc1_;
            if(this.Suffix != null)
            {
               _loc1_ += this.Suffix;
            }
         }
         return _loc1_;
      }
      
      private function GetMaxPercentString() : String
      {
         var _loc1_:String = "";
         if(this.MaxTfVisible)
         {
            _loc1_ = GlobalFunc.FormatNumberToString(this.MyTargetFillValue,this.LabelPrecision);
            if(this.Suffix != null)
            {
               _loc1_ += this.Suffix;
            }
         }
         return _loc1_;
      }
      
      public function SetLabel(param1:String) : void
      {
         if(this.NameLabel_tf != null)
         {
            GlobalFunc.SetText(this.NameLabel_tf,param1);
         }
      }
      
      public function SetValueSuffix(param1:String) : void
      {
         this.Suffix = param1;
      }
      
      public function SetFillSpeed(param1:Number) : void
      {
         this.FillSpeed = param1;
      }
      
      public function SetEmptySpeed(param1:Number) : void
      {
         this.EmptySpeed = param1;
      }
      
      public function SetLabelPrecision(param1:uint) : void
      {
         if(this.LabelPrecision != param1)
         {
            this.LabelPrecision = param1;
            this.SetMaxText();
            this.SetCurrentText();
         }
      }
      
      protected function SetCurrentText() : void
      {
         switch(this.CurrentMode)
         {
            case MODE_DEFAULT:
               if(this.TargetDeltaValue != 0)
               {
                  this.SetText(this.Current_tf,this.TargetDeltaValue,true);
               }
               else
               {
                  this.SetText(this.Current_tf,this.MyTargetFillValue);
               }
               break;
            case MODE_WEIGHT:
            case MODE_PERCENTAGE:
               if(this.TargetDeltaValue != 0)
               {
                  this.SetText(this.Current_tf,this.TargetDeltaValue);
                  this.Current_tf.visible = true;
               }
               else
               {
                  this.Current_tf.visible = false;
               }
               this.SetMaxText();
         }
         if(this.Current_tf.text != "" && this.FillBarClip.width != 0)
         {
            this.Current_tf.x = this.FillBarClip.width - this.Current_tf.width;
            if(this.Current_tf.x < this.Current_tf.textWidth * 2)
            {
               this.Current_tf.x = GlobalFunc.MapLinearlyToRange(this.Current_tf.textWidth,this.Current_tf.textWidth * 2,0,this.Current_tf.textWidth,this.Current_tf.x,false);
            }
         }
      }
      
      public function SetCurrentValue(param1:Number, param2:Number = 0) : void
      {
         this.UpdatePercent(param1,param2,true);
      }
      
      public function SetTargetCurrentValue(param1:Number, param2:Number = 0) : void
      {
         this.UpdatePercent(param1,param2,false);
      }
      
      public function SetMaxValue(param1:int) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(!this.InitializedMaxValue || param1 != this.MaxValue)
         {
            this.InitializedMaxValue = true;
            _loc2_ = this.CurrentFillValue;
            _loc3_ = this.CurrentDeltaValue;
            this.MaxValue = param1;
            this.SetMaxText();
            this.UpdatePercent(_loc2_,_loc3_,true);
         }
      }
      
      public function SetSuffix(param1:String) : *
      {
         this.Suffix = param1;
         this.SetMaxText();
         this.SetCurrentText();
      }
      
      public function SetPercent(param1:Number) : void
      {
         this.SetCurrentValue(this.MaxValue * param1);
      }
      
      public function SetTargetPercent(param1:Number) : void
      {
         this.SetTargetCurrentValue(this.MaxValue * param1);
      }
      
      private function UpdateBarColors(param1:Number, param2:Number) : *
      {
         this.FillBarColor = this.ColorConfig.FillNormal;
         if(param1 > 1)
         {
            this.FillBarColor = this.ColorConfig.FillOverflow;
         }
         if(param1 + param2 > 1)
         {
            this.DeltaBarColor = this.ColorConfig.DeltaOverflow;
            this.Current_tf.textColor = this.ColorConfig.CurrTextOverflow;
         }
         else if(param2 < 0)
         {
            this.DeltaBarColor = this.ColorConfig.DeltaNegative;
            this.Current_tf.textColor = this.ColorConfig.CurrTextNegative;
         }
         else if(param2 > 0)
         {
            this.DeltaBarColor = this.ColorConfig.DeltaPositive;
            this.Current_tf.textColor = this.ColorConfig.CurrTextPositive;
         }
         else
         {
            this.Current_tf.textColor = this.ColorConfig.CurrTextNormal;
         }
      }
      
      private function SetColorOnClip(param1:MovieClip, param2:uint) : *
      {
         var _loc3_:ColorTransform = param1.transform.colorTransform;
         _loc3_.color = param2;
         param1.transform.colorTransform = _loc3_;
      }
      
      private function UpdateFillGeometry() : *
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc1_:Number = this.MaxValue != 0 ? this.CurrentFillValue / this.MaxValue : 0;
         _loc1_ = GlobalFunc.Clamp(_loc1_,0,1);
         this.FillBarClip.graphics.clear();
         this.DeltaBarClip.graphics.clear();
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         if(this.CurrentDeltaValue == 0)
         {
            _loc5_ = this.Background_mc.width * _loc1_;
            this.FillBarClip.graphics.beginFill(this.FillBarColor);
            this.FillBarClip.graphics.drawRect(0,0,_loc5_,this.Background_mc.height);
            this.FillBarClip.graphics.endFill();
         }
         else if(this.CurrentDeltaValue > 0)
         {
            _loc2_ = this.MaxValue != 0 ? (this.CurrentFillValue - this.CurrentDeltaValue) / this.MaxValue : 0;
            _loc2_ = GlobalFunc.Clamp(_loc2_,0,1);
            _loc3_ = this.Background_mc.width * _loc2_;
            this.FillBarClip.graphics.beginFill(this.FillBarColor);
            this.FillBarClip.graphics.drawRect(0,0,_loc3_,this.Background_mc.height);
            this.FillBarClip.graphics.endFill();
            _loc4_ = this.Background_mc.width * _loc1_;
            this.FillBarClip.graphics.beginFill(this.DeltaBarColor);
            this.FillBarClip.graphics.drawRect(_loc3_,0,_loc4_ - _loc3_,this.Background_mc.height);
            this.FillBarClip.graphics.endFill();
         }
         else if(this.CurrentDeltaValue < 0)
         {
            _loc2_ = this.MaxValue != 0 ? this.CurrentFillValue / this.MaxValue : 0;
            _loc2_ = GlobalFunc.Clamp(_loc2_,0,1);
            _loc3_ = this.Background_mc.width * _loc2_;
            this.FillBarClip.graphics.beginFill(this.FillBarColor);
            this.FillBarClip.graphics.drawRect(0,0,_loc3_,this.Background_mc.height);
            this.FillBarClip.graphics.endFill();
            _loc6_ = this.MaxValue != 0 ? (this.CurrentFillValue + Math.abs(this.CurrentDeltaValue)) / this.MaxValue : 0;
            _loc6_ = GlobalFunc.Clamp(_loc6_,0,1);
            _loc4_ = this.Background_mc.width * _loc6_;
            this.FillBarClip.graphics.beginFill(this.DeltaBarColor);
            this.FillBarClip.graphics.drawRect(_loc3_,0,_loc4_ - _loc3_,this.Background_mc.height);
            this.FillBarClip.graphics.endFill();
         }
      }
      
      private function UpdatePercent(param1:Number, param2:Number, param3:Boolean) : void
      {
         var percent:Number;
         var deltaPercent:Number;
         var delta:Number = NaN;
         var duration:Number = NaN;
         var afCurrentValue:Number = param1;
         var afDeltaValue:Number = param2;
         var abImmediate:Boolean = param3;
         this.MyTargetFillValue = afCurrentValue;
         this.TargetDeltaValue = afDeltaValue;
         percent = this.MaxValue != 0 ? afCurrentValue / this.MaxValue : 0;
         deltaPercent = this.MaxValue != 0 ? afDeltaValue / this.MaxValue : 0;
         this.UpdateBarColors(percent,deltaPercent);
         if(afCurrentValue + afDeltaValue > this.MaxValue)
         {
            afDeltaValue = Math.max(this.MaxValue - afCurrentValue,0);
            afCurrentValue = Math.min(afCurrentValue,this.MaxValue);
         }
         if(afDeltaValue < 0)
         {
            afCurrentValue += afDeltaValue;
            afDeltaValue = -afDeltaValue;
            if(afCurrentValue + afDeltaValue > this.MaxValue)
            {
               afDeltaValue = this.MaxValue - afCurrentValue;
            }
         }
         if(abImmediate)
         {
            if(this.FillAnimation != null)
            {
               this.FillAnimation.kill();
               this.FillAnimation = null;
            }
            if(this.DeltaAnimation != null)
            {
               this.DeltaAnimation.kill();
               this.DeltaAnimation = null;
            }
            this.CurrentFillValue = this.MyTargetFillValue;
            this.CurrentDeltaValue = this.TargetDeltaValue;
            this.UpdateFillGeometry();
         }
         else
         {
            if(this.TargetFillShown != afCurrentValue)
            {
               if(this.FillAnimation != null)
               {
                  this.FillAnimation.kill();
               }
               delta = (afCurrentValue - this.CurrentFillValue) / this.MaxValue;
               duration = delta > 0 ? delta / this.FillSpeed : -delta / this.EmptySpeed;
               this.FillAnimation = eaze(this.CurrentFillObject).to(duration,{"CurrentValue":afCurrentValue}).onUpdate(function():*
               {
                  UpdateFillGeometry();
                  SetCurrentText();
               }).onComplete(function():*
               {
                  FillAnimation.kill();
                  FillAnimation = null;
               });
            }
            if(this.TargetDeltaShown != afDeltaValue)
            {
               if(this.DeltaAnimation != null)
               {
                  this.DeltaAnimation.kill();
               }
               delta = (afDeltaValue - this.CurrentDeltaValue) / this.MaxValue;
               duration = delta > 0 ? delta / this.FillSpeed : -delta / this.EmptySpeed;
               this.DeltaAnimation = eaze(this.CurrentDeltaObject).to(duration,{"CurrentValue":afDeltaValue}).onUpdate(function():*
               {
                  UpdateFillGeometry();
                  SetCurrentText();
               }).onComplete(function():*
               {
                  DeltaAnimation.kill();
                  DeltaAnimation = null;
               });
            }
         }
         this.TargetFillShown = afCurrentValue;
         this.TargetDeltaShown = afDeltaValue;
         this.SetCurrentText();
      }
      
      private function SetText(param1:TextField, param2:Number, param3:Boolean = false) : void
      {
         var _loc4_:String = null;
         if(param1 != null)
         {
            _loc4_ = GlobalFunc.FormatNumberToString(param2,this.LabelPrecision);
            if(this.Suffix != null)
            {
               _loc4_ += this.Suffix;
            }
            if(param3 && param2 > 0 && _loc4_ != "0")
            {
               _loc4_ = "+" + _loc4_;
            }
            GlobalFunc.SetText(param1,_loc4_);
         }
      }
      
      public function SetMaxTfVisible(param1:Boolean) : *
      {
         this.MaxTfVisible = param1;
         this.SetMaxText();
      }
   }
}
