-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_hmv_ps (dt_estatistica_p timestamp) AS $body$
DECLARE

 
dt_ultimo_dia_w	timestamp;
dt_estatistica_w	timestamp;
qt_clinica4_w		integer;
qt_psa_w		integer;
qt_psi_w		integer;
qt_pso_w		integer;
qt_psgo_w		integer;
qt_total_ps_w		integer;
qt_cc_w			integer;
qt_cti_w		integer;
qt_uco_w		integer;
qt_utin_w		integer;
qt_utip_w		integer;
qt_meio_dia_w		integer;/* 6 horas */
qt_admit_w		integer;
qt_alta_w		integer;
qt_dia_w		integer;
qt_media_diaria_w	integer;
qt_media_cirurgia_w	integer;
qt_media_ps_w		integer;


BEGIN 
 
dt_ultimo_dia_w		:= trunc(LAST_DAY(dt_estatistica_p),'dd');
dt_estatistica_w	:= trunc(dt_estatistica_p,'month');
 
While(dt_estatistica_w <= dt_ultimo_dia_w) and (trunc(dt_estatistica_w,'dd') <= trunc(clock_timestamp(),'dd')) loop 
 
	dt_estatistica_w := trunc(dt_estatistica_w,'dd');
	 
	delete	FROM w_hmv_ps 
	where	dt_estatistica = dt_estatistica_w;
 
	select	sum(qt_clinica4), 
		sum(qt_psa), 
		sum(qt_psi), 
		sum(qt_pso), 
		sum(qt_psgo), 
		sum(qt_total_ps), 
		sum(qt_cc), 
		sum(qt_cti), 
		sum(qt_uco), 
		sum(qt_utin), 
		sum(qt_utip), 
		sum(qt_meio_dia), 
		sum(qt_admit), 
		sum(qt_alta), 
		sum(qt_dia) 
		 
	into STRICT 
		qt_clinica4_w, 
		qt_psa_w, 
		qt_psi_w, 
		qt_pso_w, 
		qt_psgo_w, 
		qt_total_ps_w, 
		qt_cc_w, 
		qt_cti_w, 
		qt_uco_w, 
		qt_utin_w, 
		qt_utip_w, 
		qt_meio_dia_w, 
		qt_admit_w, 
		qt_alta_w, 
		qt_dia_w		 
	from ( 
 
	/* Item - 1 	Clinica 4, PSA, PSI, PSO, PSGO e Total P.S. */
 
 
	SELECT	sum(CASE WHEN cd_setor_atendimento=70 THEN 1  ELSE 0 END ) qt_clinica4, 
		sum(CASE WHEN cd_setor_atendimento=49 THEN 1  ELSE 0 END ) qt_psa, 
		sum(CASE WHEN cd_setor_atendimento=64 THEN 1  ELSE 0 END ) qt_psi, 
		sum(CASE WHEN cd_setor_atendimento=66 THEN 1  ELSE 0 END ) qt_pso, 
		sum(CASE WHEN cd_setor_atendimento=167 THEN 1  ELSE 0 END ) qt_psgo, 
		sum(CASE WHEN cd_setor_atendimento=70 THEN 1  ELSE 0 END ) + sum(CASE WHEN cd_setor_atendimento=49 THEN 1  ELSE 0 END ) + sum(CASE WHEN cd_setor_atendimento=64 THEN 1  ELSE 0 END ) + 
			sum(CASE WHEN cd_setor_atendimento=66 THEN 1  ELSE 0 END ) + sum(CASE WHEN cd_setor_atendimento=167 THEN 1  ELSE 0 END ) qt_total_ps, 
		0 qt_cc, 
		0 qt_cti, 
		0 qt_uco, 
		0 qt_utin, 
		0 qt_utip, 
		0 qt_meio_dia, 
		0 qt_admit, 
		0 qt_alta, 
		0 qt_dia		 
	from	admissao_hospitalar_ps_v 
	where	dt_entrada between dt_estatistica_w AND dt_estatistica_w + 86399/86400 
 
	
union
 
 
	/* Item - 2 	Centro Cirurgico */
 
 
	SELECT	0,0,0,0,0,0, 
		count(*), 
		0,0,0,0,0,0,0,0		 
	from	agenda_paciente 
	where	dt_agenda between dt_estatistica_w and dt_estatistica_w + 86399/86400 
	and	ie_status_agenda = 'E' 
 
	/* Item - 3 	CTI, UCO, UTIN, UTIP e Total da 0h às 23:59 */
 
 
	
union
 
	select	0,0,0,0,0,0,0, 
		sum(CASE WHEN cd_setor_atendimento=67 THEN 1  ELSE 0 END ),	 
		sum(CASE WHEN cd_setor_atendimento=201 THEN 1  ELSE 0 END ), 
		sum(CASE WHEN cd_setor_atendimento=86 THEN 1  ELSE 0 END ), 
		sum(CASE WHEN cd_setor_atendimento=68 THEN 1  ELSE 0 END ),	 
		0,0,0, 
		count(*)		 
	from	paciente_internado_v2 
	where	dt_saida_interno	> dt_estatistica_w 
	and	dt_entrada_unidade	<= dt_estatistica_w 
	and	nr_seq_atepacu	= obter_atepacu_data(nr_atendimento,'IA',dt_estatistica_w) 
	
union
 
 
	/* Item - 4 	6 horas */
 
 
	select	0,0,0,0,0,0, 
		0,0,0,0,0, 
		count(*), 
		0,0,0 
	from	paciente_internado_v2 
	WHERE (DT_SAIDA_INTERNO	>	dt_estatistica_w + 21601/86400) 
	AND (DT_ENTRADA_UNIDADE	<=	dt_estatistica_w + 21601/86400) 
	AND	nr_seq_atepacu	= 	obter_atepacu_data(nr_atendimento,'IA',dt_estatistica_w + 21601/86400) 
	
union
 
 
	/* Item - 5	ADMIT */
 
 
	select	0,0,0,0,0,0, 
		0,0,0,0,0, 
		0, 
		count(*), 
		0,0 
	from	admissao_hospitalar_v 
	where	dt_entrada 		between dt_estatistica_w AND dt_estatistica_w + 86399/86400 
	and	dt_entrada_unidade	between dt_estatistica_w AND dt_estatistica_w + 86399/86400 
	
union
 
 
	/* Item - 6	ALTA */
 
 
	select	0,0,0,0,0,0, 
		0,0,0,0,0, 
		0, 
		0, 
		count(*), 
		0 
	from	alta_hospitalar_v 
	where	dt_alta_interno		between dt_estatistica_w AND dt_estatistica_w + 86399/86400) alias38;
 
	insert	into W_HMV_PS( 
		dt_estatistica, 
		qt_clinica4, 
		qt_psa, 
		qt_psi, 
		qt_pso, 
		qt_psgo, 
		qt_total_ps, 
		qt_cc, 
		qt_cti, 
		qt_uco, 
		qt_utin, 
		qt_utip, 
		qt_meio_dia, 
		qt_admit, 
		qt_alta, 
		qt_dia, 
		qt_media_diaria, 
		qt_media_cirurgia, 
		qt_media_ps) 
	values (	 
		dt_estatistica_w, 
		qt_clinica4_w, 
		qt_psa_w, 
		qt_psi_w, 
		qt_pso_w, 
		qt_psgo_w, 
		qt_total_ps_w, 
		qt_cc_w, 
		qt_cti_w, 
		qt_uco_w, 
		qt_utin_w, 
		qt_utip_w, 
		qt_meio_dia_w, 
		qt_admit_w, 
		qt_alta_w, 
		qt_dia_w, 
		qt_media_diaria_w, 
		qt_media_cirurgia_w, 
		qt_media_ps_w);
	dt_estatistica_w	:= dt_estatistica_w + 1;
end	loop;
 
 
commit;
 
 
END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_hmv_ps (dt_estatistica_p timestamp) FROM PUBLIC;
