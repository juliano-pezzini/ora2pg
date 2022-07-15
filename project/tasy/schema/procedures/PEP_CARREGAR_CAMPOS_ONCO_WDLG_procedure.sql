-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_carregar_campos_onco_wdlg ( nr_seq_paciente_p bigint, cd_convenio_pac_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_prim_dia_p INOUT bigint, nr_ciclo_inicial_p INOUT bigint, nr_seq_protocolo_p INOUT bigint, qt_horas_conv_p INOUT bigint, ie_apres_dt_prev_p INOUT text, dt_hora_ciclo_p INOUT timestamp) AS $body$
DECLARE


cd_convenio_w		convenio.cd_convenio%type := 0;
cd_conv_retorno_w	convenio.cd_convenio%type := 0;
dt_hora_ciclo_aux_w	timestamp;
											

BEGIN
nr_seq_protocolo_p	:= 1;
nr_prim_dia_p		:= 1;
nr_ciclo_inicial_p	:= 1;
qt_horas_conv_p		:= 0;
ie_apres_dt_prev_p	:= 'N';
dt_hora_ciclo_p		:= null;

if (nr_seq_paciente_p IS NOT NULL AND nr_seq_paciente_p::text <> '') then
	nr_prim_dia_p	:= coalesce(obter_prim_dia_trat_onc(nr_seq_paciente_p),1);

	select	coalesce(max(nr_ciclo), 0) + 1,
			coalesce(max(nr_seq_protocolo),1)
	into STRICT	nr_ciclo_inicial_p,
			nr_seq_protocolo_p
	from	paciente_atendimento
	where	nr_seq_paciente = nr_seq_paciente_p
	and		coalesce(dt_suspensao::text, '') = ''
	and		coalesce(dt_cancelamento::text, '') = '';
	
	select	coalesce(max('S'),'N')
	into STRICT	ie_apres_dt_prev_p
	from	paciente_atendimento where		nr_seq_paciente = nr_seq_paciente_p LIMIT 1;
	
	SELECT * FROM obter_horas_conv_onc(cd_convenio_pac_p, nr_seq_paciente_p, cd_estabelecimento_p, qt_horas_conv_p, cd_conv_retorno_w) INTO STRICT qt_horas_conv_p, cd_conv_retorno_w;
			
	if (coalesce(qt_horas_conv_p,0) = 0) then
		qt_horas_conv_p	:= coalesce(obter_param_medico(cd_estabelecimento_p, 'QT_HORAS_INICIO_CICLO'),0);
	end if;

	if (coalesce(qt_horas_conv_p,0) > 0) then
	
	
		if (coalesce(cd_convenio_pac_p,0) > 0) then
			cd_convenio_w	:= cd_convenio_pac_p;
		else
			cd_convenio_w	:= cd_conv_retorno_w;
		end if;
		
		dt_hora_ciclo_p			:= coalesce(obter_dia_util_trat_onc(cd_convenio_w,cd_estabelecimento_p,nr_seq_paciente_p),clock_timestamp());			
		
	end if;

	dt_hora_ciclo_aux_w	:= coalesce(obter_prox_dia_util_trat_onc(nr_seq_paciente_p),clock_timestamp());		
	
	if (dt_hora_ciclo_aux_w > coalesce(dt_hora_ciclo_p,clock_timestamp())) then
		 dt_hora_ciclo_p	:= dt_hora_ciclo_aux_w;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_carregar_campos_onco_wdlg ( nr_seq_paciente_p bigint, cd_convenio_pac_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_prim_dia_p INOUT bigint, nr_ciclo_inicial_p INOUT bigint, nr_seq_protocolo_p INOUT bigint, qt_horas_conv_p INOUT bigint, ie_apres_dt_prev_p INOUT text, dt_hora_ciclo_p INOUT timestamp) FROM PUBLIC;

