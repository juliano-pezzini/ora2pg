-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_status_exec_exame (nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_status_exec_p text, nm_usuario_p text) AS $body$
DECLARE


nr_atendimento_w  bigint;


BEGIN

if (coalesce(nr_prescricao_p,0) > 0) then

	if (ie_status_exec_p = '13') then
		update   	prescr_procedimento
		set      	ie_status_execucao   	=  ie_status_exec_p,
			dt_atualizacao      		=  clock_timestamp(),
			nm_usuario		=  nm_usuario_p,
			dt_status_previsto		=  clock_timestamp()
		where    	nr_prescricao        		=  nr_prescricao_p
		and      	nr_sequencia         		=  nr_seq_prescr_p
		and	ie_status_execucao 	=  '10';

	elsif (ie_status_exec_p = '15') then
		update   prescr_procedimento
		set      	ie_status_execucao   	=  ie_status_exec_p,
			dt_atualizacao      		=  clock_timestamp(),
			nm_usuario		=  nm_usuario_p
		where    	nr_prescricao        		=  nr_prescricao_p
		and      	nr_sequencia         		=  nr_seq_prescr_p
		and	ie_status_execucao	   	in ('10','13');

	elsif (ie_status_exec_p = '10') then
		update   	prescr_procedimento
		set      	ie_status_execucao   	=  ie_status_exec_p,
			dt_atualizacao      		=  clock_timestamp(),
			nm_usuario		=  nm_usuario_p
		where    	nr_prescricao        		=  nr_prescricao_p
		and      	nr_sequencia         		=  nr_seq_prescr_p
		and	coalesce(ie_status_atend,0) 	< 10;

	elsif (ie_status_exec_p = '18') then
		update   	prescr_procedimento
		set      	ie_status_execucao   	=  ie_status_exec_p,
			dt_atualizacao      		=  clock_timestamp(),
			nm_usuario		=  nm_usuario_p
		where    	nr_prescricao        		=  nr_prescricao_p
		and      	nr_sequencia         		=  nr_seq_prescr_p
		and	ie_status_execucao 	= '15';

	elsif (ie_status_exec_p = '17') then

		update   	prescr_procedimento
		set      	ie_status_execucao   	=  ie_status_exec_p,
			dt_atualizacao      		=  clock_timestamp(),
			nm_usuario		=   nm_usuario_p
		where    	nr_prescricao        		=  nr_prescricao_p
		and      	nr_sequencia         		=  nr_seq_prescr_p
		and	ie_status_execucao		= '15';

	elsif (ie_status_exec_p = '11') then

		update   	prescr_procedimento
		set      	ie_status_execucao		=  ie_status_exec_p,
			dt_atualizacao     		=  clock_timestamp(),
			nm_usuario	   	=  nm_usuario_p
		where    	nr_prescricao      		=  nr_prescricao_p
		and      	nr_sequencia       		=  nr_seq_prescr_p
		and	ie_status_execucao 	= '10';


	end if;
commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_status_exec_exame (nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_status_exec_p text, nm_usuario_p text) FROM PUBLIC;
