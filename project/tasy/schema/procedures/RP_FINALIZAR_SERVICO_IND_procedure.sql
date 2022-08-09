-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rp_finalizar_servico_ind (nr_seq_servico_p text, nr_seq_motivo_p text, nm_usuario_p text, dt_fim_tratamento_p timestamp) AS $body$
DECLARE


nr_seq_hora_w		agenda_consulta.nr_seq_hora%type;
nr_seq_agenda_w		agenda_consulta.nr_sequencia%type;
cd_agenda_w		agenda_consulta.cd_agenda%type;
dt_agenda_w		agenda_consulta.dt_agenda%type;
qt_registros_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	agenda_consulta
	where	nr_seq_rp_item_ind 	= nr_seq_servico_p
	and	ie_status_agenda not in ('C','B','E','F', 'I', 'S', 'AD');



BEGIN

update	rp_pac_agend_individual
set	nr_seq_motivo_fim_tratamento 	= nr_seq_motivo_p,
	dt_fim_tratamento 		= dt_fim_tratamento_p,
	nm_usuario 			= nm_usuario_p,
	dt_atualizacao			= clock_timestamp()
where	nr_sequencia     		= nr_seq_servico_p;

open C01;
loop
fetch C01 into
	nr_seq_agenda_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	nr_seq_hora_w	:=  null;

	select	count(*)
	into STRICT	qt_registros_w
	from	agenda_consulta a
	where	a.nr_sequencia	= nr_seq_agenda_w
	and	exists (SELECT	1
			from	agenda_consulta b
			where	a.nr_sequencia <> b.nr_sequencia
			and	a.cd_agenda	= b.cd_agenda
			and	a.dt_agenda	= b.dt_agenda
			and	a.nr_seq_hora	= b.nr_seq_hora
			and	b.ie_status_agenda = 'C');

	if (coalesce(qt_registros_w,0) > 0) then

		select	max(cd_agenda),
			max(dt_agenda)
		into STRICT	cd_agenda_w,
			dt_agenda_w
		from	agenda_consulta
		where	nr_sequencia	= nr_seq_agenda_w;

		select	coalesce(max(nr_seq_hora),0) + 1
		into STRICT	nr_seq_hora_w
		from	agenda_consulta
		where	cd_agenda	= cd_agenda_w
		and	dt_agenda	= dt_agenda_w;
	end if;

	update	agenda_consulta
	set	ie_status_agenda 	= 'C',
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p,
		nr_seq_hora		= coalesce(nr_seq_hora_w, nr_seq_hora)
	where	nr_sequencia		= nr_seq_agenda_w;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rp_finalizar_servico_ind (nr_seq_servico_p text, nr_seq_motivo_p text, nm_usuario_p text, dt_fim_tratamento_p timestamp) FROM PUBLIC;
