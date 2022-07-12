-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_extenso ( dt_parametro_p timestamp, ie_tipo_data_p bigint) RETURNS varchar AS $body$
DECLARE




/* IE_TIPO_DATA_P = */



/* 0 - 20 DE FEVEREIRO DE 2001 */



/* 1 - FEVEREIRO DE 2001 */



/* 2 - 2001 */



/* 3 - SEGUNDA, 20 DE FEVEREIRO DE 2001 */



/* 4 - FEVEREIRO */



/* 5 - FEV - 01 */



/* 6 - 20/Fev*/



/* 7 - fevereiro/12*/



/* 8 - 20/Fev/2018*/

ds_retorno_w	varchar(100);

nr_seq_idioma_w	bigint;




BEGIN

if (ie_tipo_data_p	= 0) then

	begin

	select substr(pkg_date_utils.extract_field('DAY', dt_parametro_p, 0) ||' '|| CASE WHEN wheb_usuario_pck.get_nr_seq_idioma=9 THEN ''  ELSE LOWER(wheb_mensagem_pck.get_texto(69051)) END  ||' '||

		 CASE WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=1 THEN  wheb_mensagem_pck.get_texto(292749) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=2 THEN  wheb_mensagem_pck.get_texto(292751) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=3 THEN  wheb_mensagem_pck.get_texto(292752) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=4 THEN  wheb_mensagem_pck.get_texto(292753) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=5 THEN  wheb_mensagem_pck.get_texto(292754) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=6 THEN  wheb_mensagem_pck.get_texto(292755) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=7 THEN  wheb_mensagem_pck.get_texto(292756) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=8 THEN  wheb_mensagem_pck.get_texto(292761) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=9 THEN  wheb_mensagem_pck.get_texto(292762) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=10 THEN  wheb_mensagem_pck.get_texto(292767) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=11 THEN  wheb_mensagem_pck.get_texto(292768) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=12 THEN  wheb_mensagem_pck.get_texto(292769) END

		||' '|| CASE WHEN wheb_usuario_pck.get_nr_seq_idioma=9 THEN ''  ELSE LOWER(wheb_mensagem_pck.get_texto(69051)) END  ||' '||

		pkg_date_utils.extract_field('YEAR', dt_parametro_p, 0), 1, 100)

	into STRICT	ds_retorno_w

	;

	end;

elsif (ie_tipo_data_p	= 1) then

	begin

	select CASE WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=1 THEN  wheb_mensagem_pck.get_texto(458058) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- Janeiro
		2 THEN  wheb_mensagem_pck.get_texto(458059) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Fevereiro
		3 THEN  wheb_mensagem_pck.get_texto(458060) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Marco
		4 THEN  wheb_mensagem_pck.get_texto(458061) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Abril
		5 THEN  wheb_mensagem_pck.get_texto(458062) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Maio
		6 THEN  wheb_mensagem_pck.get_texto(458063) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Junho
		7 THEN  wheb_mensagem_pck.get_texto(458064) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Julho
		8 THEN  wheb_mensagem_pck.get_texto(458065) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Agosto
		9 THEN  wheb_mensagem_pck.get_texto(458066) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Setembro
		10 THEN  wheb_mensagem_pck.get_texto(458067) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Outubro
		11 THEN  wheb_mensagem_pck.get_texto(458068) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Novembro
		12 THEN  wheb_mensagem_pck.get_texto(458069) END   -- Dezembro
		||' '|| lower(wheb_mensagem_pck.get_texto(69051)) ||' '||  -- de
		pkg_date_utils.extract_field('YEAR', dt_parametro_p, 0)

	into STRICT	 ds_retorno_w

	;

	end;

elsif (ie_tipo_data_p	= 2) then

	begin

	select 	pkg_date_utils.extract_field('YEAR', dt_parametro_p, 0)

	into STRICT	ds_retorno_w

	;

	end;

