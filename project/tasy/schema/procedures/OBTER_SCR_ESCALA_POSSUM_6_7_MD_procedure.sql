-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_scr_escala_possum_6_7_md ( ie_atividades_sociais_p bigint, ie_dor_corpo_p bigint, qt_questao_6_p INOUT bigint, qt_questao_7_p INOUT bigint ) AS $body$
BEGIN

	qt_questao_6_p := ie_atividades_sociais_p;

	if (ie_dor_corpo_p = 1) then
	  qt_questao_7_p := 6;
	elsif (ie_dor_corpo_p = 2)	then
	  qt_questao_7_p := 5.4;
	elsif (ie_dor_corpo_p = 3)	then
	  qt_questao_7_p := 4.2;
	elsif (ie_dor_corpo_p = 4)	then
	  qt_questao_7_p := 3.1;
	elsif (ie_dor_corpo_p = 5)	then
	  qt_questao_7_p := 2;
	elsif (ie_dor_corpo_p = 6)	then
	  qt_questao_7_p := 1;
	end if;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_scr_escala_possum_6_7_md ( ie_atividades_sociais_p bigint, ie_dor_corpo_p bigint, qt_questao_6_p INOUT bigint, qt_questao_7_p INOUT bigint ) FROM PUBLIC;

