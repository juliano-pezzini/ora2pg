-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_oc_cta_obter_rest_pres_pag (dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_filtro_prest_p pls_tipos_ocor_pck.dados_filtro_prest, ie_incidencia_regra_p text) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Obter o acesso a tabela pls_prestador que será utilizado  para verificar o select
	dos filtros de prestador.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Realizar tratamento para os campos IMP quando hourver necessidade

Alterações:
------------------------------------------------------------------------------------------------------------------
jjung OS 597795 10/06/2013 -	Criação da function.
------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_filtro_prest_w	varchar(4000);

BEGIN

--Inicializar as variáveis.
ds_filtro_prest_w	:= null;

-- É obrigatório que o campo IE_TIPO_PRESTADOR esteja informado para que a regra seja verificada.
if (dados_filtro_prest_p.ie_tipo_prestador IS NOT NULL AND dados_filtro_prest_p.ie_tipo_prestador::text <> '') then
	-- Aqui verifca qual prestador da conta será utilizado, se atendimento, executor, solicitante ou de pagamento.
	if (dados_filtro_prest_p.ie_tipo_prestador = 'P') then
		-- Verificar a incidencia da regra para poder identificar de onde deve ser buscada a informação do prestador de pagamento.
		-- Conta
		if (ie_incidencia_regra_p in ('C', 'PM', 'RV')) then

			-- Quando for para gerar a ocorrência na conta então deve ser verificado se o prestador que está sendo filtrado na regra é prestador de pagamento de algum item na conta.
			ds_filtro_prest_w :=	ds_filtro_prest_w || pls_tipos_ocor_pck.enter_w ||
						'			and	exists ( ' || pls_tipos_ocor_pck.enter_w ||
						'					select	1 '|| pls_tipos_ocor_pck.enter_w ||
						'					from 	pls_conta_proc a '|| pls_tipos_ocor_pck.enter_w ||
						'					where 	a.nr_seq_conta = conta.nr_sequencia '|| pls_tipos_ocor_pck.enter_w ||
						'					and 	prest.nr_sequencia in (	a.nr_seq_prestador_pgto, '|| pls_tipos_ocor_pck.enter_w ||
						'									nvl(a.nr_seq_prestador_pgto, conta.nr_seq_prestador_exec), '|| pls_tipos_ocor_pck.enter_w ||
						'									a.nr_seq_prest_pgto_medico, '|| pls_tipos_ocor_pck.enter_w ||
						'									(select	max(b.nr_seq_prestador_pgto) '|| pls_tipos_ocor_pck.enter_w ||
						'									 from	pls_proc_participante b '|| pls_tipos_ocor_pck.enter_w ||
						'									 where	b.nr_seq_conta_proc = a.nr_sequencia '|| pls_tipos_ocor_pck.enter_w ||
						'									 and	b.ie_status <> ''C'' '|| pls_tipos_ocor_pck.enter_w ||
						'									 and b.nr_seq_prestador_pgto = prest.nr_sequencia)) '|| pls_tipos_ocor_pck.enter_w ||
						'					union all '|| pls_tipos_ocor_pck.enter_w ||
						'					select	a.nr_seq_prest_fornec '|| pls_tipos_ocor_pck.enter_w ||
						'					from	pls_conta_mat a '|| pls_tipos_ocor_pck.enter_w ||
						'					where	a.nr_seq_conta = conta.nr_sequencia '|| pls_tipos_ocor_pck.enter_w ||
						'					and	a.nr_seq_prest_fornec = prest.nr_sequencia '|| pls_tipos_ocor_pck.enter_w ||
						'					) ';
		-- Procedimento
		elsif (ie_incidencia_regra_p = 'P') then

			-- Se for para gerar a ocorrência para procedimento então deve ser olhado se o prestador é o prestador de pagamento do procedimento
			-- ou de algum participante do mesmo.
			ds_filtro_prest_w :=	ds_filtro_prest_w || pls_tipos_ocor_pck.enter_w ||
						'			and	exists ( ' || pls_tipos_ocor_pck.enter_w ||
						'					select	1 '|| pls_tipos_ocor_pck.enter_w ||
						'					from 	pls_conta_proc a '|| pls_tipos_ocor_pck.enter_w ||
						'					where 	a.nr_seq_conta = conta.nr_sequencia '|| pls_tipos_ocor_pck.enter_w ||
						'					and 	prest.nr_sequencia in (	a.nr_seq_prestador_pgto, '|| pls_tipos_ocor_pck.enter_w ||
						'									nvl(a.nr_seq_prestador_pgto, conta.nr_seq_prestador_exec), '|| pls_tipos_ocor_pck.enter_w ||
						'									a.nr_seq_prest_pgto_medico, '|| pls_tipos_ocor_pck.enter_w ||
						'									(select	max(b.nr_seq_prestador_pgto) '|| pls_tipos_ocor_pck.enter_w ||
						'									 from	pls_proc_participante b '|| pls_tipos_ocor_pck.enter_w ||
						'									 where	b.nr_seq_conta_proc = a.nr_sequencia '|| pls_tipos_ocor_pck.enter_w ||
						'									 and	b.ie_status <> ''C'' '|| pls_tipos_ocor_pck.enter_w ||
						'									 and b.nr_seq_prestador_pgto = prest.nr_sequencia)) '|| pls_tipos_ocor_pck.enter_w ||
						'					) ';
		-- Material
		elsif (ie_incidencia_regra_p = 'M') then

			-- Se for para gerar a ocorrência para os materiais então será olhado o fornecedor do material da conta.
			ds_filtro_prest_w :=	ds_filtro_prest_w || pls_tipos_ocor_pck.enter_w ||
						'			and	exists ( ' || pls_tipos_ocor_pck.enter_w ||
						'					select	a.nr_seq_prest_fornec ' || pls_tipos_ocor_pck.enter_w ||
						'					from	pls_conta_mat a ' || pls_tipos_ocor_pck.enter_w ||
						'					where	a.nr_sequencia = mat.nr_sequencia ' || pls_tipos_ocor_pck.enter_w ||
						'					and	a.nr_seq_prest_fornec = prest.nr_sequencia ' || pls_tipos_ocor_pck.enter_w ||
						'					) ';
		end if;
	end if;
end if;

return	ds_filtro_prest_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_oc_cta_obter_rest_pres_pag (dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_filtro_prest_p pls_tipos_ocor_pck.dados_filtro_prest, ie_incidencia_regra_p text) FROM PUBLIC;

