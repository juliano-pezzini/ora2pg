-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_noms_mdb ( ds_guia_p text) RETURNS varchar AS $body$
DECLARE


ds_concat_w varchar(2000) := 'File';
cd_localidade_w varchar(200);

BEGIN
if (ds_guia_p IS NOT NULL AND ds_guia_p::text <> '') then
	begin
	select 	coalesce(coalesce(get_info_end_endereco(pj.nr_seq_pessoa_endereco,'ESTADO_PROVINCI','C'), obter_dados_cat_localidade(pj.NR_SEQ_TIPO_ASEN,'CD_EFE')),'') CD_ESTADO_CERTIF
	into STRICT	cd_localidade_w	
	from	pessoa_juridica pj,
			estabelecimento es
	where	es.cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento
	and		pj.cd_cgc = es.cd_cgc  LIMIT 1;
	
	if (ds_guia_p = 'FETAL') then
		begin
		ds_concat_w := 'ENVIOCF'
				|| substr(pkg_date_utils.extract_field('YEAR', clock_timestamp()),3,4)
				|| lpad(cd_localidade_w,2,0) 
				||  '_'  || '03'  || '_' 
				|| lpad(pkg_date_utils.extract_field('DAY', clock_timestamp()),2,0)
				|| lpad(pkg_date_utils.extract_field('MONTH', clock_timestamp()),2,0)
				|| pkg_date_utils.extract_field('YEAR', clock_timestamp())
				|| '_' 
				|| pkg_date_utils.extract_field('HOUR', clock_timestamp())||pkg_date_utils.extract_field('MINUTE', clock_timestamp())||pkg_date_utils.extract_field('SECOND', clock_timestamp())
				|| '.' || 'MDB';
		end;
	end if;
	if (ds_guia_p = 'NASC') then
		begin
		ds_concat_w := 'ENVIOCN'
				|| substr(pkg_date_utils.extract_field('YEAR', clock_timestamp()),3,4)
				|| lpad(cd_localidade_w,2,0)
				||  '_'
				|| lpad(pkg_date_utils.extract_field('DAY', clock_timestamp()),2,0)
				|| lpad(pkg_date_utils.extract_field('MONTH', clock_timestamp()),2,0)
				|| pkg_date_utils.extract_field('YEAR', clock_timestamp())
				|| '.' || 'MDB';
		end;
	end if;
	end;
end if;
return ds_concat_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_noms_mdb ( ds_guia_p text) FROM PUBLIC;

