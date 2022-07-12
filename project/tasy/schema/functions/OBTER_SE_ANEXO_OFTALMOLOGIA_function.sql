-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_anexo_oftalmologia (nr_atendimento_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


qt_anexos_oft_w         bigint := 0;
ie_retorno_w	        varchar(1):= 'N';



BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') or (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	SELECT	SUM(valor1)
	into STRICT 		qt_anexos_oft_w
	FROM (	SELECT  	COUNT(*) valor1
					FROM    	oft_anexo a,
								oft_consulta b
					WHERE   	a.nr_seq_consulta  = b.nr_sequencia
					and		coalesce(b.dt_cancelamento::text, '') = ''
					AND     	b.nr_atendimento   = nr_atendimento_p
					
UNION ALL

					SELECT  	COUNT(*) valor1
					FROM    	oft_anexo a,
								oft_consulta b,
								atendimento_paciente c
					WHERE   	a.nr_seq_consulta  = b.nr_sequencia
					AND     	b.nr_atendimento   = c.nr_atendimento
					and		coalesce(b.dt_cancelamento::text, '') = ''
					AND     	c.cd_pessoa_fisica = cd_pessoa_fisica_p
					
UNION ALL

					SELECT  	COUNT(*) valor1
					FROM    	oft_anexo x,
								oft_consulta y
					WHERE   	x.nr_seq_consulta  = y.nr_sequencia
					AND     	y.cd_pessoa_fisica = cd_pessoa_fisica_p
					and		coalesce(y.dt_cancelamento::text, '') = '') alias9;
end if;

if (qt_anexos_oft_w > 0)  then
		ie_retorno_w	:=	'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_anexo_oftalmologia (nr_atendimento_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;
