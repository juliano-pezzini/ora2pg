-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cta_gera_hono_cirurgia_pck.gera_log_exec_cirurgica ( nr_seq_exec_cirurgica_p pls_execucao_cirurgica.nr_sequencia%type, nr_seq_conta_origem_p pls_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_exec_cirurg_guia_p pls_exec_cirurgica_guia.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

					
ds_log_call_w	varchar(1500);


BEGIN

	ds_log_call_w := substr(	' Funcao ativa : '|| obter_funcao_ativa || chr(13) ||chr(10)||
					' CallStack: '|| chr(13) || chr(10)|| dbms_utility.format_call_stack,1,1500);
					
	insert into pls_exec_cirurgica_log(cd_estabelecimento, ds_log, dt_atualizacao,
	dt_atualizacao_nrec, ie_tipo_log, nm_usuario,
	nm_usuario_nrec, nr_seq_exec_cirurgica, nr_sequencia,
	nr_seq_conta, nr_seq_exec_cir_guia)
	values ( cd_estabelecimento_p, 'Abertura contas -> Exec cirurg '||nr_seq_exec_cirurgica_p||'. Conta origem '||
		nr_seq_conta_origem_p||' Conta gerada '||nr_seq_conta_p||' stacktrace -> '||ds_log_call_w,clock_timestamp(),
		clock_timestamp(), 'C', nm_usuario_p,
		nm_usuario_p, nr_seq_exec_cirurgica_p, nextval('pls_exec_cirurgica_log_seq'),
		nr_seq_conta_p, nr_seq_exec_cirurg_guia_p);

end;					

-- gera outra conta para abertura do participante
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_gera_hono_cirurgia_pck.gera_log_exec_cirurgica ( nr_seq_exec_cirurgica_p pls_execucao_cirurgica.nr_sequencia%type, nr_seq_conta_origem_p pls_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_exec_cirurg_guia_p pls_exec_cirurgica_guia.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
