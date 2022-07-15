-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_encaixe_agexame_a_js ( cd_agenda_p text, cd_agenda_destino_p text, nr_seq_agenda_p bigint, qt_duracao_p bigint, cd_pessoa_encaixe_p text, cd_executor_p text, dt_encaixe_p timestamp, dt_agenda_p timestamp, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text, cd_convenio_p bigint) AS $body$
DECLARE

 
ie_se_perm_pf_classif_w		varchar(80);		
ie_obriga_med_encaixe_w		varchar(255);
ie_forma_agendamento_w		varchar(255);
ie_consiste_med_executor_w	varchar(255);
dt_referencia_w			timestamp;
dt_encaixe_w			varchar(255);
ds_erro_w			varchar(255);
ds_texto_w			varchar(255);


BEGIN 
dt_referencia_w		:= pkg_date_utils.get_DateTime(dt_agenda_p, dt_encaixe_p);
 
ie_se_perm_pf_classif_w	:= substr(Obter_Se_Perm_PF_Classif(820, cd_agenda_p, cd_pessoa_encaixe_p, dt_referencia_w, 'DS'),1,80);
 
if (ie_se_perm_pf_classif_w IS NOT NULL AND ie_se_perm_pf_classif_w::text <> '') then 
	begin 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(43226,'IE_CLASSIFICACAO='||ie_se_perm_pf_classif_w);
	end;
end if;
 
CALL consistir_encaixe_agenda_exame(cd_agenda_destino_p, nr_seq_agenda_p, trunc(dt_agenda_p), 'N', cd_estabelecimento_p, nm_usuario_p, dt_encaixe_p, cd_convenio_p);
 
ie_consiste_med_executor_w := Obter_Param_Usuario(820, 137, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_consiste_med_executor_w);
 
if (ie_consiste_med_executor_w = 'S') and (cd_executor_p IS NOT NULL AND cd_executor_p::text <> '') then 
	ds_erro_w := consistir_horario_med_encaixe(cd_executor_p, qt_duracao_p, dt_referencia_w, trunc(dt_agenda_p), ds_erro_w);
end if;
 
ds_erro_p	:= ds_erro_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_encaixe_agexame_a_js ( cd_agenda_p text, cd_agenda_destino_p text, nr_seq_agenda_p bigint, qt_duracao_p bigint, cd_pessoa_encaixe_p text, cd_executor_p text, dt_encaixe_p timestamp, dt_agenda_p timestamp, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text, cd_convenio_p bigint) FROM PUBLIC;

