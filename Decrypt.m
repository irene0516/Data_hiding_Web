function result=Decrypt()
boo=0;
disp("請選取已加密的網頁txt檔(after.html)");
[lastH,path] = uigetfile('*.txt');
if isequal(lastH,0)
    boo=0;
    disp('選取失敗');
else
    boo=1;
    lastH=fullfile(path,lastH);
    disp(['路徑:',lastH]);
end
if boo==1
    global all;
    lastH=string(lastH);
    [fileID,message]=fopen(lastH,'r','n','utf-8');
    %     fileout=fopen('textfinish.txt','wt','n','utf-8');
    % fprintf('message = %s\n', message);                              //開啟檔案狀態訊息
    % =========================================
    a=[];
    ex=[];
    ex2=[];
    ex3=[];
    ex4=[];
    count3=1;
    str={};
    lastcolorex=[];
    lastfontex=[];
    lastlineex=[];
    lastborderex=[];
    while ~feof(fileID)
        tline=fgetl(fileID);
        color='(color:\s*#\w*)\S?|color:(\s*)rgb\(\s*\d*,\s*\d*,\s*\d*)\S?|color:(\s*)rgba\(\s*\d*,\s*\d*,\s*\d*,\d*.\d*\S?\)|color:(\s*)hsl\(\d*.?\d*,\d*.?\d*[%],\d*.?\d*[%])\s*\S?';
        fontsize='(font-size:\d*.?\d*%|font-size:\d*.?\d*em|font-size:\d*.?\d*px|font-size:\d*.?\d*pt)';
        line='(line-height:\d*.?\d*%|line-height:\d*.?\d*em|line-height:\d*.?\d*px|line-height:\d*.?\d*pt)';
        %         border='(border:(\s)?(\d*)px #?\w* #?\w*)|border:(\S+).*(\S+)[^;]';
        border='(border:\s*(\d*)px #?\w* #?\w*|border:\s*#?\w* (\d*)px #?\w*)';
        [match,nomatch]=regexpi(tline,color,'match','split');
        lastcolorex=[lastcolorex,string(match)];
        [match,nomatch]=regexpi(tline,fontsize,'match','split');
        lastfontex=[lastfontex,string(match)];
        [match,nomatch]=regexpi(tline,line,'match','split');
        lastlineex=[lastlineex,string(match)];
        [match,nomatch]=regexpi(tline,border,'match','split');
        lastborderex=[lastborderex,string(match)];
    end
    count=all;
%     disp(count)
    lengthcount=(fix(count/10))*2;
    for k=1:length(lastcolorex)
        if(count-11>=0 && lengthcount-1>=0)
            ex=[ex,change(lastcolorex(k),2,count)];
            lengthcount=lengthcount-1;
            count=count-11;
        end
    end
    
    for k=1:length(lastfontex)
        if(count-2>=0)
            ex2=[ex2,changefont(lastfontex(k),1)];
            count=count-2;
        end
    end
%     disp("ex2"+length(ex2));
    for k=1:length(lastlineex)
        if(count-2>=0)
            ex3=[ex3,changefont(lastlineex(k),2)];
            %                   disp(class(ex3{1}))
            count=count-2;
        end
    end
%     disp("ex3"+length(ex3));
    for k=1:length(lastborderex)
        if(count-2>=0)
            [bordertype,border_change]=changeborder(lastborderex(k));
            %             if length(bordertype)~=1
            if border_change==1
                ex4=[ex4,bordertype];
                %                   disp(class(ex3{1}))
                count=count-2;
            end
            %             end
        end
    end
%     disp("ex4"+length(ex4));
    CS=[];
    str=[ex,ex2,ex3,ex4];
    lastcount=0;
    while mod(length(str),8)~=0
        str(end-lastcount)=[];
        lastcount=lastcount+1;
    end
    
    disp("密文取出長度:"+length(str))
    str=cell2mat(str);
    ans=str;
    so=mod(length(str),64);
    ans=str(1:length(str)-so);
    for i=1:4:length(ans)-3
        Ci=ans(i:i+3);
        CS=[CS,num2str(dec2hex(bin2dec(Ci)))];
        aws=CS;
    end
    result=aws;
    fclose('all');
elseif boo==0
    disp("請選取正確檔案")
end
end
%%
function aws=rgb2hsl(color,c)                      %hsl互換rgb
if c==1
    
    %         disp(class(color{1}));
    %             disp(color);
    %     color={101,200,230};
    r=color{1}/255;
    g=color{2}/255;
    b=color{3}/255;
    maxcolor=max(max(r,g),b);
    mincolor=min(min(r,g),b);
    L=(maxcolor+mincolor)/2;
    color{3}=str2num(char(sprintf("%0.2f",L*100)));
    %     color{3}=L*100;
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
    %     disp(color)
