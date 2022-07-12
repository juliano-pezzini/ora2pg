-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS solic_compra_item_afeterinsert ON solic_compra_item CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_solic_compra_item_afeterinsert() RETURNS trigger AS $BODY$
declare
ds_compl_item_w		gpi_orc_item.ds_compl_item%type;


BEGIN

if (NEW.nr_seq_orc_item_gpi > 0) then

	select	ds_compl_item
	into STRICT	ds_compl_item_w
	from	gpi_orc_item
	where	nr_sequencia = NEW.nr_seq_orc_item_gpi;

	if (ds_compl_item_w is not null) then

		insert into solic_compra_item_detalhe(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_solic_compra,
			nr_item_solic_compra,
			ds_detalhe)
		values (	nextval('solic_compra_item_detalhe_seq'),
			LOCALTIMESTAMP,
			NEW.nm_usuario,
			LOCALTIMESTAMP,
			NEW.nm_usuario_nrec,
			NEW.nr_solic_compra,
			NEW.nr_item_solic_compra,
			ds_compl_item_w);
	end if;
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_solic_compra_item_afeterinsert() FROM PUBLIC;

CREATE TRIGGER solic_compra_item_afeterinsert
	AFTER INSERT ON solic_compra_item FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_solic_compra_item_afeterinsert();
