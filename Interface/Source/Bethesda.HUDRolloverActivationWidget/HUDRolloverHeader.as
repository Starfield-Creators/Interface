package
{
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class HUDRolloverHeader extends MovieClip
   {
      
      public static const HDT_NONE:uint = EnumHelper.GetEnum(0);
      
      public static const HDT_LOAD_DOOR:uint = EnumHelper.GetEnum();
      
      public static const HDT_CELL_DOOR:uint = EnumHelper.GetEnum();
      
      private static const BASIC:int = EnumHelper.GetEnum(0);
      
      private static const SINGLE_ITEM:int = EnumHelper.GetEnum();
      
      private static const INVENTORY:int = EnumHelper.GetEnum();
       
      
      public var Name_mc:MovieClip;
      
      public var RarityIcon_mc:MovieClip;
      
      public var ResourceIcon_mc:MovieClip;
      
      public var DoorIcon_mc:MovieClip;
      
      public var Contraband_mc:MovieClip;
      
      public var Stealing_mc:MovieClip;
      
      public var Tagged_mc:MovieClip;
      
      public var BGAnim1_mc:MovieClip;
      
      public var BGAnim2_mc:MovieClip;
      
      private var IsArtifact:Boolean;
      
      private var WasShowing:Boolean = false;
      
      private var PlayingArtifactAnim:Boolean = false;
      
      private const BG_WIDTH_SPACING:Number = 8;
      
      private const NAME_SPACING:Number = 5;
      
      private const NAME_MAX_LENGTH:uint = 40;
      
      private const NAME_TRUNCATION_FOR_ICONS_BASE:* = 1;
      
      private const NAME_TRUNCATION_PER_ICON:* = 2;
      
      private const NAME_TRUNCATION_FOR_RARITY_SYMBOL:* = 5;
      
      private var ORIG_NAME_X:Number;
      
      public function HUDRolloverHeader()
      {
         super();
         this.ORIG_NAME_X = this.Name_tf.x;
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.ResourceIcon_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Name_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      private function get Name_tf() : TextField
      {
         return this.Name_mc.Text_mc.Text_tf;
      }
      
      public function ApplyData(param1:Object) : void
      {
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         this.IsArtifact = param1.bIsArtifact;
         if(!this.WasShowing)
         {
            this.PlayingArtifactAnim = false;
            gotoAndPlay("AnimIn");
         }
         else if(!this.IsArtifact && this.PlayingArtifactAnim)
         {
            this.PlayingArtifactAnim = false;
            gotoAndStop("AnimFinished");
         }
         else if(this.IsArtifact && currentFrameLabel == "AnimFinished")
         {
            this.OnAnimInFinished();
         }
         this.WasShowing = param1.bShowRolloverActivation;
         if(param1.uResourceColor != 0)
         {
            GlobalFunc.SetText(this.ResourceIcon_mc.Text_tf,param1.sResourceSymbol);
            this.ResourceIcon_mc.Background_mc.width = this.ResourceIcon_mc.Text_tf.getLineMetrics(0).width + this.BG_WIDTH_SPACING;
            (_loc8_ = new ColorTransform()).color = param1.uResourceColor;
            this.ResourceIcon_mc.Background_mc.transform.colorTransform = _loc8_;
            this.ResourceIcon_mc.visible = true;
            this.Name_tf.x = this.ResourceIcon_mc.Background_mc.x + this.ResourceIcon_mc.Background_mc.width + this.NAME_SPACING;
         }
         else
         {
            this.ResourceIcon_mc.visible = false;
            this.Name_tf.x = this.ORIG_NAME_X;
         }
         var _loc2_:Number = Number(param1.uDoorIcon);
         this.DoorIcon_mc.visible = _loc2_ != HDT_NONE;
         if(_loc2_ != HDT_NONE)
         {
            this.DoorIcon_mc.gotoAndStop(_loc2_);
         }
         if(param1.uMode == BASIC || param1.uMode == SINGLE_ITEM)
         {
            this.Contraband_mc.visible = param1.bContraband;
            this.Stealing_mc.visible = !param1.bContraband && Boolean(param1.bStealing);
            this.Tagged_mc.visible = param1.bIsTrackedForCrafting;
         }
         else
         {
            this.Contraband_mc.visible = false;
            this.Stealing_mc.visible = false;
            this.Tagged_mc.visible = false;
         }
         var _loc3_:uint = param1.uRarity != null ? uint(param1.uRarity) : uint(InventoryItemUtils.RARITY_STANDARD);
         var _loc4_:* = InventoryItemUtils.GetFrameLabelFromRarity(_loc3_);
         if(!this.PlayingArtifactAnim)
         {
            _loc9_ = (this.Tagged_mc.visible ? 1 : 0) + (this.Stealing_mc.visible || this.Contraband_mc.visible ? 1 : 0);
            _loc10_ = this.NAME_MAX_LENGTH;
            if(_loc9_ > 0)
            {
               _loc10_ -= this.NAME_TRUNCATION_PER_ICON * _loc9_ + this.NAME_TRUNCATION_FOR_ICONS_BASE;
            }
            if(_loc3_ > 0)
            {
               _loc10_ -= this.NAME_TRUNCATION_FOR_RARITY_SYMBOL;
            }
            GlobalFunc.SetText(this.Name_tf,param1.sHeaderText,false,true,_loc10_);
         }
         var _loc5_:Number = 25;
         var _loc6_:Number = 5;
         var _loc7_:Number = this.Name_mc.x + this.Name_tf.textWidth + _loc5_;
         if(this.Contraband_mc.visible)
         {
            this.Contraband_mc.x = _loc7_;
            _loc7_ += this.Contraband_mc.width + _loc6_;
         }
         if(this.Stealing_mc.visible)
         {
            this.Stealing_mc.x = _loc7_;
            _loc7_ += this.Stealing_mc.width + _loc6_;
         }
         if(this.Tagged_mc.visible)
         {
            this.Tagged_mc.x = _loc7_;
            _loc7_ += this.Tagged_mc.width + _loc6_;
         }
         this.BGAnim1_mc.gotoAndStop(_loc4_);
         this.BGAnim2_mc.gotoAndStop(_loc4_);
         this.RarityIcon_mc.gotoAndStop(_loc4_);
         this.Name_mc.gotoAndStop(_loc4_);
      }
      
      private function OnAnimInFinished() : void
      {
         if(this.IsArtifact)
         {
            GlobalFunc.SetText(this.Name_tf,"",false,true);
            this.PlayingArtifactAnim = true;
            gotoAndPlay("Artifact");
         }
      }
   }
}
