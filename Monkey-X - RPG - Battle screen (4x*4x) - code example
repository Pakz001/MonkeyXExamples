Import mojo

Class battlescreen
    Field numenemies:Int
    Field numplayers:Int
    Field enemyx:Float[4]
    Field enemyy:Float[4]
    Field enemyh:Int[4]
    Field enemya:Int[4]
    Field enemyd:Int[4]
    Field temppx:Int     'holds the start location 
                        'of the currently
                        'moving agent.
    Field temppy:Int
    Field enemyattackx:Int=320+64
    Field enemyattacky:Int=480/2
    Field currentenemy:Int=0
    Field playerx:Float[4]
    Field playery:Float[4]
    Field playerh:Int[4]
    Field playera:Int[4]
    Field playerd:Int[4]
    Field playerattackx:Int=320-128
    Field playerattacky:Int=480/2
    Field currentplayer:Int=0
    Field state:String="startmoveenemyin"

    Method update()
        If state="startmoveplayerin"
            temppx = playerx[currentplayer]
            temppy = playery[currentplayer]
            state = "moveplayerin"             
        End If
        If state="moveplayerin"
            For Local i=0 Until 3
                Local an:Int=getangle(    playerattackx,playerattacky,
                                        playerx[currentplayer],
                                        playery[currentplayer])
                playerx[currentplayer] += Cos(an)
                playery[currentplayer] += Sin(an)
                If rectsoverlap(    playerx[currentplayer]-3,
                                    playery[currentplayer]-3,
                                    6,6,
                                    playerattackx-3,
                                    playerattacky-3,
                                    6,6)=True                                                                    
                    playerx[currentplayer] = playerattackx
                    playery[currentplayer] = playerattacky
                    state="playerdobattle"
                End If
            Next
        End If
        If state="moveplayerback"
            For Local i=0 Until 3
                Local an:Int=getangle(    temppx,temppy,
                                        playerx[currentplayer],
                                        playery[currentplayer])
                playerx[currentplayer] += Cos(an)
                playery[currentplayer] += Sin(an)
                If rectsoverlap(    playerx[currentplayer]-3,
                                    playery[currentplayer]-3,
                                    6,6,
                                    temppx-3,temppy-3,
                                    6,6)=True
                    playerx[currentplayer] = temppx
                    playery[currentplayer] = temppy
                    state="nextplayermove"
                End If
            Next            
        End If

        If state="startmoveenemyin"
            temppx = enemyx[currentenemy]
            temppy = enemyy[currentenemy]
            state = "moveenemyin"             
        End If
        If state="moveenemyin"
            For Local i=0 Until 3
                Local an:Int=getangle(    enemyattackx,enemyattacky,
                                        enemyx[currentenemy],
                                        enemyy[currentenemy])
                enemyx[currentenemy] += Cos(an)
                enemyy[currentenemy] += Sin(an)
                If rectsoverlap(    enemyx[currentenemy]-3,
                                    enemyy[currentenemy]-3,
                                    6,6,
                                    enemyattackx-3,
                                    enemyattacky-3,
                                    6,6)=True                                                                    
                    enemyx[currentenemy] = enemyattackx
                    enemyy[currentenemy] = enemyattacky
                    state="enemydobattle"
                End If
            Next
        End If
        If state="moveenemyback"
            For Local i=0 Until 3
                Local an:Int=getangle(    temppx,temppy,
                                        enemyx[currentenemy],
                                        enemyy[currentenemy])
                enemyx[currentenemy] += Cos(an)
                enemyy[currentenemy] += Sin(an)
                If rectsoverlap(    enemyx[currentenemy]-3,
                                    enemyy[currentenemy]-3,
                                    6,6,
                                    temppx-3,temppy-3,
                                    6,6)=True
                    enemyx[currentenemy] = temppx
                    enemyy[currentenemy] = temppy
                    state="nextenemymove"
                End If
            Next            
        End If
        If state="enemydobattle"
            ' find target
            Local exitloop:Bool=False
            Local target:Int=0
            While exitloop=False
                target=Rnd(numplayers)
                If playerh[target] > 0
                    exitloop = True
                End If
            Wend
            'do the hit
            Local points:Int
            points = enemya[currentenemy]-playerd[target]
            If points<=0 Then points = Rnd(1,3)
            playerh[target]-=points
            myeffect.AddLast(New effect(    points+" Hit",
                                            playerx[target],
                                            playery[target]))
            ' see if all players are dead
            Local playeralive:Bool=False
            For Local i=0 Until numplayers
                If playerh[i] >0 Then playeralive=True
            Next
            state="moveenemyback"
            If playeralive=False
                state="nothing"
                Return
            End If
        End If
        If state="playerdobattle"
            ' find target
            Local exitloop:Bool=False
            Local target:Int=0
            While exitloop=False
                target=Rnd(numenemies)
                If enemyh[target] > 0
                    exitloop = True
                End If
            Wend
            'do the hit
            Local points:Int
            points = playera[currentplayer]-enemyd[target]
            If points<=0 Then points = Rnd(1,3)
            enemyh[target]-=points
            myeffect.AddLast(New effect(    points+" Hit",
                                            enemyx[target],
                                            enemyy[target]))            
            ' see if all players are dead
            Local enemyalive:Bool=False
            For Local i=0 Until numenemies
                If enemyh[i] >0 Then enemyalive=True
            Next
            state="moveplayerback"
            If enemyalive=False
                state="nothing"
                Return
            End If
        End If
        
        If state="nextenemymove"            
            Local exitloop:Bool=False
            While exitloop = False
                currentenemy+=1
                If currentenemy>=numenemies
                    state="nextplayermove"
                    currentplayer=-1
                    currentenemy=0
                    Return
                Else
                    If enemyh[currentenemy]>0
                        exitloop=True
                    End If
                End If                
            Wend

            state="startmoveenemyin"
        End If

        If state="nextplayermove"
            Local exitloop:Bool=False
            While exitloop = False
                currentplayer+=1
                If currentplayer>=numplayers
                    state="nextenemymove"
                    currentplayer=0
                    currentenemy=-1
                    Return
                Else
                    If playerh[currentplayer]>0
                        exitloop = True
                    End If
                End If
            Wend                
            state="startmoveplayerin"
        End If
    End Method
    Method draw()
        SetColor 255,255,255
        drawplayers()
        drawenemies()
    End Method
    Method drawplayers()
        For Local i:Int = 0 Until numplayers
            If playerh[i] > 0
                DrawRect playerx[i],playery[i],32,32
            End If
        Next
    End Method    
    Method drawenemies()
        For Local i:Int = 0 Until numenemies
            If enemyh[i] > 0
                DrawRect enemyx[i],enemyy[i],32,32
            End If
        Next
    End Method    
    Method setstats()
        ' here you need to put the stats in
        For Local i=0 Until numplayers
            playerh[i] = Rnd(15,30)
            playera[i] = Rnd(10,30)
            playerd[i] = Rnd(5,15)
        Next
        For Local i=0 Until numenemies
            enemyh[i] = Rnd(10,20)
            enemya[i] = Rnd(10,20)
            enemyd[i] = Rnd(5,15)
        Next
    End Method
    Method setpositions()
        If numplayers = 1
            playerx[0] = 80
            playery[0] = 220-16
        End If
        If numplayers = 2
            playerx[0] = 80
            playery[0] = 220-64
            playerx[1] = 80
            playery[1] = 220+64
        End If
        If numplayers = 3
            playerx[0] = 80
            playery[0] = 220-128
            playerx[1] = 80
            playery[1] = 220
            playerx[2] = 80
            playery[2] = 220+128
        End If
        If numplayers = 4
            playerx[0] = 80
            playery[0] = 220-128
            playerx[1] = 80
            playery[1] = 220-32
            playerx[2] = 80
            playery[2] = 220+64
            playerx[3] = 80
            playery[3] = 220+164
        End If        

        If numenemies = 1
            enemyx[0] = 480
            enemyy[0] = 220-16
        End If
        If numenemies = 2
            enemyx[0] = 480
            enemyy[0] = 220-64
            enemyx[1] = 480
            enemyy[1] = 220+64
        End If
        If numenemies = 3
            enemyx[0] = 480
            enemyy[0] = 220-128
            enemyx[1] = 480
            enemyy[1] = 220
            enemyx[2] = 480
            enemyy[2] = 220+128
        End If
        If numenemies = 4
            enemyx[0] = 480
            enemyy[0] = 220-128
            enemyx[1] = 480
            enemyy[1] = 220-32
            enemyx[2] = 480
            enemyy[2] = 220+64
            enemyx[3] = 480
            enemyy[3] = 220+164
        End If                
    End Method    
    Method getangle:Int(x1:Int,y1:Int,x2:Int,y2:Int)
        Return ATan2(y1-y2, x1-x2)
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
    Field x:Float
    Field y:Float
    Field incy:Float
    Field t:String
    Field delete:Bool=False
    Method New(t:String,x:Int,y:Int)
        Self.t = t
        Self.x = x
        Self.y = y
    End Method
    Method update()
        incy+=0.05
        y-=incy
        If incy>3 Then delete = True
    End Method
    Method draw()
        SetColor 255,0,0
        DrawText t,x,y
    End Method
End Class

Global mybs:battlescreen = New battlescreen()
Global myeffect:List<effect> = New List<effect>

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        mybs.numenemies = Rnd(1,5) 
        mybs.numplayers = Rnd(1,5)
        mybs.setpositions
        mybs.setstats
    End Method
    Method OnUpdate()
        mybs.update
        If mybs.state="nothing"
            mybs.numenemies = Rnd(1,5)
            mybs.numplayers = Rnd(1,5)
            mybs.setpositions
            mybs.setstats
            mybs.currentenemy = 0
            mybs.currentplayer=0
            mybs.state="startmoveenemyin"
        End If
        For Local i:=Eachin myeffect
            i.update
        Next
        For Local i:=Eachin myeffect
            If i.delete = True Then myeffect.Remove i
        Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "RPG Battle screen.",0,0
        mybs.draw
        For Local i:=Eachin myeffect
            i.draw
        Next
    End Method
End Class


Function Main()
    New MyGame()
End Function
