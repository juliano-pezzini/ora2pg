-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_pac_pedido_kit_delete ON agenda_pac_pedido_kit CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_pac_pedido_kit_delete() RETURNS trigger AS $BODY$
declare
ds_alteracao_w		varchar(4000);
nr_seq_agenda_w		agenda_pac_pedido.nr_seq_agenda%type;
BEGIN
  BEGIN

	if (wheb_usuario_pck.get_ie_executar_trigger	= 'S')  then

		BEGIN
		select	coalesce(max(nr_seq_agenda),0)
		into STRICT	nr_seq_agenda_w
		from	agenda_pac_pedido
		where	nr_sequencia = OLD.nr_seq_pedido;
		exception
		when no_data_found then
			nr_seq_agenda_w	:= 0;
		when others then
			nr_seq_agenda_w	:= 0;
		end;

		ds_alteracao_w	:=	substr(obter_desc_expressao(500808)||' '||obter_descricao_padrao('KIT_MATERIAL','DS_KIT_MATERIAL',OLD.cd_kit_material),1,4000);

		if (ds_alteracao_w is not null) and (nr_seq_agenda_w > 0) then
			CALL gravar_historico_montagem(nr_seq_agenda_w,'EK',ds_alteracao_w,OLD.nm_usuario);
		end if;	

	end if;

  END;
RETURN OLD;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_pac_pedido_kit_delete() FROM PUBLIC;

CREATE TRIGGER agenda_pac_pedido_kit_delete
	BEFORE DELETE ON agenda_pac_pedido_kit FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_pac_pedido_kit_delete();
