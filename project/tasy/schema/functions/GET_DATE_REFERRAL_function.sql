-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_date_referral ( cd_pessoa_fisica_p pessoa_titular_convenio.cd_pessoa_fisica%type, dt_entrada_p atendimento_paciente.dt_entrada%type) RETURNS timestamp AS $body$
DECLARE


dt_retorno_w		pessoa_titular_convenio.dt_inicio_vigencia%type;
cd_convenio_w		pessoa_titular_convenio.cd_convenio%type;
dt_inicio_vigencia_w	pessoa_titular_convenio.dt_inicio_vigencia%type;


BEGIN

dt_retorno_w := null;

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '')then

	select  max(ptc.cd_convenio),
		max(ptc.dt_inicio_vigencia)
	into STRICT	cd_convenio_w,
		dt_inicio_vigencia_w
	from    pessoa_titular_convenio ptc,
		convenio c
	where (ptc.dt_inicio_vigencia <= trunc(dt_entrada_p) and (coalesce(ptc.dt_fim_vigencia::text, '') = '' or ptc.dt_fim_vigencia >= trunc(dt_entrada_p)))
	and     c.ie_tipo_convenio = 11
	and     ptc.cd_convenio = c.cd_convenio
	and     ptc.cd_pessoa_fisica = cd_pessoa_fisica_p;

	if (dt_entrada_p IS NOT NULL AND dt_entrada_p::text <> '' AND dt_inicio_vigencia_w IS NOT NULL AND dt_inicio_vigencia_w::text <> '') then
		if ((to_char(dt_entrada_p,'mm'))::numeric  <= 3) then
			dt_retorno_w := PKG_DATE_UTILS.start_of(to_date('01/01/'||to_char(dt_entrada_p,'yyyy'),'dd/mm/yyyy'),'MONTH');
		elsif ((to_char(dt_entrada_p,'mm'))::numeric  <= 6) then
			dt_retorno_w := PKG_DATE_UTILS.start_of(to_date('01/04/'||to_char(dt_entrada_p,'yyyy'),'dd/mm/yyyy'),'MONTH');
		elsif ((to_char(dt_entrada_p,'mm'))::numeric  <= 9) then
			dt_retorno_w := PKG_DATE_UTILS.start_of(to_date('01/07/'||to_char(dt_entrada_p,'yyyy'),'dd/mm/yyyy'),'MONTH');		
		else
			dt_retorno_w := PKG_DATE_UTILS.start_of(to_date('01/10/'||to_char(dt_entrada_p,'yyyy'),'dd/mm/yyyy'),'MONTH');
		end if;
		
		if (dt_inicio_vigencia_w > dt_retorno_w)then
			dt_retorno_w := dt_inicio_vigencia_w;
		end if;
	end if;

end if;

return dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_date_referral ( cd_pessoa_fisica_p pessoa_titular_convenio.cd_pessoa_fisica%type, dt_entrada_p atendimento_paciente.dt_entrada%type) FROM PUBLIC;

