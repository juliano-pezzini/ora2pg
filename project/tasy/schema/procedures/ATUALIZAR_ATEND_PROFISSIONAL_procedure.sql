-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_atend_profissional ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_profissional_p text, nm_usuario_p text, nr_seq_nursing_team_p bigint default null) AS $body$
DECLARE


cd_pessoa_fisica_w		varchar(10);

c01 CURSOR FOR
SELECT	cd_pessoa_fisica
from	atend_profissional
where	nr_atendimento 		= nr_atendimento_p
and	ie_profissional		= ie_profissional_p
order by
	dt_inicio_vigencia;


BEGIN

if (ie_profissional_p	= 'TE') or (IS_COPY_BASE_LOCALE('es_MX') = 'S' and ie_profissional_p = '5') then
	CALL Atualizar_Enfermeiro_Resp(nr_atendimento_p,cd_pessoa_fisica_p,nm_usuario_p,null);
else


	open C01;
	loop
	fetch C01 into
		cd_pessoa_fisica_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	end loop;
	close c01;
		
	if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_atendimento_p > 0)  then
		--(trim(nr_atendimento_p) <> '')then
		
		if (coalesce(cd_pessoa_fisica_w::text, '') = '') or (cd_pessoa_fisica_p <> cd_pessoa_fisica_w) then
		
			
			insert	into atend_profissional(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_atendimento,
				cd_pessoa_fisica,
				ie_profissional,
				dt_inicio_vigencia,
				ds_observacao,
				nr_seq_nursing_team)
			values (nextval('atend_profissional_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_atendimento_p,
				cd_pessoa_fisica_p,
				ie_profissional_p,
				clock_timestamp(),
				null,
				nr_seq_nursing_team_p);	
		end if;

	end if;

end if;
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_atend_profissional ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_profissional_p text, nm_usuario_p text, nr_seq_nursing_team_p bigint default null) FROM PUBLIC;
