package
{
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   
   public class HUDLevelUpPerkClip extends MovieClip
   {
      
      internal static const Scale:Number = 1.3;
       
      
      private var PatchClip:MovieClip = null;
      
      public function HUDLevelUpPerkClip()
      {
         super();
      }
      
      public function SetClipData(param1:Object, param2:uint) : *
      {
         var arrayIndex:uint;
         var index:uint;
         var ClassReference:Class = null;
         var DefaultClassReference:Class = null;
         var aData:Object = param1;
         var aCategory:uint = param2;
         if(this.PatchClip)
         {
            removeChild(this.PatchClip);
         }
         arrayIndex = uint.MAX_VALUE;
         index = 0;
         while(arrayIndex == uint.MAX_VALUE && index < aData.length)
         {
            if(aData[index].uRow == aCategory)
            {
               arrayIndex = index;
            }
            index++;
         }
         try
         {
            ClassReference = getDefinitionByName(arrayIndex != uint.MAX_VALUE ? String(aData[arrayIndex].sArtName) : "") as Class;
            this.PatchClip = new ClassReference();
            addChild(this.PatchClip);
         }
         catch(e:ReferenceError)
         {
            DefaultClassReference = getDefinitionByName("Patch_" + aCategory + "_Default") as Class;
            PatchClip = new DefaultClassReference();
            addChild(PatchClip);
         }
         this.PatchClip.scaleX = Scale;
         this.PatchClip.scaleY = Scale;
         if(arrayIndex == uint.MAX_VALUE)
         {
            this.PatchClip.gotoAndStop("Unavailable");
         }
         else
         {
            this.PatchClip.gotoAndStop("Rank1");
         }
      }
   }
}
