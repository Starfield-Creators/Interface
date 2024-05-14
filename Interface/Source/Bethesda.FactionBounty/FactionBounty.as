package
{
   import Shared.FactionUtils;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class FactionBounty extends MovieClip
   {
       
      
      public var FactionName_mc:MovieClip;
      
      public var FactionIcon_mc:MovieClip;
      
      public var FactionIconBackground_mc:MovieClip;
      
      public var IconMask_mc:MovieClip;
      
      public var Bounty_mc:MovieClip;
      
      public var Background_Faction_mc:MovieClip;
      
      public var Background_Bounty_mc:MovieClip;
      
      private const PADDING:Number = 15;
      
      private var DefaultPosition:Number = 0;
      
      private var HasValidFaction:Boolean = false;
      
      private var DefaultIconMaskHeight:Number;
      
      public function FactionBounty()
      {
         super();
         this.DefaultPosition = this.x;
         this.DefaultIconMaskHeight = this.IconMask_mc.height;
      }
      
      public function get HasFaction() : Boolean
      {
         return this.HasValidFaction;
      }
      
      public function Show() : void
      {
         this.gotoAndPlay("Open");
      }
      
      public function Hide() : void
      {
         this.gotoAndPlay("Close");
      }
      
      public function AdjustForJumpPanel() : void
      {
         this.x = this.DefaultPosition - this.Background_Faction_mc.width - this.PADDING;
      }
      
      public function ResetPosition() : void
      {
         this.x = this.DefaultPosition;
      }
      
      public function SetFactionInfo(param1:Object) : *
      {
         this.HasValidFaction = param1.hasFaction;
         if(this.HasValidFaction)
         {
            this.Show();
            GlobalFunc.SetText(this.FactionName_mc.text_tf,param1.factionName);
            GlobalFunc.SetText(this.Bounty_mc.BountyAmount_mc.text_tf,param1.bounty);
            this.EnableBountyPanel(param1.bounty != 0);
            this.FactionIcon_mc.gotoAndStop(FactionUtils.GetFactionIconLabel(param1.factionType));
            this.FactionIconBackground_mc.gotoAndStop(FactionUtils.GetFactionIconLabel(param1.factionType));
            if(param1.bounty > 0)
            {
               this.Bounty_mc.gotoAndStop("active");
            }
            else
            {
               this.Bounty_mc.gotoAndStop("inactive");
            }
         }
         else
         {
            this.Hide();
         }
      }
      
      private function EnableBountyPanel(param1:Boolean) : *
      {
         this.Bounty_mc.visible = param1;
         this.Background_Bounty_mc.visible = param1;
         this.IconMask_mc.height = param1 ? this.DefaultIconMaskHeight : this.Background_Faction_mc.height;
      }
   }
}
