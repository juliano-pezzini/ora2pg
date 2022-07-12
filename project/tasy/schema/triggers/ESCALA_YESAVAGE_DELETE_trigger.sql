-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_yesavage_delete ON escala_yesavage CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_yesavage_delete() RETURNS trigger AS $BODY$
declare

qt_reg_w		smallint;
ie_tipo_w		varchar(10);

pragma autonomous_transaction;

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

delete
from   	pep_item_pendente
where  	ie_tipo_pendencia = 'L'
and	   	ie_escala = '84'
and		nr_seq_escala  = OLD.nr_sequencia;

commit;

<<Final>>
qt_reg_w	:= 0;
RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_yesavage_delete() FROM PUBLIC;

CREATE TRIGGER escala_yesavage_delete
	AFTER DELETE ON escala_yesavage FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_yesavage_delete();

