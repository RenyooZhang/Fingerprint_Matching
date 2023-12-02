function X = Thinning(A)
% Thinning
% DIP, P671
% Jianjiang Feng
% 2016-11-24
% 输入以1为底, 输出以1为底
% 但我怀疑这个算法有bug

bShow = 1;
B = CreateSE3();

X = A;
n_iter = 0;
while 1
    % for each B
    bChange = 0;
    for k = 1:size(B,1)
        n_iter = n_iter+1;
        Y = bwhitmiss(X, B{k,1}, B{k,2});
        if ~isempty(find(Y,1))
            bChange = 1;
            X(Y==1) = 0;
            if bShow==1
                J = MagnifyAndGrid(X, 20);
                % figure(10), imshow(J);
                % imwrite(J,sprintf('temp\\Thinning_Iter%02d_B%d.bmp',n_iter,k));
                % pause(1)
            elseif bShow==2
                figure(10), imshow(X);
                pause(0.5)
            end
        end
    end
    if ~bChange
        X = ~X;
        break
    end
end


%-----------------------------
function B = CreateSE1()
B{1,1} = [0 0 0; 0 1 0; 1 1 1];
B{1,2} = [1 1 1; 0 0 0; 0 0 0];
for k = 3:2:7
    B{k,1} = rot90(B{k-2,1});
    B{k,2} = rot90(B{k-2,2});
end
B{2,1} = [0 0 0; 1 1 0; 1 1 0];
B{2,2} = [0 1 1; 0 0 1; 0 0 0];
for k = 4:2:8
    B{k,1} = rot90(B{k-2,1});
    B{k,2} = rot90(B{k-2,2});
end

%-----------------------------
function B = CreateSE2()
B{1,1} = [0 0 0; 0 1 0; 1 1 1];
B{1,2} = [1 1 1; 0 0 0; 0 0 0];
for k = 2:4
    B{k,1} = rot90(B{k-1,1});
    B{k,2} = rot90(B{k-1,2});
end
B{5,1} = [0 0 0; 1 1 0; 0 1 0];
B{5,2} = [0 1 1; 0 0 1; 0 0 0];
for k = 6:8
    B{k,1} = rot90(B{k-1,1});
    B{k,2} = rot90(B{k-1,2});
end

%-----------------------------
function B = CreateSE3()
B{1,1} = [0 0 0; 0 1 0; 1 1 1];
B{1,2} = [1 1 1; 0 0 0; 0 0 0];
for k = 2:4
    B{k,1} = rot90(B{k-1,1});
    B{k,2} = rot90(B{k-1,2});
end
B{5,1} = [0 0 0; 1 1 0; 0 1 0];
B{5,2} = [0 1 1; 0 0 1; 0 0 0];
for k = 6:8
    B{k,1} = rot90(B{k-1,1});
    B{k,2} = rot90(B{k-1,2});
end
B{9,1} = [0 1 0; 1 1 0; 0 1 0];
B{9,2} = [0 0 1; 0 0 1; 0 0 1];
for k = 10:12
    B{k,1} = rot90(B{k-1,1});
    B{k,2} = rot90(B{k-1,2});
end

%-----------------------------
function J = MagnifyAndGrid(I, a)
% Jianjiang Feng
% 2016-11-18
I = double(~I);
I(I==0) = 0.7;% for consistent with DIP Book
J = imresize(I, a, 'nearest');
J(1,:) = 0;
for r = 1:size(I,1)
    J(r*a,:) = 0;
end
J(:,1) = 0;
for c = 1:size(I,2)
    J(:,c*a) = 0;
end