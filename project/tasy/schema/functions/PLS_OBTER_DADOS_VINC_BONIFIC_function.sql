-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_vinc_bonific ( nr_seq_vinculo_bonific_p bigint, nr_seq_vinculo_sca_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*
ie_opcao
	N = Nome da bonificação
	O = Origem da bonificação
	S = Sequencia da Origem da bonificação
*/
ds_retorno_w		varchar(300);
nm_sca_w		varchar(300);
nm_origem_w		varchar(300);
nr_seq_contrato_w	bigint;
nr_seq_plano_w		bigint;
nr_seq_segurado_w	bigint;
nr_seq_origem_w		bigint;
nr_seq_pagador_w	bigint;
nr_seq_grupo_contrato_w	pls_grupo_contrato.nr_sequencia%type;
nm_bonificacao_w	varchar(300);

BEGIN

if (coalesce(nr_seq_vinculo_bonific_p,0) <> 0) then
	select	substr(pls_obter_desc_bonificacao(nr_seq_bonificacao),1,255),
		nr_seq_contrato,
		nr_seq_plano,
		nr_seq_segurado,
		nr_seq_pagador,
		nr_seq_grupo_contrato
	into STRICT	nm_bonificacao_w,
		nr_seq_contrato_w,
		nr_seq_plano_w,
		nr_seq_segurado_w,
		nr_seq_pagador_w,
		nr_seq_grupo_contrato_w
	from	pls_bonificacao_vinculo
	where	nr_sequencia = nr_seq_vinculo_bonific_p;

	if (ie_opcao_p = 'N') then
		ds_retorno_w := nm_bonificacao_w;
	elsif (ie_opcao_p = 'S' or ie_opcao_p = 'O') then
		if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then
			nr_seq_origem_w := nr_seq_contrato_w;
			nm_origem_w	:= 'Contrato';
		elsif (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then
			nr_seq_origem_w := nr_seq_segurado_w;
			nm_origem_w	:= 'Beneficiário';
		elsif (nr_seq_pagador_w IS NOT NULL AND nr_seq_pagador_w::text <> '') then
			nr_seq_origem_w	:= nr_seq_pagador_w;
			nm_origem_w	:= 'Pagador';
		elsif (nr_seq_plano_w IS NOT NULL AND nr_seq_plano_w::text <> '') then
			nr_seq_origem_w := nr_seq_plano_w;
			nm_origem_w	:= 'SCA';
		elsif (nr_seq_grupo_contrato_w IS NOT NULL AND nr_seq_grupo_contrato_w::text <> '') then
			nr_seq_origem_w := nr_seq_grupo_contrato_w;
			nm_origem_w	:= 'Grupo de Relacionamento';
		end if;
	end if;

	if (ie_opcao_p = 'S') then
		ds_retorno_w := nr_seq_origem_w;
	elsif (ie_opcao_p = 'O') then
		ds_retorno_w := nm_origem_w;
	end if;
elsif (coalesce(nr_seq_vinculo_sca_p,0) <> 0) then
	select	substr(pls_obter_dados_produto(nr_seq_plano,'N'),1,255),
		nr_seq_contrato,
		nr_seq_plano,
		nr_seq_segurado
	into STRICT	nm_sca_w,
		nr_seq_contrato_w,
		nr_seq_plano_w,
		nr_seq_segurado_w
	from	pls_sca_vinculo
	where	nr_sequencia = nr_seq_vinculo_sca_p;

	if (ie_opcao_p = 'N') then
		ds_retorno_w := nm_sca_w;
	elsif (ie_opcao_p = 'S' or ie_opcao_p = 'O') then
		if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then
			nr_seq_origem_w := nr_seq_contrato_w;
			nm_origem_w	:= 'Contrato';
		elsif (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then
			nr_seq_origem_w := nr_seq_segurado_w;
			nm_origem_w	:= 'Beneficiário';
		elsif (nr_seq_plano_w IS NOT NULL AND nr_seq_plano_w::text <> '') then
			nr_seq_origem_w := nr_seq_plano_w;
			nm_origem_w	:= 'SCA';
		end if;
	end if;

	if (ie_opcao_p = 'S') then
		ds_retorno_w := nr_seq_origem_w;
	elsif (ie_opcao_p = 'O') then
		ds_retorno_w := nm_origem_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_vinc_bonific ( nr_seq_vinculo_bonific_p bigint, nr_seq_vinculo_sca_p bigint, ie_opcao_p text) FROM PUBLIC;

