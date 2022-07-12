-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_obriga_just_interacao (nr_prescricao_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1):= 'N';
qt_registro_w	bigint := 0;


BEGIN

if (ie_opcao_p = 'L') then
	begin
	select	count(*)
	into STRICT	qt_registro_w
	from	prescr_medica_interacao
	where	nr_prescricao	= nr_prescricao_p
	and	ie_severidade in ('L','M','S','I');
	end;
elsif (ie_opcao_p = 'M') then
	begin
	select	count(*)
	into STRICT	qt_registro_w
	from	prescr_medica_interacao
	where	nr_prescricao	= nr_prescricao_p
	and	ie_severidade in ('M','S');
	end;
elsif (ie_opcao_p = 'S') then
	begin
	select	count(*)
	into STRICT	qt_registro_w
	from	prescr_medica_interacao
	where	nr_prescricao	= nr_prescricao_p
	and	ie_severidade = 'S';
	end;
elsif (ie_opcao_p = 'I') then
	begin
	select	count(*)
	into STRICT	qt_registro_w
	from	prescr_medica_interacao
	where	nr_prescricao	= nr_prescricao_p
	and	ie_severidade 	= 'I';
	end;
end if;

if (qt_registro_w > 0) then
	ds_retorno_w	:= 'S';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_obriga_just_interacao (nr_prescricao_p bigint, ie_opcao_p text) FROM PUBLIC;
