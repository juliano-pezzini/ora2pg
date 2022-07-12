-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW lab_interf_itaipu_v (nr_sequencia, cd_usuario, nm_pessoa_fisica, cd_amb, dt_prescricao, vl_resultado, ds_resultado, ds_referencia, ds_observacao1, ds_observacao2, nr_prescricao, nr_seq_lote_externo, nr_seq_prescr) AS select	obter_equipamento_exame(f.nr_seq_exame,null,'ITAIPU') nr_sequencia,
--	nvl(c.cd_exame_integracao, '1') nr_sequencia, 
	SUBSTR(g.cd_usuario_convenio,4,7) cd_usuario, 
	substr(g.nm_paciente,1,45) nm_pessoa_fisica, 
	substr(d.cd_procedimento,1,2) || '.' || substr(d.cd_procedimento,3,2) || '.' || 
	substr(d.cd_procedimento,5,3) || '-' || substr(d.cd_procedimento,8,1) cd_amb, 
	a.dt_prescricao, 
	CASE WHEN coalesce(f.pr_resultado,0)=0 THEN  f.qt_resultado  ELSE f.pr_resultado END  vl_resultado, 
	substr(CASE WHEN upper(f.ds_resultado)='VIDE OBS' THEN ' '  ELSE CASE WHEN coalesce(f.ds_resultado,'0')='0' THEN  ' '  ELSE f.ds_resultado END  END ,1,40) ds_resultado, 
	substr(replace(replace(replace(f.ds_referencia,chr(13)||chr(10),' '),chr(13),' '),chr(10),' '),1,250) ds_referencia, 
	substr(replace(CASE WHEN lab_obter_result_item(f.nr_seq_resultado, f.nr_seq_prescr, f.nr_sequencia,5,'')='31' THEN  		'Obs.: Valores de referencia para Bastonetes: Até 11%(Miale, J.B.Lab.Med.Hematology - 6ªedição.@' || 		lab_obter_result_item(f.nr_seq_resultado, f.nr_seq_prescr, f.nr_sequencia,6,'@')  ELSE '' END  || 
		CASE WHEN coalesce(f.ds_observacao,'')='' THEN ''  ELSE f.ds_observacao || '@' END , chr(13)||chr(10),' ') || 
		'MATERIAL: ' || trim(both lab_obter_result_item(f.nr_seq_resultado, f.nr_seq_prescr, f.nr_sequencia,0,'')) || 
		'@METODO: ' || trim(both lab_obter_result_item(f.nr_seq_resultado, f.nr_seq_prescr, f.nr_sequencia,1,'')) || 
		'@Conferido com original ' || lab_obter_result_item(f.nr_seq_resultado, f.nr_seq_prescr, f.nr_sequencia,3,''),1,150) ds_observacao1, 
	substr(replace(CASE WHEN lab_obter_result_item(f.nr_seq_resultado, f.nr_seq_prescr, f.nr_sequencia,5,'')='31' THEN  		'Obs.: Valores de referencia para Bastonetes: Até 11%(Miale, J.B.Lab.Med.Hematology - 6ªedição.@' || 		lab_obter_result_item(f.nr_seq_resultado, f.nr_seq_prescr, f.nr_sequencia,6,'@')  ELSE '' END  || 
		CASE WHEN coalesce(f.ds_observacao,'')='' THEN ''  ELSE f.ds_observacao || '@' END , chr(13)||chr(10),' ') || 
		'MATERIAL: ' || trim(both lab_obter_result_item(f.nr_seq_resultado, f.nr_seq_prescr, f.nr_sequencia,0,'')) || 
		'@METODO: ' || trim(both lab_obter_result_item(f.nr_seq_resultado, f.nr_seq_prescr, f.nr_sequencia,1,'')) || 
		'@Conferido com original ' || lab_obter_result_item(f.nr_seq_resultado, f.nr_seq_prescr, f.nr_sequencia,3,''),151,300) ds_observacao2, 
	a.nr_prescricao, 
	d.nr_seq_lote_externo, 
	d.nr_sequencia nr_seq_prescr 
FROM	exame_laboratorio c, 
	atendimento_paciente_v g, 
	exame_lab_result_item f, 
	exame_lab_resultado e, 
	prescr_medica a, 
	prescr_procedimento d 
where	d.nr_prescricao		= a.nr_prescricao 
and	a.nr_atendimento	= g.nr_atendimento 
and	f.nr_seq_resultado	= e.nr_seq_resultado 
and	a.nr_prescricao		= e.nr_prescricao 
and	d.nr_sequencia		= f.nr_seq_prescr 
and	f.nr_seq_exame		= c.nr_seq_exame 
and	((obter_equipamento_exame(f.nr_seq_exame,null,'ITAIPU') is not null) or (	select count(*) 
		from exame_lab_result_item x 
		where x.nr_seq_resultado = f.nr_seq_resultado 
		 and x.nr_seq_prescr	 = f.nr_seq_prescr) = 1) 
order by	f.nr_seq_resultado, 
		f.nr_seq_prescr, 
		(obter_equipamento_exame(f.nr_seq_exame,null,'ITAIPU'))::numeric;
