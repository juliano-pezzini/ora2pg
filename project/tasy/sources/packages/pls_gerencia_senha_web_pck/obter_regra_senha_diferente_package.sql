-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_gerencia_senha_web_pck.obter_regra_senha_diferente ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS bigint AS $body$
DECLARE


qt_senha_diferente_w	bigint := 0;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
nr_seq_regra_w			pls_regra_senha_login_web.nr_sequencia%type;

BEGIN

if ((cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and cd_estabelecimento_p > 0) then
	cd_estabelecimento_w	:= cd_estabelecimento_p;
end if;

if (pls_obter_se_controle_estab('RE') = 'S') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_regra_w
	from	pls_regra_senha_login_web
	where	trunc(clock_timestamp()) between trunc(coalesce(dt_inicio_vigencia, clock_timestamp())) and trunc(coalesce(dt_fim_vigencia, clock_timestamp()))
	and (coalesce(cd_estabelecimento_w::text, '') = '' or cd_estabelecimento	= cd_estabelecimento_w);
else
	select	max(nr_sequencia)
	into STRICT	nr_seq_regra_w
	from	pls_regra_senha_login_web
	where	trunc(clock_timestamp()) between trunc(coalesce(dt_inicio_vigencia, clock_timestamp())) and trunc(coalesce(dt_fim_vigencia, clock_timestamp()));
end if;

if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then

	select	coalesce(qt_senha_diferente,0)
	into STRICT	qt_senha_diferente_w
	from	pls_regra_senha_login_web
	where	nr_sequencia = nr_seq_regra_w;
	
end if;

return qt_senha_diferente_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_gerencia_senha_web_pck.obter_regra_senha_diferente ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;