-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qt_obter_local_trat ( nr_seq_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(60);


BEGIN

select	max(coalesce(b.ds_abrev, b.ds_local))
into STRICT	ds_retorno_w
from	agenda_quimio a,
	qt_local b
where	a.nr_seq_local		= b.nr_sequencia
and	a.nr_seq_atendimento	= nr_seq_atendimento_p
and a.ie_status_agenda <> 'C';

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qt_obter_local_trat ( nr_seq_atendimento_p bigint) FROM PUBLIC;

