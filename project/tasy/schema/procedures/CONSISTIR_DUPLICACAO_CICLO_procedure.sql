-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_duplicacao_ciclo ( nr_seq_atendimento_p bigint, dt_prevista_p timestamp, dt_prevista_duplic_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, ds_pergunta_p INOUT text, ds_erro_p INOUT text) AS $body$
DECLARE


ie_exige_anotacao_duplic_w	varchar(1);
ie_nao_permite_data_igual_w	varchar(1);
ie_possui_anotacao_w	varchar(1);


BEGIN

/* Quimioterapia - Parametro [80] - Exige a informacao de anotacoes para duplicar ciclo */

ie_exige_anotacao_duplic_w := obter_param_usuario(3130, 80, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_exige_anotacao_duplic_w);

if (ie_exige_anotacao_duplic_w = 'S') then
	begin
	select	obter_se_possui_anotacao(nr_seq_atendimento_p)
	into STRICT	ie_possui_anotacao_w
	;

	if (ie_possui_anotacao_w = 'N') then
		ds_erro_p	:= substr(obter_texto_tasy(61436, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	end if;
	end;
end if;

if (coalesce(dt_prevista_duplic_p::text, '') = '') and (coalesce(ds_erro_p::text, '') = '') then
	ds_erro_p	:= substr(obter_texto_tasy(61438, wheb_usuario_pck.get_nr_seq_idioma),1,255);
end if;

if (coalesce(ds_erro_p::text, '') = '') then
	begin
	/* Quimioterapia - Parametro [81] - Consistir a data caso o ciclo esteja utilizando data prevista igual a data do ciclo a ser duplicado */

	ie_nao_permite_data_igual_w := obter_param_usuario(3130, 81, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_nao_permite_data_igual_w);

	if (ie_nao_permite_data_igual_w = 'S') and (ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_prevista_p) = ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_prevista_duplic_p)) then
		ds_erro_p	:= substr(obter_texto_tasy(61437, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	end if;
	end;
end if;

if (coalesce(ds_erro_p::text, '') = '') then
	ds_pergunta_p	:= substr(obter_texto_tasy(61440, wheb_usuario_pck.get_nr_seq_idioma),1,255);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_duplicacao_ciclo ( nr_seq_atendimento_p bigint, dt_prevista_p timestamp, dt_prevista_duplic_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, ds_pergunta_p INOUT text, ds_erro_p INOUT text) FROM PUBLIC;
