-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dar_remover_operacao_display ( nr_sequencia_p bigint, ie_operacao_p text) AS $body$
BEGIN

	update query_builder_display set ie_operacao  = NULL where nr_sequencia = nr_sequencia_p;

	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dar_remover_operacao_display ( nr_sequencia_p bigint, ie_operacao_p text) FROM PUBLIC;
