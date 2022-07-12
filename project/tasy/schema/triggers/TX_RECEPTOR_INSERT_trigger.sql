-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tx_receptor_insert ON tx_receptor CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tx_receptor_insert() RETURNS trigger AS $BODY$
declare

BEGIN

insert into paciente_tratamento(
	nr_sequencia,
	cd_pessoa_fisica,
	ie_tratamento,
	dt_inicio_tratamento,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	NR_SEQ_RECEPTOR
) values (
	nextval('paciente_tratamento_seq'),
	NEW.cd_pessoa_fisica,
	'TX',
	LOCALTIMESTAMP,
	LOCALTIMESTAMP,
	NEW.nm_usuario,
	LOCALTIMESTAMP,
	NEW.nm_usuario,
	NEW.nr_sequencia
);

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tx_receptor_insert() FROM PUBLIC;

CREATE TRIGGER tx_receptor_insert
	AFTER INSERT ON tx_receptor FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tx_receptor_insert();

