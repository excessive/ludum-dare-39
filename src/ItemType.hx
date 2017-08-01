enum ItemType {
	Weapon;
	Armor;
	Consumable;
	Material;
}

@:publicFields
class Utils {
	static function name_of(it: ItemType) {
		var names = [
			ItemType.Weapon     => "weapon",
			ItemType.Armor      => "armor",
			ItemType.Consumable => "consumable",
			ItemType.Material   => "material"
		];
		return names[it];
	}
}
