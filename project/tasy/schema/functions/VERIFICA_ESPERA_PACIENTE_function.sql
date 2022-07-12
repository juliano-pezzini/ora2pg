-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verifica_espera_paciente ( cd_pessoa_fisica_p text, nr_seq_curso_p bigint) RETURNS varchar AS $body$
DECLARE


naLista_w		varchar(1);
nr_item_w		bigint;


BEGIN
naLista_w := '';
nr_item_w := 0;

-- Verificação de treinamento
select	count(*)
into STRICT	nr_item_w
from	tre_agenda a,
	tre_candidato b
where   a.nr_sequencia = nr_seq_curso_p
and	b.nr_seq_agenda = a.nr_sequencia
and	b.cd_pessoa_fisica = cd_pessoa_fisica_p;

if (nr_item_w > 0) then
	naLista_w := 'T';
end if;


nr_item_w := 0;

-- Verificação de evento
select	count(*)
into STRICT	nr_item_w
from	tre_evento a,
	tre_inscrito b
where	a.nr_seq_curso = nr_seq_curso_p
and	a.nr_sequencia = b.nr_seq_evento
and	b.cd_pessoa_fisica = cd_pessoa_fisica_p;

if (nr_item_w > 0) then
	naLista_w := 'E';
end if;

return	naLista_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verifica_espera_paciente ( cd_pessoa_fisica_p text, nr_seq_curso_p bigint) FROM PUBLIC;
