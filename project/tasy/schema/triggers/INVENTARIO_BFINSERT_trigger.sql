-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS inventario_bfinsert ON inventario_material CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_inventario_bfinsert() RETURNS trigger AS $BODY$
declare
nr_seq_inv_ciclico_w			inventario.nr_seq_inv_ciclico%type;
ie_novo_item_inv_ciclico_w		varchar(1) := coalesce(obter_valor_param_usuario(143, 386, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento),'N');
action_w				v$session.action%type;
BEGIN
  BEGIN
BEGIN
select	upper(action)
into STRICT	action_w
from	v$session
where	audsid = (SELECT userenv('sessionid') )
and	upper(action) = 'GERAR_INVENTARIO_CICLICO'  LIMIT 1;
exception
when others then
	action_w	:=	'X';
end;

if (action_w = 'X') then
	BEGIN
	BEGIN
	select	coalesce(nr_seq_inv_ciclico,0)
	into STRICT	nr_seq_inv_ciclico_w
	from	inventario
	where	nr_sequencia = NEW.nr_seq_inventario;
	exception
	when others then
		nr_seq_inv_ciclico_w	:=	0;
	end;

	if (nr_seq_inv_ciclico_w > 0) and (ie_novo_item_inv_ciclico_w = 'N') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(791240);
	end if;
	end;
end if;
  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_inventario_bfinsert() FROM PUBLIC;

CREATE TRIGGER inventario_bfinsert
	BEFORE INSERT ON inventario_material FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_inventario_bfinsert();