elseif c==2
    %     color={'193.95','72.07','64.90'};
    %     str2num(char(
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
% disp(color)
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
if class==1     %顏色
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
        %     disp(newStr);
        exper1='(\d)*';
        newStr=regexpi(newStr,exper1,'match');
        for i=1:3
            r{i}=str2double(newStr{i});
        end
    elseif contains(H,"hsl")
        count=4;
        newStr = extractAfter(H,"hsl(");
        % disp(newStr);
        exper1='(\d*\.?\d*)';
        newStr=regexpi(newStr,exper1,'match');
        for i=1:3
            r{i}=str2double(newStr(i));
        end
    end
    aws=count;
    aws2=r;
elseif class==2     %文字大小
    exper1='(\d*[.]\d*)|(\d*)';
    %     disp(experl)
    r=regexpi(H,exper1,'match');
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
    aws=str2double(r);
elseif class==3     %框線
    color='(#\w*)|(\s*)rgb\(\s*\d*,\s*\d*,\s*\d*)|(\s*)rgba\(\s*\d*,\s*\d*,\s*\d*,\s*\S*\)|(\s*)hsl\(\s*\d*,\s*\S*,\s*\S*\)';
    newStr = extractAfter(H,"border:");
    [match,r]=regexpi(newStr,color,'match','split'); 
   r="no";
    if isempty(match)
        count=5;
    else
     newStr=regexprep(newStr,color,'no');
    exper2='(\S)(\w*)(\S)';
    match=regexpi(newStr,exper2,'match');
    r{1}=match{1};
    r{2}=match{2};
    r{3}=match{3};
    for i=1:length(r)
        exper2='(\d*[.]\d*)|(\d*)';
        a=regexpi(r{i},exper2,'match');
        if ~isempty(a)
            b=i;
            break
        end
    end
    
    
    %     disp("b"+b)
    if b==1&&(r{b+1}=="dotted"||r{b+1}=="dashed"||r{b+1}=="solid"||r{b+1}=="double"||r{b+1}=="groove"||r{b+1}=="inset"||r{b+1}=="outset"||r{b+1}=="none"||r{b+1}=="hidden")
        count=1;
    elseif b==1&&(r{b+2}=="dotted"||r{b+2}=="dashed"||r{b+2}=="solid"||r{b+2}=="double"||r{b+2}=="groove"||r{b+2}=="inset"||r{b+2}=="outset"||r{b+2}=="none"||r{b+2}=="hidden")
        count=2;
    elseif b==2&&(r{b+1}=="dotted"||r{b+1}=="dashed"||r{b+1}=="solid"||r{b+1}=="double"||r{b+1}=="groove"||r{b+1}=="inset"||r{b+1}=="outset"||r{b+1}=="none"||r{b+1}=="hidden")
        count=3;
    elseif b==2&&(r{b-1}=="dotted"||r{b-1}=="dashed"||r{b-1}=="solid"||r{b-1}=="double"||r{b-1}=="groove"||r{b-1}=="inset"||r{b-1}=="outset"||r{b-1}=="none"||r{b-1}=="hidden")
        count=4;
    else
    count=5;
        
    end
   
    end
     aws2=count;
    aws=r;
end
end
%%
function changecolor=change(lastH,type,count)
% ================編碼表=================
colorcode={{0,0,0},{0,0,1},{0,1,0},{0,1,1},{1,0,0},{1,0,1},{1,1,0},{1,1,1};
    {0,0,0},{0,0,1},{0,1,0},{0,1,1},{1,0,0},{1,0,1},{1,1,0},{1,1,1};
    {0,0,0},{0,0,1},{0,1,0},{0,1,1},{1,0,0},{1,0,1},{1,1,0},{1,1,1};
    {0,0,0},{0,0,1},{0,1,0},{0,1,1},{1,0,0},{1,0,1},{1,1,0},{1,1,1};};
%=========================================
count=1;
code={};
num=0;
[lasttype,lasttype2]=Hjudge(lastH,1);
if lasttype==1
    %     count=2;
    ex=rgb2hex(lasttype2,2);                %hex2rgb
elseif lasttype==2
    ex=rgb2rgba(lasttype2,2);                %rgba2rgb
elseif lasttype==3
    ex=lasttype2;
elseif lasttype==4
    ex=rgb2hsl(lasttype2,2);                %hsl2rgb
end
count2=['00',dec2bin(lasttype-1)];
num={count2(end-1),count2(end)};
if type==1
    for i=1:3
        num{i+2}=num2str(mod(ex{i},2));
    end
else
    for i=1:3
        count=['000',dec2bin(mod(ex{i},8))];
        for j=1:3
            num{(i-1)*3+j+2}=count(end-(3-j));
        end
        
    end
end
changecolor=num;
end
%%
function chfont=changefont(lastH,class)
%-------------邊碼表--------------------
fontcode={{0,1},{1,0},{1,1},{0,0}};
linecode={{0,1},{1,0},{1,1},{0,0}};
%---------------------------------------
% disp(lastH)
[newStr2,status2]=Hjudge(lastH,2);
num={};
if class==1
    count=fontcode{1,status2};
else
    count=linecode{1,status2};
end
count2=[];
num={num2str(count{1}),num2str(count{2})};

% end
chfont=num;
end
%%
function [chborder,border_change]=changeborder(lastH)
%-------------邊碼表--------------------
bordercode={{0,1},{1,0},{1,1},{0,0}};
%---------------------------------------
[newStr,status]=Hjudge(lastH,3);
if status~=5&&status~=0
    border_change=1;
    count=bordercode{1,status};
    num={num2str(count{1}),num2str(count{2})};
    chborder=num;
else
    border_change=5;
%     chborder=3;
chborder="no";
end
end


