function [ Hyporheic_area,HZ_Location, Hyporheiczone_depth  ] = Hyporheic_zone_volumecalculate( data,N,M )
%HYPORHEIC_ZONE_VOLUMECALCULATE 此处显示有关此函数的摘要
%   Hyporheic_area: the area of hyporheic zone
%   HZ_location: the location of hyporheic boundary
%   Hyporheiczone_depth: the distance from hyporheic boundary to the max elevation  
xx=reshape(data(:,1),N,[])';
yy=reshape(data(:,2),N,[])';
uu=reshape(data(:,3),N,[])';
dx=xx(1,2)-xx(1,1);
dy=yy(2,1)-yy(1,1);
sum_v = zeros(1,N);
for i = 1:N
    id = find(uu(:,i)>=0);
    sum_v(i) = sum(uu(id,i));
end
%% Calculate the depth at the location with lowest flux
[~,Id] = min(sum_v);
id_grid = max(find(uu(:,Id)>=0));
delta_yy = -uu(id_grid,Id)*dy/(uu(id_grid+1,Id)-uu(id_grid,Id));
if delta_yy >= dy/2
    Flux = sum(uu(find(uu(:,Id)>=0),Id))*dy;
else
    Flux = sum(uu(find(uu(:,Id)>=0),Id))*dy - (dy/2-delta_yy)*uu(id_grid,Id);
end
depth = id_grid*dy + delta_yy - dy/2;
%%  The influence depth of hyporheic flow on each section
HZ_Location = zeros(1,N);
grid_num = 0;
for i = 1:N
    if i == Id
        HZ_Location(i) = depth;
        grid_num = grid_num + M - id_grid - length(find(isnan(uu(:,i))));
    end
    for j = 1:M
        flux_current = sum(abs(uu(1:j,i)))*dy;
        if flux_current > Flux
            HZ_Location(i) = (Flux - sum(abs(uu(1:j-1,i)))*dy)/uu(j,i) + dy*(j-1);
            grid_num = grid_num + M - (j-1) - length(find(isnan(uu(:,i))));
            break
        end
    end
end
Hyporheic_area = grid_num * dx * dy;
%%
figure
plot(xx(1,:),HZ_Location);
axis equal
axis([min(xx(1,:))-dx/2 max(xx(1,:))+dx/2 min(yy(1,:))-dy/2 max(xx(1,:))+dy/2])
%
% Riverbed = zeros(1,N);
% for i = 1:N
%     Nonvalue = find(isnan(uu(:,i)));
%     if ~isempty(Nonvalue)
%         Riverbed(i) = (Nonvalue(1)-1) * dy;
%     else
%         Riverbed(i) = M * dy;
%     end
% end
Hyporheiczone_depth = yy(end,1) + dy/2 - HZ_Location;

end

