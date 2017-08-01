Import mojo

Class bullet
	' bullet x and y and radius
	Field bx:Float,by:Float,br:Int=4
	Field angle:Int
	Field bulletspeed:Float=3
	Field bulletmaxdist:Int=1200
	Field bullettraveled:Int
	Field deleteme:Bool=False
	' start location and target location for getting angle
	Method New(x1:Int,y1:Int,x2:Int,y2:Int)
		bx = x1
		by = y1
		angle = getangle(x1,y1,x2,y2)
	End Method
	Method update()
		' update the bullet position
		bx += Cos(angle)*bulletspeed
		by += Sin(angle)*bulletspeed
		' if distance to long then flag bullet for removal
		bullettraveled+=1
		If bullettraveled > bulletmaxdist Then deleteme = True
		' check collision with zombies
		For Local i:=Eachin myzombie
			If circleoverlap(bx,by,br,i.zx,i.zy,i.zr)
				deleteme = True
				i.hitpoints-=1
				' Bounce them a bit back
				i.zx += Cos(angle+Rnd(-20,20))*Rnd(5,13)
				i.zy += Sin(angle+Rnd(-20,20))*Rnd(5,13)
				i.flash = True
				' If they are dead then flag them
				If i.hitpoints<=0 Then
					i.deleteme = True
				End If
			End If
		Next
	End Method
	Method draw()
		SetColor 255,255,0
		DrawCircle bx,by,br
	End Method
End Class

Class turret
	' turret x and y and radius
	Field tx:Int,ty:Int,tr:Int=16
	Field targetx:Int,targety:Int
	Field deleteme:Bool=False
	Field shootdelay:Int
	Field maxshootdelay:Int=10
	Field currentangle:Int,shootangle:Int
	Field notarget:Bool=True
	Field turnspeed:Int=3
	Field shakex:Int,shakey:Int
	Field shaketime:Int
	Method New(x:Int,y:Int)
		tx = x
		ty = y
	End Method
	Method update()
		shootdelay += 1
		' shooting here
		' check if there are zombies on the map
		If Not myzombie.IsEmpty 			
			Local ntx:Int,nty:Int  ' New target x And y
			Local sdist:Int=1000 'shortest distance
			' find zombie closest to turret
			For Local i:=Eachin myzombie
				Local d:Int=distance(tx,ty,i.zx,i.zy)
				If d<sdist Then
					sdist = d
					ntx = i.zx
					nty = i.zy
				End If
			Next
			shootangle = getangle(tx,ty,ntx,nty)
			targetx = ntx
			targety = nty
			notarget = False
			Else
			notarget = True
		End If

		'if we have a target
		If notarget = False Then
			'turn the turrent to target
			For Local i:=0 Until turnspeed
				If currentangle <> shootangle
					currentangle += turndirection(shootangle)
					If currentangle>180 Then currentangle = -180
					If currentangle<-180 Then currentangle = 180
				End If
			Next
			' if we are aimed and reloaded then shoot
			If shootdelay > maxshootdelay
				shootdelay = 0 
				If currentangle = shootangle
					' add a shake in the opposite direction
					' of the barrel.
					shakex = -Cos(currentangle)*2
					shakey = -Sin(currentangle)*2
					shaketime = 4
					mybullet.AddLast(New bullet(tx,ty,targetx,targety))
				End If
			End If
		End If
	End Method
	' returns -1(left) or 1 right to turn towards the closest turn
	Method turndirection(destangle:Int)
		Local myangle:Int=currentangle
		Local d1:Int
		'turn left
		While myangle <> destangle
			myangle-=1
			If myangle<-180 Then myangle = 180
			d1+=1
		Wend
		myangle = currentangle
		Local d2:Int
		While myangle <> destangle
			myangle+=1
			If myangle>180 Then myangle = -180
			d2+=1
		Wend
		If d2>d1 Then Return -1 Else Return 1
	End Method
	Method draw()
		Local tx:Int = tx+shakex
		Local ty:Int = ty+shakey
		shaketime-=1
		If shaketime < 0 Then shakex = 0 ; shakey = 0
		SetColor 0,255,255
		DrawCircle tx,ty,tr
		Local x2:Int,y2:Int
		x2 = Cos(currentangle)*20
		y2 = Sin(currentangle)*20
		DrawCircle tx+x2,ty+y2,10
	End Method
End Class

Class zombie
	' zombie x and y and radius
	Field zx:Float,zy:Float,zr:Int=16
	Field tx:Int,ty:Int
	Field angle:Int
	Field movementspeed:Float=.5
	Field deleteme:Bool=False
	Field hitpoints:Int
	Field flash:Bool=False
	Field flashtime:Int
	Method New(x:Int,y:Int)
		zx = x
		zy = y
		hitpoints = Rnd(1,4)
		movementspeed = Rnd(0.1,0.3)
	End Method
	Method update()
		If Not myturret.IsEmpty 
			Local ntx:Int,nty:Int
			Local cdist:Int=1000
			For Local i:=Eachin myturret
				Local d:Int=distance(zx,zy,i.tx,i.ty)
				If d<cdist
					d = cdist
					ntx = i.tx
					nty = i.ty
				End If
			Next
			tx = ntx
			ty = nty
			angle = getangle(zx,zy,ntx,nty) 			
		End If
		'move the zombie
		zx += Cos(angle) * movementspeed
		zy += Sin(angle) * movementspeed
	End Method
	Method draw()
		If flash = False
			SetColor 255,0,0
			flashtime = 4
			Else
			SetColor 255,255,255
			flashtime -= 1
			If flashtime < 0 Then flash = False
		End If
		DrawCircle zx,zy,zr
	End Method
End Class

Global myturret:List<turret> = New List<turret>
Global myzombie:List<zombie> = New List<zombie>
Global mybullet:List<bullet> = New List<bullet>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        myturret.AddLast(New turret(DeviceWidth/2,DeviceHeight/2))
        myturret.AddLast(New turret(DeviceWidth/2-50,DeviceHeight/2))
        myturret.AddLast(New turret(DeviceWidth/2+50,DeviceHeight/2))

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
    	
    	For Local i:=Eachin myturret
    		If i.deleteme = True Then myturret.Remove(i)
    	Next
    	For Local i:=Eachin myzombie
    		If i.deleteme = True Then myzombie.Remove(i)
    	Next
    	For Local i:=Eachin mybullet
    		If i.deleteme = True Then mybullet.Remove(i)
    	Next
		If Rnd(200)<5 Then addzombie(DeviceWidth,DeviceHeight)
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


Function addzombie(Width:Int,Height:Int)
	Local l:Int=Rnd(4)
	Local x:Int,y:Int
	Select l
	Case 0
	x = 0
	y = Rnd(Height)
	Case 1
	x = Width
	y = Rnd(Height)
	Case 2
	x = Rnd(Width)
	y = 0
	Case 3
	x = Rnd(Width)
	y = Height
	End Select
	myzombie.AddLast(New zombie(x,y))
End Function

Function Main()
    New MyGame()
End Function

Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return Abs(x2-x1)+Abs(y2-y1)
End Function

Function getangle:Int(x1:Int,y1:Int,x2:Int,y2:Int)
	Local dx = x2 - x1
    Local dy = y2 - y1
    Return ATan2(dy,dx)+360 Mod 360
End Function 

Function circleoverlap:Bool(x1:Int,y1:Int,r1:Int,x2:Int,y2:Int,r2:Int)
    Local dx:Int = x1-x2
    Local dy:Int = y1-y2
    Local r:Int = r1+r2
    If dx*dx+dy*dy <= r*r Then Return True Else Return False
End
