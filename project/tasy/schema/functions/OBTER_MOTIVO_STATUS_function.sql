-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_motivo_status ( ie_status_rgct_p text, ie_motivo_status_p text) RETURNS varchar AS $body$
DECLARE

permite_w	varchar(10) := 'N';

BEGIN
if	(ie_status_rgct_p = 'I' AND ie_motivo_status_p = 'FCA') then
	permite_w := 'S';

elsif	((ie_status_rgct_p = 'S') and		((ie_motivo_status_p = 'EPI') or (ie_motivo_status_p = 'TUC') or (ie_motivo_status_p = 'SCC') or (ie_motivo_status_p = 'SV') or (ie_motivo_status_p = 'SSL') or (ie_motivo_status_p = 'SA'))) then
	permite_w := 'S';

elsif	((ie_status_rgct_p = 'R') and	((ie_motivo_status_p = 'AT') or (ie_motivo_status_p = 'MFC') or (ie_motivo_status_p = 'ACC') or (ie_motivo_status_p = 'SPL') or (ie_motivo_status_p = 'TE') or (ie_motivo_status_p = 'TFE') or (ie_motivo_status_p = 'TV') or (ie_motivo_status_p = 'TNV') or (ie_motivo_status_p = 'O') or (ie_motivo_status_p = 'DNT'))) then
	permite_w := 'S';
end if;
return	permite_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_motivo_status ( ie_status_rgct_p text, ie_motivo_status_p text) FROM PUBLIC;

