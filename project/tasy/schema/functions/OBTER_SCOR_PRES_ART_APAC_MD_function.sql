-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_scor_pres_art_apac_md (qt_pa_diast_p bigint, qt_pa_sist_p bigint, qt_pa_diast_max_p bigint, qt_pa_sist_max_p bigint ) RETURNS bigint AS $body$
DECLARE


  qt_var_w							bigint;	
  qt_pt_pressao_arterial_min_w		smallint;
  qt_pt_pressao_arterial_max_w		smallint;
  qt_pt_pressao_arterial_w			smallint;

BEGIN
  --- Inicio MD4
  qt_var_w	:=	dividir_md((qt_pa_diast_p * 2 + qt_pa_sist_p),3);
  if (qt_var_w	<=	39) then
    qt_pt_pressao_arterial_min_w	:=	23;
  elsif (qt_var_w	<=	59) then
    qt_pt_pressao_arterial_min_w	:=	15;
  elsif (qt_var_w	<=	69) then
    qt_pt_pressao_arterial_min_w	:=	7;
  elsif (qt_var_w	<=	79) then
    qt_pt_pressao_arterial_min_w	:=	6;
  elsif (qt_var_w	<=	99) then
    qt_pt_pressao_arterial_min_w	:=	0;
  elsif (qt_var_w	<=	119) then
    qt_pt_pressao_arterial_min_w	:=	4;
  elsif (qt_var_w	<=	129) then
    qt_pt_pressao_arterial_min_w	:=	7;
  elsif (qt_var_w	<=	139) then
    qt_pt_pressao_arterial_min_w	:=	9;
  else
    qt_pt_pressao_arterial_min_w	:=	10;
  end if;

  qt_var_w	:=	dividir_md((qt_pa_diast_max_p * 2 + qt_pa_sist_max_p),3);
  if (qt_var_w	<=	39) then
    qt_pt_pressao_arterial_max_w	:=	23;
  elsif (qt_var_w	<=	59) then
    qt_pt_pressao_arterial_max_w	:=	15;
  elsif (qt_var_w	<=	69) then
    qt_pt_pressao_arterial_max_w	:=	7;
  elsif (qt_var_w	<=	79) then
    qt_pt_pressao_arterial_max_w	:=	6;
  elsif (qt_var_w	<=	99) then
    qt_pt_pressao_arterial_max_w	:=	0;
  elsif (qt_var_w	<=	119) then
    qt_pt_pressao_arterial_max_w	:=	4;
  elsif (qt_var_w	<=	129) then
    qt_pt_pressao_arterial_max_w	:=	7;
  elsif (qt_var_w	<=	139) then
    qt_pt_pressao_arterial_max_w	:=	9;
  else
    qt_pt_pressao_arterial_max_w	:=	10;
  end if;
  --- Fim
  if (qt_pt_pressao_arterial_max_w > qt_pt_pressao_arterial_min_w) then
    qt_pt_pressao_arterial_w	:=	qt_pt_pressao_arterial_max_w;
  else
    qt_pt_pressao_arterial_w	:=	qt_pt_pressao_arterial_min_w;
  end if;

  return qt_pt_pressao_arterial_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_scor_pres_art_apac_md (qt_pa_diast_p bigint, qt_pa_sist_p bigint, qt_pa_diast_max_p bigint, qt_pa_sist_max_p bigint ) FROM PUBLIC;
