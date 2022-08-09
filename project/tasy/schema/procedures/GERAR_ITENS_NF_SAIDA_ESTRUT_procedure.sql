-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_itens_nf_saida_estrut (nr_seq_nota_fiscal_p bigint, nr_atendimento_p bigint, nr_interno_conta_p bigint, nr_seq_protocolo_p bigint, ie_tipo_convenio_p bigint, cd_convenio_p bigint, nr_nota_fiscal_p text, nr_sequencia_nf_p bigint, cd_operacao_nf_p bigint, cd_serie_nf_p text, cd_cgc_p text, cd_moeda_p bigint, vl_cotacao_p bigint, cd_nat_oper_nf_p text, ie_conta_financ_nf_p text, ds_complemento_p text, cd_estab_nota_fiscal_p bigint, cd_cgc_emitente_p text, vl_proc_mat_acum_p INOUT bigint, vl_desc_acum_p INOUT bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
New way of generate the items of the invoice, by a rule that group the items similar to the
account structure of patient account
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
vl_proc_mat_acum_w			double precision;
vl_desc_acum_w				double precision;


BEGIN

/* First group the items by each structure */

CALL agrupar_itens_nf_pac_estrut(nr_seq_nota_fiscal_p,nr_interno_conta_p,nr_seq_protocolo_p,nm_usuario_p);

/* Generate one item for each structure */

SELECT * FROM gerar_item_nf_pac_estrut(nr_seq_nota_fiscal_p, nr_atendimento_p, nr_interno_conta_p, nr_seq_protocolo_p, ie_tipo_convenio_p, cd_convenio_p, nr_nota_fiscal_p, nr_sequencia_nf_p, cd_operacao_nf_p, cd_serie_nf_p, cd_cgc_p, cd_moeda_p, vl_cotacao_p, cd_nat_oper_nf_p, ie_conta_financ_nf_p, ds_complemento_p, cd_estab_nota_fiscal_p, cd_cgc_emitente_p, vl_proc_mat_acum_w, vl_desc_acum_w, nm_usuario_p) INTO STRICT vl_proc_mat_acum_w, vl_desc_acum_w;

/* Comm it only in first procedure */

vl_proc_mat_acum_p			:= vl_proc_mat_acum_w;
vl_desc_acum_p				:= vl_desc_acum_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_itens_nf_saida_estrut (nr_seq_nota_fiscal_p bigint, nr_atendimento_p bigint, nr_interno_conta_p bigint, nr_seq_protocolo_p bigint, ie_tipo_convenio_p bigint, cd_convenio_p bigint, nr_nota_fiscal_p text, nr_sequencia_nf_p bigint, cd_operacao_nf_p bigint, cd_serie_nf_p text, cd_cgc_p text, cd_moeda_p bigint, vl_cotacao_p bigint, cd_nat_oper_nf_p text, ie_conta_financ_nf_p text, ds_complemento_p text, cd_estab_nota_fiscal_p bigint, cd_cgc_emitente_p text, vl_proc_mat_acum_p INOUT bigint, vl_desc_acum_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;
