-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_fluxo_consolidado (DT_REFERENCIA_1_P text, DT_REFERENCIA_2_P text, DT_REFERENCIA_3_P text, CD_EMPRESA_P text) AS $body$
DECLARE



ds_conta_estrut_w	varchar(255);
cd_conta_apres_w	varchar(255);
vl_fluxo_1_w		double precision;
vl_fluxo_2_w		double precision;
vl_fluxo_3_w		double precision;
vl_total_w			double precision;
ds_comando_w		varchar(3200);
cd_sqlw_empresa_w		varchar(4000);
ie_empresa_est_contido_w 		varchar(1) := 'S';
DT_REFERENCIA_1_W varchar(20);
DT_REFERENCIA_2_W varchar(20);
DT_REFERENCIA_3_W varchar(20);

c01 CURSOR FOR
SELECT cd_conta_apres, ds_conta_estrut,
	sum(CASE WHEN vl_fluxo_01=0 THEN vl_fluxo_1  ELSE vl_fluxo_01 END ) vl_fluxo_1,
	sum(CASE WHEN vl_fluxo_02=0 THEN vl_fluxo_2  ELSE vl_fluxo_02 END ) vl_fluxo_2,
	sum(CASE WHEN vl_fluxo_03=0 THEN vl_fluxo_3  ELSE vl_fluxo_03 END ) vl_fluxo_3,
	sum(CASE WHEN vl_fluxo_01 + vl_fluxo_02+vl_fluxo_03=0 THEN  vl_fluxo_1 + vl_fluxo_2+vl_fluxo_3  ELSE vl_fluxo_01 + vl_fluxo_02+vl_fluxo_03 END ) vl_total
