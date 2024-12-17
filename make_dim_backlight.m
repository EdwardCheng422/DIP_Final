function out=make_dim_backlight(input_img)
    M_f=[95.57 64.67 33.01;49.49 137.29 14.76;0.44 27.21 169.83];
    M_l=[4.61 3.35 1.78;2.48 7.16 0.79; 0.28 1.93 8.93];
    Gamma_rf=2.4767;Gamma_gf=2.4296;Gamma_bf=2.3792;
    Gamma_rl=2.2212;Gamma_gl=2.1044;Gamma_bl=2.1835;
    R=double(input_img(:,:,1))/255;
    G=double(input_img(:,:,2))/255;
    B=double(input_img(:,:,3))/255;
    [r,c]=size(R);
    RGB=transpose([R(:) G(:) B(:)]);
    %disp(max(RGB,[],"all"));
    %disp(min(RGB,[],"all"));
    XYZ=M_l*(RGB.^([Gamma_rl;Gamma_gl;Gamma_bl]));
    
    RGB_estimate=inv(M_f)*XYZ;
    %disp(max(RGB_estimate,[],"all"));
    %disp(min(RGB_estimate,[],"all"));
    %clipping to preserve in [0 1]
    RGB_estimate(RGB_estimate<0)=0;
    RGB_estimate(RGB_estimate>1)=1;

    RGB_estimate=RGB_estimate.^([1/Gamma_rf;1/Gamma_gf;1/Gamma_bf]);
    R_estimate=255*RGB_estimate(1,:);
    G_estimate=255*RGB_estimate(2,:);
    B_estimate=255*RGB_estimate(3,:);

    R_result=reshape(R_estimate,[r c]);
    G_result=reshape(G_estimate,[r c]);
    B_result=reshape(B_estimate,[r c]);

    out=zeros(r,c,3);
    out(:,:,1)=R_result;
    out(:,:,2)=G_result;
    out(:,:,3)=B_result;
    
    out=uint8(round(out));
    

end