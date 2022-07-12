-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_membro_grupo_aud_insert ON pls_membro_grupo_aud CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_membro_grupo_aud_insert() RETURNS trigger AS $BODY$
declare
nm_auditor_w			varchar(255);
count_w				bigint;
nr_seq_grupo_w			bigint;

pragma autonomous_transaction;
BEGIN
nm_auditor_w	:= NEW.nm_usuario_exec;
nr_seq_grupo_w	:= NEW.nr_seq_grupo;

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	if (NEW.nr_contrato is not null) then
		NEW.nr_seq_contrato := substr(pls_obter_seq_contrato(NEW.nr_contrato),1,255);
	else
		NEW.nr_seq_contrato := null;
	end if;

	if (TG_OP = 'INSERT' and NEW.ie_situacao = 'A') then
		select	count(1)
		into STRICT	count_w
		from	pls_membro_grupo_aud
		where	nm_usuario_exec	= nm_auditor_w
		and	nr_seq_grupo	= nr_seq_grupo_w
		and	ie_situacao	= 'A';

		if (count_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(218290);
		end if;
	end if;
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_membro_grupo_aud_insert() FROM PUBLIC;

CREATE TRIGGER pls_membro_grupo_aud_insert
	BEFORE INSERT OR UPDATE ON pls_membro_grupo_aud FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_membro_grupo_aud_insert();
