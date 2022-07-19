-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_guia_req_ordem_serv ( nr_seq_req_ord_serv_p bigint, ie_tipo_guia_p text, nr_seq_motivo_inclusao_p bigint, ds_indicacao_clinica_p text, ds_observacao_p text, ie_consulta_urgencia_p text, ie_opcao_p text, sg_conselho_p text, qt_dia_solicitado_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_guia_p INOUT bigint, nr_seq_requisicao_p INOUT bigint) AS $body$
DECLARE


nr_seq_conselho_w		conselho_profissional.nr_sequencia%type;
cd_senha_w			pls_guia_plano.cd_senha_externa%type;
dt_validade_w			pls_guia_plano.dt_valid_senha_ext%type;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_conselho_w
from	conselho_profissional
where	sg_conselho = sg_conselho_p;

begin
select	nr_seq_origem,
	dt_validade
into STRICT	cd_senha_w,
	dt_validade_w
from	ptu_autorizacao_ordem_serv
where	nr_sequencia = (SELECT  max(nr_sequencia)
			from	ptu_autorizacao_ordem_serv
			where	nr_transacao_solicitante = (	select	max(nr_transacao_solicitante)
								from	ptu_requisicao_ordem_serv
								where	nr_sequencia = nr_seq_req_ord_serv_p));
exception
when others then
cd_senha_w := '';
dt_validade_w := null;
end;

if (pls_obter_param_atend_geral('FA') = '1') then --OPS - Autorizações
	insert	into pls_guia_plano(nr_sequencia, dt_atualizacao, nm_usuario,
		dt_solicitacao, ie_tipo_guia, ds_indicacao_clinica,
		ds_observacao, ie_carater_internacao, ie_status,
		ie_tipo_processo, cd_estabelecimento, cd_senha_externa,
		dt_valid_senha_ext, nr_seq_conselho, qt_dia_solicitado,
		qt_dia_autorizado)
	values (nextval('pls_guia_plano_seq'), clock_timestamp(), nm_usuario_p,
		clock_timestamp(), ie_tipo_guia_p, ds_indicacao_clinica_p,
		ds_observacao_p, CASE WHEN ie_consulta_urgencia_p='S' THEN  'U' WHEN ie_consulta_urgencia_p='N' THEN  'E'  ELSE 'E' END , '2',
		'I', cd_estabelecimento_p, cd_senha_w,
		dt_validade_w, nr_seq_conselho_w, qt_dia_solicitado_p,
		qt_dia_solicitado_p) returning nr_sequencia into nr_seq_guia_p;

	CALL pls_guia_gravar_historico(nr_seq_guia_p,2,'Criada guia através da função OPS - Ordem de Serviço Intercâmbio','',nm_usuario_p);

	CALL ptu_gerar_autoriz_ordem_serv(nr_seq_req_ord_serv_p, nr_seq_guia_p, null, ie_opcao_p, nm_usuario_p);

elsif (pls_obter_param_atend_geral('FA') = '2') then --OPS - Requisições para Autorização
	insert	into pls_requisicao(nr_sequencia, dt_atualizacao, nm_usuario,
		dt_requisicao, ie_tipo_guia, ds_indicacao_clinica,
		ds_observacao, ie_consulta_urgencia, cd_estabelecimento,
		cd_senha_externa, dt_valid_senha_ext, nr_seq_conselho,
		qt_dia_solicitado, qt_dia_autorizado, nr_seq_motivo_inclusao)
	values (nextval('pls_requisicao_seq'), clock_timestamp(), nm_usuario_p,
		clock_timestamp(), ie_tipo_guia_p, ds_indicacao_clinica_p,
		ds_observacao_p, ie_consulta_urgencia_p, cd_estabelecimento_p,
		cd_senha_w, dt_validade_w, nr_seq_conselho_w,
		qt_dia_solicitado_p, qt_dia_solicitado_p, nr_seq_motivo_inclusao_p) returning nr_sequencia into nr_seq_requisicao_p;

	CALL pls_requisicao_gravar_hist(nr_seq_requisicao_p,'L','Criada requisição através da função OPS - Ordem de Serviço Intercâmbio', null, nm_usuario_p);

	CALL ptu_gerar_autoriz_ordem_serv(nr_seq_req_ord_serv_p, null, nr_seq_requisicao_p, ie_opcao_p, nm_usuario_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_guia_req_ordem_serv ( nr_seq_req_ord_serv_p bigint, ie_tipo_guia_p text, nr_seq_motivo_inclusao_p bigint, ds_indicacao_clinica_p text, ds_observacao_p text, ie_consulta_urgencia_p text, ie_opcao_p text, sg_conselho_p text, qt_dia_solicitado_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_guia_p INOUT bigint, nr_seq_requisicao_p INOUT bigint) FROM PUBLIC;

