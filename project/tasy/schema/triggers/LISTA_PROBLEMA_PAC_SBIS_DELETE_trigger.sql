-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS lista_problema_pac_sbis_delete ON lista_problema_pac CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_lista_problema_pac_sbis_delete() RETURNS trigger AS $BODY$
declare

nr_log_seq_w		bigint;
ie_inativacao_w		varchar(1);

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
									 obter_pessoa_fisica_usuario(wheb_usuario_pck.get_nm_usuario,'C'), 
									 obter_desc_expressao(303710), 
									  OLD.nr_atendimento,
									 OLD.dt_liberacao, 
									 OLD.dt_inativacao,
									 wheb_usuario_pck.get_nm_usuario,
									 OLD.NM_USUARIO_NREC);

end if;
RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_lista_problema_pac_sbis_delete() FROM PUBLIC;

CREATE TRIGGER lista_problema_pac_sbis_delete
	BEFORE DELETE ON lista_problema_pac FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_lista_problema_pac_sbis_delete();

