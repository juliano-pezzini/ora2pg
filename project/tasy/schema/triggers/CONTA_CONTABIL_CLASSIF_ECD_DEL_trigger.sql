-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS conta_contabil_classif_ecd_del ON conta_contabil_classif_ecd CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_conta_contabil_classif_ecd_del() RETURNS trigger AS $BODY$
declare
	PRAGMA AUTONOMOUS_TRANSACTION;
	-- local variables here

	cd_conta_ref_w        conta_contabil.cd_conta_contabil%type;

	c_conta_referencia CURSOR(cd_conta_ref_p  conta_contabil.cd_conta_contabil%type) FOR
	SELECT  a.cd_conta_contabil
	from  conta_contabil a
	where  a.cd_conta_referencia = cd_conta_ref_p
	order by 1;

BEGIN
open c_conta_referencia(OLD.cd_conta_Contabil);
loop
fetch c_conta_referencia into  cd_conta_ref_w;
EXIT WHEN NOT FOUND; /* apply on c_conta_referencia */
	BEGIN

	delete  FROM conta_contabil_classif_ecd
	where  cd_classif_ecd = OLD.cd_classif_ecd
	and  cd_conta_contabil = cd_conta_ref_w;

	end;
end loop;
close c_conta_referencia;

commit;

RETURN OLD;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_conta_contabil_classif_ecd_del() FROM PUBLIC;

CREATE TRIGGER conta_contabil_classif_ecd_del
	BEFORE DELETE ON conta_contabil_classif_ecd FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_conta_contabil_classif_ecd_del();
