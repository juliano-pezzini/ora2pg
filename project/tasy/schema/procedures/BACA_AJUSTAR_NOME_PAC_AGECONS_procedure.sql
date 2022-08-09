-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajustar_nome_pac_agecons () AS $body$
DECLARE


cd_agenda_w		bigint;
nr_seq_agenda_w	agenda_consulta.nr_sequencia%type;
dt_agenda_w		timestamp;
cd_pessoa_fisica_w	varchar(10);
nm_pac_cadastro_w	varchar(60);
nm_pac_agenda_w	varchar(80);
nr_seq_log_w		bigint;
qt_registro_w		bigint := 0;

/* obter agendas */

c01 CURSOR FOR
SELECT	cd_agenda,
	nr_sequencia,
	dt_agenda,
	cd_pessoa_fisica,
	substr(obter_nome_pf(cd_pessoa_fisica),1,60) nm_pac_cadastro,
	substr(nm_paciente,1,80) nm_pac_agenda
from	agenda_consulta
where	(cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '')
and	coalesce(nm_paciente::text, '') = ''
order by
	cd_agenda,
	dt_agenda;


BEGIN
/* gerar agendas */

open c01;
loop
fetch c01 into	cd_agenda_w,
			nr_seq_agenda_w,
			dt_agenda_w,
			cd_pessoa_fisica_w,
			nm_pac_cadastro_w,
			nm_pac_agenda_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	if (nm_pac_cadastro_w IS NOT NULL AND nm_pac_cadastro_w::text <> '') then
		/* atualizar agendas */

		update	agenda_consulta
		set	nm_paciente = nm_pac_cadastro_w
		where	nr_sequencia = nr_seq_agenda_w;

		/* gravar log */

		select	nextval('agenda_historico_acao_seq')
		into STRICT	nr_seq_log_w
		;

		insert into agenda_historico_acao(
							nr_sequencia,
							ie_agenda,
							cd_agenda,
							nr_seq_agenda,
							dt_agenda,
							ie_acao,
							dt_acao,
							ds_acao,
							ds_alteracao
							)
					values (
							nr_seq_log_w,
							obter_tipo_agenda(cd_agenda_w),
							cd_agenda_w,
							nr_seq_agenda_w,
							dt_agenda_w,
							'N',
							clock_timestamp(),
							'baca_ajustar_nome_pac_agecons',
							'atualizar nome paciente nulo conforme cadastro pessoa fisica'
							);

		if (qt_registro_w = 10000) then
			qt_registro_w := 0;
			commit;
		else
			qt_registro_w := qt_registro_w + 1;
		end if;
	end if;
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajustar_nome_pac_agecons () FROM PUBLIC;
