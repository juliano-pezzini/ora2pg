-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS sip_lote_item_ass_atual ON sip_lote_item_assistencial CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_sip_lote_item_ass_atual() RETURNS trigger AS $BODY$
declare
cd_classificacao_sip_w 		sip_lote_item_assistencial.cd_classificacao_sip%type;
BEGIN

if 	(((NEW.cd_classificacao_sip is null) or --insert
	  (OLD.nr_seq_item_sip <> NEW.nr_seq_item_sip))and --update
	 (NEW.nr_seq_item_sip is not null))	then
	select	max(cd_classificacao)
	into STRICT	cd_classificacao_sip_w
	from	sip_item_assistencial
	where	nr_sequencia = NEW.nr_seq_item_sip;

	NEW.cd_classificacao_sip := cd_classificacao_sip_w;

end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_sip_lote_item_ass_atual() FROM PUBLIC;

CREATE TRIGGER sip_lote_item_ass_atual
	BEFORE INSERT OR UPDATE ON sip_lote_item_assistencial FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_sip_lote_item_ass_atual();
