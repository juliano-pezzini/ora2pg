-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_cad_pac_eup_js ( cd_codigo_p text, cd_pessoa_fisica_p text, nr_cpf_p text, ds_orgao_emissor_p text, nr_ddd_celular_p text, nm_usuario_p text, ie_digito_cpf_p text, ie_consiste_digito_cpf_p text, ie_consistir_digito_p INOUT text, ds_texto_pri_p INOUT text, ds_texto_cpf_p INOUT text, ds_texto_ter_p INOUT text, ie_cpf_dupl_p INOUT text, ds_texto_qua_p INOUT text, ds_texto_emissor_p INOUT text, ds_texto_ddd_p INOUT text, ds_mascara_ddd_p INOUT text) AS $body$
DECLARE


ie_consistir_digito_w		varchar(1) := 'S';
ds_texto_pri_w			varchar(100);
ds_texto_cpf_w			varchar(100);
ds_texto_ter_w			varchar(100);
ie_cpf_dupl_w			varchar(1);
ds_texto_qua_w			varchar(100);
ds_texto_emissor_w		varchar(100);
qt_existe_emissor_w		bigint;
ie_consiste_ddd_w		varchar(1);
ie_somente_numero_ddd_w 	varchar(1);
ds_texto_ddd_w			varchar(100);
ds_mascara_ddd_w		varchar(20);
cd_estabelecimento_w		bigint;
nr_ddd_w			smallint := somente_numero(nr_ddd_celular_p);
ie_consiste_cartao_sus_w	varchar(1);
ie_consiste_orgao_emissor_w	varchar(1);
ie_consiste_digito_cpf_w	varchar(1);


BEGIN

cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;

ie_consiste_ddd_w := Obter_param_Usuario(916, 889, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_consiste_ddd_w);
ie_consiste_cartao_sus_w := Obter_param_Usuario(5, 20, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_consiste_cartao_sus_w);
ie_consiste_orgao_emissor_w := Obter_param_Usuario(5, 133, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_consiste_orgao_emissor_w);
ie_consiste_digito_cpf_w := Obter_param_Usuario(5, 146, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_consiste_digito_cpf_w);

ds_texto_pri_w		:= substr(obter_texto_tasy(69777, 1),1,100);
ds_texto_ter_w		:= substr(obter_texto_tasy(69786, 1),1,100);

ie_cpf_dupl_w		:= obter_duplic_cpf(cd_pessoa_fisica_p, nr_cpf_p);

ds_texto_qua_w		:= substr(obter_texto_tasy(69789, 1),1,100);

if (ie_consiste_digito_cpf_w = 'S') then

	if (ie_digito_cpf_p = 'S') then
		ds_texto_cpf_w	:= substr(obter_texto_tasy(69778, 1),1,100);
	end if;
else
	if (ie_consiste_digito_cpf_p = 'S') then
		ds_texto_cpf_w	:= substr(obter_texto_tasy(69778, 1),1,100);
	end if;

end if;

if (ie_consiste_cartao_sus_w = 'S') then

	ie_consistir_digito_w	:= consistir_digito('CARTAOSUS', cd_codigo_p);
end if;

if (ds_orgao_emissor_p IS NOT NULL AND ds_orgao_emissor_p::text <> '') and (ie_consiste_orgao_emissor_w = 'S') then

	select  count(*)
	into STRICT	qt_existe_emissor_w
	from    orgao_emissor
	where   upper(cd_orgao_emissor) = upper(ds_orgao_emissor_p);

	if (coalesce(qt_existe_emissor_w,0) = 0) then
		ds_texto_emissor_w := substr(obter_texto_tasy(273591, 1),1,100);
	end if;

end if;

if (nr_ddd_celular_p IS NOT NULL AND nr_ddd_celular_p::text <> '') then

	if (ie_consiste_ddd_w= 'S') then
		ie_somente_numero_ddd_w := obter_se_somente_numero(nr_ddd_celular_p);

		if (ie_somente_numero_ddd_w = 'N') then

			ds_texto_ddd_w := obter_texto_tasy(177072, 1);
		end if;
	end if;

	ds_mascara_ddd_w := substr(obter_masc_fone_ddd(nr_ddd_w, 'C'),1,20);
end if;

ie_consistir_digito_p	:= ie_consistir_digito_w;
ds_texto_pri_p		:= ds_texto_pri_w;
ds_texto_cpf_p		:= ds_texto_cpf_w;
ds_texto_ter_p		:= ds_texto_ter_w;
ie_cpf_dupl_p		:= ie_cpf_dupl_w;
ds_texto_qua_p		:= ds_texto_qua_w;
ds_texto_emissor_p	:= ds_texto_emissor_w;
ds_texto_ddd_p          := ds_texto_ddd_w;
ds_mascara_ddd_p	:= ds_mascara_ddd_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_cad_pac_eup_js ( cd_codigo_p text, cd_pessoa_fisica_p text, nr_cpf_p text, ds_orgao_emissor_p text, nr_ddd_celular_p text, nm_usuario_p text, ie_digito_cpf_p text, ie_consiste_digito_cpf_p text, ie_consistir_digito_p INOUT text, ds_texto_pri_p INOUT text, ds_texto_cpf_p INOUT text, ds_texto_ter_p INOUT text, ie_cpf_dupl_p INOUT text, ds_texto_qua_p INOUT text, ds_texto_emissor_p INOUT text, ds_texto_ddd_p INOUT text, ds_mascara_ddd_p INOUT text) FROM PUBLIC;
