-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_m350_efd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE

 
nr_seq_regra_efd_w		bigint;
nr_versao_efd_w			varchar(5);
tp_registro_w			varchar(4);
nr_linha_w			bigint 	:= qt_linha_p;
nr_seq_registro_w		bigint 	:= nr_sequencia_p;
ds_arquivo_w			varchar(4000);
ds_arquivo_compl_w		varchar(4000);
ds_linha_w			varchar(8000);
sep_w				varchar(1) 	:= ds_separador_p;
aliquota_folha_w		double precision;
vl_contribuicao_total_w		double precision;
vl_salario_familia_w		double precision := 0;
vl_aviso_previo_w		double precision := 0;
vl_fgts_direto_w		double precision := 0;
vl_total_folha_w		double precision := 0;
vl_total_exclusoes_w		double precision := 0;
vl_base_calculo_w		double precision := 0;
ie_base_calculo_w		varchar(1);

qt_registros_w			bigint;
cd_empresa_w			smallint;
nr_seq_data_w			bigint;
ie_empresa_w			varchar(1);


BEGIN 
 
select	cd_empresa 
into STRICT	cd_empresa_w 
from	estabelecimento 
where	cd_estabelecimento = cd_estabelecimento_p;
 
select	nr_seq_regra_efd 
into STRICT	nr_seq_regra_efd_w 
from	fis_efd_controle 
where	nr_sequencia = nr_seq_controle_p;
 
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
 
select	coalesce(ie_base_calculo,'S'), 
	coalesce(ie_empresa, 'S') 
into STRICT	ie_base_calculo_w, 
	ie_empresa_w 
from	fis_regra_efd_m 
where	nr_seq_regra_efd = nr_seq_regra_efd_w;
 
select	obter_pr_imposto(cd_tributo_folha) 
into STRICT	aliquota_folha_w 
from	fis_regra_efd 
where	nr_sequencia = nr_seq_regra_efd_w;
 
select	sum(CASE WHEN coalesce(c.ie_tipo_valor,'VC')='VM' THEN a.vl_movimento WHEN coalesce(c.ie_tipo_valor,'VC')='VC' THEN  a.vl_credito WHEN coalesce(c.ie_tipo_valor,'VC')='VD' THEN a.vl_debito END )	vl_pis 
into STRICT	vl_total_folha_w 
from 	ctb_balancete_v a, 
	fis_efd_conta_contabil c, 
	fis_efd_regra_tipo_ct r 
where 	a.cd_conta_contabil = c.cd_conta_contabil 
and	r.nr_sequencia = c.nr_seq_tipo_ct 
and	r.ie_tipo_ct = 'FP' 
and	a.nr_seq_mes_ref = nr_seq_data_w 
--se não for por empresa, é por estabelecimento 
and	( ((ie_empresa_w = 'N') and (a.cd_estabelecimento = cd_estabelecimento_p) and (a.cd_estabelecimento = coalesce(c.cd_estabelecimento, cd_estabelecimento_p)) ) or (ie_empresa_w <> 'N') 
	) 
and	a.ie_normal_encerramento = 'N';
 
if (ie_base_calculo_w = 'S') then 
	vl_base_calculo_w := vl_total_folha_w;
else 
	vl_base_calculo_w := vl_total_folha_w/(aliquota_folha_w/100);
end if;
 
vl_contribuicao_total_w := ((vl_base_calculo_w * aliquota_folha_w)/100);
 
ds_linha_w	:= substr(	sep_w || 'M350'	 			|| 
				sep_w || vl_base_calculo_w		|| 
				sep_w || vl_total_exclusoes_w		|| 
				sep_w || vl_base_calculo_w		|| 
				sep_w || aliquota_folha_w	 	|| 
				sep_w || vl_contribuicao_total_w	|| sep_w,1,8000);
						 
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
				'M350', 
				ds_arquivo_w, 
				ds_arquivo_compl_w);
commit;
 
qt_linha_p := nr_linha_w;
nr_sequencia_p := nr_seq_registro_w;	
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_m350_efd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;
