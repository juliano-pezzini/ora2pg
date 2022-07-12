-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gerar_arquivo_dmed_cab ( nr_ano_referencia_p text, nr_ano_calendario_p text, nr_ind_retifcar_p text, nr_numero_registro_p text, ds_identificador_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000);			
separador_w	varchar(1) := '|';


BEGIN
ds_retorno_w :=  '';
ds_retorno_w :=	ds_retorno_w || 'Dmed' || separador_w ||nr_ano_referencia_p || separador_w || nr_ano_calendario_p ||
		separador_w  || nr_ind_retifcar_p || separador_w || nr_numero_registro_p || separador_w || ds_identificador_p || separador_w;
		

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gerar_arquivo_dmed_cab ( nr_ano_referencia_p text, nr_ano_calendario_p text, nr_ind_retifcar_p text, nr_numero_registro_p text, ds_identificador_p text) FROM PUBLIC;
