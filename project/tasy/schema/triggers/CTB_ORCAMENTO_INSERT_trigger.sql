-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ctb_orcamento_insert ON ctb_orcamento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ctb_orcamento_insert() RETURNS trigger AS $BODY$
declare

cd_empresa_w			smallint;
ds_conta_contabil_w		varchar(255);
ie_liberacao_w		varchar(1);
ie_conta_vigente_w		varchar(1);

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	select	obter_empresa_estab(NEW.cd_estabelecimento)
	into STRICT	cd_empresa_w
	;

	select	ds_conta_contabil
	into STRICT	ds_conta_contabil_w
	from	conta_contabil
	where	cd_conta_contabil = NEW.cd_conta_contabil;

	/*Consistir se o usuário pode utilizar a conta contabil */

	select	ctb_obter_se_conta_usuario(cd_empresa_w,NEW.cd_conta_contabil,NEW.nm_usuario)
	into STRICT	ie_liberacao_w
	;

	if (ie_liberacao_w = 'N') then
		/*'Usuário sem permissão para atualizar o orçamento desta conta contábil:' || chr(13) ||
						:new.cd_conta_contabil ||' - ' || ds_conta_contabil_w || chr(13) ||
						'Verifique o cadastro: Liberação do Orçamento por conta.'*/
		CALL wheb_mensagem_pck.exibir_mensagem_abort(237679,'CD_CONTA_CONTABIL_W='||NEW.cd_conta_contabil);
	end if;

	select	substr(obter_se_conta_vigente(NEW.cd_conta_contabil, dt_referencia),1,1)
	into STRICT	ie_conta_vigente_w
	from	ctb_mes_ref
	where	nr_sequencia = NEW.nr_seq_mes_ref;
	if (ie_conta_vigente_w = 'N') then
		/*'Esta conta contábil esta fora da data de vigência.' || chr(13) || chr(10) || ds_conta_contabil_w*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(237680,'CD_CONTA_CONTABIL_W='||NEW.cd_conta_contabil);
	end if;
end if;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ctb_orcamento_insert() FROM PUBLIC;

CREATE TRIGGER ctb_orcamento_insert
	BEFORE INSERT ON ctb_orcamento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ctb_orcamento_insert();

