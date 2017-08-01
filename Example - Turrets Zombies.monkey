Import mojo

Class bullet
	' bullet x and y and radius
	Field bx:Int,by:Int,br:Int=4
	Field angle:Int
	Field deleteme:Bool=False
	Method New(x:Int,y:Int)
		bx = x
		by = y
	End Method
	Method update()
		
	End Method
	Method draw()
	End Method
End Class

Class turret
	' turret x and y and radius
	Field tx:Int,ty:Int,tr:Int=16
	Field deleteme:Bool=False
	Method New(x:Int,y:Int)
		tx = x
		ty = y
	End Method
	Method update()
	End Method
	Method draw()
	End Method
End Class

Class zombie
	' zombie x and y and radius
	Field zx:Int,zy:Int,zr:Int=16
	Field deleteme:Bool=False
	Method update()
	End Method
	Method draw()
	End Method
End Class

Global myturret:List<turret>
Global myzombie:List<zombie>
Global mybullet:List<bullet>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
    	For Local i:=Eachin myturret
    		i.update()
    	Next
    	For Local i:=Eachin myzombie
    		i.update()
    	Next
    	For Local i:=Eachin mybullet
    		i.update()
    	Next
    End Method
    Method OnRender()
        Cls 0,0,0 

    	For Local i:=Eachin myturret
    		i.draw()
    	Next
    	For Local i:=Eachin myzombie
    		i.draw()
    	Next
 	  	For Local i:=Eachin mybullet
    		i.draw()
    	Next


        SetColor 255,255,255
    End Method
End Class


Function Main()
    New MyGame()
End Function
