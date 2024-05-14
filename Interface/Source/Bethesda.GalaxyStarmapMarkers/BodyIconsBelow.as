package
{
   import Components.IconOrganizer;
   
   public class BodyIconsBelow extends IconOrganizer
   {
       
      
      private const PLAYER_SHIP_ICON:String = "PlayerShipIcon_mc";
      
      public function BodyIconsBelow()
      {
         super();
         this.Align_Inspectable = IconOrganizer.ALIGN_CENTER;
         this.IconSpacing_Inspectable = 0;
      }
      
      final public function Update(param1:Object) : void
      {
         SetIconVisible(this.PLAYER_SHIP_ICON,Boolean(param1.bIsPlayerAtBody) && !param1.bForceHideText);
         this.x = 0;
         this.y = param1.fMarkerHeight + MarkerConsts.BODY_ICON_PADDING;
      }
   }
}
