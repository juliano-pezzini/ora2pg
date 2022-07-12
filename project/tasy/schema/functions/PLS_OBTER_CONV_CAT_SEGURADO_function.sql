-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_conv_cat_segurado ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, ie_retorno_p bigint) RETURNS varchar AS $body$
DECLARE

/*
IE_RETORNO_P
1 - Convênio
2 - Categoria
*/
nr_sequencia_w	pessoa_titular_convenio.nr_sequencia%type;
cd_convenio_w	pessoa_titular_convenio.cd_convenio%type;
cd_categoria_w	pessoa_titular_convenio.cd_categoria%type;
ds_retorno_w	varchar(10) := null;
qt_reg_w	integer;


BEGIN
/* Francisco - 28/05/2012 - Nem entrar na rotina se não tiver dados nessa tabela */

select	count(1)
into STRICT	qt_reg_w
from	pessoa_titular_convenio LIMIT 1;

if (qt_reg_w > 0) then
	select	coalesce(max(c.nr_sequencia),0)
	into STRICT	nr_sequencia_w
	from	pessoa_titular_convenio	c,
		pls_segurado		a
	where	a.cd_pessoa_fisica	= c.cd_pessoa_fisica
	and	a.nr_sequencia		= nr_seq_segurado_p
	and	c.dt_inicio_vigencia	= (	SELECT	max(c.dt_inicio_vigencia)
						from	pessoa_titular_convenio	c,
							pls_segurado		a
						where	a.cd_pessoa_fisica	= c.cd_pessoa_fisica
						and	a.nr_sequencia		= nr_seq_segurado_p
						and	clock_timestamp() between c.dt_inicio_vigencia and coalesce(c.dt_fim_vigencia, clock_timestamp() + interval '1 days'));


	select	max(cd_convenio),
		max(cd_categoria)
	into STRICT	cd_convenio_w,
		cd_categoria_w
	from	pessoa_titular_convenio
	where	nr_sequencia	= nr_sequencia_w;

	if (ie_retorno_p	= 1) then

		ds_retorno_w	:= cd_convenio_w;
	elsif (ie_retorno_p	= 2) then

		ds_retorno_w	:= cd_categoria_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_conv_cat_segurado ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, ie_retorno_p bigint) FROM PUBLIC;

