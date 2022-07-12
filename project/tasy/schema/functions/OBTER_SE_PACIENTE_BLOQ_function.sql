-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_paciente_bloq (nr_seq_curso_p bigint, nr_seq_modulo_p bigint, nr_seq_evento_p bigint, cd_pessoa_fisica_p bigint) RETURNS varchar AS $body$
DECLARE


qt_faltas_w		smallint;
qt_faltas_permitida_w	smallint;
ds_retorno_w		varchar(1);


BEGIN

select	count(*)
into STRICT	qt_faltas_w
FROM tre_inscrito_presenca b, tre_inscrito a, tre_evento c
LEFT OUTER JOIN tre_curso d ON (c.nr_seq_curso = d.nr_sequencia)
WHERE a.nr_sequencia	= b.nr_seq_inscrito and c.nr_sequencia	= a.nr_seq_evento  and ((d.nr_sequencia	= nr_seq_curso_p)  or (nr_seq_curso_p  = 0)) and ((c.nr_sequencia	= nr_seq_evento_p) or (nr_seq_evento_p = 0)) and a.cd_pessoa_fisica	= cd_pessoa_fisica_p and b.ie_presente = 'N';

select  max(f.qt_faltas_permitida)
into STRICT	qt_faltas_permitida_w
FROM tre_tipo f, tre_inscrito_presenca b, tre_inscrito a, tre_evento c
LEFT OUTER JOIN tre_curso d ON (c.nr_seq_curso = d.nr_sequencia)
WHERE a.nr_sequencia	= b.nr_seq_inscrito and c.nr_sequencia	= a.nr_seq_evento  and f.nr_sequencia	= d.nr_seq_tipo and ((d.nr_sequencia	= nr_seq_curso_p)  or (nr_seq_curso_p  = 0)) and ((c.nr_sequencia	= nr_seq_evento_p) or (nr_seq_evento_p = 0));

if (qt_faltas_w > qt_faltas_permitida_w)	then
	ds_retorno_w := 'S';
else	ds_retorno_w := 'N';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_paciente_bloq (nr_seq_curso_p bigint, nr_seq_modulo_p bigint, nr_seq_evento_p bigint, cd_pessoa_fisica_p bigint) FROM PUBLIC;
