-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ehr_template_conteudo_update ON ehr_template_conteudo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ehr_template_conteudo_update() RETURNS trigger AS $BODY$
declare

BEGIN

if (NEW.nr_seq_elemento <> OLD.nr_seq_elemento) then
	CALL wheb_mensagem_pck.EXIBIR_MENSAGEM_ABORT(228929);
elsif (NEW.nr_seq_linked_data <> OLD.nr_seq_linked_data and (OLD.nr_seq_linked_data is not null)) then
	CALL wheb_mensagem_pck.EXIBIR_MENSAGEM_ABORT(1131452);
end	if;

if (NEW.ie_situacao = 'I') then
	NEW.dt_inativacao := LOCALTIMESTAMP;
elsif (NEW.ie_situacao = 'A') then
	NEW.dt_inativacao := null;	
end	if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ehr_template_conteudo_update() FROM PUBLIC;

CREATE TRIGGER ehr_template_conteudo_update
	BEFORE UPDATE ON ehr_template_conteudo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ehr_template_conteudo_update();
