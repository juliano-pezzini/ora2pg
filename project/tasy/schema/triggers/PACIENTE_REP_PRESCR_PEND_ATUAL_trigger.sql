-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS paciente_rep_prescr_pend_atual ON paciente_rep_prescricao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_paciente_rep_prescr_pend_atual() RETURNS trigger AS $BODY$
declare

qt_reg_w		smallint;
ie_tipo_w		varchar(10);
ie_liberar_hist_saude_w	varchar(10);

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

select	max(ie_liberar_hist_saude)
into STRICT	ie_liberar_hist_saude_w
from	parametro_medico
where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

if (TG_OP = 'INSERT' or TG_OP = 'UPDATE') and (coalesce(ie_liberar_hist_saude_w,'N') = 'S') and (NEW.dt_inativacao is null) then
	if (NEW.dt_liberacao is null) then
		ie_tipo_w := 'HRP';
	elsif (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null) then
		ie_tipo_w := 'XHRP';
	end if;
	if (ie_tipo_w	is not null) then

    CALL Gerar_registro_pendente_PEP(
      cd_tipo_registro_p => ie_tipo_w,
      nr_sequencia_registro_p => NEW.nr_sequencia,
      cd_pessoa_fisica_p => NEW.cd_pessoa_fisica,
      nm_usuario_p => NEW.nm_usuario,
      nr_atend_cons_pepa_p=> NEW.nr_seq_atend_cons_pepa
    );
	end if;
elsif (TG_OP = 'DELETE') or (TG_OP = 'UPDATE' and OLD.dt_inativacao is null and NEW.dt_inativacao is not null) then
	delete	FROM pep_item_pendente
	where	IE_TIPO_REGISTRO = 'HRP'
	and	nr_seq_registro = OLD.nr_sequencia;
end if;
	
<<Final>>
qt_reg_w	:= 0;
IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_paciente_rep_prescr_pend_atual() FROM PUBLIC;

CREATE TRIGGER paciente_rep_prescr_pend_atual
	AFTER INSERT OR UPDATE OR DELETE ON paciente_rep_prescricao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_paciente_rep_prescr_pend_atual();

