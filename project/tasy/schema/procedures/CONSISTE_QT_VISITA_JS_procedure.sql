-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_qt_visita_js ( nr_atendimento_p bigint, ie_idade_p bigint, cd_pessoa_fisica_p text, qt_visitante_p INOUT bigint, nr_idade_pf_p INOUT text, ds_texto1_p INOUT text, ds_texto2_p INOUT text) AS $body$
DECLARE


qt_visitante1_w		bigint;
qt_visitante2_w		bigint;
qt_visitante_w		bigint;
nr_idade_pf_w		bigint;
ds_texto1_w		varchar(500);
ds_texto2_w		varchar(500);


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (ie_idade_p IS NOT NULL AND ie_idade_p::text <> '')then
	begin

	select 	count(*)
	into STRICT	qt_visitante1_w
	from 	atendimento_acompanhante
	where 	nr_atendimento = nr_atendimento_p
	and 	coalesce(dt_saida::text, '') = ''
	and 	((coalesce(CD_PESSOA_FISICA::text, '') = '') or (coalesce(OBTER_IDADE_PF(cd_pessoa_fisica,clock_timestamp(),'A'),0) > ie_idade_p));

	select 	count(*)
	into STRICT	qt_visitante2_w
	from 	atendimento_visita
	where 	nr_atendimento = nr_atendimento_p
	and	coalesce(ie_paciente,'N') = 'N'
	and 	coalesce(dt_saida::text, '') = ''
	and 	((coalesce(CD_PESSOA_FISICA::text, '') = '') or (coalesce(OBTER_IDADE_PF(cd_pessoa_fisica,clock_timestamp(),'A'),0) > ie_idade_p));

	qt_visitante_w	:= qt_visitante1_w + qt_visitante2_w;

	nr_idade_pf_w	:= obter_idade_pf(cd_pessoa_fisica_p,clock_timestamp(),'A');

	ds_texto1_w	:= obter_texto_tasy(41574, 1);
	ds_texto2_w	:= obter_texto_tasy(41592, 1);

	end;
end if;

qt_visitante_p	:= qt_visitante_w;
nr_idade_pf_p	:= nr_idade_pf_w;
ds_texto1_p	:= ds_texto1_w;
ds_texto2_p	:= ds_texto2_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_qt_visita_js ( nr_atendimento_p bigint, ie_idade_p bigint, cd_pessoa_fisica_p text, qt_visitante_p INOUT bigint, nr_idade_pf_p INOUT text, ds_texto1_p INOUT text, ds_texto2_p INOUT text) FROM PUBLIC;

