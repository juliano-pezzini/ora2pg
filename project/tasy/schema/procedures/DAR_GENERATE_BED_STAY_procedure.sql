-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dar_generate_bed_stay () AS $body$
DECLARE


			
c01 CURSOR FOR
	SELECT 	   b.nr_seq_interno bedid,
		   b.cd_unidade_basica || '-' || b.cd_unidade_compl bedlabel,
		   a.cd_setor_usuario_atend clinicalunitid,
		   obter_ds_setor_atendimento(a.cd_setor_usuario_atend) clinicalunitlabel,
		   obter_valor_dominio(12, a.ie_tipo_atendimento) clinicalunittype,
		   a.nr_atendimento encounterid,
		   obter_dados_estab(a.cd_estabelecimento, 1) institutiondisplaylabel,
		   b.dt_entrada_unidade  intime,
		   b.dt_saida_unidade  outtime,
		   a.cd_pessoa_fisica patientaccountnumber,
		   a.cd_estabelecimento systemid,
		   b.dt_atualizacao dt_atualizacao,
		   b.nr_sequencia
	FROM	   atendimento_paciente a,
		   atend_paciente_unidade b,
		   unidade_atendimento c 
	WHERE  	   1 = 1 
	and 	   b.nr_atendimento = a.nr_atendimento 
	and 	   b.cd_setor_atendimento = c.cd_setor_atendimento 
	and 	   b.cd_unidade_basica = c.cd_unidade_basica 
	and	   not exists (SELECT 1
				 from DAR_BED_STAY x
				 where x.nr_seq_atend_unidade = b.nr_sequencia)
	and 	   b.cd_unidade_compl = c.cd_unidade_compl;

c01_w		c01%rowtype;


BEGIN

open c01;
loop
fetch c01 into	
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	insert into dar_bed_stay(nr_sequencia,
				 dt_atualizacao, 
				 nm_usuario,
				 nr_seq_interno, 
				 ds_unidade, 
				 cd_setor_usuario_atend, 
				 ds_setor_atendimento, 
				 ds_tipo_clinica, 
				 nr_atendimento, 
				 ds_estabelecimento, 
				 dt_entrada_unidade, 
				 dt_saida_unidade, 
				 cd_pessoa_fisica, 
				 dt_atualizacao_atend, 
				 nr_seq_atend_unidade, 
				 cd_estab_atend_paciente)
		values (nextval('dar_bed_stay_seq'),
				 clock_timestamp(),
				 'Tasy',
				 c01_w.bedid,
				 c01_w.bedlabel,
				 c01_w.clinicalunitid,
				 c01_w.clinicalunitlabel,
				 c01_w.clinicalunittype,
				 c01_w.encounterid,
				 c01_w.institutiondisplaylabel,
				 c01_w.intime,
				 c01_w.outtime,
				 c01_w.patientaccountnumber,
				 c01_w.dt_atualizacao,
				 c01_w.nr_sequencia,
				 c01_w.systemid);
	end;
end loop;
close c01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dar_generate_bed_stay () FROM PUBLIC;
