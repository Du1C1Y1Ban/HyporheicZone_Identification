function [ Hyporheic_Volume,HZ_Location ] = Hyporheic_zone_volumecalculate3D( data,M,N,O )
%HYPORHEIC_ZONE_VOLUMECALCULATE3D 此处显示有关此函数的摘要
%   此处显示详细说明
xx = reshape(data(:,1),M,N,[]);
yy = reshape(data(:,2),M,N,[]);
zz = reshape(data(:,3),M,N,[]);
uu = reshape(data(:,4),M,N,[]);
dx = xx(2,1,1) - xx(1,1,1);
dy = yy(1,2,1) - yy(1,1,1);
dz = zz(1,1,2) - zz(1,1,1);
sum_v = zeros(N,M);
for i = 1:N
    tm_uu = permute(uu(:,i,:),[1,3,2])';
    for j = 1:M
        id = find(tm_uu(:,j)>=0);
        sum_v(i,j) = sum(tm_uu(id,j));
    end
end
%
[~,Id] = min(sum_v,[],2);
depth = zeros(1,N); id_grid = zeros(1,N); Flux = zeros(1,N);
for i = 1:N
    tm_uu = permute(uu(:,i,:),[1,3,2])';
    id_grid(i) = max(find(tm_uu(:,Id(i))>=0));
    delta_zz = -tm_uu(id_grid(i),Id(i))*dz/(tm_uu(id_grid(i)+1,Id(i))-tm_uu(id_grid(i),Id(i)));
    if delta_zz >= dz/2
        Flux(i) = sum(tm_uu(find(tm_uu(:,Id(i))>=0),Id(i)))*dz;
    else
        Flux(i) = sum(tm_uu(find(tm_uu(:,Id(i))>=0),Id(i)))*dz - (dz/2-delta_zz)*tm_uu(id_grid(i),Id(i));
    end
    depth(i) = zz(1,1,id_grid(i)) + delta_zz;
end
%
HZ_Location = zeros(N,M);
grid_num = 0;
for i = 1:N
    tm_uu = permute(uu(:,i,:),[1,3,2])';
    for k = 1:M
        if k == Id(i)
            HZ_Location(i,k) = depth(i);
            grid_num = grid_num + O - id_grid(i) - length(find(isnan(tm_uu(:,k))));
        end
        for j = 1:O
            flux_current = sum(tm_uu(1:j,k))*dz;
            if flux_current > Flux(i)
                HZ_Location(i,k) = (Flux(i) - sum(tm_uu(1:j-1,k))*dz)/tm_uu(j,k) + zz(1,1,j-1);
                grid_num = grid_num + O - (j-1) - length(find(isnan(tm_uu(:,k))));
                break
            end
        end
    end
end
Hyporheic_Volume = grid_num * dx * dy * dz;
[M,I] = max(HZ_Location,[],2);
figure
surf(xx(:,:,1)',yy(:,:,1)',HZ_Location,'FaceAlpha',0.8);
colormap([0 1 1])
shading flat
axis([0 1.6 -0.45 0.45 -1 0.06])
daspect([1 1 1])
view(-32,15)
hold on
plot3(xx(I,1,1),yy(1,:,1)',M,'r','LineWidth',1)

end
