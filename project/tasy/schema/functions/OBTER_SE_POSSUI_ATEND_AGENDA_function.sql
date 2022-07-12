-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_possui_atend_agenda (nr_seq_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


possui_atend_w		varchar(1) := 'N';


BEGIN

select	CASE WHEN coalesce(max(nr_atendimento)::text, '') = '' THEN  'N'  ELSE 'S' END
into STRICT	possui_atend_w
from	agenda_paciente
where	nr_sequencia = nr_seq_agenda_p;

return	possui_atend_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_possui_atend_agenda (nr_seq_agenda_p bigint) FROM PUBLIC;
