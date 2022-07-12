-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_conta_alt ON pls_conta CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_conta_alt() RETURNS trigger AS $BODY$
declare
	ds_log_call_w 	varchar(1500);
	ds_observacao_w	varchar(4000);
	ie_opcao_w	varchar(3);
BEGIN
if (coalesce(wheb_usuario_pck.get_ie_executar_trigger,'S') = 'S')  then
	if ( pls_se_aplicacao_tasy = 'N')  or (NEW.ie_status			!= 'C' and OLD.ie_status = 'C') or (NEW.ie_status_fat	= 'N' and coalesce(OLD.ie_status_fat,'X') != 'N')  or (NEW.ie_status_fat  = 'P' and OLD.ie_status_fat != 'P')  or
		(NEW.nr_seq_analise is null AND OLD.nr_seq_analise is not null) then
		
		ds_log_call_w := substr(pls_obter_detalhe_exec(false),1,1500);/*substr(	' Funcao ativa : '|| obter_funcao_ativa || chr(13) ||chr(10)||
				' CallStack: '|| chr(13) || chr(10)|| dbms_utility.format_call_stack,1,1500);*/

				--' Funcao ativa : '|| obter_funcao_ativa || chr(13) ||chr(10)||

		ds_observacao_w := 'Conta: '||OLD.nr_sequencia||' ; Protocolo: '||OLD.nr_seq_protocolo;
		
		if (NEW.nr_seq_analise is null and OLD.nr_seq_analise is not null) then		
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Sequencia analise: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '|| OLD.nr_seq_analise||' - Modificada: '||NEW.nr_seq_analise;
						end if;
						
		if (coalesce(OLD.ie_status,'X') <> coalesce(NEW.ie_status,'X')) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Status: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '|| OLD.ie_status||' - Modificada: '||NEW.ie_status;
		end if;	
		
		if (coalesce(OLD.cd_guia,'X') <> coalesce(NEW.cd_guia,'X')) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Guia: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '|| OLD.cd_guia||' - Modificada: '||NEW.cd_guia;
		end if;	
		
		if (NEW.ie_status_fat  = 'P' and OLD.ie_status_fat != 'P') then
		  ds_observacao_w :=  ds_observacao_w||chr(13)||chr(10)||
				'Status faturamento: '||chr(13)||chr(10)||
				chr(9)||'Anterior: '|| OLD.ie_status_fat||' - Modificada: '||NEW.ie_status_fat;
		end if;
		
		if (NEW.ie_status_fat	= 'N' and coalesce(OLD.ie_status_fat,'X') != 'N') then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Status faturamento: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '|| OLD.ie_status_fat||' - Modificada: '||NEW.ie_status_fat;
		end if;
		if (coalesce(OLD.cd_guia_referencia,'X') <> coalesce(NEW.cd_guia_referencia,'X')) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Guia: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '|| OLD.cd_guia_referencia||' - Modificada: '||NEW.cd_guia_referencia;
		end if;	
		
		if (coalesce(OLD.ie_tipo_guia,'X') <> coalesce(NEW.ie_tipo_guia,'X')) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Tipo guia: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||obter_valor_dominio(1746, OLD.ie_tipo_guia)||' - Modificada: '||obter_valor_dominio(1746, NEW.ie_tipo_guia);
		end if;	

		if (coalesce(OLD.nr_seq_segurado,0) <> coalesce(NEW.nr_seq_segurado,0)) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Segurado: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||pls_obter_dados_segurado(OLD.nr_seq_segurado,'N')||' - Modificado: '||pls_obter_dados_segurado(NEW.nr_seq_segurado,'N')||chr(13)||chr(10);
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Segurado: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||OLD.nr_seq_segurado||' - Modificado: '||NEW.nr_seq_segurado||chr(13)||chr(10);
		end if;
		
		if (coalesce(OLD.nr_seq_prestador_exec,0) <> coalesce(NEW.nr_seq_prestador_exec,0)) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Prestador executor: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||pls_obter_dados_prestador(OLD.nr_seq_prestador_exec,'N')||' - Modificado: '||pls_obter_dados_prestador(NEW.nr_seq_prestador_exec,'N')||chr(13)||chr(10);
		end if;

		if (coalesce(OLD.nr_seq_prestador,0) <> coalesce(NEW.nr_seq_prestador,0)) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Prestador solicitante: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||pls_obter_dados_prestador(OLD.nr_seq_prestador,'N')||' - Modificado: '||pls_obter_dados_prestador(NEW.nr_seq_prestador,'N')||chr(13)||chr(10);	
		end if;
		
		if (coalesce(OLD.qt_nasc_mortos,0) <> coalesce(NEW.qt_nasc_mortos,0)) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Qt. Nasc. mortos:: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||OLD.qt_nasc_mortos||' - Modificado: '||NEW.qt_nasc_mortos||chr(13)||chr(10);
		end if;

		if (coalesce(OLD.qt_nasc_vivos_termo,0) <> coalesce(NEW.qt_nasc_vivos_termo,0)) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Qt. Nasc. vivos a termo: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||OLD.qt_nasc_vivos_termo||' - Modificado: '||NEW.qt_nasc_vivos_termo||chr(13)||chr(10);
		end if;

		if (coalesce(OLD.qt_nasc_vivos_prematuros,0) <> coalesce(NEW.qt_nasc_vivos_prematuros,0)) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Qt. Nasc. vivos prematuro: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||OLD.qt_nasc_vivos_prematuros||' - Modificado: '||NEW.qt_nasc_vivos_prematuros||chr(13)||chr(10);
		end if;

		if (coalesce(OLD.qt_obito_precoce,0) <> coalesce(NEW.qt_obito_precoce,0)) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Qt. Obito neonatal Precoce: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||OLD.qt_obito_precoce||' - Modificado: '||NEW.qt_obito_precoce||chr(13)||chr(10);
		end if;

		if (coalesce(NEW.qt_obito_tardio,0) <> coalesce(OLD.qt_obito_tardio,0)) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Qt. Obito neonatal Tardio: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||OLD.qt_obito_tardio||' - Modificado: '||NEW.qt_obito_tardio||chr(13)||chr(10);
		end if;
		
		if (coalesce(OLD.nr_seq_saida_int,0) <> coalesce(NEW.nr_seq_saida_int,0)) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Motivo saida: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||pls_obter_desc_mot_saida_int(OLD.nr_seq_saida_int)||' - Modificado: '||pls_obter_desc_mot_saida_int(NEW.nr_seq_saida_int)||chr(13)||chr(10);
		end if;
		
		if (coalesce(OLD.nr_seq_tipo_acomodacao,0) <> coalesce(NEW.nr_seq_tipo_acomodacao,0)) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Acomodacao: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||pls_obter_desc_tipo_acomodacao(OLD.nr_seq_tipo_acomodacao)||' - Modificado: '||pls_obter_desc_tipo_acomodacao(NEW.nr_seq_tipo_acomodacao)||chr(13)||chr(10);
		end if;

		if (coalesce(OLD.nr_seq_tipo_atendimento,0) <> coalesce(NEW.nr_seq_tipo_atendimento,0)) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Tipo atendimento: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||pls_obter_desc_tipo_atend(OLD.nr_seq_tipo_atendimento)||' - Modificado: '||pls_obter_desc_tipo_atend(NEW.nr_seq_tipo_atendimento)||chr(13)||chr(10);
		end if;
		
		if (coalesce(OLD.ie_cobertura_especial,0) <> coalesce(NEW.ie_cobertura_especial,0)) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Cobertura especial: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||OLD.ie_cobertura_especial||' - Modificado: '||NEW.ie_cobertura_especial||chr(13)||chr(10);
		end if;
		
		if (coalesce(OLD.ie_regime_atendimento,0) <> coalesce(NEW.ie_regime_atendimento,0)) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Regime atendimento: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||OLD.ie_regime_atendimento||' - Modificado: '||NEW.ie_regime_atendimento||chr(13)||chr(10);
		end if;
		
		if (coalesce(OLD.ie_saude_ocupacional,0) <> coalesce(NEW.ie_saude_ocupacional,0)) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Saude ocupacional: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||OLD.ie_saude_ocupacional||' - Modificado: '||NEW.ie_saude_ocupacional||chr(13)||chr(10);
		end if;
		
		if (coalesce(to_char(OLD.dt_emissao, 'dd/mm/yyyy hh24:mi:ss'),'X') <> coalesce(to_char(NEW.dt_emissao, 'dd/mm/yyyy hh24:mi:ss'),'X')) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Data de entrada: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||to_char(OLD.dt_emissao, 'dd/mm/yyyy hh24:mi:ss')||' - Modificado: '||to_char(NEW.dt_emissao, 'dd/mm/yyyy hh24:mi:ss')||chr(13)||chr(10);
		end if;
		
		if (coalesce(to_char(OLD.dt_entrada, 'dd/mm/yyyy hh24:mi:ss'),'X') <> coalesce(to_char(NEW.dt_entrada, 'dd/mm/yyyy hh24:mi:ss'),'X')) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Data de entrada: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||to_char(OLD.dt_entrada, 'dd/mm/yyyy hh24:mi:ss')||' - Modificado: '||to_char(NEW.dt_entrada, 'dd/mm/yyyy hh24:mi:ss')||chr(13)||chr(10);
		end if;
			
		if (coalesce(to_char(OLD.dt_alta, 'dd/mm/yyyy hh24:mi:ss'),'X') <> coalesce(to_char(NEW.dt_alta, 'dd/mm/yyyy hh24:mi:ss'),'X')) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Data de alta: '||chr(13)||chr(10)||
						chr(9)	||'Anterior: '||to_char(OLD.dt_alta, 'dd/mm/yyyy hh24:mi:ss')||' - Modificado: '||to_char(NEW.dt_alta, 'dd/mm/yyyy hh24:mi:ss')||chr(13)||chr(10);					
		end if;
		
		if (coalesce(OLD.cd_senha_externa,'X') <> coalesce(NEW.cd_senha_externa,'X')) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Senha externa: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||OLD.cd_senha_externa||' - Modificado: '||NEW.cd_senha_externa||chr(13)||chr(10);
		end if;
		
		if (coalesce(OLD.ie_gestacao,'X') <> coalesce(NEW.ie_gestacao,'X')) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Se gestacao: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||OLD.ie_gestacao||' - Modificado: '||NEW.ie_gestacao||chr(13)||chr(10);
		end if;
		
		if (coalesce(OLD.ie_aborto,'X') <> coalesce(NEW.ie_aborto,'X')) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Aborto: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||OLD.ie_aborto||' - Modificado: '||NEW.ie_aborto||chr(13)||chr(10);
		end if;
		
		if (coalesce(OLD.nr_seq_grau_partic,0) <> coalesce(NEW.nr_seq_grau_partic,0)) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Grau de participacao: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||OLD.nr_seq_grau_partic||' - Modificado: '||NEW.nr_seq_grau_partic||chr(13)||chr(10);
		end if;
		
		if (coalesce(OLD.cd_medico_executor,'X') <> coalesce(NEW.cd_medico_executor,'X')) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Medico executante: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||OLD.cd_medico_executor||' - Modificado: '||NEW.cd_medico_executor||chr(13)||chr(10);
		end if;
		
		if (coalesce(to_char(OLD.dt_atualizacao_nrec, 'dd/mm/yyyy hh24:mi:ss'),'X') <> coalesce(to_char(NEW.dt_atualizacao_nrec, 'dd/mm/yyyy hh24:mi:ss'),'X')) then
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)||
						'Data de atualizacao: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||to_char(OLD.dt_atualizacao_nrec, 'dd/mm/yyyy hh24:mi:ss')||' - Modificado: '||to_char(NEW.dt_atualizacao_nrec, 'dd/mm/yyyy hh24:mi:ss')||chr(13)||chr(10);
		end if;
		
		if (NEW.nr_seq_grau_partic is null and OLD.nr_seq_grau_partic is not null ) or (NEW.nr_seq_grau_partic <> OLD.nr_seq_grau_partic) or (NEW.nr_seq_prestador_exec is null and OLD.nr_seq_prestador_exec is not null) or (NEW.nr_seq_prestador_exec <> OLD.nr_seq_prestador_exec ) or (NEW.cd_medico_executor	is null and OLD.cd_medico_executor is not null) or (NEW.cd_medico_executor 	<> OLD.cd_medico_executor )then
			ie_opcao_w := '2';
		else
			ie_opcao_w := '1';
		end if;
		
		insert into plsprco_cta( 	nr_sequencia, dt_atualizacao, nm_usuario,
							dt_atualizacao_nrec, nm_usuario_nrec, nm_tabela,
							ds_log, ds_log_call, ds_funcao_ativa, 
							ie_aplicacao_tasy, nm_maquina, ie_opcao,
							nr_seq_conta)
				values ( 	nextval('plsprco_cta_seq'), LOCALTIMESTAMP, substr(coalesce(wheb_usuario_pck.get_nm_usuario,'Usuario nao identificado '),1,14),
							LOCALTIMESTAMP, substr(coalesce(wheb_usuario_pck.get_nm_usuario,'Usuario nao identificado '),1,14), 'PLS_CONTA', 
							ds_observacao_w, ds_log_call_w, obter_funcao_ativa, 
							pls_se_aplicacao_tasy, wheb_usuario_pck.get_machine, ie_opcao_w,
							OLD.nr_sequencia);
		--end if;

	end if;
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_conta_alt() FROM PUBLIC;

CREATE TRIGGER pls_conta_alt
	BEFORE UPDATE ON pls_conta FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_conta_alt();
