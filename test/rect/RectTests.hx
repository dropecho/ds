package rect;

import utest.Assert;
import utest.Test;
import dropecho.ds.Rect;

class RectTests extends Test {
	public function test_intersects_overlapping_rects() {
		var a = new Rect(0, 0, 10, 10);
		var b = new Rect(5, 5, 10, 10);
		Assert.isTrue(a.intersects(b));
		Assert.isTrue(b.intersects(a));
	}

	public function test_intersects_non_overlapping_rects() {
		var a = new Rect(0, 0, 10, 10);
		var b = new Rect(20, 20, 10, 10);
		Assert.isFalse(a.intersects(b));
		Assert.isFalse(b.intersects(a));
	}

	public function test_intersects_touching_edge() {
		var a = new Rect(0, 0, 10, 10);
		var b = new Rect(10, 0, 10, 10);
		Assert.isTrue(a.intersects(b));
	}

	public function test_intersects_contained_rect() {
		var outer = new Rect(0, 0, 100, 100);
		var inner = new Rect(10, 10, 10, 10);
		Assert.isTrue(outer.intersects(inner));
		Assert.isTrue(inner.intersects(outer));
	}

	public function test_intersects_zero_size_point_inside() {
		var rect = new Rect(0, 0, 10, 10);
		var point = new Rect(5, 5, 0, 0);
		Assert.isTrue(rect.intersects(point));
	}

	public function test_intersects_zero_size_point_outside() {
		var rect = new Rect(0, 0, 10, 10);
		var point = new Rect(20, 20, 0, 0);
		Assert.isFalse(rect.intersects(point));
	}

	public function test_contains_point_inside() {
		var rect = new Rect(0, 0, 10, 10);
		Assert.isTrue(rect.contains(5, 5));
	}

	public function test_contains_point_outside() {
		var rect = new Rect(0, 0, 10, 10);
		Assert.isFalse(rect.contains(15, 15));
	}

	public function test_contains_point_on_boundary() {
		var rect = new Rect(0, 0, 10, 10);
		Assert.isTrue(rect.contains(0, 0));
		Assert.isTrue(rect.contains(10, 10));
	}

	public function test_containsRect_fully_inside() {
		var outer = new Rect(0, 0, 100, 100);
		var inner = new Rect(10, 10, 10, 10);
		Assert.isTrue(outer.containsRect(inner));
	}

	public function test_containsRect_partially_outside() {
		var outer = new Rect(0, 0, 100, 100);
		var partial = new Rect(90, 90, 20, 20);
		Assert.isFalse(outer.containsRect(partial));
	}

	public function test_containsRect_same_rect() {
		var rect = new Rect(0, 0, 10, 10);
		Assert.isTrue(rect.containsRect(new Rect(0, 0, 10, 10)));
	}

	public function test_containsRect_larger_does_not_contain_smaller() {
		var inner = new Rect(10, 10, 10, 10);
		var outer = new Rect(0, 0, 100, 100);
		Assert.isFalse(inner.containsRect(outer));
	}
}
