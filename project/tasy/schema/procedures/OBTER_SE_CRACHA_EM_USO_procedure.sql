-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_se_cracha_em_uso ( nr_controle_p text, cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


qt_acompanhantes_w	bigint;
qt_visitantes_w		bigint;
nr_controle_w		atendimento_visita.nr_seq_controle%type;

BEGIN
if (nr_controle_p IS NOT NULL AND nr_controle_p::text <> '') then
	
	select 	count(*)
	into STRICT	qt_visitantes_w
	from	atendimento_visita a
	where	coalesce(dt_saida::text, '') = ''
	and	coalesce(ie_paciente,'N') = 'N'
	and	nr_seq_controle = nr_controle_p;

	select 	count(*)
	into STRICT	qt_acompanhantes_w
	from	atendimento_acompanhante a
	where	coalesce(dt_saida::text, '') = ''
	and	nr_controle = nr_controle_p;

	if (coalesce(qt_visitantes_w,0) > 0) or (coalesce(qt_acompanhantes_w,0) > 0) then
		ds_erro_p := WHEB_MENSAGEM_PCK.get_texto(1073652, null);	
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_se_cracha_em_uso ( nr_controle_p text, cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

