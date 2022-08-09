-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gen_anatomy_selec ( cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, nr_seq_proc_interno_p cpoe_anatomia_patologica.nr_seq_proc_interno%type, nr_seq_item_gerado_p INOUT bigint, cd_medico_p bigint default null, cd_paciente_p text DEFAULT NULL, nr_seq_cpoe_order_unit_p cpoe_anatomia_patologica.nr_seq_cpoe_order_unit%type DEFAULT NULL) AS $body$
BEGIN



		select	nextval('cpoe_anatomia_patologica_seq')
		into STRICT	nr_seq_item_gerado_p
		;

		insert into cpoe_anatomia_patologica(
		 NR_SEQUENCIA,
		 DT_ATUALIZACAO,                           
		 NM_USUARIO,                               
		 DT_ATUALIZACAO_NREC,                                                 
		 NM_USUARIO_NREC,                                
		                                 
		 NR_ATENDIMENTO,                                 
		 CD_PERFIL_ATIVO,                                                        
		 CD_PESSOA_FISICA,                                                  
		 CD_FUNCAO_ORIGEM,                                                       
		 CD_MEDICO, 
         
		 IE_PRESCRITOR_AUX    ,
         nr_seq_proc_interno,
         NR_SEQ_CPOE_ORDER_UNIT,
		IE_DURACAO,
		DT_INICIO,
		DT_PREV_EXECUCAO
		 )
		values (
		nr_seq_item_gerado_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		
		nr_atendimento_p,
		cd_perfil_p,
		cd_paciente_p,
		2314,
		cd_medico_p,
        
		null,
        nr_seq_proc_interno_p,
        nr_seq_cpoe_order_unit_p,
        'P',
        clock_timestamp() + interval '1 days'/24,
		clock_timestamp());
		
		
commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gen_anatomy_selec ( cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, nr_seq_proc_interno_p cpoe_anatomia_patologica.nr_seq_proc_interno%type, nr_seq_item_gerado_p INOUT bigint, cd_medico_p bigint default null, cd_paciente_p text DEFAULT NULL, nr_seq_cpoe_order_unit_p cpoe_anatomia_patologica.nr_seq_cpoe_order_unit%type DEFAULT NULL) FROM PUBLIC;
