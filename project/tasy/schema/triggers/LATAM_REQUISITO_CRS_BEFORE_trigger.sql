-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS latam_requisito_crs_before ON latam_requisito_crs CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_latam_requisito_crs_before() RETURNS trigger AS $BODY$
DECLARE
qt_count_w latam_requisito_crs.nr_sequencia%type;

BEGIN
	qt_count_w := 0;
	if (wheb_usuario_pck.get_ie_executar_trigger <> 'N') then
		if (NEW.nr_seq_crs is not null and OLD.nr_seq_crs is null or (NEW.nr_seq_crs <> OLD.nr_seq_crs)) then
			select count(*)
			into STRICT qt_count_w
			from latam_requisito_crs
			where nr_seq_crs = NEW.nr_seq_crs
			and nr_seq_requisito = NEW.nr_seq_requisito;
			if (qt_count_w > 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(1204116);
			end if;
		end if;
	end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_latam_requisito_crs_before() FROM PUBLIC;

CREATE TRIGGER latam_requisito_crs_before
	BEFORE INSERT OR UPDATE ON latam_requisito_crs FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_latam_requisito_crs_before();
