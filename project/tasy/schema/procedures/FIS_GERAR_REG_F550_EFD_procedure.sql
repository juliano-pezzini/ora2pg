-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_f550_efd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


aliquota_pis_w		double precision;
aliquota_cofins_w		double precision;
cd_tributo_pis_w		smallint;
cd_tributo_cofins_w		smallint;
nr_seq_regra_efd_w	bigint;
ds_linha_w		varchar(8000);
ds_arquivo_w		varchar(4000);
ds_arquivo_compl_w	varchar(4000);
nr_linha_w		bigint 	:= qt_linha_p;
nr_seq_registro_w		bigint 	:= nr_sequencia_p;
sep_w			varchar(1)	:= ds_separador_p;
nr_seq_data_w		bigint;
vl_pis_w			double precision;
vl_cofins_w		double precision;
qt_registros_w		bigint;
cd_empresa_w		smallint;

c01 CURSOR FOR
	SELECT	round((CASE WHEN coalesce(c.ie_tipo_valor,'VM')='VM' THEN a.vl_movimento WHEN coalesce(c.ie_tipo_valor,'VM')='VC' THEN a.vl_credito WHEN coalesce(c.ie_tipo_valor,'VM')='VD' THEN  a.vl_debito END )::numeric,2) vl_base_calculo,
		c.cd_conta_contabil cd_conta_contabil
	from 	ctb_balancete_v a,
		fis_efd_conta_contabil c,
		fis_efd_regra_tipo_ct r
	where	a.cd_conta_contabil = c.cd_conta_contabil
	and	r.nr_sequencia = c.nr_seq_tipo_ct
	and	a.nr_seq_mes_ref = nr_seq_data_w
	and	r.ie_tipo_ct = 'F550'
	and	a.cd_estabelecimento = coalesce(c.cd_estabelecimento, cd_estabelecimento_p)
	and	obter_empresa_estab(a.cd_estabelecimento) = coalesce(c.cd_empresa, cd_empresa_p)
	and	a.ie_normal_encerramento = 'N';
	
vet01	C01%RowType;


BEGIN

select	cd_empresa
into STRICT	cd_empresa_w
from	estabelecimento
where	cd_estabelecimento = cd_estabelecimento_p;

select	count(*)
into STRICT	qt_registros_w
from	ctb_mes_ref
where	trunc(dt_referencia,'mm') = trunc(dt_inicio_p,'mm')
and	cd_empresa = cd_empresa_w;

if (qt_registros_w = 1) then
	select	nr_sequencia
	into STRICT	nr_seq_data_w
	from 	ctb_mes_ref
	where 	trunc(dt_referencia,'mm') = trunc(dt_inicio_p,'mm')
	and	cd_empresa = cd_empresa_w;
end if;

select	nr_seq_regra_efd
into STRICT	nr_seq_regra_efd_w
from	fis_efd_controle
where	nr_sequencia = nr_seq_controle_p;

select 	cd_tributo_pis,
	cd_tributo_cofins
into STRICT	cd_tributo_pis_w,
	cd_tributo_cofins_w
from	fis_regra_efd
where	nr_sequencia = nr_seq_regra_efd_w;

aliquota_pis_w	:= obter_pr_imposto(cd_tributo_pis_w);
aliquota_cofins_w	:= obter_pr_imposto(cd_tributo_cofins_w);

open C01;
loop
fetch C01 into	
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	vl_pis_w		:= vet01.vl_base_calculo * (aliquota_pis_w/ 100);
	vl_cofins_w	:= vet01.vl_base_calculo * (aliquota_cofins_w/100);

	ds_linha_w	:= substr(	sep_w || 'F550'						|| 	-- REG
				sep_w || replace(campo_mascara(vet01.vl_base_calculo,2),'.',',')	||	-- VL_REC_COMP
				sep_w || '01'						|| 	-- CST_PIS
				sep_w || 0							||	-- VL_DESC_PIS
				sep_w || replace(campo_mascara(vet01.vl_base_calculo,2),'.',',')	||	-- VL_BC_PIS
				sep_w || replace(campo_mascara(aliquota_pis_w,2),'.',',')		|| 	-- ALIQ_PIS
				sep_w || replace(campo_mascara(vl_pis_w,2),'.',',')			|| 	-- VL_PIS
				sep_w || '01'						|| 	-- CST_COFINS
				sep_w || 0							|| 	-- VL_DESC_COFINS
				sep_w || replace(campo_mascara(vet01.vl_base_calculo,2),'.',',')	|| 	-- VL_BC_COFINS
				sep_w || replace(campo_mascara(aliquota_cofins_w,2),'.',',')		|| 	-- ALIQ_COFINS
				sep_w || replace(campo_mascara(vl_cofins_w,2),'.',',')		|| 	-- VL_COFINS
				sep_w || ''							|| 	-- COD_MOD
				sep_w || ''							|| 	-- CFOP
				sep_w || vet01.cd_conta_contabil				|| 	-- COD_CTA
				sep_w || ''							|| 	-- INFO_COMPL
				sep_w, 1, 8000);
	
	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w		:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;
		
	insert into fis_efd_0900(	nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_seq_controle,
								ds_registro,
								cd_cst,
								cd_ind_oper,
								vl_registro )
					values ( 	nextval('fis_efd_0900_seq'),
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								nr_seq_controle_p,
								'F550',
								'01',
								0,
								vet01.vl_base_calculo );

	insert into fis_efd_arquivo(
		nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		nr_seq_controle_efd,
		nr_linha,
		cd_registro,
		ds_arquivo,
		ds_arquivo_compl)
	values (	nr_seq_registro_w,
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nr_seq_controle_p,
		nr_linha_w,
		'F550',
		ds_arquivo_w,
		ds_arquivo_compl_w);
			
	end;

end loop;
close C01;
	
commit;

qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;	

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_f550_efd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;
