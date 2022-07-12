-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS med_aval_pac_sbis_del ON med_avaliacao_paciente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_med_aval_pac_sbis_del() RETURNS trigger AS $BODY$
declare
nr_log_seq_w		bigint;

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S')  then
	select 	nextval('log_alteracao_prontuario_seq')
	into STRICT 	nr_log_seq_w
	;

	insert into log_alteracao_prontuario(nr_sequencia, 
										 dt_atualizacao, 
										 ds_evento, 
										 ds_maquina, 
										 cd_pessoa_fisica, 
										 ds_item, 
										 nr_atendimento,
										 dt_liberacao,
										 dt_inativacao,
										 nm_usuario,
										 nm_usuario_nrec) values (nr_log_seq_w, 
										 LOCALTIMESTAMP, 
										 obter_desc_expressao(493387) ,
										 wheb_usuario_pck.get_nm_maquina, 
										 coalesce(obter_pessoa_fisica_usuario(wheb_usuario_pck.get_nm_usuario,'C'),OLD.cd_pessoa_fisica), 
										 obter_desc_expressao(284113), 
										 OLD.nr_atendimento,
										 OLD.dt_liberacao, 
										 OLD.dt_inativacao,
										 coalesce(wheb_usuario_pck.get_nm_usuario, OLD.nm_usuario),
										 OLD.nm_usuario_nrec);
end if;
RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_med_aval_pac_sbis_del() FROM PUBLIC;

CREATE TRIGGER med_aval_pac_sbis_del
	BEFORE DELETE ON med_avaliacao_paciente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_med_aval_pac_sbis_del();

