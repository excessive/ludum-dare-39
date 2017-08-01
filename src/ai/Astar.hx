package ai;

import math.BitField;

/** A node in our network of world states. **/
typedef AstarNode = {
	/** The state of the world at this node. **/
	var ws: WorldState;
	/** The cost so far. **/
	var g: Int;
	/** The heuristic for remaining cost (don't overestimate!) **/
	var h: Int;
	/** g+h combined. **/
	var f: Int;
	/** How did we get to this node? **/
	var actionname: Null<String>;
	/** Where did we come from? **/
	var parent: WorldState;
}

class Astar {
	/** The maximum number of nodes we can store in the opened set. **/
	static var max_open   = 1024;
	/** The maximum number of nodes we can store in the closed set. **/
	static var max_closed = 1024;

	/** This is our heuristic: estimate for remaining distance is the nr of mismatched atoms that matter. **/
	static function calc_h(fr: WorldState, to: WorldState) {
		var care = to.dontcare.flipped();
		var diff = (fr.values & care) ^ (to.values & care);
		var dist = 0;
		for (i in 0...ActionPlanner.max_atoms) {
			if (diff.is_set(i)) {
				dist++;
			}
		}
		return dist;
	}

	/*
	// from: http://theory.stanford.edu/~amitp/GameProgramming/ImplementationNotes.html
	OPEN = priority queue containing START
	CLOSED = empty set
	while lowest rank in OPEN is not the GOAL:
	current = remove lowest rank item from OPEN
	add current to CLOSED
	for neighbors of current:
		cost = g(current) + movementcost(current, neighbor)
		if neighbor in OPEN and cost less than g(neighbor):
			remove neighbor from OPEN, because new path is better
		if neighbor in CLOSED and cost less than g(neighbor): **
			remove neighbor from CLOSED
		if neighbor not in OPEN and neighbor not in CLOSED:
			set g(neighbor) to cost
			add neighbor to OPEN
			set priority queue rank to g(neighbor) + h(neighbor)
			set neighbor's parent to current
	*/
	// returns list of actions to achieve a goal
	public static function plan(planner: ActionPlanner, start: WorldState, goal: WorldState): {cost: Int, actions: Array<String>} {
		var opened: Array<AstarNode> = [];
		var closed: Array<AstarNode> = [];
		var no_solution = {
			cost: 0,
			actions: []
		};

		function idx_in_opened(ws: WorldState): Int {
			for (i in 0...opened.length) {
				if (opened[i].ws.values == ws.values) {
					return i;
				}
			}
			return -1;
		}

		function idx_in_closed(ws: WorldState): Int {
			for (i in 0...closed.length) {
				if (closed[i].ws.values == ws.values) {
					return i;
				}
			}
			return -1;
		}

		/** reconstruct the plan by tracing from last node to initial node. **/
		function reconstruct_plan(goalnode: AstarNode) {
			var curnode: Null<AstarNode> = goalnode;
			var actions = [];
			var i = 0;
			while (curnode != null && curnode.actionname != null) {
				actions.push(curnode.actionname);
				var idx = idx_in_closed(curnode.parent);
				curnode = (idx < 0) ? null : closed[idx];
				i++;
			}
			actions.reverse();
			return {
				cost: goalnode.f,
				actions: actions
			};
		}

		// put start in opened list
		var n0: AstarNode = {
			ws: start,
			parent: start,
			g: 0,
			h: calc_h(start, goal),
			f: 0,
			actionname: null,
		};
		n0.f = n0.g + n0.h;
		opened.push(n0);

		while (true) {
			if (opened.length == 0) {
				trace("Did not find a path.");
				break;
			}

			// find the node with lowest rank
			var lowestIdx=-1;
			var lowestVal=1e10;
			for (i in 0...opened.length) {
				if (opened[i].f < lowestVal) {
					lowestVal = opened[i].f;
					lowestIdx = i;
				}
			}
			// remove the node with the lowest rank
			var cur = opened[lowestIdx];
			if (opened.length != 0) {
				opened[lowestIdx] = opened.pop();
			}

			// trace(planner.describe_state(cur.ws));

			// if it matches the goal, we are done!
			var care = goal.dontcare.flipped();
			var match = ((cur.ws.values & care) == (goal.values & care));
			if (match) {
				return reconstruct_plan(cur);
			}
			// add it to closed
			closed.push(cur);

			// ran out of storage for closed set
			if (closed.length == max_closed) {
				trace("Closed set overflow");
				break;
			}

			// iterate over neighbours
			var possibilities = planner.get_possible_state_transitions(cur.ws);
			// trace("neighbors", possibilities.length);
			for (i in 0...possibilities.length) {
				var possibility = possibilities[i];
				var cost = cur.g + possibility.cost;
				var idx_o = idx_in_opened(possibility.state);
				var idx_c = idx_in_closed(possibility.state);

				// if neighbor in OPEN and cost less than g(neighbor):
				if (idx_o >= 0 && cost < opened[idx_o].g) {
					// remove neighbor from OPEN, because new path is better
					if (opened.length != 0) {
						opened[idx_o] = opened.pop();
					}
					idx_o = -1; // BUGFIX: neighbor is no longer in OPEN, signal this so that we can re-add it.
				}

				// if neighbor in CLOSED and cost less than g(neighbor):
				if (idx_c >= 0 && cost < closed[idx_c].g) {
					// remove neighbor from CLOSED
					if (closed.length != 0) {
						closed[idx_c] = closed.pop();
					}
					idx_c = -1; // BUGFIX: neighbour is no longer in CLOSED< signal this so that we can re-add it.
				}

				// if neighbor not in OPEN and neighbor not in CLOSED:
				if (idx_c == -1 && idx_o == -1) {
					var ws = possibility.state;
					var nb: AstarNode = {
						ws: ws,
						g: cost,
						h: calc_h(ws, goal),
						f: 0,
						actionname: possibility.name,
						parent: cur.ws
					};
					nb.f = nb.g + nb.h;
					opened.push(nb);
				}

				// ran out of storage for opened set
				if (opened.length == max_open) {
					trace("Opened set overflow");
					break;
				}
			}
		}

		return no_solution;
	}
}
