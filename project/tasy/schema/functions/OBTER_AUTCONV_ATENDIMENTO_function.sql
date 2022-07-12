-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_autconv_atendimento (nr_atendimento_p bigint, nr_seq_agenda_consulta_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1) := 'N';
qt_aut_convenio_w	integer;

BEGIN

select	count(*)
into STRICT	qt_aut_convenio_w
from	autorizacao_convenio c ,
		agenda_consulta a
where	c.nr_seq_agenda_consulta	=	a.nr_sequencia
and		a.nr_atendimento	=	nr_atendimento_p
and		c.nr_seq_agenda_consulta	=	nr_seq_agenda_consulta_p;

if (qt_aut_convenio_w > 0 ) then
		ds_retorno_w	:= 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_autconv_atendimento (nr_atendimento_p bigint, nr_seq_agenda_consulta_p bigint) FROM PUBLIC;
