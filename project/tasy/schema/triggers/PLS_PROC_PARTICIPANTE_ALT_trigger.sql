-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_proc_participante_alt ON pls_proc_participante CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_proc_participante_alt() RETURNS trigger AS $BODY$
declare
	ds_log_call_w 	varchar(1500);
	ds_observacao_w	varchar(4000);
	ie_opcao_w	varchar(3);
BEGIN 
if (NEW.nr_seq_grau_partic 	is null and OLD.nr_seq_grau_partic is not null ) or (NEW.nr_seq_grau_partic 	<> OLD.nr_seq_grau_partic) or (NEW.nr_seq_prestador 		is null and OLD.nr_seq_prestador is not null) or (NEW.nr_seq_prestador	 	<> OLD.nr_seq_prestador ) or (NEW.cd_medico			is null and OLD.cd_medico is not null) or (NEW.cd_medico		 	<> OLD.cd_medico )then 
	ie_opcao_w := '2';
else 
	ie_opcao_w := '1';
end if;
 
if	(( pls_se_aplicacao_tasy = 'N') and (coalesce(wheb_usuario_pck.get_nm_usuario,'X') = 'X')) or (NEW.nr_seq_grau_partic 	is null and OLD.nr_seq_grau_partic is not null ) or (NEW.nr_seq_grau_partic 	<> OLD.nr_seq_grau_partic) or (NEW.nr_seq_prestador 		is null and OLD.nr_seq_prestador is not null) or (NEW.nr_seq_prestador	 	<> OLD.nr_seq_prestador ) or (NEW.cd_medico			is null and OLD.cd_medico is not null) or (NEW.cd_medico		 	<> OLD.cd_medico )then 
	 
	ds_log_call_w := substr(pls_obter_detalhe_exec(false),1,1500);/*substr(	' Função ativa : '|| obter_funcao_ativa || chr(13) ||chr(10)|| 
			' CallStack: '|| chr(13) || chr(10)|| dbms_utility.format_call_stack,1,1500);*/
 
			--' Função ativa : '|| obter_funcao_ativa || chr(13) ||chr(10)|| 
	ds_observacao_w := 'Conta partic: '||OLD.nr_sequencia||' ; Conta proc: '||OLD.nr_seq_conta_proc;
	 
	 
	if (coalesce(OLD.nr_seq_prestador,0) <> coalesce(NEW.nr_seq_prestador,0)) then 
		ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
					'Prestador executor: '||chr(13)||chr(10)|| 
					chr(9)||'Anterior: '||pls_obter_dados_prestador(OLD.nr_seq_prestador,'N')||' - Modificado: '||pls_obter_dados_prestador(NEW.nr_seq_prestador,'N')||chr(13)||chr(10);
	end if;
 
	if (coalesce(OLD.nr_seq_grau_partic,0) <> coalesce(NEW.nr_seq_grau_partic,0)) then 
		ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
					'Grau de participação: '||chr(13)||chr(10)|| 
					chr(9)||'Anterior: '||OLD.nr_seq_grau_partic||' - Modificado: '||NEW.nr_seq_grau_partic||chr(13)||chr(10);
	end if;
	 
	if (coalesce(OLD.cd_medico,'X') <> coalesce(NEW.cd_medico,'X')) then 
		ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
					'Médico: '||chr(13)||chr(10)|| 
					chr(9)||'Anterior: '||OLD.cd_medico||' - Modificado: '||NEW.cd_medico||chr(13)||chr(10);
	end if;
	 
	insert into plsprco_cta( 	nr_sequencia, dt_atualizacao, nm_usuario, 
						dt_atualizacao_nrec, nm_usuario_nrec, nm_tabela, 
						ds_log, ds_log_call, ds_funcao_ativa, 
						ie_aplicacao_tasy, nm_maquina,ie_opcao, 
						nr_seq_conta_proc_partic) 
			values ( 	nextval('plsprco_cta_seq'), LOCALTIMESTAMP, substr(coalesce(wheb_usuario_pck.get_nm_usuario,'Usuário não identificado '),1,14), 
						LOCALTIMESTAMP, substr(coalesce(wheb_usuario_pck.get_nm_usuario,'Usuário não identificado '),1,14), 'PLS_PROC_PARTICIPANTE', 
						ds_observacao_w, ds_log_call_w, obter_funcao_ativa, 
						pls_se_aplicacao_tasy, wheb_usuario_pck.get_machine, ie_opcao_w, 
						OLD.nr_sequencia);
	--end if; 
end if;
 
if (TG_OP = 'UPDATE') and 
	((OLD.nr_id_analise is not null) and ((NEW.nr_id_analise is null) or (OLD.nr_id_analise != NEW.nr_id_analise)))then 
	 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(247472);
end if;
 
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_proc_participante_alt() FROM PUBLIC;

CREATE TRIGGER pls_proc_participante_alt
	BEFORE UPDATE ON pls_proc_participante FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_proc_participante_alt();