from(
	SELECT c.cd_conta_apres, c.ds_conta_estrut,
		CASE WHEN obter_se_totaliza_cf(c.cd_conta_financ)='S' THEN  CASE WHEN c.cd_conta_financ=obter_conta_financ_param(a.CD_ESTABELECIMENTO, 2) THEN  obter_valor_fluxo_saldo_lote(a.CD_ESTABELECIMENTO, 'P', CASE WHEN DT_REFERENCIA_1_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_1_W,'dd/mm/yyyy') END , CASE WHEN DT_REFERENCIA_1_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_1_W,'dd/mm/yyyy') END  , 2) WHEN c.cd_conta_financ=obter_conta_financ_param(a.CD_ESTABELECIMENTO, 1) THEN  obter_valor_fluxo_saldo_lote(a.CD_ESTABELECIMENTO, 'P', CASE WHEN DT_REFERENCIA_1_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_1_W,'dd/mm/yyyy') END  , CASE WHEN DT_REFERENCIA_1_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_1_W,'dd/mm/yyyy') END  , 1)  ELSE 0 END   ELSE 0 END  vl_fluxo_01,
		SUM(CASE WHEN TO_CHAR(a.dt_referencia,'mm/yyyy')=CASE WHEN DT_REFERENCIA_1_W='/' THEN null  ELSE DT_REFERENCIA_1_W END  THEN a.vl_fluxo  ELSE 0 END ) vl_fluxo_1,
		CASE WHEN obter_se_totaliza_cf(c.cd_conta_financ)='S' THEN  CASE WHEN c.cd_conta_financ=obter_conta_financ_param(a.CD_ESTABELECIMENTO, 2) THEN  obter_valor_fluxo_saldo_lote(a.CD_ESTABELECIMENTO, 'P', CASE WHEN DT_REFERENCIA_2_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_2_W,'dd/mm/yyyy') END , CASE WHEN DT_REFERENCIA_2_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_2_W,'dd/mm/yyyy') END  , 2) WHEN c.cd_conta_financ=obter_conta_financ_param(a.CD_ESTABELECIMENTO, 1) THEN  obter_valor_fluxo_saldo_lote(a.CD_ESTABELECIMENTO, 'P', CASE WHEN DT_REFERENCIA_2_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_2_W,'dd/mm/yyyy') END  , CASE WHEN DT_REFERENCIA_2_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_2_W,'dd/mm/yyyy') END  , 1)  ELSE 0 END   ELSE 0 END  vl_fluxo_02,
		SUM(CASE WHEN TO_CHAR(a.dt_referencia,'mm/yyyy')=CASE WHEN DT_REFERENCIA_2_W='/' THEN null  ELSE DT_REFERENCIA_2_W END  THEN a.vl_fluxo  ELSE 0 END ) vl_fluxo_2,
		CASE WHEN obter_se_totaliza_cf(c.cd_conta_financ)='S' THEN  CASE WHEN c.cd_conta_financ=obter_conta_financ_param(a.CD_ESTABELECIMENTO, 2) THEN  obter_valor_fluxo_saldo_lote(a.CD_ESTABELECIMENTO, 'P', CASE WHEN DT_REFERENCIA_3_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_3_W,'dd/mm/yyyy') END , CASE WHEN DT_REFERENCIA_3_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_3_W,'dd/mm/yyyy') END  , 2) WHEN c.cd_conta_financ=obter_conta_financ_param(a.CD_ESTABELECIMENTO, 1) THEN  obter_valor_fluxo_saldo_lote(a.CD_ESTABELECIMENTO, 'P', CASE WHEN DT_REFERENCIA_3_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_3_W,'dd/mm/yyyy') END  , CASE WHEN DT_REFERENCIA_3_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_3_W,'dd/mm/yyyy') END  , 1)  ELSE 0 END   ELSE 0 END  vl_fluxo_03,
		SUM(CASE WHEN TO_CHAR(a.dt_referencia,'mm/yyyy')=CASE WHEN DT_REFERENCIA_3_W='/' THEN null  ELSE DT_REFERENCIA_3_W END  THEN a.vl_fluxo  ELSE 0 END ) vl_fluxo_3
	FROM	conta_financeira_v c, 	fluxo_caixa_lote b, 	fluxo_caixa_data a
	WHERE	a.vl_fluxo	<> 0 
	AND	c.ie_oper_fluxo = coalesce('',c.ie_oper_fluxo) 
	AND	coalesce(c.ie_situacao,'A') = coalesce('A',coalesce(c.ie_situacao,'A')) 
	AND	a.cd_conta_financ = c.cd_conta_financ 
	AND	b.ie_classif_fluxo = 'P'
	and ((cd_sqlw_empresa_w = 'X') or (obter_se_contido(b.cd_empresa, cd_sqlw_empresa_w) = ie_empresa_est_contido_w)) 
	AND	a.nr_seq_lote_fluxo = b.nr_sequencia 
	AND	coalesce(a.ie_origem,'X') = coalesce('',coalesce(a.ie_origem,'X')) 
	AND	coalesce(a.ie_nivel,1) <= coalesce('4',1) 
	AND	((DT_REFERENCIA_1_W <> '/' AND TO_CHAR(a.dt_referencia,'mm/yyyy') = DT_REFERENCIA_1_W) 
		OR (DT_REFERENCIA_2_W <> '/' AND TO_CHAR(a.dt_referencia,'mm/yyyy') = DT_REFERENCIA_2_W) 
			OR (DT_REFERENCIA_3_W <> '/' AND TO_CHAR(a.dt_referencia,'mm/yyyy') = DT_REFERENCIA_3_W))
	GROUP BY c.cd_conta_apres, c.ds_conta_estrut,
		CASE WHEN obter_se_totaliza_cf(c.cd_conta_financ)='S' THEN  CASE WHEN c.cd_conta_financ=obter_conta_financ_param(a.CD_ESTABELECIMENTO, 2) THEN  obter_valor_fluxo_saldo_lote(a.CD_ESTABELECIMENTO, 'P', CASE WHEN DT_REFERENCIA_1_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_1_W,'dd/mm/yyyy') END , CASE WHEN DT_REFERENCIA_1_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_1_W,'dd/mm/yyyy') END  , 2) WHEN c.cd_conta_financ=obter_conta_financ_param(a.CD_ESTABELECIMENTO, 1) THEN  obter_valor_fluxo_saldo_lote(a.CD_ESTABELECIMENTO, 'P', CASE WHEN DT_REFERENCIA_1_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_1_W,'dd/mm/yyyy') END  , CASE WHEN DT_REFERENCIA_1_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_1_W,'dd/mm/yyyy') END  , 1)  ELSE 0 END   ELSE 0 END ,
		CASE WHEN obter_se_totaliza_cf(c.cd_conta_financ)='S' THEN  CASE WHEN c.cd_conta_financ=obter_conta_financ_param(a.CD_ESTABELECIMENTO, 2) THEN  obter_valor_fluxo_saldo_lote(a.CD_ESTABELECIMENTO, 'P', CASE WHEN DT_REFERENCIA_2_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_2_W,'dd/mm/yyyy') END , CASE WHEN DT_REFERENCIA_2_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_2_W,'dd/mm/yyyy') END  , 2) WHEN c.cd_conta_financ=obter_conta_financ_param(a.CD_ESTABELECIMENTO, 1) THEN  obter_valor_fluxo_saldo_lote(a.CD_ESTABELECIMENTO, 'P', CASE WHEN DT_REFERENCIA_2_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_2_W,'dd/mm/yyyy') END  , CASE WHEN DT_REFERENCIA_2_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_2_W,'dd/mm/yyyy') END  , 1)  ELSE 0 END   ELSE 0 END ,
		CASE WHEN obter_se_totaliza_cf(c.cd_conta_financ)='S' THEN  CASE WHEN c.cd_conta_financ=obter_conta_financ_param(a.CD_ESTABELECIMENTO, 2) THEN  obter_valor_fluxo_saldo_lote(a.CD_ESTABELECIMENTO, 'P', CASE WHEN DT_REFERENCIA_3_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_3_W,'dd/mm/yyyy') END , CASE WHEN DT_REFERENCIA_3_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_3_W,'dd/mm/yyyy') END  , 2) WHEN c.cd_conta_financ=obter_conta_financ_param(a.CD_ESTABELECIMENTO, 1) THEN  obter_valor_fluxo_saldo_lote(a.CD_ESTABELECIMENTO, 'P', CASE WHEN DT_REFERENCIA_3_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_3_W,'dd/mm/yyyy') END  , CASE WHEN DT_REFERENCIA_3_W='/' THEN null  ELSE TO_DATE('01/' || DT_REFERENCIA_3_W,'dd/mm/yyyy') END  , 1)  ELSE 0 END   ELSE 0 END )
