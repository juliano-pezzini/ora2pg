-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE convidar_perfil_agenda_tasy (nr_seq_agenda_p bigint, cd_perfil_p bigint, nm_usuario_p text) AS $body$
DECLARE


nm_usuario_w	varchar(15);
qt_convite_w	bigint;

c01 CURSOR FOR
SELECT	b.nm_usuario
from	usuario a,
	usuario_perfil b
where	a.nm_usuario	= b.nm_usuario
and	a.ie_situacao	= 'A'
and	b.cd_perfil	= cd_perfil_p
group by
	b.nm_usuario
order by
	b.nm_usuario;


BEGIN
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (cd_perfil_p IS NOT NULL AND cd_perfil_p::text <> '') then
	open c01;
	loop
	fetch c01 into nm_usuario_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		/* validar usuário convidado */

		select	coalesce(count(*),0)
		into STRICT	qt_convite_w
		from	agenda_tasy_convite
		where	nr_seq_agenda		= nr_seq_agenda_p
		and	nm_usuario_convidado	= nm_usuario_w;

		if (qt_convite_w = 0) then
			insert into agenda_tasy_convite(	nr_sequencia,
								nr_seq_agenda,
								nm_usuario_convidado,
								dt_atualizacao,
								nm_usuario,
								ie_confirmado,
								ds_motivo_ausencia,
								dt_confirmacao
								)
							values (nextval('agenda_tasy_convite_seq'),
								nr_seq_agenda_p,
								nm_usuario_w,
								clock_timestamp(),
								nm_usuario_p,
								'N',
								null,
								null
								);
		end if;
		end;
	end loop;
	close c01;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE convidar_perfil_agenda_tasy (nr_seq_agenda_p bigint, cd_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;
