global all
boo=0;
disp('請輸入經DES加密的密文(toencrypt.txt)');
[S,path] = uigetfile('*.txt');
if isequal(S,0)
    boo=0;
    disp('選取失敗');
else
    boo=1;
    disp(['選擇檔案:',S]);
    S=fullfile(path,S);
    
end
disp("請選取要加密的網站txt檔(testweb.html)");
[H,path] = uigetfile('*.txt');
if isequal(H,0)
    boo=0;
    disp('選取失敗');
else
    boo=1;
    disp(['選擇檔案:', H]);
    H=fullfile(path,H);
end
if boo==1
    S=string(S);
    H=string(H);
    [fileS,message]=fopen(S,'r','n','utf-8');
    a=[];
    while ~feof(fileS)
        tline=fgetl(fileS);
        b=char(tline);
        a=[a,b];
    end
    S=a;
    fclose('all');
    % ================編碼表=================
    colorcode={{0,0,0},{0,0,1},{0,1,0},{0,1,1},{1,0,0},{1,0,1},{1,1,0},{1,1,1};
        {0,0,0},{0,0,1},{0,1,0},{0,1,1},{1,0,0},{1,0,1},{1,1,0},{1,1,1};
        {0,0,0},{0,0,1},{0,1,0},{0,1,1},{1,0,0},{1,0,1},{1,1,0},{1,1,1};
        {0,0,0},{0,0,1},{0,1,0},{0,1,1},{1,0,0},{1,0,1},{1,1,0},{1,1,1};};
    % =========================================
    %=========================將DES密文分區塊=================
    disp("密文總大小為"+length(S))
