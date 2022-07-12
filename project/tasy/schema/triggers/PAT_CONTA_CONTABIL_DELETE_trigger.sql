-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pat_conta_contabil_delete ON pat_conta_contabil CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pat_conta_contabil_delete() RETURNS trigger AS $BODY$
declare

qt_registro_w		bigint;

BEGIN

select	count(*)
into STRICT	qt_registro_w
from	pat_bem
where	cd_conta_contabil	= OLD.cd_conta_contabil;

if (qt_registro_w > 0) then
	/*'Não é possível excluir esta regra, pois existem bens ' || chr(13) || chr(10) ||
					'vinculados a esta conta contábil!#@#@');*/
	CALL wheb_mensagem_pck.exibir_mensagem_abort(266503);
end if;
RETURN OLD;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pat_conta_contabil_delete() FROM PUBLIC;

CREATE TRIGGER pat_conta_contabil_delete
	BEFORE DELETE ON pat_conta_contabil FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pat_conta_contabil_delete();
