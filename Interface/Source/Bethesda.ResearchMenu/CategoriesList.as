package
{
   import Shared.AS3.BSScrollingContainer;
   
   public class CategoriesList extends BSScrollingContainer
   {
       
      
      private var _nextClipIndex:uint = 0;
      
      private var _animatingClips:Boolean = false;
      
      public function CategoriesList()
      {
         super();
         addEventListener(CategoryList_Entry.OPEN_ANIM_HALFWAY,this.OpenNextClip);
      }
      
      public function SetSelectedCategory(param1:uint) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < entryList.length)
         {
            if(entryList[_loc2_].uID == param1)
            {
               selectedIndex = _loc2_;
               break;
            }
            _loc2_++;
         }
      }
      
      public function DisplayList(param1:Boolean) : void
      {
         var _loc2_:CategoryList_Entry = null;
         if(param1)
         {
            this._animatingClips = true;
            this.OpenNextClip();
         }
         else
         {
            _loc2_ = GetClipByIndex(selectedClipIndex) as CategoryList_Entry;
            if(_loc2_ != null)
            {
               _loc2_.Display(false);
            }
         }
      }
      
      private function OpenNextClip() : void
      {
         var _loc1_:CategoryList_Entry = null;
         if(this._animatingClips)
         {
            if(this._nextClipIndex < totalEntryClips)
            {
               _loc1_ = GetClipByIndex(this._nextClipIndex) as CategoryList_Entry;
               if(_loc1_ != null)
               {
                  _loc1_.Display(true);
               }
               ++this._nextClipIndex;
            }
            else
            {
               this._animatingClips = false;
            }
         }
      }
   }
}