%     disp(length(dec2bin(length(S))));
    count=floor(length(S)/10);
    %=========================================================
    [fileH,message]=fopen(H,'r','n','utf-8');
    count3=1;
    line=length(S);
    colorex=[];
    fontex=[];
    lineex=[];
    borderex=[];
    while ~feof(fileH)
        tline=fgetl(fileH);
        color='(color:\s*#\w*)|color:(\s*)rgb\(\s*\d*,\s*\d*,\s*\d*)|color:(\s*)rgba\(\s*\d*,\s*\d*,\s*\d*,\s*\S*\)|color:(\s*)hsl\(\s*\d*,\s*\S*,\s*\S*\)';
        [match,nomatch]=regexpi(tline,color,'match','split');
        colorex=[colorex,string(match)];
        fontsize='(font-size:\d*.?\d*%|font-size:\d*.?\d*em|font-size:\d*.?\d*px|font-size:\d*.?\d*pt)';
        [match,nomatch]=regexpi(tline,fontsize,'match','split');
        fontex=[fontex,string(match)];
        lineheight='(line-height:\d*.?\d*%|line-height:\d*.?\d*em|line-height:\d*.?\d*px|line-height:\d*.?\d*pt)';
        [match,nomatch]=regexpi(tline,lineheight,'match','split');
        lineex=[lineex,string(match)];
        %         border='(border:(\s)?(\d*)px #?\w* #?\w*)|border:(\S+).*(\S+)[^;]';
        border='(border:\s*(\d*)px #?\w* #?\w*|border:\s*#?\w* (\d*)px #?\w*)';
        [match,nomatch]=regexpi(tline,border,'match','split');
        borderex=[borderex,string(match)];
    end
    
    [fileH,message]=fopen(H,'r','n','utf-8');
    fid = fopen('after.html','w','n','utf-8');
    linecolor=0;
    lengthcount=fix(line/10);
    for k=1:length(colorex)
        if count3<=lengthcount*10
            if line-11>=0
                codecolor=str2num(S(count3))*2+str2num(S(count3+1))+1;
                codecolor2=str2num(S(count3+2))*4+str2num(S(count3+3))*2+str2num(S(count3+4))+1;
                %coderesultcolor=string(colorcode{codecolor,codecolor2});
                coderesultcolor=string({S(count3+2),S(count3+3),S(count3+4),S(count3+5),S(count3+6),S(count3+7),S(count3+8),S(count3+9),S(count3+10)});
                colorex(k)=changecolor(codecolor,colorex(k),coderesultcolor);
                count3=count3+11;
                line=line-11;
                linecolor=linecolor+1;
            end
        end
    end
    for k=1:length(fontex)
        if line-2>=0
            coderesultfont={num2str(S(count3)),num2str(S(count3+1))};
            fontex(k)=changefont(fontex(k),coderesultfont,1);
            count3=count3+2;
            line=line-2;
        end
    end
    for k=1:length(lineex)
        if line-2>=0
            coderesultline={num2str(S(count3)),num2str(S(count3+1))};
            lineex(k)=changefont(lineex(k),coderesultline,2);
            count3=count3+2;
            line=line-2;
        end
    end
    for k=1:length(borderex)
        if line-2>=0
            coderesultborder={num2str(S(count3)),num2str(S(count3+1))};
            border_change=changeborder(borderex(k),coderesultborder);
            if border_change~="no"
                borderex(k)=changeborder(borderex(k),coderesultborder);
                count3=count3+2;
                line=line-2;
            end
        end
    end
    countcolor=1;
    countfont=1;
    countline=1;
    countborder=1;
    while ~feof(fileH)
        tline=fgetl(fileH);
        color='(color:\s*#\w*)|color:(\s*)rgb\(\s*\d*,\s*\d*,\s*\d*)|color:(\s*)rgba\(\s*\d*,\s*\d*,\s*\d*,\s*\S*\)|color:(\s*)hsl\(\s*\d*,\s*\S*,\s*\S*\)';
        [match,nomatch]=regexpi(tline,color,'match','split');
        if countcolor<=length(colorex)
            for k=1:length(match)
                match(k)={colorex(countcolor)};
                countcolor=countcolor+1;
            end
        end
        tline=strjoin(string(nomatch),string(match));
        fontsize='(font-size:\d*.?\d*%|font-size:\d*.?\d*em|font-size:\d*.?\d*px|font-size:\d*.?\d*pt)';
        [match,nomatch]=regexpi(tline,fontsize,'match','split');
        if countfont<=length(fontex)
            for k=1:length(match)
                match(k)={fontex(countfont)};
                countfont=countfont+1;
            end
        end
        tline=strjoin(string(nomatch),string(match));
        lineheight='(line-height:\d*.?\d*%|line-height:\d*.?\d*em|line-height:\d*.?\d*px|line-height:\d*.?\d*pt)';
        [match,nomatch]=regexpi(tline,lineheight,'match','split');
        if countline<=length(lineex)
            for k=1:length(match)
                match(k)={lineex(countline)};
                countline=countline+1;
            end
        end
        tline=strjoin(string(nomatch),string(match));
        border='(border:\s*(\d*)px #?\w* #?\w*|border:\s*#?\w* (\d*)px #?\w*)';
        [match,nomatch]=regexpi(tline,border,'match','split');
        if countborder<=length(borderex)
            for k=1:length(match)
                match(k)={borderex(countborder)};
                countborder=countborder+1;
            end
        end
        
        tline=strjoin(string(nomatch),string(match));
        fprintf(fid,'%s\n',tline);
    end
    %all=linecolor*5+length(fontex)*2+length(lineex)*2+length(borderex)*2;
    all=count3-1;
    if line~=0
        disp("還未藏完"+(length(S)-(count3-1))+"bits");
    else
        disp("加密成功")
    end
    fclose('all');
elseif  boo==0
    disp("請選取正確檔案")
end

%%
function chcolor=changecolor(a,text,encrypt)
color={};
[type,type2]=Hjudge(text,1);    %type為原本color的種類，type2為color裡的顏色數值
if type==1
    %         r=['0','C','2','A','2','B'];
    ex=rgb2hex(type2,2);                %hex2rgb
    
    if length(encrypt)==3
        for i=1:3
            color{i}=fix(ex{i}/2)*2+str2num(char(encrypt(i)));
        end
    else
        for i=1:3
            type1=(fix(ex{i}/8)-1)*8+bin2dec(encrypt(1+((i-1)*3))+encrypt(2+((i-1)*3))+encrypt(3+((i-1)*3)));
            type2=fix(ex{i}/8)*8+bin2dec(encrypt(1+((i-1)*3))+encrypt(2+((i-1)*3))+encrypt(3+((i-1)*3)));
            type3=(fix(ex{i}/8)+1)*8+bin2dec(encrypt(1+((i-1)*3))+encrypt(2+((i-1)*3))+encrypt(3+((i-1)*3)));
            if abs(type1-ex{i})<abs(type2-ex{i})&&abs(type1-ex{i})<abs(type3-ex{i})&&type1>=0
