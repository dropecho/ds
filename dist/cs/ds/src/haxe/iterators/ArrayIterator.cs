// Generated by Haxe 4.1.5
using haxe.root;

#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.iterators {
	public class ArrayIterator<T> : global::haxe.lang.HxObject, global::haxe.iterators.ArrayIterator {
		
		public ArrayIterator(global::haxe.lang.EmptyObject empty) {
		}
		
		
		public ArrayIterator(global::haxe.root.Array<T> array) {
			global::haxe.iterators.ArrayIterator<object>.__hx_ctor_haxe_iterators_ArrayIterator<T>(((global::haxe.iterators.ArrayIterator<T>) (this) ), ((global::haxe.root.Array<T>) (array) ));
		}
		
		
		protected static void __hx_ctor_haxe_iterators_ArrayIterator<T_c>(global::haxe.iterators.ArrayIterator<T_c> __hx_this, global::haxe.root.Array<T_c> array) {
			__hx_this.current = 0;
			{
				__hx_this.array = array;
			}
			
		}
		
		
		public static object __hx_cast<T_c_c>(global::haxe.iterators.ArrayIterator me) {
			return ( (( me != null )) ? (me.haxe_iterators_ArrayIterator_cast<T_c_c>()) : default(object) );
		}
		
		
		public virtual object haxe_iterators_ArrayIterator_cast<T_c>() {
			if (global::haxe.lang.Runtime.eq(typeof(T), typeof(T_c))) {
				return this;
			}
			
			global::haxe.iterators.ArrayIterator<T_c> new_me = new global::haxe.iterators.ArrayIterator<T_c>(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			global::haxe.root.Array<string> fields = global::haxe.root.Reflect.fields(this);
			int i = 0;
			while (( i < fields.length )) {
				string field = fields[i++];
				global::haxe.root.Reflect.setField(new_me, field, global::haxe.root.Reflect.field(this, field));
			}
			
			return new_me;
		}
		
		
		public global::haxe.root.Array<T> array;
		
		public int current;
		
		public bool hasNext() {
			return ( this.current < this.array.length );
		}
		
		
		public T next() {
			return this.array[this.current++];
		}
		
		
		public override double __hx_setField_f(string field, int hash, double @value, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 1273207865:
					{
						this.current = ((int) (@value) );
						return @value;
					}
					
					
					default:
					{
						return base.__hx_setField_f(field, hash, @value, handleProperties);
					}
					
				}
				
			}
		}
		
		
		public override object __hx_setField(string field, int hash, object @value, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 1273207865:
					{
						this.current = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						return @value;
					}
					
					
					case 630156697:
					{
						this.array = ((global::haxe.root.Array<T>) (global::haxe.root.Array<object>.__hx_cast<T>(((global::haxe.root.Array) (@value) ))) );
						return @value;
					}
					
					
					default:
					{
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
		}
		
		
		public override object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 1224901875:
					{
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(this, "next", 1224901875)) );
					}
					
					
					case 407283053:
					{
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(this, "hasNext", 407283053)) );
					}
					
					
					case 1273207865:
					{
						return this.current;
					}
					
					
					case 630156697:
					{
						return this.array;
					}
					
					
					default:
					{
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
		}
		
		
		public override double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties) {
			unchecked {
				switch (hash) {
					case 1273207865:
					{
						return ((double) (this.current) );
					}
					
					
					default:
					{
						return base.__hx_getField_f(field, hash, throwErrors, handleProperties);
					}
					
				}
				
			}
		}
		
		
		public override object __hx_invokeField(string field, int hash, object[] dynargs) {
			unchecked {
				switch (hash) {
					case 1224901875:
					{
						return this.next();
					}
					
					
					case 407283053:
					{
						return this.hasNext();
					}
					
					
					default:
					{
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
			}
		}
		
		
		public override void __hx_getFields(global::haxe.root.Array<string> baseArr) {
			baseArr.push("current");
			baseArr.push("array");
			base.__hx_getFields(baseArr);
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.iterators {
	[global::haxe.lang.GenericInterface(typeof(global::haxe.iterators.ArrayIterator<object>))]
	public interface ArrayIterator : global::haxe.lang.IHxObject, global::haxe.lang.IGenericObject {
		
		object haxe_iterators_ArrayIterator_cast<T_c>();
		
		bool hasNext();
		
	}
}


