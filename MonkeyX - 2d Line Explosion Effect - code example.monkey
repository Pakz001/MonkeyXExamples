Import mojo

Global numrings:Int=20

Class ring
    Field x1:Int,y1:Int
    Field x2:Float[]
    Field y2:Float[]
    Field spd:Float[]
    Field ang:Int[]
    Field n:Int
    Field thetime:Int
    Field timeout:Int
    Field deleteme:Bool
    Method New(x:Int,y:Int,num:Int,tmo:Int)
        timeout = tmo
        x1 = x
        y1 = y
        x2 = New Float[num]
        y2 = New Float[num]
        spd = New Float[num]
        ang = New Int[num]
        n = num
        For Local i=0 Until num
            ang[i] = (i*(360/num))
            x2[i] = x1+Cos(ang[i])'*Rnd(1,7)
            y2[i] = y1+Sin(ang[i])'*Rnd(1,7)
            spd[i] = 1'Rnd(0.2,0.8)
        Next
    End Method
    Method update()
        For Local i=0 Until n
            x2[i]+=Cos(ang[i])*spd[i]
            y2[i]+=Sin(ang[i])*spd[i]
        Next
        thetime+=1
        If thetime > timeout
            deleteme = True
        End If
    End Method
    Method draw()
        SetColor 0,0,0
        For Local i=1 Until n
            DrawLine x2[i-1],y2[i-1],x2[i],y2[i]
        Next
        DrawLine x2[0],y2[0],x2[n-1],y2[n-1]
    End Method
End Class

Global r:List<ring> = New List<ring>

Class MyGame Extends App
    ' time containers
    Field newring:Int[numrings]
    'locations on screen
    Field lx:Int[numrings]
    Field ly:Int[numrings]
    Method OnCreate()
        SetUpdateRate(60)
        ' set random positions
        For Local i=0 Until numrings
            lx[i] = Rnd(0,DeviceWidth)
            ly[i] = Rnd(0,DeviceHeight)
        Next
    End Method
    Method OnUpdate()
        For Local i=0 Until numrings
            newring[i]-=1
            ' if time
            If newring[i]<0
                ' chance for new location
                If Rnd(100)<10
                    lx[i] = Rnd(0,DeviceWidth)
                    ly[i] = Rnd(0,DeviceHeight)
                End If
                'add new ring
                r.AddLast(New ring(    lx[i],
                                    ly[i],
                                    Rnd(3,20),
                                    Rnd(10,60)))
                ' set new time
                newring[i] = Rnd(10,40)                                    
            End If
        Next
        ' update the rings
        For Local i:=Eachin r
            i.update
            If i.deleteme = True
                r.Remove(i)
            End If
        Next
    End Method
    Method OnRender()
        Cls 255,255,255 
        SetColor 0,0,0
        'draw the rings
        For Local i:=Eachin r
            i.draw
        Next
    End Method
End Class


Function Main()
    New MyGame()
End Function
