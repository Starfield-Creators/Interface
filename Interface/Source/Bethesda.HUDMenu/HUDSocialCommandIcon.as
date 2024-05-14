package
{
   import Components.Icons.SocialSkillIcons;
   import flash.display.MovieClip;
   
   public class HUDSocialCommandIcon extends MovieClip
   {
       
      
      public var Icon_mc:SocialSkillIcons;
      
      public function HUDSocialCommandIcon()
      {
         super();
      }
      
      public function SetData(param1:Object) : *
      {
         this.Icon_mc.SetData(param1);
      }
   }
}
