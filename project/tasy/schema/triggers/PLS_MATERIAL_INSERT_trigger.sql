-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_material_insert ON pls_material CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_material_insert() RETURNS trigger AS $BODY$
declare

qt_registros_w	integer := 0;

BEGIN

if (NEW.ds_material_sem_acento is null) or (NEW.ds_material <> OLD.ds_material ) then
	NEW.ds_material_sem_acento	:= upper(elimina_acentuacao(NEW.ds_material));
end if;

if (NEW.cd_material_ops is not null) and (OLD.cd_material_ops is null) then
	NEW.cd_material_ops_orig	:= NEW.cd_material_ops;
end if;


if (NEW.DT_EXCLUSAO is not null) then
	select	count(1)
	into STRICT	qt_registros_w
	from	pls_material_a900
	where	nr_seq_material		= NEW.nr_sequencia
	and (dt_fim_vigencia	is null
	or	dt_fim_vigencia		> NEW.dt_exclusao);

	if (qt_registros_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort('Existem registros A900 vinculados a este material que não possuem fim de vigência,' ||
						' ou estão com a data de fim de vigência superior a data de exclusão do material.' ||
						chr(13) || chr(10) || 'Necessário realizar revisão dos registros A900.');
	end if;
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_material_insert() FROM PUBLIC;

CREATE TRIGGER pls_material_insert
	BEFORE INSERT OR UPDATE ON pls_material FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_material_insert();

