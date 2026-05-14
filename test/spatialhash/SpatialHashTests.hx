package spatialhash;

import utest.Assert;
import utest.Test;
import dropecho.ds.SpatialHash;

typedef Entity = {id:Int};

class SpatialHashTests extends Test {
	var grid:SpatialHash<Entity>;

	public function setup() {
		grid = new SpatialHash<Entity>(64);
	}

	public function test_canInstantiate() {
		Assert.notNull(grid);
	}

	public function test_cellSize_is_set() {
		Assert.equals(64.0, grid.cellSize);
	}

	public function test_query_returns_empty_when_nothing_inserted() {
		var result = grid.query(0, 0, 64, 64);
		Assert.equals(0, result.length);
	}

	public function test_inserted_item_found_by_query_covering_its_cell() {
		var e = {id: 1};
		grid.insert(e, 10, 10);
		var result = grid.query(0, 0, 64, 64);
		Assert.equals(1, result.length);
		Assert.equals(e, result[0]);
	}

	public function test_item_not_found_when_query_misses_its_cell() {
		var e = {id: 1};
		grid.insert(e, 10, 10); // cell (0,0)
		var result = grid.query(128, 128, 64, 64); // cell (2,2)
		Assert.equals(0, result.length);
	}

	public function test_multiple_items_in_same_cell_all_returned() {
		var a = {id: 1};
		var b = {id: 2};
		grid.insert(a, 10, 10);
		grid.insert(b, 20, 20);
		var result = grid.query(0, 0, 64, 64);
		Assert.equals(2, result.length);
	}

	public function test_items_in_different_cells_separated_by_query() {
		var a = {id: 1};
		var b = {id: 2};
		grid.insert(a, 10, 10);   // cell (0,0)
		grid.insert(b, 200, 200); // cell (3,3)
		var r1 = grid.query(0, 0, 32, 32);
		var r2 = grid.query(192, 192, 32, 32);
		Assert.equals(1, r1.length);
		Assert.equals(a, r1[0]);
		Assert.equals(1, r2.length);
		Assert.equals(b, r2[0]);
	}

	public function test_large_item_found_from_multiple_cell_queries() {
		var big = {id: 1};
		grid.insert(big, 32, 32, 64, 64); // spans cells (0,0),(1,0),(0,1),(1,1)
		Assert.equals(1, grid.query(0, 0, 10, 10).length);
		Assert.equals(1, grid.query(90, 0, 10, 10).length);
		Assert.equals(1, grid.query(0, 90, 10, 10).length);
		Assert.equals(1, grid.query(90, 90, 10, 10).length);
	}

	public function test_large_item_deduplicated_in_single_query() {
		var big = {id: 1};
		grid.insert(big, 32, 32, 64, 64); // spans 4 cells
		var result = grid.query(0, 0, 200, 200);
		Assert.equals(1, result.length);
	}

	public function test_remove_item_no_longer_returned() {
		var e = {id: 1};
		grid.insert(e, 10, 10);
		grid.remove(e, 10, 10);
		var result = grid.query(0, 0, 64, 64);
		Assert.equals(0, result.length);
	}

	public function test_remove_only_removes_target_item() {
		var a = {id: 1};
		var b = {id: 2};
		grid.insert(a, 10, 10);
		grid.insert(b, 20, 20);
		grid.remove(a, 10, 10);
		var result = grid.query(0, 0, 64, 64);
		Assert.equals(1, result.length);
		Assert.equals(b, result[0]);
	}

	public function test_clear_removes_all_items() {
		grid.insert({id: 1}, 10, 10);
		grid.insert({id: 2}, 200, 200);
		grid.clear();
		Assert.equals(0, grid.query(0, 0, 1000, 1000).length);
	}

	public function test_negative_coordinates_work() {
		var e = {id: 1};
		grid.insert(e, -100, -100);
		var result = grid.query(-128, -128, 64, 64);
		Assert.equals(1, result.length);
		Assert.equals(e, result[0]);
	}

	public function test_point_query_returns_items_in_same_cell() {
		var e = {id: 1};
		grid.insert(e, 10, 10);
		// zero-size query in same cell
		var result = grid.query(10, 10, 0, 0);
		Assert.equals(1, result.length);
	}
}
