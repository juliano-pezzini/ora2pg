-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_tasy_update ON agenda_tasy CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_tasy_update() RETURNS trigger AS $BODY$
DECLARE

nr_seq_comunicacao_w	bigint;
nm_usuario_conv_w	varchar(15);
nm_usuario_destino_w	varchar(4000);
nr_seq_agenda_google_w	bigint;
ds_id_google_w		varchar(255);

expressao1_w	varchar(255) := obter_desc_expressao_idioma(773957, null, wheb_usuario_pck.get_nr_seq_idioma);--Cancelamento de Reunião
expressao2_w	varchar(255) := obter_desc_expressao_idioma(732872, null, wheb_usuario_pck.get_nr_seq_idioma);--do dia
c01 CURSOR FOR
	SELECT	nm_usuario_convidado
	from	agenda_tasy_convite
	where	nr_seq_agenda	= NEW.nr_sequencia;

BEGIN

if (NEW.ie_status = 'C') then
	BEGIN

	nm_usuario_destino_w	:= '';

	open	c01;
	loop
	fetch	c01 into
		nm_usuario_conv_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		BEGIN

		nm_usuario_destino_w	:= nm_usuario_destino_w ||
						nm_usuario_conv_w || ', ';

		end;
	end loop;
	close c01;

	if (length(nm_usuario_destino_w) > 0) then
		BEGIN

		select	nextval('comunic_interna_seq')
		into STRICT	nr_seq_comunicacao_w
		;

		insert	into comunic_interna(dt_comunicado,
			ds_titulo,
			ds_comunicado,
			nm_usuario,
			dt_atualizacao,
			ie_geral,
			nm_usuario_destino,
			cd_perfil,
			nr_sequencia,
			ie_gerencial,
			nr_seq_classif,
			ds_perfil_adicional,
			cd_setor_destino,
			cd_estab_destino,
			ds_setor_adicional,dt_liberacao)
		values (LOCALTIMESTAMP,
			expressao1_w || ' ' || NEW.ds_agenda,
			expressao1_w || ' ' || NEW.ds_agenda || ' ' ||expressao2_w|| ' ' || to_char(NEW.dt_agenda, 'dd/mm/yyyy hh24:mi:ss'),
			NEW.nm_usuario,
			LOCALTIMESTAMP,
			'N',
			nm_usuario_destino_w,
			null,
			nr_seq_comunicacao_w,
			'N', null, null, null, null, null,
			LOCALTIMESTAMP);

		end;
	end if;

	select	coalesce(max(nr_sequencia), 0),
		max(ds_id_google)
	into STRICT	nr_seq_agenda_google_w,
		ds_id_google_w
	from	agenda_google_cal_hist
	where	nr_seq_agenda = NEW.nr_sequencia;

	if (nr_seq_agenda_google_w > 0) then
		insert into agenda_google_cal_del(
			nr_sequencia,
			ds_id_google,
			nm_usuario_agenda,
			nr_seq_agenda,
			dt_atualizacao,
			nm_usuario
		) values (
			nextval('agenda_google_cal_del_seq'),
			ds_id_google_w,
			NEW.nm_usuario_agenda,
			NEW.nr_sequencia,
			LOCALTIMESTAMP,
			NEW.nm_usuario_agenda
		);
	end if;

	end;

end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_tasy_update() FROM PUBLIC;

CREATE TRIGGER agenda_tasy_update
	AFTER UPDATE ON agenda_tasy FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_tasy_update();

