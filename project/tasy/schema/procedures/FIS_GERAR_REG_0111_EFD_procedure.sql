-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_0111_efd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE

 
nr_seq_regra_efd_w		bigint;
nr_versao_efd_w			varchar(5);
tp_registro_w			varchar(4);
nr_linha_w			bigint	:= qt_linha_p;
nr_seq_registro_w		bigint	:= nr_sequencia_p;
ds_arquivo_w			varchar(4000);
ds_arquivo_compl_w		varchar(4000);
ds_linha_w			varchar(8000);
sep_w				varchar(1)	:= ds_separador_p;
nr_versao_w			integer;
ie_crit_apur_w			varchar(1);
vl_receita_total_w		double precision;
vl_notas_pis_retido_w		double precision;
vl_notas_sem_pis_retido_w	double precision;
vl_receita_n_cumulat_w		double precision;
ie_consistir_cpf_cnpj_w		varchar(1);
ie_nota_entrada_w		varchar(1);
ie_buscar_data_w		varchar(1);
ie_nota_cancelada_w		varchar(1);
cd_tributo_pis_w		smallint;
ie_somar_trib_sai_w		varchar(1);


BEGIN 
 
select	a.nr_versao_efd 
into STRICT	nr_versao_w 
from	fis_regra_efd a, 
	fis_efd_controle b 
where	a.nr_sequencia = b.NR_SEQ_REGRA_EFD 
and	b.nr_sequencia = nr_seq_controle_p;
 
select	ie_consistir_cpf_cnpj, 
	nr_seq_regra_efd 
into STRICT	ie_consistir_cpf_cnpj_w, 
	nr_seq_regra_efd_w 
from	fis_efd_controle 
where	nr_sequencia = nr_seq_controle_p;
 
select	coalesce(max(ie_nota_entrada),'N'), 
	coalesce(max(ie_buscar_data),'N'), 
	coalesce(max(ie_nota_cancelada),'N') 
into STRICT	ie_nota_entrada_w, 
	ie_buscar_data_w, 
	ie_nota_cancelada_w 
from	fis_regra_efd_a100 
where	nr_seq_regra_efd = nr_seq_regra_efd_w;
 
select	cd_tributo_pis 
into STRICT	cd_tributo_pis_w 
from	fis_regra_efd 
where	nr_sequencia = nr_seq_regra_efd_w;
 
select	coalesce(max(ie_somar_trib_sai),'N') 
into STRICT	ie_somar_trib_sai_w 
from	fis_regra_efd_a100 
where	nr_seq_regra_efd = nr_seq_regra_efd_w;
 
-- Buscar o valor total das notas com retenção do PIS 
select	sum(a.vl_total_nota) 
into STRICT	vl_notas_pis_retido_w 
FROM operacao_nota b, nota_fiscal a
LEFT OUTER JOIN lote_protocolo p ON (a.nr_seq_lote_prot = p.nr_sequencia)
LEFT OUTER JOIN conta_paciente x ON (a.nr_interno_conta = x.nr_interno_conta)
LEFT OUTER JOIN protocolo_convenio z ON (x.nr_seq_protocolo = z.nr_seq_protocolo)
WHERE a.cd_operacao_nf	= b.cd_operacao_nf and a.vl_total_nota > 0 and a.cd_estabelecimento	= cd_estabelecimento_p and ((b.ie_operacao_fiscal = 'S' AND ie_nota_entrada_w = 'N') 
or (ie_nota_entrada_w = 'S')) and ((a.dt_emissao between dt_inicio_p and fim_dia(dt_fim_p) and (ie_buscar_data_w = 'N')) 
or	((a.nr_seq_lote_prot IS NOT NULL AND a.nr_seq_lote_prot::text <> '') and (trunc(p.dt_mesano_referencia,'mm') = trunc(dt_inicio_p,'mm') and (ie_buscar_data_w = 'P'))) 
or	((x.nr_seq_protocolo IS NOT NULL AND x.nr_seq_protocolo::text <> '') and (trunc(z.dt_mesano_referencia,'mm') = trunc(dt_inicio_p,'mm') and (ie_buscar_data_w = 'P')))) and (b.ie_servico = 'S') and (a.dt_atualizacao_estoque IS NOT NULL AND a.dt_atualizacao_estoque::text <> '') and ((a.ie_situacao = 1 AND ie_nota_cancelada_w = 'N') 
or	((a.ie_situacao in (1, 3)) and (ie_nota_cancelada_w = 'S'))) and (((ie_consistir_cpf_cnpj_w = 'S') and (CASE WHEN a.cd_pessoa_fisica='' THEN obter_dados_pf_pj(null,a.cd_cgc,'C')  ELSE obter_dados_pf(a.cd_pessoa_fisica,'CPF') (END IS NOT NULL AND END::text <> ''))) 
or (ie_consistir_cpf_cnpj_w = 'N')) and exists (	SELECT 1 from nota_fiscal_trib c 
			where  a.nr_sequencia = c.nr_sequencia 
			and   c.cd_tributo = cd_tributo_pis_w 
			and	c.vl_tributo > 0);
		 
