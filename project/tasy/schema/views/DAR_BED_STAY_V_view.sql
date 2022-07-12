-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW dar_bed_stay_v (bedid, bedlabel, clinicalunitid, clinicalunitlabel, clinicalunittype, encounterid, institutiondisplaylabel, intime, outtime, intimecalendarday, intimeyear, intimemonth, intimedayofmonth, outtimecalendarday, outtimeyear, outtimemonth, outtimedayofmonth, patientaccountnumber, patientage, patientdateofbirth, patientencounternumber, patientfullname, patientgender, dt_atualizacao_atend, unitnumber, systemid) AS select	 nr_seq_interno bedid,
	 ds_unidade bedlabel,
	 cd_setor_usuario_atend clinicalunitid,
	 ds_setor_atendimento clinicalunitlabel,
	 ds_tipo_clinica clinicalunittype,
	 nr_atendimento encounterid,
	 ds_estabelecimento institutiondisplaylabel,
	 to_char(dt_entrada_unidade, 'dd/mm/yyyy hh24:mi:ss') intime,
	 to_char(dt_saida_unidade, 'dd/mm/yyyy hh24:mi:ss') outtime,
         to_char(dt_entrada_unidade, 'dd/mm/yyyy') intimecalendarday,
   	 to_char(dt_entrada_unidade, 'yyyy') intimeyear,
   	 (to_char(dt_entrada_unidade, 'MM'))::numeric  intimemonth,
   	 (to_char(dt_entrada_unidade, 'dd'))::numeric  intimedayofmonth,
   	 to_char(dt_saida_unidade, 'dd/mm/yyyy') outtimecalendarday,
   	 to_char(dt_saida_unidade, 'yyyy') outtimeyear,
   	 (to_char(dt_saida_unidade, 'MM'))::numeric  outtimemonth,
   	 (to_char(dt_saida_unidade, 'dd'))::numeric  outtimedayofmonth,
	 cd_pessoa_fisica patientaccountnumber,
	 obter_dados_pf(cd_pessoa_fisica, 'I') patientage,
         obter_dados_pf(cd_pessoa_fisica, 'DN') patientdateofbirth,
         nr_atendimento patientencounternumber,
         obter_dados_pf(cd_pessoa_fisica, 'NSOC') patientfullname,
	 obter_dados_pf(cd_pessoa_fisica, 'SE') patientgender,
	 dt_atualizacao_atend,
	 nr_seq_atend_unidade unitNumber,
	 cd_estab_atend_paciente systemid
FROM 	 dar_bed_stay;
