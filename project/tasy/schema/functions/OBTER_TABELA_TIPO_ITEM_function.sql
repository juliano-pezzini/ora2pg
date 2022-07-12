-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tabela_tipo_item ( ie_tipo_item_p text) RETURNS varchar AS $body$
DECLARE


nm_tabela_w		varchar(50);


BEGIN

case	ie_tipo_item_p
	when 'D'   then nm_tabela_w := 'PRESCR_DIETA';
	when 'O'   then nm_tabela_w := 'PRESCR_GASOTERAPIA';
	when 'HM'  then nm_tabela_w := 'PRESCR_PROCEDIMENTO';
	when 'P'   then nm_tabela_w := 'PRESCR_PROCEDIMENTO';
	when 'G'   then nm_tabela_w := 'PRESCR_PROCEDIMENTO';
	when 'C'   then nm_tabela_w := 'PRESCR_PROCEDIMENTO';
	when 'I'   then nm_tabela_w := 'PRESCR_PROCEDIMENTO';
	when 'L'   then nm_tabela_w := 'PRESCR_PROCEDIMENTO';
	when 'J'   then nm_tabela_w := 'REP_JEJUM';
	when 'MAT' then nm_tabela_w := 'PRESCR_MATERIAL';
	when 'M'   then nm_tabela_w := 'PRESCR_MATERIAL';
	when 'ME'  then nm_tabela_w := 'PRESCR_MATERIAL';
	when 'SNE' then nm_tabela_w := 'PRESCR_MATERIAL';
	when 'S'   then nm_tabela_w := 'PRESCR_MATERIAL';
	when 'LD'  then nm_tabela_w := 'PRESCR_MATERIAL';
	when 'IAG' then nm_tabela_w := 'PRESCR_MATERIAL';
	when 'IA'  then nm_tabela_w := 'PRESCR_MATERIAL';
	when 'IAH' then nm_tabela_w := 'PRESCR_MATERIAL';
	when 'NPN' then nm_tabela_w := 'NUT_PAC';
	when 'NAN' then nm_tabela_w := 'NUT_PAC';
	when 'R'   then nm_tabela_w := 'PRESCR_RECOMENDACAO';
	when 'SOL' then nm_tabela_w := 'PRESCR_SOLUCAO';
	when 'DI'  then nm_tabela_w := 'PRESCR_SOLUCAO';
	when 'E'   then nm_tabela_w := 'PE_PRESCR_PROC_HOR';
	when 'B'   then nm_tabela_w := 'PRESCR_MEDICA_ORDEM';
	else nm_tabela_w := '';
end case;

return	nm_tabela_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tabela_tipo_item ( ie_tipo_item_p text) FROM PUBLIC;

