-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_usuario_excl_migr ( nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ie_excl_migr_w	varchar(1) := 'N';


BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	if (nm_usuario_p = 'Rafael') or (nm_usuario_p = 'ctheilacker') or (nm_usuario_p = 'jpweiss') or (nm_usuario_p = 'jojunior') or (nm_usuario_p = 'mkath') or (nm_usuario_p = 'amleicht') or (nm_usuario_p = 'ascarneiro') or (nm_usuario_p = 'mfcrodrigues') or (nm_usuario_p = 'jepalinguer') or (nm_usuario_p = 'crhobus') or (nm_usuario_p = 'akrauchuki') or (nm_usuario_p = 'rknoch') or (nm_usuario_p = 'lgggodoy') or (nm_usuario_p = 'algiovanini') or (nm_usuario_p = 'tpsilva') or (nm_usuario_p = 'hmpettenuci') or (nm_usuario_p = 'Jerusa') or (nm_usuario_p = 'trbarin') or (nm_usuario_p = 'peleicht') or (nm_usuario_p = 'acfkoehler') or (nm_usuario_p = 'wtpasold') or (nm_usuario_p = 'mmueller') or (nm_usuario_p = 'aarbigaus') or (nm_usuario_p = 'tfferretti') or (nm_usuario_p = 'jahfilho') or (nm_usuario_p = 'lfhinckel') or (nm_usuario_p = 'waskroth') or (nm_usuario_p = 'dsilva') or (nm_usuario_p = 'wfkoehler') or (nm_usuario_p = 'epmallmann') or (nm_usuario_p = 'sbraun') or (nm_usuario_p = 'bwoerner') or (nm_usuario_p = 'gsautner') or (nm_usuario_p = 'atinti') or (nm_usuario_p = 'fgums') then
		begin
		ie_excl_migr_w := 'S';
		end;
	end if;
	end;
end if;
return ie_excl_migr_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_usuario_excl_migr ( nm_usuario_p text) FROM PUBLIC;
