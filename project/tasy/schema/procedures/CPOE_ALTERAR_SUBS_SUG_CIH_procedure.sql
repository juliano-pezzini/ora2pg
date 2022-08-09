-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_alterar_subs_sug_cih ( NR_SEQ_CPOE_P bigint, nm_usuario_p text) AS $body$
DECLARE



qt_dias_liberados_w				bigint;
ds_stack_w						log_cpoe.ds_stack%type;
ds_log_cpoe_w					log_cpoe.ds_log%type;


c01 CURSOR FOR
	SELECT	nr_prescricao,
			nr_sequencia
	from 	prescr_material
	where	NR_SEQ_MAT_CPOE = NR_SEQ_CPOE_P;
	

BEGIN

	select 	max(qt_dias_liberado)
	into STRICT 	qt_dias_liberados_w
	from 	prescr_material
	where	NR_SEQ_MAT_CPOE = NR_SEQ_CPOE_P
	and		ie_agrupador	= 1;
	

	for c01_w in c01
	loop
		update	prescr_material
		set		qt_dias_liberado	= 	qt_dias_liberados_w,
				dt_atualizacao		= 	clock_timestamp(),
				nm_usuario			= 	nm_usuario_p
		where	nr_prescricao		=	c01_w.nr_prescricao
		and		nr_sequencia		=	c01_w.nr_sequencia;
		
		delete	from	medicamento_cih_sug
		where	nr_prescricao	=	c01_w.nr_prescricao
		and		NR_SEQ_MATERIAL	=	c01_w.nr_sequencia
		and		IE_CONCORDO		<>	'S';
	end loop;
	


	exception
	   when others then

		ds_stack_w	:= substr(dbms_utility.format_call_stack,1,2000);
		ds_log_cpoe_w := substr('ERROR: CPOE_ALTERAR_SUBS_SUG_CIH'
			||  CHR(10) || '| NR_SEQ_CPOE_P: ' || NR_SEQ_CPOE_P
			||  CHR(10) || '| nm_usuario_p: ' || NM_USUARIO_P
			||  CHR(10) || ' - ERRO: ' || sqlerrm 
			|| chr(13) || ' - FUNCAO('||to_char(obter_funcao_ativa)||'); PERFIL('||to_char(obter_perfil_ativo)||')',1,2000);
			
		insert into log_cpoe(
			nr_sequencia,
			dt_atualizacao, 
			nm_usuario, 
			ds_log, 
			ds_stack) 
		values (
			nextval('log_cpoe_seq'),
			clock_timestamp(), 
			nm_usuario_p, 
			ds_log_cpoe_w, 
			ds_stack_w);
			
		commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_alterar_subs_sug_cih ( NR_SEQ_CPOE_P bigint, nm_usuario_p text) FROM PUBLIC;
