-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE bsc_validar_estornar_acao ( nr_sequencia_p bigint, ie_operacao_p text, nm_usuario_p text) AS $body$
DECLARE


/* IE_OPERACAO_P
V - Validar - preenche a data
E - Estornar - limpa o DT_VALIDACAO_PE
*/
BEGIN

update	man_ordem_servico
set	dt_validacao_pe	= CASE WHEN ie_operacao_p='V' THEN clock_timestamp() WHEN ie_operacao_p='E' THEN null END
where	nr_sequencia	= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bsc_validar_estornar_acao ( nr_sequencia_p bigint, ie_operacao_p text, nm_usuario_p text) FROM PUBLIC;
