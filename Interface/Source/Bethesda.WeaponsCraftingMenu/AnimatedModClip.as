package
{
   import flash.display.MovieClip;
   
   public class AnimatedModClip extends MovieClip
   {
      
      public static const HIDE_CONTENT:String = "Hide";
      
      public static const SHOW_CONTENT:String = "Show";
      
      public static const INSTALLED:String = "Installed";
      
      public static const ANIMATION_FINISHED:String = "ModClipAnimationFinished";
       
      
      private var AnimationQueue:Array;
      
      protected var _lastFramePlayed:String;
      
      private var _playingAnimation:Boolean;
      
      public function AnimatedModClip()
      {
         super();
         this.AnimationQueue = new Array();
         this.playingAnimation = true;
      }
      
      private function set playingAnimation(param1:Boolean) : void
      {
         this._playingAnimation = param1;
         if(this._playingAnimation)
         {
            addEventListener(ANIMATION_FINISHED,this.AnimationFinished);
         }
         else
         {
            removeEventListener(ANIMATION_FINISHED,this.AnimationFinished);
         }
      }
      
      public function CancelQueuedAnims() : void
      {
         this.AnimationQueue.length = 0;
      }
      
      public function PlayAnimation(param1:String) : void
      {
         var _loc2_:String = null;
         if(!this._playingAnimation)
         {
            if(param1 != this._lastFramePlayed)
            {
               this.playingAnimation = true;
               _loc2_ = this._lastFramePlayed + "To" + param1;
               this._lastFramePlayed = param1;
               gotoAndPlay(_loc2_);
            }
            else
            {
               this.AnimationFinished();
            }
         }
         else
         {
            this.AnimationQueue.push(param1);
         }
      }
      
      private function AnimationFinished() : void
      {
         this.playingAnimation = false;
         var _loc1_:String = this.AnimationQueue.shift();
         if(_loc1_ != null)
         {
            this.PlayAnimation(_loc1_);
         }
      }
   }
}
