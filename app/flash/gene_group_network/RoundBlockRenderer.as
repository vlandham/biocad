package 
{
	import flare.vis.data.DataSprite;
	import flare.vis.data.render.IRenderer;
 
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
 
	public class RoundBlockRenderer implements IRenderer
	{
 
		public static const ROUNDED_BLOCK : String = "roundedblock";
 
		private static var _instance:RoundBlockRenderer = new RoundBlockRenderer();
 
		public var _defaultSize:Number;
 
		public static function get instance():RoundBlockRenderer { return _instance; }
 
		public function RoundBlockRenderer(defaultSize : Number = 6)
		{
			this._defaultSize = defaultSize;
		}
 
		public function render(d:DataSprite):void
		{
			var size:Number = d.size * _defaultSize;
			var g : Graphics = d.graphics;
			g.clear();
			var _n : Number = Math.random();
			g.beginGradientFill( 	GradientType.LINEAR,
									[ 0xffffffff* _n,0xaaaaaaaa* _n, 0x8c8c8cff* _n, 0x000000 ],
									[ .8, .8, .8, .8 ],
									[ 0,96, 128, 180 ],
									new Matrix()
								);
 
			switch( d.shape ) {
 
				case ROUNDED_BLOCK:
					g.drawRoundRect(d.u-d.x, d.v-d.y, d.w, d.h, 8, 8);
				break;
			}
 
		}
 
	}
}
