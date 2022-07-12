-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_oxigenacao_eapache_iv_md (qt_altitude_p bigint, qt_fio2_p bigint, ie_ventilacao_p text, qt_pco2_p bigint, qt_po2_p bigint ) RETURNS bigint AS $body$
DECLARE


   qt_var_w						bigint;	
   qt_pressao_atmosferica_w		double precision;
   qt_pt_po2_w					smallint;

BEGIN
	--- Inicio MD7
	qt_pressao_atmosferica_w	:=	round((760 * exp(dividir_md(qt_altitude_p,7924)))::numeric,2); -- Converte metros para mmHg;
	if ((qt_fio2_p	>=	50)	or (ie_ventilacao_p	=	'S')) then
		qt_var_w	:=	(dividir_sem_round_md(qt_fio2_p,100) * (qt_pressao_atmosferica_w - 47)) - dividir_md(qt_pco2_p,0.8) - qt_po2_p;
		qt_var_w	:=	round((qt_var_w)::numeric,2);
		if (qt_var_w	<	100) then
			qt_pt_po2_w	:=	0;
		elsif (qt_var_w	<=	249) then
			qt_pt_po2_w	:=	7;
		elsif (qt_var_w	<=	349) then
			qt_pt_po2_w	:=	9;
		elsif (qt_var_w	<=	499) then
			qt_pt_po2_w	:=	11;
		else
			qt_pt_po2_w	:=	14;
		end if;		
	else
		if (qt_po2_p	<=	49) then
			qt_pt_po2_w	:=	15;
		elsif (qt_po2_p	<=	69) then
			qt_pt_po2_w	:=	5;
		elsif (qt_po2_p	<=	79) then
			qt_pt_po2_w	:=	2;
		else
			qt_pt_po2_w	:=	0;
		end if;
	end if;	
	--- Fim MD7
    RETURN qt_pt_po2_w;
   
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_oxigenacao_eapache_iv_md (qt_altitude_p bigint, qt_fio2_p bigint, ie_ventilacao_p text, qt_pco2_p bigint, qt_po2_p bigint ) FROM PUBLIC;

