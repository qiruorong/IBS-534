function [obj] = plotxtimeyraster3(spiketimes, labelon, varargin)
% [OBJ] = PLOTXTIMEYRASTER3(SPIKETIMES, LABELON, VARARGIN)
% Makes a raster plot of the spike times in SPIKETRAIN.  Each row
% of SPIKETRAIN is assumed to be a different trial, and each column
% is assumed to be a spike time.  Zeros are ignored.
% VARARGIN options include:
% RASTYLIMITS: [min max] for range on axes to plot rasters
%              (default = [0 1])
% COLOR      : Char indicating line color (default = 'k', black)
% GROUPI     : An index associated with each row in SPIKETIMES that can be
% used to group together different trials; note that trials belonging to
% the same group should be in consecutive rows of the SPIKETIMES matrix.
% Different groups will be plotted in different colors specified by
% PLOTCOLSTR

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Written by R. Liu <liu@phy.ucsf.edu>
% Last revised: 2003.01.03
% Called by: 
% Scripts used: 
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

rastylimits = [0 1];
rastlabelon = 1;
Color = 'k';
altcolors = 0;
dotson = 1;
dotsize = 1;
otheropts = assignopts({'rastlabelon','rastylimits','Color','groupi',...
        'altcolors','groupcolor','dotson','dotsize'},varargin{:});

[ntrials,maxtrialspk] = size(spiketimes);
if ntrials > 0
    ysep = diff(rastylimits)/(ntrials);
    spikerasterYlo = [rastylimits(1):ysep:rastylimits(2)-ysep];
    spikerasterYhi = [rastylimits(1)+ysep/2:ysep:rastylimits(2)];
    xlim = get(gca,'XLim');
    if ~exist('groupi','var')
        if dotson 
            spikerasterX = reshape(spiketimes',maxtrialspk*ntrials,1);
            spikerasterY1 = repmat(spikerasterYlo,maxtrialspk,1);
            spikerasterY1 = reshape(spikerasterY1,maxtrialspk*ntrials,1);
            obj = plot(spikerasterX,spikerasterY1,'o','Color',Color,'MarkerSize',dotsize,otheropts{:});
        else
            spikerasterX = reshape(spiketimes',maxtrialspk*ntrials,1);
            spikerasterX = repmat(spikerasterX',2,1);
            spikerasterY1 = repmat(spikerasterYlo,maxtrialspk,1);
            spikerasterY1 = reshape(spikerasterY1,maxtrialspk*ntrials,1);
            spikerasterY2 = repmat(spikerasterYhi,maxtrialspk,1);
            spikerasterY2 = reshape(spikerasterY2,maxtrialspk*ntrials,1);
            spikerasterY = [spikerasterY1';spikerasterY2'];
            obj = line(spikerasterX,spikerasterY,'Color',Color,otheropts{:});
        end
    else
        % Cycle through the groups
        % Look for when GROUPI changes -- these are the borders between
        % groups
        bi = [1,find(diff(groupi))+1,length(groupi)+1];  
        for i = 1:length(bi)-1
            ntrials_group = bi(i+1)-bi(i);
            if dotson
                spikerasterX = reshape(spiketimes(bi(i):bi(i+1)-1,:)',maxtrialspk*ntrials_group,1);
                spikerasterY1 = repmat(spikerasterYlo(bi(i):bi(i+1)-1),maxtrialspk,1);
                spikerasterY1 = reshape(spikerasterY1,maxtrialspk*ntrials_group,1);
                if exist('groupcolor','var')
                    col = groupcolor(i,:);
                else
                    col = plotcolstr(i,-1,'altcolors',altcolors');
                end
                obj = plot(spikerasterX,spikerasterY1,'o','Color',col,'MarkerSize',dotsize,otheropts{:});
            else
                spikerasterX = reshape(spiketimes(bi(i):bi(i+1)-1,:)',maxtrialspk*ntrials_group,1);
                spikerasterX = repmat(spikerasterX',2,1);
                spikerasterY1 = repmat(spikerasterYlo(bi(i):bi(i+1)-1),maxtrialspk,1);
                spikerasterY1 = reshape(spikerasterY1,maxtrialspk*ntrials_group,1);
                spikerasterY2 = repmat(spikerasterYhi(bi(i):bi(i+1)-1),maxtrialspk,1);
                spikerasterY2 = reshape(spikerasterY2,maxtrialspk*ntrials_group,1);
                spikerasterY = [spikerasterY1';spikerasterY2'];
                if exist('groupcolor','var')
                    col = groupcolor(i,:);
                else
                    col = plotcolstr(i,-1,'altcolors',altcolors');
                end
                obj = line(spikerasterX,spikerasterY,'Color',col,otheropts{:});
                if rastlabelon
                    text(-(diff(xlim)/32),spikerasterYlo(bi(i)+round(ntrials_group/2)-1),...
                        num2str(groupi(bi(i))),'Color',col,'FontSize',6,...
                        'HorizontalAlignment','right');
                end
            end
        end
   end
   
end

if labelon
   xlabel('Time (ms)');
end
