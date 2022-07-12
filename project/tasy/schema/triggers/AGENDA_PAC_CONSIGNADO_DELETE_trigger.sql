-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_pac_consignado_delete ON agenda_pac_consignado CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_pac_consignado_delete() RETURNS trigger AS $BODY$
declare
ds_alteracao_w		varchar(4000) := null;
BEGIN

if (coalesce(OLD.DS_MATERIAL,'XPTO') <> 'XPTO') then
	ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(800099)||':  '||
				wheb_mensagem_pck.get_texto(798501)||':  '|| OLD.DS_MATERIAL   ||'  '||
				wheb_mensagem_pck.get_texto(799261)||':  '||OLD.QT_QUANTIDADE ||'  '||
				wheb_mensagem_pck.get_texto(800101)||':  '||OLD.DS_FORNECEDOR ||'  '||
				wheb_mensagem_pck.get_texto(800103)||':  '||OLD.IE_PERMANENTE ||'  '||
				wheb_mensagem_pck.get_texto(800105)||':  '||OLD.ds_observacao,1,4000);
end if;

if (ds_alteracao_w is not null) then
	CALL gravar_hist_planeja_consig(OLD.nr_seq_agenda,'ES',ds_alteracao_w,OLD.nm_usuario);
end if;

RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_pac_consignado_delete() FROM PUBLIC;

CREATE TRIGGER agenda_pac_consignado_delete
	BEFORE DELETE ON agenda_pac_consignado FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_pac_consignado_delete();
