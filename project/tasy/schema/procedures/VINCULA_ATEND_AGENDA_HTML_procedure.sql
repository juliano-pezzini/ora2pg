-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincula_atend_agenda_html ( nr_seq_agenda_p bigint, nr_atendimento_p bigint, ie_atualiza_convenio_p text) AS $body$
DECLARE

													
cd_estabelecimento_w			integer;
cd_perfil_w						integer;
nm_usuario_w					varchar(15);
cd_convenio_atend_w			integer;
cd_categoria_atend_w			varchar(10);
ie_status_painel_w			varchar(15);
ie_atualiza_ged_w				varchar(15);
ie_integracao_w				varchar(15);
ie_executa_evento_w			varchar(15);
cd_pf_usuario_w				varchar(10);
ie_conv_menor_prio_w		parametro_agenda.ie_conv_menor_prio%type;
													
													

BEGIN

cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;
cd_perfil_w				:= wheb_usuario_pck.get_cd_perfil;
nm_usuario_w			:= wheb_usuario_pck.get_nm_usuario;
cd_pf_usuario_w		:=	obter_pf_usuario(nm_usuario_w,'C');

ie_integracao_w := Obter_Param_Usuario(871, 257, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_integracao_w);
ie_atualiza_ged_w := Obter_Param_Usuario(871, 657, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_atualiza_ged_w);
ie_status_painel_w := Obter_Param_Usuario(871, 754, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_status_painel_w);
													

CALL vinc_desv_atendimento_agenda(nr_seq_agenda_p,nr_atendimento_p,nm_usuario_w,'V');

if (ie_atualiza_convenio_p = 'S') then
	SELECT ie_conv_menor_prio
	INTO STRICT ie_conv_menor_prio_w
	FROM parametro_agenda
	WHERE cd_estabelecimento = obter_estabelecimento_ativo;
	if (ie_conv_menor_prio_w = 'S') then

		select	coalesce(obter_convenio_menor_prio(nr_atendimento_p),0)
		into STRICT	cd_convenio_atend_w
		;
		
		if (cd_convenio_atend_w > 0) then
			select	max(ac.cd_categoria)
			into STRICT	cd_categoria_atend_w
			from	atend_categoria_convenio ac
			where 	ac.nr_atendimento = nr_atendimento_p
			and 	ac.cd_convenio = cd_convenio_atend_w;
		end if;
	else
		select	coalesce(max(Obter_Convenio_Atendimento(nr_atendimento_p)),0),
			coalesce(max(Obter_Categoria_Atendimento(nr_atendimento_p)),0)
		into STRICT	cd_convenio_atend_w,
			cd_categoria_atend_w
		;
	end if;
	
	CALL atualizar_convenio_agenda(nr_seq_agenda_p,cd_convenio_atend_w,cd_categoria_atend_w);
end if;	

if (ie_status_painel_w IS NOT NULL AND ie_status_painel_w::text <> '') then
	CALL gerar_dados_painel_cirurgia(ie_status_painel_w,nr_seq_agenda_p,'A',nm_usuario_w,'S');
end if;

select 	max(obter_se_existe_evento_agenda(cd_estabelecimento_w,'VA','CI'))
into STRICT		ie_executa_evento_w
;

if (ie_executa_evento_w = 'S') then
	CALL executar_evento_agenda('VA','CI',nr_seq_agenda_p,cd_estabelecimento_w,nm_usuario_w,null,null);
end if;

if (ie_atualiza_ged_w = 'S') then
	CALL exportar_anexo_agenda_ged(nm_usuario_w,cd_pf_usuario_w,nr_seq_agenda_p);
end if;

CALL enviar_email_regra(nr_seq_agenda_p,'SA',nm_usuario_w,cd_estabelecimento_w);

if (ie_integracao_w <> 'N') then
	CALL vincula_atend_agend_opme(nr_seq_agenda_p,'V',nm_usuario_w);
end if;	

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincula_atend_agenda_html ( nr_seq_agenda_p bigint, nr_atendimento_p bigint, ie_atualiza_convenio_p text) FROM PUBLIC;
