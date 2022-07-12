-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estado_nasc_rfc ( sg_estado_p text) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w			varchar(255);


BEGIN
if (sg_estado_p = 'AGU') then
	ds_retorno_w	:= 'AS';
elsif (sg_estado_p = 'BCN') then
	ds_retorno_w	:= 'BC';
elsif (sg_estado_p = 'BCS') then
	ds_retorno_w	:= 'BS';
elsif (sg_estado_p = 'CAM') then
	ds_retorno_w	:= 'CC';
elsif (sg_estado_p = 'CHP') then
	ds_retorno_w	:= 'CP';
elsif (sg_estado_p = 'CHH') then
	ds_retorno_w	:= 'CH';
elsif (sg_estado_p = 'COA') then
	ds_retorno_w	:= 'CL';
elsif (sg_estado_p = 'COL') then
	ds_retorno_w	:= 'CM';
elsif (sg_estado_p = 'DIF') then
	ds_retorno_w	:= 'DF';
elsif (sg_estado_p = 'DUR') then
	ds_retorno_w	:= 'DG';
elsif (sg_estado_p = 'MEX') then
	ds_retorno_w	:= 'MC';--'EM';
elsif (sg_estado_p = 'GUA') then
	ds_retorno_w	:= 'GT';
elsif (sg_estado_p = 'GRO') then
	ds_retorno_w	:= 'GR';
elsif (sg_estado_p = 'HID') then
	ds_retorno_w	:= 'HG';
elsif (sg_estado_p = 'JAL') then
	ds_retorno_w	:= 'JC';
elsif (sg_estado_p = 'MIC') then
	ds_retorno_w	:= 'MN';
elsif (sg_estado_p = 'MOR') then
	ds_retorno_w	:= 'ML';
elsif (sg_estado_p = 'NAY') then
	ds_retorno_w	:= 'NT';
elsif (sg_estado_p = 'NLE') then
	ds_retorno_w	:= 'NL';
elsif (sg_estado_p = 'OAX') then
	ds_retorno_w	:= 'OC';
elsif (sg_estado_p = 'PUE') then
	ds_retorno_w	:= 'PL';
elsif (sg_estado_p = 'QUE') then
	ds_retorno_w	:= 'QR';
elsif (sg_estado_p = 'ROO') then
	ds_retorno_w	:= 'QR';
elsif (sg_estado_p = 'SLP') then
	ds_retorno_w	:= 'SP';
elsif (sg_estado_p = 'SIN') then
	ds_retorno_w	:= 'SL';
elsif (sg_estado_p = 'SON') then
	ds_retorno_w	:= 'SR';
elsif (sg_estado_p = 'TAB') then
	ds_retorno_w	:= 'TC';
elsif (sg_estado_p = 'TAM') then
	ds_retorno_w	:= 'TP';
elsif (sg_estado_p = 'TLA') then
	ds_retorno_w	:= 'TL';
elsif (sg_estado_p = 'VER') then
	ds_retorno_w	:= 'VZ';
elsif (sg_estado_p = 'YUC') then
	ds_retorno_w	:= 'YN';
elsif (sg_estado_p = 'ZAC') then
	ds_retorno_w	:= 'ZS';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estado_nasc_rfc ( sg_estado_p text) FROM PUBLIC;

