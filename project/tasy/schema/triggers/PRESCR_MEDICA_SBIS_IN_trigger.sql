-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS prescr_medica_sbis_in ON prescr_medica CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_prescr_medica_sbis_in() RETURNS trigger AS $BODY$
declare
nr_log_seq_w		log_alteracao_prontuario.nr_sequencia%type;
nm_usuario_w    prescr_medica.nm_usuario%type;

BEGIN

	select 	nextval('log_alteracao_prontuario_seq')
	into STRICT 	nr_log_seq_w
	;
  
  nm_usuario_w := wheb_usuario_pck.get_nm_usuario;
  if (nm_usuario_w is null) then
    nm_usuario_w := NEW.nm_usuario;
  end if;

	IF (TG_OP = 'INSERT') then
		insert into log_alteracao_prontuario(nr_sequencia,
											 dt_atualizacao, 
											 ds_evento, 
											 ds_maquina, 
											 cd_pessoa_fisica, 
											 ds_item, 
											  nr_atendimento,
											  nm_usuario) values (nr_log_seq_w, 
											 coalesce(NEW.dt_prescricao, LOCALTIMESTAMP),
											 obter_desc_expressao(656665) ,  
											 wheb_usuario_pck.get_nm_maquina, 
											 coalesce(obter_pessoa_fisica_usuario(nm_usuario_w,'C'),NEW.cd_pessoa_fisica), 
											 obter_desc_expressao(296208), 
											 NEW.nr_atendimento,
											 nm_usuario_w);
	else
		insert into log_alteracao_prontuario(nr_sequencia,
											 dt_atualizacao, 
											 ds_evento, 
											 ds_maquina, 
											 cd_pessoa_fisica, 
											 ds_item, 
											  nr_atendimento,
											  nm_usuario) values (nr_log_seq_w, 
											 coalesce(NEW.dt_prescricao, LOCALTIMESTAMP),
											 obter_desc_expressao(302570) ,  
											 wheb_usuario_pck.get_nm_maquina, 
											 coalesce(obter_pessoa_fisica_usuario(nm_usuario_w,'C'),NEW.cd_pessoa_fisica), 
											 obter_desc_expressao(296208), 
											 NEW.nr_atendimento,
											 nm_usuario_w);
	
	end if;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_prescr_medica_sbis_in() FROM PUBLIC;

CREATE TRIGGER prescr_medica_sbis_in
	BEFORE INSERT OR UPDATE ON prescr_medica FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_prescr_medica_sbis_in();

