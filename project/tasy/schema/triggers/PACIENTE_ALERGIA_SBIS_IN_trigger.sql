-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS paciente_alergia_sbis_in ON paciente_alergia CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_paciente_alergia_sbis_in() RETURNS trigger AS $BODY$
declare

nr_log_seq_w		bigint;
ie_inativacao_w		varchar(1);

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S')  then
  select 	nextval('log_alteracao_prontuario_seq')
	into STRICT 	nr_log_seq_w
	;
  
  IF (TG_OP = 'INSERT') THEN
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
                      obter_desc_expressao(656665) ,  
                       wheb_usuario_pck.get_nm_maquina, 
                         NEW.cd_pessoa_fisica, 
                         obter_desc_expressao(314079), 
                        NEW.nr_atendimento,
                       NEW.dt_liberacao, 
                       NEW.dt_inativacao,
					   coalesce(wheb_usuario_pck.get_nm_usuario, NEW.nm_usuario),
					   NEW.nm_usuario_nrec);
  else
    ie_inativacao_w := 'N';

    if (OLD.dt_inativacao is null) and (NEW.dt_inativacao is not null) then
      ie_inativacao_w := 'S';	
    end if;
    
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
                         NEW.cd_pessoa_fisica, 
                        obter_desc_expressao(307861), 
                       NEW.nr_atendimento,
                       NEW.dt_liberacao, 
                       NEW.dt_inativacao,
			                NEW.nm_usuario,
							NEW.nm_usuario_nrec);
end if;
  end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_paciente_alergia_sbis_in() FROM PUBLIC;

CREATE TRIGGER paciente_alergia_sbis_in
	BEFORE INSERT OR UPDATE ON paciente_alergia FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_paciente_alergia_sbis_in();

