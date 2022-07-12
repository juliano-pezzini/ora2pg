-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS hd_prescricao_insert ON hd_prescricao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_hd_prescricao_insert() RETURNS trigger AS $BODY$
DECLARE

ie_existe_hd_prescr_w	varchar(1);

BEGIN

null;
/*select	obter_se_existe_hd_prescr(:new.nr_prescricao)
into	ie_existe_hd_prescr_w
from	dual;

if	(ie_existe_hd_prescr_w = 'S') then
	wheb_mensagem_pck.exibir_mensagem_abort(232680);
end if;*/
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_hd_prescricao_insert() FROM PUBLIC;

CREATE TRIGGER hd_prescricao_insert
	BEFORE INSERT ON hd_prescricao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_hd_prescricao_insert();

