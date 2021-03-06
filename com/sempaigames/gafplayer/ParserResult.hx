package com.sempaigames.gafplayer;

import com.sempaigames.gafplayer.header.Header;
import com.sempaigames.gafplayer.tags.Tag;
import com.sempaigames.gafplayer.tags.TagDefineAtlas;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Assets;
import flash.display.Tilesheet;

class ParserResult {

	public var header : Header;
	public var tags : Array<Tag>;
	public var tilesheets : Array<Tilesheet>;

	public function new (header : Header, tags : Array<Tag>) {

		this.header = header;
		this.tags = tags;
		this.tilesheets = [];

		var tagDefineAtlas = getTagsByType(TagDefineAtlas)[0];
		for (atlas in tagDefineAtlas.atlases) {
			var bmp = Assets.getBitmapData(Parser.assetsPrefix + atlas.sources[0].fileName, false);
			var tilesheet = new Tilesheet(bmp);
			tilesheets.push(tilesheet);
		}

		for (element in tagDefineAtlas.elements) {
			tilesheets[element.atlasIndex-1].addTileRect(
				new Rectangle(element.origin.x, element.origin.y, element.width, element.height),
				new Point(element.pivot.x, element.pivot.y)
			);
		}

	}

	function tagsList () : Array<Tag> {
		var ret = [];
		for (t in tags) {
			ret.push(t);
			for (t2 in t.getSubTags()) {
				ret.push(t2);
			}
		}
		return ret;
	}

	public function getTagsByType<T> (type : Class<T>) : Array<T> {
		var ret = [];
		for (t in tagsList()) {
			if (Std.is(t, type)) {
				ret.push(cast(t));
			}
		}
		return ret;
	}

}
