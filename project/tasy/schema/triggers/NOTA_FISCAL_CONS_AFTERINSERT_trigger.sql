-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS nota_fiscal_cons_afterinsert ON nota_fiscal_consist CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_nota_fiscal_cons_afterinsert() RETURNS trigger AS $BODY$
declare

cd_funcao_ativa_w	funcao.cd_funcao%type;
cd_material_w		material.cd_material%type;

BEGIN

cd_funcao_ativa_w := obter_funcao_ativa;

cd_material_w	:= null;

if (cd_funcao_ativa_w = 146) then
	BEGIN

	if (NEW.nr_item_nf > 0) then

		select	coalesce(max(cd_material),0)
		into STRICT	cd_material_w
		from	nota_fiscal_item
		where	nr_sequencia = NEW.nr_seq_nota
		and	nr_item_nf = NEW.nr_item_nf;

		if (cd_material_w = 0) then
			cd_material_w := null;
		end if;
	end if;

	insert into w_nota_fiscal_consist(
		nr_sequencia,
		nr_seq_nota,
		ds_titulo,
		ds_log,
		dt_atualizacao,
		nm_usuario,
		nr_item_nf,
		cd_material)
	values ( nextval('w_nota_fiscal_consist_seq'),
		NEW.nr_seq_nota,
		substr(NEW.ds_consistencia,1,255),
		substr(NEW.ds_observacao,1,4000),
		LOCALTIMESTAMP,
		NEW.nm_usuario,
		NEW.nr_item_nf,
		cd_material_w);

	end;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_nota_fiscal_cons_afterinsert() FROM PUBLIC;

CREATE TRIGGER nota_fiscal_cons_afterinsert
	AFTER INSERT ON nota_fiscal_consist FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_nota_fiscal_cons_afterinsert();
