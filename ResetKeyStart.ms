if IsKIndOf ResetKeyStart RolloutClass do DestroyDialog ResetKeyStart
rollout ResetKeyStart "Reset Key Start" Width:170 Height:55
(
	Spinner SpinnerDestination "Reset All Key Start To :" Pos:[5,5] FieldWidth:40 Type:#Integer Range:[-10000,10000,0]
	Button ButtonApply "Apply" Pos:[5,25] Width:160 Height:25
	fn UpdateKeyRange Controller Range =
	(
		if Controller == Undefined do return ()
		for i = 1 to Controller.NumSubs do UpdateKeyRange Controller [ i ].Controller Range
		Local n = NumKeys Controller
		if n < 1 do return ()
		Local t1 = ( GetKeyTime Controller 1 ) as Integer / TicksPerFrame
		Local t2 = ( GetKeyTime Controller n ) as Integer / TicksPerFrame
		if t1 < Range.X do Range.X = t1
		if t2 > Range.Y do Range.Y = t2
	)

	fn GetKeyRange Nodes =
	(
		Local Range = [1E10,-1E10]
		for Node in Nodes do UpdateKeyRange Node.Controller Range
		if Range.X > Range.Y do return Undefined
		Range
	)

	mapped fn MoveKeyStartTo Node Frame =
	(
		Local Range = GetKeyRange #( Node )
		if Range == Undefined do return ()
		if Range.X == Frame do return ()
		Local Offset = Frame - Range.X
		Local Controller = Node.Controller
		if IsKindOf Controller Vertical_Horizontal_Turn then
		(
			Biped.MoveKeys Controller.Vertical Offset
			Biped.MoveKeys Controller.Horizontal Offset
			Biped.MoveKeys Controller.Turning Offset
		)
		else MoveKeys Node Offset
	)
	
	on ButtonApply Pressed do
	(
		MoveKeyStartTo Objects SpinnerDestination.Value
	)
)
CreateDialog ResetKeyStart