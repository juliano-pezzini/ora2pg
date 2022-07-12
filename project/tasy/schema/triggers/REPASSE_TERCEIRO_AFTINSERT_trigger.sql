-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS repasse_terceiro_aftinsert ON repasse_terceiro CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_repasse_terceiro_aftinsert() RETURNS trigger AS $BODY$
declare

c_tipo_repasse_regra_ger CURSOR(nr_seq_tipo_pc	tipo_repasse.nr_sequencia%type) FOR
	SELECT	a.cd_regra,
		a.ie_considerar_regra
	from	tipo_repasse b,
		tipo_repasse_regra_geracao a
	where	a.nr_seq_tipo_repasse	= b.nr_sequencia
	and	b.nr_sequencia = nr_seq_tipo_pc
	and	b.cd_regra is null
	
union	all

	PERFORM	a.cd_regra,
		'C' ie_considerar_regra
	from	tipo_repasse a
	where	a.nr_sequencia = nr_seq_tipo_pc
	and	a.cd_regra is not null;

cd_regra_w		integer;

BEGIN

if (NEW.nr_seq_tipo is not null) then

	for r_c_tipo_rep_regra_ger in c_tipo_repasse_regra_ger(NEW.nr_seq_tipo) loop
		if (r_c_tipo_rep_regra_ger.cd_regra is not null) then
			CALL atualiza_regra_ger_repasse(NEW.nr_repasse_terceiro, r_c_tipo_rep_regra_ger.cd_regra,NEW.nm_usuario, r_c_tipo_rep_regra_ger.ie_considerar_regra);
		end if;
	end loop;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_repasse_terceiro_aftinsert() FROM PUBLIC;

CREATE TRIGGER repasse_terceiro_aftinsert
	AFTER INSERT ON repasse_terceiro FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_repasse_terceiro_aftinsert();
