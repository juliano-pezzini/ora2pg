-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_descricao_motivo_sib (cd_motivo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(2000);

BEGIN

if (cd_motivo_p = 1) then
	return 'Rompimento do contrato por iniciativa do beneficiário';
elsif (cd_motivo_p = 2) then
	return 'Término da relação de vinculado a um beneficiário titular';
elsif (cd_motivo_p = 3) then
	return 'Desligamento da empresa (para planos coletivos)';
elsif (cd_motivo_p = 4) then
	return 'Inadimplência';
elsif (cd_motivo_p = 5) then
	return 'Óbito';
elsif (cd_motivo_p = 7) then
	return 'Exclusão decorrente de mudança de código de beneficiário motivada pela adaptação de sistema da operadora';
elsif (cd_motivo_p = 8) then
	return 'Tranferência de carteira';
elsif (cd_motivo_p = 9) then
	return 'Alteração individual do código do beneficiário';
elsif (cd_motivo_p = 13) then
	return 'Inclusão indevida de beneficiários';
elsif (cd_motivo_p = 14) then
	return 'Fraude (art. 13 da Lei nº 9.656/98)';
elsif (cd_motivo_p = 6) then
	return 'Mudança de plano';
elsif (cd_motivo_p = 11) then
	return 'Plano antigo migrado';
elsif (cd_motivo_p = 12) then
	return 'Plano antigo adaptado';
elsif (cd_motivo_p = 15) then
	return 'Inclusão de novos beneficiários';
elsif (cd_motivo_p = 16) then
	return 'Inclusão de beneficiários motivada por transferência voluntária de carteira';
elsif (cd_motivo_p = 17) then
	return 'Inclusão de beneficiários motivada por transferência compulsória de carteira';
elsif (cd_motivo_p = 18) then
	return 'Inclusão decorrente de mudança de código de beneficiário motivada pela adaptação de sistema da operadora';
/*aaschlote 25/05/2011 OS - 305656*/

elsif (cd_motivo_p = 41) then
	return 'Rompimento do contrato por iniciativa do beneficiário';
elsif (cd_motivo_p = 42) then
	return 'Desligamento da empresa (para planos coletivos)';
elsif (cd_motivo_p = 43) then
	return 'Inadimplência';
elsif (cd_motivo_p = 44) then
	return 'Óbito';
elsif (cd_motivo_p = 45) then
	return 'Tranferência de carteira';
elsif (cd_motivo_p = 46) then
	return 'Inclusão indevida de beneficiários';
elsif (cd_motivo_p = 47) then
	return 'Fraude (art. 13 da Lei nº 9.656/98)';
elsif (cd_motivo_p = 48) then
	return 'Por portabilidade de carência';
elsif (cd_motivo_p = 51) then
	return 'Correção de dados de beneficiários em registros ativos no cadastro de beneficiários do SIB/ANS';
else
	return null;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_descricao_motivo_sib (cd_motivo_p bigint) FROM PUBLIC;

