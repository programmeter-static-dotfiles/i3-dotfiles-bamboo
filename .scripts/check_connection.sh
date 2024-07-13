HOST=debian.org

ping -c1 $HOST 1>/dev/null 2>/dev/null
SUCCESS=$?

if [ $SUCCESS -eq 0 ]
then
    echo " "
    echo " "
    echo \#9fafa1
else
    echo " "
    echo " "
    echo \#1c1c20
fi
