package flash.display
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class DisplayObjectContainer extends InteractiveObject
	{
		private var children:Array = [];
		private var _mouseChildren:Boolean = true;
		public function DisplayObjectContainer()
		{
			super();
		}
		
		public function addChild(child:DisplayObject):DisplayObject
		{
			return addChildAt(child,children.length);
		}
		
		public function addChildAt(child:DisplayObject, index:int):DisplayObject  {
			children.splice(index,0,child);
			child.stage = stage;
			child._parent = this;
			return child;
		}
		
		public function removeChild(child:DisplayObject):DisplayObject  { 
			var i:int = children.indexOf(child);
			if (i!=-1) {
				return removeChildAt(i);
			}
			return child;
		}
		
		public function removeChildAt(i:int):DisplayObject  { 
			var child:DisplayObject = children[i];
			if(child){
				child._parent = null;
				child.stage = null;
			}
			children.splice(i, 1);
			return child;
		}
		
		public function getChildIndex(child:DisplayObject):int  { 
			return children.indexOf(child);
		}
		
		public function setChildIndex(child:DisplayObject, index:int):void  {
			removeChild(child);
			addChildAt(child, index);
		}
		
		public function getChildAt(index:int):DisplayObject  { 
			return children[index]; 
		}
		
		public function getChildByName(name:String):DisplayObject  { 
			for each(var c:DisplayObject in children) {
				if (c.name==name) {
					return c;
				}
			}
			return null;
		}
		
		public function get numChildren():int  { return children.length; }
		override public function set stage(value:Stage):void 
		{
			super.stage = value;
			for each(var c:DisplayObject in children) {
				c.stage = value;
			}
		}
		
		// public function get textSnapshot() : TextSnapshot;
		
		public function getObjectsUnderPoint(p:Point):Array  { return null }
		
		public function areInaccessibleObjectsUnderPoint(p:Point):Boolean  { return false }
		
		public function get tabChildren():Boolean  { return false }
		
		public function set tabChildren(v:Boolean):void  {/**/ }
		
		public function get mouseChildren():Boolean  { return _mouseChildren; }
		
		public function set mouseChildren(v:Boolean):void  { _mouseChildren = v; }
		
		public function contains(child:DisplayObject):Boolean  { 
			return children.indexOf(child) != -1;
		}
		
		public function swapChildrenAt(i1:int, i2:int):void  {
			var temp:DisplayObject = children[i1];
			children[i1] = children[i2];
			children[i2] = temp;
		}
		
		public function swapChildren(c1:DisplayObject, c2:DisplayObject):void  {
			swapChildrenAt(getChildIndex(c1), getChildIndex(c2));
		}
		
		public function removeChildren(start:int = 0, len:int = 2147483647):void  {
			for (var i:int = Math.min(numChildren - 1, start + len - 1); i >= start;i-- ) {
				removeChildAt(i);
			}
		}
		
		public function stopAllMovieClips():void
		{
		
		}
		
		override public function __update():void
		{
			super.__update();
			if(stage&&visible){
				for each (var c:DisplayObject in children)
				{
					c.__update();
				}
			}
		}
		
		override public function updateTransforms():void
		{
			super.updateTransforms();
			for each (var c:DisplayObject in children)
			{
				c.updateTransforms();
			}
		}
		
		override protected function __doMouse(e:flash.events.MouseEvent):DisplayObject 
		{
			if (mouseEnabled&&mouseChildren&&visible) {
				for (var i:int = children.length - 1; i >= 0; i-- ) {
					var obj:DisplayObject = children[i].__doMouse(e);
					if (obj) {
						return obj;
					}
				}
			}
			return null;
		}
		
		override public function getRect(v:DisplayObject):Rectangle 
		{
			var rect:Rectangle = super.getRect(v);
			for each(var c:DisplayObject in children) {
				var rect1:Rectangle = c.getRect(v);
				if (rect == null) {
					rect = rect1;
				}else if(rect1){
					rect.inflate(rect1.x, rect1.y);
					rect.inflate(rect1.right, rect1.bottom);
				}
			}
			return rect;
		}
	}
}
