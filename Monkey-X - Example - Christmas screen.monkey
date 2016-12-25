Import mojo

Class flake
	Field x:Float,y:Float
	Field angle:Float
	Field angleinc:Float
	Field size:Float
	
	
	Method New(x:Float,y:Float,size:Int)
		Self.x = x
		Self.y = y
		Self.size = size
		angle = Rnd()
		angleinc = 1
		If Rnd()<.5 Then angleinc=0-Rnd()
	End Method
	Method update()
		angle += 1
		If angle>360 Then angle = 0
	End Method
	Method draw()
		PushMatrix()
		Translate(x,y)
		Rotate(angle)	
		Translate(-x,-y)
		SetColor 255,255,255
		For Local i=0 To 360-45 Step 45
			Local x1:Int=x+Cos(i)*size
			Local y1:Int=y+Sin(i)*size
			Local size2:Float=size/5+size/5
			For Local i2=0 Until 3
				Local x2:Int=x+Cos(i)*size2
				Local y2:Int=y+Sin(i)*size2
				Local size3:Int
				If i2 = 0 Then size3=size/4
				If i2 = 1 Then size3=size/3
				If i2 = 2 Then size3=size/5
				Local x3:Int=x2+Cos(i-40)*size3
				Local y3:Int=y2+Sin(i-40)*size3
				Local x4:Int=x2+Cos(i+40)*size3
				Local y4:Int=y2+Sin(i+40)*size3
				DrawLine x2,y2,x3,y3
				DrawLine x2,y2,x4,y4
				size2+=size/5
			Next
			DrawLine x,y,x1,y1
		Next
		'Translate(x,y)
		PopMatrix()
	End Method
	Method newang:Int(ang1:Int,m:Int)
		ang1 += m
		If ang1<0 Then Return 360+m
		If ang1>359 Then Return 0+m
	End Method
End Class

Global myflakes:List<flake> = New List<flake>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        For Local i=0 Until 20
        	myflakes.AddLast(New flake(Rnd(640),Rnd(480),Rnd(20,40)))
        Next
    End Method
    Method OnUpdate()        
        For Local i:=Eachin myflakes
        	i.update
        Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        For Local i:=Eachin myflakes
        	i.draw
        Next
    End Method
End Class


Function Main()
    New MyGame()
End Function
