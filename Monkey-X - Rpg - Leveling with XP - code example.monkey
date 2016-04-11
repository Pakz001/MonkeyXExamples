Import mojo

Class player
    Field x:Int=50,y:Int=50
    Field w:Int=48,h:Int=48
    Field level:Int=1
    Field currentlevel:Int=0
    Field nextlevel:Int=100
    Method update()
        ' movement by input
        Local nx:Int=x,ny:Int=y
        For Local i:Int = 0 Until 4
            If KeyDown(KEY_LEFT)
                nx-=1
            End If
            If KeyDown(KEY_RIGHT)
                nx+=1
            End If
            If KeyDown(KEY_UP)
                ny-=1
            End If
            If KeyDown(KEY_DOWN)
                ny+=1
            End If
            If nx > 0 And nx < 640-w Then x = nx
            If ny > 16 And ny <(480-48)-16 Then y = ny
        Next
        ' collision with enemies
        For Local i:=Eachin myenemies
            If rectsoverlap(x,y,w,h,i.x,i.y,i.w,i.h)
                i.delete = True
                Local p:Int=Rnd(5,15)
                myeffect.AddLast(New effect(p+"XP",i.x,i.y))
                currentlevel+=p
            End If
        Next
        ' leveling up
        If currentlevel > nextlevel
            currentlevel=currentlevel-nextlevel
            level+=1            
            nextlevel=(nextlevel*1.5)
        End If
    End Method
    Method draw()
        SetColor 255,0,0
        DrawRect x,y,w,h
    End Method
    Method rectsoverlap:Bool(    x1:Int, y1:Int, w1:Int, 
                                h1:Int, x2:Int, y2:Int, 
                                w2:Int, h2:Int)
        If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
        If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
        Return True
    End Method     
End Class

Class enemy
    Field x:Int,y:Int
    Field w:Int=32,h:Int=32
    Field delete:Bool=False
    Method New()
        Local exitloop:Bool=False
        Local x1:Int,y1:Int
        While exitloop = False
            x1 = Rnd(50,500)
            y1 = Rnd(32,400)
            exitloop = True
            For Local i:=Eachin myenemies
                If rectsoverlap(x1,y1,50,50,i.x-10,
                                i.y-10,50,50)
                    exitloop = False
                End If
            Next
        Wend
        x = x1
        y = y1
    End Method
    Method update()
    End Method
    Method draw()
        SetColor 255,255,0
        DrawRect x,y,w,h
    End Method
    Method rectsoverlap:Bool(    x1:Int, y1:Int, w1:Int, 
                                h1:Int, x2:Int, y2:Int, 
                                w2:Int, h2:Int)
        If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
        If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
        Return True
    End Method     
End Class


Class effect
    Field x:Int,y:float
    Field t:String,incy:Float
    Field delete:Bool=False
    Method New(t:String,x:Int,y:Int)
        Self.x = x
        Self.y = y
        Self.t = t
    End Method
    Method update()
        incy+=0.05
        y-=incy
        If incy>3 Then delete = True
    End Method
    Method draw()
        SetColor 255,255,255
        DrawText t,x,y
    End Method
End Class

Global myplayer:player = New player()
Global myenemies:List<enemy> = New List<enemy>
Global myeffect:List<effect> = New List<effect>

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        For Local i=0 Until 10
            myenemies.AddLast(New enemy())
        Next
    End Method
    Method OnUpdate()
        myplayer.update
        ' update the enemies remove/count/repopulate
        For Local i:=Eachin myenemies
            If i.delete = True Then myenemies.Remove i
        Next
        Local enemiesgone:Bool=True
        For Local i:=Eachin myenemies
            enemiesgone = False
        Next
        If enemiesgone = True Then
            For Local i=0 Until 10
                myenemies.AddLast(New enemy())
            Next
        End If
        ' the xp text effect
        For Local i:=Eachin myeffect
            i.update
        Next
        'remove if needed
        For Local i:=Eachin myeffect
            If i.delete = True Then myeffect.Remove i
        Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Rpg player leveling/xp. Cursors to move.",0,0
        DrawText "Level : "+myplayer.level+" | Next level : " +
                 myplayer.currentlevel + " of "+myplayer.nextlevel,
                 100,460 
        For Local i:=Eachin myenemies
            i.draw
        Next
        myplayer.draw
        'draw the texteffect
        For Local i:=Eachin myeffect
            i.draw
        Next
    End Method
End Class


Function Main()
    New MyGame()
End Function
