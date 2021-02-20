import { t } from "@rbxts/t";

type Primitives = string | number | boolean | Color3

type Undefined<T, K> = T extends undefined ? K | undefined : K

type KeysOfType<T, SelectedType> = {
  [key in keyof T]: SelectedType extends T[key] ? key : never
}[keyof T];

type Optional<T> = Partial<Pick<T, KeysOfType<T, undefined>>>;

type Required<T> = Omit<T, KeysOfType<T, undefined>>;

type OptionalUndefined<T> = Optional<T> & Required<T>;

interface ser {

	// Luau Primitives
	string: ser.SerializerStructure<string>;

	number: ser.SerializerStructure<number>;
	
	boolean: ser.SerializerStructure<boolean>;

	Color3: ser.SerializerStructure<Color3>;

	// ser functions
	array: <T>(check: ser.SerializerStructure<T>) => ser.SerializerStructure<Array<T>>;

	optional: <T>(check: ser.SerializerStructure<T>) => ser.SerializerStructure<T | undefined>;

	interface: <T extends { [index: string]: ser.SerializerStructure<any>}>(
		name: string,
		checkTable: T
	) => ser.SerializerStructure<OptionalUndefined<{ [P in keyof T]: ser.static<T[P]>}>>;
}

declare namespace ser {
	/** creates a static type from a ser-defined type */
	export type static<T> = T extends SerializerStructure<infer U> ? U : never;

	/** creates a type where all the properties of T are strings */
	export type Serialized<T> = {
		[P in keyof T]: T[P] extends Primitives ? Undefined<T, string> : Undefined<T, Serialized<T[P]>>
	}

	export interface SerializerStructure<T> {
		name: string,
		validate: t.check<T>,
		serialize(value: T): Serialized<T>,
		deserialize(value: Serialized<T>): T
	}
}

declare const ser: ser;
export { ser };
