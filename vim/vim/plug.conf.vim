let s:avail_plug_dir = expand('<sfile>:h').'/plug.conf.d/'
for s:plug in globpath(s:avail_plug_dir, '*', v:false, v:true)
    execute 'source '.s:plug
endfor
