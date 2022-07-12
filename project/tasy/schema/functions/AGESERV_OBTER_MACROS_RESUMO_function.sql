-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageserv_obter_macros_resumo () RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(2000);


BEGIN

ds_retorno_w	:= 	replace(wheb_mensagem_pck.get_texto(800226), '@agenda', obter_traducao_macro_pront('@agenda',866)) ||CHR(10)||
			replace(wheb_mensagem_pck.get_texto(800228), '@horario', obter_traducao_macro_pront('@horario',866)) ||CHR(10)||
			replace(wheb_mensagem_pck.get_texto(800229), '@paciente', obter_traducao_macro_pront('@paciente',866)) ||CHR(10)||
			replace(wheb_mensagem_pck.get_texto(800230), '@convenio', obter_traducao_macro_pront('@convenio',866)) ||CHR(10)||
			replace(wheb_mensagem_pck.get_texto(800231), '@observacao', obter_traducao_macro_pront('@observacao',866)) ||CHR(10)||
			replace(wheb_mensagem_pck.get_texto(800234), '@classif', obter_traducao_macro_pront('@classif',866));

RETURN	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageserv_obter_macros_resumo () FROM PUBLIC;

