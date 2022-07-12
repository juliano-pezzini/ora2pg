-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_com_orcamento ( cd_pessoa_fisica_p text, dt_entrada_p timestamp, ie_tipo_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE

 
qt_tora_w			bigint;
ie_considera_aprov_validade_w	varchar(1);
qt_num_dias_orc_w		bigint;


BEGIN 
ie_considera_aprov_validade_w	:= coalesce(obter_valor_param_usuario(916, 510, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo),'S');
qt_num_dias_orc_w		:= coalesce(obter_valor_param_usuario(916, 1087, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo),0);
 
if (ie_considera_aprov_validade_w = 'I') then 
	select count(*) 
	into STRICT	qt_tora_w 
	from  orcamento_paciente a 
	where 	a.cd_pessoa_fisica = cd_pessoa_fisica_p 
	and   coalesce(a.nr_atendimento::text, '') = '' 
	and	((qt_num_dias_orc_w = 0) or (dt_orcamento > clock_timestamp() - qt_num_dias_orc_w)) 
	and	obter_se_conv_vinculacao_orc(a.cd_convenio,obter_estabelecimento_ativo) = 'S' 
	and	Possui_vinc_orc(ie_tipo_atendimento_p, a.ie_tipo_atendimento) = 'S';
else 
	select count(*) 
	into STRICT	qt_tora_w 
	from  orcamento_paciente a 
	where 	a.cd_pessoa_fisica = cd_pessoa_fisica_p 
	and   a.ie_status_orcamento = 2 
	and   coalesce(a.dt_validade,dt_entrada_p) > dt_entrada_p 
	and   coalesce(a.nr_atendimento::text, '') = '' 
	and	((qt_num_dias_orc_w = 0) or (dt_orcamento > clock_timestamp() - qt_num_dias_orc_w)) 
	and	obter_se_conv_vinculacao_orc(a.cd_convenio,obter_estabelecimento_ativo) = 'S' 
	and	Possui_vinc_orc(ie_tipo_atendimento_p, a.ie_tipo_atendimento) = 'S';
end if;
 
return	qt_tora_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_com_orcamento ( cd_pessoa_fisica_p text, dt_entrada_p timestamp, ie_tipo_atendimento_p bigint) FROM PUBLIC;

