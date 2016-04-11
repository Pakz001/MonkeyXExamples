Import mojo

Class ai
    ' unit locations
    Field x:Float,y:Float
    ' destination coords
    Field dx:Int,dy:Int
    ' movement speed
    Field ms:Float
    ' angle of x/y and dx/dy
    Field angle:Int
    ' state
    Field state:String="Direct Line"
    Field aroundang:Int
    Field countdown1:Int
    Method New(x:Int,y:Int)
        Self.x = x
        Self.y = y
        Self.ms = Rnd(0.5,1.5)
        Self.dx = DeviceWidth()/2
        Self.dy = DeviceHeight()/2
    End Method
    Method update()
        If state = "Wait"
            countdown1-=1
            If countdown1 < 1
                state="Direct Line"
            End If
        End If    
        If state="Move Around"
            countdown1-=1
            If countdown1 < 1 
                state="Direct Line"
            End If
            Local nx:Float = x+Cos(aroundang)*(ms*4)
            Local ny:Float = y+Sin(aroundang)*(ms*4)
            Local nxt:Bool=False
            For Local i:=Eachin myai
                    If i.x <> x
                    If i.y <> y
                   If rectsoverlap(nx,ny,16,16,i.x,i.y,16,16) = True
                    nxt = True
                       state="Wait"
                End If
                End If
                End If
            Next
            If nxt = False
                x += Cos(aroundang)*ms
                y += Sin(aroundang)*ms
            End If
           End If
        If state="Direct Line"
            angle = getangle(dx,dy,x,y)
               If distance(x,y,dx,dy) > 5
                Local nx:Float = x+Cos(angle)*(ms*4)
                Local ny:Float = y+Sin(angle)*(ms*4)
                Local nxt:Bool=False
                For Local i:=Eachin myai
                        If i.x <> x
                        If i.y <> y
                       If rectsoverlap(nx,ny,16,16,i.x,i.y,16,16) = True
                        nxt = True
                           state="Move Around"
                           countdown1 = 32
                           findopenspot()                             
                    End If
                    End If
                    End If
                Next
                If nxt = False
                    x += Cos(angle)*ms
                    y += Sin(angle)*ms
                End If
            End If
        End If        
    End Method
    Method findopenspot()
        Local sel:Int=Rnd(10)
        If sel<5 Then
            If rightturn() = False
                leftturn
            End If
        Else
            If leftturn() = False
                rightturn
            End If
        End If
    End Method
    Method rightturn:Bool()
        aroundang=angle+90
        Local nx:Float = x+Cos(aroundang)*(ms*4)
        Local ny:Float = y+Sin(aroundang)*(ms*4)
           Local nxt:Bool=False
           For Local i:=Eachin myai
               If i.x <> x
               If i.y <> y
              If rectsoverlap(nx,ny,16,16,i.x,i.y,16,16) = True
                   nxt = True
                   state="Wait"
                   countdown1 = 60
                   Return False
               End If
               End If
               End If
           Next
        Return True
    End Method

    Method leftturn:Bool()    
        aroundang=angle-90
        Local nx:Float = x+Cos(aroundang)*(ms*4)
        Local ny:Float = y+Sin(aroundang)*(ms*4)
        Local nxt:Bool=False
        For Local i:=Eachin myai
                If i.x <> x
                If i.y <> y
               If rectsoverlap(nx,ny,16,16,i.x,i.y,16,16) = True
                   nxt = True
                   state = "Wait"
                   countdown1 = 60
                   Return False
            End If
            End If
            End If
        Next
        Return True
    End Method

    Method draw()
        SetColor 255,0,0
        DrawOval x,y,16,16
        If state="Move Around"
        SetColor 255,255,0
        DrawOval     x+(Cos(aroundang)*16),
                    y+(Sin(aroundang)*16),16,16
           End If
    End Method
    Method rectsoverlap:Bool(    x1:Int, y1:Int, w1:Int, 
                                h1:Int, x2:Int, y2:Int, 
                                w2:Int, h2:Int)
        If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
        If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
        Return True
    End Method    
    Method getangle:Int(x1:Int,y1:Int,x2:Int,y2:Int)
        Return ATan2(y1-y2, x1-x2)
    End Method    
    Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
        Return Abs(x2-x1)+Abs(y2-y1)
    End Function    
End Class


Global numai:Int=10
Global myai:List<ai> = New List<ai>
' waittime before random new destination
Global dxchangecountdown:Int=500
' hold the destination of the units
Global mydx:Int,mydy:Int

Class MyApp Extends App
    
    Method OnCreate()
        SetUpdateRate(60)
        For Local i=0 To numai
            Local exitloop:Bool=False
            Local nx:Int,ny:Int
            While exitloop = False
                exitloop = True
                nx=Rnd(640)
                ny=Rnd(480)            
                For Local ii:=Eachin myai
                    If distance(nx,ny,ii.x,ii.y) < 32
                        exitloop = False
                    End If
                Next
            Wend
            myai.AddLast(New ai(nx,ny))
        Next
        Local date := GetDate()
        Seed = date[6]
        
    End Method

    Method OnUpdate()
        dxchangecountdown-=1
        If dxchangecountdown < 0
            dxchangecountdown = 500
            mydx = Rnd(32,DeviceWidth()-64)
            mydy = Rnd(32,DeviceHeight()-64)
            For Local i:=Eachin myai
                i.dx = mydx
                i.dy = mydy
            Next
        End If
        For Local i:=Eachin myai
            i.update
        Next
        If MouseHit(MOUSE_LEFT)
            dxchangecountdown = 500
            For Local i:=Eachin myai
                i.dx = MouseX()
                i.dy = MouseY()
            Next
        End If
    End Method
    
    Method OnRender()
        Cls 0,0,0
        For Local i:=Eachin myai
            i.draw
            mydx = i.dx
            mydy = i.dy
        Next
        SetColor 255,255,0
        DrawLine mydx,mydy,mydx-5,mydy
        DrawLine mydx,mydy,mydx+5,mydy
        DrawLine mydx,mydy,mydx,mydy-5        
        DrawLine mydx,mydy,mydx,mydy+5
        SetColor 255,255,255
        DrawText "Monkey-X Smarter group movement ai.",10,10
        DrawText "Press the left mouse to change dx,dy",10,25
    End Method
    
End Class

    Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
        Return Abs(x2-x1)+Abs(y2-y1)
    End Function    


Function Main()
    New MyApp
End Function
