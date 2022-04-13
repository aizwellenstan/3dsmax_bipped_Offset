(
	local allBip = for obj in $* where (isKindOf obj Biped_Object) collect obj
	--local allBip = selection as array
	
	local itemList = #()--キーが設定されてるオブジェクトが入る
	local rootList = #()--ルートオブジェクトだけ下記の"getKeyTime"が通らないので分けて別でオフセットかける用のリスト。解決策模索中
	
	for item in allBip do(--"getKeyTime"がキーをつけれないコントローラに対してエラー吐くので選別する、最後の一文[-1 != numKeys item.controller]だけでもいいかも…
		local itemKeys = item.controller.keys
		if 0 != itemKeys.count and -1 != numKeys  item.controller do(
			appendIfUnique itemList item
		)
	)
	
	for item in itemList do(--1fずらす
		try(
			--local startKeys = getKeyTime item.controller 1
			--if 0f == startKeys do(
				biped.moveKeys item.controller 1
                appendIfUnique rootList item.transform.controller.rootNode
			--)
		)catch()
	)
	for item in rootList do(--rootオブジェクトはコントローラの構造が違うので選別して別で同じ関数を適応
		try(
            biped.moveKeys item.transform.controller.vertical.controller 1
            biped.moveKeys item.transform.controller.horizontal.controller 1
            biped.moveKeys item.transform.controller.turning.controller 1
		)catch()
	)
)
