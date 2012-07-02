mkdir tmp

for img in play.png play_active.png pause.png pause_active.png
do
  convert $img -resize %50 tmp/$img
done

convert tmp/play.png        tmp/pause.png        rw.png        ff.png        back.png        -background transparent +append sprite_player.png
convert tmp/play_active.png tmp/pause_active.png rw_active.png ff_active.png back_active.png -background transparent +append sprite_player_focused.png

rm -r tmp
