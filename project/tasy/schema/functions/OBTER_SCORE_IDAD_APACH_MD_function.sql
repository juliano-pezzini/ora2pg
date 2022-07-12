-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_idad_apach_md (qt_idade_p bigint ) RETURNS bigint AS $body$
DECLARE


   qt_pt_idade_w	smallint;

BEGIN
	--- Inicio MD19
	-- Idade 
	if (qt_idade_p	<=	44) then
		qt_pt_idade_w	:=	0;
	elsif (qt_idade_p	<=	59) then
		qt_pt_idade_w	:=	5;
	elsif (qt_idade_p	<=	64) then
		qt_pt_idade_w	:=	11;
	elsif (qt_idade_p	<=	69) then
		qt_pt_idade_w	:=	13;
	elsif (qt_idade_p	<=	74) then
		qt_pt_idade_w	:=	16;
	elsif (qt_idade_p	<=	84) then
		qt_pt_idade_w	:=	17;
	else
		qt_pt_idade_w	:=	24;
	end if;
	--- Fim MD19
    RETURN qt_pt_idade_w;
   
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_idad_apach_md (qt_idade_p bigint ) FROM PUBLIC;
