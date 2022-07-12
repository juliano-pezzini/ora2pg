-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS rp_pac_modelo_agend_delete ON rp_pac_modelo_agendamento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_rp_pac_modelo_agend_delete() RETURNS trigger AS $BODY$
declare
qt_vagas_restantes_w	bigint;
qt_lista_espera_w	bigint;

BEGIN
--rp_insert_log_movto_modelo(:new.nr_seq_modelo_agendamento,wheb_usuario_pck.get_nm_usuario);
qt_vagas_restantes_w	:= Rp_obter_qtd_vaga_restante(OLD.nr_seq_modelo_agendamento) + 1;
qt_lista_espera_w	:= rp_obter_lista_espera_modelo(OLD.nr_seq_modelo_agendamento);

insert into rp_log_movto_modelo(
	NR_SEQUENCIA,
	NR_SEQ_MODELO,
	DT_ATUALIZACAO,
	NM_USUARIO,
	DT_ATUALIZACAO_NREC,
	NM_USUARIO_NREC,
	DT_LOG,
	QT_VAGAS_RESTANTES,
	QT_LISTA_ESPERA        )
values (	nextval('rp_log_movto_modelo_seq'),
	OLD.nr_seq_modelo_agendamento,
	LOCALTIMESTAMP,
	wheb_usuario_pck.get_nm_usuario,
	LOCALTIMESTAMP,
	wheb_usuario_pck.get_nm_usuario,
	LOCALTIMESTAMP,
	qt_vagas_restantes_w,
	qt_lista_espera_w);

RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_rp_pac_modelo_agend_delete() FROM PUBLIC;

CREATE TRIGGER rp_pac_modelo_agend_delete
	BEFORE DELETE ON rp_pac_modelo_agendamento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_rp_pac_modelo_agend_delete();

