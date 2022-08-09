-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_acumular_saldo_centro ( cd_centro_custo_p bigint, cd_classif_centro_p text, qt_meses_p bigint, ie_tipo_valor_p bigint, ie_tipo_centro_p text, nm_usuario_p text) AS $body$
DECLARE


cd_classif_centro_w			varchar(40);
ie_w 					varchar(10);
pr_var_01_w				double precision;
pr_var_02_w				double precision;
pr_var_03_w				double precision;
pr_var_04_w				double precision;
pr_var_05_w				double precision;
pr_var_06_w				double precision;
pr_var_07_w				double precision;
pr_var_08_w				double precision;
pr_var_09_w				double precision;
pr_var_10_w				double precision;
pr_var_11_w				double precision;
pr_var_12_w				double precision;
vl_media_w				double precision;
vl_orc_01_w				double precision;
vl_orc_02_w				double precision;
vl_orc_03_w				double precision;
vl_orc_04_w				double precision;
vl_orc_05_w				double precision;
vl_orc_06_w				double precision;
vl_orc_07_w				double precision;
vl_orc_08_w				double precision;
vl_orc_09_w				double precision;
vl_orc_10_w				double precision;
vl_orc_11_w				double precision;
vl_orc_12_w				double precision;
vl_total_w				double precision;
vl_real_01_w				double precision;
vl_real_02_w				double precision;
vl_real_03_w				double precision;
vl_real_04_w				double precision;
vl_real_05_w				double precision;
vl_real_06_w				double precision;
vl_real_07_w				double precision;
vl_real_08_w				double precision;
vl_real_09_w				double precision;
vl_real_10_w				double precision;
vl_real_11_w				double precision;
vl_real_12_w				double precision;
vl_total_real_w				double precision;
vl_media_real_w				double precision;
vl_variacao_w				double precision;
pr_variacao_w				double precision;
nr_nivel_classif_w			bigint;
ie_tipo_centro_w			varchar(1);

vl_variacao_01_w			double precision;
vl_variacao_02_w			double precision;
vl_variacao_03_w			double precision;
vl_variacao_04_w			double precision;
vl_variacao_05_w			double precision;
vl_variacao_06_w			double precision;
vl_variacao_07_w			double precision;
vl_variacao_08_w			double precision;
vl_variacao_09_w			double precision;
vl_variacao_10_w			double precision;
vl_variacao_11_w			double precision;
vl_variacao_12_w			double precision;



c01 CURSOR FOR
SELECT	'T' ie,
	coalesce(sum(a.vl_orc_01),0) vl_orc_01,
	coalesce(sum(a.vl_orc_02),0) vl_orc_02,
	coalesce(sum(a.vl_orc_03),0) vl_orc_03,
	coalesce(sum(a.vl_orc_04),0) vl_orc_04,
	coalesce(sum(a.vl_orc_05),0) vl_orc_05,
	coalesce(sum(a.vl_orc_06),0) vl_orc_06,
	coalesce(sum(a.vl_orc_07),0) vl_orc_07,
	coalesce(sum(a.vl_orc_08),0) vl_orc_08,
	coalesce(sum(a.vl_orc_09),0) vl_orc_09,
	coalesce(sum(a.vl_orc_10),0) vl_orc_10,
	coalesce(sum(a.vl_orc_11),0) vl_orc_11,
	coalesce(sum(a.vl_orc_12),0) vl_orc_12,
	coalesce(sum(a.vl_real_01),0) vl_real_01,
	coalesce(sum(a.vl_real_02),0) vl_real_02,
	coalesce(sum(a.vl_real_03),0) vl_real_03,
	coalesce(sum(a.vl_real_04),0) vl_real_04,
	coalesce(sum(a.vl_real_05),0) vl_real_05,
	coalesce(sum(a.vl_real_06),0) vl_real_06,
	coalesce(sum(a.vl_real_07),0) vl_real_07,
	coalesce(sum(a.vl_real_08),0) vl_real_08,
	coalesce(sum(a.vl_real_09),0) vl_real_09,
	coalesce(sum(a.vl_real_10),0) vl_real_10,
	coalesce(sum(a.vl_real_11),0) vl_real_11,
	coalesce(sum(a.vl_real_12),0) vl_real_12,
	coalesce(sum(coalesce(a.vl_total,0)),0) vl_total,
	coalesce(sum(coalesce(a.vl_media,0)),0) vl_media
