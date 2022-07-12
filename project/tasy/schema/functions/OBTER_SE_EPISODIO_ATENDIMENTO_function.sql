-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_episodio_atendimento ( nr_episodio_filtro_p bigint, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_episodio_w	atendimento_paciente.nr_seq_episodio%type;
nr_episodio_w		episodio_paciente.nr_episodio%type;
ie_retorno_w		varchar(1);


BEGIN
begin
select	a.nr_seq_episodio,
	b.nr_episodio
into STRICT	nr_seq_episodio_w,
	nr_episodio_w
FROM atendimento_paciente a
LEFT OUTER JOIN episodio_paciente b ON (a.nr_seq_episodio = b.nr_sequencia)
WHERE a.nr_atendimento = nr_atendimento_p;

if (nr_episodio_filtro_p = nr_seq_episodio_w) then
	ie_retorno_w	:=	'S';
elsif (nr_episodio_filtro_p = nr_episodio_w) then
	ie_retorno_w	:=	'S';
else
	ie_retorno_w	:=	'N';
end if;
exception
when others then
	ie_retorno_w	:=	'N';
end;

return  ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_episodio_atendimento ( nr_episodio_filtro_p bigint, nr_atendimento_p bigint) FROM PUBLIC;
