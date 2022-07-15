-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_pre_fat_f100_efd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE

 
pr_imposto_cofins_w		double precision;
pr_imposto_pis_w		double precision;
aliquota_iss_w			double precision;
cd_tributo_pis_w		smallint;
cd_tributo_cofins_w		smallint;
cd_tributo_iss_w		smallint;
nr_seq_regra_efd_w		bigint;
nr_versao_efd_w			varchar(5);
tp_registro_w			varchar(4);
nr_linha_w			bigint := qt_linha_p;
nr_seq_registro_w		bigint := nr_sequencia_p;
ds_arquivo_w			varchar(4000);
ds_arquivo_compl_w		varchar(4000);
ds_linha_w			varchar(8000);
sep_w				varchar(1) := ds_separador_p;
nr_sequencia_w			bigint;
vl_material_incentivo_w		double precision;
vl_base_calculo_tributo_w	double precision;
vl_pis_w			double precision;
vl_cofins_w			double precision;
vl_iss_retido_w			double precision;
vl_pis_retido_w			double precision;
vl_cofins_retido_w		double precision;
ie_local_gerar_sped_w		varchar(1);
ie_consistir_cpf_cnpj_w		varchar(1);
dt_operacao_w			timestamp;
vl_glosa_w			double precision;
vl_monofasico_w			double precision;
vl_base_calculo_w		double precision;
qt_registros_w			bigint;
vl_pre_faturamento_w		double precision := 0;
vl_pre_faturamento_atu_w	double precision;
vl_pre_faturamento_ant_w	double precision := 0;
ds_convenio_w			varchar(255);
vl_faturamento_w		double precision := 0;
dt_fim_ant_w			timestamp;
dt_inicio_ant_w			timestamp;
dt_fim_atual_w			timestamp;
dt_inicio_atual_w		timestamp;

c01 CURSOR FOR 
		SELECT	distinct 'F100'								tp_registro, 
			'1'									ie_receita, 
			CASE WHEN c.ie_tipo_convenio=1 THEN a.cd_pessoa_fisica  ELSE c.cd_cgc END  cd_participante, 
			sum(f.vl_procedimento + f.vl_material) vl_pre_faturamento_at, 
			''									cd_item, 
			'01'									cd_cst_pis, 
			pr_imposto_pis_w							pr_aliquota_pis, 
			'01'									cd_cst_cofins, 
			pr_imposto_cofins_w							pr_aliquota_cofins, 
			''									cd_base_calculo, 
			''									ie_origem_credito, 
			''									cd_conta_contabil, 
			''									cd_centro_custos, 
			''									ds_documento 
		FROM convenio c, pre_faturamento f
LEFT OUTER JOIN conta_paciente p ON (f.nr_interno_conta = p.nr_interno_conta)
LEFT OUTER JOIN atendimento_paciente a ON (p.nr_atendimento = a.nr_atendimento)
WHERE f.cd_convenio = c.cd_convenio   and dt_referencia between dt_inicio_atual_w and dt_fim_atual_w and f.cd_estabelecimento = cd_estabelecimento_p group by	CASE WHEN c.ie_tipo_convenio=1 THEN a.cd_pessoa_fisica  ELSE c.cd_cgc END , 
					pr_imposto_pis_w, 
					pr_imposto_cofins_w 
		
union
 
		SELECT	distinct 'F100'								tp_registro, 
			'1'									ie_receita, 
			CASE WHEN c.ie_tipo_convenio=1 THEN a.cd_pessoa_fisica  ELSE c.cd_cgc END  cd_participante, 
			sum(f.vl_procedimento + f.vl_material) vl_pre_faturamento_at, 
			''									cd_item, 
			'01'									cd_cst_pis, 
			pr_imposto_pis_w							pr_aliquota_pis, 
			'01'									cd_cst_cofins, 
			pr_imposto_cofins_w							pr_aliquota_cofins, 
			''									cd_base_calculo, 
			''									ie_origem_credito, 
			''									cd_conta_contabil, 
			''									cd_centro_custos, 
			''									ds_documento 
		FROM convenio c, pre_faturamento f
