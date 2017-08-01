package ai;

typedef PlanAction = {
	var name: String;
	var precond: WorldState;
	var postcond: WorldState;
	var cost: Int;
}

class ActionPlanner {
	var atoms: Array<String> = [];
	var actions: Array<PlanAction> = [];

	public static var max_atoms = 32;
	public static var max_actions = 32;

	public function new() {
		this.atoms = [];
		this.actions = [];
	}

	function action_idx(name: String): Int {
		var idx = -1;
		for (i in 0...actions.length) {
			if (actions[i].name == name) {
				idx = i;
				break;
			}
		}
		if (idx < 0 && idx < max_actions) {
			return actions.push({
				name: name,
				precond: new WorldState(),
				postcond: new WorldState(),
				cost: 1
			}) - 1;
		}
		return idx;
	}

	function atom_idx(atom: String): Int {
		var idx = atoms.indexOf(atom);
		if (idx < 0 && atoms.length < max_atoms) {
			return atoms.push(atom) - 1;
		}
		return idx;
	}

	public function set_flag(ws: WorldState, atom: String, value: Bool): Bool {
		var idx = atom_idx(atom);
		if (idx < 0) {
			trace(idx, atom, value);
			return false;
		}

		if (value) {
			ws.values.set(idx);
		}
		else {
			ws.values.unset(idx);
		}
		ws.dontcare.unset(idx);

		return true;
	}

	public function set_pre(name: String, atom: String, value: Bool): Bool {
		var idx = action_idx(name);
		if (idx < 0) {
			return false;
		}
		return set_flag(this.actions[idx].precond, atom, value);
	}

	public function set_post(name: String, atom: String, value: Bool): Bool {
		var idx = action_idx(name);
		if (idx < 0) {
			return false;
		}
		return set_flag(this.actions[idx].postcond, atom, value);
	}

	public function set_cost(name: String, cost: Int): Bool {
		var idx = action_idx(name);
		if (idx < 0) {
			return false;
		}
		this.actions[idx].cost = cost;
		return true;
	}

	// debug
	public function describe(): String {
		var buf = "";
		for (i in 0...actions.length) {
			var a = actions[i];
			buf += a.name;
			buf += ":\n";

			var pre = a.precond;
			var post = a.postcond;

			for (i in 0...max_atoms) {
				if (!pre.dontcare.is_set(i)) {
					var v = pre.values.is_set(i);
					buf += "  " + atoms[i] + "==" + Std.string(v?1:0) + "\n";
				}
			}
			for (i in 0...max_atoms) {
				if (!post.dontcare.is_set(i)) {
					var v = post.values.is_set(i);
					buf += "  " + atoms[i] + ":=" + Std.string(v?1:0) + "\n";
				}
			}
		}
		return buf;
	}

	public function describe_state(ws: WorldState): String {
		var buf = "";
		for (i in 0...max_atoms) {
			if (!ws.dontcare.is_set(i)) {
				var set = ws.values.is_set(i);
				buf += set ? atoms[i].toUpperCase() : atoms[i].toString();
				buf += ",";
			}
		}
		if (buf.charAt(buf.length-1) == ",") {
			buf = buf.substr(0, buf.length-1);
		}
		return buf;
	}

	// used by A*
	public function get_possible_state_transitions(from: WorldState): Array<{name: String, cost: Int, state: WorldState}> {
		inline function do_action(actionnr: Int, from: WorldState): WorldState {
			var nf = new WorldState();
			var pst = actions[actionnr].postcond;
			var unaffected = pst.dontcare;
			var affected   = unaffected.flipped();

			nf.values = (from.values & unaffected) | (pst.values & affected);
			nf.dontcare = from.dontcare & pst.dontcare;
			return nf;
		}

		var possible = [];
		for (i in 0...actions.length) {
			var pre = actions[i].precond;
			var care = pre.dontcare.flipped();
			var met = ((pre.values & care) == (from.values & care));
			if (met) {
				possible.push({
					name: actions[i].name,
					cost: actions[i].cost,
					state: do_action(i, from)
				});
			}
		}

		return possible;
	}
}
