Import mojo

Class gravitypoint
	Field x:Int,y:Int
	Method New(x:Int,y:Int)
		Self.x = x
		Self.y = y
	End Method
	Method draw()
		SetColor 255,255,0
		DrawOval x,y,6,6
	End Method
End Class

Class particle
	Field x:Float,y:Float
	Field incx:Float
	Field incy:Float
	Method New(x:Float,y:Float)
		Self.x = x
		Self.y = y 
		incx = Rnd(-1,1)
		incy = Rnd(-1,1)
	End Method
	Method update()
		For Local i:=Eachin mygravitypoint
			Local a:Int=getangle(x,y,i.x,i.y)
			incx+=Cos(a)/2
			incy+=Sin(a)/2
		Next
		x+=incx
		y+=incy
	End Method
	Method draw()
		SetColor 255,255,255
		DrawOval x,y,6,6
	End Method
    Function getangle:Int(x1:Int,y1:Int,x2:Int,y2:Int)
         Local dx = x2 - x1
         Local dy = y2 - y1
         Return ATan2(dy,dx)+360 Mod 360
    End Function  	
End Class

Global myparticle:List<particle> = New List<particle>
Global mygravitypoint:List<gravitypoint> = New List<gravitypoint>

Class MyGame Extends App
	Field counter:Int=0
    Method OnCreate()	
    	Seed = GetDate[5]+GetDate[4]
        SetUpdateRate(60)
        createscene
    End Method
    Method OnUpdate()  
    	counter+=1
    	If counter > 300
    		counter = 0
    		createscene
    	End If      
    	For Local i:=Eachin myparticle
    		i.update
    	Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        For Local i:=Eachin myparticle
        	i.draw
        Next
        If MouseDown(MOUSE_LEFT)
	        For Local i:=Eachin mygravitypoint
    	      	i.draw
	        Next
	    End If
	    SetAlpha 1
	    SetColor 255,255,255
	    DrawText "Monkey-X - Particles with 'Attraction' Effect - Thnx to The Coding Train",0,0
	    DrawText "Particles get attracted to <Left Mouse Button> points on the map",0,DeviceHeight-20
    End Method
End Class

Function createscene()
	myparticle = New List<particle>
	mygravitypoint = New List<gravitypoint>

    For Local i=0 Until Rnd(10,200)
    	myparticle.AddLast(New particle(Rnd(DeviceWidth),Rnd(DeviceHeight)))
	Next
	For Local i=0 Until Rnd(1,20)
		mygravitypoint.AddLast(New gravitypoint(Rnd(DeviceWidth),Rnd(DeviceHeight)))
	Next
End Function

Function Main()
    New MyGame()
End Function
