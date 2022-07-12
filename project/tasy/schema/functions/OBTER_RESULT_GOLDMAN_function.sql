-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_result_goldman (nr_pontuacao_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* ie_opcao_p:
'CL'	= Classe de risco
'S'	= % Sem complicações
'C'	= % Com complicações
'O'	= % Óbito
*/
BEGIN
if (upper(ie_opcao_p) = 'CL') then
	if (nr_pontuacao_p <=5) then
		return 'I';
	elsif (nr_pontuacao_p <= 12) then
		return 'II';
	elsif (nr_pontuacao_p <= 25) then
		return 'III';
	else
		return 'IV';
	end if;
elsif (upper(ie_opcao_p) = 'S') then
	if (nr_pontuacao_p <=5) then
		return '99';
	elsif (nr_pontuacao_p <= 12) then
		return '93';
	elsif (nr_pontuacao_p <= 25) then
		return '86';
	else
		return '22';
	end if;
elsif (upper(ie_opcao_p) = 'C') then
	if (nr_pontuacao_p <=5) then
		return '0,7';
	elsif (nr_pontuacao_p <= 12) then
		return '5';
	elsif (nr_pontuacao_p <= 25) then
		return '11';
	else
		return '22';
	end if;
elsif (upper(ie_opcao_p) = 'O') then
	if (nr_pontuacao_p <=5) then
		return '0,2';
	elsif (nr_pontuacao_p <= 12) then
		return '2';
	elsif (nr_pontuacao_p <= 25) then
		return '2';
	else
		return '56';
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_result_goldman (nr_pontuacao_p bigint, ie_opcao_p text) FROM PUBLIC;

