import datetime

def isDate(dt):
    try:
        datetime.datetime.strptime(dt, '%Y-%m-%d')
        return True
    except ValueError:
        return False 

print( isDate('aaaaa') )