file = open('/home/rwd82/PycharmProjects/nameslist', 'r')
file1 = open('/home/rwd82/PycharmProjects/nameslist1', 'w')

file2 = open('/home/rwd82/PycharmProjects/nameslist_output', 'w')
lines = file.readlines()
for n, line in enumerate(lines):
    print(str(n+1) + "\t" + line.strip())
    if 'Fernansez' in line:
        line = "Letty Fernandez"
    file2.write(str(n+1) + "\t" + line.strip() + "\n")
file.close()
file2.close()