LEFT OUTER JOIN conta_paciente p ON (f.nr_interno_conta = p.nr_interno_conta)
LEFT OUTER JOIN atendimento_paciente a ON (p.nr_atendimento = a.nr_atendimento)
WHERE f.cd_convenio = c.cd_convenio   and dt_referencia between dt_inicio_ant_w and dt_fim_ant_w and f.cd_estabelecimento = cd_estabelecimento_p group by	CASE WHEN c.ie_tipo_convenio=1 THEN a.cd_pessoa_fisica  ELSE c.cd_cgc END , 
					pr_imposto_pis_w, 
					pr_imposto_cofins_w;

vet01	C01%RowType;


BEGIN 
 
dt_inicio_atual_w	:= trunc(dt_inicio_p,'mm');
dt_fim_atual_w		:= fim_dia(last_day(dt_fim_p));
 
dt_inicio_ant_w		:= trunc(add_months(dt_inicio_p,-1),'mm');
dt_fim_ant_w		:= fim_dia(last_day(add_months(dt_fim_p,-1)));
 
select	nr_seq_regra_efd 
into STRICT	nr_seq_regra_efd_w 
from	fis_efd_controle 
where	nr_sequencia = nr_seq_controle_p;
 
select	cd_tributo_pis, 
	cd_tributo_cofins, 
	cd_tributo_iss 
into STRICT	cd_tributo_pis_w, 
	cd_tributo_cofins_w, 
	cd_tributo_iss_w 
from	fis_regra_efd 
where	nr_sequencia = nr_seq_regra_efd_w;
 
pr_imposto_pis_w 	:= obter_pr_imposto(cd_tributo_pis_w);
pr_imposto_cofins_w 	:= obter_pr_imposto(cd_tributo_cofins_w);
 
