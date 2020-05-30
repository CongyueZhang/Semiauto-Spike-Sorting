function idx=ClusterRL_FCM(features)
% global data
% global parameters;
% ���룺
% data ���ݼ� n��m�У�nΪ������������mΪ���ݵ�������
% c �������ĵĸ���

%     data.idx{ch} = zeros(size(data.waveforms{ch},1),1);
    n = size(features, 1);% ��������
    m = size(features, 2);% ��������
    %��ʼ��
    V=features;
    c=n;           %
    alpha_old=1/c*ones(1,c);
    r1=1;
    r2=1;
    r3=1;
    t=1;
    delta=1e4;
    Epsilon=0.05;
    %����U
    while (delta>Epsilon)
        for k=1:c
            for i=1:n
                distance(i,k)=norm(features(i,:)-V(k,:));
            end
        end
        U1=exp((-distance.^2+r1*log(alpha_old))/r2);
        U2=ones(1,c).*sum(exp((-distance.^2+r1*log(alpha_old))/r2),2);
        U=U1./U2;
        %����r1,r2
        r1=exp(-t/10);
        r2=exp(-t/100);
        %����alpha
        alpha_new=(1/n)*sum(U)+(r3/r1)*alpha_old.*(bsxfun(@minus,log(alpha_old),sum(log(alpha_old).*alpha_old)));
        %����r3
        eta=min(1,2/(m.^floor(m/2-1)));
        temp1_r3=sum(exp(-eta*n*abs(alpha_new-alpha_old)))/c;
        temp2_r3=(1-max((1/n)*sum(U)))/(-max(alpha_old)*sum(alpha_old.*log(alpha_old)));
        r3=min(temp1_r3,temp2_r3);
        %����c,
        c=c-length(find(alpha_new<1/n));
        %if t>=100
        % r3=0
        %end
        %��ʣ���alpha��U���¹�һ��
        alpha_old=alpha_new(alpha_new>=1/n)/sum(alpha_new(alpha_new>=1/n));
        index=find(alpha_new<1/n);
        U(:,index(1:end))=[];
        U=bsxfun(@rdivide,U,sum(U,2));
        %����������ȶ�ͬʱ�����������ڻ����100�ε�ʱ,r3=0.
        if  t>=100 && isempty(find(alpha_new<1/n, 1))
            r3=0;
        end
        %����V
        % V_new=(bsxfun(@rdivide,sum((data'*U),2),sum(U)))';
        V_new=[];
        for k=1:c
            V_new(k,:)=sum(U(:,k).*features(:,:))/sum(U(:,k));
        end
        
        if isempty(find(alpha_new<1/n, 1))
            D=abs(minus(V_new,V)) ;
            delta=max(D,[],'all');
        end
        
        V=V_new;
        t=t+1;
        distance=[];
        D=[];
    end
    
    %  [~,label] = max(U');
    %   gscatter(data(:,1),data(:,2),label)
    [~,idx] = max(U,[],2);

 
 
end
   
 
