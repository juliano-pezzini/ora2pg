-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_espec_pf_prest ( nr_seq_prestador_p bigint) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter as especialidades do prestador
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [ X ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w			varchar(4000);
ds_especialidade_w		varchar(255)	:= null;

C01 CURSOR FOR
	SELECT	distinct
		c.ds_especialidade
	from	especialidade_medica 	c,
		pls_prestador_med_espec b,
		pls_prestador 		a
	where	b.cd_especialidade	= c.cd_especialidade
	and	b.nr_seq_prestador	= a.nr_sequencia
	and	a.nr_sequencia		= nr_seq_prestador_p
	and	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
	and	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '')
	and	clock_timestamp() between trunc(coalesce(b.dt_inicio_vigencia, clock_timestamp())) and fim_dia(coalesce(b.dt_fim_vigencia, clock_timestamp()))
	
union all

	SELECT	distinct
		c.ds_especialidade
	from	especialidade_medica 	c,
		pls_prestador_med_espec b,
		pls_prestador_medico	d,
		pls_prestador 		a
	where	b.cd_especialidade	= c.cd_especialidade
	and	b.nr_seq_prestador	= a.nr_sequencia
	and	d.nr_seq_prestador	= a.nr_sequencia
	and	d.cd_medico 		= b.cd_pessoa_fisica
	and	a.nr_sequencia		= nr_seq_prestador_p
	and	(a.cd_cgc IS NOT NULL AND a.cd_cgc::text <> '')
	and	clock_timestamp() between trunc(coalesce(b.dt_inicio_vigencia, clock_timestamp())) and fim_dia(coalesce(b.dt_fim_vigencia, clock_timestamp()))
	order by
		1;


BEGIN
open C01;
loop
fetch C01 into
	ds_especialidade_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_retorno_w	:= ds_retorno_w || ds_especialidade_w || '\';	--'
	end;
end loop;
close C01;

ds_retorno_w	:= substr(ds_retorno_w, 1, length(ds_retorno_w) - 1);

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_espec_pf_prest ( nr_seq_prestador_p bigint) FROM PUBLIC;

