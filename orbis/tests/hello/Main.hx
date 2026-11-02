import sys.FileSystem;
import sys.io.File;

/**
 * Teste do runtime hxcpp no PS4: GC, excecoes, thread e sistema de arquivos.
 * Cada passo grava em /data/FNF/hello.log na hora (se travar, o log mostra onde).
 */
class Main {
	static inline var DIR = "/data/FNF";
	static inline var LOG = "/data/FNF/hello.log";

	static function say(s:String):Void {
		try {
			var f = File.append(LOG, false);
			f.writeString(s + "\n");
			f.close();
		} catch (e:Dynamic) {}
	}

	static function main():Void {
		try {
			if (!FileSystem.exists(DIR))
				FileSystem.createDirectory(DIR);
		} catch (e:Dynamic) {}

		say("[1] inicio: hxcpp rodando");

		// GC
		var keep:Array<Array<Int>> = [];
		for (i in 0...300000) {
			var a = [i, i + 1, i + 2];
			if (i % 1000 == 0)
				keep.push(a);
		}
		say("[2] gc ok, mantidos=" + keep.length);

		// excecoes
		try {
			throw "boom";
		} catch (e:String) {
			say("[3] excecao ok: " + e);
		}

		// thread
		var lock = new sys.thread.Lock();
		var flag = false;
		sys.thread.Thread.create(function() {
			flag = true;
			lock.release();
		});
		var got = lock.wait(3.0);
		say("[4] thread " + (got && flag ? "ok" : "FALHOU"));

		say("[5] fim");
	}
}
