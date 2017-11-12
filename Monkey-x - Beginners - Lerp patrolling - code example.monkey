Import mojo

Class MyGame Extends App
	Field enemyx:Int,enemyy:Int
	Field startx:Int=100,starty:Int=100
	Field destx:Int=320,desty:Int=230
	Field percentage:Float=0 ' how far in the path are we
	Field stp:Float=0.01 ' how fast do we move
    Method OnCreate()
        SetUpdateRate(60) ' Fps
		enemyx = startx
		enemyy = starty		
    End Method
    Method OnUpdate()  
    	' Get our new x and y position
    	enemyx = lerp(percentage,startx,destx)
    	enemyy = lerp(percentage,starty,desty)
    	' Set the new position    	
    	percentage+=stp
    	' Keep inside the value of 0.0 and 1.0
    	If percentage<=0 Or percentage>=1 Then stp=-stp
    End Method
    Method OnRender()
        Cls 0,0,0         
        SetColor 255,255,255
        ' Draw the enemy sprite
        DrawRect enemyx,enemyy,32,32
        '     
        DrawText "Lerp(Linear Interpolation) Patrolling - example",0,0
    End Method
	' Percentage 0 to 1 returns number between a and b
	Function lerp:Int(t:Float , a:Float, b:Float) 
		Return a + t * (b - a)
	End Function 
End Class


Function Main()
    New MyGame()
End Function