%                 disp("type1")
                color{i}=type1;
            elseif abs(type3-ex{i})<abs(type1-ex{i})&&abs(type3-ex{i})<abs(type2-ex{i})&&type3<=255
                color{i}=type3;
%                 disp("type3")
            else
                color{i}=type2;
%                 disp("type2")
            end
            %             color{i}=fix(ex{i}/8)*8+bin2dec(encrypt(1+((i-1)*3))+encrypt(2+((i-1)*3))+encrypt(3+((i-1)*3)));
            %disp(color{i});
        end
    end
    
    if a==1
        color=rgb2hex(color,1);
    elseif a==2
        color{4}=1;
    elseif a==4
        color=rgb2hsl(color,1);
    end
elseif type==2                                             %rgba換算成HEX
    %     r={100,200,255,0.5};
    ex=rgb2rgba(type2,2);                %rgba2rgb
    if length(encrypt)==3
        for i=1:3
            color{i}=fix(ex{i}/2)*2+str2num(char(encrypt(i)));
        end
    else
        for i=1:3
            type1=(fix(ex{i}/8)-1)*8+bin2dec(encrypt(1+((i-1)*3))+encrypt(2+((i-1)*3))+encrypt(3+((i-1)*3)));
            type2=fix(ex{i}/8)*8+bin2dec(encrypt(1+((i-1)*3))+encrypt(2+((i-1)*3))+encrypt(3+((i-1)*3)));
            type3=(fix(ex{i}/8)+1)*8+bin2dec(encrypt(1+((i-1)*3))+encrypt(2+((i-1)*3))+encrypt(3+((i-1)*3)));
            if abs(type1-ex{i})<abs(type2-ex{i})&&abs(type1-ex{i})<abs(type3-ex{i})&&type1>=0
%                 disp("type1")
                color{i}=type1;
            elseif abs(type3-ex{i})<abs(type1-ex{i})&&abs(type3-ex{i})<abs(type2-ex{i})&&type3<=255
                color{i}=type3;
%                 disp("type3")
            else
                color{i}=type2;
%                 disp("type2")
            end
        end
    end
    if a==1
        color=rgb2hex(color,1);
    elseif a==2
        color{4}=ex{4};
    elseif a==4
        color=rgb2hsl(color,1);                 %rgb2hsl
    end
elseif type==3
    %     ex={12,42,43};
    
    if length(encrypt)==3
        for i=1:3
            color{i}=fix(type2{i}/2)*2+str2num(char(encrypt(i)));
        end
    else
        ex=type2;
        for i=1:3
            
            type1=(fix(ex{i}/8)-1)*8+bin2dec(encrypt(1+((i-1)*3))+encrypt(2+((i-1)*3))+encrypt(3+((i-1)*3)));
            type2=fix(ex{i}/8)*8+bin2dec(encrypt(1+((i-1)*3))+encrypt(2+((i-1)*3))+encrypt(3+((i-1)*3)));
            type3=(fix(ex{i}/8)+1)*8+bin2dec(encrypt(1+((i-1)*3))+encrypt(2+((i-1)*3))+encrypt(3+((i-1)*3)));
            if abs(type1-ex{i})<abs(type2-ex{i})&&abs(type1-ex{i})<abs(type3-ex{i})&&type1>=0
%                 disp("type1")
                color{i}=type1;
            elseif abs(type3-ex{i})<abs(type1-ex{i})&&abs(type3-ex{i})<abs(type2-ex{i})&&type3<=255
                color{i}=type3;
%                 disp("type3")
            else
                color{i}=type2;
%                 disp("type2")
            end
        end
    end
    if a==1
        color=rgb2hex(color,1);
    elseif a==2
        color{4}=1;
    elseif a==4
        color=rgb2hsl(color,1);
    end
