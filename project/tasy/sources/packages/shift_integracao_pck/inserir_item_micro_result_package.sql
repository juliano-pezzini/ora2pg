-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

 
	/* 
	* Inserir resultados de cultura 
	*/
 


CREATE OR REPLACE PROCEDURE shift_integracao_pck.inserir_item_micro_result ( nr_prescricao_p bigint, cd_exame_p text, cd_exame_analito_p text, cd_microorganismo_p text, cd_medicamento_p text, qt_microorganismo_p text, qt_mic_p text, ie_result_p text, ds_erro_p INOUT text) AS $body$
DECLARE

 
	nr_seq_exame_w		exame_laboratorio.nr_seq_exame%type;
	nr_sequencia_w		prescr_procedimento.nr_sequencia%type;
	nr_seq_resultado_w	exame_lab_resultado.nr_seq_resultado%type;

	
BEGIN 
 
		begin 
 
			select 	nr_seq_exame 
			into STRICT	nr_seq_exame_w 
			from	lab_exame_equip a, 
					equipamento_lab b 
			where	a.cd_exame_equip = cd_exame_p 
			and		a.cd_equipamento = b.cd_equipamento 
			and		b.ds_sigla = 'SHIFTWS' 
			and		a.nr_seq_exame in (SELECT nr_seq_exame from prescr_procedimento where nr_prescricao = nr_prescricao_p);
 
		exception 
			when no_data_found then 
			ds_erro_p := wheb_mensagem_pck.get_texto(318850);
			return;
 
			when others then 
			ds_erro_p := substr(wheb_mensagem_pck.get_texto(317525)||' - '||SQLERRM,1,255);
			return;
		end;
		 
		begin 
 
			select	nr_sequencia 
			into STRICT	nr_sequencia_w 
			from	prescr_procedimento 
			where	nr_prescricao = nr_prescricao_p 
			and		nr_seq_exame = nr_seq_exame_w;
 
		exception 
			when no_data_found then 
			ds_erro_p := wheb_mensagem_pck.get_texto(318852,'NR_SEQ_EXAME='||nr_seq_exame_w||';NR_PRESCRICAO='||nr_prescricao_p);
			return;
 
			when too_many_rows then 
			ds_erro_p := wheb_mensagem_pck.get_texto(318854,'NR_SEQ_EXAME='||nr_seq_exame_w||';NR_PRESCRICAO='||nr_prescricao_p);
			return;
 
			when others then 
			ds_erro_p := substr(wheb_mensagem_pck.get_texto(317525)||' - '||SQLERRM,1,255);
			return;
		end;
 
		begin 
 
			select	nr_seq_resultado 
			into STRICT	nr_seq_resultado_w 
			from	exame_lab_resultado 
			where	nr_prescricao = nr_prescricao_p;
 
		exception 
			when no_data_found then 
			ds_erro_p := wheb_mensagem_pck.get_texto(318856,'NR_PRESCRICAO='||nr_prescricao_p);
			return;
 
			when others then 
			ds_erro_p := substr(wheb_mensagem_pck.get_texto(317525)||' - '||SQLERRM,1,255);
			return;
		end;
 
		lab_inserir_item_micro_result(	nr_prescricao_p, 
										nr_sequencia_w, 
										cd_exame_analito_p, 
										cd_microorganismo_p, 
										cd_medicamento_p, 
										qt_microorganismo_p, 
										qt_mic_p, 
										ie_result_p, 
										'TASYLAB', 
										ds_erro_p);
 
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE shift_integracao_pck.inserir_item_micro_result ( nr_prescricao_p bigint, cd_exame_p text, cd_exame_analito_p text, cd_microorganismo_p text, cd_medicamento_p text, qt_microorganismo_p text, qt_mic_p text, ie_result_p text, ds_erro_p INOUT text) FROM PUBLIC;
