-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_incluir_acordo ( nr_sequencia_p bigint, nr_seq_classif_gestao_p bigint, dt_externa_acordo_p timestamp, dt_interna_acordo_p timestamp, nm_pessoa_acordo_p text, dt_fim_acordo_p timestamp, nm_usuario_p text, ie_opcao_p text) AS $body$
BEGIN

IF (ie_opcao_p = 'I') THEN

	update  man_ordem_servico
	set  	nr_seq_classif_gestao = nr_seq_classif_gestao_p,
		dt_externa_acordo = coalesce(dt_externa_acordo_p,dt_externa_acordo),
		dt_interna_acordo = coalesce(dt_interna_acordo_p,dt_interna_acordo),
		nm_pessoa_acordo = nm_pessoa_acordo_p,
		dt_fim_acordo = coalesce(dt_fim_acordo_p,dt_fim_acordo),
		nm_usuario = nm_usuario_p
	where  	nr_sequencia = nr_sequencia_p;
END IF;

IF (ie_opcao_p = 'E') THEN

	update  man_ordem_servico
	set  	nr_seq_classif_gestao  = NULL,
		dt_externa_acordo  = NULL,
		dt_interna_acordo  = NULL,
		nm_pessoa_acordo  = NULL,
		dt_fim_acordo  = NULL,
		nm_usuario = nm_usuario_p
	where  	nr_sequencia = nr_sequencia_p;

END IF;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_incluir_acordo ( nr_sequencia_p bigint, nr_seq_classif_gestao_p bigint, dt_externa_acordo_p timestamp, dt_interna_acordo_p timestamp, nm_pessoa_acordo_p text, dt_fim_acordo_p timestamp, nm_usuario_p text, ie_opcao_p text) FROM PUBLIC;
