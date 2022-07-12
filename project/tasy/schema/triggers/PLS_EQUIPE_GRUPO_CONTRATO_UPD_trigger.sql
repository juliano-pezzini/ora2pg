-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_equipe_grupo_contrato_upd ON pls_equipe_grupo_contrato CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_equipe_grupo_contrato_upd() RETURNS trigger AS $BODY$
declare
nr_seq_grupo_w	pls_grupo_contrato.nr_sequencia%type;

BEGIN

if (NEW.ie_tipo_relacionamento is not null) then
	select	max(b.nr_sequencia)
	into STRICT	nr_seq_grupo_w
	from	pls_grupo_contrato_equipe a,
		pls_grupo_contrato b
	where	b.nr_sequencia	= a.nr_seq_grupo_contrato
	and	a.nr_seq_equipe	= NEW.nr_sequencia
	and	b.ie_tipo_relacionamento <> NEW.ie_tipo_relacionamento;

	if (nr_seq_grupo_w is not null) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(348193,'NR_SEQ_GRUPO='||nr_seq_grupo_w);
	end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_equipe_grupo_contrato_upd() FROM PUBLIC;

CREATE TRIGGER pls_equipe_grupo_contrato_upd
	BEFORE UPDATE ON pls_equipe_grupo_contrato FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_equipe_grupo_contrato_upd();

