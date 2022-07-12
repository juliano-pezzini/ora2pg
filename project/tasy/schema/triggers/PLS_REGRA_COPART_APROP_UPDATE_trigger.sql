-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_regra_copart_aprop_update ON pls_regra_copartic_aprop CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_regra_copart_aprop_update() RETURNS trigger AS $BODY$
declare

BEGIN
if (NEW.nr_seq_centro_apropriacao <> OLD.nr_seq_centro_apropriacao)	then
	 CALL pls_gravar_log_alt_regra_aprop(NEW.nr_seq_regra, OLD.nr_seq_centro_apropriacao, NEW.nr_seq_centro_apropriacao, 'PLS_REGRA_COPARTIC_APROP', 'NR_SEQ_CENTRO_APROPRIACAO', NEW.nm_usuario);
end if;
if (NEW.ie_tipo_apropriacao <> OLD.ie_tipo_apropriacao)	then
	 CALL pls_gravar_log_alt_regra_aprop(NEW.nr_seq_regra, OLD.ie_tipo_apropriacao, NEW.ie_tipo_apropriacao, 'PLS_REGRA_COPARTIC_APROP', 'IE_TIPO_APROPRIACAO', NEW.nm_usuario);
end if;
if (NEW.vl_apropriacao <> OLD.vl_apropriacao)	then
	 CALL pls_gravar_log_alt_regra_aprop(NEW.nr_seq_regra, OLD.vl_apropriacao, NEW.vl_apropriacao, 'PLS_REGRA_COPARTIC_APROP', 'VL_APROPRIACAO', NEW.nm_usuario);
end if;
if (NEW.tx_apropriacao <> OLD.tx_apropriacao)	then
	 CALL pls_gravar_log_alt_regra_aprop(NEW.nr_seq_regra, OLD.tx_apropriacao, NEW.tx_apropriacao, 'PLS_REGRA_COPARTIC_APROP', 'TX_APROPRIACAO', NEW.nm_usuario);
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_regra_copart_aprop_update() FROM PUBLIC;

CREATE TRIGGER pls_regra_copart_aprop_update
	BEFORE UPDATE ON pls_regra_copartic_aprop FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_regra_copart_aprop_update();
