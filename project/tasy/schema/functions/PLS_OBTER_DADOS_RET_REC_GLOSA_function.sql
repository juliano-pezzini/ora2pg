-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_ret_rec_glosa ( nr_seq_prestador_p pls_regra_ret_rec_glosa.nr_seq_prestador%type, cd_estabelecimento_p pls_regra_ret_rec_glosa.cd_estabelecimento%type, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade:	Retorna os dados pertinente a regra que controla o retorno de recurso de glosa em XML. 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[X] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
------------------------------------------------------------------------------------------------------------------- 
Pontos de atenção:	Essa function serve para retornar uma opção, usando a pls_obter_seq_ret_rec_glosa, 
		que retornar o sequencial da regra selecionada. 
		 
		Caso seja necessário retornar varios campos em um espaço curto de tempo, 
		como no corpo de um select por exemplo, verificar a possibilidade de usar a 
		pls_obter_seq_ret_rec_glosa e obter os dados diretamente da tabela, 
		por questões de performance. 
		 
		Opções 
		ID	- Identificação do prestador a ser retornada 
 
Alterações: 
------------------------------------------------------------------------------------------------------------------- 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
ds_retorno_w	varchar(500) := null;

BEGIN
 
if (ie_opcao_p = 'ID') then 
 
	select	max(a.ie_ident_prestador) 
	into STRICT	ds_retorno_w 
	from	pls_regra_ret_rec_glosa	a 
	where	a.nr_sequencia	= pls_obter_seq_ret_rec_glosa(nr_seq_prestador_p, cd_estabelecimento_p);
end if;
 
return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_ret_rec_glosa ( nr_seq_prestador_p pls_regra_ret_rec_glosa.nr_seq_prestador%type, cd_estabelecimento_p pls_regra_ret_rec_glosa.cd_estabelecimento%type, ie_opcao_p text) FROM PUBLIC;

