#生产工具的配置文件
> **包括了:**

- [x] bash  
- [x] vim  
- [x] tmux  
- [x] rxvt  
- [ ] fvwm  
- [ ] sdcv


###使用说明
使用install.sh来安装和卸载，文件安装在~/.myconfigures里面

> **安装**

```
./install.sh [-a{i|r}] [-b{i|r}] [-v{i|r}] [-fo{i|r}] [-fv{i|r}] [-t{|r}] [-r{i|r}]
a:    all, 所有配置文件都安装(i)或卸载(r)
b:    bash, bash配置的安装(i)或卸载(r)
v:    vim, vim配置的安装(i)或卸载(r)
fo:   fonts, 字体的安装(i)或卸载(r)
fv:   fvwm, fvwm配置的安装(i)或卸载(r)
t:    tmux, tmux配置的安装(i)或卸载(r)
r:    rxvt, rxvt配置的安装(i)或卸载(r)
```

> **卸载**

进入~/.myconfigures里然后执行
```
./install -ar
```
然后全部就卸载了，不留一点痕迹:P
