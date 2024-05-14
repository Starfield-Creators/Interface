package Shared
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.system.fscommand;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.text.TextLineMetrics;
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import scaleform.gfx.Extensions;
   
   public class GlobalFunc
   {
      
      public static const SELECTED_RECT_ALPHA:Number = 1;
      
      public static const DIMMED_ALPHA:Number = 0.65;
      
      public static const HOLD_BUTTON_DELAY_DEFAULT:uint = 200;
      
      protected static const CLOSE_ENOUGH_EPSILON:Number = 0.001;
      
      public static const PLAY_FOCUS_SOUND:String = "GlobalFunc_PlayFocusSound";
      
      public static const START_GAME_RENDER:String = "GlobalFunc_StartGameRender";
      
      public static const PLAY_MENU_SOUND:String = "GlobalFunc_PlayMenuSound";
      
      public static const USER_EVENT:String = "GlobalFunc_UserEvent";
      
      public static const CLOSE_MENU:String = "GlobalFunc_CloseMenu";
      
      public static const CLOSE_ALL_MENUS:String = "GlobalFunc_CloseAllMenus";
      
      public static const FOCUS_SOUND:String = "UIMenuGeneralFocus";
      
      public static const OK_SOUND:String = "UIMenuGeneralOK";
      
      public static const CANCEL_SOUND:String = "UIMenuGeneralCancel";
      
      public static const COLUMN_SWITCH_SOUND:String = "UIMenuGeneralColumn";
      
      public static const TAB_SWITCH_SOUND:String = "UIMenuGeneralTab";
      
      public static const LONG_PRESS_START_SOUND:String = "UIMenuGeneralLongPressStart";
      
      public static const LONG_PRESS_COMPLETE_SOUND:String = "UIMenuGeneralLongPressComplete";
      
      public static const LONG_PRESS_ABORT_SOUND:String = "UIMenuGeneralLongPressAbort";
      
      protected static const MINUTES_PER_DAY:int = 1440;
      
      protected static const MINUTES_PER_HOUR:int = 60;
      
      public static const NameToTextMap:Object = {
         "Xenon_A":"A",
         "Xenon_B":"B",
         "Xenon_X":"C",
         "Xenon_Y":"D",
         "Xenon_Select":"E",
         "Xenon_LS":"F",
         "Xenon_L1":"G",
         "Xenon_L3":"H",
         "Xenon_L2":"I",
         "Xenon_L2R2":"J",
         "Xenon_RS":"K",
         "Xenon_R1":"L",
         "Xenon_R3":"M",
         "Xenon_R2":"N",
         "Xenon_Start":"O",
         "Xenon_L1R1":"1",
         "_Positive":"P",
         "_Negative":"Q",
         "_Question":"R",
         "_Neutral":"S",
         "Left":"T",
         "Right":"U",
         "Down":"V",
         "Up":"W",
         "Xenon_R2_Alt":"X",
         "Xenon_L2_Alt":"Y",
         "PSN_A":"a",
         "PSN_Y":"b",
         "PSN_X":"c",
         "PSN_B":"d",
         "PSN_Select":"z",
         "PSN_L3":"f",
         "PSN_L1":"g",
         "PSN_L1R1":"h",
         "PSN_LS":"i",
         "PSN_L2":"j",
         "PSN_L2R2":"k",
         "PSN_R3":"l",
         "PSN_R1":"m",
         "PSN_RS":"n",
         "PSN_R2":"o",
         "PSN_Start":"p",
         "DPad_LR":"q",
         "DPad_UD":"r",
         "DPad_All":"s",
         "DPad_Left":"t",
         "DPad_Right":"u",
         "DPad_Down":"v",
         "DPad_Up":"w",
         "PSN_R2_Alt":"x",
         "PSN_L2_Alt":"y",
         "Xenon_L1Xenon_R1":"1",
         "Xenon_L2Xenon_R2":"J",
         "PSN_L1PSN_R1":"h",
         "PSN_L2PSN_R2":"k",
         "DPad_LeftDPad_Right":"q",
         "DPad_DownDPad_Up":"r",
         "DPad_DownDPad_LeftDPad_RightDPad_Up":"s",
         "LeftRight":"q",
         "DownUp":"r",
         "DownLeftRightUp":"s",
         "PCLeft":"←",
         "PCRight":"→",
         "PCDown":"↓",
         "PCUp":"↑",
         "PCLeftRight":"← →",
         "PCDownUp":"↑ ↓",
         "PCDownLeftRightUp":"↑ ↓ ← →",
         "PCMouseWheelDownMouseWheelUp":"Mousewheel"
      };
      
      private static const MetersInLightSeconds:Number = 299792458;
      
      private static const MetersInAU:Number = 149597870700;
      
      private static const MaxMeterDisplay:Number = 10000;
      
      private static const MaxKilometerDisplay:Number = 30000 * 1000;
      
      private static const MaxLightSecondsDisplay:Number = 50000 * MetersInLightSeconds;
      
      private static const MeterPrecision:uint = 0;
      
      private static const KilometerPrecision:uint = 0;
      
      private static const LightSecondPrecision:uint = 1;
      
      private static const AUPrecision:uint = 2;
       
      
      public function GlobalFunc()
      {
         super();
      }
      
      public static function Lerp(param1:Number, param2:Number, param3:Number) : Number
      {
         return param1 + param3 * (param2 - param1);
      }
      
      public static function VectorLerp(param1:Vector3D, param2:Vector3D, param3:Number) : Vector3D
      {
         var _loc4_:Vector3D;
         (_loc4_ = param2.subtract(param1)).scaleBy(param3);
         return param1.add(_loc4_);
      }
      
      public static function MapLinearlyToRange(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Boolean) : Number
      {
         var _loc7_:Number = (param5 - param3) / (param4 - param3);
         var _loc8_:Number = Lerp(param1,param2,_loc7_);
         if(param6)
         {
            if(param1 < param2)
            {
               _loc8_ = Clamp(_loc8_,param1,param2);
            }
            else
            {
               _loc8_ = Clamp(_loc8_,param2,param1);
            }
         }
         return _loc8_;
      }
      
      public static function Clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc4_:Number = param1;
         if(param1 < param2)
         {
            _loc4_ = param2;
         }
         else if(param1 > param3)
         {
            _loc4_ = param3;
         }
         return _loc4_;
      }
      
      public static function PadNumber(param1:Number, param2:uint) : String
      {
         var _loc3_:String = "" + param1;
         while(_loc3_.length < param2)
         {
            _loc3_ = "0" + _loc3_;
         }
         return _loc3_;
      }
      
      public static function FormatTimeString(param1:Number, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : String
      {
         var _loc5_:* = 0;
         var _loc6_:Number = Math.round(param1);
         var _loc7_:int = Math.floor(_loc6_ / 3600);
         _loc5_ = _loc6_ % 3600;
         var _loc8_:int = Math.floor(_loc5_ / 60);
         _loc5_ = _loc6_ % 60;
         var _loc9_:int = Math.round(_loc5_);
         var _loc10_:Boolean = false;
         var _loc11_:* = "";
         if(param2 || _loc7_ > 0)
         {
            _loc11_ = PadNumber(_loc7_,2);
            _loc10_ = true;
         }
         if(param3 || (_loc7_ > 0 || _loc8_ > 0))
         {
            if(_loc10_)
            {
               _loc11_ += ":";
            }
            else
            {
               _loc10_ = true;
            }
            _loc11_ += PadNumber(_loc8_,2);
         }
         if(param4 || (_loc7_ > 0 || _loc8_ > 0 || _loc9_ > 0))
         {
            if(_loc10_)
            {
               _loc11_ += ":";
            }
            _loc11_ += PadNumber(_loc9_,2);
         }
         return _loc11_;
      }
      
      public static function RoundDecimal(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = Math.pow(10,param2);
         return Math.round(_loc3_ * param1) / _loc3_;
      }
      
      public static function RoundDecimalToFixedString(param1:Number, param2:Number) : String
      {
         var _loc3_:Number = RoundDecimal(param1,param2);
         return _loc3_.toFixed(param2);
      }
      
      public static function CloseToNumber(param1:Number, param2:Number, param3:Number = 0.001) : Boolean
      {
         return Math.abs(param1 - param2) < param3;
      }
      
      public static function MaintainTextFormat() : *
      {
         TextField.prototype.SetText = function(param1:String, param2:Boolean = false, param3:Boolean = false):*
         {
            var _loc5_:Number = NaN;
            var _loc6_:Boolean = false;
            if(!param1 || param1 == "")
            {
               param1 = " ";
            }
            if(param3 && param1.charAt(0) != "$")
            {
               param1 = param1.toUpperCase();
            }
            var _loc4_:TextFormat = this.getTextFormat();
            if(param2)
            {
               _loc5_ = Number(_loc4_.letterSpacing);
               _loc6_ = Boolean(_loc4_.kerning);
               this.htmlText = param1;
               (_loc4_ = this.getTextFormat()).letterSpacing = _loc5_;
               _loc4_.kerning = _loc6_;
               this.setTextFormat(_loc4_);
               this.htmlText = param1;
            }
            else
            {
               this.text = param1;
               this.setTextFormat(_loc4_);
               this.text = param1;
            }
         };
      }
      
      public static function FormatNumberToString(param1:Number, param2:uint = 0, param3:Boolean = false) : String
      {
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:* = undefined;
         var _loc9_:String = null;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:int = 0;
         var _loc16_:String = null;
         var _loc17_:* = undefined;
         if(param3)
         {
            if(param2 == 0)
            {
               _loc4_ = int(Math.round(param1)).toString();
            }
            else if(param1 == 0)
            {
               _loc4_ = "0";
            }
            else
            {
               _loc5_ = Math.pow(10,param2);
               if((_loc6_ = int(Math.round(param1 * _loc5_))) == 0)
               {
                  _loc4_ = "0";
               }
               else
               {
                  _loc7_ = false;
                  _loc8_ = 0;
                  _loc9_ = param1.toString();
                  _loc10_ = 0;
                  while(_loc10_ < _loc9_.length)
                  {
                     switch(_loc9_.charAt(_loc10_))
                     {
                        case ".":
                           _loc7_ = true;
                           break;
                        case "0":
                           if(_loc7_)
                           {
                              _loc8_++;
                           }
                           break;
                        default:
                           _loc10_ = _loc9_.length;
                           break;
                     }
                     _loc10_++;
                  }
                  _loc4_ = _loc6_.toString();
                  _loc11_ = 0;
                  while(_loc11_ < _loc8_)
                  {
                     _loc4_ = "0" + _loc4_;
                     _loc11_++;
                  }
                  _loc12_ = _loc4_.length - param2;
                  _loc13_ = _loc4_.substring(0,_loc12_);
                  _loc15_ = (_loc14_ = _loc4_.substring(_loc12_,_loc4_.length)).length - 1;
                  while(_loc15_ >= 0)
                  {
                     if(_loc14_.charAt(_loc15_) != "0")
                     {
                        break;
                     }
                     _loc15_--;
                  }
                  if((_loc16_ = _loc14_.substring(0,_loc15_ + 1)).length > 0)
                  {
                     _loc4_ = _loc13_ + "." + _loc16_;
                  }
                  else
                  {
                     _loc4_ = _loc13_;
                  }
               }
            }
         }
         else if((_loc17_ = (_loc4_ = param1.toString()).indexOf(".")) > -1)
         {
            if(param2)
            {
               _loc4_ = _loc4_.substring(0,Math.min(_loc17_ + param2 + 1,_loc4_.length));
            }
            else
            {
               _loc4_ = _loc4_.substring(0,_loc17_);
            }
         }
         return _loc4_;
      }
      
      public static function ClearClipOfChildren(param1:DisplayObjectContainer) : void
      {
         while(param1.numChildren > 0)
         {
            param1.removeChildAt(0);
         }
      }
      
      public static function FormatDistanceToString(param1:Number) : String
      {
         var _loc2_:* = "";
         if(param1 < MaxMeterDisplay)
         {
            _loc2_ = FormatNumberToString(param1,MeterPrecision) + " M";
         }
         else if(param1 < MaxKilometerDisplay)
         {
            _loc2_ = FormatNumberToString(param1 / 1000,KilometerPrecision) + " KM";
         }
         else if(param1 < MaxLightSecondsDisplay)
         {
            _loc2_ = FormatNumberToString(param1 / MetersInLightSeconds,LightSecondPrecision) + " LS";
         }
         else
         {
            _loc2_ = FormatNumberToString(param1 / MetersInAU,AUPrecision) + " AU";
         }
         return _loc2_;
      }
      
      public static function SetText(param1:TextField, param2:String, param3:Boolean = false, param4:Boolean = false, param5:int = 0, param6:Boolean = false, param7:uint = 0, param8:Array = null, param9:uint = 0, param10:uint = 0) : *
      {
         var _loc12_:Number = NaN;
         var _loc13_:Boolean = false;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         if(!param2 || param2 == "")
         {
            param2 = " ";
         }
         if(param4 && param2.charAt(0) != "$")
         {
            param2 = param2.toUpperCase();
         }
         var _loc11_:TextFormat = param1.getTextFormat();
         if(param3)
         {
            _loc12_ = Number(_loc11_.letterSpacing);
            _loc13_ = Boolean(_loc11_.kerning);
            param1.htmlText = param2;
            if(param8 != null)
            {
               param1.htmlText = DoSubstitutions(param1.htmlText,param8);
            }
            (_loc11_ = param1.getTextFormat()).letterSpacing = _loc12_;
            _loc11_.kerning = _loc13_;
            if(param9 != 0)
            {
               _loc11_.leading = param9;
            }
            param1.setTextFormat(_loc11_);
         }
         else
         {
            param1.text = param2;
            if(param8 != null)
            {
               param1.text = DoSubstitutions(param1.text,param8);
            }
         }
         if(param10 > 0 && param1.numLines > param10)
         {
            param1.text = param1.text.slice(0,param1.getLineOffset(param10) - 1) + "…";
         }
         if(param5 > 0)
         {
            if(param1.text.length > param5)
            {
               param1.text = param1.text.slice(0,param5 - 1) + "…";
            }
            else if(param1.textWidth > param1.width && param1.wordWrap === false)
            {
               _loc14_ = param1.length - 1;
               _loc15_ = 0;
               while(_loc15_ < param1.text.length)
               {
                  if((_loc16_ = param1.getCharBoundaries(_loc15_)).right > param1.x + param1.width)
                  {
                     _loc14_ = _loc15_;
                     break;
                  }
                  _loc15_++;
               }
               param1.text = param1.text.slice(0,_loc14_ - 2) + "…";
            }
         }
         if(param6)
         {
            _loc17_ = param1.x;
            _loc18_ = param1.width;
            _loc19_ = param1.textWidth + 2 * param7;
            switch(_loc11_.align)
            {
               case TextFormatAlign.RIGHT:
                  param1.x += _loc18_ - (_loc19_ + param7);
                  break;
               case TextFormatAlign.CENTER:
                  param1.x += (_loc18_ - _loc19_) / 2;
            }
            param1.width = _loc19_;
            param1.height = param1.textHeight;
         }
      }
      
      public static function SetTwoLineText(param1:TextField, param2:String, param3:int, param4:Boolean = false) : *
      {
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         var _loc5_:int = param3;
         if(param2.length > param3)
         {
            _loc6_ = 0;
            while(_loc6_ <= param3)
            {
               if(param2.charAt(_loc6_) == " " || param2.charAt(_loc6_) == "-")
               {
                  _loc5_ = _loc6_ - 1;
               }
               _loc6_++;
            }
            _loc7_ = _loc5_ + param3;
            GlobalFunc.SetText(param1,param2,false,param4,_loc7_);
         }
         else
         {
            GlobalFunc.SetText(param1,param2,false,param4);
         }
      }
      
      public static function TruncateSingleLineText(param1:TextField) : *
      {
         var _loc2_:int = 0;
         if(param1.text.length > 3)
         {
            _loc2_ = param1.getCharIndexAtPoint(param1.width,0);
            if(_loc2_ > 0)
            {
               param1.replaceText(_loc2_ - 1,param1.length,"…");
            }
         }
      }
      
      public static function SetTruncatedMultilineText(param1:TextField, param2:String, param3:Boolean = false) : *
      {
         var _loc8_:* = null;
         var _loc9_:int = 0;
         var _loc10_:* = undefined;
         var _loc4_:TextLineMetrics = param1.getLineMetrics(0);
         var _loc5_:int = param1.height / _loc4_.height;
         param1.text = "W";
         var _loc6_:int = param1.width / param1.textWidth;
         GlobalFunc.SetText(param1,param2,false,param3);
         var _loc7_:int = Math.min(_loc5_,param1.numLines);
         if(param1.numLines > _loc5_)
         {
            _loc8_ = param2;
            _loc10_ = (_loc9_ = param1.getLineOffset(_loc5_ - 1)) + _loc6_ - 1;
            if(_loc8_.charAt(_loc10_ - 1) == " ")
            {
               _loc10_--;
            }
            _loc8_ = _loc8_.substr(0,_loc10_) + "…";
            GlobalFunc.SetText(param1,_loc8_,false,param3);
         }
      }
      
      public static function DoSubstitutions(param1:String, param2:Array) : String
      {
         var _loc5_:RegExp = null;
         var _loc3_:String = param1;
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc5_ = new RegExp("{[" + _loc4_ + "]}","g");
            _loc3_ = _loc3_.replace(_loc5_,param2[_loc4_]);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function LockToSafeRect(param1:DisplayObject, param2:String, param3:Number = 0, param4:Number = 0, param5:Boolean = false) : *
      {
         var _loc13_:Error = null;
         if(!param1)
         {
            _loc13_ = new Error();
            trace("GlobalFunc::LockToSafeRect -- called with a null or undefined display object\n" + _loc13_.getStackTrace());
            return;
         }
         var _loc6_:Rectangle = Extensions.visibleRect;
         var _loc7_:Point = new Point(_loc6_.x + param3,_loc6_.y + param4);
         var _loc8_:Point = new Point(_loc6_.x + _loc6_.width - param3,_loc6_.y + _loc6_.height - param4);
         var _loc9_:Point = param1.parent.globalToLocal(_loc7_);
         var _loc10_:Point = param1.parent.globalToLocal(_loc8_);
         var _loc11_:Point = Point.interpolate(_loc9_,_loc10_,0.5);
         var _loc12_:Rectangle = param1.getBounds(param1.parent);
         if(param2 == "T" || param2 == "TL" || param2 == "TR" || param2 == "TC")
         {
            if(param5)
            {
               param1.y = _loc9_.y + param1.y - _loc12_.y;
            }
            else
            {
               param1.y = _loc9_.y;
            }
         }
         if(param2 == "CR" || param2 == "CC" || param2 == "CL")
         {
            if(param5)
            {
               param1.y = _loc11_.y + param1.y - _loc12_.y - _loc12_.height / 2;
            }
            else
            {
               param1.y = _loc11_.y;
            }
         }
         if(param2 == "B" || param2 == "BL" || param2 == "BR" || param2 == "BC")
         {
            if(param5)
            {
               param1.y = _loc10_.y - (_loc12_.height + _loc12_.y - param1.y);
            }
            else
            {
               param1.y = _loc10_.y;
            }
         }
         if(param2 == "L" || param2 == "TL" || param2 == "BL" || param2 == "CL")
         {
            if(param5)
            {
               param1.x = _loc9_.x + param1.x - _loc12_.x;
            }
            else
            {
               param1.x = _loc9_.x;
            }
         }
         if(param2 == "TC" || param2 == "CC" || param2 == "BC")
         {
            if(param5)
            {
               param1.x = _loc11_.x + param1.x - _loc12_.x - _loc12_.width / 2;
            }
            else
            {
               param1.x = _loc11_.x;
            }
         }
         if(param2 == "R" || param2 == "TR" || param2 == "BR" || param2 == "CR")
         {
            if(param5)
            {
               param1.x = _loc10_.x - (_loc12_.width + _loc12_.x - param1.x);
            }
            else
            {
               param1.x = _loc10_.x;
            }
         }
      }
      
      public static function AddMovieExploreFunctions() : *
      {
         MovieClip.prototype.getMovieClips = function():Array
         {
            var _loc2_:* = undefined;
            var _loc1_:* = new Array();
            for(_loc2_ in this)
            {
               if(this[_loc2_] is MovieClip && this[_loc2_] != this)
               {
                  _loc1_.push(this[_loc2_]);
               }
            }
            return _loc1_;
         };
         MovieClip.prototype.showMovieClips = function():*
         {
            var _loc1_:* = undefined;
            for(_loc1_ in this)
            {
               if(this[_loc1_] is MovieClip && this[_loc1_] != this)
               {
                  trace(this[_loc1_]);
                  this[_loc1_].showMovieClips();
               }
            }
         };
      }
      
      public static function InspectObject(param1:Object, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc4_:String = getQualifiedClassName(param1);
         trace("Inspecting object with type " + _loc4_);
         trace("{");
         InspectObjectHelper(param1,new Array(),param2,param3);
         trace("}");
      }
      
      private static function InspectObjectHelper(param1:Object, param2:Array, param3:Boolean, param4:Boolean, param5:String = "\t") : void
      {
         var typeDef:XML;
         var member:XML = null;
         var constMember:XML = null;
         var id:String = null;
         var prop:XML = null;
         var propName:String = null;
         var propValue:Object = null;
         var memberName:String = null;
         var memberValue:Object = null;
         var constMemberName:String = null;
         var constMemberValue:Object = null;
         var value:Object = null;
         var subid:String = null;
         var subvalue:Object = null;
         var aObject:Object = param1;
         var aSeenObjects:Array = param2;
         var abRecursive:Boolean = param3;
         var abIncludeProperties:Boolean = param4;
         var astrIndent:String = param5;
         if(aSeenObjects.indexOf(aObject) != -1)
         {
            return;
         }
         aSeenObjects.push(aObject);
         typeDef = describeType(aObject);
         if(abIncludeProperties)
         {
            for each(prop in typeDef.accessor.(@access == "readwrite" || @access == "readonly"))
            {
               propName = prop.@name;
               propValue = aObject[prop.@name];
               trace(astrIndent + propName + " = " + propValue);
               if(abRecursive)
               {
                  InspectObjectHelper(propValue,aSeenObjects,abRecursive,abIncludeProperties,astrIndent + "\t");
               }
            }
         }
         for each(member in typeDef.variable)
         {
            memberName = member.@name;
            memberValue = aObject[memberName];
            trace(astrIndent + memberName + " = " + memberValue);
            if(abRecursive)
            {
               InspectObjectHelper(memberValue,aSeenObjects,abRecursive,abIncludeProperties,astrIndent + "\t");
            }
         }
         for each(constMember in typeDef.constant)
         {
            constMemberName = constMember.@name;
            constMemberValue = aObject[constMemberName];
            trace(astrIndent + constMemberName + " = " + constMemberValue + " --const");
            if(abRecursive)
            {
               InspectObjectHelper(constMemberValue,aSeenObjects,abRecursive,abIncludeProperties,astrIndent + "\t");
            }
         }
         for(id in aObject)
         {
            value = aObject[id];
            trace(astrIndent + id + " = " + value);
            if(abRecursive)
            {
               InspectObjectHelper(value,aSeenObjects,abRecursive,abIncludeProperties,astrIndent + "\t");
            }
            else
            {
               for(subid in value)
               {
                  subvalue = value[subid];
                  trace(astrIndent + "\t" + subid + " = " + subvalue);
               }
            }
         }
      }
      
      public static function GetFullClipPath(param1:DisplayObject) : String
      {
         var _loc2_:DisplayObject = param1;
         var _loc3_:String = "";
         if(_loc2_ == null)
         {
            _loc3_ = "null";
         }
         else
         {
            _loc3_ = _loc2_.name;
            _loc2_ = _loc2_.parent;
            while(_loc2_ != null && !(_loc2_ is Stage))
            {
               _loc3_ = _loc2_.name + "." + _loc3_;
               _loc2_ = _loc2_.parent;
            }
         }
         return _loc3_;
      }
      
      public static function FrameLabelExists(param1:MovieClip, param2:String) : Boolean
      {
         var _loc3_:FrameLabel = null;
         for each(_loc3_ in param1.currentLabels)
         {
            if(_loc3_.name == param2)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function AddReverseFunctions() : *
      {
         MovieClip.prototype.PlayReverseCallback = function(param1:Event):*
         {
            if(param1.currentTarget.currentFrame > 1)
            {
               param1.currentTarget.gotoAndStop(param1.currentTarget.currentFrame - 1);
            }
            else
            {
               param1.currentTarget.removeEventListener(Event.ENTER_FRAME,param1.currentTarget.PlayReverseCallback);
            }
         };
         MovieClip.prototype.PlayReverse = function():*
         {
            if(this.currentFrame > 1)
            {
               this.gotoAndStop(this.currentFrame - 1);
               this.addEventListener(Event.ENTER_FRAME,this.PlayReverseCallback);
            }
            else
            {
               this.gotoAndStop(1);
            }
         };
         MovieClip.prototype.PlayForward = function(param1:String):*
         {
            delete this.onEnterFrame;
            this.gotoAndPlay(param1);
         };
         MovieClip.prototype.PlayForward = function(param1:Number):*
         {
            delete this.onEnterFrame;
            this.gotoAndPlay(param1);
         };
      }
      
      public static function PlayMenuSound(param1:String, param2:String = "", param3:Number = 0) : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(GlobalFunc.PLAY_MENU_SOUND,{
            "sSoundID":param1,
            "sRTPCName":param2,
            "fRTPCValue":param3
         }));
      }
      
      public static function StartGameRender() : *
      {
         BSUIDataManager.dispatchEvent(new Event(GlobalFunc.START_GAME_RENDER));
      }
      
      public static function UserEvent(param1:String, param2:String) : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(GlobalFunc.USER_EVENT,{
            "menuName":param1,
            "eventID":param2
         }));
      }
      
      public static function CloseMenu(param1:String) : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(GlobalFunc.CLOSE_MENU,{"menuName":param1}));
      }
      
      public static function CloseAllMenus() : *
      {
         BSUIDataManager.dispatchEvent(new Event(GlobalFunc.CLOSE_ALL_MENUS));
      }
      
      public static function StringTrim(param1:String) : String
      {
         var _loc5_:String = null;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = param1.length;
         while(param1.charAt(_loc2_) == " " || param1.charAt(_loc2_) == "\n" || param1.charAt(_loc2_) == "\r" || param1.charAt(_loc2_) == "\t")
         {
            _loc2_++;
         }
         _loc3_ = (_loc5_ = param1.substring(_loc2_)).length - 1;
         while(_loc5_.charAt(_loc3_) == " " || _loc5_.charAt(_loc3_) == "\n" || _loc5_.charAt(_loc3_) == "\r" || _loc5_.charAt(_loc3_) == "\t")
         {
            _loc3_--;
         }
         return _loc5_.substring(0,_loc3_ + 1);
      }
      
      public static function GetTextFieldFontSize(param1:TextField) : Number
      {
         return GetFontSize(param1.getTextFormat());
      }
      
      public static function GetFontSize(param1:TextFormat) : Number
      {
         var _loc2_:Number = 12;
         var _loc3_:Object = param1.size;
         return _loc3_ != null ? _loc3_ as Number : _loc2_;
      }
      
      public static function BSASSERT(param1:Boolean, param2:String) : void
      {
         var _loc3_:String = null;
         if(!param1)
         {
            _loc3_ = new Error().getStackTrace();
            fscommand("BSASSERT",param2 + "\nCallstack:\n" + _loc3_);
         }
      }
      
      public static function TraceWarning(param1:String) : void
      {
         var _loc2_:String = new Error().getStackTrace();
         trace("WARNING: " + param1 + _loc2_.substr(_loc2_.indexOf("\n")));
      }
      
      public static function BinarySearchUpperBound(param1:*, param2:Array, param3:String = null) : Object
      {
         var _loc7_:int = 0;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:int = int(param2.length - 1);
         var _loc6_:* = param1;
         if(param3 != null && Boolean(param1.hasOwnProperty(param3)))
         {
            _loc6_ = param1[param3];
         }
         while(_loc4_ <= _loc5_)
         {
            _loc7_ = (_loc4_ + _loc5_) / 2;
            _loc9_ = _loc8_ = param2[_loc7_];
            if(param3 != null)
            {
               _loc9_ = _loc8_[param3];
            }
            if(_loc9_ < _loc6_)
            {
               _loc4_ = _loc7_ + 1;
            }
            else
            {
               if(_loc9_ <= _loc6_)
               {
                  return {
                     "found":true,
                     "index":_loc7_
                  };
               }
               _loc5_ = _loc7_ - 1;
            }
         }
         return {
            "found":false,
            "index":_loc4_
         };
      }
      
      public static function CloneObject(param1:Object) : Object
      {
         var _loc2_:Object = null;
         var _loc5_:* = undefined;
         var _loc3_:String = getQualifiedClassName(param1);
         var _loc4_:Class = getDefinitionByName(_loc3_) as Class;
         if(_loc3_ !== "Array" && typeof param1 != "object")
         {
            _loc2_ = param1;
         }
         else
         {
            _loc2_ = new _loc4_();
            for(_loc5_ in param1)
            {
               _loc2_[_loc5_] = CloneObject(param1[_loc5_]);
            }
         }
         return _loc2_;
      }
      
      public static function FindObjectWithProperty(param1:String, param2:*, param3:Array) : Object
      {
         var _loc4_:uint = 0;
         var _loc6_:* = undefined;
         var _loc5_:uint = param3.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if((_loc6_ = param3[_loc4_])[param1] == param2)
            {
               return _loc6_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public static function FindIndexWithProperty(param1:String, param2:*, param3:Array) : int
      {
         var _loc4_:uint = 0;
         var _loc6_:* = undefined;
         var _loc5_:uint = param3.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if((_loc6_ = param3[_loc4_])[param1] == param2)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return -1;
      }
      
      public static function HasFireForgetEvent(param1:Object, param2:String) : Boolean
      {
         var obj:Object = null;
         var aDataObject:Object = param1;
         var asEventString:String = param2;
         var result:Boolean = false;
         try
         {
            if(aDataObject.aEvents.length > 0)
            {
               for each(obj in aDataObject.aEvents)
               {
                  if(obj.sEventName == asEventString)
                  {
                     result = true;
                     break;
                  }
               }
            }
         }
         catch(e:Error)
         {
            trace(e.getStackTrace() + " The following Fire Forget Event object could not be parsed:");
            GlobalFunc.InspectObject(aDataObject,true);
         }
         return result;
      }
      
      public static function DebugDrawCircle(param1:MovieClip, param2:Point, param3:uint = 16777215, param4:Number = 5) : *
      {
         var _loc5_:Shape;
         (_loc5_ = new Shape()).graphics.beginFill(param3,1);
         _loc5_.graphics.lineStyle(2,0);
         _loc5_.graphics.drawCircle(param2.x,param2.y,param4);
         _loc5_.graphics.endFill();
         param1.addChild(_loc5_);
      }
      
      public static function GetQuestTimeRemainingString(param1:int) : String
      {
         var _loc2_:String = "";
         var _loc3_:* = 0;
         var _loc4_:Number = Math.floor(param1 / MINUTES_PER_DAY);
         _loc3_ = param1 % MINUTES_PER_DAY;
         var _loc5_:Number = Math.floor(_loc3_ / MINUTES_PER_HOUR);
         _loc3_ %= MINUTES_PER_HOUR;
         var _loc6_:Number = Math.floor(_loc3_);
         if(_loc4_ > 0)
         {
            _loc2_ = GlobalFunc.PadNumber(_loc4_,2) + " " + (_loc4_ == 1 ? "$$DAY" : "$$DAYS") + " : " + GlobalFunc.PadNumber(_loc5_,2) + " " + (_loc5_ == 1 ? "$$HOUR" : "$$HOURS");
         }
         else if(_loc5_ >= 2)
         {
            _loc2_ = GlobalFunc.PadNumber(_loc5_,2) + " " + (_loc5_ == 1 ? "$$HOUR" : "$$HOURS");
         }
         else
         {
            _loc2_ = GlobalFunc.PadNumber(_loc5_,2) + " " + (_loc5_ == 1 ? "$$HOUR" : "$$HOURS") + " : " + GlobalFunc.PadNumber(_loc6_,2) + " " + (_loc6_ == 1 ? "$$MINUTE" : "$$MINUTES");
         }
         return _loc2_;
      }
      
      public static function ConvertScreenPercentsToLocalPoint(param1:Number, param2:Number, param3:DisplayObjectContainer) : Point
      {
         var _loc4_:Rectangle = null;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         _loc4_ = Extensions.visibleRect;
         _loc5_ = param1 * _loc4_.width + _loc4_.x;
         _loc6_ = (1 - param2) * _loc4_.height + _loc4_.y;
         var _loc7_:Point = new Point(_loc5_,_loc6_);
         return param3.globalToLocal(_loc7_);
      }
      
      public static function GetRectangleCenter(param1:Rectangle) : Point
      {
         return new Point((param1.topLeft.x + param1.bottomRight.x) / 2,(param1.topLeft.y + param1.bottomRight.y) / 2);
      }
   }
}
