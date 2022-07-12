-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_identificador_tabela (nm_tabela_p text,nr_seq_mer_p bigint) RETURNS bigint AS $body$
DECLARE

NR_IDENTIFICADOR_W bigint;

BEGIN
	SELECT 	NR_SEQUENCIA
	INTO STRICT	NR_IDENTIFICADOR_W
	FROM 	TASY_MER_TABELA
	WHERE 	NM_TABELA  = NM_TABELA_P
	AND	NR_SEQ_MER = NR_SEQ_MER_P;

	RETURN NR_IDENTIFICADOR_W;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_identificador_tabela (nm_tabela_p text,nr_seq_mer_p bigint) FROM PUBLIC;

