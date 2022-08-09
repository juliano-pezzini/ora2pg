-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE estornar_dev_atend_prescr ( nr_prescricao_p bigint, nr_sequencia_p bigint, cd_local_estoque_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
nr_atendimento_w				bigint;
dt_entrada_unidade_w				timestamp;
cd_material_w					bigint;
dt_atendimento_w				timestamp;
qt_material_w					double precision;
cd_setor_atendimento_w			bigint;
cd_unidade_medida_w				varchar(30);
nr_seq_proc_princ_w				bigint;
nr_sequencia_w				bigint;
cd_cgc_fornecedor_w				varchar(20);
ds_observacao_w				varchar(2000);
nr_seq_lote_fornec_w				bigint;
nr_receita_w					bigint;
nr_serie_material_w				varchar(80);

/*Matheus OS 49104 01/02/07 inclui o nr_receita no select */
 
c01 CURSOR FOR 
	SELECT	a.nr_atendimento, 
		a.dt_entrada_unidade, 
		coalesce(a.cd_material_exec, a.cd_material), 
		a.dt_atendimento, 
		a.qt_material, 
		a.cd_setor_atendimento, 
		a.cd_unidade_medida, 
		a.nr_seq_proc_princ, 
		a.nr_sequencia, 
		a.cd_cgc_fornecedor, 
		a.ds_observacao, 
		a.nr_seq_lote_fornec, 
		a.nr_receita, 
		a.nr_serie_material 
	from	material_atend_paciente a 
	where	nr_prescricao 		= nr_prescricao_p 
	and	nr_sequencia_prescricao = nr_sequencia_p 
	and	qt_material		< 0;
	/* Retirado pois quando realizada devolução pelo Atendimento a dt_atualizacao_estoque não é nula 
	and	dt_atualizacao_estoque is null;*/
 
 

BEGIN 
 
 
open	c01;
loop 
fetch	c01 into 
	nr_atendimento_w, 
	dt_entrada_unidade_w, 
	cd_material_w, 
	dt_atendimento_w, 
	qt_material_w, 
	cd_setor_atendimento_w, 
	cd_unidade_medida_w, 
	nr_seq_proc_princ_w, 
	nr_sequencia_w, 
	cd_cgc_fornecedor_w, 
	ds_observacao_w, 
	nr_seq_lote_fornec_w, 
	nr_receita_w, 
	nr_serie_material_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	 
	CALL Gerar_Prescricao_estoque( 
			null, 
			nr_atendimento_w, 
			dt_entrada_unidade_w, 
			cd_material_w, 
			dt_atendimento_w, 
			2, 
			cd_local_estoque_p, 
			qt_material_w, 
			cd_setor_atendimento_w, 
			cd_unidade_medida_w, 
			nm_usuario_p, 'E', 
			nr_prescricao_p, 
         	nr_sequencia_p, 
			nr_seq_proc_princ_w, 
			nr_sequencia_w, 
			cd_cgc_fornecedor_w, 
			ds_observacao_w, 
			nr_seq_lote_fornec_w, 
			nr_receita_w, 
			nr_serie_material_w, 
			null, '','','');
 
	delete from material_atend_paciente 
	where	nr_sequencia = nr_sequencia_w;
 
	end;
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE estornar_dev_atend_prescr ( nr_prescricao_p bigint, nr_sequencia_p bigint, cd_local_estoque_p bigint, nm_usuario_p text) FROM PUBLIC;
