m = [1, 2, 3, 4, 5, "happy"]
k = []
print("Array:", m)
print("Array length:", len(m))

m.insert(4, 'wefwef')
print(m)
m.append('christmas')
print(m)
for a in range(0, len(m)):
    k.append(m[a])

print("_______________Deleting elements_________________")
for i in range(0, 4):
    d = m.pop(0)
m.remove(5)

print("Original array:", k)
print("Items left in array:", m)
m.sort(reverse=True)
print("Sorted imems left in array:", m)
