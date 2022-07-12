-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atend_sumario_sbis_in ON atend_sumario_alta CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atend_sumario_sbis_in() RETURNS trigger AS $BODY$
declare
ie_inativacao_w		varchar(1);
nr_log_seq_w		bigint;

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S')  then
IF (TG_OP = 'INSERT') THEN
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
										 NEW.DT_ALTA, 
										 obter_desc_expressao(656665) ,  
										 wheb_usuario_pck.get_nm_maquina, 
										 obter_pessoa_fisica_usuario(NEW.nm_usuario,'C'), 
										 obter_desc_expressao(487401), 
										 NEW.nr_atendimento,
										 NEW.dt_liberacao, 
										 NEW.dt_inativacao,
										 coalesce(wheb_usuario_pck.get_nm_usuario, NEW.nm_usuario),
										 NEW.NM_USUARIO_NREC);
else
	ie_inativacao_w := 'N';
	
	if (OLD.dt_inativacao is null) and (NEW.dt_inativacao is not null) then
		ie_inativacao_w := 'S';	
	end if;
	
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
										 CASE WHEN ie_inativacao_w='N' THEN  obter_desc_expressao(302570)   ELSE obter_desc_expressao(331011) END , 
										 wheb_usuario_pck.get_nm_maquina, 
										 obter_pessoa_fisica_usuario(NEW.nm_usuario,'C'), 
										 obter_desc_expressao(487401), 
										 NEW.nr_atendimento,
										 NEW.dt_liberacao, 
										 NEW.dt_inativacao,
										 coalesce(wheb_usuario_pck.get_nm_usuario, NEW.nm_usuario),
										 NEW.NM_USUARIO_NREC);
end if;
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atend_sumario_sbis_in() FROM PUBLIC;

CREATE TRIGGER atend_sumario_sbis_in
	BEFORE INSERT OR UPDATE ON atend_sumario_alta FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atend_sumario_sbis_in();

