-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rp_gravar_agendamento_ga_go (nr_seq_agenda_p text, nr_seq_pac_reab_p bigint, ie_tipo_grupo_p text, nm_usuario_p text) AS $body$
DECLARE


ie_existe_registro_w	varchar(1);


BEGIN

if (nr_seq_agenda_p <> 0) and (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (nr_seq_pac_reab_p IS NOT NULL AND nr_seq_pac_reab_p::text <> '') and (nr_seq_pac_reab_p <> 0) and (ie_tipo_grupo_p IS NOT NULL AND ie_tipo_grupo_p::text <> '') then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_existe_registro_w
	from	rp_agendamento_grupo
	where	nr_seq_agenda = nr_seq_agenda_p;

	if (ie_existe_registro_w = 'N') then
		insert into 	rp_agendamento_grupo(nr_sequencia,
				 dt_atualizacao,
				 nm_usuario,
				 dt_atualizacao_nrec,
				 nm_usuario_nrec,
				 nr_seq_pac_reab,
				 nr_seq_agenda,
				 ie_tipo_grupo)
		values (nextval('rp_agendamento_grupo_seq'),
				 clock_timestamp(),
				 nm_usuario_p,
				 clock_timestamp(),
				 nm_usuario_p,
				 nr_seq_pac_reab_p,
				 nr_seq_agenda_p,
				 ie_tipo_grupo_p);
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rp_gravar_agendamento_ga_go (nr_seq_agenda_p text, nr_seq_pac_reab_p bigint, ie_tipo_grupo_p text, nm_usuario_p text) FROM PUBLIC;

