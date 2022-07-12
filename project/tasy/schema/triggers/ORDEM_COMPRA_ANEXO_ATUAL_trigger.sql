-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ordem_compra_anexo_atual ON ordem_compra_anexo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ordem_compra_anexo_atual() RETURNS trigger AS $BODY$
DECLARE

dt_aprovacao_w			ordem_compra.dt_aprovacao%type;
cd_estabelecimento_w		ordem_compra.cd_estabelecimento%type;
ie_altera_anexo_w		varchar(15);
ie_altera_anexo_oc_w		varchar(15);
dt_liberacao_w			ordem_compra.dt_liberacao%type;
ds_ambiente_w			v$session.program%type;

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then

	select	dt_aprovacao,
		cd_estabelecimento,
		dt_liberacao
	into STRICT	dt_aprovacao_w,
		cd_estabelecimento_w,
		dt_liberacao_w
	from	ordem_compra
	where	nr_ordem_compra = OLD.nr_ordem_compra;

	select (max(obter_valor_param_usuario(917, 231, obter_perfil_ativo, NEW.nm_usuario, cd_estabelecimento_w))),
		(max(obter_valor_param_usuario(917, 241, obter_perfil_ativo, NEW.nm_usuario, cd_estabelecimento_w)))
	into STRICT	ie_altera_anexo_w,
		ie_altera_anexo_oc_w
	;
	
	select	program
	into STRICT    ds_ambiente_w
	from    v$session
	where	audsid = (SELECT userenv('sessionid') );

	if (upper(ds_ambiente_w) <> 'TASY.EXE') and (dt_liberacao_w is not null) and (coalesce(ie_altera_anexo_oc_w,'N') = 'N') and
		((coalesce(OLD.DS_ARQUIVO, 'X') <> coalesce(NEW.DS_ARQUIVO, 'X')) or (coalesce(OLD.DS_TITULO, 'X') <> coalesce(NEW.DS_TITULO, 'X')) or (coalesce(OLD.DS_OBSERVACAO, 'X') <> coalesce(NEW.DS_OBSERVACAO, 'X'))) then

		CALL wheb_mensagem_pck.exibir_mensagem_abort(1175667);

	elsif (dt_aprovacao_w is not null) and (coalesce(ie_altera_anexo_w,'N') = 'N') and
		((coalesce(OLD.DS_ARQUIVO, 'X') <> coalesce(NEW.DS_ARQUIVO,'X')) or (coalesce(OLD.DS_TITULO,'X') <> coalesce(NEW.DS_TITULO,'X')) or (coalesce(OLD.DS_OBSERVACAO,'X') <> coalesce(NEW.DS_OBSERVACAO,'X'))) then

		CALL wheb_mensagem_pck.exibir_mensagem_abort(352022);
	end if;

end if;
RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ordem_compra_anexo_atual() FROM PUBLIC;

CREATE TRIGGER ordem_compra_anexo_atual
	BEFORE UPDATE ON ordem_compra_anexo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ordem_compra_anexo_atual();
