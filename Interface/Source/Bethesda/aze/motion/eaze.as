
{
   PropertyTint.register();
   PropertyFrame.register();
   PropertyFilter.register();
   PropertyVolume.register();
   PropertyColorMatrix.register();
   PropertyBezier.register();
   PropertyShortRotation.register();
   return PropertyRect.register();
}

package aze.motion
{
   public function eaze(param1:Object) : EazeTween
   {
      return new EazeTween(param1);
   }
}
