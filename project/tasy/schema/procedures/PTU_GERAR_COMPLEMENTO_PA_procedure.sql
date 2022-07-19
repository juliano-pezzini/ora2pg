-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_complemento_pa ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Gerar o complemento do pedido do protocolo de atendimento 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção:Performance. 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;

cd_usuario_plano_w		pls_segurado_carteira.cd_usuario_plano%type;

nr_seq_protocolo_w		pls_protocolo_atendimento.nr_sequencia%type;
nr_protocolo_referencia_w	pls_protocolo_atendimento.nr_protocolo_referencia%type;

cd_cgc_outorgante_w		pls_outorgante.cd_cgc_outorgante%type;

cd_cooperativa_w		pls_congenere.cd_cooperativa%type;
cd_congenere_w			pls_congenere.cd_cooperativa%type;

nr_seq_controle_exec_w		ptu_controle_execucao.nr_sequencia%type;

nr_seq_execucao_w		ptu_resp_solicitacao_pa.nr_seq_execucao%type;
nr_protocolo_w			ptu_resp_solicitacao_pa.nr_protocolo%type;


BEGIN 
 
goto final;
-- Obter dados da Requisição / Guia 
if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then 
	 
	begin 
		select	nr_seq_segurado 
		into STRICT	nr_seq_segurado_w 
		from	pls_requisicao 
		where	nr_sequencia	= nr_seq_requisicao_p;
	exception 
	when others then 
		nr_seq_segurado_w	:= null;
	end;
 
	begin 
		select	nr_sequencia 
		into STRICT	nr_seq_protocolo_w 
		from	pls_protocolo_atendimento 
		where	nr_seq_requisicao	= nr_seq_requisicao_p;
	exception 
	when others then 
		nr_seq_protocolo_w	:= null;
	end;
	 
	begin 
		select	max(nr_seq_execucao) 
		into STRICT	nr_seq_execucao_w 
		from	ptu_pedido_autorizacao 
		where	nr_seq_requisicao	= nr_seq_requisicao_p;
	exception 
	when others then 
		nr_seq_execucao_w	:= null;
	end;	
	 
elsif (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then 
	 
	begin 
		select	nr_seq_segurado 
		into STRICT	nr_seq_segurado_w 
		from	pls_guia_plano 
		where	nr_sequencia	= nr_seq_guia_p;
	exception 
	when others then 
		nr_seq_segurado_w	:= null;
	end;
	 
	begin 
		select	nr_sequencia 
		into STRICT	nr_seq_protocolo_w 
		from	pls_protocolo_atendimento 
		where	nr_seq_guia	= nr_seq_guia_p;	
	exception 
	when others then 
		nr_seq_protocolo_w	:= null;
	end;
	 
	begin 
		select	max(nr_seq_execucao) 
		into STRICT	nr_seq_execucao_w 
		from	ptu_pedido_autorizacao 
		where	nr_seq_guia	= nr_seq_guia_p;
	exception 
	when others then 
		nr_seq_execucao_w	:= null;
	end;	
end if;
 
-- Obter dados do segurado 
if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then 
 
	cd_usuario_plano_w	:= pls_obter_dados_segurado(nr_seq_segurado_w,'C');
	cd_congenere_w		:= pls_obter_unimed_benef(nr_seq_segurado_w);
end if;
 
-- Obter dados do protocolo 
if (nr_seq_protocolo_w IS NOT NULL AND nr_seq_protocolo_w::text <> '') then 
	 
	begin 
		select	nr_protocolo_referencia 
		into STRICT	nr_protocolo_referencia_w 
		from	pls_protocolo_atendimento 
		where	nr_sequencia	= nr_seq_protocolo_w;
	exception 
	when others then 
		nr_protocolo_referencia_w	:= null;
	end;
	 
	begin 
		select	nr_protocolo 
		into STRICT	nr_protocolo_w 
		from	ptu_resp_solicitacao_pa 
		where	nr_seq_protocolo	= nr_seq_protocolo_w;	
	exception 
	when others then 
		nr_protocolo_w		:= null;
	end;
end if;
 
-- Obter dados da operadora 
select	max(cd_cgc_outorgante) 
into STRICT	cd_cgc_outorgante_w 
from	pls_outorgante;
 
select	max(cd_cooperativa) 
into STRICT	cd_cooperativa_w 
from	pls_congenere 
where	cd_cgc			= cd_cgc_outorgante_w 
and	(cd_cooperativa IS NOT NULL AND cd_cooperativa::text <> '');
 
select	nextval('gestao_protocolo_atend_seq') 
into STRICT	nr_seq_controle_exec_w
;
 
   
 
insert into ptu_complemento_pa( 
	nr_sequencia, 			cd_estabelecimento, 			dt_atualizacao, 
	nm_usuario, 			dt_atualizacao_nrec, 			nm_usuario_nrec, 
	cd_transacao, 			ie_tipo_cliente, 			cd_operadora_origem, 
	cd_operadora_destino, 		nr_registro_ans, 			nr_seq_execucao, 
	dt_geracao, 			cd_operadora, 				cd_usuario_plano, 
	nr_protocolo, 			nr_trans_intercambio, 			nr_versao, 
	nr_seq_protocolo 
	) 
values ( 
	nextval('ptu_complemento_pa_seq'),	cd_estabelecimento_p,		clock_timestamp(), 
	nm_usuario_p,			clock_timestamp(),			nm_usuario_p, 
	'003',				'U',			cd_cooperativa_w, 
	cd_congenere_w,			null,				nr_seq_controle_exec_w, 
	clock_timestamp(),			substr(cd_usuario_plano_w,1,4),	substr(cd_usuario_plano_w,5,13), 
	nr_protocolo_w,			nr_seq_execucao_w,		'001', 
	nr_seq_protocolo_w);
 
<<final>> 
-- SOMENTE PORQUE PRECISA EXISTIR UMA LINHA DEPOIS DO <<FINAL>>. NESTE MOMENTO NÃO VAMOS ENVIAR A SOLICITAÇÃO DE PROTOCOLO DE ATENDIMENTO. 
nr_protocolo_w	:= '';
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_complemento_pa ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

