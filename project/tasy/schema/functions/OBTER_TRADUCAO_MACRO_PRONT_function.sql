-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_traducao_macro_pront ( nm_macro_p text, cd_funcao_p bigint default null) RETURNS varchar AS $body$
DECLARE

			
ds_retorno_w	varchar(255);
ds_locale_w	varchar(255)	:= pkg_i18n.get_user_locale;

BEGIN
  if (nm_macro_p IS NOT NULL AND nm_macro_p::text <> '') then
    begin	
    if (ds_locale_w = 'de_DE') then
      select  a.ds_macro
      into STRICT    ds_retorno_w
      from	funcao_macro a,
	funcao_macro_cliente b
      where	  a.nr_sequencia = b.nr_seq_macro
      and     a.cd_funcao = cd_funcao_p
      and     b.ds_macro = nm_macro_p;
    else
      select	substr(ds_macro_client,1,255)
      into STRICT	  ds_retorno_w
      from	  table(search_macros(cd_funcao_p, nm_macro_p, ds_locale_w, 'P')) LIMIT 1;
    end if;

    exception	
    when others then
      ds_retorno_w := substr(nm_macro_p,1,255);
    end;
  end if;

  if (ds_locale_w	= 'en_AU') then
	ds_retorno_w	:= trim(both ds_retorno_w);
  end if;

  if (nm_macro_p	= ds_retorno_w) and (ds_locale_w = 'en_AU') then
	--Force to get the macro without importing
	select  max(b.ds_macro)
	into STRICT    ds_retorno_w
	from	funcao_macro a,
		funcao_macro_inicial b  
	where	a.nr_sequencia = b.nr_seq_macro
	and	a.cd_funcao = cd_funcao_p
	and	upper(trim(both a.ds_macro)) = upper(trim(both nm_macro_p))
	and	b.ds_locale = ds_locale_w;


      if (coalesce(ds_retorno_w::text, '') = '') then
		ds_retorno_w := substr(nm_macro_p,1,255);
      end if;
	
  end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_traducao_macro_pront ( nm_macro_p text, cd_funcao_p bigint default null) FROM PUBLIC;

