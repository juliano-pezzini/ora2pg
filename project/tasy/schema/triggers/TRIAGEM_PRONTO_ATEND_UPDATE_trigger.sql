-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS triagem_pronto_atend_update ON triagem_pronto_atend CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_triagem_pronto_atend_update() RETURNS trigger AS $BODY$
declare

ie_atualizar_dados_w	varchar(1);
ie_atualizar_clinica_w	varchar(1);
nr_seq_evento_atendimento_w	bigint;
ds_erro_w		varchar(255);

C09 CURSOR FOR
	SELECT	a.nr_seq_evento
	FROM	regra_envio_sms a
	WHERE	a.cd_estabelecimento	= wheb_usuario_pck.get_cd_estabelecimento
	AND	a.ie_evento_disp	= 'TCP'
	and	coalesce(a.ie_situacao,'A') = 'A'
	order by a.nr_seq_evento desc;
BEGIN
  BEGIN

ie_atualizar_dados_w := Obter_Param_Usuario(281, 972, obter_perfil_ativo, NEW.nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_atualizar_dados_w);
ie_atualizar_clinica_w := Obter_Param_Usuario(916, 329, obter_perfil_ativo, NEW.nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_atualizar_clinica_w);

if (ie_atualizar_dados_w = 'S') and (NEW.nr_atendimento is not null)then
	
		if  	((coalesce(OLD.nr_seq_classif,0) <> coalesce(NEW.nr_seq_classif,0)) or (coalesce(OLD.nr_seq_triagem_prioridade,0) <> coalesce(NEW.nr_seq_triagem_prioridade,0))) then
			update	atendimento_paciente
			set	nr_seq_triagem		   =	NEW.nr_seq_classif,
				nr_seq_triagem_prioridade  =	NEW.nr_seq_triagem_prioridade
			where	nr_atendimento		   =	NEW.nr_atendimento;
		end if;
		
		if (coalesce(OLD.dt_chamada_painel,LOCALTIMESTAMP - interval '1 days') <> coalesce(NEW.dt_chamada_painel,LOCALTIMESTAMP - interval '1 days')) then
			update  atendimento_paciente
			set     dt_chamada_enfermagem =	NEW.dt_chamada_painel,
				ie_chamado            = CASE WHEN NEW.dt_chamada_painel = NULL THEN 'N'  ELSE 'S' END
			where	nr_atendimento        =	NEW.nr_atendimento;
		
		end if;
		
		if (coalesce(OLD.dt_inicio_triagem,LOCALTIMESTAMP - interval '1 days') <> coalesce(NEW.dt_inicio_triagem,LOCALTIMESTAMP - interval '1 days')) then
			update  atendimento_paciente
			set 	dt_inicio_atendimento = NEW.dt_inicio_triagem,
					nm_usuario_triagem	  = coalesce(wheb_usuario_pck.get_nm_usuario,NEW.nm_usuario)
			where	nr_atendimento        =	NEW.nr_atendimento;
		end if;
		
		if (coalesce(OLD.dt_fim_triagem,LOCALTIMESTAMP - interval '1 days') <> coalesce(NEW.dt_fim_triagem,LOCALTIMESTAMP - interval '1 days')) then
			update  atendimento_paciente
			set 	dt_fim_triagem	      = NEW.dt_fim_triagem
			where	nr_atendimento        =	NEW.nr_atendimento;

			CALL job_regra_alterar_local_status(NEW.nr_atendimento,'FE',coalesce(wheb_usuario_pck.get_nm_usuario,NEW.nm_usuario),obter_perfil_ativo,obter_estabelecimento_ativo);

		end if;
		
		if (ie_atualizar_clinica_w = 'S') and (coalesce(OLD.ie_clinica,0) <> coalesce(NEW.ie_clinica,0)) then
			update	atendimento_paciente
			set	ie_clinica		   =	NEW.ie_clinica
			where	nr_atendimento		   =	NEW.nr_atendimento;
		end if;
		
end if;

if (coalesce(OLD.nr_seq_classif,0) <> coalesce(NEW.nr_seq_classif,0)) then
	insert into log_classif_triagem(
			nr_sequencia,
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nr_seq_classif, 
			nr_seq_triagem)
	values (nextval('log_classif_triagem_seq'),
			LOCALTIMESTAMP, 
			NEW.nm_usuario, 
			LOCALTIMESTAMP, 
			NEW.nm_usuario, 
			OLD.nr_seq_classif, 
			NEW.nr_sequencia);
end if;

BEGIN
if (coalesce(NEW.NR_SEQ_CLASSIF,0)	<> coalesce(OLD.NR_SEQ_CLASSIF,0)) and (NEW.nr_atendimento	is null)then
	BEGIN

	OPEN C09;
	LOOP
	FETCH C09 INTO	
		nr_seq_evento_atendimento_w;
	EXIT WHEN NOT FOUND; /* apply on C09 */
		BEGIN
		CALL gerar_evento_paciente_trigger(nr_seq_evento_atendimento_w, NEW.nr_atendimento, NEW.cd_Pessoa_fisica, 0, coalesce(wheb_usuario_pck.get_nm_usuario,NEW.nm_usuario), null);
		END;	
	END LOOP;
	CLOSE C09;
	end;
end if;

EXCEPTION
WHEN OTHERS THEN
	NULL;
END;

if (NEW.NR_SEQ_CLASSIF <> coalesce(OLD.NR_SEQ_CLASSIF,-1)) then
	CALL gerar_lancamento_automatico(NEW.nr_atendimento,null,589,NEW.nm_usuario,NEW.nr_sequencia,'','','',NEW.NR_SEQ_CLASSIF,null);
end if;

  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_triagem_pronto_atend_update() FROM PUBLIC;

CREATE TRIGGER triagem_pronto_atend_update
	AFTER UPDATE ON triagem_pronto_atend FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_triagem_pronto_atend_update();
