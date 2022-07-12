-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cpoe_gas_insert_update_after ON cpoe_gasoterapia CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cpoe_gas_insert_update_after() RETURNS trigger AS $BODY$
declare

ds_stack_w		varchar(2000);
ds_log_cpoe_w	varchar(2000);
dt_min_date_w	timestamp := to_date('30/12/1899 00:00:00', 'dd/mm/yyyy hh24:mi:ss');

ie_order_integr_type_w 	varchar(10);
nr_entity_identifier_w	cpoe_integracao.nr_sequencia%type;
ie_use_integration_w	varchar(10);
nr_seq_sub_grp_w varchar(2);
ie_transmit_special_order varchar(1);
json_data_w           	text;
ds_param_integration_w  varchar(20000);
nr_prescricao_w  		bigint;
BEGIN
  BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'N') then
    goto final;
end if;

	BEGIN

	if (coalesce(NEW.nr_sequencia,0) <> coalesce(OLD.nr_sequencia,0)) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' nr_sequencia(' || coalesce(OLD.nr_sequencia,0) || '/' || coalesce(NEW.nr_sequencia,0)||'); ',1,2000);
	end if;

	if (coalesce(NEW.nr_seq_cpoe_anterior,0) <> coalesce(OLD.nr_seq_cpoe_anterior,0)) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' nr_seq_cpoe_anterior(' || coalesce(OLD.nr_seq_cpoe_anterior,0) || '/' || coalesce(NEW.nr_seq_cpoe_anterior,0)||'); ',1,2000);
	end if;

	if (coalesce(NEW.dt_liberacao, dt_min_date_w) <> coalesce(OLD.dt_liberacao, dt_min_date_w)) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' dt_liberacao(' || coalesce(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(OLD.dt_liberacao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),'<NULL>') || '/' || coalesce(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_liberacao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),'<NULL>')||'); ',1,2000);
	end if;

	if (coalesce(NEW.dt_suspensao, dt_min_date_w) <> coalesce(OLD.dt_suspensao, dt_min_date_w)) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' dt_suspensao(' || coalesce(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(OLD.dt_suspensao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),'<NULL>') || '/' || coalesce(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_suspensao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),'<NULL>')||'); ',1,2000);
	end if;

	if (coalesce(NEW.ie_forma_suspensao,'XPTO') <> coalesce(OLD.ie_forma_suspensao,'XPTO')) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' ie_forma_suspensao(' || coalesce(OLD.ie_forma_suspensao,'<NULL>') || '/' || coalesce(NEW.ie_forma_suspensao,'<NULL>')||'); ',1,2000);
	end if;

	if (coalesce(NEW.dt_lib_suspensao, dt_min_date_w) <> coalesce(OLD.dt_lib_suspensao, dt_min_date_w)) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' dt_lib_suspensao(' || coalesce(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(OLD.dt_lib_suspensao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),'<NULL>') || '/' || coalesce(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_lib_suspensao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),'<NULL>')||'); ',1,2000);
	end if;

	if (coalesce(NEW.dt_liberacao_enf, dt_min_date_w) <> coalesce(OLD.dt_liberacao_enf, dt_min_date_w)) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' dt_liberacao_enf(' || coalesce(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(OLD.dt_liberacao_enf, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),'<NULL>') || '/' || coalesce(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_liberacao_enf, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),'<NULL>')||'); ',1,2000);
	end if;

	if (coalesce(NEW.dt_liberacao_farm, dt_min_date_w) <> coalesce(OLD.dt_liberacao_farm, dt_min_date_w)) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' dt_liberacao_farm(' || coalesce(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(OLD.dt_liberacao_farm, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),'<NULL>') || '/' || coalesce(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_liberacao_farm, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),'<NULL>')||'); ',1,2000);
	end if;

	if (coalesce(NEW.dt_prox_geracao, dt_min_date_w) <> coalesce(OLD.dt_prox_geracao, dt_min_date_w)) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' dt_prox_geracao(' || coalesce(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(OLD.dt_prox_geracao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),'<NULL>') || '/' || coalesce(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_prox_geracao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),'<NULL>')||'); ',1,2000);
	end if;

	if (coalesce(NEW.dt_inicio, dt_min_date_w) <> coalesce(OLD.dt_inicio, dt_min_date_w)) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' dt_inicio(' || coalesce(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(OLD.dt_inicio, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),'<NULL>') || '/' || coalesce(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_inicio, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),'<NULL>')||'); ',1,2000);
	end if;

	if (coalesce(NEW.dt_fim, dt_min_date_w) <> coalesce(OLD.dt_fim, dt_min_date_w)) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' dt_fim(' || coalesce(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(OLD.dt_fim, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),'<NULL>') || '/' || coalesce(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_fim, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),'<NULL>')||'); ',1,2000);
	end if;

	if (coalesce(NEW.ds_horarios,'XPTO') <> coalesce(OLD.ds_horarios,'XPTO')) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' ds_horarios(' || coalesce(OLD.ds_horarios,'<NULL>') || '/' || coalesce(NEW.ds_horarios,'<NULL>')||'); ',1,2000);
	end if;

	if (coalesce(NEW.ie_evento_unico,'XPTO') <> coalesce(OLD.ie_evento_unico,'XPTO')) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' ie_evento_unico(' || coalesce(OLD.ie_evento_unico,'<NULL>') || '/' || coalesce(NEW.ie_evento_unico,'<NULL>')||'); ',1,2000);
	end if;

	if (coalesce(NEW.ie_administracao,'XPTO') <> coalesce(OLD.ie_administracao,'XPTO')) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' ie_administracao(' || coalesce(OLD.ie_administracao,'<NULL>') || '/' || coalesce(NEW.ie_administracao,'<NULL>')||'); ',1,2000);
	end if;

	if (coalesce(NEW.ds_justificativa,'XPTO') <> coalesce(OLD.ds_justificativa,'XPTO')) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' ds_justificativa(' || coalesce(length(OLD.ds_justificativa),0) || '/' || coalesce(length(NEW.ds_justificativa),0)||'); ',1,2000);
	end if;

	if (coalesce(NEW.hr_prim_horario,'XPTO') <> coalesce(OLD.hr_prim_horario,'XPTO')) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' hr_prim_horario(' || coalesce(OLD.hr_prim_horario,'<NULL>') || '/' || coalesce(NEW.hr_prim_horario,'<NULL>')||'); ',1,2000);
	end if;

	if (coalesce(NEW.cd_setor_atendimento,0) <> coalesce(OLD.cd_setor_atendimento,0)) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' cd_setor_atendimento(' || coalesce(OLD.cd_setor_atendimento,0) || '/' || coalesce(NEW.cd_setor_atendimento,0)||'); ',1,2000);
	end if;

	if (coalesce(NEW.cd_intervalo,'XPTO') <> coalesce(OLD.cd_intervalo,'XPTO')) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' cd_intervalo(' || coalesce(OLD.cd_intervalo,'<NULL>') || '/' || coalesce(NEW.cd_intervalo,'<NULL>')||'); ',1,2000);
	end if;

	if (coalesce(NEW.ie_baixado_por_alta,'XPTO') <> coalesce(OLD.ie_baixado_por_alta,'XPTO')) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' ie_baixado_por_alta(' || coalesce(OLD.ie_baixado_por_alta,'<NULL>') || '/' || coalesce(NEW.ie_baixado_por_alta,'<NULL>')||'); ',1,2000);
	end if;

	if (coalesce(NEW.nr_ocorrencia,0) <> coalesce(OLD.nr_ocorrencia,0)) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' nr_ocorrencia(' || coalesce(OLD.nr_ocorrencia,0) || '/' || coalesce(NEW.nr_ocorrencia,0)||'); ',1,2000);
	end if;

	if (coalesce(NEW.dt_alta_medico, dt_min_date_w) <> coalesce(OLD.dt_alta_medico, dt_min_date_w)) then
		ds_log_cpoe_w	:= substr(ds_log_cpoe_w || ' dt_alta_medico(' || coalesce(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(OLD.dt_alta_medico, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),'<NULL>') || '/' || coalesce(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_alta_medico, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),'<NULL>')||'); ',1,2000);
	end if;
	
