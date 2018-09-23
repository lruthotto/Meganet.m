classdef MeganetWeights
    
    properties
        weights
    end
    
    methods
        function this = MeganetWeights(weights)
            if not(exist('weights','var')) || isempty(weights)
                weights = cell(0,1);
            end
            
            if isnumeric(weights)
                weights = {weights};
            end
            this.weights = weights;
        end
        
        % ------- counting ----------
        function n = numel(this)
            if isnumeric(this.weights)
                n = numel(this.weights);
            else
                n = 0;
                for k=1:numel(this.weights)
                    n = n+numel(this.weights{k});
                end
            end            
        end
        
        function mw = split(this,v)
            % splits a vector into MeganetWeights of same structure
            if numel(this) ~= numel(v)
                error('sizes must match');
            end
            w = cell(size(this.weights));
            cnt = 0;
            for k=1:numel(w)
                wk = this.weights{k};
                nk = numel(this.weights{k});
                vk = v(cnt+(1:nk));
                if isnumeric(wk)
                    w{k} = reshape(vk,size(wk));
                else
                    w{k} = split(this.weights{k},vk);
                end
                cnt = cnt + nk;
            end
            mw = MeganetWeights(w);
        end
        
        function this = plus(this,v)
           % addition
           if isnumeric(v)
               v = split(this,v);
           end
           
           for k = numel(this.weights)
               if isnumeric(this.weights{k})
                   this.weights{k} = this.weights{k} + v.weights{k};
               else
                   this.weights{k}  = plus(this.weights{k},v.weights{k});
               end
           end
        end
        function this = times(this,v)
           % addition
           if isnumeric(v)
               v = split(this,v);
           end
           
           for k = numel(this.weights)
               if isnumeric(this.weights{k})
                   this.weights{k} = this.weights{k} .* v.weights{k};
               else
                   this.weights{k}  = times(this.weights{k},v.weights{k});
               end
           end
        end
        
        function v = vec(this)
            v = [];
            for k=1:numel(this.weights)
                   v =[ v;  vec(this.weights{k})];
            end
        end
        
        function this = double(this)
            for k = 1:numel(this.weights)
                this.weights{k}  = double(this.weights{k});
            end
        end
        function this = single(this)
            for k = 1:numel(this.weights)
                this.weights{k}  = single(this.weights{k});
            end
        end
        
        function this = gpuArray(this)
            for k = 1:numel(this.weights)
                this.weights{k}  = gpuArray(this.weights{k});
            end
        end

    end
end

