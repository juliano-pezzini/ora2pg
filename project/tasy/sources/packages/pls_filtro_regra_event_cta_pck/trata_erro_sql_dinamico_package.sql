-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_filtro_regra_event_cta_pck.trata_erro_sql_dinamico ( nr_seq_regra_filtro_p pls_pp_cta_filtro.nr_sequencia%type, ds_select_p text, nr_id_transacao_p pls_pp_cta_selecao.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type, ie_grava_log_p text default 'S') AS $body$
DECLARE

					
ds_log_w	pls_pp_cta_log_erro.ds_log%type;


BEGIN
-- Desfazer qualquer alteracao anterior;

rollback;

-- Limpar a tabela de selecao.

CALL CALL CALL CALL CALL pls_filtro_regra_event_cta_pck.limpar_transacao(nr_id_transacao_p);

-- como isso e chamado varias vezes dentro das rotinas foi criado este parametro com default para nao gravar o registro 

-- e grava somente no tratamento de excecao desta package

if (ie_grava_log_p = 'S') then
	
	-- Se nao foi preenchido ainda entao preenche com o atual.

	if (current_setting('pls_filtro_regra_event_cta_pck.ds_sql_erro_w')::coalesce(varchar(32000)::text, '') = '') then
		-- obter o callstack

		PERFORM set_config('pls_filtro_regra_event_cta_pck.ds_stack_w', dbms_utility.format_call_stack, false);
		PERFORM set_config('pls_filtro_regra_event_cta_pck.ds_err_stack_w', dbms_utility.format_error_backtrace, false);
		PERFORM set_config('pls_filtro_regra_event_cta_pck.ds_sql_erro_w', ds_select_p, false);
		PERFORM set_config('pls_filtro_regra_event_cta_pck.ds_sqlerrm_w', sqlerrm, false);
	end if;
	
	-- Obter o log a ser gravado

	ds_log_w := substr(	'Filtro: ' || nr_seq_regra_filtro_p || pls_util_pck.enter_w ||
				'Erro: ' || current_setting('pls_filtro_regra_event_cta_pck.ds_sqlerrm_w')::varchar(4000) || pls_util_pck.enter_w || pls_util_pck.enter_w ||
				'SQL: ' || pls_util_pck.enter_w ||
				current_setting('pls_filtro_regra_event_cta_pck.ds_sql_erro_w')::varchar(32000) ||pls_util_pck.enter_w|| pls_util_pck.enter_w ||
				'Stack:' || pls_util_pck.enter_w ||
				current_setting('pls_filtro_regra_event_cta_pck.ds_stack_w')::varchar(4000) || pls_util_pck.enter_w ||
				'Error Back Trace: ' || pls_util_pck.enter_w ||
				current_setting('pls_filtro_regra_event_cta_pck.ds_err_stack_w')::varchar(4000),1,4000);
				
	-- Anula os dados para a proxima execucao.

	PERFORM set_config('pls_filtro_regra_event_cta_pck.ds_sql_erro_w', null, false);
	PERFORM set_config('pls_filtro_regra_event_cta_pck.ds_stack_w', null, false);
	PERFORM set_config('pls_filtro_regra_event_cta_pck.ds_err_stack_w', null, false);
	
	-- Grava o log na tabela;

	insert into pls_pp_cta_log_erro(nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nr_id_transacao,
		ds_log,
		ie_local_log)
	values (nextval('pls_pp_cta_log_erro_seq'),
		nm_usuario_p,
		clock_timestamp(),
		nr_id_transacao_p,
		ds_log_w,
		'1');
		
	-- Gravar alteracoes

	commit;	
else
	-- Se nao salva o erro para usar depois,

	PERFORM set_config('pls_filtro_regra_event_cta_pck.ds_sql_erro_w', ds_select_p, false);
	-- obter o callstack

	PERFORM set_config('pls_filtro_regra_event_cta_pck.ds_stack_w', dbms_utility.format_call_stack, false);
	PERFORM set_config('pls_filtro_regra_event_cta_pck.ds_err_stack_w', dbms_utility.format_error_backtrace, false);
	PERFORM set_config('pls_filtro_regra_event_cta_pck.ds_sqlerrm_w', sqlerrm, false);
end if;

CALL wheb_mensagem_pck.exibir_mensagem_abort(	383703,	'SEQREGRA=' || nr_seq_regra_filtro_p ||
						';ERRO=' || current_setting('pls_filtro_regra_event_cta_pck.ds_sql_erro_w')::varchar(32000) || ' ' || current_setting('pls_filtro_regra_event_cta_pck.ds_stack_w')::varchar(4000) || ' ' || current_setting('pls_filtro_regra_event_cta_pck.ds_err_stack_w')::varchar(4000) || ' ' || current_setting('pls_filtro_regra_event_cta_pck.ds_sqlerrm_w')::varchar(4000));

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_filtro_regra_event_cta_pck.trata_erro_sql_dinamico ( nr_seq_regra_filtro_p pls_pp_cta_filtro.nr_sequencia%type, ds_select_p text, nr_id_transacao_p pls_pp_cta_selecao.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type, ie_grava_log_p text default 'S') FROM PUBLIC;
