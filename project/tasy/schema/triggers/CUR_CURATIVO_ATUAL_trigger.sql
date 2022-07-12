-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cur_curativo_atual ON cur_curativo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cur_curativo_atual() RETURNS trigger AS $BODY$
BEGIN

NEW.qt_escore :=	NEW.ie_epitelizacao +
			NEW.ie_tecido_granulacao +
			NEW.ie_endurecimento +
			NEW.ie_edema_tecido +
			NEW.ie_cor_pele_redor +
			NEW.ie_qt_exsudato +
			NEW.ie_tipo_exsudato +
			NEW.ie_qt_tecido +
			NEW.ie_tipo_tecido +
			NEW.ie_deslocamento +
			NEW.ie_borda +
			NEW.ie_profundidade +
			NEW.ie_dor_redor +
			NEW.ie_grangrena +
			NEW.ie_maceracao +
			NEW.ie_tamanho;

if (coalesce(OLD.DT_CURATIVO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_CURATIVO) and (NEW.DT_CURATIVO is not null) then
	NEW.ds_utc		:= obter_data_utc(NEW.DT_CURATIVO, 'HV');
end if;

if (coalesce(OLD.DT_LIBERACAO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_LIBERACAO) and (NEW.DT_LIBERACAO is not null) then
	NEW.ds_utc_atualizacao	:= obter_data_utc(NEW.DT_LIBERACAO,'HV');
end if;


RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cur_curativo_atual() FROM PUBLIC;

CREATE TRIGGER cur_curativo_atual
	BEFORE INSERT OR UPDATE ON cur_curativo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cur_curativo_atual();
