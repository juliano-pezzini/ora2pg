-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rothman_obter_ritmo_card (ie_ritmo_ecg_p text) RETURNS varchar AS $body$
BEGIN


if (ie_ritmo_ecg_p	= '1') then
	return 'SR=';
elsif (ie_ritmo_ecg_p	= '2') then
	return 'ST=';
elsif (ie_ritmo_ecg_p	= '3') then
	return 'ST=';
elsif (ie_ritmo_ecg_p	= '4') then
	return 'AF=';
elsif (ie_ritmo_ecg_p	= '5') then
	return 'AFL';
elsif (ie_ritmo_ecg_p	= '6') then
	return 'JR=';
elsif (ie_ritmo_ecg_p	= '7') then
	return 'ST=';
elsif (ie_ritmo_ecg_p	= '8') then
	return 'HB=';
elsif (ie_ritmo_ecg_p	= '9') then
	return 'HB=';
elsif (ie_ritmo_ecg_p	= '10') then
	return 'P=P';
elsif (ie_ritmo_ecg_p	= '11') then
	return 'VT=';
elsif (ie_ritmo_ecg_p	= '12') then
	return 'VF=';
elsif (ie_ritmo_ecg_p	= '13') then
	return 'EXP';
elsif (ie_ritmo_ecg_p	= '14') then
	return 'ST=';
elsif (ie_ritmo_ecg_p	= '15') then
	return 'VT=';
elsif (ie_ritmo_ecg_p	= '16') then
	return 'VF=';
elsif (ie_ritmo_ecg_p	= '17') then
	return 'HB=';
elsif (ie_ritmo_ecg_p	= '18') then
	return 'HB=';
elsif (ie_ritmo_ecg_p	= '19') then
	return 'ST=';
elsif (ie_ritmo_ecg_p	= '20') then
	return 'SB=';
elsif (ie_ritmo_ecg_p	= '21') then
	return 'EXP';
elsif (ie_ritmo_ecg_p	= '22') then
	return 'ST=';
elsif (ie_ritmo_ecg_p	= '23') then
	return 'EXP';
else
	return ie_ritmo_ecg_p;
end if;


return	null;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rothman_obter_ritmo_card (ie_ritmo_ecg_p text) FROM PUBLIC;

