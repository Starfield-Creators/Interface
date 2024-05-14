package
{
   import Shared.AS3.Events.CustomEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DigiKey extends MovieClip
   {
      
      public static const KEY_CLICKED:String = "KeyClicked";
       
      
      public var KeySelected_mc:MovieClip;
      
      public var KeyTooth_mc_0:MovieClip;
      
      public var KeyTooth_mc_1:MovieClip;
      
      public var KeyTooth_mc_2:MovieClip;
      
      public var KeyTooth_mc_3:MovieClip;
      
      public var KeyTooth_mc_4:MovieClip;
      
      public var KeyTooth_mc_5:MovieClip;
      
      public var KeyTooth_mc_6:MovieClip;
      
      public var KeyTooth_mc_7:MovieClip;
      
      public var KeyTooth_mc_8:MovieClip;
      
      public var KeyTooth_mc_9:MovieClip;
      
      public var KeyTooth_mc_10:MovieClip;
      
      public var KeyTooth_mc_11:MovieClip;
      
      public var KeyTooth_mc_12:MovieClip;
      
      public var KeyTooth_mc_13:MovieClip;
      
      public var KeyTooth_mc_14:MovieClip;
      
      public var KeyTooth_mc_15:MovieClip;
      
      public var KeyTooth_mc_16:MovieClip;
      
      public var KeyTooth_mc_17:MovieClip;
      
      public var KeyTooth_mc_18:MovieClip;
      
      public var KeyTooth_mc_19:MovieClip;
      
      public var KeyTooth_mc_20:MovieClip;
      
      public var KeyTooth_mc_21:MovieClip;
      
      public var KeyTooth_mc_22:MovieClip;
      
      public var KeyTooth_mc_23:MovieClip;
      
      public var KeyTooth_mc_24:MovieClip;
      
      public var KeyTooth_mc_25:MovieClip;
      
      public var KeyTooth_mc_26:MovieClip;
      
      public var KeyTooth_mc_27:MovieClip;
      
      public var KeyTooth_mc_28:MovieClip;
      
      public var KeyTooth_mc_29:MovieClip;
      
      public var KeyTooth_mc_30:MovieClip;
      
      public var KeyTooth_mc_31:MovieClip;
      
      public var KeyTeeth:Array;
      
      private var KeyIndex:uint = 0;
      
      public function DigiKey()
      {
         super();
         this.KeyTeeth = new Array(this.KeyTooth_mc_0,this.KeyTooth_mc_1,this.KeyTooth_mc_2,this.KeyTooth_mc_3,this.KeyTooth_mc_4,this.KeyTooth_mc_5,this.KeyTooth_mc_6,this.KeyTooth_mc_7,this.KeyTooth_mc_8,this.KeyTooth_mc_9,this.KeyTooth_mc_10,this.KeyTooth_mc_11,this.KeyTooth_mc_12,this.KeyTooth_mc_13,this.KeyTooth_mc_14,this.KeyTooth_mc_15,this.KeyTooth_mc_16,this.KeyTooth_mc_17,this.KeyTooth_mc_18,this.KeyTooth_mc_19,this.KeyTooth_mc_20,this.KeyTooth_mc_21,this.KeyTooth_mc_22,this.KeyTooth_mc_23,this.KeyTooth_mc_24,this.KeyTooth_mc_25,this.KeyTooth_mc_26,this.KeyTooth_mc_27,this.KeyTooth_mc_28,this.KeyTooth_mc_29,this.KeyTooth_mc_30,this.KeyTooth_mc_31);
         this.addEventListener(MouseEvent.CLICK,this.handleMouseRelease);
      }
      
      public function set keyIndex(param1:uint) : *
      {
         this.KeyIndex = param1;
      }
      
      public function get keyIndex() : *
      {
         return this.KeyIndex;
      }
      
      private function handleMouseRelease(param1:MouseEvent) : *
      {
         this.dispatchEvent(new CustomEvent(KEY_CLICKED,{"Index":this.KeyIndex},true,true));
      }
   }
}
