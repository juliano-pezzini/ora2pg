-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS lote_audit_hist_item_bef ON lote_audit_hist_item CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_lote_audit_hist_item_bef() RETURNS trigger AS $BODY$
declare
pragma autonomous_transaction;
nm_usuario_resp_w varchar(15);
BEGIN

if (NEW.nm_usuario_previsto is null) then
	nm_usuario_resp_w := usuario_resp_pck.obter_usuario_responsavel(null, null, NEW.nr_seq_propaci, NEW.nr_seq_matpaci, null, null, null, null, null, null, NEW.nm_usuario, nm_usuario_resp_w);
	NEW.nm_usuario_previsto := nm_usuario_resp_w;
end if;



RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_lote_audit_hist_item_bef() FROM PUBLIC;

CREATE TRIGGER lote_audit_hist_item_bef
	BEFORE INSERT ON lote_audit_hist_item FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_lote_audit_hist_item_bef();
