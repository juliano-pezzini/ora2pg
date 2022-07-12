-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_usuario_estagio_atual (nr_seq_pendencia_p bigint) RETURNS varchar AS $body$
DECLARE


nm_usuario_w	varchar(15);
nr_seq_hist_w	bigint;


BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_hist_w
from 	cta_pendencia_hist
where 	nr_seq_pend = nr_seq_pendencia_p;

if (nr_seq_hist_w > 0) then

	select 	nm_usuario_nrec
	into STRICT	nm_usuario_w
	from 	cta_pendencia_hist
	where 	nr_sequencia = nr_seq_hist_w;

else

	select 	nm_usuario_nrec
	into STRICT	nm_usuario_w
	from 	cta_pendencia
	where 	nr_sequencia = nr_seq_pendencia_p;

end if;

return	nm_usuario_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_usuario_estagio_atual (nr_seq_pendencia_p bigint) FROM PUBLIC;