elsif (ie_tipo_data_p	= 3) then

	begin

	--select decode(to_number(to_char(dt_parametro_p,'d')),1,'Domingo',
	select CASE WHEN pkg_date_utils.get_weekday(dt_parametro_p)=1 THEN  wheb_mensagem_pck.get_texto(458094) WHEN pkg_date_utils.get_weekday(dt_parametro_p)= -- Domingo
		2 THEN  wheb_mensagem_pck.get_texto(458095) WHEN pkg_date_utils.get_weekday(dt_parametro_p)=	-- Segunda-feira
		3 THEN  wheb_mensagem_pck.get_texto(458096) WHEN pkg_date_utils.get_weekday(dt_parametro_p)=  -- Terca-feira
		4 THEN  wheb_mensagem_pck.get_texto(458097) WHEN pkg_date_utils.get_weekday(dt_parametro_p)=  -- Quarta-feira
		5 THEN  wheb_mensagem_pck.get_texto(458098) WHEN pkg_date_utils.get_weekday(dt_parametro_p)=  -- Quinta-feira
		6 THEN  wheb_mensagem_pck.get_texto(458099) WHEN pkg_date_utils.get_weekday(dt_parametro_p)=  -- Sexta-feira
		7 THEN  wheb_mensagem_pck.get_texto(458105) END  || ', ' ||  --  Sabado
		pkg_date_utils.extract_field('DAY', dt_parametro_p, 0) ||' '|| lower(wheb_mensagem_pck.get_texto(69051)) ||' '||  -- de
		CASE WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=1 THEN  wheb_mensagem_pck.get_texto(292749) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- janeiro
		2 THEN  wheb_mensagem_pck.get_texto(292751) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- fevereiro
		3 THEN  wheb_mensagem_pck.get_texto(292752) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- marco
		4 THEN  wheb_mensagem_pck.get_texto(292753) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- abril
		5 THEN  wheb_mensagem_pck.get_texto(292754) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- maio
		6 THEN  wheb_mensagem_pck.get_texto(292755) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- junho
		7 THEN  wheb_mensagem_pck.get_texto(292756) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- julho
		8 THEN  wheb_mensagem_pck.get_texto(292761) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- agosto
		9 THEN  wheb_mensagem_pck.get_texto(292762) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- setembro
		10 THEN  wheb_mensagem_pck.get_texto(292767) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- outubro
		11 THEN  wheb_mensagem_pck.get_texto(292768) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- novembro
		12 THEN  wheb_mensagem_pck.get_texto(292769) END    -- dezembro
		||' '|| lower(wheb_mensagem_pck.get_texto(69051)) ||' '||  -- de
		pkg_date_utils.extract_field('YEAR', dt_parametro_p, 0)

	into STRICT	ds_retorno_w

	;

	end;

elsif (ie_tipo_data_p	= 4) then

	begin

	select CASE WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=1 THEN  wheb_mensagem_pck.get_texto(458058) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- Janeiro
		2 THEN  wheb_mensagem_pck.get_texto(458059) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Fevereiro
		3 THEN  wheb_mensagem_pck.get_texto(458060) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Marco
		4 THEN  wheb_mensagem_pck.get_texto(458061) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Abril
		5 THEN  wheb_mensagem_pck.get_texto(458062) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Maio
		6 THEN  wheb_mensagem_pck.get_texto(458063) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Junho
		7 THEN  wheb_mensagem_pck.get_texto(458064) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Julho
		8 THEN  wheb_mensagem_pck.get_texto(458065) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Agosto
		9 THEN  wheb_mensagem_pck.get_texto(458066) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Setembro
		10 THEN  wheb_mensagem_pck.get_texto(458067) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Outubro
		11 THEN  wheb_mensagem_pck.get_texto(458068) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- Novembro
		12 THEN  wheb_mensagem_pck.get_texto(458069) END   -- Dezembro
	into STRICT	 ds_retorno_w

	;

	end;

elsif (ie_tipo_data_p	= 5) then

	begin

	select CASE WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=1 THEN  wheb_mensagem_pck.get_texto(458106) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- jan
			2 THEN  wheb_mensagem_pck.get_texto(458107) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- fev
			3 THEN  wheb_mensagem_pck.get_texto(458108) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- mar
			4 THEN  wheb_mensagem_pck.get_texto(458109) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- abr
			5 THEN  wheb_mensagem_pck.get_texto(458110) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- mai
			6 THEN  wheb_mensagem_pck.get_texto(458111) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- jun
			7 THEN  wheb_mensagem_pck.get_texto(458112) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- jul
			8 THEN  wheb_mensagem_pck.get_texto(458113) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- ago
			9 THEN  wheb_mensagem_pck.get_texto(458115) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- set
			10 THEN  wheb_mensagem_pck.get_texto(458116) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- out
			11 THEN  wheb_mensagem_pck.get_texto(458117) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- nov
			12 THEN  wheb_mensagem_pck.get_texto(458118) END  -- dez
	into STRICT	ds_retorno_w

	;



	ds_retorno_w	:= ds_retorno_w || ' - ' || to_char(ESTABLISHMENT_TIMEZONE_UTILS.startOfYear(dt_parametro_p),'YY');

	end;

elsif (ie_tipo_data_p	= 6) then

	begin

	select 	pkg_date_utils.extract_field('DAY', dt_parametro_p, 0) ||'/'||

		CASE WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=1 THEN  wheb_mensagem_pck.get_texto(458121) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- Jan
				2 THEN  wheb_mensagem_pck.get_texto(458122) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- Fev
				3 THEN  wheb_mensagem_pck.get_texto(458123) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- Mar
				4 THEN  wheb_mensagem_pck.get_texto(458124) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- Abr
				5 THEN  wheb_mensagem_pck.get_texto(458125) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- Mai
				6 THEN  wheb_mensagem_pck.get_texto(458126) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- Jun
				7 THEN  wheb_mensagem_pck.get_texto(458127) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- Jul
				8 THEN  wheb_mensagem_pck.get_texto(1188576) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- Ago
				9 THEN  wheb_mensagem_pck.get_texto(458129) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- Set
				10 THEN  wheb_mensagem_pck.get_texto(458131) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- Out
				11 THEN  wheb_mensagem_pck.get_texto(458132) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- Nov
				12 THEN  wheb_mensagem_pck.get_texto(458133) END  -- Dez
	into STRICT	 ds_retorno_w

	;

	end;

elsif (ie_tipo_data_p	= 7) then

	begin

	select 	CASE WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=1 THEN  wheb_mensagem_pck.get_texto(292749) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)= -- janeiro
		2 THEN  wheb_mensagem_pck.get_texto(292751) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- fevereiro
		3 THEN  wheb_mensagem_pck.get_texto(292752) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- marco
		4 THEN  wheb_mensagem_pck.get_texto(292753) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- abril
		5 THEN  wheb_mensagem_pck.get_texto(292754) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- maio
		6 THEN  wheb_mensagem_pck.get_texto(292755) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- junho
		7 THEN  wheb_mensagem_pck.get_texto(292756) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- julho
		8 THEN  wheb_mensagem_pck.get_texto(292761) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- agosto
		9 THEN  wheb_mensagem_pck.get_texto(292762) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- setembro
		10 THEN  wheb_mensagem_pck.get_texto(292767) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- outubro
		11 THEN  wheb_mensagem_pck.get_texto(292768) WHEN pkg_date_utils.extract_field('MONTH', dt_parametro_p, 0)=  -- novembro
		12 THEN  wheb_mensagem_pck.get_texto(292769) END    -- dezembro
	into STRICT	ds_retorno_w

	;



	ds_retorno_w	:= ds_retorno_w || ' - ' || to_char(ESTABLISHMENT_TIMEZONE_UTILS.startOfYear(dt_parametro_p),'YY');

	end;

elsif (ie_tipo_data_p	= 8) then

	begin

	select 	pkg_date_formaters.to_varchar(dt_parametro_p,

				pkg_date_formaters.localize_mask('shortThreeLetterMonth', pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario)),

				wheb_usuario_pck.get_cd_estabelecimento)

	into STRICT	ds_retorno_w

	;

	end;

end if;

return ds_retorno_w;

end;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_extenso ( dt_parametro_p timestamp, ie_tipo_data_p bigint) FROM PUBLIC;
