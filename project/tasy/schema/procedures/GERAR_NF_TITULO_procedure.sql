-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nf_titulo ( cd_estabelecimento_p bigint, cd_convenio_p INOUT bigint, nr_seq_protocolo_p INOUT bigint, nr_atendimento_p INOUT bigint, nr_interno_conta_p bigint, cd_pessoa_fisica_p INOUT text, cd_cgc_p INOUT text, dt_emissao_p timestamp, dt_base_vencimento_p timestamp, cd_serie_nf_p text, cd_nat_oper_nf_p text, cd_operacao_nf_p bigint, cd_condicao_pagamento_p bigint, qt_item_maximo_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_proced_acrescimo_p bigint, ie_origem_proc_acres_p bigint, ie_opcao_p INOUT text, nm_usuario_p text, ds_complemento_p text, nr_nota_fiscal_p bigint, ds_observacao_p text, ds_obs_desc_nf_p text, vl_desconto_nf_p bigint, vl_total_conta_p bigint, vl_conta_p bigint, tx_juros_p bigint, cd_tipo_taxa_juro_p bigint, tx_multa_p bigint, cd_tipo_taxa_multa_p bigint, tx_desc_antecip_p bigint, nr_documento_p bigint, nr_sequencia_doc_p bigint, ie_gera_nf_p text, ie_gera_titulo_p text, nr_sequencia_p INOUT bigint, nr_seq_classif_fiscal_p bigint, nr_seq_sit_trib_p bigint, nr_recibo_p text, cd_Setor_atendimento_p bigint, cd_uso_cfdi_p text default null, cd_tipo_relacao_p text default null, ie_tipo_cfdi_p text default null) AS $body$
DECLARE


ie_ok_w			bigint	:= 0;
ds_erro_w		varchar(255)	:= 'X';
nr_nota_fiscal_w		varchar(255);
nr_titulo_w		bigint;
ie_gerar_imposto_w		varchar(1);
cd_condicao_pagto_w	varchar(255);


BEGIN

if (ie_gera_nf_p = 'S') then
	SELECT * FROM Gerar_NF_Paciente(NR_INTERNO_CONTA_P, NR_ATENDIMENTO_P, CD_CONVENIO_P, NR_SEQ_PROTOCOLO_P, CD_ESTABELECIMENTO_P, DT_EMISSAO_P, DT_BASE_VENCIMENTO_P, CD_PESSOA_FISICA_P, CD_CGC_P, CD_SERIE_NF_P, CD_NAT_OPER_NF_P, CD_OPERACAO_NF_P, CD_CONDICAO_PAGAMENTO_P, QT_ITEM_MAXIMO_P, IE_ORIGEM_PROCED_P, CD_PROCEDIMENTO_P, CD_PROCED_ACRESCIMO_P, IE_ORIGEM_PROC_ACRES_P, IE_OPCAO_P, NM_USUARIO_P, NR_SEQUENCIA_P, DS_COMPLEMENTO_P, NR_NOTA_FISCAL_P, DS_OBSERVACAO_P, DS_OBS_DESC_NF_P, VL_DESCONTO_NF_P, 'N', nr_seq_classif_fiscal_p, nr_seq_sit_trib_p, nr_recibo_p, cd_Setor_atendimento_p, null, null, null, cd_uso_cfdi_p, cd_tipo_relacao_p, ie_tipo_cfdi_p) INTO STRICT NR_ATENDIMENTO_P, CD_CONVENIO_P, NR_SEQ_PROTOCOLO_P, CD_PESSOA_FISICA_P, CD_CGC_P, IE_OPCAO_P, NR_SEQUENCIA_P;

	if (coalesce(nr_seq_protocolo_p,0) <> 0) then
		select count(*)
		into STRICT ie_ok_w
		from nota_fiscal
		where nr_seq_protocolo = nr_seq_protocolo_p;
	elsif (coalesce(nr_interno_conta_p,0) <> 0) then
		select count(*)
		into STRICT ie_ok_w
		from nota_fiscal
		where nr_interno_conta = nr_interno_conta_p;
	end if;

	if (ie_ok_w = 0) then
		ds_erro_w := Wheb_mensagem_pck.get_Texto(307156); /*'Nota fiscal não gerada !';*/
	end if;
end if;

