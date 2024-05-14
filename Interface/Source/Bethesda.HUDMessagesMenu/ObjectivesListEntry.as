package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class ObjectivesListEntry extends EventDispatcher
   {
      
      private static const COMPLETED_OBJECTIVE_MAX_CHARS:uint = 29;
      
      private static const OBJECTIVE_MAX_CHARS:uint = 34;
      
      public static const OBJECTIVE_TEXT_HIDDEN_TIMELINE_EVENT:String = "ObjectiveTextHiddenTimelineEvent";
      
      public static const OBJECTIVE_TEXT_HIDDEN_EVENT:String = "ObjectiveTextHiddenEvent";
       
      
      public var Clip:MovieClip;
      
      public var TextClip:MovieClip;
      
      public var UID:int;
      
      public var Completed:Boolean;
      
      public var Failed:Boolean;
      
      public var Dormant:Boolean;
      
      public var Text:String;
      
      public function ObjectivesListEntry()
      {
         super();
      }
      
      public function Create(param1:Object) : void
      {
         this.UID = param1.uID;
         this.Text = param1.strObjectiveText;
         this.Dormant = param1.bDormant;
         var _loc2_:RegExp = /\\n/gi;
         this.Text = this.Text.replace(_loc2_,"\n");
         var _loc3_:Boolean = true;
         if(Boolean(param1.bCompleted) || Boolean(param1.bFailed))
         {
            if(this.Text.length <= COMPLETED_OBJECTIVE_MAX_CHARS && this.Text.search("\n") == -1)
            {
               this.Clip = new QuestObjectiveCompleteText();
               this.TextClip = this.Clip.QuestObjectiveCompletedTextfield_mc;
               GlobalFunc.SetText(this.TextClip.QuestObjectiveText_tf,this.Text);
               if(this.TextClip.QuestObjectiveText_tf.textWidth > this.TextClip.width)
               {
                  _loc3_ = true;
                  this.Clip = null;
                  this.TextClip = null;
               }
               else
               {
                  _loc3_ = false;
               }
            }
            if(_loc3_)
            {
               this.Clip = new QuestObjectiveCompleteTextLong();
               this.TextClip = this.Clip.QuestObjectiveCompletedTextfieldLong_mc;
            }
            this.Completed = param1.bCompleted;
            this.Failed = param1.bFailed;
         }
         else
         {
            if(this.Text.length <= OBJECTIVE_MAX_CHARS && this.Text.search("\n") == -1)
            {
               this.Clip = new QuestObjectiveText();
               this.TextClip = this.Clip.QuestObjectiveTextfield_mc;
               GlobalFunc.SetText(this.TextClip.QuestObjectiveText_tf,this.Text);
               if(this.TextClip.QuestObjectiveText_tf.textWidth > this.TextClip.width)
               {
                  _loc3_ = true;
                  this.Clip = null;
                  this.TextClip = null;
               }
               else
               {
                  _loc3_ = false;
               }
            }
            if(_loc3_)
            {
               this.Clip = new QuestObjectiveTextLong();
               this.TextClip = this.Clip.QuestObjectiveTextfieldLong_mc;
            }
            this.Completed = false;
            this.Failed = false;
         }
         if(this.Clip)
         {
            this.Clip.addEventListener(OBJECTIVE_TEXT_HIDDEN_TIMELINE_EVENT,this.OnObjectiveTextHidden);
         }
      }
      
      public function SetText(param1:String) : void
      {
         var _loc2_:RegExp = null;
         var _loc3_:int = 0;
         if(this.TextClip)
         {
            this.Text = param1;
            _loc2_ = /\\n/gi;
            this.Text = this.Text.replace(_loc2_,"\n");
            _loc3_ = this.Completed || this.Failed ? int(COMPLETED_OBJECTIVE_MAX_CHARS) : int(OBJECTIVE_MAX_CHARS);
            if(this.Text.length > _loc3_)
            {
               GlobalFunc.SetTwoLineText(this.TextClip.QuestObjectiveText_tf,this.Text,_loc3_);
            }
            else
            {
               GlobalFunc.SetText(this.TextClip.QuestObjectiveText_tf,this.Text);
            }
         }
      }
      
      private function OnObjectiveTextHidden(param1:Event) : *
      {
         dispatchEvent(new Event(OBJECTIVE_TEXT_HIDDEN_EVENT));
      }
   }
}
