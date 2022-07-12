-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atend_previsao_alta_atual ON atend_previsao_alta CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atend_previsao_alta_atual() RETURNS trigger AS $BODY$
declare

dt_previsto_alta_w		timestamp;
ie_probabilidade_alta_w		varchar(3);
nr_seq_classif_medico_w		bigint;
ds_obs_prev_alta_w		varchar(255);
new_ds_observacao_w		varchar(255);
nr_dias_prev_alta_w 		smallint;
ie_consistir_w			boolean := true;

pragma autonomous_transaction;
BEGIN


if (wheb_usuario_pck.get_ie_executar_trigger	!= 'N')  then
if	TG_OP = 'INSERT' then
	if (NEW.cd_especialidade is null) then
		NEW.cd_especialidade	:= coalesce(wheb_usuario_pck.get_cd_especialidade, Obter_Especialidade_Medico(NEW.cd_profissional,'C'));
	end if;

elsif (NEW.nr_atendimento is not null) then

	if (NEW.dt_previsto_alta is not null) then
	   nr_dias_prev_alta_w := NEW.nr_dias_prev_alta;
	end if;

	if (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null) and (coalesce(NEW.ie_alta_hospitalar,'N') = 'S') then
		update	atendimento_paciente set
			dt_previsto_alta	= NEW.dt_previsto_alta,
			ie_probabilidade_alta	= NEW.ie_probabilidade_alta,
			nr_seq_classif_medico	= coalesce(NEW.nr_seq_classif_medico, nr_seq_classif_medico),
			ds_obs_prev_alta	= NEW.ds_observacao
		where	nr_atendimento = NEW.nr_atendimento;

		ie_consistir_w := false;
		
	        commit;
	

	       if (NEW.dt_previsto_alta is not null) then
			update	atendimento_paciente set
				NR_DIAS_PREV_ALTA = nr_dias_prev_alta_w
			where	nr_atendimento = NEW.nr_atendimento;
		end if;
		
		CALL wl_gerar_finalizar_tarefa('ED', 'F', NEW.nr_atendimento, 0, NEW.nm_usuario, LOCALTIMESTAMP, 'N',null,null,null,null,null,null,null,null,null,null,null,null,null,null,NEW.nr_sequencia);
		
		commit;
	elsif (coalesce(OLD.ie_situacao,'A') = 'A') and (coalesce(NEW.ie_situacao,'A') = 'I') and (coalesce(NEW.ie_alta_hospitalar,'N') = 'S') then
		
		select	max(dt_previsto_alta),
			max(ie_probabilidade_alta),
			max(nr_seq_classif_medico),
			max(ds_obs_prev_alta)
		into STRICT	dt_previsto_alta_w,
			ie_probabilidade_alta_w,
			nr_seq_classif_medico_w,
			ds_obs_prev_alta_w
		from	atendimento_paciente
		where	nr_atendimento = NEW.nr_atendimento;
		
		if (dt_previsto_alta_w = NEW.dt_previsto_alta) and (coalesce(ie_probabilidade_alta_w,'XPTO') = coalesce(NEW.ie_probabilidade_alta,'XPTO')) and (coalesce(nr_seq_classif_medico_w,0) = coalesce(NEW.nr_seq_classif_medico,0)) and (coalesce(ds_obs_prev_alta_w,'xpto') = coalesce(NEW.ds_observacao,'xpto')) then
			
			select	max(dt_previsto_alta),
				max(ie_probabilidade_alta),
				max(nr_seq_classif_medico),
				max(ds_observacao)
			into STRICT	dt_previsto_alta_w,
				ie_probabilidade_alta_w,
				nr_seq_classif_medico_w,
				ds_obs_prev_alta_w
			from	atend_previsao_alta
			where	nr_atendimento = NEW.nr_atendimento
			and	nr_sequencia = (SELECT	max(nr_sequencia)
						from	atend_previsao_alta
						where	nr_atendimento = NEW.nr_atendimento
						and	coalesce(ie_situacao,'A') = 'A'
						and	dt_liberacao is not null
						and	coalesce(ie_alta_hospitalar,'N') = 'S'
						and	nr_sequencia <> NEW.nr_sequencia);
						
			if (dt_previsto_alta_w is not null) or (ie_probabilidade_alta_w is not null) or (nr_seq_classif_medico_w is not null) or (ds_obs_prev_alta_w is not null) then	
				update	atendimento_paciente set
					dt_previsto_alta	= dt_previsto_alta_w,
					ie_probabilidade_alta	= ie_probabilidade_alta_w,
					nr_seq_classif_medico	= nr_seq_classif_medico_w,
					ds_obs_prev_alta	= ds_obs_prev_alta_w,
					NR_DIAS_PREV_ALTA = nr_dias_prev_alta_w
				where	nr_atendimento = NEW.nr_atendimento;
				
				ie_consistir_w := false;
			else
				update	atendimento_paciente set
					dt_previsto_alta	 = NULL,
					ie_probabilidade_alta	 = NULL,
					nr_seq_classif_medico	 = NULL,
					ds_obs_prev_alta	 = NULL,
					NR_DIAS_PREV_ALTA  = NULL
				where	nr_atendimento = NEW.nr_atendimento;
				
				ie_consistir_w := false;

			end if;

			commit;
		end if;
	end if;
	
	if (ie_consistir_w) then
		if	((NEW.dt_previsto_alta <> OLD.dt_previsto_alta) or
			 (OLD.dt_previsto_alta is null AND NEW.dt_previsto_alta is not null) or
			 (OLD.dt_liberacao is null AND NEW.dt_liberacao is not null) or (coalesce(NEW.ie_situacao,'A') <> coalesce(OLD.ie_situacao,'A')))  then
			 CALL consiste_tipo_visita_atend(nr_atendimento_p => NEW.nr_atendimento,
						    dt_previsto_alta_p => NEW.dt_previsto_alta,
						    ie_alteracao_p => 'D',
						    ie_alt_data_prev_p => 'S');
		end if;
	end if;
end if;

commit;
end if;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atend_previsao_alta_atual() FROM PUBLIC;

CREATE TRIGGER atend_previsao_alta_atual
	BEFORE INSERT OR UPDATE ON atend_previsao_alta FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atend_previsao_alta_atual();
