-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_1700_efd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


aliquota_pis_w		double precision;
aliquota_cofins_w		double precision;
aliquota_iss_w		double precision;
cd_tributo_pis_w		smallint;
cd_tributo_cofins_w		smallint;
cd_tributo_iss_w		smallint;
nr_seq_regra_efd_w	bigint;
nr_linha_w		bigint := qt_linha_p;
nr_seq_registro_w		bigint := nr_sequencia_p;
ds_arquivo_w		varchar(4000);
ds_arquivo_compl_w	varchar(4000);
ds_linha_w		varchar(8000);
sep_w			varchar(1) := ds_separador_p;

c01 CURSOR FOR
	SELECT	'1700' tp_registro,
		'03' ie_natureza_ret,
		to_char(dt_inicio_p,'mmyyyy') dt_ref_retencao,
		coalesce(sum(i.vl_tributo),0) vl_retido,
		0 vl_deducao_ret,
		0 vl_restituido_ret,
		0 vl_compensacao_ret,
		coalesce(sum(i.vl_tributo),0) vl_saldo_ret
	from	nota_fiscal n,
		nota_fiscal_trib i,
		operacao_nota o,
		titulo_receber t
	where	n.nr_sequencia = t.nr_seq_nf_saida
	and	n.nr_sequencia = i.nr_sequencia
	and	n.cd_operacao_nf = o.cd_operacao_nf
	and	i.cd_tributo = cd_tributo_cofins_w
	and	trunc(t.dt_liquidacao,'mm') between trunc(dt_inicio_p,'mm') and trunc(dt_fim_p,'mm')
	and	o.ie_operacao_fiscal = 'S'
	and 	o.ie_servico = 'S'
	and	(n.dt_atualizacao_estoque IS NOT NULL AND n.dt_atualizacao_estoque::text <> '')
	and	n.vl_total_nota > 0
	and	n.cd_estabelecimento	= cd_estabelecimento_p;

vet01	c01%rowtype;


BEGIN

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

aliquota_pis_w 	:= obter_pr_imposto(cd_tributo_pis_w);
aliquota_cofins_w 	:= obter_pr_imposto(cd_tributo_cofins_w);
aliquota_iss_w 	:= obter_pr_imposto(cd_tributo_iss_w);

open c01;
loop
fetch c01 into
	vet01;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	ds_linha_w	:= substr(	sep_w || vet01.tp_registro	 		||
				sep_w || vet01.ie_natureza_ret 		||
				sep_w || vet01.dt_ref_retencao 		||
				sep_w || vet01.vl_retido	 		||
				sep_w || vet01.vl_deducao_ret		||
				sep_w || vet01.vl_restituido_ret		||
				sep_w || vet01.vl_compensacao_ret		||
				sep_w || vet01.vl_saldo_ret				|| sep_w,1,8000);

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
		values (	nr_seq_registro_w,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nr_seq_controle_p,
			nr_linha_w,
			vet01.tp_registro,
			ds_arquivo_w,
			ds_arquivo_compl_w);
		end;
	end loop;
	close c01;
commit;

qt_linha_p := nr_linha_w;
nr_sequencia_p := nr_seq_registro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_1700_efd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;
