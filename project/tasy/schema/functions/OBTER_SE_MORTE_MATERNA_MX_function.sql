-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_morte_materna_mx (nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


 qt_cert_obito_w	bigint := 0;

BEGIN

	if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

		select count(d.nr_sequencia)
		into STRICT qt_cert_obito_w
		from atendimento_paciente a,
			 declaracao_obito d,
			 nascimento nac
		where a.nr_atendimento	= d.nr_atendimento
		and nac.nr_atendimento = a.nr_atendimento
		and d.ie_situacao = 'A'
		and	coalesce(d.dt_inativacao::text, '') = ''
		and (d.dt_liberacao IS NOT NULL AND d.dt_liberacao::text <> '')
		and (d.dt_obito IS NOT NULL AND d.dt_obito::text <> '')
		and (nac.dt_nascimento IS NOT NULL AND nac.dt_nascimento::text <> '')
		and	a.nr_atendimento = nr_atendimento_p;

	end if;

	return qt_cert_obito_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_morte_materna_mx (nr_atendimento_p bigint) FROM PUBLIC;