elseif type==4
    %     r={12,42,43};
    ex=rgb2hsl(type2,2);                %hsl2rgb
    if length(encrypt)==3
        for i=1:3
            color{i}=fix(ex{i}/2)*2+str2num(char(encrypt(i)));
        end
    else
        for i=1:3
            type1=(fix(ex{i}/8)-1)*8+bin2dec(encrypt(1+((i-1)*3))+encrypt(2+((i-1)*3))+encrypt(3+((i-1)*3)));
            type2=fix(ex{i}/8)*8+bin2dec(encrypt(1+((i-1)*3))+encrypt(2+((i-1)*3))+encrypt(3+((i-1)*3)));
            type3=(fix(ex{i}/8)+1)*8+bin2dec(encrypt(1+((i-1)*3))+encrypt(2+((i-1)*3))+encrypt(3+((i-1)*3)));
            if abs(type1-ex{i})<abs(type2-ex{i})&&abs(type1-ex{i})<abs(type3-ex{i})&&type1>=0
%                 disp("type1")
                color{i}=type1;
            elseif abs(type3-ex{i})<abs(type1-ex{i})&&abs(type3-ex{i})<abs(type2-ex{i})&&type3<=255
                color{i}=type3;
%                 disp("type3")
            else
                color{i}=type2;
%                 disp("type2")
            end
        end
    end
    if a==1
        color=rgb2hex(color,1);
        
    elseif a==2
        color{4}=1;
    elseif a==4
        color=rgb2hsl(color,1);
    end
end


if a==1
    chcolor="color:#"+color{1}+color{2}+color{3}+color{4}+color{5}+color{6};
elseif a==2
    chcolor="color:rgba("+color{1}+","+color{2}+","+color{3}+","+color{4}+")";
elseif a==3
    chcolor="color:rgb("+color{1}+","+color{2}+","+color{3}+")";
elseif a==4
    chcolor="color:hsl("+color{1}+","+color{2}+"%,"+color{3}+"%)";
end
if chcolor==text
    chcolor=chcolor+"   ";
end
end
%%
function chfont=changefont(text,encrypt,class)
fontcode={{0,1},{1,0},{1,1},{0,0}};
linecode={{0,1},{1,0},{1,1},{0,0}};
% ===========================================
% disp(string(encrypt(1)+encrypt(2)));
for i=1:4
    if class==1
        if isequal(string(fontcode{1,i}),string(encrypt))
            a=i;
        end
    else
        if isequal(string(linecode{1,i}),string(encrypt))
            a=i;
        end
    end
end
[newStr,status]=Hjudge(text,2);
font=0;
if status==1        
    font=newStr;
    if a==1
    elseif a==2
        font=(font*3)/4;
    elseif a==3
        if class==1
            if newStr<1
                font=font/16;
            else
                font=font/14;
            end
        else
            font=font/28;
        end
    elseif a==4
        if class==1
            font=(font/14)*100;
        else
            font=(font/28)*100;
        end
    end
elseif status==2       %pt
    font=(newStr*4)/3;
    if a==2
        font=newStr;
    elseif a==3
        if class==1
            if font<1
                font=font/16;
            else
                font=font/14;
            end
        else
            font=font/28;
        end
    elseif a==4
        if class==1
            font=(font/14)*100;
        else
            font=(font/28)*100;
        end
    end
elseif status==3    %em
    if class==1
        font=newStr*14;
    else
        font=newStr*28;
    end
    if a==2
        font=(font*3)/4;
    elseif a==3
        font=newStr;
    elseif a==4
        font=newStr*100;
    end
elseif status==4        % %
    font=newStr/100;
    if a==1
        font=font*14;
    elseif a==2
        font=font*14*3/4;
    elseif a==4
        font=newStr;
    end
end
if class==1
    if a==1
        chfont="font-size:"+font+"px";
    elseif a==2
        chfont="font-size:"+font+"pt";
    elseif a==3
        chfont="font-size:"+font+"em";
    elseif a==4
        chfont="font-size:"+font+"%";
    end
elseif class==2
    if a==1
        chfont="line-height:"+font+"px";
    elseif a==2
        chfont="line-height:"+font+"pt";
    elseif a==3
        chfont="line-height:"+font+"em";
    elseif a==4
        chfont="line-height:"+font+"%";
    end
