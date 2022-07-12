-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_result_acp (qt_pontuacao_p bigint, qt_risco_p bigint, ie_opcao_p text, ie_complex_cirur_p text) RETURNS varchar AS $body$
DECLARE


ds_classe_w	varchar(255);
/*
 R                  = Risco
 C	= Classe
*/
BEGIN

if (ie_opcao_p	= 'C') then
	if (qt_pontuacao_p IS NOT NULL AND qt_pontuacao_p::text <> '') then

		if (qt_pontuacao_p <= 15)then
			ds_classe_w := 'I';
		elsif (qt_pontuacao_p between 20 and 30)then
			ds_classe_w := 'II';
		else
			ds_classe_w := 'III';
		end if;
	end if;
elsif (ie_opcao_p	= 'R') then
	if (qt_pontuacao_p IS NOT NULL AND qt_pontuacao_p::text <> '') then

		if (qt_pontuacao_p between 0 and 15) then
			if (qt_risco_p between 0 and 1) then
				ds_classe_w	:= 	'< 3%';
			elsif (qt_risco_p >= 2) then
				ds_classe_w	:=	'3% a 15%';
			end if;

		else
			ds_classe_w	:= '> 15%';
		end if;

		/*if 	(qt_pontuacao_p <= 15)then
			ds_classe_w := '5%';
		elsif 	(qt_pontuacao_p between 20 and 30)then
			ds_classe_w := '27%';
		else
			ds_classe_w := '60%';
		end if;*/
	end if;
elsif (ie_opcao_p	= 'COND') then
	if (qt_pontuacao_p IS NOT NULL AND qt_pontuacao_p::text <> '') and (ie_complex_cirur_p IS NOT NULL AND ie_complex_cirur_p::text <> '')then

		if (qt_pontuacao_p < 15)then
			if (qt_risco_p	<=1) then
				ds_classe_w := Wheb_mensagem_pck.get_texto(309656); --'Liberação para cirurgia.';
			else
				if (ie_complex_cirur_p = 'A') then
					ds_classe_w := Wheb_mensagem_pck.get_texto(309657); --'Realizar teste de isquemia.';
				else
					ds_classe_w := Wheb_mensagem_pck.get_texto(309656); --'Liberação para cirurgia.';
				end if;
			end if;

		elsif (qt_pontuacao_p between 20 and 30)then

			if (ie_complex_cirur_p = 'A') then
				ds_classe_w := Wheb_mensagem_pck.get_texto(309657); --'Realizar teste de isquemia.';
			else
				ds_classe_w := Wheb_mensagem_pck.get_texto(309656); --'Liberação para cirurgia.';
			end if;
		else
			ds_classe_w := Wheb_mensagem_pck.get_texto(309661); --'Alto risco: Considerar benefício do procedimento.';
		end if;
	end if;

end if;

return	ds_classe_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_result_acp (qt_pontuacao_p bigint, qt_risco_p bigint, ie_opcao_p text, ie_complex_cirur_p text) FROM PUBLIC;
