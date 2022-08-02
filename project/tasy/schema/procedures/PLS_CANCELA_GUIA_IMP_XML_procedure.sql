-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_cancela_guia_imp_xml ( nr_seq_lote_cancel_p pls_guia_plano_lote_cancel.nr_sequencia%type, ie_tipo_guia_imp_p text, cd_cgc_prestador_imp_p text, nr_protocolo_imp_p text, cd_guia_prestador_imp_p text, cd_guia_operadora_imp_p text, cd_prestador_imp_p text, cd_cpf_prestador_imp_p text, nm_contratado_imp_p text, nm_usuario_p text, nr_seq_cancelamento_p INOUT pls_guia_plano_cancel.nr_sequencia%type, nr_seq_guia_p INOUT pls_guia_plano.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Solicitar o cancelamento da guia, via importação XML (CANCELA_GUIA)
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [X] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
	

ie_status_w			pls_guia_plano_cancel.ie_status%type := '4';	--Em análise	
nr_seq_prestador_w		pls_prestador.nr_sequencia%type;
nr_seq_guia_w			pls_guia_plano.nr_sequencia%type := null;
nr_seq_solic_cancel_w		pls_guia_plano_cancel.nr_sequencia%type := null;
nr_seq_requisicao_w		pls_requisicao.nr_sequencia%type := null;
ie_execucao_posterior_w		pls_param_importacao_guia.ie_execucao_posterior%type;

ie_funcao_autorizador_w		pls_param_atend_geral.ie_funcao_autorizador%type;


BEGIN

begin
	select	coalesce(max(ie_execucao_posterior),'N')
	into STRICT	ie_execucao_posterior_w --Tratamento realizado para o projeto das OS 1127701 e 1759957
	from	pls_param_importacao_guia;
exception
when others then
	ie_execucao_posterior_w := 'N';
end;

select	nextval('pls_guia_plano_cancel_seq')
into STRICT	nr_seq_solic_cancel_w
;

if (cd_cgc_prestador_imp_p IS NOT NULL AND cd_cgc_prestador_imp_p::text <> '') then
	nr_seq_prestador_w := pls_obter_guia_tiss_prest_cgc( cd_cgc_prestador_imp_p, cd_guia_prestador_imp_p, cd_guia_operadora_imp_p, 'CA', null);
else
	select	max(nr_seq_prestador)
	into STRICT	nr_seq_prestador_w
	from	pls_guia_plano_lote_cancel
	where	nr_sequencia = nr_seq_lote_cancel_p;
end if;
-- Tratamento feito devido a uso da regra 'Disponibilizar requisicao para execucao futura' em OPS - Gestao de Operadoras > Parametros da OPS > Importacao XML guia, 

-- caso use a regra, tenta identificar primeiro se existe uma requisicao com a sequencia antes de verificar as guias.
if (ie_execucao_posterior_w = 'S') then
	begin
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_requisicao_w
		from	pls_requisicao a
		where	a.nr_seq_prestador	= nr_seq_prestador_w
		and	((a.nr_sequencia	= cd_guia_operadora_imp_p AND cd_guia_operadora_imp_p IS NOT NULL AND cd_guia_operadora_imp_p::text <> '')
		or	(a.cd_guia_prestador	= cd_guia_prestador_imp_p AND cd_guia_prestador_imp_p IS NOT NULL AND cd_guia_prestador_imp_p::text <> ''))
		and	a.ie_origem_solic	= 'W'
		and	not exists (SELECT 1
					from	pls_execucao_req_item b
					where	b.nr_seq_requisicao = a.nr_sequencia);
	exception
	when others then
		nr_seq_requisicao_w := null;
		nr_seq_guia_w		:= null;
	end;
else
	nr_seq_requisicao_w	:= null;
	nr_seq_guia_w		:= null;
end if;

--Se for informado o código de guia na Operadora o sistema irá validar pela guia na Operadora
if (cd_guia_operadora_imp_p IS NOT NULL AND cd_guia_operadora_imp_p::text <> '') then
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_guia_w
	from	pls_guia_plano a
	where	a.nr_seq_prestador 	= nr_seq_prestador_w
	and	a.cd_guia 		= cd_guia_operadora_imp_p;
else	
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_guia_w
	from	pls_guia_plano a
	where	a.nr_seq_prestador 	= nr_seq_prestador_w
	and	a.cd_guia_prestador	= cd_guia_prestador_imp_p;
end if;

if (coalesce(nr_seq_requisicao_w::text, '') = '') then
	if (coalesce(nr_seq_guia_w::text, '') = '') then
		ie_status_w := '3'; --Guia inexistente
	else
		select	max(nr_seq_requisicao)
		into STRICT	nr_seq_requisicao_w
		from	pls_guia_plano_imp
		where	nr_seq_guia_plano = nr_seq_guia_w;
	end if;
end if;

-- Tratamento para que não permita cancelar somente a guia quando a operadora utilizar a função de requisição de autorização
ie_funcao_autorizador_w	:= pls_obter_param_atend_geral('FA');

if (coalesce(ie_funcao_autorizador_w, '1') = '2') then
	if	((nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') and (coalesce(nr_seq_requisicao_w::text, '') = '')) then
		ie_status_w := '2'; --Não cancelado
	end if;
end if;

update	pls_guia_plano_lote_cancel
set	nr_seq_prestador = nr_seq_prestador_w
where	nr_sequencia = nr_seq_lote_cancel_p;

insert into pls_guia_plano_cancel(	nr_sequencia, dt_atualizacao, nm_usuario,
					dt_atualizacao_nrec, nm_usuario_nrec, ie_tipo_guia_imp,
					nr_protocolo_imp, cd_guia_prestador_imp, cd_prestador_imp,
					cd_cgc_prestador_imp, cd_cpf_prestador_imp, nm_contratado_imp,
					nr_seq_guia, nr_seq_lote_cancel, ie_status,
					cd_guia_operadora_imp, nr_seq_requisicao )
			   values ( 	nr_seq_solic_cancel_w, clock_timestamp(), nm_usuario_p, 
					clock_timestamp(), nm_usuario_p, ie_tipo_guia_imp_p,
					nr_protocolo_imp_p,cd_guia_prestador_imp_p, cd_prestador_imp_p,
					cd_cgc_prestador_imp_p, cd_cpf_prestador_imp_p, nm_contratado_imp_p,
					nr_seq_guia_w, nr_seq_lote_cancel_p, ie_status_w,
					cd_guia_operadora_imp_p, nr_seq_requisicao_w );	

commit;	

nr_seq_cancelamento_p 	:= nr_seq_solic_cancel_w;
nr_seq_guia_p		:= nr_seq_guia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cancela_guia_imp_xml ( nr_seq_lote_cancel_p pls_guia_plano_lote_cancel.nr_sequencia%type, ie_tipo_guia_imp_p text, cd_cgc_prestador_imp_p text, nr_protocolo_imp_p text, cd_guia_prestador_imp_p text, cd_guia_operadora_imp_p text, cd_prestador_imp_p text, cd_cpf_prestador_imp_p text, nm_contratado_imp_p text, nm_usuario_p text, nr_seq_cancelamento_p INOUT pls_guia_plano_cancel.nr_sequencia%type, nr_seq_guia_p INOUT pls_guia_plano.nr_sequencia%type) FROM PUBLIC;

