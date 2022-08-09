-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reenviar_int_auto_opme_job ( nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_atendimento_w	bigint;
nr_seq_agenda_w		bigint;
nr_sequencia_w		bigint;

c01 CURSOR FOR
	SELECT	nr_atendimento,
		nr_seq_agenda
	from	agenda_pac_int_opme_log a
	where	a.cd_evento_log = 0
	and	((SELECT count(*) from agenda_pac_int_opme_log x where ((x.nr_seq_agenda = a.nr_seq_agenda) or (x.nr_atendimento = a.nr_atendimento))) = 1)
	and	((a.nr_seq_agenda IS NOT NULL AND a.nr_seq_agenda::text <> '') or (a.nr_atendimento IS NOT NULL AND a.nr_atendimento::text <> ''))
	order by nr_seq_agenda;


BEGIN

open C01;
loop
fetch C01 into
	nr_atendimento_w,
	nr_seq_agenda_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (coalesce(nr_atendimento_w,0) > 0) or (coalesce(nr_seq_agenda_w,0) > 0) then

		if (coalesce(nr_atendimento_w,0) > 0) then
			CALL gravar_agend_integracao(58,'nr_atendimento=' || nr_atendimento_w || ';');
		end if;

		if (coalesce(nr_seq_agenda_w,0) > 0) then
			CALL gravar_agend_integracao(58,'nr_sequencia=' || nr_seq_agenda_w || ';');
		end if;

		select	nextval('agenda_pac_int_opme_log_seq')
		into STRICT	nr_sequencia_w
		;

		insert into agenda_pac_int_opme_log(
			nr_sequencia,		dt_atualizacao,
			nm_usuario,		dt_atualizacao_nrec,
			nm_usuario_nrec,	nr_seq_agenda,
			ds_descricao,		cd_evento_log,
			nr_atendimento)
		values (	nr_sequencia_w,		clock_timestamp(),
			nm_usuario_p,		clock_timestamp(),
			nm_usuario_p,		CASE WHEN coalesce(nr_atendimento_w,0)=0 THEN  nr_seq_agenda_w  ELSE null END  ,
			'',			'9',
			nr_atendimento_w);

	end if;

	end;
end loop;
close C01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reenviar_int_auto_opme_job ( nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