--***Trigger Point Cancel UnexecutedOrder Treatment Interface Starts***--
    if ((coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'ja_JP') and NEW.ie_forma_suspensao = 'I' and OLD.ie_forma_suspensao is null and wheb_usuario_pck.get_ie_executar_trigger = 'S') then
        select  distinct ct.nr_seq_sub_grp
        into STRICT    nr_seq_sub_grp_w
        from    cpoe_order_unit co,
                cpoe_tipo_pedido ct
        where   co.nr_seq_cpoe_tipo_pedido = ct.nr_sequencia
        and     co.nr_sequencia = OLD.nr_seq_cpoe_order_unit;

        select  is_special_order_rule(nr_seq_sub_grp_w,'A',wheb_usuario_pck.get_cd_estabelecimento) --select  is_special_order_rule('PR','A',wheb_usuario_pck.get_cd_estabelecimento)
        into STRICT    ie_transmit_special_order 
;
        if (ie_transmit_special_order = 'S' and nr_seq_sub_grp_w = 'PC') then
            select  nr_prescricao
            into STRICT    nr_prescricao_w 
            from    prescr_gasoterapia b 
            where   b.nr_seq_gas_cpoe = OLD.nr_sequencia;
            ds_param_integration_w := '{"recordId" : "' || nr_prescricao_w || '"' || ',"typePrescription" : "' || 'PR' || '"}';
            json_data_w := bifrost.send_integration_content(nm_event =>'nais.unexecutedOrderPrescriptionCancel.message', ds_content => ds_param_integration_w, nm_user => wheb_usuario_pck.get_nm_usuario);
         end if;
    end if;	
