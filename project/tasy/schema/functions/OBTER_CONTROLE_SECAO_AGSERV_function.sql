-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_controle_secao_agserv (nr_seq_agenda_p bigint) RETURNS bigint AS $body$
DECLARE


nr_secao_w	bigint;
cd_procedimento_w	bigint;
cd_pessoa_fisica_w	varchar(10);
qt_total_secao_w	smallint;
vl_retorno_w		bigint;
nm_paciente_w		varchar(80);


BEGIN

select	coalesce(max(nr_secao),0),
	max(cd_procedimento),
	max(cd_pessoa_fisica),
	max(qt_total_secao),
	max(nm_paciente)
into STRICT	nr_secao_w,
	cd_procedimento_w,
	cd_pessoa_fisica_w,
	qt_total_secao_w,
	nm_paciente_w
from	agenda_consulta
where	nr_sequencia = nr_seq_agenda_p;

if (nr_secao_w > 1) then
	select	coalesce(max(nr_controle_secao),0)
	into STRICT	vl_retorno_w
	from	agenda_consulta
	where	((cd_pessoa_fisica = cd_pessoa_fisica_w) or (nm_paciente = nm_paciente_w))
	and	((cd_procedimento  = cd_procedimento_w) or (coalesce(cd_procedimento_w::text, '') = ''));
elsif (nr_secao_w = 0) then
	select	coalesce(max(nr_controle_secao),0)+1
	into STRICT	vl_retorno_w
	from	agenda_consulta
	where	dt_agenda between clock_timestamp() - interval '5 days' and clock_timestamp() + interval '365 days';
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_controle_secao_agserv (nr_seq_agenda_p bigint) FROM PUBLIC;

