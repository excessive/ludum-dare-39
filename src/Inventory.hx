typedef ItemStack = {
	var count: Int;
	var item: Item;
}

class Inventory {
	public var all_items: Array<ItemStack> = [];

	public function new() {}

	public function has_item(item: Item): Bool {
		for (i in all_items) {
			if (i.item.id == item.id) {
				return true;
			}
		}
		return false;
	}

	public function pickup(e: Entity) {
		var item = ItemList.lookup(e.drop.id);
		Log.write(Log.Level.Item, "Picked up \"" + item.get_name() + "\"");
		this.add(item);
		World.remove(e);
	}

	// add new item
	public function add(item: Item, count: Int = 1) {
		var found = false;
		for (itm in all_items) {
			if (itm.item.id == item.id) {
				itm.count += count;
				found = true;
				break;
			}
		}

		if (!found) {
			all_items.push({
				count: count,
				item: item
			});
		}
	}

	function cleanup() {
		// remove empty stacks
		var i = all_items.length;
		while (i-- > 0) {
			if (all_items[i].count <= 0) {
				all_items.splice(i, 1);
			}
		}
	}

	// take items from inventory
	public function remove(item: Item, count: Int = 1) {
		for (itm in all_items) {
			if (itm.item.id == item.id) {
				itm.count -= count;
				break;
			}
		}

		this.cleanup();
	}

	public function remove_all(items: Array<Item>) {
		for (item in items) {
			for (itm in all_items) {
				if (itm.item.id == item.id) {
					itm.count -= 1;
					break;
				}
			}
		}
		this.cleanup();
	}
}
