-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS segmento_compras_estrut_insert ON segmento_compras_estrut CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_segmento_compras_estrut_insert() RETURNS trigger AS $BODY$
declare

cd_estabelecimento_w	bigint;
qt_existe_w		bigint;

PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN

if (NEW.cd_material is not null) then
	BEGIN

	select	count(*)
	into STRICT	qt_existe_w
	from	segmento_compras b,
		segmento_compras_estrut a
	where	b.nr_sequencia		= a.nr_seq_segmento
	and	b.nr_sequencia		<> NEW.nr_seq_segmento
	and	a.cd_material		= NEW.cd_material
	and	b.cd_estabelecimento is null;

	if (qt_existe_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(215676,'CD_MATERIAL_P='||NEW.cd_material);
		/*r.aise_application_error(-20011,'Este material já existe em uma regra geral (para todos estabelecimentos).');*/

	end if;


	select	coalesce(max(cd_estabelecimento), 0)
	into STRICT	cd_estabelecimento_w
	from	segmento_compras
	where	nr_sequencia = NEW.nr_seq_segmento;


	select	count(*)
	into STRICT	qt_existe_w
	from	segmento_compras b,
		segmento_compras_estrut a
	where	b.nr_sequencia		= a.nr_seq_segmento
	and	b.nr_sequencia		<> NEW.nr_seq_segmento
	and	a.cd_material		= NEW.cd_material
	and	b.cd_estabelecimento	= cd_estabelecimento_w;

	if (qt_existe_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(215677,'CD_MATERIAL_P='||NEW.cd_material);
		/*r.aise_application_error(-20011,'Este material já existe nesta regra para este estabelecimento.');*/

	end if;

	select	count(*)
	into STRICT	qt_existe_w
	from	segmento_compras b,
		segmento_compras_estrut a
	where	b.nr_sequencia		= a.nr_seq_segmento
	and	b.nr_sequencia		= NEW.nr_seq_segmento
	and	a.nr_sequencia		<> NEW.nr_sequencia
	and	a.cd_material		= NEW.cd_material;

	if (qt_existe_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(215679,'CD_MATERIAL_P='||NEW.cd_material);
		/*r.aise_application_error(-20011,'Este material já existe neste segmento.');*/

	end if;

	end;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_segmento_compras_estrut_insert() FROM PUBLIC;

CREATE TRIGGER segmento_compras_estrut_insert
	AFTER INSERT OR UPDATE ON segmento_compras_estrut FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_segmento_compras_estrut_insert();
