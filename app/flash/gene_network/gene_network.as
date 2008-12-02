package {
	import flare.vis.Visualization;
	import flare.vis.data.Data;
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.NodeSprite;
	
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import com.adobe.serialization.json.JSON;


	[SWF(width="800", height="800", backgroundColor="#ffffff", frameRate="30")]
	public class gene_network extends App
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
		private var _gene_ids:String;
		private var textFormat:TextFormat;
		
		public function gene_network()
		{
			//_base_url = "http://landham.homelinux.org/";
			_base_url = "http://0.0.0.0:3000/";
			_controller = "genes";
			_current_id = "10";
			
			//_controller = root.loaderInfo.parameters.controller;
			_gene_ids = root.loaderInfo.parameters.gene_ids;
			_url = _base_url+_controller+"/"+_current_id+".txt";
			
			textFormat = new TextFormat();
			textFormat.color = 0xffffffff;
			textFormat.size  =12;
			textFormat.font = "Helvetica,Arial";
			setupImport();
			loadData();
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
			layout();
		}
		private function layout():void
		{
		}
		private function visualize():void
		{
			
		}
		private function buildGraph(values:Object):void
		{
			_graph = new Data;	
			_graph.treePolicy = "depth-first";
			var item_type:String = _des["type-plural"]; 
			var shell:Object, item:Object, in_item:Object, sprite:NodeSprite,in_item_name:String;
			shell = values[0];
			trace("importing for: "+shell);
			
			for each (item in shell)
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
	
	private function setupImport():void
	{
		_des = new Object;
		_des["type"] = "gene";
		_des["type-plural"] = "genes";
		_des["container"] = "gene";
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
}
}
