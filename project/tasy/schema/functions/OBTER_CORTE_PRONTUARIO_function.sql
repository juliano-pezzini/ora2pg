-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_corte_prontuario ( cd_cgc_convenio_p text, dt_entrada_p timestamp, dt_alta_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1)	:= 'N';
qt_dias_w	bigint;
qt_dias_conv_w	bigint;


BEGIN

qt_dias_w	:= dt_alta_p - dt_entrada_p;

select	coalesce((Obter_Conversao_Externa(cd_cgc_convenio_p,'INTERF_UNIMED_LONDRINA_V','QT_DIAS_CONV','30'))::numeric ,30)
into STRICT	qt_dias_conv_w
;

if (qt_dias_w > qt_dias_conv_w) then
	ds_retorno_w	:= 'S';
end if;

return	coalesce(ds_retorno_w, 'N');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_corte_prontuario ( cd_cgc_convenio_p text, dt_entrada_p timestamp, dt_alta_p timestamp) FROM PUBLIC;

