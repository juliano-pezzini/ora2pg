-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_item_prop_lib ( cd_perfil_p bigint, nr_seq_item_p bigint) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter se o item está liberado para visualização para o perfil.
Cadastro realizado em Administração do Sistema Tasy / Parâmetros / Parâmetros OPS / OPS - Proposta de adesão
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w	varchar(255);


BEGIN

select	max(b.ie_controle)
into STRICT	ds_retorno_w
from	pls_proposta_item_perfil	b,
	pls_itens_proposta		a
where	b.nr_seq_item		= a.nr_sequencia
and	a.nr_sequencia		= nr_seq_item_p
and	b.cd_perfil		= cd_perfil_p
and	a.ie_situacao		= 'A';

ds_retorno_w	:= coalesce(ds_retorno_w,'N');

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_item_prop_lib ( cd_perfil_p bigint, nr_seq_item_p bigint) FROM PUBLIC;

