-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cpoe_gasoterapia_insert ON cpoe_gasoterapia CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cpoe_gasoterapia_insert() RETURNS trigger AS $BODY$
DECLARE

BEGIN

NEW.ds_stack	:= substr(dbms_utility.format_call_stack,1,2000);

if (NEW.cd_perfil_ativo is null)  then
	NEW.cd_perfil_ativo := obter_perfil_ativo;
end if;

if (coalesce(NEW.ie_retrogrado, 'N') = 'S') then
	NEW.dt_prox_geracao := coalesce(NEW.dt_inicio, LOCALTIMESTAMP);
end if;

if (NEW.nr_seq_cpoe_anterior is not null and NEW.dt_liberacao is null and NEW.cd_funcao_origem = 2314) then
	NEW.dt_liberacao_enf := null;
	NEW.dt_liberacao_farm := null;
	NEW.nm_usuario_lib_enf := null;
	NEW.nm_usuario_lib_farm := null;
	NEW.cd_farmac_lib := null;
end if;

if (NEW.nr_cirurgia is not null) and (NEW.ie_tipo_prescr_cirur is null) then
	NEW.ie_tipo_prescr_cirur := 2;
end if;

if (NEW.ie_duracao <> 'P') then
	NEW.dt_fim := null;
end if;

RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cpoe_gasoterapia_insert() FROM PUBLIC;

CREATE TRIGGER cpoe_gasoterapia_insert
	BEFORE INSERT ON cpoe_gasoterapia FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cpoe_gasoterapia_insert();

