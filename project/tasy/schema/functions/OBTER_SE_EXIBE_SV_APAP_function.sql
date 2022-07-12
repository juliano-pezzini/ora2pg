-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibe_sv_apap ( ie_mediana_p text, ie_mediana_sv_p text, ie_mediana_1_min_p text, ie_mediana_5_min_p text, ie_mediana_10_min_p text, ie_mediana_15_min_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w   varchar(1) := 'N';

BEGIN
if (coalesce(ie_mediana_p,'N') = 'N') and (coalesce(ie_mediana_sv_p::text, '') = '') then
   ds_retorno_w := 'S';
elsif (coalesce(ie_mediana_p,'N') in ('S','C')) then
   if (ie_mediana_p = 'C') and (coalesce(ie_mediana_sv_p::text, '') = '') then
      ds_retorno_w := 'S';
   elsif (ie_mediana_sv_p = '1') and (coalesce(ie_mediana_1_min_p,'N') = 'S') then
      ds_retorno_w := 'S';
   elsif (ie_mediana_sv_p = '5') and (coalesce(ie_mediana_5_min_p,'N') = 'S') then
      ds_retorno_w := 'S';
   elsif (ie_mediana_sv_p = '10') and (coalesce(ie_mediana_10_min_p,'N') = 'S') then
      ds_retorno_w := 'S';
   elsif (ie_mediana_sv_p = '15') and (coalesce(ie_mediana_15_min_p,'N') = 'S') then
      ds_retorno_w := 'S';
   end if;
end if;

return   ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibe_sv_apap ( ie_mediana_p text, ie_mediana_sv_p text, ie_mediana_1_min_p text, ie_mediana_5_min_p text, ie_mediana_10_min_p text, ie_mediana_15_min_p text) FROM PUBLIC;
