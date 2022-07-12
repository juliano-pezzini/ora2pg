-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS item_req_material_insert ON item_requisicao_material CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_item_req_material_insert() RETURNS trigger AS $BODY$
declare
dt_aprovacao_w		timestamp;
nm_usuario_aprov_w	varchar(15);

BEGIN

select	dt_aprovacao,
	nm_usuario_aprov
into STRICT	dt_aprovacao_w,
	nm_usuario_aprov_w
from	requisicao_material
where	nr_requisicao = NEW.nr_requisicao;

if (dt_aprovacao_w is not null) and (NEW.dt_aprovacao is null) then
	BEGIN

	NEW.dt_aprovacao	:= dt_aprovacao_w;
	NEW.nm_usuario_aprov	:= nm_usuario_aprov_w;

	end;
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_item_req_material_insert() FROM PUBLIC;

CREATE TRIGGER item_req_material_insert
	BEFORE INSERT ON item_requisicao_material FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_item_req_material_insert();

