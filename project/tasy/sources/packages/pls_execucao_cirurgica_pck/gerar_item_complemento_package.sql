-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_execucao_cirurgica_pck.gerar_item_complemento ( nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, ie_origem_proced_p procedimento.ie_origem_proced%type, cd_procedimento_p procedimento.cd_procedimento%type, qt_procedimento_p pls_requisicao_proc.qt_solicitado%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


nr_seq_proc_w				pls_requisicao_proc.nr_sequencia%type;
ie_tipo_intercambio_w			pls_requisicao.ie_tipo_intercambio%type;
ie_tipo_processo_w			pls_requisicao.ie_tipo_processo%type;


BEGIN

insert into pls_requisicao_proc(nr_sequencia, nm_usuario, nm_usuario_nrec,
	dt_atualizacao, dt_atualizacao_nrec, ie_origem_proced,
	cd_procedimento, qt_procedimento, ie_status,          
	ie_estagio, nr_seq_requisicao, qt_solicitado,
	qt_proc_executado, ie_origem_inclusao)
values (nextval('pls_requisicao_proc_seq'), nm_usuario_p, nm_usuario_p,
	clock_timestamp(), clock_timestamp(), ie_origem_proced_p,
	cd_procedimento_p, 0, 'U',
	'AE', nr_seq_requisicao_p, qt_procedimento_p,
	0, 'P') returning nr_sequencia into nr_seq_proc_w;

commit;

CALL pls_atualiza_valor_proc_aut(nr_seq_proc_w, 'R', nm_usuario_p);
CALL pls_lanc_auto_requisicao(nr_seq_requisicao_p, nr_seq_proc_w, null, nm_usuario_p, cd_estabelecimento_p, 'LR');

begin
	select	ie_tipo_intercambio,
		ie_tipo_processo
	into STRICT	ie_tipo_intercambio_w,
		ie_tipo_processo_w
	from	pls_requisicao
	where 	nr_sequencia = nr_seq_requisicao_p;
exception
when others then
	ie_tipo_intercambio_w := null;
	ie_tipo_processo_w := null;
end;

if (ie_tipo_intercambio_w = 'I' and ie_tipo_processo_w = 'I') then
	CALL pls_inserir_obs_regra_intercam( nr_seq_proc_w, null, 'P', nm_usuario_p);
	CALL pls_gerar_de_para_req_intercam( nr_seq_proc_w, null, null,
					null, null, null,
					null, cd_estabelecimento_p, nm_usuario_p);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_execucao_cirurgica_pck.gerar_item_complemento ( nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, ie_origem_proced_p procedimento.ie_origem_proced%type, cd_procedimento_p procedimento.cd_procedimento%type, qt_procedimento_p pls_requisicao_proc.qt_solicitado%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;