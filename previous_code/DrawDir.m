% ----函数定义--------------------------------------------------------------------
% 输入：
%       fig：图窗
%       dir：矩阵，保存每一个block的方向
%       BLK_SIZE：标量，图窗的长度
%       LineSpec：输出线段格式
%       ROI：矩阵，保存每个block是否要绘制线段
%       注意注意：这里面的方向矩阵用的不是法线方向，而是正弦波的走向
function obj = DrawDir(fig, dir, BLK_SIZE, LineSpec, ROI, bias)

    % 颜色控制
    linecolor = LineSpec(1);
    if length(LineSpec)>1
        linewidth = str2num(LineSpec(2));
    else
        linewidth = 1;
    end
    
    % 长度控制
    len = BLK_SIZE*0.8;
    
    imshow(fig),hold on

    [h,w] = size(dir);
    obj = zeros(h,w);

    for row = 1:h
        for col = 1:w
            if (dir(row, col) < -90 || dir(row, col) > 90 || nargin>4 && ROI(row,col)==0)
                obj(row,col) = -1; 
                continue
            end
            
            cx = (col-1)*BLK_SIZE+BLK_SIZE/2;
            cy = (row-1)*BLK_SIZE+BLK_SIZE/2;
            if 1
                linex(1) = cos(dir(row,col)*pi/180)*len/2;
                linex(2) = -cos(dir(row,col)*pi/180)*len/2;
                liney(1) = -sin(dir(row,col)*pi/180)*len/2;
                liney(2) = sin(dir(row,col)*pi/180)*len/2;
            else
                if dir(row,col)==90
                    linex(1) = 0;               % 起点的x坐标
                    liney(1) = -len/2;          % 起点的y坐标
                    linex(2) = 0;               % 终点的x坐标
                    liney(2) = len/2;           % 终点的y坐标
                elseif dir(row,col)<=45 && dir(row,col)>=-45
                    linex(1) = -len/2;
                    liney(1) = -linex(1)*tan(dir(row,col)*pi/180);
                    linex(2) = len/2;
                    liney(2) = -linex(2)*tan(dir(row,col)*pi/180);
                else
                    liney(1) = -len/2;
                    linex(1) = -liney(1)/tan(dir(row,col)*pi/180);
                    liney(2) = len/2;
                    linex(2) = -liney(2)/tan(dir(row,col)*pi/180);
                end
    
                linex(1) = cut(linex(1),-len/2,len/2);
                liney(1) = cut(liney(1),-len/2,len/2);
                linex(2) = cut(linex(2),-len/2,len/2);
                liney(2) = cut(liney(2),-len/2,len/2);
            end
            
            linex = linex+cx+bias;           % 起点、终点的x坐标
            liney = liney+cy+bias;           % 起点、终点的y坐标
            obj(row,col) = line(linex,liney,'color',linecolor,'linewidth',linewidth);   % 输出矩阵
        end
    end
end

function y = cut(x,minval,maxval)
    y=x;
    if y<minval
        y=minval;
    end
    if y>maxval
        y=maxval;
    end
end

