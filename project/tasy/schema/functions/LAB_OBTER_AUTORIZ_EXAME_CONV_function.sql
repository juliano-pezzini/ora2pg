-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_autoriz_exame_conv (nr_seq_exame_p bigint, cd_convenio_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ie_autorizacao_w	varchar(2);
ds_retorno_w		varchar(254);


BEGIN

if (nr_seq_exame_p IS NOT NULL AND nr_seq_exame_p::text <> '') and (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') and (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') and (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') then

	select	coalesce(max(ie_autorizacao),'0')
	into STRICT	ie_autorizacao_w
	from 	exame_lab_convenio
	where	nr_seq_exame		= nr_seq_exame_p
	and	cd_convenio		= cd_convenio_p
	and	cd_procedimento	= cd_procedimento_p
	and	ie_origem_proced	= ie_origem_proced_p;

	if (ie_autorizacao_w = '0') then

			select	coalesce(max(ie_autorizacao),'0')
			into STRICT	ie_autorizacao_w
			from 	exame_lab_convenio
			where	nr_seq_exame		= nr_seq_exame_p
			and	coalesce(cd_convenio,cd_convenio_p)		= cd_convenio_p
			and	cd_procedimento	= cd_procedimento_p
			and	ie_origem_proced	= ie_origem_proced_p;

	end if;

	if (coalesce(ie_opcao_p, 'C') = 'D') then
		if (coalesce(ie_autorizacao_w,'0') <> '0') then
			select	substr(obter_valor_dominio(1026, ie_autorizacao_w),1,254)
			into STRICT	ds_retorno_w
			;
		end if;
	else
		ds_retorno_w	:= ie_autorizacao_w;
	end if;
end if;

Return	ds_retorno_w;
END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_autoriz_exame_conv (nr_seq_exame_p bigint, cd_convenio_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_opcao_p text) FROM PUBLIC;

