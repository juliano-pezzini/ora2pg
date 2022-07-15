-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_inserir_ordem_acordo ( nr_seq_ordem_acordo_p bigint, nr_seq_ordem_servico_p bigint, cd_pessoa_inclusao_p text, ie_acordo_adic_p text, ie_tipo_acordo_p text, ie_status_acordo_p text, cd_pessoa_solic_p text, dt_entrega_desejada_p timestamp, dt_entrega_prev_p timestamp, ds_projeto_p text, ds_comentario_p text, ds_justificativa_p text, dt_inclusao_p timestamp, ie_tipo_solucao_p text, dt_posicionamento_p timestamp, dt_retorno_cli_p timestamp, nr_seq_projeto_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_acordo_w	bigint;


BEGIN

select	nextval('desenv_acordo_os_seq')
into STRICT	nr_acordo_w
;

if (nr_seq_ordem_acordo_p IS NOT NULL AND nr_seq_ordem_acordo_p::text <> '' AND nr_seq_ordem_servico_p IS NOT NULL AND nr_seq_ordem_servico_p::text <> '')	then
	insert	into	desenv_acordo_os(nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nr_seq_acordo,
		cd_pessoa_inclusao,
		ie_status_acordo,
		dt_retorno_cli,
		nr_seq_ordem_servico,
		ie_acordo_adic,
		ds_comentario,
		ds_projeto,
		ie_tipo_solucao,
		ie_tipo_acordo,
		dt_entrega_desejada,
		cd_pessoa_solic,
		nr_seq_projeto,
		dt_posicionamento,
		dt_entrega_prev,
		dt_inclusao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		ds_justificativa)
	values (nr_acordo_w,
		nm_usuario_p,
		clock_timestamp(),
		nr_seq_ordem_acordo_p,
		cd_pessoa_inclusao_p,
		ie_status_acordo_p,
		dt_retorno_cli_p,
		nr_seq_ordem_servico_p,
		ie_acordo_adic_p,
		ds_comentario_p,
		ds_projeto_p,
		ie_tipo_solucao_p,
		ie_tipo_acordo_p,
		dt_entrega_desejada_p,
		cd_pessoa_solic_p,
		nr_seq_projeto_p,
		dt_posicionamento_p,
		dt_entrega_prev_p,
		dt_inclusao_p,
		nm_usuario_p,
		clock_timestamp(),
		ds_justificativa_p);
end	if;
commit;


end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_inserir_ordem_acordo ( nr_seq_ordem_acordo_p bigint, nr_seq_ordem_servico_p bigint, cd_pessoa_inclusao_p text, ie_acordo_adic_p text, ie_tipo_acordo_p text, ie_status_acordo_p text, cd_pessoa_solic_p text, dt_entrega_desejada_p timestamp, dt_entrega_prev_p timestamp, ds_projeto_p text, ds_comentario_p text, ds_justificativa_p text, dt_inclusao_p timestamp, ie_tipo_solucao_p text, dt_posicionamento_p timestamp, dt_retorno_cli_p timestamp, nr_seq_projeto_p bigint, nm_usuario_p text) FROM PUBLIC;

