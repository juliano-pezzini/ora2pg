-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_modalidade_isite (cd_tipo_procedimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(2);


BEGIN

/*
1               Radiografia     CR			ok
2               Ultrassonografia   US			ok
3               Tomografia   CT			ok
4               Ressonância Magnética MR		ok
5               Mamografia    MG			ok
7               Angiografia   XA			ok
92              Endoscopia     ES                                                    ok
97              Raios-x Contrastado     CR
104             Raio-x Intervencionista CR
107             Angioplastia   XA
*/
if (cd_tipo_procedimento_p = '1') then
ds_retorno_w := 'CR';
elsif (cd_tipo_procedimento_p = '2') then
ds_retorno_w := 'US';
elsif (cd_tipo_procedimento_p = '3') then
ds_retorno_w := 'CT';
elsif (cd_tipo_procedimento_p = '4') then
ds_retorno_w := 'MR';
elsif (cd_tipo_procedimento_p = '5') then
ds_retorno_w := 'MG';
elsif (cd_tipo_procedimento_p = '97') then
ds_retorno_w := 'CR';
elsif (cd_tipo_procedimento_p = '92') then
ds_retorno_w := 'ES';
elsif (cd_tipo_procedimento_p = '7') then
ds_retorno_w := 'XA';
elsif (cd_tipo_procedimento_p = '104') then
ds_retorno_w := 'CR';
elsif (cd_tipo_procedimento_p = '107') then
ds_retorno_w := 'XA';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_modalidade_isite (cd_tipo_procedimento_p bigint) FROM PUBLIC;

