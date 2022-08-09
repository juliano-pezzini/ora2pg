-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_atualizar_xml_ws ( ie_tipo_transacao_p bigint, nr_seq_xml_scs_p ptu_xml_scs.nr_sequencia%type, nr_seq_transacao_p ptu_xml_scs_transacao.nr_seq_transacao%type, nm_usuario_p usuario.nm_usuario%type ) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Atualizar cabeçalho do XML gerado, realizar o controle entre a transação e o
arquivo XML gerado na base.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ x Tasy (Delphi/Java) [ x ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:  Esta procedure deve ser utilizada somente no momento de gerar o XML
para enviar para alguma outra operadora ou no momento de gerar o retorno de um arquivo
recebido.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_tipo_transacao_w	varchar(255)	:= 'mensagemPTU';
ds_xml_w		ptu_xml_scs.ds_xml%type;


BEGIN

--00600 - pedidoAutorizacaoWS
if ( ie_tipo_transacao_p = 1 ) then
	ds_tipo_transacao_w := 'pedidoAutorizacaoWS';

--00605 - pedidoComplementoAutorizacaoWS
elsif ( ie_tipo_transacao_p = 3) then
	ds_tipo_transacao_w := 'pedidoComplementoAutorizacaoWS';

--00501 - respostaPedidoAutorizacaoWS
elsif ( ie_tipo_transacao_p in ( 2,4 ) ) then
	ds_tipo_transacao_w := 'respostaPedidoAutorizacaoWS';

--00404 - respostaAuditoriaWS
elsif ( ie_tipo_transacao_p = 7 ) then
	ds_tipo_transacao_w := 'respostaAuditoriaWS';

--00302 - pedidoInsistenciaWS
elsif ( ie_tipo_transacao_p = 5 ) then
	ds_tipo_transacao_w := 'pedidoInsistenciaWS';

--00309 - confirmacaoWS
elsif ( ie_tipo_transacao_p in ( 6,8,10,14,18)	) then
	ds_tipo_transacao_w := 'confirmacaoWS';

--00311 - cancelamentoWS
elsif ( ie_tipo_transacao_p = 9 ) then
	ds_tipo_transacao_w := 'cancelamentoWS';


--00412 - consultaDadosBeneficiarioWS
elsif ( ie_tipo_transacao_p = 30 ) then
	ds_tipo_transacao_w := 'consultaDadosBeneficiarioWS';

--00413 -  respostaConsultaDadosBeneficiarioWS
elsif ( ie_tipo_transacao_p = 31 ) then
	ds_tipo_transacao_w := 'respostaConsultaDadosBeneficiarioWS';

--00418 - consultaDadosPrestadorWS
elsif ( ie_tipo_transacao_p = 32 ) then
	ds_tipo_transacao_w := 'consultaDadosPrestadorWS';

-- 00419 - respostaConsultaDadosPrestadorWS
elsif ( ie_tipo_transacao_p = 33 ) then
	ds_tipo_transacao_w := 'respostaConsultaDadosPrestadorWS';

--00806 - ordemServicoWS
elsif ( ie_tipo_transacao_p = 15 ) then
	ds_tipo_transacao_w := 'ordemServicoWS';

--00807 - respostaOrdemServicoWS
elsif ( ie_tipo_transacao_p = 16 ) then
	ds_tipo_transacao_w := 'respostaOrdemServicoWS';

--00430 - requisicaoContagemBeneficiariosWS
--00331 - respostaRequisicaoContagemBeneficiariosWS
elsif ( ie_tipo_transacao_p = 35 ) then
	ds_tipo_transacao_w := 'respostaRequisicaoContagemBeneficiariosWS';

--00360 - statusTransacaoWS
elsif ( ie_tipo_transacao_p = 11 ) then
	ds_tipo_transacao_w := 'statusTransacaoWS';

--00361 - respostaStatusTransacaoWS
elsif ( ie_tipo_transacao_p = 12 ) then
	ds_tipo_transacao_w := 'respostaStatusTransacaoWS';

--00700 - comunicacaoDecursoPrazoWS
elsif ( ie_tipo_transacao_p = 13 ) then
	ds_tipo_transacao_w := 'comunicacaoDecursoPrazoWS';

--00804 - autorizacaoOrdemServicoWS
elsif ( ie_tipo_transacao_p = 17 ) then
	ds_tipo_transacao_w := 'autorizacaoOrdemServicoWS';
--01100 - consultaA1100WS
elsif ( ie_tipo_transacao_p = 36 ) then
	ds_tipo_transacao_w := 'consultaA1100WS';
--01101 - respostaA1100WS
elsif ( ie_tipo_transacao_p = 37 ) then
	ds_tipo_transacao_w := 'respostaA1100WS';
--00750 -  comunicacaoInternacaoAltaWS
elsif ( ie_tipo_transacao_p = 38 ) then
	ds_tipo_transacao_w := 'comunicacaoInternacaoAltaWS';
end if;


if (nr_seq_xml_scs_p IS NOT NULL AND nr_seq_xml_scs_p::text <> '') then
	select	ds_xml
	into STRICT	ds_xml_w
	from	ptu_xml_scs
	where	nr_sequencia	= nr_seq_xml_scs_p;

	--Atualizaca o cabeçalho do arquivo XML antes de enviar, para ficar igual ao padrão do WSDL
	ds_xml_w := replace(ds_xml_w, 'mensagemPTU', ds_tipo_transacao_w);

	update	ptu_xml_scs
	set	ds_xml 		= ds_xml_w,
		dt_atualizacao 	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_xml_scs_p;

	insert into ptu_xml_scs_transacao(
		nr_sequencia, dt_atualizacao, nm_usuario,
		dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_xml_scs,
		nr_seq_transacao, ie_tipo_transacao)
	values (	nextval('ptu_xml_scs_transacao_seq'), clock_timestamp(), nm_usuario_p,
		clock_timestamp(), nm_usuario_p, nr_seq_xml_scs_p,
		nr_seq_transacao_p, ie_tipo_transacao_p);

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_atualizar_xml_ws ( ie_tipo_transacao_p bigint, nr_seq_xml_scs_p ptu_xml_scs.nr_sequencia%type, nr_seq_transacao_p ptu_xml_scs_transacao.nr_seq_transacao%type, nm_usuario_p usuario.nm_usuario%type ) FROM PUBLIC;
