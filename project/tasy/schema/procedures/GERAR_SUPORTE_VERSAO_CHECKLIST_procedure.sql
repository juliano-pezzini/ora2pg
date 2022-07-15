-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_suporte_versao_checklist ( nm_usuario_p text, ds_clientes_aprovacao_p text, ie_envio_net_p text, ie_arquivo_correcao_p text, nr_seq_comunicado_p bigint, ds_observacao_net_p text) AS $body$
BEGIN

insert	into suporte_versao_checklist(nr_sequencia,
			 dt_atualizacao,
			 nm_usuario,
			 dt_atualizacao_nrec,
			 nm_usuario_nrec,
			 ds_clientes_aprovacao,
			 ie_envio_net,
			 ie_arquivo_correcao,
			 nr_seq_comunicado,
			 ds_observacao_net)
		values (nextval('suporte_versao_checklist_seq'),
			 clock_timestamp(),
			 nm_usuario_p,
			 clock_timestamp(),
			 nm_usuario_p,
			 ds_clientes_aprovacao_p,
			 ie_envio_net_p,
			 ie_arquivo_correcao_p,
			 nr_seq_comunicado_p,
			 ds_observacao_net_p);

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_suporte_versao_checklist ( nm_usuario_p text, ds_clientes_aprovacao_p text, ie_envio_net_p text, ie_arquivo_correcao_p text, nr_seq_comunicado_p bigint, ds_observacao_net_p text) FROM PUBLIC;

