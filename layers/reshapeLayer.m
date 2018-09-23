classdef reshapeLayer < abstractMeganetElement
    % classdef reshapeLayer < abstractMeganetElement
    %
    % reshapes the feature matrix (used in semantic segmentation)
    %
    % this layer has no trainable weights
    %
    properties
        nY          % dimension of input data
        perm        % permutation applied to input data
        nZ          % dimension of output data
        useGPU      % flag for GPU computing 
        precision   % flag for precision
        outTimes 
    end
    methods
        function this = reshapeLayer(nY,nZ,varargin)
            if nargin==0
                help(mfilename)
                return;
            end
            perm  = [1 2 3 4];
            useGPU     = 0;
            precision  = 'double';
            for k=1:2:length(varargin)     % overwrites default parameter
                    eval([varargin{k},'=varargin{',int2str(k+1),'};']);
            end
            
            this.useGPU = useGPU;
            this.precision = precision;
            this.perm = perm;
            this.nY = nY;
            this.nZ = nZ;
            this.outTimes = 1;
            
        end
        function [Ydata,Y,dA] = apply(this,theta,Y,varargin)
            dA  = [];
            nex = size(Y,ndims(Y));
            Y   = permute(Y,this.perm);
            Y   = reshape(Y,[this.nZ nex]);
            Ydata = Y;
        end
        
        
        function n = nTheta(this)
            n = 0;
            
        end
        
        function n = nFeatIn(this)
            n = this.nY;
        end
        
        function n = nFeatOut(this)
            n = this.nZ;
        end
       
        function n = nDataOut(this)
            n = this.nZ;
        end
        
        function theta = initTheta(this)
            theta = [];
        end
        
        
        function [dYdata,dY] = Jthetamv(this,dtheta,theta,Y,~)
           nex = size(Y,ndims(Y));
           dY = reshape(0*Y,[this.nZ nex]);
           dYdata = dY;
        end
        
        function dtheta = JthetaTmv(this,Z,~,theta,Y,~)
            dtheta = [];
        end
       
        
        function [dYdata,dY] = JYmv(this,dY,theta,~,~)
           [dYdata,dY] = apply(this,theta,dY);
        end
        
        function Z = JYTmv(this,Z,~,theta,Y,~)
            nex = size(Y,ndims(Y));
           Z = reshape(ipermute(Z,this.perm),[this.nY nex]);
        end
        
        
        % ------- functions for handling GPU computing and precision ---- 
        function this = set.useGPU(this,value)
            if (value~=0) && (value~=1)
                error('useGPU must be 0 or 1.')
            else
                this.useGPU  = value;
            end
        end
        function this = set.precision(this,value)
            if not(strcmp(value,'single') || strcmp(value,'double'))
                error('precision must be single or double.')
            else
                this.precision = value;
            end
        end
        function useGPU = get.useGPU(this)
            useGPU = this.useGPU;
        end
        function precision = get.precision(this)
            precision = this.precision;
        end
    end
end


