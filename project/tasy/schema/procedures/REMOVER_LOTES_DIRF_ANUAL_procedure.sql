-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE remover_lotes_dirf_anual ( nr_sequencia_p bigint) AS $body$
DECLARE


-- Esta rotina remove na tabela "DIRF_AGRUPAR_LOTE" os lotes mensais que foram selecionados
BEGIN

delete 	from dirf_agrupar_lote
where	nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE remover_lotes_dirf_anual ( nr_sequencia_p bigint) FROM PUBLIC;
