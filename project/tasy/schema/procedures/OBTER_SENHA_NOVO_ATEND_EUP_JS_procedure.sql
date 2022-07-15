-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_senha_novo_atend_eup_js ( ie_atualiza_sintoma_triag_pa_p text, ie_atual_mot_atend_triag_pa_p text, ie_atualiza_clinica_triag_pa_p text, qt_horas_val_triagem_p bigint, cd_pessoa_fisica_p text, nr_atendimento_p bigint, ie_utiliza_senha_dt_gs_p text, nm_usuario_p text, ds_maquina_p text, nr_pac_senha_fila_p INOUT bigint, dt_recebimento_p INOUT timestamp, ds_senha_p INOUT text, ie_clinica_p INOUT bigint, nr_seq_queixa_p INOUT bigint, ds_sintoma_paciente_p INOUT text) AS $body$
DECLARE


nr_seq_senha_pac_w	bigint;
nr_pac_senha_fila_w	bigint;
dt_senha_w		timestamp;
ds_senha_w		varchar(20);
ie_clinica_w		integer;
nr_seq_queixa_w		bigint;
ds_sintoma_paciente_w	varchar(255);
nr_seq_senha_fila_w		bigint;



BEGIN

nr_seq_senha_pac_w := obter_senha_pac_maquina(nm_usuario_p,upper(ds_maquina_p));

if (coalesce(nr_seq_senha_pac_w,0) > 0) then
	nr_pac_senha_fila_p := nr_seq_senha_pac_w;

	if (ie_utiliza_senha_dt_gs_p = 'S') and (coalesce(nr_atendimento_p,0) > 0) then

		SELECT * FROM obter_dados_senha_fila_v2(nr_seq_senha_pac_w, cd_pessoa_fisica_p, qt_horas_val_triagem_p, dt_senha_w, ds_senha_w, nr_seq_senha_fila_w) INTO STRICT dt_senha_w, ds_senha_w, nr_seq_senha_fila_w;
		if (dt_senha_w IS NOT NULL AND dt_senha_w::text <> '') then
			dt_recebimento_p := dt_senha_w;
		end if;
		if (ds_senha_w IS NOT NULL AND ds_senha_w::text <> '') then
			ds_senha_p := ds_senha_w;
		end if;
	end if;
	SELECT * FROM obter_dados_triagem_senha(nr_seq_senha_pac_w, ie_clinica_w, nr_seq_queixa_w, ds_sintoma_paciente_w) INTO STRICT ie_clinica_w, nr_seq_queixa_w, ds_sintoma_paciente_w;

	if (coalesce(ie_clinica_w,0) > 0) and (ie_atualiza_clinica_triag_pa_p = 'S') then
		ie_clinica_p := ie_clinica_w;
	end if;

	if (ie_atual_mot_atend_triag_pa_p = 'S') and (coalesce(nr_seq_queixa_w,0) > 0) then
		nr_seq_queixa_p := nr_seq_queixa_w;
	end if;

	if (ie_atualiza_sintoma_triag_pa_p = 'S')  and (ds_sintoma_paciente_w IS NOT NULL AND ds_sintoma_paciente_w::text <> '') then
		ds_sintoma_paciente_p := ds_sintoma_paciente_w;
	end if;
end if;




commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_senha_novo_atend_eup_js ( ie_atualiza_sintoma_triag_pa_p text, ie_atual_mot_atend_triag_pa_p text, ie_atualiza_clinica_triag_pa_p text, qt_horas_val_triagem_p bigint, cd_pessoa_fisica_p text, nr_atendimento_p bigint, ie_utiliza_senha_dt_gs_p text, nm_usuario_p text, ds_maquina_p text, nr_pac_senha_fila_p INOUT bigint, dt_recebimento_p INOUT timestamp, ds_senha_p INOUT text, ie_clinica_p INOUT bigint, nr_seq_queixa_p INOUT bigint, ds_sintoma_paciente_p INOUT text) FROM PUBLIC;

