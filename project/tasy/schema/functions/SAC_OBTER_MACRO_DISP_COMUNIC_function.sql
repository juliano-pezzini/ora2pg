-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sac_obter_macro_disp_comunic ( ie_tipo_p bigint) RETURNS varchar AS $body$
DECLARE



ds_retorno_w	varchar(2000);
ds_enter_w	varchar(10) := chr(13) || chr(10);


BEGIN
ds_retorno_w := substr(	'@nr_boletim = ' || substr(wheb_mensagem_pck.get_texto(301080),1,40) || ds_enter_w ||
			'@ds_pessoa_abertura = ' || substr(wheb_mensagem_pck.get_texto(301086),1,40) || ds_enter_w ||
			'@ds_pessoa_ref = ' || substr(wheb_mensagem_pck.get_texto(301087),1,60) || ds_enter_w ||
			'@ds_setor_ref = ' || wheb_mensagem_pck.get_texto(301088) || ds_enter_w ||
			'@ds_responsavel = ' || wheb_mensagem_pck.get_texto(386601) || ds_enter_w ||
			'@ds_ocorrencia = ' || wheb_mensagem_pck.get_texto(301089) || ds_enter_w ||
			'@ds_ultimo_historico = ' || wheb_mensagem_pck.get_texto(301090)  || ds_enter_w ||
			'@ds_motivo = ' || wheb_mensagem_pck.get_texto(301093)  || ds_enter_w ||
			'@ds_convenio = ' || wheb_mensagem_pck.get_texto(301209)  || ds_enter_w ||
			'@dt_ocorrencia = '  || wheb_mensagem_pck.get_texto(302544)  || ds_enter_w ||
			'@nm_usuario_envio = ' || wheb_mensagem_pck.get_texto(302545)  || ds_enter_w ||
			'@nr_atendimento = ' || wheb_mensagem_pck.get_texto(302546) || ds_enter_w ||
			'@nm_paciente_atend = '|| wheb_mensagem_pck.get_texto(302547) || ds_enter_w ||
			'@nm_pessoa_reg = '|| wheb_mensagem_pck.get_texto(302550) ,1,2000);

if (ie_tipo_p in (1,3,8)) then
	ds_retorno_w := substr(ds_retorno_w || ds_enter_w || '@ds_resp_bo = ' || wheb_mensagem_pck.get_texto(302591),1,2000);
	ds_retorno_w := substr(ds_retorno_w || ds_enter_w || '@dt_resposta = ' || wheb_mensagem_pck.get_texto(302552),1,2000);
	ds_retorno_w := substr(ds_retorno_w || ds_enter_w || '@dt_encerramento = ' || wheb_mensagem_pck.get_texto(302572),1,2000);
end if;

if (ie_tipo_p in (1,3)) then /* Responsta do B.O */
	begin
	ds_retorno_w := substr(ds_retorno_w || ds_enter_w || '@ds_ocor_longa = ' || wheb_mensagem_pck.get_texto(302576),1,2000);
	ds_retorno_w := substr(ds_retorno_w || ds_enter_w || '@ds_status_atual = ' || wheb_mensagem_pck.get_texto(302579),1,2000);

	if (ie_tipo_p = 1) then
		ds_retorno_w := substr(ds_retorno_w || ds_enter_w || '@ds_status_ant = ' || wheb_mensagem_pck.get_texto(302580) ,1,2000);
	end if;
	end;
end if;

if (ie_tipo_p = 4) then
	ds_retorno_w :=  '';
	ds_retorno_w := substr(ds_retorno_w || ds_enter_w || '@dt_avaliacao = ' || wheb_mensagem_pck.get_texto(302581),1,2000);
	ds_retorno_w := substr(ds_retorno_w || ds_enter_w || '@dt_liberacao = ' || wheb_mensagem_pck.get_texto(302582),1,2000);
	ds_retorno_w := substr(ds_retorno_w || ds_enter_w || '@pessoa = ' || wheb_mensagem_pck.get_texto(302585),1,2000);
	ds_retorno_w := substr(ds_retorno_w || ds_enter_w || '@tipo = ' || wheb_mensagem_pck.get_texto(302586),1,2000);
	ds_retorno_w := substr(ds_retorno_w || ds_enter_w || '@nr_boletim = ' || wheb_mensagem_pck.get_texto(302587),1,2000);
	ds_retorno_w := substr(ds_retorno_w || ds_enter_w || '@seq_apres = ' || wheb_mensagem_pck.get_texto(302589),1,2000);
end if;

if (ie_tipo_p = 6) then
	ds_retorno_w := substr(ds_retorno_w || ds_enter_w || '@ds_resp_bo = ' || wheb_mensagem_pck.get_texto(302591),1,2000);
end if;

if (ie_tipo_p in (9,10)) then
	ds_retorno_w := substr(ds_retorno_w || ds_enter_w || '@ds_resp_bo = ' || wheb_mensagem_pck.get_texto(302591),1,2000);
	ds_retorno_w := substr(ds_retorno_w || ds_enter_w || '@usuario_historico = ' || wheb_mensagem_pck.get_texto(302593),1,2000);
	ds_retorno_w := substr(ds_retorno_w || ds_enter_w || '@data_historico = ' || wheb_mensagem_pck.get_texto(302594),1,2000);
end if;

if (ie_tipo_p = 11) then
	ds_retorno_w := substr(ds_retorno_w || ds_enter_w ||'@nr_seq_nao_conf = ' || wheb_mensagem_pck.get_texto(302597),1,2000);
end if;

return ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sac_obter_macro_disp_comunic ( ie_tipo_p bigint) FROM PUBLIC;
