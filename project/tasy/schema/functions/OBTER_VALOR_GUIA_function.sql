-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_guia (nr_atendimento_p text, NR_SEQ_VISAO_P bigint) RETURNS varchar AS $body$
DECLARE


cd_estabelecimento_w	tabela_atrib_regra.cd_estabelecimento%type;
cd_perfil_w		tabela_atrib_regra.cd_perfil%type;
nm_usuario_w		tabela_atrib_regra.nm_usuario%type;
ds_script_w		varchar(4000);
ie_tipo_guia_w		atend_categoria_convenio.ie_tipo_guia%type;
ds_retorno_w		atend_categoria_convenio.ie_tipo_guia%type;
ie_tipo_script_w	tabela_atrib_regra.ie_tipo_script%type;


BEGIN

select 	obter_estabelecimento_ativo,
	obter_perfil_ativo,
	obter_usuario_ativo
into STRICT	cd_estabelecimento_w,
	cd_perfil_w,
	nm_usuario_w
;

begin
SELECT   ds_script,
	 ie_tipo_script
INTO STRICT	 ds_script_w,
	 ie_tipo_script_w
FROM     tabela_atrib_regra
WHERE    nm_tabela = 'ATEND_CATEGORIA_CONVENIO'
AND      coalesce(cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
AND      coalesce(cd_perfil, coalesce( cd_perfil_w , 0))	= coalesce( cd_perfil_w ,0)
AND      coalesce(cd_funcao, 916)	= 916
AND      coalesce(nm_usuario_param, nm_usuario_w)	= nm_usuario_w
AND      coalesce(nr_seq_visao, nr_seq_visao_p)	= nr_seq_visao_p
AND      (ds_script IS NOT NULL AND ds_script::text <> '')
AND      nm_Atributo = 'IE_TIPO_GUIA';
exception
when others then
	ie_tipo_script_w := '';
end;

if (ie_tipo_script_w = 'VL') then
	ds_script_w := 'SELECT ' || ds_script_w || ' FROM DUAL';
	ds_retorno_w := Obter_valor_Dinamico_char_bv(ds_script_w, 'nr_atendimento='||nr_atendimento_p, ds_retorno_w);
	return	ds_retorno_w;
else
	return  '';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_guia (nr_atendimento_p text, NR_SEQ_VISAO_P bigint) FROM PUBLIC;

