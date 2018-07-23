#!/bin/bash

## NOTE: When using "sed" commands, the path names can't have "/" and should be replaced by "\/" as shown ##
## NOTE: When you put {} around the variable, it may complain about the "/" but not when you put single quotes, check this again!
## NOTE: If you have file path in your variable (like the $PWD) below, it's better to change the sed delimiter to "|" so it doesn't confuse it with the "/" in the file path

##------------------------------------ User Defined -------------------------------------------------------------
#OutputPath="/hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_Friday_freq1"
#OutputPath2="\/hpf\/largeprojects\/ccmbio\/samkh\/bioinf_rep\/IBD_genes\/MutationLevel_HSC_Friday_freq1"

OutputPath="/hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_genes/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26"
OutputPath2="\/hpf\/largeprojects\/ccmbio\/samkh\/bioinf_rep\/IBD_genes\/MutationLevel_HSC_noMNPs_freq0.01_Het_oct26"

Input_family_file="/hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_families/1and2family_sorted_HSC.txt"
Input_family_file2="\/hpf\/largeprojects\/ccmbio\/samkh\/bioinf_rep\/IBD_families\/1and2family_sorted_HSC.txt"

Freq_cutoff=0.01
Zygosity=HET ## Possible options: HOM, HET, HOMHET



mkdir -p $OutputPath

echo -e "Time run: \n"$(date) > $OutputPath/log.txt
echo -e "\nOutputPath: \n"$OutputPath >> $OutputPath/log.txt
echo -e "\nInput_Family_File: \n"${Input_family_file} >> $OutputPath/log.txt
echo -e "\nFrequency cut off: \n"${Freq_cutoff} >> $OutputPath/log.txt
echo -e "\nZygosity counted: \n"${Zygosity} >> $OutputPath/log.txt


mkdir -p Step1b_CoverageAtMutationSite_RunStep1c_sh_folder
rm -f Step1b_CoverageAtMutationSite_RunStep1c_sh_folder/*

for term in frameshift_variant inframe_deletion inframe_insertion missense_variant protein_altering_variant splice_acceptor_variant splice_donor_variant start_lost stop_gained stop_lost transcript_ablation transcript_amplification;
#for term in frameshift_variant inframe_deletion inframe_insertion missense_variant protein_altering_variant;
#for term in frameshift_variant;
#for term in splice_acceptor_variant splice_donor_variant start_lost stop_gained stop_lost transcript_ablation transcript_amplification;
#for term in splice_acceptor_variant splice_donor_variant start_lost stop_gained stop_lost;
#for term in stop_lost;
	do
		sed 's/Category/'"$term"'/g; s/COMMON_FOLDER/'${OutputPath2}'/g; s/INPUT_FAMILY_FILE/'${Input_family_file2}'/g; s|CURRENT_DIRECTORY|'$PWD'|g' Step1b_CoverageAtMutationSite_RunStep1c.sh > Step1b_CoverageAtMutationSite_RunStep1c_2.sh
		## submit a qsub for each of the subsamples of IBD_2600samples which is in the /hpf/largeprojects/ccmbio/samkh/bioinf_rep/IBD_folders_stat/split folder. They have the suffix _aa, _ab, _ac, _ad, etc.
		## (20 x 26letters + 1 = 521)
		for j in {aa,ab,ac,ad,ae,af,ag,ah,ai,aj,ak,al,am,an,ao,ap,aq,ar,as,at,au,av,aw,ax,ay,az,ba,bb,bc,bd,be,bf,bg,bh,bi,bj,bk,bl,bm,bn,bo,bp,bq,br,bs,bt,bu,bv,bw,bx,by,bz,ca,cb,cc,cd,ce,cf,cg,ch,ci,cj,ck,cl,cm,cn,co,cp,cq,cr,cs,ct,cu,cv,cw,cx,cy,cz,da,db,dc,dd,de,df,dg,dh,di,dj,dk,dl,dm,dn,do,dp,dq,dr,ds,dt,du,dv,dw,dx,dy,dz,ea,eb,ec,ed,ee,ef,eg,eh,ei,ej,ek,el,em,en,eo,ep,eq,er,es,et,eu,ev,ew,ex,ey,ez,fa,fb,fc,fd,fe,ff,fg,fh,fi,fj,fk,fl,fm,fn,fo,fp,fq,fr,fs,ft,fu,fv,fw,fx,fy,fz,ga,gb,gc,gd,ge,gf,gg,gh,gi,gj,gk,gl,gm,gn,go,gp,gq,gr,gs,gt,gu,gv,gw,gx,gy,gz,ha,hb,hc,hd,he,hf,hg,hh,hi,hj,hk,hl,hm,hn,ho,hp,hq,hr,hs,ht,hu,hv,hw,hx,hy,hz,ia,ib,ic,id,ie,if,ig,ih,ii,ij,ik,il,im,in,io,ip,iq,ir,is,it,iu,iv,iw,ix,iy,iz,ja,jb,jc,jd,je,jf,jg,jh,ji,jj,jk,jl,jm,jn,jo,jp,jq,jr,js,jt,ju,jv,jw,jx,jy,jz,ka,kb,kc,kd,ke,kf,kg,kh,ki,kj,kk,kl,km,kn,ko,kp,kq,kr,ks,kt,ku,kv,kw,kx,ky,kz,la,lb,lc,ld,le,lf,lg,lh,li,lj,lk,ll,lm,ln,lo,lp,lq,lr,ls,lt,lu,lv,lw,lx,ly,lz,ma,mb,mc,md,me,mf,mg,mh,mi,mj,mk,ml,mm,mn,mo,mp,mq,mr,ms,mt,mu,mv,mw,mx,my,mz,na,nb,nc,nd,ne,nf,ng,nh,ni,nj,nk,nl,nm,nn,no,np,nq,nr,ns,nt,nu,nv,nw,nx,ny,nz,oa,ob,oc,od,oe,of,og,oh,oi,oj,ok,ol,om,on,oo,op,oq,or,os,ot,ou,ov,ow,ox,oy,oz,pa,pb,pc,pd,pe,pf,pg,ph,pi,pj,pk,pl,pm,pn,po,pp,pq,pr,ps,pt,pu,pv,pw,px,py,pz,qa,qb,qc,qd,qe,qf,qg,qh,qi,qj,qk,ql,qm,qn,qo,qp,qq,qr,qs,qt,qu,qv,qw,qx,qy,qz,ra,rb,rc,rd,re,rf,rg,rh,ri,rj,rk,rl,rm,rn,ro,rp,rq,rr,rs,rt,ru,rv,rw,rx,ry,rz,sa,sb,sc,sd,se,sf,sg,sh,si,sj,sk,sl,sm,sn,so,sp,sq,sr,ss,st,su,sv,sw,sx,sy,sz,ta,tb,tc,td,te,tf,tg,th,ti,tj,tk,tl,tm,tn,to,tp,tq,tr,ts,tt,tu,tv,tw,tx,ty,tz,ua}; do 
		#for j in {aa,ab}; do 
			sed 's/IBD_SAMPLE_FILE/IBD_2600samples_'${j}'/g' Step1b_CoverageAtMutationSite_RunStep1c_2.sh > Step1b_CoverageAtMutationSite_RunStep1c_${j}.sh
			chmod u+x Step1b_CoverageAtMutationSite_RunStep1c_${j}.sh
			qsub Step1b_CoverageAtMutationSite_RunStep1c_${j}.sh
			mv Step1b_CoverageAtMutationSite_RunStep1c_${j}.sh Step1b_CoverageAtMutationSite_RunStep1c_sh_folder
		done

done
