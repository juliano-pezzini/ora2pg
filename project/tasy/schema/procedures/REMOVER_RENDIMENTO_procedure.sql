-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE remover_rendimento (NR_SEQ_RENDIMENTO_P bigint) AS $body$
BEGIN

delete	from BANCO_RENDIMENTO
where	nr_sequencia	= NR_SEQ_RENDIMENTO_P;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE remover_rendimento (NR_SEQ_RENDIMENTO_P bigint) FROM PUBLIC;

