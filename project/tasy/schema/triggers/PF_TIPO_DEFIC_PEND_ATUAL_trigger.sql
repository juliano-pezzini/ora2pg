-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pf_tipo_defic_pend_atual ON pf_tipo_deficiencia CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pf_tipo_defic_pend_atual() RETURNS trigger AS $BODY$
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

if (coalesce(ie_liberar_hist_saude_w,'N') = 'S') then
	if (NEW.dt_liberacao is null) then
		ie_tipo_w := 'HSD';
	elsif (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null) then
		ie_tipo_w := 'XHSD';
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
end if;
	
<<Final>>
qt_reg_w	:= 0;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pf_tipo_defic_pend_atual() FROM PUBLIC;

CREATE TRIGGER pf_tipo_defic_pend_atual
	AFTER INSERT OR UPDATE ON pf_tipo_deficiencia FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pf_tipo_defic_pend_atual();

