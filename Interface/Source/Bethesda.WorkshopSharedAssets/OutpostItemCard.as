package
{
   import Components.ModularPanelObject;
   import Shared.GlobalFunc;
   import Shared.WorkshopUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextFieldAutoSize;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class OutpostItemCard extends ModularPanelObject
   {
       
      
      public var NameSection_mc:MovieClip;
      
      public var BuildCountSection_mc:MovieClip;
      
      public var BuildReqsSection_mc:MovieClip;
      
      public var InputReqsSection_mc:MovieClip;
      
      public var ProductionSection_mc:MovieClip;
      
      public var DescriptionSection_mc:MovieClip;
      
      public var AttributeReqsSection_mc:MovieClip;
      
      public var IntegritySection_mc:MovieClip;
      
      public var ConnectionsSection_mc:MovieClip;
      
      public var CargoLinkSection_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      public var BottomDivider_mc:MovieClip;
      
      private var _sectionsArray:Array;
      
      private var _openStarted:Boolean = false;
      
      private var _dataReady:Boolean = false;
      
      private var _largeTextMode:Boolean = false;
      
      private var _descPadding:Number = 0;
      
      private const REQ_COLUMNS:Number = 1;
      
      private const REQ_ROWS:Number = 12;
      
      private const REQ_COLUMNS_SPACING:Number = 0;
      
      private const REQ_ROWS_SPACING:Number = 3;
      
      private const REQ_HORIZONTAL_PADDING:Number = 0;
      
      private const REQ_VERTICAL_PADDING:Number = 14;
      
      private const LINK_COLUMNS:Number = 1;
      
      private const LINK_ROWS:Number = 8;
      
      private const LINK_COLUMNS_SPACING:Number = 0;
      
      private const LINK_ROWS_SPACING:Number = 3;
      
      private const ICON_PADDING_TITLE:Number = 12;
      
      private const ICON_PADDING:Number = 6;
      
      private const LINK_PADDING:Number = 5;
      
      private const MAX_SKILLS:Number = 2;
      
      private const SKILL_HEADER_SPACING:Number = 7.5;
      
      private const SKILL_SPACING:Number = 20;
      
      private const MAX_DESC_CHARS:int = 26;
      
      private const MAX_DESC_LINES:int = 11;
      
      private const DESC_LINES_FOR_PADDING:int = 4;
      
      private const DESC_PADDING:Number = 10;
      
      public function OutpostItemCard()
      {
         this._sectionsArray = [];
         super();
         Extensions.enabled = true;
         if(!this._largeTextMode)
         {
            TextFieldEx.setTextAutoSize(this.NameSection_mc.Name_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.BuildReqsSection_mc.ReqLabel_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.InputReqsSection_mc.ReqLabel_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.ProductionSection_mc.ProductionLabel_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.ProductionSection_mc.ProductionContent_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.CargoLinkSection_mc.CargoLinkLabel_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.CargoLinkSection_mc.IncomingLabel_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.ConnectionsSection_mc.SourceLabel_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.ConnectionsSection_mc.Source_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.ConnectionsSection_mc.TargetLabel_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.ConnectionsSection_mc.Target_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         this.BuildReqsSection_mc.RequirementsList_mc.Configure(CostCard_Entry,this.REQ_COLUMNS,this.REQ_ROWS,this.REQ_COLUMNS_SPACING,this.REQ_ROWS_SPACING,this.REQ_HORIZONTAL_PADDING,this.REQ_VERTICAL_PADDING);
         this.InputReqsSection_mc.RequirementsList_mc.Configure(CostCard_Entry,this.REQ_COLUMNS,this.REQ_ROWS,this.REQ_COLUMNS_SPACING,this.REQ_ROWS_SPACING,this.REQ_HORIZONTAL_PADDING,this.REQ_VERTICAL_PADDING);
         this.CargoLinkSection_mc.CargoLinkList_mc.Configure(CargoLinkResourceEntry,this.LINK_COLUMNS,this.LINK_ROWS,this.LINK_COLUMNS_SPACING,this.LINK_ROWS_SPACING);
         GlobalFunc.SetText(this.BuildReqsSection_mc.ReqLabel_mc.Text_tf,"$Build Requirements:");
         GlobalFunc.SetText(this.InputReqsSection_mc.ReqLabel_mc.Text_tf,"$Operating Cost:");
         this.InitializeSections();
         addEventListener("NextAnimation",this.PlayNextAnimation);
         TextFieldEx.setNoTranslate(this.DescriptionSection_mc.Description_mc.Text_tf,true);
         this.DescriptionSection_mc.Description_mc.Text_tf.autoSize = TextFieldAutoSize.LEFT;
         this.DescriptionSection_mc.Description_mc.Text_tf.multiline = true;
      }
      
      public function get sectionsArray() : Array
      {
         return this._sectionsArray;
      }
      
      public function set show(param1:Boolean) : void
      {
         this.visible = param1;
         this.Open();
      }
      
      override public function PlayNextAnimation() : *
      {
         super.PlayNextAnimation();
         if(NextInQueue == InfoPanelArray.length)
         {
            this.BottomDivider_mc.gotoAndPlay(WorkshopUtils.OPEN_FRAME);
         }
      }
      
      public function Close(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         if(param1)
         {
            this.gotoAndPlay(WorkshopUtils.CLOSE_FRAME);
            _loc2_ = 0;
            while(_loc2_ < this.sectionsArray.length)
            {
               this.sectionsArray[_loc2_].gotoAndPlay(WorkshopUtils.CLOSE_FRAME);
               _loc2_++;
            }
         }
         else
         {
            this.gotoAndStop(WorkshopUtils.HIDDEN_FRAME);
         }
         this.BottomDivider_mc.gotoAndStop(WorkshopUtils.HIDDEN_FRAME);
         ContractBackgroundHeight(this.Background_mc);
      }
      
      private function Open() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         if(!this._openStarted && this._dataReady && this.visible)
         {
            this._openStarted = true;
            _loc1_ = 0;
            while(_loc1_ < this.sectionsArray.length)
            {
               _loc2_ = this.sectionsArray[_loc1_];
               if(_loc2_.visible)
               {
                  AddToInfoPanelArray(_loc2_);
               }
               else
               {
                  _loc2_.gotoAndStop(WorkshopUtils.SHOWN_FRAME);
               }
               _loc1_++;
            }
            this.gotoAndPlay(WorkshopUtils.OPEN_FRAME);
            OpenBackgroundAnimation(this.Background_mc);
         }
      }
      
      private function InitializeSections() : void
      {
         var _loc2_:MovieClip = null;
         this.sectionsArray.push(this.NameSection_mc);
         this.sectionsArray.push(this.BuildCountSection_mc);
         this.sectionsArray.push(this.BuildReqsSection_mc);
         this.sectionsArray.push(this.InputReqsSection_mc);
         this.sectionsArray.push(this.ProductionSection_mc);
         this.sectionsArray.push(this.DescriptionSection_mc);
         this.sectionsArray.push(this.AttributeReqsSection_mc);
         this.sectionsArray.push(this.IntegritySection_mc);
         this.sectionsArray.push(this.ConnectionsSection_mc);
         this.sectionsArray.push(this.CargoLinkSection_mc);
         var _loc1_:uint = 0;
         while(_loc1_ < this.sectionsArray.length)
         {
            _loc2_ = this.sectionsArray[_loc1_];
            _loc2_.hasData = false;
            _loc1_++;
         }
      }
      
      public function UpdateItemData(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:* = null;
         var _loc10_:int = 0;
         var _loc11_:* = undefined;
         if(param1 != null)
         {
            this._dataReady = param1.sDisplayName != "";
            this.NameSection_mc.hasData = param1.sDisplayName != "";
            WorkshopUtils.SetSingleLineText(this.NameSection_mc.Name_mc.Text_tf,param1.sDisplayName,this._largeTextMode);
            this.NameSection_mc.IconHolder_mc.ResourceIcon_mc.gotoAndStop(WorkshopUtils.GetResourceIconFrameLabel(param1.uResourceType));
            _loc2_ = this.NameSection_mc.Name_mc.Text_tf.x + this.NameSection_mc.Name_mc.Text_tf.getLineMetrics(0).width + this.ICON_PADDING_TITLE;
            this.NameSection_mc.IconHolder_mc.x = _loc2_;
            this.BuildCountSection_mc.hasData = param1.sBuildCount != "";
            GlobalFunc.SetText(this.BuildCountSection_mc.BuildCounts_mc.Text_tf,param1.sBuildCount);
            if(param1.hasOwnProperty("aBuildRequirements"))
            {
               this.BuildReqsSection_mc.hasData = param1.aBuildRequirements.length > 0;
               this.BuildReqsSection_mc.RequirementsList_mc.entryData = param1.aBuildRequirements;
            }
            this.InputReqsSection_mc.hasData = param1.aInputRequirements.length > 0;
            this.InputReqsSection_mc.RequirementsList_mc.entryData = param1.aInputRequirements;
            this.ProductionSection_mc.hasData = param1.aResourcesProduced.length > 0;
            _loc3_ = WorkshopUtils.GetProducedResourcesString(param1.aResourcesProduced);
            WorkshopUtils.SetSingleLineText(this.ProductionSection_mc.ProductionContent_mc.Text_tf,_loc3_,this._largeTextMode);
            _loc4_ = WorkshopUtils.GetResourceIconFrameLabel(WorkshopUtils.WRT_NONE);
            _loc5_ = false;
            _loc6_ = 0;
            while(_loc6_ < param1.aResourcesProduced.length)
            {
               _loc4_ = WorkshopUtils.GetResourceIconFrameLabel(param1.aResourcesProduced[_loc6_].uResourceType);
               if(!_loc5_)
               {
                  _loc5_ = Boolean(param1.aResourcesProduced[_loc6_].bTracking);
               }
               _loc6_++;
            }
            this.ProductionSection_mc.IconHolder_mc.ResourceIcon_mc.gotoAndStop(_loc4_);
            _loc2_ = this.ProductionSection_mc.ProductionContent_mc.x + (this.ProductionSection_mc.ProductionContent_mc.width - this.ProductionSection_mc.ProductionContent_mc.Text_tf.getLineMetrics(0).width) - this.ProductionSection_mc.IconHolder_mc.width - this.ICON_PADDING;
            this.ProductionSection_mc.IconHolder_mc.x = _loc2_;
            this.ProductionSection_mc.Tagged_mc.x = _loc2_ - this.ProductionSection_mc.Tagged_mc.width;
            this.ProductionSection_mc.Tagged_mc.visible = _loc5_;
            if(param1.hasOwnProperty("fIntegrity"))
            {
               this.IntegritySection_mc.hasData = param1.fIntegrity > -1;
               if(param1.fIntegrity > -1)
               {
                  _loc8_ = GlobalFunc.MapLinearlyToRange(1,this.IntegritySection_mc.IntegrityMeter_mc.framesLoaded,0,1,param1.fIntegrity,true);
                  this.IntegritySection_mc.IntegrityMeter_mc.gotoAndStop(_loc8_);
               }
            }
            this.DescriptionSection_mc.hasData = param1.sDescription != "";
            GlobalFunc.SetText(this.DescriptionSection_mc.Description_mc.Text_tf,param1.sDescription);
            if(this.DescriptionSection_mc.Description_mc.Text_tf.numLines > this.DESC_LINES_FOR_PADDING)
            {
               this._descPadding = this.DESC_PADDING;
            }
            else
            {
               this._descPadding = 0;
            }
            _loc7_ = Math.min(this.MAX_DESC_LINES,this.DescriptionSection_mc.Description_mc.Text_tf.numLines);
            if(this.DescriptionSection_mc.Description_mc.Text_tf.numLines > this.MAX_DESC_LINES)
            {
               _loc9_ = String(this.DescriptionSection_mc.Description_mc.Text_tf.text);
               _loc11_ = (_loc10_ = int(this.DescriptionSection_mc.Description_mc.Text_tf.getLineOffset(this.MAX_DESC_LINES - 1))) + this.MAX_DESC_CHARS - 1;
               if(_loc9_.charAt(_loc11_ - 1) == " ")
               {
                  _loc11_--;
               }
               _loc9_ = _loc9_.substr(0,_loc11_) + "…";
               GlobalFunc.SetText(this.DescriptionSection_mc.Description_mc.Text_tf,_loc9_);
            }
            this.AttributeReqsSection_mc.hasData = param1.aRequiredAttributes.length > 0;
            this.UpdateAttributes(param1.aRequiredAttributes);
            if(param1.hasOwnProperty("bIsCargoLink"))
            {
               this.CargoLinkSection_mc.hasData = param1.bIsCargoLink;
               this.UpdateCargoLinkInfo(param1.cargoLinkData);
            }
            if(param1.hasOwnProperty("sSourceName"))
            {
               this.ConnectionsSection_mc.hasData = param1.sSourceName != "" || param1.sTargetName != "";
               WorkshopUtils.SetSingleLineText(this.ConnectionsSection_mc.Source_mc.Text_tf,param1.sSourceName,this._largeTextMode);
               WorkshopUtils.SetSingleLineText(this.ConnectionsSection_mc.Target_mc.Text_tf,param1.sTargetName,this._largeTextMode);
            }
         }
         this.UpdateSections();
         this.Open();
      }
      
      private function UpdateAttributes(param1:Array) : void
      {
         var _loc2_:Number = this.AttributeReqsSection_mc.AttributesLabel_mc.y + this.AttributeReqsSection_mc.AttributesLabel_mc.height + this.SKILL_HEADER_SPACING;
         var _loc3_:uint = 0;
         var _loc4_:AttributeIcon = null;
         _loc3_ = 0;
         while(_loc3_ < this.MAX_SKILLS && _loc3_ < param1.length)
         {
            (_loc4_ = this.GetAttributeClip(_loc3_)).LoadClip(param1[_loc3_]);
            _loc4_.y = _loc2_;
            _loc4_.visible = true;
            _loc2_ += _loc4_.height + this.SKILL_SPACING;
            _loc3_++;
         }
         while(_loc3_ < this.MAX_SKILLS)
         {
            (_loc4_ = this.GetAttributeClip(_loc3_)).y = 0;
            _loc4_.visible = false;
            _loc3_++;
         }
         this.AttributeReqsSection_mc.Sizer_mc.height = _loc2_;
      }
      
      private function GetAttributeClip(param1:uint) : AttributeIcon
      {
         return this.AttributeReqsSection_mc["Attribute" + param1 + "_mc"];
      }
      
      private function UpdateCargoLinkInfo(param1:Object) : void
      {
         var _loc2_:String = param1.sLinkedOutpostName != "" ? String(param1.sLinkedOutpostName) : "$None";
         WorkshopUtils.SetSingleLineText(this.CargoLinkSection_mc.CargoLinkLabel_mc.Text_tf,_loc2_,this._largeTextMode);
         var _loc3_:* = param1.aIncomingResources.length > 0;
         this.CargoLinkSection_mc.IncomingLabel_mc.visible = _loc3_;
         this.CargoLinkSection_mc.IncomingLabel_mc.y = _loc3_ ? this.CargoLinkSection_mc.CargoLinkLabel_mc.y + this.CargoLinkSection_mc.CargoLinkLabel_mc.height + this.LINK_PADDING : this.CargoLinkSection_mc.CargoLinkLabel_mc.y;
         this.CargoLinkSection_mc.CargoLinkList_mc.entryData = param1.aIncomingResources;
         this.CargoLinkSection_mc.CargoLinkList_mc.y = _loc3_ ? this.CargoLinkSection_mc.IncomingLabel_mc.y + this.CargoLinkSection_mc.IncomingLabel_mc.height + this.LINK_PADDING : this.CargoLinkSection_mc.CargoLinkLabel_mc.y + this.CargoLinkSection_mc.CargoLinkLabel_mc.height;
      }
      
      private function UpdateSections() : void
      {
         var _loc3_:MovieClip = null;
         var _loc1_:Number = 0;
         var _loc2_:uint = 0;
         while(_loc2_ < this.sectionsArray.length)
         {
            _loc3_ = this.sectionsArray[_loc2_];
            _loc3_.visible = _loc3_.hasData;
            if(_loc3_.visible)
            {
               _loc3_.y = _loc1_;
               _loc1_ += _loc3_.height;
               if(_loc3_ === this.DescriptionSection_mc)
               {
                  _loc1_ += this._descPadding;
               }
            }
            _loc2_++;
         }
         this.Background_mc.height = _loc1_ != 0 ? _loc1_ : 1;
         this.BottomDivider_mc.y = this.Background_mc.height - 1;
      }
   }
}
