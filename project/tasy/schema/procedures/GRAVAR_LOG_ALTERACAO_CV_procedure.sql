-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_log_alteracao_cv ( nr_atendimento_p bigint, nm_usuario_p text, qt_visita_atual_p bigint, qt_visita_anterior_p bigint, cd_motivo_alteracao_p bigint, ds_observacao_p text) AS $body$
DECLARE

 
			 
cd_setor_atendimento_w			bigint;
cd_unidade_compl_w			varchar(10);
cd_unidade_basica_w			varchar(10);		
qt_existe_w				bigint;			
			 

BEGIN 
 
select	cd_unidade_basica, 
	cd_unidade_compl, 
	cd_setor_atendimento 
into STRICT	cd_unidade_basica_w, 
	cd_unidade_compl_w, 
	cd_setor_atendimento_w 
 from  atend_paciente_unidade 
 where (nr_seq_interno = obter_atepacu_paciente(nr_atendimento_p, 'A'));
 
 
 insert into atend_ajuste_visita(		nr_sequencia,          
					nm_usuario,           
					dt_atualizacao,         
					nr_atendimento, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					cd_setor_atendimento,      
					cd_unidade_basica,        
					cd_unidade_compl,        
					qt_visita_atual,         
					qt_visita_anterior, 
					nr_seq_motivo_alter_visita, 
					ds_observacao)						 
				values (nextval('atend_ajuste_visita_seq'), 
					nm_usuario_p, 
					clock_timestamp(), 
					nr_atendimento_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					cd_setor_atendimento_w, 
					cd_unidade_basica_w, 
					cd_unidade_compl_w, 
					qt_visita_atual_p, 
					qt_visita_anterior_p, 
					cd_motivo_alteracao_p, 
					ds_observacao_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_log_alteracao_cv ( nr_atendimento_p bigint, nm_usuario_p text, qt_visita_atual_p bigint, qt_visita_anterior_p bigint, cd_motivo_alteracao_p bigint, ds_observacao_p text) FROM PUBLIC;

