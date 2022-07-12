-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_param_medico ( cd_estabelecimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(255);

BEGIN

if (ie_opcao_p	= 'IE_NEGA_ALERGIA_ALERTA') then

	select	coalesce(max(IE_NEGA_ALERGIA_ALERTA),'S')
	into STRICT	ds_retorno_w
	from	parametro_medico
	where	cd_estabelecimento = cd_estabelecimento_p;
	
elsif (ie_opcao_p	= 'IE_LIB_SINAL_VITAL') then

	select	coalesce(max(IE_LIB_SINAL_VITAL),'N')
	into STRICT	ds_retorno_w
	from	parametro_medico
	where	cd_estabelecimento = cd_estabelecimento_p;
	
elsif (ie_opcao_p	= 'QT_HORAS_INICIO_CICLO') then

	select	coalesce(max(QT_HORAS_INICIO_CICLO),0)
	into STRICT	ds_retorno_w
	from	parametro_medico
	where	cd_estabelecimento = cd_estabelecimento_p;
	
elsif (ie_opcao_p = 'IE_REGRA_PF_NASC') then
	select	coalesce(max(ie_regra_pf_nasc),'N')
	into STRICT	ds_retorno_w
	from    parametro_medico
	where   cd_estabelecimento = cd_estabelecimento_p;	
elsif (ie_opcao_p = 'IE_LIBERAR_HIST_SAUDE') then
	select	coalesce(max(IE_LIBERAR_HIST_SAUDE),'N')
	into STRICT	ds_retorno_w
	from    parametro_medico
	where   cd_estabelecimento = cd_estabelecimento_p;	
elsif (ie_opcao_p = 'IE_LIB_DIAG_TUMOR') then
	select	coalesce(max(IE_LIB_DIAG_TUMOR),'N')
	into STRICT	ds_retorno_w
	from    parametro_medico
	where   cd_estabelecimento = cd_estabelecimento_p;	
elsif (ie_opcao_p = 'IE_LIB_DIAG_MEDICO') then
	select	coalesce(max(IE_LIB_DIAG_MEDICO),'N')
	into STRICT	ds_retorno_w
	from    parametro_medico
	where   cd_estabelecimento = cd_estabelecimento_p;	
elsif (ie_opcao_p = 'IE_LIBERA_PARTIC') then
	select	coalesce(max(IE_LIBERA_PARTIC),'N')
	into STRICT	ds_retorno_w
	from    parametro_medico
	where   cd_estabelecimento = cd_estabelecimento_p;
elsif (ie_opcao_p = 'IE_LIBERA_ANEXOS_OFT') then
	select	coalesce(max(IE_LIBERA_ANEXOS_OFT),'N')
	into STRICT	ds_retorno_w
	from    parametro_medico
	where   cd_estabelecimento = cd_estabelecimento_p;	
elsif (ie_opcao_p = 'IE_LIBERA_ATRASO_CIRUR') then
	select	coalesce(max(IE_LIBERA_ATRASO_CIRUR),'N')
	into STRICT	ds_retorno_w
	from    parametro_medico
	where   cd_estabelecimento = cd_estabelecimento_p;
elsif (ie_opcao_p = 'IE_LIBERA_EVENTO_PEPO') then
	select	coalesce(max(IE_LIBERA_EVENTO_PEPO),'N')
	into STRICT	ds_retorno_w
	from    parametro_medico
	where   cd_estabelecimento = cd_estabelecimento_p;
elsif (ie_opcao_p = 'IE_LIBERA_DEMARCACAO') then
	select	coalesce(max(IE_LIBERA_DEMARCACAO),'N')
	into STRICT	ds_retorno_w
	from    parametro_medico
	where   cd_estabelecimento = cd_estabelecimento_p;
elsif (ie_opcao_p = 'IE_LIBERA_PELE') then
	select	coalesce(max(IE_LIBERA_PELE),'N')
	into STRICT	ds_retorno_w
	from    parametro_medico
	where   cd_estabelecimento = cd_estabelecimento_p;
elsif (ie_opcao_p = 'IE_LIBERA_INCISAO') then
	select	coalesce(max(IE_LIBERA_INCISAO),'N')
	into STRICT	ds_retorno_w
	from    parametro_medico
	where   cd_estabelecimento = cd_estabelecimento_p;
elsif (ie_opcao_p = 'IE_LIBERA_POSICAO') then
	select	coalesce(max(IE_LIBERA_POSICAO),'N')
	into STRICT	ds_retorno_w
	from    parametro_medico
	where   cd_estabelecimento = cd_estabelecimento_p;
elsif (ie_opcao_p = 'IE_TIPO_ORI_PRESCRITOR') then
	Select  coalesce(max(IE_TIPO_ORI_PRESCRITOR),'F')
	into STRICT	ds_retorno_w			
	from	parametro_medico
	where   cd_estabelecimento = cd_estabelecimento_p;
elsif (ie_opcao_p = 'IE_LIB_FERIDA') then
	Select  coalesce(max(IE_LIB_FERIDA),'N')
	into STRICT	ds_retorno_w			
	from	parametro_medico
	where   cd_estabelecimento = cd_estabelecimento_p;
elsif (ie_opcao_p = 'IE_LIB_PARTOGRAMA') then
	Select  coalesce(max(IE_LIB_PARTOGRAMA),'N')
	into STRICT	ds_retorno_w			
	from	parametro_medico
	where   cd_estabelecimento = cd_estabelecimento_p;
elsif (ie_opcao_p = 'IE_LIB_EVENTO') then
	Select  coalesce(max(IE_LIB_EVENTO),'N')
	into STRICT	ds_retorno_w			
	from	parametro_medico
	where   cd_estabelecimento = cd_estabelecimento_p;
elsif (ie_opcao_p = 'IE_UNIDADE_GLICEMIA') then
	Select  coalesce(max(ie_unidade_glicemia),'mg')
	into STRICT	ds_retorno_w			
	from	parametro_medico
	where   cd_estabelecimento = cd_estabelecimento_p;
elsif (ie_opcao_p = 'IE_UNIDADE_NUT_AVAL') then
	Select  coalesce(max(ie_unidade_nut_aval),'KCAL')
	into STRICT	ds_retorno_w			
	from	parametro_medico
	where   cd_estabelecimento = cd_estabelecimento_p;
elsif (ie_opcao_p = 'IE_LIBERA_CICLO_ONC') then
      select coalesce(max(ie_libera_ciclo_onc), 'N')
      into STRICT ds_retorno_w
      from parametro_medico
      where cd_estabelecimento = cd_estabelecimento_p;	
elsif (ie_opcao_p = 'IE_TIPO_ENVIO') then
    select coalesce(max(ie_tipo_envio), 'N')
    into STRICT ds_retorno_w
    from parametro_medico
    where cd_estabelecimento = cd_estabelecimento_p;
elsif (ie_opcao_p = 'DS_EMAIL_ENVIO') then
    select max(DS_EMAIL_ENVIO)
    into STRICT ds_retorno_w
    from parametro_medico
    where cd_estabelecimento = cd_estabelecimento_p;	
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_param_medico ( cd_estabelecimento_p bigint, ie_opcao_p text) FROM PUBLIC;

