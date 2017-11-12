Import mojo

'
' This is our enemy class
' 
Class enemy
	Field px:Int,py:Int
	Method New(x:Int,y:Int)
		Self.px = x
		Self.py = y
	End Method
	Method move(x:Int,y:Int)
		px += x
		py += y
	End Method
End Class

Class MyGame Extends App
	' How many enemies are there
	Field numenemies:Int=10
	' Set up the array using the enemy class
	Field myenemy:enemy[]
    Method OnCreate()
    	' Create the enemies in the array
    	myenemy = New enemy[numenemies]
    	For Local i:Int=0 Until numenemies
    		myenemy[i] = New enemy(Rnd(DeviceWidth()),Rnd(DeviceHeight))
    	Next
    End Method
    Method OnUpdate()  
    End Method
    Method OnRender()
        Cls 0,0,0         
        SetColor 255,255,255
        ' Loop through all array containers (numenemies)
        ' and draw them.
        For Local i:=Eachin myenemy
        	DrawRect i.px,i.py,32,32
        Next
        
        ' We can acces arrays directly and call/modify anything inside it.
        myenemy[0].move(5,0)
        If myenemy[0].px > DeviceWidth Then myenemy[0].px = -10
    End Method

End Class


Function Main()
    New MyGame()
End Function
