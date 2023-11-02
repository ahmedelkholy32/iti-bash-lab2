#!/bin/bash
### This script use to insert, display, edit and delay db file
### DB file include thes fields (id name gender email)

### This script has two mod
##  1- Interactive mode
#       - db.sh
#       - db.sh insert
#       - db.sh display
#       - db.sh edit
#       - db.sh edit id
#       - db.sh delete
#       - db.sh delete id
##  2- Deactive mode
#       - db.sh insert id name gender email
#       - db.sh display id

### Exit codes:
#       0: success
#       1: permission deny
#       2: invalid action with not deactive mod
#       3: invalid required parameter for insert
#       4: invalid required parameter for display
#       5: invalid required parameter for edit
#       6: invalid required parameter for delete
#       7: id not positive integer
#       8: id exist before if user make insert
#       9: Invalid gender value
#       10: email exist before
#       11: id not exist

### make function to check if id is positive integer or not
function is_positive_int {
    echo $(echo ${1} | grep -c "^[0-9]\+$")
}

## make function to check if certain value exist in db file
function val_exist {
    echo $(grep -cw "$1" db.txt)
}

## check if gender value is valid
function gender_valid {
    case ${1} in
        'male')
            echo "male"
            ;;
        'Male')
            echo "male"
            ;;
        'MALE')
            echo "male"
            ;;
        'female')
            echo "female"
            ;;
        'Female')
            echo "female"
            ;;
        'FEMALE')
            echo "female"
            ;;
        *)
            echo "invalid"
    esac
}
### make function for insert action
function insert { 
    # check if user use interactive mode or deactive mode
    if [ ${#} -eq 4 ]
        then
            # check id is positive integer
            [ $(is_positive_int ${1}) -ne 1 ] && echo Invalid Id: Id must be positive intger && exit 7
            # check if id exist before or not
            [ $(val_exist ${1}) -eq 1 ] && echo This Id exist before && exit 8
            # check if gender is valid or not
            g=$(gender_valid ${3})
            [ ${g} == 'invalid' ] && echo Invalid gender value && exit 9
            # check if email exist before or not
            [ $(val_exist ${4}) -eq 1 ] && echo This Email exist before && exit 10
            # insert value to db file
            echo "${1}:${2}:${g}:${4}" >> db.txt
            echo "################################"
            echo "# Done record data into db.txt #"
            echo "################################"
        else
            echo You inside Insert interactive mode
            # read id value from stdin
            cond=1
            while [ $cond -eq 1 ]
                do
                    echo -n "Id: "
                    read id
                    # check id is positive integer
                    if [ $(is_positive_int ${id}) -ne 1 ]
                        then
                            echo Invalid Id: Id must be positive intger
                        else
                            # check if id exist before or not
                            if [ $(val_exist ${id}) -eq 1 ]
                                then
                                    echo This Id exist before
                                else # if id is valid stop while loop
                                    cond=0
                            fi
                    fi
                done
            # read Name from user
            echo -n "Name: "
            read name
            # read gender from user
            cond=1
            while [ ${cond} -eq 1 ]
                do
                    # check if gender is valid or not
                    echo -n "Gender: "
                    read gender
                    gender=$(gender_valid ${gender})
                    if [ ${gender} == 'invalid' ]
                        then
                            echo Invalid gender value
                        else
                            cond=0
                    fi
                done
            # read email from user
            cond=1
            while [ ${cond} -eq 1 ]
                do
                    echo -n "Email: "
                    read email
                    # check if email exist before or not
                    if [ $(val_exist ${email}) -eq 1 ]
                        then
                            echo This Email exist before
                        else
                            cond=0
                    fi
                done
            # insert value to db file
            echo "${id}:${name}:${gender}:${email}" >> db.txt
            echo "################################"
            echo "# Done record data into db.txt #"
            echo "################################"
    fi
}

## display function
function display {
    if [ ${#} -eq 1 ]
        then
            # check id is positive integer
            [ $(is_positive_int ${1}) -ne 1 ] && echo Invalid Id: Id must be positive intger && exit 7
            # check if id exist
            [ $(val_exist ${1}) -eq 0 ] && echo This Id not exist && exit 11
            id=${1}
        else
            # read id from user
            cond=1
            while [ ${cond} -eq 1 ]
                do
                    echo -n "Id: "
                    read id
                    # check id is positive integer
                    if [ $(is_positive_int ${id}) -ne 1 ]
                        then
                            echo Invalid Id: Id must be positive intger
                        else
                            # check if id exist
                            if [ $(val_exist ${id}) -eq 0 ]
                                then
                                    echo This Id not exist
                                else
                                    cond=0
                            fi
                    fi
                done
    fi
    # display record
    result=$(grep -w "^${id}" db.txt)
    echo -e "Id\t: $(echo ${result} | awk 'BEGIN { FS=":" }{ print $1 }')"
    echo -e "Name\t: $(echo ${result} | awk 'BEGIN { FS=":" }{ print $2 }')"
    echo -e "Gender\t: $(echo ${result} | awk 'BEGIN { FS=":" }{ print $3 }')"
    echo -e "Email\t: $(echo ${result} | awk 'BEGIN { FS=":" }{ print $4 }')"
}

## edit function
function edit {
    echo You inside Edit interactive mode
    if [ ${#} -eq 1 ]
        then
            # check id is positive integer
            [ $(is_positive_int ${1}) -ne 1 ] && echo Invalid Id: Id must be positive intger && exit 7
            # check if id exist
            [ $(val_exist ${1}) -eq 0 ] && echo This Id not exist && exit 11
            id=${1}
        else
            # read id from user
            cond=1
            while [ ${cond} -eq 1 ]
                do
                    echo -n "Id: "
                    read id
                    # check id is positive integer
                    if [ $(is_positive_int ${id}) -ne 1 ]
                        then
                            echo Invalid Id: Id must be positive intger
                        else
                            # check if id exist
                            if [ $(val_exist ${id}) -eq 0 ]
                                then
                                    echo This Id not exist
                                else
                                    cond=0
                            fi
                    fi
                done
    fi
    # call display function to display the id info
    display ${id} 
    cond=1
    while [ ${cond} -eq 1 ]
        do
            # get quiry
            name=$(echo ${result} | awk 'BEGIN { FS=":" }{ print $2 }')
            gender=$(echo ${result} | awk 'BEGIN { FS=":" }{ print $3 }')
            email=$(echo ${result} | awk 'BEGIN { FS=":" }{ print $4 }')
            echo "Id: 1, Name: 2, Gender: 3, Email: 4, Quit: q"
            echo -n "which parameter want to change: "
            read a
            case ${a} in
                1)
                    cond2=1
                    while [ ${cond2} -eq 1 ]
                        do
                            echo -n "New Id: "
                            read nid
                            # check id is positive integer
                            if [ $(is_positive_int ${nid}) -ne 1 ]
                                then
                                    echo Invalid Id: Id must be positive intger
                                else
                                    # check if id exist before
                                    if [ $(val_exist ${nid}) -eq 1 ]
                                        then
                                            echo This Id exist before
                                        else
                                            cond2=0
                                    fi
                            fi
                        done
                    sed -i "s/${id}/${nid}/g" db.txt
                    id=${nid}
                    echo "----------"
                    display ${id}
                    echo "###############"
                    echo "# Update done #"
                    echo "###############"
                    ;;
                2)
                    # read Name from user
                    echo -n "New Name: "
                    read nname
                    sed -i "s/${id}:${name}/${id}:${nname}/g" db.txt
                    echo "----------"
                    display ${id}
                    echo "###############"
                    echo "# Update done #"
                    echo "###############"
                    ;;
                3)
                    # read new gender from user
                    cond2=1
                    while [ ${cond2} -eq 1 ]
                        do
                            # check if new gender is valid or not
                            echo -n "New Gender: "
                            read ngender
                            ngender=$(gender_valid ${ngender})
                            if [ ${ngender} == 'invalid' ]
                                then
                                    echo Invalid gender value
                                else
                                    cond2=0
                            fi
                        done
                    sed -i "s/${id}:${name}:${gender}/${id}:${name}:${ngender}/g" db.txt
                    echo "----------"
                    display ${id}
                    echo "###############"
                    echo "# Update done #"
                    echo "###############"
                    ;;
                4)
                    # read new email from user
                    cond2=1
                    while [ ${cond2} -eq 1 ]
                        do
                            echo -n "New Email: "
                            read nemail
                            # check if email exist before or not
                            if [ $(val_exist ${nemail}) -eq 1 ]
                                then
                                    echo This Email exist before
                                else
                                    cond2=0
                            fi
                        done
                    sed -i "s/${email}/${nemail}/g" db.txt
                    echo "----------"
                    display ${id}
                    echo "###############"
                    echo "# Update done #"
                    echo "###############"
                    ;;
                'q')
                    exit 0
                    ;;
                *)
                    echo "Invalid Number"
                    ;;
            esac
        done
}

