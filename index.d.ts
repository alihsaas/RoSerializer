import { t } from "@rbxts/t";

type Primitives = string | number | Color3 | Vector3

type Serialized<T> = {
	[P in keyof T]: T[P] extends Primitives ? string : Serialized<T[P]>
}

interface ser {

	// Luau Primitives
	string: ser.SerializerStructure<string>;

	number: ser.SerializerStructure<number>;
	
	boolean: ser.SerializerStructure<boolean>;

	Color3: ser.SerializerStructure<Color3>;

	// ser functions
	array: <T>(check: ser.SerializerStructure<T>) => ser.SerializerStructure<Array<T>>;

	interface: <T extends { [index: string]: ser.SerializerStructure<any>}>(
		name: string,
		checkTable: T
	) => ser.SerializerStructure<{ [P in keyof T]: ser.static<T[P]> }>;
}

declare namespace ser {
	/** creates a static type from a ser-defined type */
	export type static<T> = T extends ser.SerializerStructure<infer U> ? U : never;

	export interface SerializerStructure<T> {
		name: string,
		validate: t.check<T>,
		serialize<V>(value: V): V extends T ? Serialized<T> : never,
		deserialize<V>(value: V): T extends Serialized<T> ? T : never
	}
}

declare const ser: ser;
export { ser };