end

end
%%
function chborder=changeborder(text,encrypt)
bordercode={{0,1},{1,0},{1,1},{0,0}};
for i=1:4
    if isequal(string(bordercode{1,i}),string(encrypt))
        a=i;
    end
end
[newStr,status,b]=borderHjudge(text);
if status==5
    chborder="no";
else
    if a==2
        ex=newStr{2};
        newStr{2}=newStr{3};
        newStr{3}=ex;
    elseif a==3
        ex=newStr{1};
        newStr{1}=newStr{3};
        newStr{3}=newStr{2};
        newStr{2}=ex;
    elseif a==4
        ex=newStr{1};
        newStr{1}=newStr{2};
        newStr{2}=ex;
    end
    chborder="border:"+newStr{1}+" "+newStr{2}+" "+newStr{3};
end
end

%%

function aws=rgb2hsl(color,c)                      %hsl互換rgb
if c==1
    %     color={101,200,230};
    r=color{1}/255;
    g=color{2}/255;
    b=color{3}/255;
    maxcolor=max(max(r,g),b);
    mincolor=min(min(r,g),b);
    L=(maxcolor+mincolor)/2;
    color{3}=str2num(char(sprintf("%0.2f",L*100)));
    if maxcolor==mincolor
        color{2}=0;
    elseif L<=0.5
        color{2}=str2num(char(sprintf("%0.2f",(maxcolor-mincolor)/(2*L)*100)));
    else
        color{2}=str2num(char(sprintf("%0.2f",(maxcolor-mincolor)/(2-2*L)*100)));
    end
    if maxcolor==mincolor
        color{1}=0;
    elseif r==maxcolor
        if g>=b
            color{1}=60*(g-b)/(maxcolor-mincolor);
        else
            color{1}=60*(g-b)/(maxcolor-mincolor)+360;
        end
    elseif g==maxcolor
        color{1}=60*(b-r)/(maxcolor-mincolor)+120;
    else
        color{1}=60*(r-g)/(maxcolor-mincolor)+240;
    end
    color{1}=str2num(char(sprintf("%0.2f",color{1})));
elseif c==2
    h=color{1};
    s=color{2}/100;
    l=color{3}/100;
    for i=1:length(color)
        if s==0
            color{i}=l;
        else
            if l<0.5
                q=l*(1+s);
            elseif l>=0.5
                q=l+s-(l*s);
            end
            p=2*l-q;
            hk=h/360;
            if i==1
                hk=hk+(1/3);
            elseif i==3
                hk=hk-(1/3);
            end
            if hk<0
                hk=hk+1;
            elseif hk>1
                hk=hk-1;
            end
            if hk<(1/6)
                color{i}=p+((q-p)*6*hk);
            elseif hk<(1/2)&&hk>=(1/6)
                color{i}=q;
            elseif hk<(2/3)&&hk>=(1/2)
                color{i}=p+((q-p)*(2/3-hk)*6);
            else
                color{i}=p;
            end
        end
        color{i}=round(color{i}*255);
    end
end
aws=color;
end
%%
function aws=rgb2hex(color,c)
hex={};
count=1;
if c==1
    for i=1:2:6
        ex=dec2hex(fix(color{count}/16));                       %rgb2hex
        ex2=dec2hex(mod(color{count},16));
        hex{i}=ex;
        hex{i+1}=ex2;
        count=count+1;
    end
else
    for i=1:2:6
        hex{count}=hex2dec(color{i})*16+hex2dec(color{i+1});        %hex2rgb
        count=count+1;
    end
end
aws=hex;
end
%%
function aws=rgb2rgba(color,c)
rgb={};
if c==1
    alpha=color{4};
    for i=1:3
        rgb{i}=fix((color{i})*alpha+255*(1-alpha));
    end
elseif c==2
    for i=1:3
        rgb{i}=color{i};
    end
    rgb{4}=color{4};
