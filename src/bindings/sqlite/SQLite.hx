package sqlite;

import love.filesystem.FilesystemModule as Fs;

/*
enum SQLiteCode {
	Empty      = 16;
	CantOpen   = 14;
	Full       = 13;
	Busy       = 5;
	Format     = 24;
	ReadOnly   = 8;
	Locked     = 6;
	Internal   = 2;
	Row        = 100;
	Perm       = 3;
	Corrupt    = 11;
	Abort      = 4;
	Schema     = 17;
	Done       = 101;
	Mismatch   = 20;
	Ok         = 0;
	TooBig     = 18;
	Auth       = 23;
	NoLFs      = 22;
	Protocol   = 15;
	IOErr      = 10;
	Constraint = 19;
	NotADB     = 26;
	Misuse     = 21;
	Range      = 25;
	NoMem      = 7;
	Error      = 1;
	Interrupt  = 9;
	NotFound   = 12;
}
*/

typedef SQLiteResult = {}

typedef SQLiteStatement = {
	var rc: Int;

	function results(): SQLiteStatement;
	function run(): Bool;

	// function hasNext(): Bool {
	// 	return false;
	// }

	// function next(): T {
		// local rc = self:step()
		// return self:getRowTable()
	// }
}

typedef SQLiteConnection = {
	function open(?filename: String): SQLiteConnection;

	function close(): Void;

	function prepare(statement: String): SQLiteStatement;
	function exec(statement: SQLiteStatement): SQLiteResult;
}

// extern class SQLiteTable {
// }

@:luaRequire("sqlite-ffi")
extern class SQLiteExtern {
	static var DBConnection: SQLiteConnection;
}

@:forward
abstract SQLite(SQLiteConnection) {
	public inline function new(?filename: String) {
		var real_filename = filename;
		if (Fs.isFile(filename)) {
			real_filename = Fs.getRealDirectory(filename);
		}
		else if (filename != ":memory:") {
			real_filename = Fs.getSaveDirectory();
			real_filename += "/";
			real_filename += filename;
		}
		this = SQLiteExtern.DBConnection.open(real_filename);
	}
}
