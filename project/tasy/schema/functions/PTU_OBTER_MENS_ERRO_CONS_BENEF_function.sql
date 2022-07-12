-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_mens_erro_cons_benef ( nr_seq_execucao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w				varchar(255);
nr_seq_inconsist_w			bigint;


BEGIN

select	nr_seq_inconsistencia
into STRICT	nr_seq_inconsist_w
from	ptu_intercambio_consist
where	nr_seq_guia	= nr_seq_execucao_p;

select	max(ds_inconsistencia)
into STRICT	ds_retorno_w
from	ptu_inconsistencia
where	nr_sequencia	= nr_seq_inconsist_w;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_mens_erro_cons_benef ( nr_seq_execucao_p bigint) FROM PUBLIC;
