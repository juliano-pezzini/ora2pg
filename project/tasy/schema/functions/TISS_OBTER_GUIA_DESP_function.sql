-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_guia_desp (nr_interno_conta_p bigint, cd_autorizacao_p text, cd_cgc_prestador_p text) RETURNS varchar AS $body$
DECLARE


/*
Edgar  18/03/2010, Esta function não deve mais ser utilizada
*/
ie_tiss_tipo_guia_desp_w	varchar(10);
cont_w				bigint;


BEGIN

select	count(*)
into STRICT	cont_w
from	tiss_conta_proc
where	nr_interno_conta	= nr_interno_conta_p
and	cd_autorizacao		= cd_autorizacao_p
and	ie_tiss_tipo_guia	= '4'
and	cd_cgc_prestador	= cd_cgc_prestador_p;

if (cont_w > 0) then			-- se tiver guia de sadt para o prestador do procedimento, então apontar para esta guia,
	ie_tiss_tipo_guia_desp_w	:= '4';	-- senão jogar na guia de resumo de internação
else
	select	count(*)
	into STRICT	cont_w
	from	tiss_conta_proc
	where	nr_interno_conta	= nr_interno_conta_p
	and	cd_autorizacao		= cd_autorizacao_p
	and	ie_tiss_tipo_guia	= '5';

	if (cont_w > 0) then
		ie_tiss_tipo_guia_desp_w	:= '5';
	else		-- Caso a despesa não esteja vinculada a nenhum proc, a mesma deve ser gerada sozinha na guia de SP/SADT
		ie_tiss_tipo_guia_desp_w	:= '4';
	end if;
end if;

return	ie_tiss_tipo_guia_desp_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_guia_desp (nr_interno_conta_p bigint, cd_autorizacao_p text, cd_cgc_prestador_p text) FROM PUBLIC;

