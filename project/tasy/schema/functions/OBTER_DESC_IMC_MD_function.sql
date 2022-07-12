-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_imc_md ( qt_imc_p bigint, qt_idade_p bigint default null, qt_ig_semana_p bigint default null, ie_result_imc_p text default null) RETURNS varchar AS $body$
DECLARE

  ds_retorno_w	varchar(255);

BEGIN
	if (ie_result_imc_p	= 'O') then
		if (qt_imc_p	<=18.4) then
			ds_retorno_w	:= Wheb_mensagem_pck.get_texto(308991);
		elsif (qt_imc_p	>=18.5) and (qt_imc_p	<=24.9) then
			ds_retorno_w	:= lower(Wheb_mensagem_pck.get_texto(308986));
		elsif (qt_imc_p	>=25.0) and (qt_imc_p	<=29.9) then
			ds_retorno_w	:= lower(Wheb_mensagem_pck.get_texto(308987));
		elsif (qt_imc_p	>=30.0) and (qt_imc_p	<=34.9) then
			ds_retorno_w	:= Wheb_mensagem_pck.get_texto(308988);
		elsif (qt_imc_p	>=35.0) and (qt_imc_p	<=39.9) then
			ds_retorno_w	:= Wheb_mensagem_pck.get_texto(308989);
		elsif (qt_imc_p	>=40) then
			ds_retorno_w	:= Wheb_mensagem_pck.get_texto(308990);
		end if;
	elsif (ie_result_imc_p	= 'S') then
		if (qt_ig_semana_p IS NOT NULL AND qt_ig_semana_p::text <> '') then
			if (qt_ig_semana_p = 6) then
				if (qt_imc_p <= 19.9) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 24.9) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 30) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 30.1) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 7) then
				if (qt_imc_p <= 20) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 25) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 30.1) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 30.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 8) then
				if (qt_imc_p <= 20.1) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 25) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 30.1) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 30.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 9) then
				if (qt_imc_p <= 20.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 25.1) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 30.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 30.3) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 10) then
				if (qt_imc_p <= 20.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 25.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 30.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 30.3) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 11) then
				if (qt_imc_p <= 20.3) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 25.3) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 30.3) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 30.4) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 12) then
				if (qt_imc_p <= 20.4) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 25.4) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 30.3) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 30.4) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 13) then
				if (qt_imc_p <= 20.6) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 25.6) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 30.4) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 30.5) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 14) then
				if (qt_imc_p <= 20.7) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 25.7) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 30.5) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 30.6) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 15) then
				if (qt_imc_p <= 20.8) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 25.8) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 30.6) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 30.7) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 16) then
				if (qt_imc_p <= 21) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 25.9) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 30.7) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 30.8) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 17) then
				if (qt_imc_p <= 21.1) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 26) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 30.8) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 30.9) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 18) then
				if (qt_imc_p <= 21.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 26.1) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 30.9) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 31) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 19) then
				if (qt_imc_p <= 21.4) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 26.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 30.9) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 31) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 20) then
				if (qt_imc_p <= 21.5) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 26.3) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 31) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 31.1) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 21) then
				if (qt_imc_p <= 21.7) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 26.4) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 31.1) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 31.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 22) then
				if (qt_imc_p <= 21.8) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 26.6) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 31.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 31.3) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 23) then
				if (qt_imc_p <= 22) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 26.8) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 31.3) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 31.4) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 24) then
				if (qt_imc_p <= 22.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 26.9) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 31.5) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 31.6) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 25) then
				if (qt_imc_p <= 22.4) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 27) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 31.6) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 31.7) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 26) then
				if (qt_imc_p <= 22.6) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 27.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 31.7) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 31.8) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 27) then
				if (qt_imc_p <= 22.7) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 27.3) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 31.8) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 31.9) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 28) then
				if (qt_imc_p <= 22.9) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 27.5) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 31.9) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 32) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 29) then
				if (qt_imc_p <= 23.1) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 27.6) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 32) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 32.1) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 30) then
				if (qt_imc_p <= 23.3) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 27.8) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 32.1) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 32.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 31) then
				if (qt_imc_p <= 23.4) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 27.9) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 32.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 32.3) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 32) then
				if (qt_imc_p <= 23.6) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 28) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 32.3) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 32.4) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 33) then
				if (qt_imc_p <= 23.8) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 28.1) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 32.4) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 32.5) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 34) then
				if (qt_imc_p <= 23.9) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 28.3) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 32.5) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 32.6) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 35) then
				if (qt_imc_p <= 24.1) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 28.4) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 32.6) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 32.7) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 36) then
				if (qt_imc_p <= 24.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 28.5) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 32.7) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 32.8) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 37) then
				if (qt_imc_p <= 24.3) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 28.7) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 32.8) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 32.9) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 38) then
				if (qt_imc_p <= 24.5) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 28.8) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 32.9) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 33) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 39) then
				if (qt_imc_p <= 24.7) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 28.9) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 33) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 33.1) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 40) then
				if (qt_imc_p <= 24.9) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 29.1) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 33.1) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 33.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 41) then
				if (qt_imc_p <= 25) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 29.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 33.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 33.3) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			elsif (qt_ig_semana_p = 42) then
				if (qt_imc_p <= 25) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308991);
				elsif (qt_imc_p <= 29.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308992);
				elsif (qt_imc_p <= 33.2) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308993);
				elsif (qt_imc_p >= 33.3) then
					ds_retorno_w := Wheb_mensagem_pck.get_texto(308994);
				end if;
			end if;
		else
			if (qt_idade_p	>=20) and (qt_idade_p	< 60) then
				
				if (qt_imc_p	< 18.5) then
					ds_retorno_w	:= lower(Wheb_mensagem_pck.get_texto(308991));
				elsif (qt_imc_p	>= 18.5) and (qt_imc_p	< 25) then
					ds_retorno_w	:= lower(Wheb_mensagem_pck.get_texto(308986));
				elsif (qt_imc_p	>= 25) and (qt_imc_p	< 30) then
					ds_retorno_w	:= lower(Wheb_mensagem_pck.get_texto(308987));
				elsif (qt_imc_p	> 30) then
					ds_retorno_w	:= lower(Wheb_mensagem_pck.get_texto(309008));
				end if;
				
			elsif (qt_idade_p	>=60) then
				if (qt_imc_p	<= 22) then
					ds_retorno_w	:= lower(Wheb_mensagem_pck.get_texto(308991));
				elsif (qt_imc_p	>=22 ) and (qt_imc_p	<27) then
					ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309009);
				elsif (qt_imc_p	>= 27) then
					ds_retorno_w	:= lower(Wheb_mensagem_pck.get_texto(308987));
				end if;
			end if;	
		end if;
	elsif (ie_result_imc_p	= 'P') then
		begin
		if (qt_imc_p	<= 23) then
			ds_retorno_w	:= lower(Wheb_mensagem_pck.get_texto(308991));
		elsif (qt_imc_p	> 23) and (qt_imc_p	< 28) then
			ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309010);
		elsif (qt_imc_p	>= 28) and (qt_imc_p	< 30) then
			ds_retorno_w	:= lower(Wheb_mensagem_pck.get_texto(308987));
		elsif (qt_imc_p	>= 30) then
			ds_retorno_w	:= lower(Wheb_mensagem_pck.get_texto(309008));
		end if;		
		end;
	elsif (ie_result_imc_p = 'M') then
		begin
			if (qt_idade_p >= 19) and (qt_idade_p <= 59) then
				if (qt_imc_p < 16) then
					ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309014);
				elsif (qt_imc_p < 16.9) then
					ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309015);
				elsif (qt_imc_p <= 18.4) then
					ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309016);
				elsif (qt_imc_p <= 24.9) then
					ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309018);
				elsif (qt_imc_p <= 29.9) then
					ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309019);
				elsif (qt_imc_p <= 34.1) then
					ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309020);
				elsif (qt_imc_p <= 39.9) then
					ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309021);
				elsif (qt_imc_p >= 40) then
					ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309022);
				end if;
			elsif (qt_idade_p >= 60) then	
				if (qt_imc_p >= 18.5) and (qt_imc_p <= 21.9) then
					ds_retorno_w	:= lower(Wheb_mensagem_pck.get_texto(308991));
				elsif (qt_imc_p <= 26.9) then
					ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309018);
				elsif (qt_imc_p <= 29.9) then
					ds_retorno_w	:= Wheb_mensagem_pck.get_texto(308987);
				elsif (qt_imc_p <= 34.9) then
					ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309020);
				elsif (qt_imc_p <= 39.9) then
					ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309021);
				elsif (qt_imc_p >= 40) then
					ds_retorno_w	:= Wheb_mensagem_pck.get_texto(309022);
				end if;
			end if;
		end;
	elsif (ie_result_imc_p = 'OM') and (qt_idade_p	>= 10)then
		if (qt_imc_p	< 16.0) then
			ds_retorno_w	:= Wheb_mensagem_pck.get_texto(308982);
		elsif (qt_imc_p	>=16.0) and (qt_imc_p	<=16.9) then
			ds_retorno_w	:= Wheb_mensagem_pck.get_texto(308983);
		elsif (qt_imc_p	>=17.0) and (qt_imc_p	<=18.4) then
			ds_retorno_w	:= Wheb_mensagem_pck.get_texto(308985);
		elsif (qt_imc_p	>=18.5) and (qt_imc_p	<=24.9) then
			ds_retorno_w	:= lower(Wheb_mensagem_pck.get_texto(308986));
		elsif (qt_imc_p	>=25.0) and (qt_imc_p	<=29.9) then
			ds_retorno_w	:= Wheb_mensagem_pck.get_texto(308988);
		elsif (qt_imc_p	>=30.0) and (qt_imc_p	<=39.9) then
			ds_retorno_w	:= Wheb_mensagem_pck.get_texto(308989);
		elsif (qt_imc_p	>=40) then
			ds_retorno_w	:= Wheb_mensagem_pck.get_texto(308990);
		end if;
	end if;
  return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_imc_md ( qt_imc_p bigint, qt_idade_p bigint default null, qt_ig_semana_p bigint default null, ie_result_imc_p text default null) FROM PUBLIC;

