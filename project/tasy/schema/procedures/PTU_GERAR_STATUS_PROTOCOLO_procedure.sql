-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_status_protocolo ( nr_seq_protocolo_p ptu_solicitacao_pa.nr_seq_protocolo%type, nr_seq_status_pa_p INOUT ptu_consulta_status_pa.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_operadora_origem_w		ptu_solicitacao_pa.cd_operadora_origem%type;
cd_operadora_destino_w		ptu_solicitacao_pa.cd_operadora_destino%type;
cd_operadora_w			ptu_solicitacao_pa.cd_operadora%type;
cd_usuario_plano_w		ptu_solicitacao_pa.cd_usuario_plano%type;
nr_protocolo_w			pls_protocolo_atendimento.nr_protocolo%type;
nr_seq_controle_exec_w		ptu_consulta_status_pa.nr_seq_execucao%type;


BEGIN

select	cd_operadora_origem,
	cd_operadora_destino,
	cd_operadora,
	cd_usuario_plano
into STRICT	cd_operadora_origem_w,
	cd_operadora_destino_w,
	cd_operadora_w,
	cd_usuario_plano_w
from	ptu_solicitacao_pa
where	nr_seq_protocolo	= nr_seq_protocolo_p;

select	nr_protocolo
into STRICT	nr_protocolo_w
from	pls_protocolo_atendimento
where	nr_sequencia		= nr_seq_protocolo_p;

select	nextval('gestao_protocolo_atend_seq')
into STRICT	nr_seq_controle_exec_w
;

insert into ptu_consulta_status_pa(
		nr_sequencia, cd_estabelecimento, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		cd_transacao, ie_tipo_cliente, cd_operadora_origem,
		cd_operadora_destino, nr_registro_ans, nr_seq_execucao,
		dt_geracao, cd_operadora, cd_usuario_plano,
		nr_protocolo, nr_versao, nr_seq_protocolo)
values (
		nextval('ptu_consulta_status_pa_seq'), cd_estabelecimento_p, clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p,
		'006', 'UNIMED', cd_operadora_origem_w,
		cd_operadora_destino_w, null, nr_seq_controle_exec_w,
		clock_timestamp(), cd_operadora_w, cd_usuario_plano_w,
		nr_protocolo_w, '001', nr_seq_protocolo_p) returning nr_sequencia into nr_seq_status_pa_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_status_protocolo ( nr_seq_protocolo_p ptu_solicitacao_pa.nr_seq_protocolo%type, nr_seq_status_pa_p INOUT ptu_consulta_status_pa.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

