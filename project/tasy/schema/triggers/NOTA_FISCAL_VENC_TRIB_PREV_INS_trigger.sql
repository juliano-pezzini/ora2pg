-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS nota_fiscal_venc_trib_prev_ins ON nota_fiscal_venc_trib_prev CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_nota_fiscal_venc_trib_prev_ins() RETURNS trigger AS $BODY$
BEGIN

if (NEW.ie_origem is null) then
	NEW.ie_origem := 'N';
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_nota_fiscal_venc_trib_prev_ins() FROM PUBLIC;

CREATE TRIGGER nota_fiscal_venc_trib_prev_ins
	BEFORE INSERT ON nota_fiscal_venc_trib_prev FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_nota_fiscal_venc_trib_prev_ins();