GROUP BY cd_conta_apres, ds_conta_estrut
ORDER BY cd_conta_apres;



BEGIN

DT_REFERENCIA_1_W	:= replace(DT_REFERENCIA_1_P,' ','');
DT_REFERENCIA_2_W	:= replace(DT_REFERENCIA_2_P,' ','');
DT_REFERENCIA_3_W	:= replace(DT_REFERENCIA_3_P,' ','');


cd_sqlw_empresa_w := replace(CD_EMPRESA_P,' ','');
cd_sqlw_empresa_w := replace(cd_sqlw_empresa_w,'(','');
cd_sqlw_empresa_w := replace(cd_sqlw_empresa_w,')','');
cd_sqlw_empresa_w := coalesce(cd_sqlw_empresa_w,'X');

CALL Exec_sql_Dinamico('Tasy', 'drop table w_fluxo_caixa_consolidado');

-- criar tabela
ds_comando_w		:= 'create table w_fluxo_caixa_consolidado (cd_conta_apres varchar2(255), ds_conta_estrut varchar2(255), vl_fluxo_1 NUMBER(17,4), vl_fluxo_2 NUMBER(17,4), vl_fluxo_3 NUMBER(17,4), vl_total NUMBER(17,4))';

CALL Exec_sql_Dinamico('Tasy', ds_comando_w);


-- carregar contas financeiras
open c01;
loop
fetch c01 into
	cd_conta_apres_w,
	ds_conta_estrut_w,
	vl_fluxo_1_w,
	vl_fluxo_2_w,
	vl_fluxo_3_w,
	vl_total_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	CALL Exec_sql_Dinamico('Tasy', 'insert into w_fluxo_caixa_consolidado (cd_conta_apres, ds_conta_estrut, vl_fluxo_1, vl_fluxo_2, vl_fluxo_3, vl_total) values (' || chr(39) || cd_conta_apres_w || chr(39) || ',' || chr(39) || ds_conta_estrut_w || chr(39) || ', ' || chr(39) || vl_fluxo_1_w || chr(39) || ', ' || chr(39) || vl_fluxo_2_w || chr(39) || ', ' || chr(39) || vl_fluxo_3_w || chr(39) || ', ' || chr(39) || vl_total_w || chr(39) ||')');
	
	end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_fluxo_consolidado (DT_REFERENCIA_1_P text, DT_REFERENCIA_2_P text, DT_REFERENCIA_3_P text, CD_EMPRESA_P text) FROM PUBLIC;

