-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS diagnostico_doenca_sbis_del ON diagnostico_doenca CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_diagnostico_doenca_sbis_del() RETURNS trigger AS $BODY$
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
									 obter_pessoa_atendimento(OLD.nr_atendimento,'C'), 
									 obter_desc_expressao(316599), 
									  OLD.nr_atendimento,
									 OLD.dt_liberacao, 
									 OLD.dt_inativacao,
									 coalesce(wheb_usuario_pck.get_nm_usuario,'TASY'),
									 OLD.nm_usuario_nrec);


end if;
RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_diagnostico_doenca_sbis_del() FROM PUBLIC;

CREATE TRIGGER diagnostico_doenca_sbis_del
	BEFORE DELETE ON diagnostico_doenca FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_diagnostico_doenca_sbis_del();
