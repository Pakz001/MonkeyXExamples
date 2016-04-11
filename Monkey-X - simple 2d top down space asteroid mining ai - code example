Import mojo

Const screenwidth:Int=640
Const screenheight:Int=480
Global numships:Int=45
Global minerals:Int=0
Global resettime:Int=Millisecs()+15000

Class ship
    Field x:Float
    Field y:Float
    Field angle:Int
    Field destangle:Int
    Field incx:Float
    Field incy:Float
    Field homex:Int
    Field homey:Int
    Field destx:Int
    Field desty:Int
    Field state:String="evaluate"
    Field laststate:String
    Field cargo:Int=0
    Field minetime:Int
    Method New(_x:Float,_y:Float,_angle:Int)
        x = _x
        y = _y
        homex = x
        homey = y
        angle = _angle
    End Method    
    Method update()
        Select state
            Case "evaluate" ; eval
            Case "findasteroidtomine" ; findasteroid
            Case "flytotarget" ; flytot
            Case "mineasteroid" ; mineasteroid
        End Select
    End Method
    Method mineasteroid()
        If minetime < Millisecs() Then
            For Local i:=Eachin a
                If i.x = destx And i.y = desty
                    i.s -=1
                    If i.s < 1 Then i.delete = True
                    Exit
                End If
            Next
            cargo = 1
            laststate=state
            destx = homex
            desty = homey
            state="flytotarget"
        End If
    End Method
    Method flytot()
        destangle = getangle(x,y,destx,desty)
        If leftangle(angle,destangle) = True Then angle-=5 Else angle+=5
        If angle<-180 Then angle=180
        If angle>180 Then angle = -180
        incx = Cos(angle)
        incy = Sin(angle)
        x+=incx
        y+=incy
        If distance(x,y,destx,desty) < 5 Then 
            If laststate = "findasteroidtomine" Then
                laststate = state ; state = "mineasteroid"
                minetime = Millisecs()+2000
            End If
            If laststate = "mineasteroid"
                cargo = 0
                minerals+=1
                laststate = state ; state = "evaluate"
            End If
        End If
    End Method
    Method findasteroid()
        Local sd:Int = 100000
        Local afound:Bool=False
        Local taken:Bool=False
        For Local i:=Eachin a
            Local d:Int = distance(i.x,i.y,x,y) 
            If d<sd Then
                Local taken = False
                For Local ii:=Eachin sh
                    If ii.destx = i.x And ii.desty=i.y
                        taken = True
                    End If
                Next
                If taken=False
                    sd=d
                    destx=i.x
                    desty=i.y
                    afound=True
                End If
            End If
        Next        
        If afound = True Then
            laststate= state ; state="flytotarget"
            'Print "found asteroid to mine"+Millisecs()
        Else
            'Print "Nothing state ship"+Millisecs
            state="evaluate"
            
        End If
    End Method
    Method eval()
        If Rnd(200)<2 And cargo = 0 Then laststate=state ; state="findasteroidtomine"
    End Method
    Method draw()
        SetColor 255,255,0
        DrawPoint x,y
    End Method
End Class

Class star
    Field x:Int
    Field y:Int
    Method New(_x:Int,_y:Int)
        x=_x
        y=_y
    End Method
    Method draw()
        SetColor 255,255,255
        DrawPoint x,y
    End Method
End Class

Class asteroid
    Field x:Float
    Field y:Float
    Field s:Float
    Field rotangle:Float
    Field rotangles:Float
    Field delete:Bool=False
    Method New(_x:Float,_y:Float,_s:Float)
        x = _x
        y = _y
        s = _s
        rotangle = 0.0
        rotangles = Rnd(-1,1)
    End Method
    Method update()
        rotangle += rotangles
        If rotangle <-180 Then rotangle = 180
        If rotangle >180 Then rotangle = -180
        For Local i:=Eachin a
            If i.delete = True Then a.Remove i
        Next
    End Method
    Method draw()
        PushMatrix()
        Translate x,y
        Rotate(-rotangle)
        Translate -x,-y
        SetColor 100,100,100
        DrawRect x-s/2,y-s/2,s,s
        PopMatrix()
    End Method
End Class

Class planet
    Field x:Float
    Field y:Float
    Field s:Float
    Field t:Int ' planet type
    Method New(_x:Float,_y:Float,_s:Float,_t:Int)
        x = _x
        y = _y
        s = _s
        t = _t
    End Method
    Method update()
    End Method
    Method draw()
        Select t
            Case 1 'earthlike
                SetColor 0,200,0
            Case 2 'gas
                SetColor 255,0,0
        End Select
        DrawOval x-s/2,y-s/2,s,s        
    End Method
End Class

Global p:List<planet> = New List<planet>
Global a:List<asteroid> = New List<asteroid>
Global s:List<star> = New List<star>
Global sh:List<ship> = New List<ship>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        createmap
    End Method
    Method OnUpdate()        
        If Rnd(1600)<2 And resettime<Millisecs() Then createmap ; resettime=Millisecs()+15000
        For Local i:=Eachin p 'update planets
            i.update
        Next
        For Local i:=Eachin a 'update asteroids
            i.update
        Next
        For Local i:=Eachin sh
            i.update
        Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Minerals Mined : " + minerals,0,0
        For Local i:=Eachin s 'draw stars
            i.draw
        Next
        For Local i:=Eachin p 'draw planets
            i.draw
        Next
        For Local i:=Eachin a 'draw asteroids
            i.draw
        Next
        For Local i:=Eachin sh 'draw ships
            i.draw
        Next
    End Method
End Class


Function createmap()        
        a.Clear()
        sh.Clear()
        s.Clear()
        p.Clear()
        minerals = 0
        numships = Rnd(10,300)
        Seed = Millisecs()
        'Make planets
        For Local i=0 Until 3
            Local x1 = Rnd(25,screenwidth-50)
            Local y1 = Rnd(25,screenheight-50)
            p.AddLast(New planet(x1,y1,Rnd(5,10),2))
        Next
           Local x1 = 320
           Local y1 = 240
        p.AddLast(New planet(x1,y1,Rnd(5,25),1))
        ' Make asteroids
        Local numfields:Int=Int(Rnd(3,6))
        For Local i=0 Until numfields
            Local x1 = Rnd(50,screenwidth-50)
            Local y1 = Rnd(50,screenheight-50)
            Local numa:Int=Rnd(3,45)
            For Local ii=0 Until numa
                Local x2 = Rnd(-50,50)
                Local y2 = Rnd(-50,50)
                a.AddLast(New asteroid(x1+x2,y1+y2,Rnd(2,8)))
            Next
        Next
        'Make stars
        For Local i=0 Until 100
            s.AddLast(New star(Rnd(screenwidth),Rnd(screenheight)))
        Next
        'Make ships
        For Local i=0 Until numships
            Local v:Int=Rnd(360)
            Local x1:Float
            Local y1:Float
            x1=320+(Cos(v)*32)+Rnd(-2,2)
            y1=240+(Sin(v)*32)+Rnd(-2,2)
            sh.AddLast(New ship(x1,y1,Rnd(-180,180)))
        Next
End Function
Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return Abs(x2-x1) + Abs(y2-y1)
End Function

Function getangle:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return ATan2(y1-y2, x1-x2)
End Function

Function leftangle:Bool(_angle:Int,_destinationangle:Int)
    Local cnt1 = 0    
    Local a1 = _angle
    While a1<>_destinationangle    
        a1+=1
        If a1>180 Then a1=-180
        cnt1+=1
    Wend
    If cnt1<180 Then Return True Else Return False
End Function

Function Main()
    New MyGame()
End Function