if (ie_gera_titulo_p = 'S') and (ds_erro_w = 'X') then
	if (coalesce(nr_seq_protocolo_p,0) <> 0) then
		cd_condicao_pagto_w := Gerar_Venc_titulo_Protocolo(nr_seq_protocolo_p, nm_usuario_p, 'N', cd_condicao_pagto_w, clock_timestamp(), cd_estabelecimento_p);
	end if;

	if (coalesce(nr_sequencia_p,0) <> 0) then
		select	nr_nota_fiscal
		into STRICT	nr_nota_fiscal_w
		from	nota_fiscal
		where	nr_sequencia = nr_sequencia_p;
	end if;

	nr_nota_fiscal_w := coalesce(nr_nota_fiscal_w, nr_nota_fiscal_p);

	CALL Gerar_Titulo(	cd_estabelecimento_p, cd_pessoa_fisica_p,
			cd_cgc_p, nr_atendimento_p,
			nr_interno_conta_p, nr_seq_protocolo_p,
			cd_condicao_pagamento_p, dt_base_vencimento_p,
			dt_emissao_p, vl_total_conta_p,
			vl_conta_p, tx_juros_p,
			cd_tipo_taxa_juro_p, tx_multa_p,
			cd_tipo_taxa_multa_p, tx_desc_antecip_p,
			nr_documento_p, nr_sequencia_doc_p,
			nr_nota_fiscal_w, cd_serie_nf_p,
			nm_usuario_p, 'N');
	if (coalesce(nr_seq_protocolo_p,0) <> 0) then
		select coalesce(max(nr_titulo),0)
		into STRICT nr_titulo_w
		from titulo_receber
		where nr_seq_protocolo = nr_seq_protocolo_p;
	elsif (coalesce(nr_interno_conta_p,0) <> 0) then
		select coalesce(max(nr_titulo),0)
		into STRICT nr_titulo_w
		from titulo_receber
		where nr_interno_conta = nr_interno_conta_p;
	end if;

	if (ie_ok_w = 0) and (ie_gera_nf_p = 'S') then		/*Anderson 16/03/2007 - Incluí o parametro pois consistia mesmo se não era obrigatorio gerar a NF*/
		ds_erro_w := Wheb_mensagem_pck.get_Texto(307158); /*'Título não gerado !';*/
	end if;
end if;

if (coalesce(nr_seq_protocolo_p,0) <> 0) and (ds_erro_w = 'X') then
	update protocolo_convenio
	set ie_status_protocolo = 2
	where nr_seq_protocolo = nr_seq_protocolo_p;
end if;

if (ds_erro_w = 'X') then
	commit;
else
	rollback;

	if (coalesce(nr_interno_conta_p,0) <> 0) then
		update conta_paciente
		set ie_status_acerto = 1
		where nr_interno_conta = nr_interno_conta_p;

		CALL Desfazer_Conta_Pac_Repasse(nr_interno_conta_p, 'T', nm_usuario_p);

		commit;
	end if;

	CALL wheb_mensagem_pck.exibir_mensagem_abort(265335,'DS_ERRO=' || ds_erro_w);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nf_titulo ( cd_estabelecimento_p bigint, cd_convenio_p INOUT bigint, nr_seq_protocolo_p INOUT bigint, nr_atendimento_p INOUT bigint, nr_interno_conta_p bigint, cd_pessoa_fisica_p INOUT text, cd_cgc_p INOUT text, dt_emissao_p timestamp, dt_base_vencimento_p timestamp, cd_serie_nf_p text, cd_nat_oper_nf_p text, cd_operacao_nf_p bigint, cd_condicao_pagamento_p bigint, qt_item_maximo_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_proced_acrescimo_p bigint, ie_origem_proc_acres_p bigint, ie_opcao_p INOUT text, nm_usuario_p text, ds_complemento_p text, nr_nota_fiscal_p bigint, ds_observacao_p text, ds_obs_desc_nf_p text, vl_desconto_nf_p bigint, vl_total_conta_p bigint, vl_conta_p bigint, tx_juros_p bigint, cd_tipo_taxa_juro_p bigint, tx_multa_p bigint, cd_tipo_taxa_multa_p bigint, tx_desc_antecip_p bigint, nr_documento_p bigint, nr_sequencia_doc_p bigint, ie_gera_nf_p text, ie_gera_titulo_p text, nr_sequencia_p INOUT bigint, nr_seq_classif_fiscal_p bigint, nr_seq_sit_trib_p bigint, nr_recibo_p text, cd_Setor_atendimento_p bigint, cd_uso_cfdi_p text default null, cd_tipo_relacao_p text default null, ie_tipo_cfdi_p text default null) FROM PUBLIC;