# make delete function
function delete {
    echo You inside Delted interactive mode
    if [ ${#} -eq 1 ]
        then
            # check id is positive integer
            [ $(is_positive_int ${1}) -ne 1 ] && echo Invalid Id: Id must be positive intger && exit 7
            # check if id exist
            [ $(val_exist ${1}) -eq 0 ] && echo This Id not exist && exit 11
            id=${1}
        else
            # read id from user
            cond=1
            while [ ${cond} -eq 1 ]
                do
                    echo -n "Id: "
                    read id
                    # check id is positive integer
                    if [ $(is_positive_int ${id}) -ne 1 ]
                        then
                            echo Invalid Id: Id must be positive intger
                        else
                            # check if id exist
                            if [ $(val_exist ${id}) -eq 0 ]
                                then
                                    echo This Id not exist
                                else
                                    cond=0
                            fi
                    fi
                done
    fi
    # call display function to display the id info
    display ${id}
    # ask user if he want really delete this record
    cond=1
    while [ ${cond} -eq 1 ]
        do
            echo -n "You want to delete this record (y/n)? "
            read conf
            case ${conf} in
                'y')
                    old=$(grep -vw "^${id}" db.txt)
                    echo "$old" > db.txt
                    echo "####################"
                    echo "# Delete......Done #"
                    echo "####################"
                    exit 0
                    ;;
                'n')
                    exit 0
                    ;;
            esac
        done
}

