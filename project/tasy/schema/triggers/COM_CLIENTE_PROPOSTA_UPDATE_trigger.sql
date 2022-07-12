-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS com_cliente_proposta_update ON com_cliente_proposta CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_com_cliente_proposta_update() RETURNS trigger AS $BODY$
BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S')  then

	if (OLD.dt_cancelamento is null) and (NEW.dt_cancelamento is not null) and (NEW.nm_usuario_cancelamento is null) then
		BEGIN
		NEW.nm_usuario_cancelamento := wheb_usuario_pck.get_nm_usuario;
		end;
	end if;

	if (OLD.dt_vencimento is not null) and (NEW.dt_vencimento is not null) and (OLD.dt_vencimento <> NEW.dt_vencimento) then
		BEGIN
		insert into
		com_cliente_prop_log(
			nr_sequencia,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_atualizacao,
			nm_usuario,
			nr_seq_proposta,
			dt_log,
			nm_usuario_log,
			ds_motivo_log)
		values (
			nextval('com_cliente_prop_log_seq'),
			LOCALTIMESTAMP,
			NEW.nm_usuario,
			LOCALTIMESTAMP,
			NEW.nm_usuario,
			NEW.nr_sequencia,
			LOCALTIMESTAMP,
			NEW.nm_usuario,
			NEW.ds_mot_alt_venc);
		end;
	end if;
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_com_cliente_proposta_update() FROM PUBLIC;

CREATE TRIGGER com_cliente_proposta_update
	BEFORE UPDATE ON com_cliente_proposta FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_com_cliente_proposta_update();
