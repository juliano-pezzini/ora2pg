-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE gerar_dados_302_pck.inserir_dataset ( nr_seq_lote_p bigint, ie_dataset_p text, nm_usuario_p text, nr_referencia_p bigint, nr_seq_dataset_p INOUT bigint) AS $body$
DECLARE


	nr_seq_dataset_w		d301_dataset_envio.nr_sequencia%type;
	nr_atendimento_w		atendimento_paciente.nr_atendimento%type	:= null;
	nr_interno_conta_w		conta_paciente.nr_interno_conta%type		:= null;
	nr_seq_nota_fiscal_w		nota_fiscal.nr_sequencia%type			:= null;
	nr_seq_atend_prev_alta_w	atend_previsao_alta.nr_sequencia%type		:= null;
	nr_seq_atend_alta_w		atendimento_alta.nr_sequencia%type		:= null;
	nr_seq_import_301_inka_w	i301_arquivo_inka.nr_sequencia%type		:= null;

	nr_seq_arquivo_w		d301_arquivo_envio.nr_sequencia%type;
	cd_convenio_w			convenio.cd_convenio%type	:= null;

	
BEGIN

		select	nextval('d301_dataset_envio_seq')
		into STRICT	nr_seq_dataset_w
		;

		/*
		if	(ie_dataset_p in ('AUFN','ENTL')) then
			nr_atendimento_w		:= nr_referencia_p;
		elsif	(ie_dataset_p in ('VERL','MBEG')) then
			nr_seq_atend_prev_alta_w	:= nr_referencia_p;
			nr_atendimento_w		:= obter_atendimento(nr_referencia_p,ie_dataset_p);
		elsif	(ie_dataset_p in ('ENTL')) then
			nr_seq_atend_alta_w		:= nr_referencia_p;
		elsif	(ie_dataset_p in ('ZGUT')) then
			nr_seq_nota_fiscal_w		:= nr_referencia_p;
		elsif	(ie_dataset_p in ('INKA')) then
			nr_seq_import_301_inka_w	:= nr_referencia_p;
		elsif	(ie_dataset_p in ('RECH','AMBO')) then
			nr_interno_conta_w		:= nr_referencia_p;
			nr_atendimento_w		:= obter_atendimento(nr_referencia_p,ie_dataset_p);
		end if;

		if	(nr_atendimento_w is not null) then
			cd_convenio_w	:= obter_convenio_atendimento(nr_atendimento_w);
		end if;*/
		nr_seq_arquivo_w := gerar_dados_302_pck.obter_seq_arquivo(nr_seq_lote_p, cd_convenio_w, nm_usuario_p, nr_seq_arquivo_w);

		insert into d302_dataset_envio(nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nr_seq_arquivo,
			ie_dataset,
			nr_ordem)
		values (nr_seq_dataset_w,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nr_seq_arquivo_w,
			ie_dataset_p,
			nextval('dataset_302_ordem_seq'));

		nr_seq_dataset_p	:= nr_seq_dataset_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dados_302_pck.inserir_dataset ( nr_seq_lote_p bigint, ie_dataset_p text, nm_usuario_p text, nr_referencia_p bigint, nr_seq_dataset_p INOUT bigint) FROM PUBLIC;