from	w_ctb_orcamento_vis a
where	a.nm_usuario		= nm_usuario_p
and	ie_tipo_centro_w	= 'T'
and	ctb_obter_nivel_classif_conta(cd_classificacao)	= nr_nivel_classif_w

union

SELECT	'A' ie,
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_orc_01 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_orc_01 * -1)  ELSE a.vl_orc_01 END  END ), 0) vl_orc_01,
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_orc_02 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_orc_02 * -1)  ELSE a.vl_orc_02 END  END ), 0) vl_orc_02,
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_orc_03 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_orc_03 * -1)  ELSE a.vl_orc_03 END  END ), 0) vl_orc_03,
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_orc_04 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_orc_04 * -1)  ELSE a.vl_orc_04 END  END ), 0) vl_orc_04,
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_orc_05 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_orc_05 * -1)  ELSE a.vl_orc_05 END  END ), 0) vl_orc_05,
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_orc_06 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_orc_06 * -1)  ELSE a.vl_orc_06 END  END ), 0) vl_orc_06,
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_orc_07 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_orc_07 * -1)  ELSE a.vl_orc_07 END  END ), 0) vl_orc_07,
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_orc_08 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_orc_08 * -1)  ELSE a.vl_orc_08 END  END ), 0) vl_orc_08,
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_orc_09 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_orc_09 * -1)  ELSE a.vl_orc_09 END  END ), 0) vl_orc_09,
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_orc_10 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_orc_10 * -1)  ELSE a.vl_orc_10 END  END ), 0) vl_orc_10,
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_orc_11 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_orc_11 * -1)  ELSE a.vl_orc_11 END  END ), 0) vl_orc_11,
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_orc_12 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_orc_12 * -1)  ELSE a.vl_orc_12 END  END ), 0) vl_orc_12,
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_real_01 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_real_01 * -1)  ELSE a.vl_real_01 END  END ), 0) vl_real_01,
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_real_02 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_real_02 * -1)  ELSE a.vl_real_02 END  END ), 0) vl_real_02,	
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_real_03 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_real_03 * -1)  ELSE a.vl_real_03 END  END ), 0) vl_real_03,
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_real_04 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_real_04 * -1)  ELSE a.vl_real_04 END  END ), 0) vl_real_04,	
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_real_05 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_real_05 * -1)  ELSE a.vl_real_05 END  END ), 0) vl_real_05,	
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_real_06 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_real_06 * -1)  ELSE a.vl_real_06 END  END ), 0) vl_real_06,	
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_real_07 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_real_07 * -1)  ELSE a.vl_real_07 END  END ), 0) vl_real_07,	
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_real_08 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_real_08 * -1)  ELSE a.vl_real_08 END  END ), 0) vl_real_08,	
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_real_09 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_real_09 * -1)  ELSE a.vl_real_09 END  END ), 0) vl_real_09,	
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_real_10 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_real_10 * -1)  ELSE a.vl_real_10 END  END ), 0) vl_real_10,	
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_real_11 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_real_11 * -1)  ELSE a.vl_real_11 END  END ), 0) vl_real_11,	
	coalesce(sum(CASE WHEN coalesce(b.ie_deducao_acomp_orc,'N')='S' THEN (a.vl_real_12 * -1)  ELSE CASE WHEN c.ie_debito_credito='D' THEN (a.vl_real_12 * -1)  ELSE a.vl_real_12 END  END ), 0) vl_real_12,	
	coalesce(sum(a.vl_total),0) vl_total,
	coalesce(sum(a.vl_media),0) vl_media
from	ctb_grupo_conta c,
	conta_contabil b,
	w_ctb_orcamento_vis a
where	a.cd_conta_contabil	= b.cd_conta_contabil
and	b.cd_grupo		= c.cd_grupo
and	a.nm_usuario		= nm_usuario_p
and	a.cd_centro_custo	= cd_centro_custo_p
and	b.ie_tipo		= 'A';



BEGIN

ie_tipo_centro_w		:= ie_tipo_centro_p;
nr_nivel_classif_w		:= ctb_obter_nivel_classif_conta(cd_classif_centro_p) + 1;