end
aws=rgb;
end
%%
function [aws,aws2]=Hjudge(H,class)
r=[];
count=0;
if class==1
    if contains(H,"#")
        count=1;
        newStr = extractAfter(H,"#");
        exper1='(\d)|(\w)';
        newStr=regexpi(newStr,exper1,'match');
        r={};
        count2=1;
        for i=1:length(newStr)
            if length(newStr)==3
                r{count2}=newStr(i);
                r{count2+1}=newStr(i);
                count2=count2+2;
            else
                r{i}=newStr(i);
            end
        end
        
    elseif contains(H,"rgba")
        count=2;
        newStr = extractAfter(H,"rgba(");
        exper1='(\d)(\.)(\d)|(\d)*';
        newStr=regexpi(newStr,exper1,'match');
        for i=1:4
            r{i}=str2double(newStr{i});
        end
    elseif contains(H,"rgb")
        count=3;
        newStr = extractAfter(H,"rgb(");
        exper1='(\d)*';
        newStr=regexpi(newStr,exper1,'match');
        for i=1:3
            r{i}=str2double(newStr{i});
        end
    elseif contains(H,"hsl")
        count=4;
        newStr = extractAfter(H,"hsl(");
        exper1='(\d*\.?\d*)';
        newStr=regexpi(newStr,exper1,'match');
        for i=1:3
            r{i}=str2double(newStr(i));
        end
    end
    aws=count;
    aws2=r;
elseif class==2
    exper1='(\d*[.]\d*)|(\d*)';
    r=regexpi(H,exper1,'match');
    r=str2num(char(r));
    if contains(H,"px")
        count=1;
    elseif contains(H,"pt")
        count=2;
    elseif contains(H,"em")
        count=3;
    elseif contains(H,"%")
        count=4;
    end
    aws2=count;
    aws=r;
    
end

end
%%
function [aws,aws2,aws3]=borderHjudge(H)
color='(#\w*)|(\s*)rgb\(\s*\d*,\s*\d*,\s*\d*)|(\s*)rgba\(\s*\d*,\s*\d*,\s*\d*,\s*\S*\)|(\s*)hsl\(\s*\d*,\s*\S*,\s*\S*\)';
newStr = extractAfter(H,"border:");
exper2='(\w*)';
[match,r]=regexpi(newStr,color,'match','split');
b=0;
d=0;
if isempty(match)
count=5;
else
for i=1:length(r)
    if ~isempty(r{i})
        [match2]=regexpi(r{i},exper2,'match');
    end
end
r{1}=match{1};
r{2}=match2{1};
r{3}=match2{2};
for i=1:length(r)
    exper2='(\d*)px';
    a=regexpi(r{i},exper2,'match');
    if ~isempty(a)
        b=i;
        exper3='(\d*)';
        c=regexpi(a,exper3,'match');
        d=c{1};
        break
    end
end
if b==1&&(r{b+1}=="dotted"||r{b+1}=="dashed"||r{b+1}=="solid"||r{b+1}=="double"||r{b+1}=="groove"||r{b+1}=="inset"||r{b+1}=="outset"||r{b+1}=="none"||r{b+1}=="hidden")
    count=1;
elseif b==1&&(r{b+2}=="dotted"||r{b+2}=="dashed"||r{b+2}=="solid"||r{b+2}=="double"||r{b+2}=="groove"||r{b+2}=="inset"||r{b+2}=="outset"||r{b+2}=="none"||r{b+2}=="hidden")
    ex=r{3};
    r{3}=r{2};
    r{2}=ex;
    count=2;
elseif b==2&&(r{b+1}=="dotted"||r{b+1}=="dashed"||r{b+1}=="solid"||r{b+1}=="double"||r{b+1}=="groove"||r{b+1}=="inset"||r{b+1}=="outset"||r{b+1}=="none"||r{b+1}=="hidden")
    ex=r{1};
    r{1}=r{2};
    r{2}=r{3};
    r{3}=ex;
    count=3;
elseif b==2&&(r{b-1}=="dotted"||r{b-1}=="dashed"||r{b-1}=="solid"||r{b-1}=="double"||r{b-1}=="groove"||r{b-1}=="inset"||r{b-1}=="outset"||r{b-1}=="none"||r{b-1}=="hidden")
    ex=r{1};
    r{1}=r{2};
    r{2}=ex;
    count=4;
else
    count=5;
end
end
aws2=count;
aws=r;
aws3=d;
end