open C01;
loop 
fetch C01 into 
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
 
	select	count(*) 
	into STRICT	qt_registros_w 
	from	pessoa_fisica 
	where	cd_pessoa_fisica = vet01.cd_participante;
	 
	if (qt_registros_w > 0) then 
	 
		vl_faturamento_w := coalesce(vet01.vl_pre_faturamento_at,0);
		 
		select	sum(vl_material) 
		into STRICT	vl_monofasico_w 
		from	efd_monofasico 
		where	cd_pessoa_fisica = vet01.cd_participante;
		 
		vl_base_calculo_w := vl_faturamento_w - coalesce(vl_monofasico_w,0);
		 
	else 
		 
		select	max(x.dt_mesano_referencia) 
		into STRICT	dt_operacao_w 
		from 	conta_paciente_status_v x, 
				pessoa_juridica d, 
				convenio c 
		where 	c.cd_convenio = x.cd_convenio 
		and		c.cd_cgc = d.cd_cgc 
		and 	exists (SELECT 1  where x.cd_estab_conta = 2) 
		and		x.dt_mesano_referencia between dt_inicio_atual_w and dt_fim_atual_w 
		and		c.cd_cgc = vet01.cd_participante;
		 
		if (coalesce(dt_operacao_w::text, '') = '') then 
			dt_operacao_w := dt_fim_p;
			vl_faturamento_w := 0;
		else 
			select	sum(x.vl_total_receita)		vl_operacao 
			into STRICT	vl_faturamento_w 
			from 	conta_paciente_status_v x, 
					pessoa_juridica d, 
					convenio c 
			where 	c.cd_convenio = x.cd_convenio 
			and		c.cd_cgc = d.cd_cgc 
			and 	exists (SELECT 1  where x.cd_estab_conta = 2) 
			and 	x.dt_mesano_referencia between dt_inicio_atual_w and dt_fim_atual_w 
			and		c.cd_cgc = vet01.cd_participante;
		end if;
		 
		select	sum(coalesce(a.vl_procedimento,0) + coalesce(a.vl_material,0)) vl_total_receita 
		into STRICT	vl_pre_faturamento_ant_w 
		from	pre_faturamento a, 
				convenio c 
		where	a.cd_convenio = c.cd_convenio 
		and		dt_referencia between dt_inicio_ant_w and dt_fim_ant_w 
		and		a.cd_estabelecimento = cd_estabelecimento_p 
		and		c.cd_convenio in ( 	SELECT	d.cd_convenio 
										from	convenio d 
										where	d.cd_cgc = vet01.cd_participante);
 
		select	sum(coalesce(a.vl_procedimento,0) + coalesce(a.vl_material,0)) vl_total_receita 
		into STRICT	vl_pre_faturamento_atu_w 
		from	pre_faturamento a, 
				convenio c 
		where	a.cd_convenio = c.cd_convenio 
		and		dt_referencia between dt_inicio_atual_w and dt_fim_atual_w 
		and		a.cd_estabelecimento = cd_estabelecimento_p 
		and		c.cd_convenio in ( 	SELECT	d.cd_convenio 
										from	convenio d 
										where	d.cd_cgc = vet01.cd_participante);
		 
		vl_faturamento_w 			:= coalesce(vl_faturamento_w,0);
		vl_pre_faturamento_atu_w 	:= coalesce(vl_pre_faturamento_atu_w,0);
		vl_pre_faturamento_ant_w	:= coalesce(vl_pre_faturamento_ant_w,0);
		 
		vl_pre_faturamento_w := vl_pre_faturamento_atu_w - vl_pre_faturamento_ant_w;
 
		vl_base_calculo_w := vl_faturamento_w + vl_pre_faturamento_w;	
		 
		select	obter_nome_pf_pj('', vet01.cd_participante) into STRICT ds_convenio_w;
	 
	end if;
	 
	ds_linha_w	:= substr(	sep_w || vet01.tp_registro	 							|| 
					sep_w || vet01.ie_receita	 							|| 
					sep_w || vet01.cd_participante	 							|| 
					sep_w || vet01.cd_item	 								|| 
					sep_w || to_Char(dt_operacao_w,'ddmmyyyy')						|| 
					sep_w || replace(campo_mascara(vl_base_calculo_w,2),'.',',')	|| 
					sep_w || vet01.cd_cst_pis	 							|| 
					sep_w || replace(campo_mascara(vl_base_calculo_w,2),'.',',') 				|| 
					sep_w || replace(campo_mascara(pr_imposto_pis_w,2),'.',',')				|| 
					sep_w || replace(campo_mascara(vl_base_calculo_w * pr_imposto_pis_w/100,2),'.',',')	 	|| 
					sep_w || vet01.cd_cst_cofins	 							|| 
					sep_w || replace(campo_mascara(vl_base_calculo_w,2),'.',',') 				|| 
					sep_w || replace(campo_mascara(pr_imposto_cofins_w,2),'.',',')				|| 
					sep_w || replace(campo_mascara(vl_base_calculo_w * pr_imposto_cofins_w/100,2),'.',',')	|| 
					sep_w || vet01.cd_base_calculo								|| 
					sep_w || vet01.ie_origem_credito							|| 
					sep_w || vet01.ie_origem_credito							|| 
					sep_w || vet01.cd_centro_custos								|| 
					sep_w || vet01.ds_documento								|| sep_w,1,8000);
 
	ds_arquivo_w := substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w := substr(ds_linha_w,4001,4000);
	nr_seq_registro_w := nr_seq_registro_w + 1;
	nr_linha_w := nr_linha_w + 1;
 
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
			values ( 
					nr_seq_registro_w, 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nr_seq_controle_p, 
					nr_linha_w, 
					vet01.tp_registro, 
					ds_arquivo_w, 
					ds_arquivo_compl_w);
	 
	commit;
	 
	end;
end loop;
close C01;
 
qt_linha_p := nr_linha_w;
nr_sequencia_p := nr_seq_registro_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_pre_fat_f100_efd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