-- Buscar o total das notas sem retenção do PIS 
select	CASE WHEN ie_somar_trib_sai_w='S' THEN sum(a.vl_mercadoria-a.vl_descontos)  ELSE sum(a.vl_total_nota) END  
into STRICT	vl_notas_sem_pis_retido_w 
FROM operacao_nota b, nota_fiscal a
LEFT OUTER JOIN lote_protocolo p ON (a.nr_seq_lote_prot = p.nr_sequencia)
LEFT OUTER JOIN conta_paciente x ON (a.nr_interno_conta = x.nr_interno_conta)
LEFT OUTER JOIN protocolo_convenio z ON (x.nr_seq_protocolo = z.nr_seq_protocolo)
WHERE a.cd_operacao_nf	= b.cd_operacao_nf and a.vl_total_nota > 0 and a.cd_estabelecimento	= cd_estabelecimento_p and ((b.ie_operacao_fiscal = 'S' AND ie_nota_entrada_w = 'N') 
or (ie_nota_entrada_w = 'S')) and ((a.dt_emissao between dt_inicio_p and fim_dia(dt_fim_p) and (ie_buscar_data_w = 'N')) 
or	((a.nr_seq_lote_prot IS NOT NULL AND a.nr_seq_lote_prot::text <> '') and (trunc(p.dt_mesano_referencia,'mm') = trunc(dt_inicio_p,'mm') and (ie_buscar_data_w = 'P'))) 
or	((x.nr_seq_protocolo IS NOT NULL AND x.nr_seq_protocolo::text <> '') and (trunc(z.dt_mesano_referencia,'mm') = trunc(dt_inicio_p,'mm') and (ie_buscar_data_w = 'P')))) and (b.ie_servico = 'S') and (a.dt_atualizacao_estoque IS NOT NULL AND a.dt_atualizacao_estoque::text <> '') and ((a.ie_situacao = 1 AND ie_nota_cancelada_w = 'N') 
or	((a.ie_situacao in (1, 3)) and (ie_nota_cancelada_w = 'S'))) and (((ie_consistir_cpf_cnpj_w = 'S') and (CASE WHEN a.cd_pessoa_fisica='' THEN obter_dados_pf_pj(null,a.cd_cgc,'C')  ELSE obter_dados_pf(a.cd_pessoa_fisica,'CPF') (END IS NOT NULL AND END::text <> ''))) 
or (ie_consistir_cpf_cnpj_w = 'N')) and (not exists (	SELECT 1 from nota_fiscal_trib c 
			where  a.nr_sequencia = c.nr_sequencia 
			and   c.cd_tributo = cd_tributo_pis_w 
			and	c.vl_tributo > 0));
	 
-- Calcular a receita total (Total das notas com PIS retido + total das notas sem PIS retido) 
vl_receita_total_w := coalesce(vl_notas_pis_retido_w,0) + coalesce(vl_notas_sem_pis_retido_w,0);
 
select	coalesce(sum(a.vl_movimento),0) 
into STRICT	vl_receita_n_cumulat_w 
from	fis_efd_regra_tipo_ct c, 
	fis_efd_conta_contabil b, 
	ctb_balancete_v a 
where 	a.cd_conta_contabil = b.cd_conta_contabil 
and	c.nr_sequencia = b.nr_seq_tipo_ct 
and	trunc(a.dt_referencia,'mm') = trunc(dt_inicio_p,'mm') 
and	a.cd_estabelecimento = cd_estabelecimento_p 
and	a.cd_estabelecimento = coalesce(b.cd_estabelecimento,a.cd_estabelecimento) 
and	obter_empresa_estab(a.cd_estabelecimento) = coalesce(b.cd_empresa,cd_empresa_p) 
and	a.ie_normal_encerramento = 'N' 
and	coalesce(b.ie_regime_receita,'C') = 'N' 
and	c.ie_tipo_ct = 'F';
 
ds_linha_w	:= substr(	sep_w || '0111'			|| 
				sep_w || vl_receita_n_cumulat_w	|| 
				sep_w || vl_receita_n_cumulat_w	|| 
				sep_w || 0			|| 
				sep_w || vl_receita_total_w	|| 
				sep_w || vl_receita_total_w	|| sep_w,1,8000);
 
ds_arquivo_w		:= substr(ds_linha_w,1,4000);
ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
nr_seq_registro_w	:= nr_seq_registro_w + 1;
nr_linha_w		:= nr_linha_w + 1;
 
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
	'0111', 
	ds_arquivo_w, 
	ds_arquivo_compl_w);
 
commit;
 
qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_0111_efd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

