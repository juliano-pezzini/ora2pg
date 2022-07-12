-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS caixa_conta_contabil_atual ON caixa_conta_contabil CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_caixa_conta_contabil_atual() RETURNS trigger AS $BODY$
declare

ds_erro_w				varchar(2000);

ds_conta_contabil_w		varchar(40);

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
ds_conta_contabil_w		:= substr(wheb_mensagem_pck.get_texto(354087,''),1,40);

CALL ctb_consistir_conta_titulo(NEW.cd_conta_contabil, ds_conta_contabil_w);

ds_erro_w := con_consiste_vigencia_conta(NEW.cd_conta_contabil, NEW.dt_inicio_vigencia, NEW.dt_fim_vigencia, ds_erro_w);
if (ds_erro_w is not null) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(ds_erro_w);
end if;
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_caixa_conta_contabil_atual() FROM PUBLIC;

CREATE TRIGGER caixa_conta_contabil_atual
	BEFORE INSERT OR UPDATE ON caixa_conta_contabil FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_caixa_conta_contabil_atual();
