-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_dado_atend_cat_conv ( nr_atendimento_p bigint, dt_referencia_p timestamp, cd_convenio_p bigint, cd_categoria_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE



ds_retorno_w			varchar(2000);
dt_referencia_w			timestamp;
cd_usuario_convenio_w		varchar(40);
cd_plano_w			varchar(20);
cd_empresa_w			bigint;
cd_tipo_acomodacao_w		bigint;
ds_observacao_w			Atend_categoria_convenio.ds_observacao%type;
/*	Opção
	E	- Empresa de referência
	P	- Plano
	U	- Códido do Usuário no Plano
	A	- Tipo de acomodação
	O	- Observação
*/
BEGIN

ds_retorno_w			:= '';

select /*+ index (a ATECACO_I2) */	max(dt_inicio_vigencia)
into STRICT	dt_referencia_w
from	Atend_categoria_convenio
where	nr_atendimento	= nr_atendimento_p
and	cd_convenio		= cd_convenio_p
and	cd_categoria		= cd_categoria_p
and	dt_inicio_vigencia	<= dt_referencia_p;

if (dt_referencia_w IS NOT NULL AND dt_referencia_w::text <> '') then


	if (ie_opcao_p = 'P') then

		select	/*+ index (a ATECACO_I2) */			max(cd_plano_convenio)
		into STRICT	cd_plano_w
		from	Atend_categoria_convenio
		where	nr_atendimento		= nr_atendimento_p
		and	cd_convenio		= cd_convenio_p
		and	cd_categoria		= cd_categoria_p
		and	dt_inicio_vigencia	= dt_referencia_w;


		ds_retorno_w		:=  cd_plano_w;
	elsif (ie_opcao_p = 'E') then

		select	/*+ index (a ATECACO_I2) */			max(cd_empresa)
		into STRICT	cd_empresa_w
		from	Atend_categoria_convenio
		where	nr_atendimento		= nr_atendimento_p
		and	cd_convenio		= cd_convenio_p
		and	cd_categoria		= cd_categoria_p
		and	dt_inicio_vigencia	= dt_referencia_w;


		ds_retorno_w		:=  cd_empresa_w;
	elsif (ie_opcao_p = 'U') then

		select	/*+ index (a ATECACO_I2) */			max(cd_usuario_convenio)
		into STRICT	cd_usuario_convenio_w
		from	Atend_categoria_convenio
		where	nr_atendimento		= nr_atendimento_p
		and	cd_convenio		= cd_convenio_p
		and	cd_categoria		= cd_categoria_p
		and	dt_inicio_vigencia	= dt_referencia_w;

		ds_retorno_w		:=  cd_usuario_convenio_w;
	elsif (ie_opcao_p = 'A') then

		select	/*+ index (a ATECACO_I2) */			max(cd_tipo_acomodacao)
		into STRICT	cd_tipo_acomodacao_w
		from	Atend_categoria_convenio
		where	nr_atendimento		= nr_atendimento_p
		and	cd_convenio		= cd_convenio_p
		and	cd_categoria		= cd_categoria_p
		and	dt_inicio_vigencia	= dt_referencia_w;

		ds_retorno_w		:=  cd_tipo_acomodacao_w;
	elsif (ie_opcao_p = 'O') then

		select	/*+ index (a ATECACO_I2) */			max(ds_observacao)
		into STRICT	ds_observacao_w
		from	Atend_categoria_convenio
		where	nr_atendimento		= nr_atendimento_p
		and	cd_convenio		= cd_convenio_p
		and	cd_categoria		= cd_categoria_p
		and	dt_inicio_vigencia	= dt_referencia_w;

		ds_retorno_w		:=  ds_observacao_w;
	end if;

end if;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_dado_atend_cat_conv ( nr_atendimento_p bigint, dt_referencia_p timestamp, cd_convenio_p bigint, cd_categoria_p text, ie_opcao_p text) FROM PUBLIC;

