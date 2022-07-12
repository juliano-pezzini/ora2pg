-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_grupo_rol ( cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter se o procedimento informado está no rol de procedimentos e buscar informações do grupo deste procedimento.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/*
	ie_opcao_p
	- PAC
	- DUT
*/
nr_seq_rol_w			bigint;
ie_diretriz_utilizacao_w	pls_rol_grupo_proc.ie_diretriz_utilizacao%type;
ie_complexidade_w		pls_rol_grupo_proc.ie_complexidade%type;
ds_retorno_w			varchar(255);


BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_rol_w
from	pls_rol
where	dt_inicio_vigencia	= (SELECT max(dt_inicio_vigencia) from pls_rol);

begin
	select	b.ie_diretriz_utilizacao,
		b.ie_complexidade
	into STRICT	ie_diretriz_utilizacao_w,
		ie_complexidade_w
	from	pls_rol_capitulo	e,
		pls_rol_grupo		d,
		pls_rol_subgrupo	c,
		pls_rol_grupo_proc	b,
		pls_rol_procedimento	a
	where	e.nr_seq_rol		= nr_seq_rol_w
	and	a.nr_seq_rol_grupo	= b.nr_sequencia
	and	a.cd_procedimento	= cd_procedimento_p
	and	a.ie_origem_proced	= ie_origem_proced_p
	and	b.nr_seq_subgrupo	= c.nr_sequencia
	and	c.nr_seq_grupo		= d.nr_sequencia
	and	d.nr_seq_capitulo	= e.nr_sequencia
	and	coalesce(b.ie_situacao,'A')	= 'A'
	and	coalesce(c.ie_situacao,'A')	= 'A'
	and	coalesce(d.ie_situacao,'A')	= 'A'
	and	coalesce(e.ie_situacao,'A')	= 'A';
exception
when others then
	ie_diretriz_utilizacao_w	:= '';
	ie_complexidade_w		:= '';
end;

if (ie_opcao_p = 'PAC') then
	ds_retorno_w := ie_complexidade_w;
elsif (ie_opcao_p = 'DUT') then
	ds_retorno_w := ie_diretriz_utilizacao_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_grupo_rol ( cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_opcao_p text) FROM PUBLIC;

