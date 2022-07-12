-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS comunic_interna_lida_insert ON comunic_interna_lida CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_comunic_interna_lida_insert() RETURNS trigger AS $BODY$
declare
nr_seq_ev_pac_dest_w		bigint;
nr_seq_ev_pac_w			bigint;
ie_alterar_status_lido_w		varchar(1);
qt_evento_pac_w			bigint;
qt_evento_pac_ci_lido_w		bigint;

BEGIN

--Obter_Param_Usuario(7032,7,obter_perfil_ativo,:new.nm_usuario,wheb_usuario_pck.get_cd_estabelecimento,ie_alterar_status_lido_w);
if (wheb_usuario_pck.get_ie_executar_trigger	= 'S') then

	select	coalesce(max(nr_seq_ev_pac_dest),0)
	into STRICT	nr_seq_ev_pac_dest_w
	from	comunic_interna
	where	nr_sequencia = NEW.nr_sequencia;

	if (nr_seq_ev_pac_dest_w > 0) then

		select	max(nr_seq_ev_pac)
		into STRICT	nr_seq_ev_pac_w
		from	ev_evento_pac_destino
		where 	nr_sequencia = nr_seq_ev_pac_dest_w;

		update	ev_evento_pac_destino
		set	ie_status 	= 'L',
			nm_usuario	= NEW.nm_usuario,
			dt_atualizacao	= LOCALTIMESTAMP
		where	nr_sequencia	= nr_seq_ev_pac_dest_w;

		select 	count(*)
		into STRICT	qt_evento_pac_w
		from	ev_evento_pac_destino
		where	nr_seq_ev_pac = nr_seq_ev_pac_w;

		select 	count(*)
		into STRICT	qt_evento_pac_ci_lido_w
		from	ev_evento_pac_destino
		where	nr_seq_ev_pac = nr_seq_ev_pac_w
		and	ie_status = 'L'
		and	ie_forma_ev = 3;

		if (qt_evento_pac_w = qt_evento_pac_ci_lido_w) then
			update 	ev_evento_paciente
			set	ie_status = 'L'
			where	nr_sequencia = nr_seq_ev_pac_w;
		end if;
	end if;

end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_comunic_interna_lida_insert() FROM PUBLIC;

CREATE TRIGGER comunic_interna_lida_insert
	AFTER INSERT ON comunic_interna_lida FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_comunic_interna_lida_insert();
