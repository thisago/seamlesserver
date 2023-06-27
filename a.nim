proc a[T](kind: typedesc[T]): T =
  echo astToStr kind
  result = new T

type C = ref object

echo a(C)[]
