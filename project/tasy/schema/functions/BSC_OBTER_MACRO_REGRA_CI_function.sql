-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION bsc_obter_macro_regra_ci ( nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000) := '';


BEGIN
ds_retorno_w := 	substr('@NR_INICIATIVA'			|| CHR(13) || CHR(10) ||
		'@NM_SOLICITANTE'		|| CHR(13) || CHR(10) ||
		'@NM_RESPONSAVEL'		|| CHR(13) || CHR(10) ||
		'@DS_DESCRICAO'		|| CHR(13) || CHR(10) ||
		'@DS_ESTAGIO'			|| CHR(13) || CHR(10) ||
		'@DT_FIM_PREVISTO'		|| CHR(13) || CHR(10) ||
		'@DT_INICIO_PREVISTO'		|| CHR(13) || CHR(10) ||
		'@NM_RESP_INDICADOR'		|| CHR(13) || CHR(10) ||
		'@NM_INDICADOR_VINCULADO'	|| CHR(13) || CHR(10) ||
		'@DS_HISTORICO'			|| CHR(13) || CHR(10) ||
		'@DS_DANO' || CHR(13) || CHR(10) ||
		'@DS_EXECUTORES',1,4000);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION bsc_obter_macro_regra_ci ( nm_usuario_p text) FROM PUBLIC;
