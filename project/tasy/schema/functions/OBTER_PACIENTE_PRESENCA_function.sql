-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_paciente_presenca (nr_seq_curso_p bigint, nr_seq_modulo_p bigint, cd_pessoa_fisica_p bigint, nr_seq_evento_p bigint, dt_presenca_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);
ie_presente_w	varchar(1);


BEGIN

select	b.ie_presente
into STRICT	ie_presente_w
FROM tre_inscrito_presenca b, tre_inscrito a, tre_evento c
LEFT OUTER JOIN tre_curso d ON (c.nr_seq_curso = d.nr_sequencia)
LEFT OUTER JOIN tre_evento_modulo e ON (c.nr_sequencia = e.nr_seq_evento)
WHERE a.nr_sequencia	= b.nr_seq_inscrito and c.nr_sequencia	= a.nr_seq_evento   and ((d.nr_sequencia	= nr_seq_curso_p) or (nr_seq_curso_p = 0)) and ((c.nr_sequencia	= nr_seq_evento_p) or (nr_seq_evento_p = 0)) and ((e.nr_sequencia = nr_seq_modulo_p) or (nr_seq_modulo_p = 0)) and a.cd_pessoa_fisica	= cd_pessoa_fisica_p and to_char(b.dt_presenca, 'dd/mm/yyyy') = to_char(dt_presenca_p, 'dd/mm/yyyy');


if	ie_presente_w = 'S'	then
	ds_retorno_w := 'P';
elsif	ie_presente_w = 'N'	then
	ds_retorno_w := 'F';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_paciente_presenca (nr_seq_curso_p bigint, nr_seq_modulo_p bigint, cd_pessoa_fisica_p bigint, nr_seq_evento_p bigint, dt_presenca_p timestamp) FROM PUBLIC;
