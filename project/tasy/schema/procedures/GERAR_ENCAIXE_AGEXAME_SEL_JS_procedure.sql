-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_encaixe_agexame_sel_js ( nr_seq_agenda_sel_p bigint, cd_agenda_p text, cd_agenda_usa_p text, dt_agenda_p timestamp, dt_encaixe_p text, ie_transferir_p text, qt_duracao_p bigint, cd_motivo_p text, ds_motivo_p text, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_seq_encaixe_p INOUT bigint, ds_carteiras_selec_p INOUT text, cd_convenio_p bigint) AS $body$
DECLARE


ie_se_perm_pf_classif_w		varchar(80);					
dt_encaixe_w			varchar(255);
dt_referencia_w			varchar(255);
dt_encaixe_cons_w		varchar(255);
cd_pessoa_fisica_w		varchar(10);
nr_seq_encaixe_w		bigint;
ie_consiste_med_executor_w	varchar(255);
ds_carteiras_selec_w		varchar(255);
ie_atualiza_plano_w		varchar(255);
ds_texto_w			varchar(255);
ie_permite_w			varchar(1) := 'S';
dt_teste_w				timestamp;


BEGIN
dt_encaixe_w		:= dt_encaixe_p || ':00';
dt_encaixe_cons_w	:= '31/12/1899 ' || dt_encaixe_w;
dt_referencia_w		:= to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || dt_encaixe_w;

if (nr_seq_agenda_sel_p IS NOT NULL AND nr_seq_agenda_sel_p::text <> '') then
	begin
	
	select	max(cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from	agenda_paciente
	where	nr_sequencia = nr_seq_agenda_sel_p;
	
	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
		begin
		ie_permite_w	:= Consiste_Agenda_Sexo(cd_pessoa_fisica_w, cd_agenda_p);

		if (ie_permite_w = 'N') then
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(268471);
		end if;
	
		ie_se_perm_pf_classif_w	:= substr(Obter_Se_Perm_PF_Classif(820, cd_agenda_p, cd_pessoa_fisica_w, to_date(dt_referencia_w,'dd/mm/yyyy hh24:mi:ss'), 'DS'),1,80);

		if (ie_se_perm_pf_classif_w IS NOT NULL AND ie_se_perm_pf_classif_w::text <> '') then	
			begin
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(43226,'IE_CLASSIFICACAO='||ie_se_perm_pf_classif_w);
			end;
		end if;
		end;
	end if;
	
	CALL consistir_encaixe_agenda_exame(cd_agenda_p, nr_seq_agenda_sel_p, trunc(dt_agenda_p), ie_transferir_p, cd_estabelecimento_p, nm_usuario_p, to_date(dt_encaixe_cons_w,'dd/mm/yyyy hh24:mi:ss'), cd_convenio_p);

	nr_seq_encaixe_w := gerar_encaixe_agenda_exame_sel(	cd_estabelecimento_p, cd_agenda_usa_p, trunc(dt_agenda_p), dt_encaixe_p, qt_duracao_p, nr_seq_agenda_sel_p, ie_transferir_p, cd_motivo_p, ds_motivo_p, nm_usuario_p, nr_seq_encaixe_w);

	ie_consiste_med_executor_w := obter_Param_Usuario(820, 117, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_consiste_med_executor_w);

	if (nr_seq_encaixe_w IS NOT NULL AND nr_seq_encaixe_w::text <> '') and (ie_consiste_med_executor_w = 'S') then
		begin
		ds_carteiras_selec_w := Gera_usu_conv_OPS_Agepac(nr_seq_encaixe_w, cd_estabelecimento_p, ds_carteiras_selec_w);
		
		ie_atualiza_plano_w := obter_Param_Usuario(820, 116, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_atualiza_plano_w);
		
		if (coalesce(ds_carteiras_selec_w::text, '') = '') and (ie_atualiza_plano_w = 'S') then
			CALL Gera_plano_OPS_Agepac(nr_seq_encaixe_w);		
		end if;
		end;
	end if;
	end;
end if;

nr_seq_encaixe_p	:= nr_seq_encaixe_w;
ds_carteiras_selec_p	:= ds_carteiras_selec_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_encaixe_agexame_sel_js ( nr_seq_agenda_sel_p bigint, cd_agenda_p text, cd_agenda_usa_p text, dt_agenda_p timestamp, dt_encaixe_p text, ie_transferir_p text, qt_duracao_p bigint, cd_motivo_p text, ds_motivo_p text, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_seq_encaixe_p INOUT bigint, ds_carteiras_selec_p INOUT text, cd_convenio_p bigint) FROM PUBLIC;

