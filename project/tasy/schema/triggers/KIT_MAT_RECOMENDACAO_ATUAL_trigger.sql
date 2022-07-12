-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS kit_mat_recomendacao_atual ON kit_mat_recomendacao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_kit_mat_recomendacao_atual() RETURNS trigger AS $BODY$
declare

ie_kit_padrao_prot_w		kit_mat_recomendacao.ie_kit_padrao_prot%type;
ie_kit_padrao_prot_ant_w	bigint;

pragma autonomous_transaction;

BEGIN

ie_kit_padrao_prot_w := NEW.ie_kit_padrao_prot;

select	count(*)
into STRICT	ie_kit_padrao_prot_ant_w
from	kit_mat_recomendacao
where	cd_recomendacao = NEW.cd_recomendacao
and		ie_kit_padrao_prot = 'S';


if (ie_kit_padrao_prot_w = 'S') AND (ie_kit_padrao_prot_ant_w > 0) then

	CALL wheb_mensagem_pck.exibir_mensagem_abort(690624);

else
	if (ie_kit_padrao_prot_w = 'S') then
		update 	protocolo_medic_rec
		set 	cd_kit = NEW.cd_kit
		where 	cd_recomendacao = NEW.cd_recomendacao;
	end if;
end if;

if (ie_kit_padrao_prot_w = 'N') then
		update	protocolo_medic_rec
		set		cd_kit  = NULL
		where	cd_recomendacao = NEW.cd_recomendacao
		and		cd_kit = NEW.cd_kit;
	end if;

COMMIT;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_kit_mat_recomendacao_atual() FROM PUBLIC;

CREATE TRIGGER kit_mat_recomendacao_atual
	BEFORE INSERT OR UPDATE ON kit_mat_recomendacao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_kit_mat_recomendacao_atual();

