-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_agenda_pac ( nr_seq_encaminhamento_p bigint, nr_seq_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);


BEGIN

select	coalesce(max('S'),'N')
into STRICT	ds_retorno_w
from	atend_encaminhamento a
where	a.nr_seq_agenda = nr_seq_agenda_p
and	a.nr_sequencia = nr_seq_encaminhamento_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_agenda_pac ( nr_seq_encaminhamento_p bigint, nr_seq_agenda_p bigint) FROM PUBLIC;
