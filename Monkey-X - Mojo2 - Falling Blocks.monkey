Import mojo2

Global blockw:Int=32
Global blockh:Int=32

Class block
	Field x:Int
	Field y:Int	
	Field tx:Int
	Field ty:Int
	Field movedown:Bool=False
	Method New(x:Int,y:Int)
		Self.x = x
		Self.y = y
	End Method
End Class

Class machine
	Field map:Bool[][]
	Field mapwidth:Int
	Field mapheight:Int
	Field myblock:List<block> = New List<block>
	Method New(mapwidth:Int,mapheight:Int)	
		Self.mapwidth = mapwidth
		Self.mapheight = mapheight
		map = New Bool[mapwidth][]
		For Local i=0 Until mapwidth
			map[i] = New Bool[mapheight]
		Next
		For Local i=0 Until 50
			Local x:Int=Rnd(0,mapwidth)
			Local y:Int=Rnd(0,mapheight)
			createblock(x,y)
		Next
	End Method
	Method update()
		addblocks()
		destroyblocks()
		For Local i1:=Eachin myblock
			i1.movedown = False
			If i1.y+1 < mapheight Then 
				i1.movedown = True
				If map[i1.x][i1.y+1] = True Then i1.movedown = False
			End If
		Next
		For Local i1:=Eachin myblock
			If i1.movedown = True
				map[i1.x][i1.y] = False
				map[i1.x][i1.y+1] = True
				i1.y += 1	
			End If
		Next
	End Method
	Method destroyblocks()
		Local ch:Int=(GetDate[5]*10)+5		
		For Local i:=Eachin myblock
			If Rnd(0,ch)<2
				map[i.x][i.y] = False
				myblock.Remove(i)
			End If
		Next
	End Method
	Method addblocks()
		Local gw:Int[mapwidth]
		For Local i:=Eachin myblock
			gw[i.x]+=1
		Next
		For Local i=0 Until mapwidth
			If Rnd(0,100)<3
				If gw[i] < mapheight/1.2
					createblock(i,0)
				End If
			End If
		Next
	End Method
	Method createblock(x:Int,y:Int)
		If map[x][y] = True Then Return
		map[x][y] = true
		myblock.AddLast(New block(x,y))
	End Method
	Method blockexists:Bool(x:Int,y:Int)
		For Local i:=Eachin myblock
			If i.x = x And i.y = y Then Return True
		Next
		Return False
	End Method
	Method draw(imagecanvas:Canvas)
		'DebugLog 15.0/10.0
		Local cy:Float = 1.0/15.0
		For Local i:=Eachin myblock
			Local a:Float = cy*i.y
			imagecanvas.SetColor(a,a,0)
			imagecanvas.DrawRect(i.x*blockw,i.y*blockh,blockw,blockh)
		Next
	End Method
End Class

Class grid
	Field image:Image
	Field imagecanvas:Canvas
	Field gridw:Int
	Field gridh:Int
	Field cellw:Int
	Field cellh:Int
	Method New(width:Int,height:Int,cellw:Int,cellh:Int)
		Self.gridw = width
		Self.gridh = height
		Self.cellw = cellw
		Self.cellh = cellh
		image = New Image(width,height)
		image.SetHandle(0,0)
		imagecanvas = New Canvas(image)
		createimage()		
	End Method
	Method createimage()
		Local x:Int=0
		Local y:Int=0
		Local exitloop:Bool=False
		'imagecanvas.SetColor(1,1,1)
		Local cy:Float=1.0/gridh
		While exitloop = False
			'
			imagecanvas.SetColor(1-cy*y,0,0)
			imagecanvas.DrawLine(x,y,x+cellw,y)
			imagecanvas.DrawLine(x,y,x,y+cellh)
			'  
			x+=cellw
			If x>gridw Then
				x=0
				y+=cellh
			End If
			If y>gridh Then exitloop = True
		Wend
		imagecanvas.Flush()
	End Method
End Class

Class arrow
	Field image:Image
	Field imagecanvas:Canvas
	Method New(width:Int,height:Int)
		image = New Image(width,height)
		imagecanvas = New Canvas(image)
		createimage()
	End Method
	Method createimage()
		imagecanvas.SetColor 1,1,1
		Local w:Float=image.Width()
		Local h:Float=image.Height()
		Local pol:Float[14]
		pol[0] = 0
		pol[1] = h/2		
		pol[2] = w/3
		pol[3] = h		
		pol[4] = w/3
		pol[5] = h/1.5		
		pol[6] = w
		pol[7] = h/1.5		
		pol[8] = w
		pol[9] = h/3		
		pol[10] = w/3
		pol[11] = 0+h/3		
		pol[12] = w/3
		pol[13] = 0
		imagecanvas.DrawPoly(pol)
		imagecanvas.Flush
	End Method
End Class

Global myarrow:arrow
Global mygrid:grid
Global mymachine:machine

Class MyApp Extends App
	Field canvas:Canvas
	Field angle:Int=0
	Method OnCreate()
		SetUpdateRate(60)
		myarrow = New arrow(200,100)
		mygrid = New grid(DeviceWidth(),DeviceHeight(),32,32)
		mymachine = New machine(32,15)
		canvas=New Canvas
	End Method
	Method OnUpdate()
		angle+=1
		If angle>359 Then angle = 0
		mymachine.update
	End Method
	Method OnRender()
		canvas.Clear 0,0,0
		canvas.SetColor(1,1,1)
		canvas.DrawImage(mygrid.image,0,0)	
		mymachine.draw(canvas)
		canvas.SetColor(0,0,1)
		canvas.DrawImage(myarrow.image,64,64,angle)
		canvas.DrawImage(myarrow.image,64,DeviceHeight()-64,angle)
		canvas.DrawImage(myarrow.image,DeviceWidth()-64,64,360-angle)
		canvas.DrawImage(myarrow.image,DeviceWidth()-64,DeviceHeight()-64,360-angle)						
		canvas.Flush
	End
End Class


Function Main()
	New MyApp
End
