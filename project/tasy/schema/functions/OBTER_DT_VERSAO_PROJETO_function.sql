-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_versao_projeto (nr_seq_ordem_p bigint) RETURNS timestamp AS $body$
DECLARE



dt_versao_prev_w timestamp;


BEGIN

select	DT_VERSAO_PREV
into STRICT	dt_versao_prev_w
from	man_ordem_servico
where 	nr_sequencia = nr_seq_ordem_p;



return	dt_versao_prev_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_versao_projeto (nr_seq_ordem_p bigint) FROM PUBLIC;

