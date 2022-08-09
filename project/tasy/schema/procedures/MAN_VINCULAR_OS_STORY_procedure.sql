-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_vincular_os_story ( nr_story_p bigint, nr_sprint_p bigint, nr_ordem_servico_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


nr_ordem_servico_w	desenv_story_sprint.nr_ordem_servico%type;
qt_existe_w		bigint;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	man_ordem_servico
where	nr_sequencia = nr_ordem_servico_p;

if (qt_existe_w = 0) then
	ds_erro_p := wheb_mensagem_pck.get_texto(338584);
	return;
end if;

select	max(nr_ordem_servico)
into STRICT	nr_ordem_servico_w
from	desenv_story_sprint
where	nr_story = nr_story_p
and	nr_sprint = nr_sprint_p;

if (nr_ordem_servico_w IS NOT NULL AND nr_ordem_servico_w::text <> '') then
	ds_erro_p := wheb_mensagem_pck.get_texto(338531);
	return;
end if;

update  desenv_story_sprint
set     nr_ordem_servico = nr_ordem_servico_p
where   coalesce(nr_sprint,0) = coalesce(nr_sprint_p,0)
and     nr_story = nr_story_p;
if (NOT FOUND) then
	insert into desenv_story_sprint(
		cd_status,
		dt_atualizacao,
		dt_atualizacao_nrec,
		nm_usuario,
		nm_usuario_nrec,
		nr_ordem_servico,
		nr_sequencia,
		nr_sprint,
		nr_story)
	values (	0,
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		nm_usuario_p,
		nr_ordem_servico_p,
		nextval('desenv_story_sprint_seq'),
		nr_sprint_p,
		nr_story_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_vincular_os_story ( nr_story_p bigint, nr_sprint_p bigint, nr_ordem_servico_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