if (nr_nivel_classif_w > 0) then
	begin
	
	
	open C01;
	loop
	fetch c01 into
		ie_w,
		vl_orc_01_w,
		vl_orc_02_w,
		vl_orc_03_w,
		vl_orc_04_w,
		vl_orc_05_w,
		vl_orc_06_w,
		vl_orc_07_w,
		vl_orc_08_w,
		vl_orc_09_w,
		vl_orc_10_w,
		vl_orc_11_w,
		vl_orc_12_w,
		vl_real_01_w,
		vl_real_02_w,
		vl_real_03_w,
		vl_real_04_w,
		vl_real_05_w,
		vl_real_06_w,
		vl_real_07_w,
		vl_real_08_w,
		vl_real_09_w,
		vl_real_10_w,
		vl_real_11_w,
		vl_real_12_w,
		vl_total_w,
		vl_media_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		vl_total_real_w	:= 0;
		if (ie_w = ie_tipo_centro_w) then
			begin
			pr_var_01_w		:= dividir(((vl_real_01_w - vl_orc_01_w) *100), vl_orc_01_w);
			pr_var_02_w		:= dividir(((vl_real_02_w - vl_orc_02_w) *100), vl_orc_02_w);
			pr_var_03_w		:= dividir(((vl_real_03_w - vl_orc_03_w) *100), vl_orc_03_w);
			pr_var_04_w		:= dividir(((vl_real_04_w - vl_orc_04_w) *100), vl_orc_04_w);
			pr_var_05_w		:= dividir(((vl_real_05_w - vl_orc_05_w) *100), vl_orc_05_w);
			pr_var_06_w		:= dividir(((vl_real_06_w - vl_orc_06_w) *100), vl_orc_06_w);
			pr_var_07_w		:= dividir(((vl_real_07_w - vl_orc_07_w) *100), vl_orc_07_w);
			pr_var_08_w		:= dividir(((vl_real_08_w - vl_orc_08_w) *100), vl_orc_08_w);
			pr_var_09_w		:= dividir(((vl_real_09_w - vl_orc_09_w) *100), vl_orc_09_w);
			pr_var_10_w		:= dividir(((vl_real_10_w - vl_orc_10_w) *100), vl_orc_10_w);
			pr_var_11_w		:= dividir(((vl_real_11_w - vl_orc_11_w) *100), vl_orc_11_w);
			pr_var_12_w		:= dividir(((vl_real_12_w - vl_orc_12_w) *100), vl_orc_12_w);

			if (ie_tipo_valor_p = 0) then

				vl_total_w	:= 	vl_orc_01_w + vl_orc_02_w + vl_orc_03_w +
							vl_orc_04_w + vl_orc_05_w + vl_orc_06_w +
							vl_orc_07_w + vl_orc_08_w + vl_orc_09_w +
							vl_orc_10_w + vl_orc_11_w + vl_orc_12_w;
				vl_total_real_w	:= 0;			
				
			elsif (ie_tipo_valor_p = 1) then
				vl_total_w	:= 	vl_real_01_w + vl_real_02_w + vl_real_03_w +
							vl_real_04_w + vl_real_05_w + vl_real_06_w +
							vl_real_07_w + vl_real_08_w + vl_real_09_w +
							vl_real_10_w + vl_real_11_w + vl_real_12_w;
				vl_total_real_w	:= 0;	
			elsif (ie_tipo_valor_p in (3,4)) then
				begin
				vl_total_w	:= 	vl_orc_01_w + vl_orc_02_w + vl_orc_03_w +
							vl_orc_04_w + vl_orc_05_w + vl_orc_06_w +
							vl_orc_07_w + vl_orc_08_w + vl_orc_09_w +
							vl_orc_10_w + vl_orc_11_w + vl_orc_12_w;
				
				
				vl_total_real_w	:= 	vl_real_01_w + vl_real_02_w + vl_real_03_w +
							vl_real_04_w + vl_real_05_w + vl_real_06_w +
							vl_real_07_w + vl_real_08_w + vl_real_09_w +
							vl_real_10_w + vl_real_11_w + vl_real_12_w;
							
				
				
				vl_variacao_w	:= (vl_total_w - vl_total_real_w);
				pr_variacao_w	:= (dividir(vl_total_real_w - vl_total_w,vl_total_w) * 100);
				
				end;
			end if;

			begin
			vl_media_w			:= dividir(vl_total_w, qt_meses_p);
			vl_media_real_w			:= dividir(vl_total_real_w, qt_meses_p);
			exception when others then
				vl_media_w		:= round((vl_total_w / qt_meses_p)::numeric, 2);
				vl_media_real_w		:= 0;
			end;
					
			
			
			vl_variacao_01_w		:= (vl_real_01_w - vl_orc_01_w);
			vl_variacao_02_w		:= (vl_real_02_w - vl_orc_02_w);
			vl_variacao_03_w		:= (vl_real_03_w - vl_orc_03_w);	
			vl_variacao_04_w		:= (vl_real_04_w - vl_orc_04_w);	
			vl_variacao_05_w		:= (vl_real_05_w - vl_orc_05_w);
			vl_variacao_06_w		:= (vl_real_06_w - vl_orc_06_w);
			vl_variacao_07_w		:= (vl_real_07_w - vl_orc_07_w);
			vl_variacao_08_w		:= (vl_real_08_w - vl_orc_08_w);
			vl_variacao_09_w		:= (vl_real_09_w - vl_orc_09_w);
			vl_variacao_10_w		:= (vl_real_10_w - vl_orc_10_w);
			vl_variacao_11_w		:= (vl_real_11_w - vl_orc_11_w);
			vl_variacao_12_w		:= (vl_real_12_w - vl_orc_12_w);
			
			
			
			update	w_ctb_orcamento_vis
			set	vl_orc_01 	= vl_orc_01_w,
				vl_orc_02 	= vl_orc_02_w,
				vl_orc_03 	= vl_orc_03_w,
				vl_orc_04 	= vl_orc_04_w,
				vl_orc_05 	= vl_orc_05_w,
				vl_orc_06 	= vl_orc_06_w,
				vl_orc_07 	= vl_orc_07_w,
				vl_orc_08 	= vl_orc_08_w,
				vl_orc_09 	= vl_orc_09_w,
				vl_orc_10 	= vl_orc_10_w,
				vl_orc_11 	= vl_orc_11_w,
				vl_orc_12 	= vl_orc_12_w,
				vl_real_01 	= vl_real_01_w,
				vl_real_02 	= vl_real_02_w,
				vl_real_03 	= vl_real_03_w,
				vl_real_04 	= vl_real_04_w,
				vl_real_05 	= vl_real_05_w,
				vl_real_06	= vl_real_06_w,
				vl_real_07	= vl_real_07_w,
				vl_real_08	= vl_real_08_w,
				vl_real_09	= vl_real_09_w,
				vl_real_10 	= vl_real_10_w,
				vl_real_11 	= vl_real_11_w,
				vl_real_12	= vl_real_12_w,
				pr_var_01	= coalesce(pr_var_01_w, 0),
				pr_var_02	= coalesce(pr_var_02_w, 0),
				pr_var_03	= coalesce(pr_var_03_w, 0),
				pr_var_04	= coalesce(pr_var_04_w, 0),
				pr_var_05	= coalesce(pr_var_05_w, 0),
				pr_var_06	= coalesce(pr_var_06_w, 0),
				pr_var_07	= coalesce(pr_var_07_w, 0),
				pr_var_08	= coalesce(pr_var_08_w, 0),
				pr_var_09	= coalesce(pr_var_09_w, 0),
				pr_var_10	= coalesce(pr_var_10_w, 0),
				pr_var_11	= coalesce(pr_var_11_w, 0),
				pr_var_12	= coalesce(pr_var_12_w, 0),
				vl_total	= vl_total_w,
				vl_media	= vl_media_w,
				vl_variacao	= vl_variacao_w,
				pr_variacao	= pr_variacao_w,
				vl_total_real	= vl_total_real_w,
				vl_media_real 	= vl_media_real_w,
				vl_var_01       = vl_variacao_01_w,
				vl_var_02       = vl_variacao_02_w,
 				vl_var_03       = vl_variacao_03_w,
				vl_var_04       = vl_variacao_04_w,
 				vl_var_05       = vl_variacao_05_w,			
				vl_var_06       = vl_variacao_06_w,
 				vl_var_07       = vl_variacao_07_w,
 				vl_var_08       = vl_variacao_08_w,
 				vl_var_09       = vl_variacao_09_w,
				vl_var_10       = vl_variacao_10_w,
				vl_var_11       = vl_variacao_11_w,
				vl_var_12	= vl_variacao_12_w
				where	cd_classificacao 	= cd_classif_centro_p
			and	nm_usuario	= nm_usuario_p;

			end;
		end if;
		end;
	end loop;
	close C01;
	if (ie_tipo_centro_w = 'T') then
		nr_nivel_classif_w	:= nr_nivel_classif_w - 1;
	else
		nr_nivel_classif_w	:= 0;
	end if;
	end;
	end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_acumular_saldo_centro ( cd_centro_custo_p bigint, cd_classif_centro_p text, qt_meses_p bigint, ie_tipo_valor_p bigint, ie_tipo_centro_p text, nm_usuario_p text) FROM PUBLIC;
