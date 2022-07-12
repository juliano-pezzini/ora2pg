-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS sip_lote_item_assist_insert ON sip_lote_item_assistencial CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_sip_lote_item_assist_insert() RETURNS trigger AS $BODY$
declare

BEGIN

select	coalesce(ie_evento, 'S'),
	coalesce(ie_benef_carencia, 'S'),
	coalesce(ie_despesa, 'S'),
	nr_seq_apres
into STRICT	NEW.ie_evento,
	NEW.ie_benef_carencia,
	NEW.ie_despesa,
	NEW.nr_seq_apres
from	sip_item_assistencial
where	nr_sequencia	= NEW.nr_seq_item_sip;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_sip_lote_item_assist_insert() FROM PUBLIC;

CREATE TRIGGER sip_lote_item_assist_insert
	BEFORE INSERT ON sip_lote_item_assistencial FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_sip_lote_item_assist_insert();