### function used if user don't insert wanted action
function interactive {   
    while [ 1 -eq 1 ]
        do
            echo "Welcome to Interactive Mode"
            echo "What action you want?"
            echo "1     Insert"
            echo "2     Display"
            echo "3     Edit"
            echo "4     Delete"
            echo -n "Enter your choose or q to quit: "
            read a
            case ${a} in
                1)
                    insert
                    ;;
                2)
                    display
                    ;;
                3)
                    edit
                    ;;
                4)
                    delete
                    ;;
                'q')
                    exit 0
                    ;;
                *)
                    echo "Invalid number, try agin"
                    ;;
            esac
        done
}

# touch db file
[ ! -f db.txt ] && touch db.txt
# check if user have permission on db file or not
[ ! -r db.txt ] && echo "permission deny" && exit 1
[ ! -w db.txt ] && echo "permission deny" && exit 1

# check if user want interactive or deactive mode
case ${1} in
    "")
        interactive
        ;;
    "insert")
        # check if user want to enter to insert active mod
        [ ${#} -eq 1 ] && insert
        [ ${#} -gt 1 ] && [ ${#} -eq 5 ] && insert "${2}" "${3}" "${4}" "${5}"
        [ ${#} -gt 1 ] && [ ${#} -ne 5 ] && echo "insert take 0 parameter (Interactive mode) or 4 parameter (Deactive mode)" && exit 3
        ;;
    "display")
        [ ${#} -eq 1 ] && display
        [ ${#} -gt 1 ] && [ ${#} -eq 2 ] && display "${2}"
        [ ${#} -gt 1 ] && [ ${#} -ne 2 ] && echo "display take 0 parameter (Interactive mode) or 1 parameter (Deactive mode)" && exit 4
        ;;
    "edit")
        [ ${#} -eq 1 ] && edit
        [ ${#} -gt 1 ] && [ ${#} -eq 2 ] && edit "${2}"
        [ ${#} -gt 1 ] && [ ${#} -ne 2 ] && echo "edit take 0 parameter (Interactive mode) or 1 parameter (id)" && exit 5
        ;;
    "delete")
        [ ${#} -eq 1 ] && delete
        [ ${#} -gt 1 ] && [ ${#} -eq 2 ] && delete "${2}"
        [ ${#} -gt 1 ] && [ ${#} -ne 2 ] && echo "delete take 0 parameter (Interactive mode) or 1 parameter (id)" && exit 6
        ;;
    *)
        echo "Invalid value"
        exit 2
        ;;
esac
exit 0
