-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_consiste_espec_proced ( nr_seq_proc_interno_p bigint, nr_seq_proc_interno_item_p bigint, cd_procedimento_item_p bigint, ie_origem_proced_item_p bigint, cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_plano_p text) RETURNS varchar AS $body$
DECLARE

-- Exame adic
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_especialidade_w		bigint;
-- Item principal
cd_procedimento_item_w		bigint;
ie_origem_proced_item_w		bigint;
cd_especialidade_item_w		bigint;

ds_retorno_w		varchar(1) := 'N';

BEGIN
if (nr_seq_proc_interno_p	> 0) then

	-- Obter procedimento Exame Adicional
	SELECT * FROM obter_proc_tab_interno_conv(
				nr_seq_proc_interno_p, cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, cd_plano_p, null, cd_procedimento_w, ie_origem_proced_w, null, null, null, null, null, null, null, null, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;

	select	max(cd_especialidade)
	into STRICT	cd_especialidade_w
	from	estrutura_procedimento_v
	where	cd_procedimento		= cd_procedimento_w
	and	ie_origem_proced	= ie_origem_proced_w;

	if (coalesce(cd_procedimento_item_p::text, '') = '') then
		SELECT * FROM obter_proc_tab_interno_conv(
			nr_seq_proc_interno_item_p, cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, cd_plano_p, null, cd_procedimento_item_w, ie_origem_proced_item_w, null, null, null, null, null, null, null, null, null, null) INTO STRICT cd_procedimento_item_w, ie_origem_proced_item_w;
	else
		cd_procedimento_item_w	:= cd_procedimento_item_p;
		ie_origem_proced_item_w	:= ie_origem_proced_item_p;
	end if;

	select	max(cd_especialidade)
	into STRICT	cd_especialidade_item_w
	from	estrutura_procedimento_v
	where	cd_procedimento		= cd_procedimento_item_w
	and	ie_origem_proced	= ie_origem_proced_item_w;

	if (cd_especialidade_w = cd_especialidade_item_w) then
		ds_retorno_w := 'N';
	else
		ds_retorno_w := 'S';
	end if;
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_consiste_espec_proced ( nr_seq_proc_interno_p bigint, nr_seq_proc_interno_item_p bigint, cd_procedimento_item_p bigint, ie_origem_proced_item_p bigint, cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_plano_p text) FROM PUBLIC;
