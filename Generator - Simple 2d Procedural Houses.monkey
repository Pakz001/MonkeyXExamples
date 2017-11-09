Import mojo

Class building
	Field px:Int,py:Int
	Field totalwidth:Int
	Field blockhouse:Int=1
	Field blockdoor:Int=2
	' For collision (enter/flee in home/shop)
	Field doorx:Int,doory:Int
	Field doorwidth:Int,doorheight:Int
	Field blocksmallwindow:Int=3
	Field blockwidewindow:Int=4
	Field blockcrateleft:Int=5
	Field blockcrateright:Int=6
	Field blockiceboxleft:Int=7
	Field blockiceboxright:Int=7
	Field blocktoiletleft:Int=8
	Field blocktoiletright:Int=9
	Field blockfrontcrate:Int=10
	Field blockrooftop:Int=11
	Field blockchimney:Int=12
	Field blockshopsign:Int=13
	Field houselayer:Int[]=New Int[3] 'base blocks
	Field rooftoplayer:Int[]=New Int[3]
	Field chimneylayer:Int[]=New Int[3]
	Field doorlayer:Int[] = New Int[3]
	Field windowlayer:Int[] = New Int[3] '011010'
	Field housesidelayer:Int[] = New Int[2]
	Field shopsignlayer:Int[] = New Int[3]
	Field frontlayer:Int[] = New Int[6]
	Method New(x:Int,y:Int,w:Int,isshop:Bool)
		px = x
		py = y
		totalwidth = w
		makehouse(w,isshop)
	End Method
	Method makehouse(w:Int,isshop:Bool)



		' Make the base house blocks
		For Local i:Int=0 Until w
			houselayer[i] = blockhouse
		Next
		' Create the items at the side of the houses
		If Rnd(10)<5
			' add to which side(s)
			Local sides:String="left"			
			If Rnd(10)<3 Then sides="right" 
			If Rnd(10)<3 Then sides="both"
			' Add items to side(s)
			If sides="left" Or sides="both" Then 
				housesidelayer[0] = blocktoiletleft
				If Rnd(10)<3 Then 
					housesidelayer[0] = blockcrateleft
				End If
				If Rnd(10)<3 Then
					housesidelayer[0] = blockiceboxleft
				End If	
			Endif				
			If sides="right" Or sides="both" Then 
				housesidelayer[1] = blocktoiletright
				If Rnd(10)<3 Then 
					housesidelayer[1] = blockcrateright
				End If
				If Rnd(10)<3 Then
					housesidelayer[1] = blockiceboxright
				End If	
			Endif				
		End If
		'Create the crates at the front of the house
		For Local i:Int= 0 Until (w*2)-2
			If Rnd(10)<2 Then
				frontlayer[i] = blockfrontcrate
			End If

		Next
		'Create windows
		Select w
			Case 2
				windowlayer[0] = blocksmallwindow
			Case 3
				windowlayer[0] = blockwidewindow
		End Select
		' create door
		Select w
			Case 1
				doorlayer[0] = blockdoor
				If isshop Then shopsignlayer[0] = blockshopsign
			Case 2
				doorlayer[1] = blockdoor
				If isshop Then shopsignlayer[1] = blockshopsign				
			Case 3
				doorlayer[2] = blockdoor
				If isshop Then shopsignlayer[2] = blockshopsign
		End Select
		' rooftop
		Select w
			Case 1
				rooftoplayer[0] = blockrooftop
			Case 2
				rooftoplayer[0] = blockrooftop
				rooftoplayer[1] = blockrooftop
			Case 3
				rooftoplayer[0] = blockrooftop
				rooftoplayer[1] = blockrooftop
				rooftoplayer[2] = blockrooftop
		End Select
		' chimney
		Select w
			Case 1
				chimneylayer[0] = blockchimney
			Case 2
				chimneylayer[Rnd(0,2)] = blockchimney
			Case 3
				chimneylayer[Rnd(0,3)] = blockchimney
		End Select
	
	End Method
	Method draw(w:Int,h:Int)
		Local bw:Int=w
		Local bh:Int=h
		' Draw the house blocks
		For Local i:Int=0 Until 3	
			If houselayer[i] = blockhouse Then
				SetColor 200,200,200
				DrawRect px+(i*bw),py,bw,bh
			End If
		Next
		' Draw the rooftop
		For Local i:Int=0 Until 3	
			If rooftoplayer[i] = blockrooftop Then
				SetColor 200,100,100
				DrawRect px+(i*bw),py-(bh/2),bw,bh-(bh/2)
			End If
		Next

		' Draw the chimney
		For Local i:Int=0 Until 3	
			If chimneylayer[i] = blockchimney Then
				SetColor 100,100,100
				DrawRect px+(i*bw)+(bw/4),py-(bh/1.5),bw/2,bh/4
			End If
		Next		
		'Draw the windows
		For Local i:Int=0 Until 3
			If windowlayer[i] = blocksmallwindow
				SetColor 0,100,200
				DrawRect px+(i*bw)+5,py+(bh/5),bw-10,bh-(bh/2.5)
			End If
			If windowlayer[i] = blockwidewindow
				SetColor 0,100,200
				DrawRect px+(i*bw)+5,py+(bh/5),(bw*2)-10,bh-(bh/2.5)
			End If
		Next
		' Draw the door
		For Local i:Int=0 Until 3
			If doorlayer[i] = blockdoor
				SetColor 100,50,50
				DrawRect px+(i*bw)+10,py+10,bw-20,bh-10
			End If
		Next
		' Draw the sides
		If housesidelayer[0] = blocktoiletleft Then drawtoilet(px,py,bw,bh,"left")
		If housesidelayer[1] = blocktoiletright Then drawtoilet(px,py,bw,bh,"right")
		If housesidelayer[0] = blockcrateleft Then drawsidecrate(px,py,bw,bh,"left")
		If housesidelayer[1] = blockcrateright Then drawsidecrate(px,py,bw,bh,"right")
		If housesidelayer[0] = blockiceboxleft Then drawsideicebox(px,py,bw,bh,"left")
		If housesidelayer[1] = blockiceboxright Then drawsideicebox(px,py,bw,bh,"right")
		
		'Draw the crates  at the front of the house
		For Local i:Int=0 Until (totalwidth*2)-2
			If frontlayer[i] = blockfrontcrate
				SetColor 100,50,50
				DrawRect px+((bw/2)*i),py+bh/1.2,bw/4,bh/6.4
			End If
		Next
		
		'Draw the shop sign
		For Local i:Int=0 Until totalwidth
			If shopsignlayer[i] = blockshopsign
				SetColor 255,40,30
				Local x:Int=px+(bw*i)-bw/6
				Local y:Int=py-bh/5
				DrawRect x,y,bw*1.2,bh/3
				SetColor 255,255,255
				DrawText "Shop X",x+5,y+5
			End If
		Next
	End Method
	Method drawtoilet(x:Int,y:Int,w:Int,h:Int,side:String)
		If side = "left"
		SetColor 100,50,50
		DrawRect x-w/2,y+10,w/2,h-10
		Elseif side="right"
		SetColor 100,50,50
		DrawRect (x)+totalwidth*w,y+10,w/2,h-10
		End If
	End Method
	Method drawsidecrate(x:Int,y:Int,w:Int,h:Int,side:String)
		If side = "left"
		SetColor 100,50,50
		DrawRect x-w/2,y+(h/1.5),w/2,h-(h/1.5)
		Elseif side="right"
		SetColor 100,50,50
		DrawRect (x)+totalwidth*w,y+(h/1.5),w/2,h-(h/1.5)
		End If
	End Method
	Method drawsideicebox(x:Int,y:Int,w:Int,h:Int,side:String)
		If side = "left"
		SetColor 200,200,200
		DrawRect x-w/2,y+(h/1.5),w/2,h-(h/1.5)
		Elseif side="right"
		SetColor 200,200,200
		DrawRect (x)+totalwidth*w,y+(h/1.5),w/2,h-(h/1.5)
		End If
	End Method

End Class

Class MyGame Extends App
	Field mybuilding1:building
	Field mybuilding2:building
	Field mybuilding3:building
	Field time:Int=Millisecs()
    Method OnCreate()
        SetUpdateRate(2)
		makehouses()
    End Method
    Method OnUpdate()        
		If KeyHit(KEY_SPACE) Or Millisecs() > time
			time=Millisecs()+2000
			makehouses
		End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 5,55,255
        DrawRect 0,0,DeviceWidth,150+64
        mybuilding1.draw(48,64)
        mybuilding2.draw(48,64)
        mybuilding3.draw(48,64)   
             
    End Method
    Method makehouses()
		Local z1:Bool,z2:Bool,z3:Bool
		If Rnd(5)<1 Then z1 = True
		If Rnd(5)<1 Then z2 = True		
		If Rnd(5)<1 Then z3 = True
        mybuilding1 = New building(20,150,Rnd(1,4),z1)
        mybuilding2 = New building(220,150,Rnd(1,4),z2)
        mybuilding3 = New building(460,150,Rnd(1,4),z3)
    End Method
End Class


Function Main()
    New MyGame()
End Function
