-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_update_sus_rubrica ( CD_RUBRICA_P text, DS_RUBRICA_P text, DT_COMPETENCIA_P text, NM_USUARIO_P usuario.nm_usuario%type) AS $body$
DECLARE


dt_competencia_w	timestamp;
nr_sequencia_w		sus_rubrica.nr_sequencia%type;


BEGIN

	dt_competencia_w	:= 	to_date(dt_competencia_p, 'yyyymm');

	begin
		select	nr_sequencia
		into STRICT	nr_sequencia_w
		from	sus_rubrica
		where	cd_rubrica = cd_rubrica_p  LIMIT 1;
		exception
			when others then
				nr_sequencia_w := 0;
	end;

	if (coalesce(nr_sequencia_w, 0) > 0) then

		begin
			update	sus_rubrica
			set     DS_RUBRICA		=	ds_rubrica_p,
				DT_ATUALIZACAO		=	clock_timestamp(),
				DT_COMPETENCIA	=	dt_competencia_w,
				NM_USUARIO		=	nm_usuario_p
			where	nr_sequencia		=	nr_sequencia_w;
		end;

	else
		begin

		select	nextval('sus_rubrica_seq')
		into STRICT	nr_sequencia_w
		;

			insert into sus_rubrica(	CD_RUBRICA,
							DS_RUBRICA,
							DT_ATUALIZACAO,
							DT_ATUALIZACAO_NREC,
							DT_COMPETENCIA,
							NM_USUARIO,
							NM_USUARIO_NREC,
							NR_SEQUENCIA)
			values (		cd_rubrica_p,
					ds_rubrica_p,
					clock_timestamp(),
					clock_timestamp(),
					dt_competencia_w,
					nm_usuario_p,
					nm_usuario_p,
					nr_sequencia_w);





		end;
	end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_update_sus_rubrica ( CD_RUBRICA_P text, DS_RUBRICA_P text, DT_COMPETENCIA_P text, NM_USUARIO_P usuario.nm_usuario%type) FROM PUBLIC;

