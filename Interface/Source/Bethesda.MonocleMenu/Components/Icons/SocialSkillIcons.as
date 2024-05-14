package Components.Icons
{
   import flash.display.MovieClip;
   
   public class SocialSkillIcons extends MovieClip
   {
       
      
      public function SocialSkillIcons()
      {
         super();
      }
      
      public function SetData(param1:Object) : void
      {
         if(this.currentFrame != param1.sCommandIcon)
         {
            this.gotoAndStop(param1.sCommandIcon);
         }
      }
   }
}
