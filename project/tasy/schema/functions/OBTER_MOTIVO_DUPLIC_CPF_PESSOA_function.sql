-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_motivo_duplic_cpf_pessoa ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w			varchar(255);


BEGIN
select	max(a.ds_motivo)
into STRICT	ds_retorno_w
from	pf_motivo_cpf_duplic	a,
	pessoa_fisica_aux	b
where	a.nr_sequencia		= b.nr_seq_motivo
and	b.cd_pessoa_fisica	= cd_pessoa_fisica_p;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_motivo_duplic_cpf_pessoa ( cd_pessoa_fisica_p text) FROM PUBLIC;
