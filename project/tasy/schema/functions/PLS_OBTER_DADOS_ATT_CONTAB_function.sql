-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_att_contab ( nr_seq_atualizacao_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

ie_opcao_p
	QI = Quantidade de inconsistências
	QP = Quantidade de inconsistências pendentes

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w		varchar(255);


BEGIN

if (ie_opcao_p = 'QI') then
	select	count(1)
	into STRICT	ds_retorno_w
	from	pls_movimento_contabil
	where	nr_seq_atualizacao	= nr_seq_atualizacao_p;
elsif (ie_opcao_p = 'QP') then
	select	count(1)
	into STRICT	ds_retorno_w
	from	pls_movimento_contabil
	where	nr_seq_atualizacao	= nr_seq_atualizacao_p
	and	ie_status not in ('3','7');
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_att_contab ( nr_seq_atualizacao_p bigint, ie_opcao_p text) FROM PUBLIC;

