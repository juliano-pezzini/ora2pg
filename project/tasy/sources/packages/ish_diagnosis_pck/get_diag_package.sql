-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_diagnosis_pck.get_diag ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_doenca_p diagnostico_doenca.cd_doenca%type, ie_retorno_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);

BEGIN
begin
if (ie_retorno_p = 'D') then
	begin
	ds_retorno_w	:=	replace(replace(replace(replace(cd_doenca_p, '#', null), '*', null), '+', null), '!', null);
	end;
elsif (ie_retorno_p = 'T') then
	begin
	if (position('+' in cd_doenca_p) > 0) then
		ds_retorno_w	:=	'+';
	elsif (position('*' in cd_doenca_p) > 0) then
		ds_retorno_w	:=	'*';
	elsif (position('#' in cd_doenca_p) > 0) then
		ds_retorno_w	:=	'#';
	elsif (position('!' in cd_doenca_p) > 0) then
		ds_retorno_w	:=	'!';
	end if;

	if (coalesce(ds_retorno_w::text, '') = '') then
		begin --Por padrao, todo CID pai deve enviar o + no tipo.
		select	'+'
		into STRICT	ds_retorno_w
		from	diagnostico_doenca
		where	nr_atendimento		= nr_atendimento_p
		and	cd_doenca_superior	= cd_doenca_p  LIMIT 1;
		exception
		when others then
			ds_retorno_w := null;
		end;
	end if;

	end;
end if;
return ds_retorno_w;
exception
when others then
	return cd_doenca_p;
end;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_diagnosis_pck.get_diag ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_doenca_p diagnostico_doenca.cd_doenca%type, ie_retorno_p text) FROM PUBLIC;