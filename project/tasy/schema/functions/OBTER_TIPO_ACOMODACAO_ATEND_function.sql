-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_acomodacao_atend (nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

cd_tipo_acomodacao_w	varchar(100);
ds_tipo_acomodacao_w	varchar(100);
ds_resultado_w		varchar(100);
nr_seq_atepacu_w	bigint;


BEGIN

if (coalesce(nr_atendimento_p,0) > 0) then

	select	Obter_Atepacu_paciente(nr_atendimento_p,'A')
	into STRICT	nr_seq_atepacu_w
	;

	select	max(cd_tipo_acomodacao)
	into STRICT	cd_tipo_acomodacao_w
	from	atend_paciente_unidade
	where	nr_atendimento = nr_atendimento_p
	and	nr_seq_interno = nr_seq_atepacu_w;

	if (cd_tipo_acomodacao_w IS NOT NULL AND cd_tipo_acomodacao_w::text <> '') then
		select ds_tipo_acomodacao
		into STRICT ds_tipo_acomodacao_w
		from tipo_acomodacao
		where cd_tipo_acomodacao = cd_tipo_acomodacao_w;


		if (ie_opcao_p = 'C') then
			ds_resultado_w := cd_tipo_acomodacao_w;
		elsif (ie_opcao_p = 'D') then
			ds_resultado_w := ds_tipo_acomodacao_w;
		end if;
	end if;

end if;

return	ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_acomodacao_atend (nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;

