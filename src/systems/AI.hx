package systems;

import ai.ActionPlanner;
import ai.Astar;
import ai.WorldState;

class AI extends System {
	override function filter(e: Entity) {
		return false;
	}

	override function process(e: Entity, dt: Float) {
		//
	}
}

class GOAP {
	var plan: ActionPlanner;

	public function new() {
		plan = new ActionPlanner();

		// not aware of any enemies, wander around.
		plan.set_pre ("go_home", "aggro", false);
		plan.set_pre ("go_home", "healthy", false);
		plan.set_post("go_home", "at_nest", false);
		plan.set_post("go_home", "at_nest", true);

		// we're hurt and the enemy isn't nearby, try to recover
		plan.set_pre ("recover", "enemy_nearby", false);
		plan.set_pre ("recover", "healthy", false);
		plan.set_pre ("recover", "at_nest", true);
		plan.set_post("recover", "healthy", true);

		// we're hurt and the enemy is close, get out of here
		plan.set_pre ("flee", "enemy_nearby", true);
		plan.set_pre ("flee", "healthy", false);
		plan.set_post("flee", "enemy_nearby", false);
		plan.set_post("flee", "at_nest", true);

		// we're healthy, but player has pissed us off
		plan.set_pre ("search", "aggro", true);
		plan.set_pre ("search", "healthy", true);
		plan.set_post("search", "enemy_nearby", true);

		// enemy is nearby, but we don't know where
		plan.set_pre ("investigate", "enemy_visible", false);
		plan.set_pre ("investigate", "enemy_nearby", true);
		plan.set_post("investigate", "enemy_visible", true);

		plan.set_pre ("guard", "enemy_visible", true);
		plan.set_pre ("guard", "enemy_nearby", false);
		plan.set_post("guard", "aggro", true);

		// the enemy is here, take them out
		plan.set_pre ("attack", "enemy_visible", true);
		plan.set_pre ("attack", "enemy_nearby", true);
		plan.set_pre ("attack", "aggro", true);
		plan.set_post("attack", "enemy_alive", false);
		plan.set_post("attack", "aggro", false);
		// trace(plan.describe());

		var start = new WorldState();
		plan.set_flag(start, "at_nest", false);
		plan.set_flag(start, "enemy_visible", true);
		plan.set_flag(start, "enemy_nearby", true);
		plan.set_flag(start, "aggro", true);
		plan.set_flag(start, "healthy", false);
		plan.set_flag(start, "enemy_alive", true);

		var goal = new WorldState();
		plan.set_flag(goal, "healthy", true);
		plan.set_flag(goal, "aggro", false);
		// plan.set_flag(goal, "alive", true);

		trace('\n'
			+ 'current state: ${plan.describe_state(start)}\n'
			+ 'desired state: ${plan.describe_state(goal)}'
		);
		var plan = Astar.plan(plan, start, goal);
		for (i in 0...plan.actions.length) {
			trace(i, plan.actions[i]);
		}
	}
}


/*
local tiny = require "tiny"
local lume = require "lume"
local cpml = require "cpml"

local system = tiny.processingSystem {
	filter = tiny.requireAll(
		"combat", "transform",
		tiny.requireAny("player", "ai")
	),
	player = false
}

--[[

* When he targets you:
	1) If you are 10m+ away, he will SHOOT
	2) If you are -5m away, he will SWAP
		* When he SWAPs, he then stop targetting you and AVOID

* He will stop targetting you after he SHOOTs and instead AVOID

--]]

function system:onAdd(entity)
	if entity.player then
		self.player = entity
	end
end

function system:onRemoveFromWorld()
	self.player = false
end

local actions = {
	AVOID  = 1, -- avoid player while on cooldown
	SHOOT  = 2, -- shoot bullets everywhere because player's out of range
	SWAP   = 3  -- black screen and trade places with the player. deals SAN damage.
}

local function decide(self)
	if self.ai.cooldown then
		return actions.AVOID
	end

	if self.ai.target:dist(self.transform.position) >= 10 then
		return actions.SHOOT
	end

	if self.ai.target:dist(self.transform.position) < 5 then
		return actions.SWAP
	end

	return actions.AVOID
end

local function cooldown_for(idea)
	local cd = {
		[actions.AVOID] = 3,
		[actions.SHOOT] = 11,
		[actions.SWAP]  = 3
	}
	return cd[idea]
end

function system:process(entity, dt)
	if not self.player then
		imgui.Text("AI: no player!")
		return
	end

	if entity.player then
		return
	end

	local player     = self.player
	local ptransform = player.transform

	local ai        = entity.ai
	local transform = entity.transform

	if ai.cooldown then
		ai.cooldown = ai.cooldown - dt
		if ai.cooldown <= 0 then
			ai.cooldown   = false
			ai.targetting = true
		end
	end

	if ai.targetting then
		ai.target = ptransform.position
	end

	if not ai.cooldown then
		local idea
		if ai.new_idea then
			idea = ai.new_idea
			ai.new_idea = false
		else
			idea = assert(decide(entity))
		end
		ai.last_idea = idea
		ai.cooldown  = cooldown_for(idea)

		if idea == actions.AVOID then
			local function nrand()
				return love.math.random()*2-1
			end

			ai.destination = transform.position
			-- find a place at least 10m away from player
			while ai.destination:dist(ptransform.position) < 10 do
				ai.destination = cpml.vec3(nrand()*10, nrand()*10, 0)
			end
			ai.target     = ai.destination
			ai.targetting = false
		end
		if idea == actions.SHOOT then
			_G.EVENT:emit("enemy shoot", transform.position, 10)
			ai.new_idea    = actions.AVOID
			ai.destination = false
		end
		if idea == actions.SWAP then
			_G.EVENT:emit("enemy swap", player, entity)
			ai.new_idea = actions.AVOID
		end
	end

	if _G.imgui then
		imgui.Text("last idea: " .. (lume.find(actions, ai.last_idea) or "never had one"))
		imgui.Value("cooldown", ai.cooldown)
		imgui.Text(ai.target and "TARGET ACQUIRED" or "TARGET ESCAPED")
	end

	if ai.destination then
		transform.velocity = (ai.destination - transform.position):normalize() * ai.speed
	else
		transform.velocity = cpml.vec3()
	end

	if ai.target then
		transform.direction   = (ptransform.position - transform.position):normalize()
		local angle = cpml.vec2(transform.direction.x, transform.direction.y):angle_to() + math.pi / 2
		transform.orientation = cpml.quat.rotate(angle, cpml.vec3.unit_z)
	end

	transform.position = transform.position + transform.velocity * dt
end

return system
*/