--***Trigger Point Cancel UnexecutedOrder Treatment Interface Ends***--  
	if (ds_log_cpoe_w is not null) then
		
		if (coalesce(OLD.nr_sequencia, 0) > 0) then
			ds_log_cpoe_w := substr('Alteracoes(old/new)= ' || ds_log_cpoe_w,1,2000);
		else
			ds_log_cpoe_w := substr('Criacao(old/new)= ' || ds_log_cpoe_w,1,2000);
		end if;
		
		ds_stack_w	:= substr(dbms_utility.format_call_stack,1,2000);
		ds_log_cpoe_w := substr(ds_log_cpoe_w ||' FUNCAO('||to_char(obter_funcao_ativa)||'); PERFIL('||to_char(obter_perfil_ativo)||')',1,2000);
		
		insert into log_cpoe(nr_sequencia, nr_atendimento, dt_atualizacao, nm_usuario, nr_seq_gasoterapia, ds_log, ds_stack) values (nextval('log_cpoe_seq'), NEW.nr_atendimento, LOCALTIMESTAMP, NEW.nm_usuario, NEW.nr_sequencia, ds_log_cpoe_w, ds_stack_w);
	end if;

	exception
	when others then
		ds_stack_w	:= substr(dbms_utility.format_call_stack,1,2000);
		
		insert into log_cpoe(nr_sequencia,
							nr_atendimento, 
							dt_atualizacao, 
							nm_usuario, 
							nr_seq_dieta, 
							ds_log, 
							ds_stack) 
		values (			nextval('log_cpoe_seq'), 
							NEW.nr_atendimento, 
							LOCALTIMESTAMP, 
							NEW.nm_usuario, 
							NEW.nr_sequencia, 
							'EXCEPTION CPOE_GAS_INSERT_UPDATE_AFTER', 
							ds_stack_w);
	end;
	
	BEGIN
		if (NEW.dt_liberacao is not null and ((OLD.dt_liberacao_enf is null and  NEW.dt_liberacao_enf is not null) or (OLD.dt_liberacao_farm is null and NEW.dt_liberacao_farm is not null))) then
			CALL cpoe_atualizar_inf_adic(NEW.nr_atendimento, NEW.nr_sequencia, 'G', NEW.dt_liberacao_enf, NEW.dt_liberacao_farm, null, null, null, null, null, NEW.nr_seq_cpoe_order_unit);
		end if;
	exception
		when others then
			CALL gravar_log_cpoe('CPOE_GAS_INSERT_UPDATE_AFTER - CPOE_ATUALIZAR_INF_ADIC - Erro: ' || substr(sqlerrm(SQLSTATE),1,1500) || ' :new.nr_sequencia '|| NEW.nr_sequencia, NEW.nr_atendimento);
	end;
	
  ie_use_integration_w := obter_param_usuario(9041, 10, obter_perfil_ativo, NEW.nm_usuario, obter_estabelecimento_ativo, ie_use_integration_w);

  if (ie_use_integration_w = 'S')
    and ((OLD.DT_LIBERACAO IS NULL AND NEW.DT_LIBERACAO IS NOT NULL)
      or (OLD.DT_LIB_SUSPENSAO IS NULL AND NEW.DT_LIB_SUSPENSAO IS NOT NULL )) then
    
    select obter_cpoe_regra_ator('G')
    into STRICT ie_order_integr_type_w
;

    if (ie_order_integr_type_w = 'OI') then
    
      nr_entity_identifier_w := cpoe_gas_order_json_pck.getCpoeIntegracaoGas(NEW.nr_sequencia, NEW.nm_usuario, nr_entity_identifier_w);

      if (OLD.DT_LIBERACAO IS NULL AND NEW.DT_LIBERACAO IS NOT NULL) then
        
        CALL call_bifrost_content('prescription.gas.order.request','cpoe_gas_order_json_pck.get_message_clob(' || NEW.nr_sequencia || ', ''NW'', ' || nr_entity_identifier_w || ')', NEW.nm_usuario);

      elsif (OLD.DT_LIB_SUSPENSAO IS NULL AND NEW.DT_LIB_SUSPENSAO IS NOT NULL ) then
      
        CALL call_bifrost_content('prescription.gas.order.request','cpoe_gas_order_json_pck.get_message_clob(' || NEW.nr_sequencia || ', ''CA'', ' || nr_entity_identifier_w || ')', NEW.nm_usuario);

      end if;

    end if;						

  end if;

<<final>>
null;	
	
  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cpoe_gas_insert_update_after() FROM PUBLIC;

CREATE TRIGGER cpoe_gas_insert_update_after
	AFTER INSERT OR UPDATE ON cpoe_gasoterapia FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cpoe_gas_insert_update_after();
