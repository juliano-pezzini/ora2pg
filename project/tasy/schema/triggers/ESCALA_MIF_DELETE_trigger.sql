-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_mif_delete ON escala_mif CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_mif_delete() RETURNS trigger AS $BODY$
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
and	   	ie_escala = '70'
and		nr_seq_escala  = OLD.nr_sequencia;

commit;

<<Final>>
qt_reg_w	:= 0;
RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_mif_delete() FROM PUBLIC;

CREATE TRIGGER escala_mif_delete
	AFTER DELETE ON escala_mif FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_mif_delete();

