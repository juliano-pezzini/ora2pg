-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_servico_agend_hc ( dt_agenda_p timestamp, cd_pessoa_fisica_p text, nr_seq_servico_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1);


BEGIN

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_retorno_w
from	agenda_home_care a,
	agenda_hc_paciente b,
	hc_servico c
where	b.nr_seq_agenda = a.nr_sequencia
and	a.nr_seq_servico = c.nr_sequencia
and	b.cd_pessoa_fisica = cd_pessoa_fisica_p
and	b.dt_agenda = dt_agenda_p
and     c.nr_sequencia = nr_seq_servico_p;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_servico_agend_hc ( dt_agenda_p timestamp, cd_pessoa_fisica_p text, nr_seq_servico_p bigint) FROM PUBLIC;

