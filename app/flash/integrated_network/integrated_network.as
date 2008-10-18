package {
	
	import com.adobe.serialization.json.JSON;
	
	import flare.animate.Transitioner;
	import flare.display.TextSprite;
	import flare.util.Shapes;
	import flare.vis.Visualization;
	import flare.vis.controls.ExpandControl;
	import flare.vis.controls.HoverControl;
	import flare.vis.controls.PanZoomControl;
	import flare.vis.data.Data;
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.NodeSprite;
	import flare.vis.events.SelectionEvent;
	import flare.vis.operator.layout.RadialTreeLayout;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	
	
	
	[SWF(width="800", height="600", backgroundColor="#ffffff", frameRate="30")]
	public class integrated_network extends Sprite
	{
		private var _vis:Visualization;
		private var _graph:Data;
		private var _current_nodes:Object;
		private var _des:Object;
		private var _bar:ProgressBar;
		private var _url:String;
		private var _base_url:String;
		private var _controller:String;
		private var _current_id:String;
		private var textFormat:TextFormat;
		
		public function integrated_network()
		{
			_des = new Object;
			setupImport();
			_base_url = "http://0.0.0.0:3000/";
			_controller = "cancers";
			_current_id = "10";
			
			//_controller = root.loaderInfo.parameters.controller;
			//_current_id = root.loaderInfo.parameters.value_id;
			_url = _base_url+_controller+"/"+_current_id+".txt";
			_graph = new Data;	
			_current_nodes = {};
			
			textFormat = new TextFormat();
			textFormat.color = 0xffffffff;
			textFormat.size  =14;
			textFormat.font = "Arial";
			
			loadData();
		}
		
		private function setupImport():void
		{
			_des["type"] = "gene";
			_des["type-plural"] = "genes";
			_des["container"] = "cancer";
			_des["name"] = "gene_symbol";
			_des["import"] = {"gene_transcription_factors_in":true,
							  "gene_interactions_out":false, 
							  "gene_interactions_in":false};
			_des["positions"] = {"base":1,
							  "gene_transcription_factors_in":2,
							  "gene_interactions_out":3, 
							  "gene_interactions_in":3};
			_des["node_colors"] = {1:0xFF0000,
							  2:0xFF6600,
							  2:0xFF6600, 
							  3:0x8B8B83};
			_des["edge_colors"] = {"gene_transcription_factors_in":0x30420f,
								   "gene_interactions_out":0x8c7d15,
								   "gene_interactions_in":0x8c7d15,
								   "pathway":0x272204};
		}
		
		private function loadData():void
		{
			addChild(_bar = new ProgressBar());
			_bar.bar.filters = [new DropShadowFilter(1)];
			
			var ldr:URLLoader = new URLLoader(new URLRequest(_url));
			_bar.loadURL(ldr, function():void {
				var obj:Object = JSON.decode(ldr.data as String) as Object;
				
				buildGraph(obj);
	            visualize();
	            _bar = null;
			});
		}
		
		private function visualize():void
		{
			var w:Number = stage.stageWidth;
			var h:Number = stage.stageHeight;
			
//			_graph.edges.setProperties({
//				
//				lineWidth: 2,
//				//lineColor: 0xff0055cc,
//				mouseEnabled: false
//			});
			
		//	_graph.nodes.setProperties({
		//		lineColor: 0xff0055cc,
		//		size: 1
		//	});
			
			trace("graph size: "+_graph.nodes.length);
			_graph.nodes.sortBy("data.position");
			_vis = new Visualization(_graph);
			_vis.bounds = new Rectangle(0, 0, w, h);
			_vis.x = 21;
			_vis.y = 21;
			
			setLayout();
			addHoverControl();

			_vis.controls.add(new ExpandControl());
			
			setupNodes();
			setupEdges();
			addHoverControl();
			
			var pzc:PanZoomControl = new PanZoomControl();
			_vis.controls.add(pzc);
					
			//_vis.continuousUpdates = true;
			
			 addChild(_vis);			 
			 _vis.update();		 
		}
		
		private function setupNodes():void
		{
			_vis.tree.nodes.visit(function(n:NodeSprite):void {		
				addNameHover(n);
					
//				n.lineColor = 0x0000dd; n.lineAlpha = 0.7;
				n.lineWidth = 2;
				n.fillColor = _des["node_colors"][n.data.position];
				n.fillAlpha = 0.9;
			
//				if (n.childDegree > 0) { // possible since our tree is static
//				n.fillColor = 0xff0000; n.fillAlpha = 0.9;
//				//	n.lineColor = 0x0000ee; 
//					n.addEventListener(MouseEvent.CLICK, updateColor); 
//				} else {
//					n.fillColor = 0x0000ff; n.fillAlpha = 0.9;
//				//	n.lineColor = 0x004400; 
//				}
				n.buttonMode = true;
			});
		}
		
		private function addNameHover(ns:NodeSprite):void
		{			
			var ts:TextSprite = new TextSprite(ns.data.name,textFormat);
			ns.addChild(ts);
			adjustLabel(ns);
			//ns.buttonMode  =true;
		}
		
		private function addHoverControl():void
		{
			_vis.controls.add(new HoverControl(NodeSprite,
				HoverControl.MOVE_AND_RETURN,
				function(evt:SelectionEvent):void {
					evt.node.getChildAt(0).visible = true;
				},
				function(evt:SelectionEvent):void {
					evt.node.getChildAt(0).visible = false;
				}
			));
		}
		
		private function adjustLabel(s:Sprite) : void 
		{	
			var s2:TextSprite = s.getChildAt(0) as TextSprite; // get the text sprite belonging to this node sprite		
			s2.horizontalAnchor = TextSprite.LEFT;
			s2.verticalAnchor = TextSprite.MIDDLE;
			s2.textField.background  =true;	
			s2.textField.backgroundColor = 0xff990022;	
			s2.x += 10;		
			s2.useHandCursor = false; // since the text label doesn't invoke the expand control
			s2.visible = false;
		}
		
		private function setupEdges():void
		{
			_vis.tree.edges.visit(function(e:EdgeSprite):void {
				setEdgeColor(e);
				if(e.directed)
				{
					trace("setting edge to directed "+e.data.type);
					e.arrowType = Shapes.TRIANGLE_RIGHT;
					//e.arrowHeight = 2;
					//e.arrowWidth = 2;
				}
				e.size = 1;
				e.mouseEnabled = false;
			});
		}
		
		private function setEdgeColor(ed:EdgeSprite):void
		{
			if (_des["edge_colors"][ed.data.type])
			{
				ed.lineColor = _des["edge_colors"][ed.data.type];
				//	trace("line color: "+ed.lineColor+" for type - "+ed.data.type);
				ed.lineAlpha = 0.9;
			}
			else if(ed.data.type == "fake")
			{
				ed.visible = false;
			}
			else
			{
				trace("!!!!no line color for type:"+ed.data.type);
			}
			
		}
		
		private function setLayout():void
		{
			_vis.operators.add(new RadialTreeLayout());
		}
		
		private function updateColor(event:MouseEvent):void {
			
			var t:Transitioner = new Transitioner(1);
			var n:NodeSprite = event.target as NodeSprite;
			
			/* n.childDegree is here never 0 since we only call this method for none leaves*/
			if (n.expanded || n.childDegree == 0) { 
				t.$(n).fillColor = 0xff0000; 
			} else {
				t.$(n).fillColor = 0x00ff00; 
			}
			t.$(n).fillAlpha = 0.9;
			t.play();
			
		}
		
		private function buildGraph(values:Object):void
		{
			var item_type:String = _des["type-plural"]; 
			var shell:Object, item:Object, in_item:Object, sprite:NodeSprite,in_item_name:String;
			shell = values[_des["container"]];
			trace("importing for: "+shell["name"]);
			
			//!!!!! hack
			var prev:NodeSprite = null;
			
			for each (item in shell[item_type])
			{
				sprite = findOrCreateNode(item);
				// set position to be used in organizing these genes
				setPositionOfNode(sprite,"base");
				trace("imported: "+item[_des["name"]]);
				for (var key:String in _des["import"])
				{
					var new_items:Array = item[key];
					addEdgesTo(sprite,new_items, _des["import"][key], key);
				}
				//!!!!!!!!!!! hack
				if(prev !== null)
				{				
					var tempArray:Array = new Array;
					tempArray.push(item);
					//trace("going to add edge between "+prev.data.name+" -> "+item[_des["name"]]);
					addEdgesTo(prev,tempArray,false,"fake");
				}
				prev = sprite;
			} 
			
		}
		
		private function findOrCreateNode(item:Object):NodeSprite
		{
			var name:String = item[_des["name"]];
			if(!_current_nodes[name])
			{			
				_current_nodes[name] =  _graph.addNode({name:item[_des["name"]], size:1, 
					id:item[_des["id"]], type:_des["type"]});
				trace("created node :"+name);
			}
			return _current_nodes[name];
		}
		
		private function addEdgesTo(node:NodeSprite, group:Array, directed:Boolean,type:String):void
		{
			var item:Object, sp:NodeSprite;
			for each(item in group)
			{
				sp = findOrCreateNode(item);
				setPositionOfNode(sp,type);
				if(sp.data.name !== node.data.name) {				
  				var ed:EdgeSprite = _graph.addEdgeFor(node,sp, directed,{type:type} );
  				trace("- added edge from: "+node.data.name+" -> "+sp.data.name+" -- "+ed.data.type);
				}	
			}
		}
		private function setPositionOfNode(node:NodeSprite, type:String):void
		{
			node.data.position = _des["positions"][type];
			trace("set position of "+node.data.name+"to "+node.data.position);
		}
		
	}
}
