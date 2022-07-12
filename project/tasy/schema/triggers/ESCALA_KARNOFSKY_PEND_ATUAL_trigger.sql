-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_karnofsky_pend_atual ON escala_karnofsky CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_karnofsky_pend_atual() RETURNS trigger AS $BODY$
declare

qt_reg_w		smallint;
ie_tipo_w		varchar(10);

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;


if (NEW.dt_liberacao is null) then
	ie_tipo_w := 'ESC';
elsif (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null) then
	ie_tipo_w := 'XESC';
end if;

if (ie_tipo_w	is not null) then
    CALL Gerar_registro_pendente_PEP( cd_tipo_registro_p => ie_tipo_w,
      nr_sequencia_registro_p => NEW.nr_sequencia,
      cd_pessoa_fisica_p => substr(obter_pessoa_atendimento(NEW.nr_atendimento,'C'),1,255),
      nr_atendimento_p => NEW.nr_atendimento,
      nm_usuario_p => NEW.nm_usuario,
      ie_escala_p => '40',
      nr_atend_cons_pepa_p => NEW.nr_seq_atend_cons_pepa);
end if;
	
<<Final>>
qt_reg_w	:= 0;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_karnofsky_pend_atual() FROM PUBLIC;

CREATE TRIGGER escala_karnofsky_pend_atual
	AFTER INSERT OR UPDATE ON escala_karnofsky FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_karnofsky_pend_atual();

