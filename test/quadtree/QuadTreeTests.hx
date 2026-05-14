package quadtree;

import utest.Assert;
import utest.Test;
import dropecho.ds.Rect;
import dropecho.ds.QuadTree;

typedef Item = {x:Float, y:Float};

function getBounds(item:Item):Rect {
	return new Rect(item.x, item.y, 0, 0);
}

class QuadTreeTests extends Test {
	var qt:QuadTree<Item>;

	public function setup() {
		qt = new QuadTree(new Rect(0, 0, 100, 100), getBounds);
	}

	public function test_canInstantiate() {
		Assert.notNull(qt);
	}

	public function test_insert_returns_true_for_item_inside_bounds() {
		Assert.isTrue(qt.insert({x: 50, y: 50}));
	}

	public function test_insert_returns_false_for_item_outside_bounds() {
		Assert.isFalse(qt.insert({x: 200, y: 200}));
	}

	public function test_query_returns_items_in_region() {
		var a = {x: 10.0, y: 10.0};
		var b = {x: 90.0, y: 90.0};
		qt.insert(a);
		qt.insert(b);
		var result = qt.query(new Rect(0, 0, 50, 50));
		Assert.equals(1, result.length);
		Assert.equals(a, result[0]);
	}

	public function test_query_returns_empty_when_no_matches() {
		qt.insert({x: 80, y: 80});
		var result = qt.query(new Rect(0, 0, 10, 10));
		Assert.equals(0, result.length);
	}

	public function test_query_returns_all_matching_items() {
		var items = [{x: 10.0, y: 10.0}, {x: 20.0, y: 20.0}, {x: 90.0, y: 90.0}];
		for (item in items) qt.insert(item);
		var result = qt.query(new Rect(0, 0, 50, 50));
		Assert.equals(2, result.length);
	}

	public function test_remove_existing_item_returns_true() {
		var item = {x: 50.0, y: 50.0};
		qt.insert(item);
		Assert.isTrue(qt.remove(item));
	}

	public function test_remove_missing_item_returns_false() {
		Assert.isFalse(qt.remove({x: 50, y: 50}));
	}

	public function test_remove_item_no_longer_returned_by_query() {
		var item = {x: 25.0, y: 25.0};
		qt.insert(item);
		qt.remove(item);
		var result = qt.query(new Rect(0, 0, 100, 100));
		Assert.equals(0, result.length);
	}

	public function test_clear_removes_all_items() {
		qt.insert({x: 10, y: 10});
		qt.insert({x: 50, y: 50});
		qt.insert({x: 90, y: 90});
		qt.clear();
		var result = qt.query(new Rect(0, 0, 100, 100));
		Assert.equals(0, result.length);
	}

	public function test_subdivision_occurs_and_items_still_queryable() {
		// maxItems=2 forces subdivision after 3 inserts
		var smallQt = new QuadTree(new Rect(0, 0, 100, 100), getBounds, 2);
		var items = [
			{x: 10.0, y: 10.0}, {x: 20.0, y: 20.0},
			{x: 80.0, y: 10.0}, {x: 10.0, y: 80.0}
		];
		for (item in items) smallQt.insert(item);
		var result = smallQt.query(new Rect(0, 0, 100, 100));
		Assert.equals(4, result.length);
	}

	public function test_items_in_different_quadrants_separated_after_subdivision() {
		var smallQt = new QuadTree(new Rect(0, 0, 100, 100), getBounds, 2);
		var nw = {x: 10.0, y: 10.0};
		var ne = {x: 80.0, y: 10.0};
		var sw = {x: 10.0, y: 80.0};
		var se = {x: 80.0, y: 80.0};
		smallQt.insert(nw);
		smallQt.insert(ne);
		smallQt.insert(sw);
		smallQt.insert(se);

		Assert.equals(1, smallQt.query(new Rect(0, 0, 49, 49)).length);
		Assert.equals(1, smallQt.query(new Rect(51, 0, 49, 49)).length);
		Assert.equals(1, smallQt.query(new Rect(0, 51, 49, 49)).length);
		Assert.equals(1, smallQt.query(new Rect(51, 51, 49, 49)).length);
	}

	public function test_bounding_box_items_spanning_quadrants_found_by_all_overlapping_queries() {
		var getBoundsWide = (item:{x:Float, y:Float, w:Float, h:Float}) -> new Rect(item.x, item.y, item.w, item.h);
		var smallQt = new QuadTree(new Rect(0, 0, 100, 100), getBoundsWide, 2);

		// item spans the center of the tree, crossing all four quadrants
		var big = {x: 30.0, y: 30.0, w: 40.0, h: 40.0};
		var nw = {x: 5.0, y: 5.0, w: 5.0, h: 5.0};
		var se = {x: 85.0, y: 85.0, w: 5.0, h: 5.0};

		smallQt.insert(big);
		smallQt.insert(nw);
		smallQt.insert(se);

		// big item should appear in queries from any quadrant it spans
		var nwResult = smallQt.query(new Rect(0, 0, 45, 45));
		Assert.isTrue(nwResult.indexOf(big) != -1);
		Assert.isTrue(nwResult.indexOf(nw) != -1);

		var seResult = smallQt.query(new Rect(55, 55, 45, 45));
		Assert.isTrue(seResult.indexOf(big) != -1);
		Assert.isTrue(seResult.indexOf(se) != -1);
	}

	public function test_bounds_property() {
		Assert.equals(0.0, qt.bounds.x);
		Assert.equals(0.0, qt.bounds.y);
		Assert.equals(100.0, qt.bounds.width);
		Assert.equals(100.0, qt.bounds.height);
	}
}
