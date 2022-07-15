-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_titulo_desp_viagem ( nr_sequencia_p bigint) AS $body$
BEGIN

update proj_desp_viagem_mes set nr_titulo  = NULL where nr_sequencia = nr_sequencia_p;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_titulo_desp_viagem ( nr_sequencia_p bigint) FROM PUBLIC;

