package {
	
	import com.adobe.serialization.json.JSON;
	
	import flare.animate.Parallel;
	import flare.animate.Transitioner;
	import flare.display.TextSprite;
	import flare.vis.Visualization;
	import flare.vis.controls.ClickControl;
	import flare.vis.controls.ExpandControl;
	import flare.vis.controls.HoverControl;
	import flare.vis.controls.PanZoomControl;
	import flare.vis.data.Data;
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.ScaleBinding;
	import flare.vis.data.render.ArrowType;
	import flare.vis.events.SelectionEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	
	
	
	[SWF(width="800", height="800", backgroundColor="#ffffff", frameRate="30")]
	public class integrated_network extends App
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
		private var _search:SearchBox;
		private var textFormat:TextFormat;
		private var _search_text_format:TextFormat = new TextFormat("Helvetica,Arial",16,0,true);
		
		private var _highlight_color:uint = 0xffD91818;
		
		// for highlighting purposes		
		private var _trans:Object = {};
		
		protected override function init():void
		{
			_des = new Object;
			setupImport();
			_base_url = "http://0.0.0.0:3000/";
			_controller = "cancers";
			_current_id = "10";
			
			//_controller = root.loaderInfo.parameters.controller;
			//_current_id = root.loaderInfo.parameters.value_id;
			_url = _base_url+_controller+"/"+_current_id+".txt";
			
			_current_nodes = {};
			
			textFormat = new TextFormat();
			textFormat.color = 0xffffffff;
			textFormat.size  =8;
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
			_des["positions"] = {"base":2,
							  "gene_transcription_factors_in":1,
							  "gene_interactions_out":3, 
							  "gene_interactions_in":4};
			_des["node_colors"] = {1:0xA7D285,
							  2:0x438208,
							  3:0x002754, 
							  4:0x3b3b3b
							  };
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
		public override function resize(bounds:Rectangle):void
		{
			if (_bar) {
				_bar.x = bounds.width/2 - _bar.width/2;
				_bar.y = bounds.height/3 - _bar.height/2;
			}
			//bounds.width -= (15 + 50);
			//bounds.height -= (75 + 25);
			//bounds.x += 15;
			//bounds.y += 75;
			//_bounds = bounds;
			layout();
		}
		private function layout():void
		{
			if (_search) {
				_search.x = 0;
				_search.y = 4;
			}
		}
		private function addControls():void
		{
			// create search box
			_search = new SearchBox(_search_text_format, ">", 250);
			_search.borderColor = 0xdedede;
			_search.input.tabIndex = 0;
			_search.input.restrict = "a-zA-Z \\-";
			_search.addEventListener(SearchBox.SEARCH, onFilter);
			addChild(_search);
	
		}
		/** Callback for filter events. */
		private function onFilter(evt:Event=null):void
		{
			//var color:uint = 0xff00ff00;
			//var query:Array = _search.query.toLowerCase().split(/\s+/);
			//if (query.length==1 && query[0].length==0) query.pop();
			//var regulars:Array = new Array(query.length);
			//for (var word:String in query)
			//{
			//	var regexp:RegExp = new RegExp(".*","i")
			//	regulars.push(regexp);
			//}
			var word:String = _search.query.toLowerCase();
			if(word.length == 0) word = "***";
			trace("search string is: "+word);
			var t:Transitioner;
			var p:Parallel = new Parallel();
			var regexp:RegExp;
			_vis.data.nodes.visit(function(n:NodeSprite):void {
			//	for (var word:String in query)
			//	{
					regexp = new RegExp("^"+word+".*","i");
					t = getTransitioner(n.name);
					if(n.data.name.toLowerCase().search(regexp) != -1)
					{
						
						t = toggleColor(n,_highlight_color,true,t);
						
					}
					else
					{
						t = toggleColor(n,_highlight_color,false,t);
					}
					p.add(t);
			//	}
			});
			p.play();
//			_query = _search.query.toLowerCase().split(/\|/);
//			if (_query.length==1 && _query[0].length==0) _query.pop();
//			
//			if (_t && _t.running) _t.stop();
//			_t = _vis.update(_dur);
//			_t.play();
//			
//			_exact = false; // reset exact match after each search
		}

		
		private function visualize():void
		{
			var w:Number = stage.stageWidth;
			var h:Number = stage.stageHeight;
			
			trace("graph size: "+_graph.nodes.length);
			_graph.nodes.sortBy("data.position");
			_vis = new Visualization(_graph);
			_vis.bounds = new Rectangle(0, 0, w, h);
			//_vis.x = 21;
			//_vis.y = 21;
			
			setupNodes();
			setupEdges();
			var hc:HoverControl = new HoverControl(NodeSprite,HoverControl.MOVE_TO_FRONT,highLightOn,highlightOff);
			_vis.controls.add(hc);
			
			var cc:ClickControl = new ClickControl(NodeSprite,1,toggleEdges);
			_vis.controls.add(cc);
			//addHoverControl();
			
			_vis.controls.add(new ExpandControl(NodeSprite));
			//_vis.operators.add(new BundledEdgeRouter(0.5));
			var pzc:PanZoomControl = new PanZoomControl();
			_vis.controls.add(pzc);
			setLayout();
			//_vis.continuousUpdates = true;
			
			 addChild(_vis);			 
			 _vis.update();	
			 addControls();
		}
		
		private function setupNodes():void
		{
			_vis.data.nodes.visit(function(n:NodeSprite):void {		
				
					
//				n.lineColor = 0x0000dd; n.lineAlpha = 0.7;
				n.lineWidth = 2;
				n.fillColor = _des["node_colors"][n.data.position];
				n.fillAlpha = 0.9;
				addNameHover(n);
				
			
				if (n.childDegree > 0) { // possible since our tree is static
//				n.fillColor = 0xff0000; n.fillAlpha = 0.9;
//				//	n.lineColor = 0x0000ee; 
					//n.addEventListener(MouseEvent.CLICK, updateColor);
				} 
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
			ns.size = 2;
			adjustLabel(ns);
			ns.mouseChildren = false;
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
			s2.horizontalAnchor = TextSprite.MIDDLE;
			s2.verticalAnchor = TextSprite.MIDDLE;
			s2.textField.background  =true;	
			s2.textField.backgroundColor = (s as NodeSprite).fillColor;	
			//s2.x += 10;		
			//s2.useHandCursor = false; // since the text label doesn't invoke the expand control
			//s2.visible = false;
		}
		
		private function setupEdges():void
		{
			_vis.data.edges.visit(function(e:EdgeSprite):void {
				setEdgeColor(e);
				if(e.directed)
				{
					//trace("setting edge to directed "+e.data.type);
					e.arrowType = ArrowType.LINES;
					//e.arrowHeight = 2;
					//e.arrowWidth = 2;
				}
				e.size = 2;
				e.visible = false;
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
			var cir:StaggeredCircleLayout = new StaggeredCircleLayout("data.position",null,true);
			var sc:ScaleBinding = new ScaleBinding();
			
			cir.angleWidth = 6 * Math.PI;
			cir.padding = 25;
			cir.startRadius = 10;
			_vis.operators.add(cir);
			
			
		//var rad:RadialTreeLayout = new RadialTreeLayout();
		//	_vis.operators.add(rad);
		}
		
		// !!!! Remove?
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
			_graph = new Data;	
			_graph.treePolicy = "depth-first";
			var item_type:String = _des["type-plural"]; 
			var shell:Object, item:Object, in_item:Object, sprite:NodeSprite,in_item_name:String;
			shell = values[_des["container"]];
			trace("importing for: "+shell["name"]);
			
			//!!!!! hack
			var prev:NodeSprite = null;
			
			for each (item in shell[item_type])
			{
				sprite = findOrCreateNode(item,"base");
				// set position to be used in organizing these genes
				//setPositionOfNode(sprite,"base");
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
					addEdgesTo(prev,tempArray,false,"base");
				}
				prev = sprite;
			} 
			
		}
		
		private function findOrCreateNode(item:Object,type:String):NodeSprite
		{
			var name:String = item[_des["name"]];
			if(!_current_nodes[name])
			{			
				_current_nodes[name] =  _graph.addNode({name:item[_des["name"]], size:1, 
					id:item[_des["id"]], type:_des["type"], position:_des["positions"][type]});
				trace("created node :"+name+" -- "+_des["positions"][type]);
			}
			return _current_nodes[name];
		}
		
		private function addEdgesTo(node:NodeSprite, group:Array, directed:Boolean,type:String):void
		{
			var item:Object, sp:NodeSprite;
			for each(item in group)
			{
				sp = findOrCreateNode(item,type);
				//setPositionOfNode(sp,type);
				if(sp.data.name !== node.data.name) {				
  				var ed:EdgeSprite = _graph.addEdgeFor(node,sp, directed,{type:type} );
  				trace("- added edge from: "+node.data.name+" -> "+sp.data.name+" -- "+ed.data.type);
				}	
			}
		}
		//private function setPositionOfNode(node:NodeSprite, type:String):void
		//{
		//	node.data.position = _des["positions"][type];
		//	trace("set position of "+node.data.name+"to "+node.data.position);
		//}
		
		/*
		* ------ Clicking Edges -------
		*/
		private function toggleEdges(evt:SelectionEvent):void {
			var toggle:Boolean = true;
			if(evt.node.data.clicked)
			{
				 toggle = evt.node.data.clicked;
				toggle = !toggle;
				evt.node.data.clicked = toggle;
			}
			else
			{
				evt.node.data.clicked = true;
			}
			_toggleEdges(evt.node, toggle,0);
		}
		private function _toggleEdges(n:NodeSprite, toggle:Boolean, duration:uint):void {
			var p:Parallel = new Parallel();
			var t:Transitioner = new Transitioner(duration);
			n.visitEdges(function(edge:EdgeSprite):void {
				t.$(edge).visible = toggle;
				p.add(t);
			});
			//t.$(n).lineColor = toggle ? 0x000001 : 0xffffff
			//p.add(t);
			p.play();
		}
		/*
		* ------ Highlighting Nodes -------
		*/
		
		private function highLightOn(evt:SelectionEvent):void {
			 _highLight(evt.node,true,1);
		}
			
		private function highlightOff(evt:SelectionEvent):void {
			_highLight(evt.node,false,1);
		}
		 
		 
		private function _highLight(n:NodeSprite, highlight:Boolean, duration:uint):void {	
			
			var p:Parallel = new Parallel();	
			
			var t:Transitioner; 
			
			n.visitNodes(function(neighbor_node:NodeSprite):void {
				t = getTransitioner(neighbor_node.name, duration);
				t = toggleColor(neighbor_node,_highlight_color,highlight,t);
				p.add(t);
			});
			
			t = getTransitioner(n.name, duration);
			t = toggleColor(n,_highlight_color,highlight,t);		
			p.add(t);
			
			p.play();
		 }
		 
		 private function toggleColor(n:NodeSprite,color:uint, toggle:Boolean, t:Transitioner):Transitioner
		 {
		 	if(!n.data.color)
			{
				n.data.color = n.fillColor
			}			
			t.$(n).fillColor = toggle ? color : n.data.color;
			var s2:TextSprite = n.getChildAt(0) as TextSprite;
			//var t2:TextField = s2.textField;
			//s2.textField.background = true;
			//s2.textField.backgroundColor = toggle ? color : n.data.color;
			
			t.$(s2.textField).backgroundColor = toggle ? color : n.data.color;
			return t;
		 }
		 
		 private function getTransitioner(task:String,duration:Number=1, easing:Function=null,
									 optimize:Boolean = false ):Transitioner {
				if (_trans[task] != null) {					
					_trans[task].stop();
					_trans[task].dispose();
				}
										 					 
				_trans[task] = new Transitioner(duration,easing,optimize);
				return _trans[task];
		 }


		
	}
}
