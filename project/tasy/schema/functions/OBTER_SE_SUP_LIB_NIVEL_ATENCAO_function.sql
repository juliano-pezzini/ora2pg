-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_sup_lib_nivel_atencao ( ie_niveis_lib_perfil_p text, nm_usuario_reg_p text, nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(1) := 'S';


BEGIN


if (ie_opcao_p = 'ODT') then

	Select 	coalesce(max('S'),'N')
	into STRICT	ds_retorno_w
	from	odont_consulta
	where	nr_sequencia = nr_sequencia_p
	and ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_reg_p)
	and	    obter_se_lib_nivel_atencao(ie_nivel_atencao,ie_niveis_lib_perfil_p,nm_usuario_reg_p) = 'S';

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_sup_lib_nivel_atencao ( ie_niveis_lib_perfil_p text, nm_usuario_reg_p text, nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
