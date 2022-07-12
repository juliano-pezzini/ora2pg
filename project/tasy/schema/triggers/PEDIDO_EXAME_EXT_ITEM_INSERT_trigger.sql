-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pedido_exame_ext_item_insert ON pedido_exame_externo_item CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pedido_exame_ext_item_insert() RETURNS trigger AS $BODY$
DECLARE

total_w					bigint;
qt_max_exames_w 			bigint;

pragma autonomous_transaction;
BEGIN

qt_max_exames_w	:= Obter_Valor_Param_Usuario(281,587, Obter_perfil_Ativo, Wheb_Usuario_Pck.Get_nm_Usuario, 0);

select	count(*)
into STRICT	total_w
from	Pedido_Exame_Externo_Item
where 	nr_seq_pedido = NEW.nr_seq_pedido;

if (qt_max_exames_w > 0) and (total_w > (qt_max_exames_w-1)) then
	--Quantidade máxima de exames é de '||qt_max_exames_w||'. (Parâmetro[587]). #@#@');
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(262182, 'QT_EXAME='||to_char(qt_max_exames_w));
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pedido_exame_ext_item_insert() FROM PUBLIC;

CREATE TRIGGER pedido_exame_ext_item_insert
	BEFORE INSERT ON pedido_exame_externo_item FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pedido_exame_ext_item_insert();

