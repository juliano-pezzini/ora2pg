-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS mapa_ocupacao_quimio_insert ON mapa_ocupacao_quimio CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_mapa_ocupacao_quimio_insert() RETURNS trigger AS $BODY$
declare

nr_sequencia_w		bigint;
nr_seq_mapa_onco_w	bigint;
BEGIN

nr_seq_mapa_onco_w := NEW.nr_sequencia;

if (NEW.nr_seq_local <> OLD.nr_seq_local) then
	select	nextval('paciente_atendimento_hist_seq')
	into STRICT	nr_sequencia_w
	;

	insert into paciente_atendimento_hist(
		nr_sequencia,
		nr_seq_atendimento,
		dt_atualizacao,
		nm_usuario,
		nr_seq_local,
		nr_seq_mapa_ocup)
	values (nr_sequencia_w,
		NEW.nr_seq_atendimento,
		LOCALTIMESTAMP,
		wheb_usuario_pck.get_nm_usuario,
		NEW.nr_seq_local,
		nr_seq_mapa_onco_w);
end if;

if (NEW.dt_mapa <> OLD.dt_mapa) then
	select	nextval('paciente_atendimento_hist_seq')
	into STRICT	nr_sequencia_w
	;

	insert into paciente_atendimento_hist(
		nr_sequencia,
		nr_seq_atendimento,
		dt_atualizacao,
		nm_usuario,
		dt_mapa,
		nr_seq_mapa_ocup)
	values (nr_sequencia_w,
		NEW.nr_seq_atendimento,
		LOCALTIMESTAMP,
		wheb_usuario_pck.get_nm_usuario,
		NEW.dt_mapa,
		nr_seq_mapa_onco_w);
end if;

if (NEW.dt_mapa <> OLD.dt_mapa) then
	select	nextval('paciente_atendimento_hist_seq')
	into STRICT	nr_sequencia_w
	;

	insert into paciente_atendimento_hist(
		nr_sequencia,
		nr_seq_atendimento,
		dt_atualizacao,
		nm_usuario,
		dt_mapa,
		nr_seq_mapa_ocup)
	values (nr_sequencia_w,
		NEW.nr_seq_atendimento,
		LOCALTIMESTAMP,
		wheb_usuario_pck.get_nm_usuario,
		NEW.dt_mapa,
		nr_seq_mapa_onco_w);
end if;

if (NEW.ie_exibir_mapa <> OLD.ie_exibir_mapa) then
	select	nextval('paciente_atendimento_hist_seq')
	into STRICT	nr_sequencia_w
	;

	insert into paciente_atendimento_hist(
		nr_sequencia,
		nr_seq_atendimento,
		dt_atualizacao,
		nm_usuario,
		ie_exibir_mapa,
		nr_seq_mapa_ocup)
	values (nr_sequencia_w,
		NEW.nr_seq_atendimento,
		LOCALTIMESTAMP,
		wheb_usuario_pck.get_nm_usuario,
		NEW.ie_exibir_mapa,
		nr_seq_mapa_onco_w);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_mapa_ocupacao_quimio_insert() FROM PUBLIC;

CREATE TRIGGER mapa_ocupacao_quimio_insert
	BEFORE UPDATE ON mapa_ocupacao_quimio FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_mapa_ocupacao_quimio_insert();
