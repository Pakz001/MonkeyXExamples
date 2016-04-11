Import mojo

' this is the laser class
Class laser
    Field x:Float,y:Float
    Field lw:Int=4
    Field lh:Int=6
    Field laserspeed:Int=4
    Field delete:Bool=False
    Method New(x:Int,y:Int)
        Self.x=x
        Self.y=y
    End Method
    Method update()
        For Local i=0 Until laserspeed
            y-=1
        Next
        If y<-10 Then delete = True
    End Method
    Method draw()
        SetColor 0,0,255
        DrawRect x,y,lw,lh
    End Method
End Class

Class player
    Field x:Int
    Field y:Int
    ' player height and width
    Field ph:Int=16
    Field pw:Int=16
    Field playerspeed:Int=4
    Field targetx:Int
    Field laserdelay:Int=0
    Method New()
        Self.x = (DeviceWidth()/2)-(ph/2)
        Self.y = DeviceHeight()-ph
    End Method
    Method update()
        ' move the player around
        For Local i=0 Until playerspeed
            If x < targetx Then x+=1
            If x > targetx Then x-=1
            If x = targetx Then findtarget
        Next
        ' fire a laser every now and then
        laserdelay+=1
        If laserdelay>10 Then
            laserdelay = 0
            mylaser.AddLast(New laser(x,y))
        End If
    End Method
    ' find new position to move to
    Method findtarget()
        targetx = Rnd(0,DeviceWidth()-pw)
    End Method
    Method draw()
        SetColor 255,255,0
        DrawRect x,y,pw,ph
    End Method
End Class

Class enemy
    ' location where the sprite it at
    Field x:Int,y:Int
    ' Tile width and height
    Field tw:Int=16
    Field th:Int=16
    ' enemy movement
    Field edir:String="right"
    ' the sprite
    Field map:Int[][] = [    [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
                            [1,1,1,2,2,1,1,1,1,1,1,1,2,2,1,1,1],
                            [1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1],
                            [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
                            [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
                            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                            [1,1,1,1,0,0,1,2,2,2,2,1,0,0,1,1,1],                            
                            [0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,0],
                            [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0]]
    Field allgone:Bool=False
    Method New()
        ' Position the sprite
        Self.x = DeviceWidth()/2-((map[0].Length*tw)/2)
        Self.y = th*3
    End Method
    Method update()
        ' move the enemy
        If edir="right" Then
            x+=1
            Else
            x-=1
        End If
        If x+(map[0].Length*tw) > DeviceWidth() Or
            x<0 Then
            If edir = "left" Then
                edir="right"
                Else
                edir="left"
            End If
        End If
        ' collision between the lasers and the enemy
        For Local i:=Eachin mylaser
        For Local y1=0 Until map.Length
        For Local x1=0 Until map[0].Length
            If map[y1][x1] > 0
                Local x2:Int=(x1*tw)+x
                Local y2:Int=(y1*th)+y
                If rectsoverlap(i.x,i.y,i.lw,i.lh,x2,y2,tw,th)
                    map[y1][x1]=0
                    i.delete = True
                End If
            End If
        Next
        Next            
        Next
        ' if the enemy is completely gone then
        ' put this in the allgone variable
        allgone=True
        For Local y1=0 Until map.Length
        For Local x1=0 Until map[0].Length
            If map[y1][x1] > 0
                allgone = False
            End If
        Next
        Next
    End Method
    Method draw()
        For Local y1=0 Until map.Length
        For Local x1=0 Until map[0].Length
            If map[y1][x1] = 1
                SetColor 255,0,0
                DrawRect x+(x1*tw),y+(y1*th),tw,th
            End If
            If map[y1][x1] = 2
                SetColor 255,100,0
                DrawRect x+(x1*tw),y+(y1*th),tw,th
            End If
        Next
        Next
    End Method
    Method rectsoverlap:Bool(    x1:Int, y1:Int, w1:Int, 
                                h1:Int, x2:Int, y2:Int, 
                                w2:Int, h2:Int)
        If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
        If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
        Return True
    End Method    
End Class

Global myenemy:enemy
Global myplayer:player
Global mylaser:List<laser>

Class MyApp Extends App

    
    Method OnCreate()
        SetUpdateRate(60)
        ' set up the stuff for
        ' the first time.
        myenemy = New enemy()
        myplayer = New player()
        mylaser = New List<laser>
    End Method

    Method OnUpdate()
        ' if the big sprite is destroyed
        ' then make him new again
        If myenemy.allgone = True
            myenemy = New enemy()
        End If
        ' update the classes
        myplayer.update
        myenemy.update
        For Local i:=Eachin mylaser
            i.update
        Next
        ' if a laser is set to delete
        ' then delete it from the list
        For Local i:=Eachin mylaser
            If i.delete = True Then mylaser.Remove i
        Next
    End Method
    
    Method OnRender()
        Cls 0,0,0
        myenemy.draw
        For Local i:=Eachin mylaser
            i.draw
        Next
        myplayer.draw
    End Method
    
End Class

Function Main()
    New MyApp
End Function

        
        
    
    
    
