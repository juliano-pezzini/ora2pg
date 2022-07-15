-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE controlar_acesso_conc_serv (nr_seq_agenda_p bigint, cd_pessoa_fisica_p text, ds_erro_p INOUT text) AS $body$
DECLARE


qt_agenda_w 	bigint;
i		smallint;
cd_agenda_w	bigint;
dt_agenda_w	timestamp;


BEGIN
/* limpar retorno */

ds_erro_p := '';

/* acesso exclusivo à tabela */

--lock table agenda_consulta in exclusive mode;
select 	max(cd_agenda),
	max(dt_agenda)
into STRICT	cd_agenda_w,
	dt_agenda_w
from	agenda_consulta
where	nr_sequencia		= nr_seq_agenda_p;

select	1
into STRICT	i
from	agenda_consulta
where	cd_agenda = cd_agenda_w
and	trunc(dt_agenda) = trunc(dt_agenda_w)
for update;

begin
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	/* obter registros cadastrados */

	select	coalesce(count(*),0)
	into STRICT	qt_agenda_w
	from	agenda_consulta
	where	nr_sequencia	= nr_seq_agenda_p
	and	cd_pessoa_fisica	<> cd_pessoa_fisica_p
	and	(cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '');

	/* gravar registro caso horário livre */

	if (qt_agenda_w = 0) then
		update	agenda_consulta
		set	cd_pessoa_fisica	= cd_pessoa_fisica_p
		where	nr_sequencia	= nr_seq_agenda_p;
		commit;
	else
		ds_erro_p := wheb_mensagem_pck.get_texto(281497,null);
	end if;
end if;
exception
	when others then
	commit;
end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE controlar_acesso_conc_serv (nr_seq_agenda_p bigint, cd_pessoa_fisica_p text, ds_erro_p INOUT text) FROM PUBLIC;

