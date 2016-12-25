Import mojo

Global tr:Int=90
Global tg:Int=10
Global tb:Int=150

Class dot
	Field x:Float,y:Float
	Field rad:Int
	Field alpha:Float
	Field r:Int,g:Int,b:Int
	Method New()
		x = Rnd(640)
		y = Rnd(480)
		rad = Rnd(3,7)
		alpha = Rnd(0.4,0.8)
		Local c:Int=Rnd(50,255)
		r = c/2+tr/2
		g = c/2+tg/2
		b = c/2+tb/2
	End Method
	Method draw()
		SetColor r,g,b
		SetAlpha alpha
		DrawCircle x,y,rad
	End Method
End Class

Class flake
	Field x:Float,y:Float
	Field angle:Float
	Field size:Float
	Field thick:Bool
	Field alpha:Float
	Method New(x:Float,y:Float,size:Int)
		Self.x = x
		Self.y = y
		Self.size = size
		alpha = Rnd(0.2,0.9)
		angle = Rnd(360)
		If Rnd()<.5 Then thick=True Else thick=False
	End Method
	Method draw()
		SetAlpha alpha
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
				If thick = True
					DrawLine x2+1,y2+1,x3+1,y3+1
					DrawLine x2+1,y2+1,x4+1,y4+1
				End If
				size2+=size/5
			Next
			DrawLine x,y,x1,y1
			If thick = True Then
				DrawLine x+1,y+1,x1+1,y1+1			
			End If
		Next
		PopMatrix()
		SetAlpha 1
	End Method
	Method newang:Int(ang1:Int,m:Int)
		ang1 += m
		If ang1<0 Then Return 360+m
		If ang1>359 Then Return 0+m
	End Method
End Class

Global myflakes:List<flake> = New List<flake>
Global mydots:List<dot> = New List<dot>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        Seed = 3
        For Local i=0 Until 70
        	mydots.AddLast(New dot())
        Next
        For Local i=0 Until 76
        	myflakes.AddLast(New flake(Rnd(-50,640),Rnd(-50,480),Rnd(20,60)))
        Next
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls tr,tg,tb
        SetColor 255,255,255
        For Local i:=Eachin mydots
        	i.draw
        Next
        For Local i:=Eachin myflakes
        	i.draw
        Next
        Scale 4,4
        SetColor 255,255,255
        DrawText "Merry Christmas",DeviceWidth/(2*4),20,.5,.5
        Scale 1,1
    End Method
End Class


Function Main()
    New MyGame()
End Function
