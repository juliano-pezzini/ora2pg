-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibir_fun_html5_tasy ( ie_base_wheb_p text, cd_estabelecimento_p text, cd_funcao_p bigint, ie_situacao_funcao_p text, ie_situacao_java_p text, ie_versao_utilizacao_p text default 'D', ie_utilitarios_p text default 'N') RETURNS varchar AS $body$
DECLARE

		
ie_exibir_funcao_w	varchar(1) := 'N';
ie_base_wheb_w	estabelecimento.ie_situacao%type := 'N';
		

BEGIN
if (ie_base_wheb_p = 'S') then
	begin
	if (ie_situacao_funcao_p in ('A','W') or (ie_utilitarios_p = 'S' and ie_situacao_funcao_p in ('C'))) and
		((ie_situacao_java_p in ('W','T','A','V')) or (cd_funcao_p in (9910, 1605, 1601,1604,1606, 1603,9033))) then -- >>> Tratar funcoes do TasyPaf <<<
		begin
		ie_exibir_funcao_w := 'S';
		end;
	end if;
	end;
elsif (ie_versao_utilizacao_p in ('H','V','J')) and (ie_situacao_java_p = 'A') and
	((ie_situacao_funcao_p in ('A') or (ie_utilitarios_p = 'S' and ie_situacao_funcao_p in ('C'))) or	 /* Francisco - 21/03/2014, inclui esse IF pois a Medicina Preventiva esta em homologacao */
	(ie_situacao_funcao_p = 'W' and (obter_se_funcao_lib_cliente(cd_estabelecimento_p,cd_funcao_p) = 'S'))) then
	begin
	ie_exibir_funcao_w := 'S';
	end;
elsif (ie_versao_utilizacao_p in ('J','A','H','V')) and((ie_situacao_funcao_p in ('A')) and (ie_situacao_java_p = 'A')) or
		((ie_situacao_funcao_p in ('A', 'W') or (ie_utilitarios_p = 'S' and ie_situacao_funcao_p in ('C'))) and (ie_situacao_java_p in ('W','T','A','V')) and (obter_se_funcao_lib_cliente(cd_estabelecimento_p,cd_funcao_p) = 'S')) then
		begin
		ie_exibir_funcao_w := 'S';
		end;
else
	begin
	if	((coalesce(ie_versao_utilizacao_p::text, '') = '') and (ie_situacao_funcao_p in ('A') or (ie_utilitarios_p = 'S' and ie_situacao_funcao_p in ('C'))) and (ie_situacao_java_p = 'A')) then
		begin
		ie_exibir_funcao_w := 'S';
		end;
	end if;
	end;
end if;

if (ie_base_wheb_p <> 'S' and ie_exibir_funcao_w = 'S') then
    if (GET_VALID_PFCS_FUNCTION(cd_funcao_p, 'N', 'Y') = 'N') then

        SELECT  coalesce(max('S'), 'N')
        into STRICT    ie_base_wheb_w
        FROM    estabelecimento
        WHERE cd_cgc = '01950338000177'
            AND    ie_situacao = 'A'
            AND    user = 'TASY';

        if (ie_base_wheb_w <> 'S') then
            ie_exibir_funcao_w := 'N';
        end if;
    end if;
end if;

return ie_exibir_funcao_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibir_fun_html5_tasy ( ie_base_wheb_p text, cd_estabelecimento_p text, cd_funcao_p bigint, ie_situacao_funcao_p text, ie_situacao_java_p text, ie_versao_utilizacao_p text default 'D', ie_utilitarios_p text default 'N') FROM PUBLIC;

