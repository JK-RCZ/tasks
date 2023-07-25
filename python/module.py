def note():
    """asks for username, password, creates comlicated passwd (name+password), asks for list,
       returns (name, complicated password, list[])"""
    m = []
    i = 0
    print("Hello. This app let's you create list of your wishes and sends it to GOD")
    nm = input ("Please, introduce yourself:")
    pwd = input("Hello, " + nm.title() + ". In order to protect your data, create your password:")
    print("It seems to be too simple.")
    cpwd = nm + pwd
    print("In way to protect your wish list from devil himself let me introduce you your new password: " + cpwd)
    print("Try to enter it in order to remember:")
    while input() != cpwd:
        print ("Wrong! Try again!")
    print ("Congrats! "
       "Now we are ready to create your wish list. "
       "Type (q) when you're done")
    while True:
        k = input(str(i+1) + ":")
        m.append(k)
        if m[i] == 'q':
            m.pop(i)
            break
        else:
            i = i+1
    print("Great, we've got wish list from " + str(i) + " positions saved.")
    print("____________________________________________________________")

    return nm, cpwd, m









