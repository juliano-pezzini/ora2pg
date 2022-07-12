-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_regra_alt_pf_ref_befinsup ON pls_regra_alt_pf_ref CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_regra_alt_pf_ref_befinsup() RETURNS trigger AS $BODY$
declare

qt_regra_w		bigint;
qt_acao_regra_w		bigint;
qt_ambos_regra_w	bigint;

pragma autonomous_transaction;

BEGIN

if (coalesce(wheb_usuario_pck.get_ie_executar_trigger, 'S') = 'S') then
	select	count(1)
	into STRICT	qt_regra_w
	from	pls_regra_alt_pf_ref
	where	cd_estabelecimento = NEW.cd_estabelecimento;

	if (qt_regra_w > 0) and (NEW.ie_acao = 'A') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1166184);
	end if;
	
	select	count(1)
	into STRICT	qt_ambos_regra_w
	from	pls_regra_alt_pf_ref
	where	cd_estabelecimento = NEW.cd_estabelecimento
	and	ie_acao = 'A';
	
	if (qt_ambos_regra_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1166185);
	end if;

	select	count(1)
	into STRICT	qt_acao_regra_w
	from	pls_regra_alt_pf_ref
	where	cd_estabelecimento = NEW.cd_estabelecimento
	and	ie_acao = NEW.ie_acao;

	if (qt_acao_regra_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1166186);
	end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_regra_alt_pf_ref_befinsup() FROM PUBLIC;

CREATE TRIGGER pls_regra_alt_pf_ref_befinsup
	BEFORE INSERT OR UPDATE ON pls_regra_alt_pf_ref FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_regra_alt_pf_ref_befinsup();
