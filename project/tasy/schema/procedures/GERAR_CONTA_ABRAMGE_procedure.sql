-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_conta_abramge ( nr_interno_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_grupo_item_w			bigint;
cd_item_w				varchar(20);
ds_item_w				varchar(180);
dt_item_w				timestamp;
qt_item_w				double precision;
vl_item_w				double precision;
pr_item_w				bigint;
ie_eme_w				varchar(15);
ie_dhe_w				varchar(15);
ie_funcao_medico_w			varchar(80);
nr_sequencia_w			bigint;
vl_total_materiais_w			double precision;
vl_total_medic_w			double precision;
nr_seq_item_w				bigint;
nr_seq_w				bigint;
ds_observacao_w			varchar(255);
cd_material_convenio_w		varchar(20);
cd_medicamento_convenio_w		varchar(20);
qt_registros_w			bigint;
cd_setor_atendimento_w		bigint;
cd_especialidade_w		integer;

C01 CURSOR FOR 
SELECT		CASE WHEN b.cd_area_procedimento=1 THEN 1 WHEN b.cd_area_procedimento=11 THEN 1 WHEN b.cd_area_procedimento=4 THEN 2 WHEN b.cd_area_procedimento=13 THEN 2 WHEN b.cd_area_procedimento=2 THEN 3 WHEN b.cd_area_procedimento=12 THEN 3 WHEN b.cd_area_procedimento=3 THEN 4 WHEN b.cd_area_procedimento=14 THEN 4  ELSE CASE WHEN c.ie_classificacao='3' THEN 7 WHEN c.ie_classificacao='2' THEN 8  ELSE 9 END  END ,	 
		substr(a.cd_proc_convenio,1,20), 
		substr(a.ds_proc_convenio,1,180), 
		a.dt_procedimento, 
		a.qt_procedimento, 
		CASE WHEN b.cd_area_procedimento=3 THEN a.vl_medico + a.vl_custo_operacional WHEN b.cd_area_procedimento=14 THEN a.vl_medico + a.vl_custo_operacional WHEN b.cd_area_procedimento=4 THEN a.vl_medico WHEN b.cd_area_procedimento=13 THEN a.vl_medico  ELSE CASE WHEN b.cd_especialidade=23000007 THEN a.vl_medico WHEN b.cd_especialidade=15000001 THEN a.vl_medico  ELSE a.vl_procedimento END  END , 
		round(coalesce(a.pr_faturado,100)), 
		CASE WHEN coalesce(d.ie_carater_inter_sus::text, '') = '' THEN ' ' WHEN d.ie_carater_inter_sus='1' THEN ' '  ELSE 'X' END , 
		CASE WHEN coalesce(a.tx_hora_extra::text, '') = '' THEN ' ' WHEN a.tx_hora_extra=1 THEN ' '  ELSE 'X' END , 
		substr(a.ie_funcao_medico,1,80), 
		a.nr_sequencia, 
		a.cd_setor_atendimento cd_setor_atend, 
		a.cd_especialidade 
from		atendimento_paciente d, 
		procedimento c, 
		estrutura_procedimento_v b, 
		conta_paciente_honorario_v a 
where		a.nr_interno_conta	= nr_interno_conta_p 
and		a.nr_atendimento		= d.nr_atendimento 
and		coalesce(a.cd_motivo_exc_conta::text, '') = '' 
and		a.cd_procedimento		= b.cd_procedimento 
and		a.ie_origem_proced	= b.ie_origem_proced 
and		a.cd_procedimento		= c.cd_procedimento 
and		a.ie_origem_proced	= c.ie_origem_proced 
and 		coalesce(a.ie_responsavel_credito,'X') <> 'M' 
and (a.nr_sequencia	= a.nr_seq_proc_pacote or 
		coalesce(a.nr_seq_proc_pacote::text, '') = '') 
and		b.cd_area_procedimento 	not in (9) 

union
 
SELECT		CASE WHEN b.cd_area_procedimento=1 THEN 1 WHEN b.cd_area_procedimento=11 THEN 1 WHEN b.cd_area_procedimento=4 THEN 2 WHEN b.cd_area_procedimento=13 THEN 2 WHEN b.cd_area_procedimento=2 THEN 3 WHEN b.cd_area_procedimento=12 THEN 3 WHEN b.cd_area_procedimento=3 THEN 4 WHEN b.cd_area_procedimento=14 THEN 4  ELSE CASE WHEN c.ie_classificacao='3' THEN 7 WHEN c.ie_classificacao='2' THEN 8  ELSE 9 END  END ,	 
		substr(a.cd_proc_convenio,1,20), 
		substr(a.ds_proc_convenio,1,180), 
		d.dt_entrada, 
		a.qt_procedimento, 
		CASE WHEN b.cd_area_procedimento=3 THEN a.vl_medico WHEN b.cd_area_procedimento=14 THEN a.vl_medico WHEN b.cd_area_procedimento=4 THEN a.vl_medico WHEN b.cd_area_procedimento=13 THEN a.vl_medico  ELSE CASE WHEN b.cd_especialidade=23000007 THEN a.vl_medico WHEN b.cd_especialidade=15000001 THEN a.vl_medico  ELSE a.vl_procedimento END  END , 
		round(coalesce(a.pr_faturado,100)), 
		CASE WHEN coalesce(d.ie_carater_inter_sus::text, '') = '' THEN ' ' WHEN d.ie_carater_inter_sus='1' THEN ' '  ELSE 'X' END , 
		CASE WHEN coalesce(a.tx_hora_extra::text, '') = '' THEN ' ' WHEN a.tx_hora_extra=1 THEN ' '  ELSE 'X' END , 
		substr(a.ie_funcao_medico,1,80), 
		a.nr_sequencia, 
		a.cd_setor_atendimento cd_setor_atend, 
		a.cd_especialidade 
from		atendimento_paciente d, 
		procedimento c, 
		estrutura_procedimento_v b, 
		conta_paciente_honorario_v a 
where		a.nr_interno_conta	= nr_interno_conta_p 
and		a.nr_atendimento		= d.nr_atendimento 
and		coalesce(a.cd_motivo_exc_conta::text, '') = '' 
and		a.cd_procedimento		= b.cd_procedimento 
and		a.ie_origem_proced	= b.ie_origem_proced 
and		a.cd_procedimento		= c.cd_procedimento 
and		a.ie_origem_proced	= c.ie_origem_proced 
and 		coalesce(a.ie_responsavel_credito,'X') <> 'M' 
and (a.nr_sequencia	= a.nr_seq_proc_pacote or 
		coalesce(a.nr_seq_proc_pacote::text, '') = '') 
and		b.cd_area_procedimento 	in (9) 
/* OS 51024 - Fabrício em 21/02/2007, Documentado o Select abaixo */
 
/*union 
select	 
		decode(b.cd_area_procedimento,1,1,11,1,4,2,13,2,2,3,12,3,3,4,14,4, 
				decode(c.ie_classificacao,'3',7,'2',8,9)),	 
		substr(a.cd_proc_convenio,1,20), 
		substr(('custo oper - '||a.ds_proc_convenio),1,100), 
		a.dt_procedimento, 
		a.qt_procedimento, 
		a.vl_custo_operacional, 
		round(nvl(a.pr_faturado,100)), 
		decode(d.ie_carater_inter_sus,null,' ','1',' ','X'), 
		decode(a.tx_hora_extra,null,'N',1,' ','X'), 
		a.ie_funcao_medico, 
		a.nr_sequencia, 
		a.cd_setor_atendimento cd_setor_atend, 
		a.cd_especialidade 
from		atendimento_paciente d, 
		procedimento c, 
		estrutura_procedimento_v b, 
		conta_paciente_honorario_v a 
where		a.nr_interno_conta	= nr_interno_conta_p 
and		a.nr_atendimento		= d.nr_atendimento 
and		a.cd_motivo_exc_conta	is null 
and		a.cd_procedimento		= b.cd_procedimento 
and		a.ie_origem_proced	= b.ie_origem_proced 
and		a.cd_procedimento		= c.cd_procedimento 
and		a.ie_origem_proced	= c.ie_origem_proced 
and 		nvl(a.ie_responsavel_credito,'X') <> 'M' 
and		b.cd_area_procedimento 	in (3,14) 
and		(a.nr_sequencia	= a.nr_seq_proc_pacote or 
		a.nr_seq_proc_pacote is null) */
 
order by	1,11;

 
 
C02 CURSOR FOR 
SELECT	1, 
		5,		 
		substr(a.cd_proc_convenio,1,20), 
		substr(wheb_mensagem_pck.get_Texto(312055, 'DS_PROC_CONVENIO_W='|| a.ds_proc_convenio),1,100), /*Filme - #@DS_PROC_CONVENIO_W#@*/
 
		max(a.dt_procedimento), 
		sum(coalesce(Obter_dados_preco_amb(a.nr_sequencia,'F'),0)), 
		sum(a.vl_filme), 
		100, 
		' ', 
		' ', 
		' ', 
		wheb_mensagem_pck.get_Texto(312061, 'CD_PROC_CONVENIO_W='|| substr(a.cd_proc_convenio,1,20)),/* Procedimento: #@CD_PROC_CONVENIO#@*/
 
		a.cd_setor_atendimento cd_setor_atend 
from		atendimento_paciente d, 
		procedimento c, 
		estrutura_procedimento_v b, 
		conta_paciente_honorario_v a 
where		a.nr_interno_conta	= nr_interno_conta_p 
and		a.nr_atendimento		= d.nr_atendimento 
and		coalesce(a.cd_motivo_exc_conta::text, '') = '' 
and		a.cd_procedimento		= b.cd_procedimento 
and		a.ie_origem_proced	= b.ie_origem_proced 
and		a.cd_procedimento		= c.cd_procedimento 
and		a.ie_origem_proced	= c.ie_origem_proced 
and 		coalesce(a.ie_responsavel_credito,'X') <> 'M' 
and		b.cd_area_procedimento 	in (3,14) 
and		a.vl_filme			<> 0 
and (a.nr_sequencia	= a.nr_seq_proc_pacote or 
		coalesce(a.nr_seq_proc_pacote::text, '') = '') 
group by 
		substr(a.cd_proc_convenio,1,20), 
		substr(wheb_mensagem_pck.get_Texto(312055, 'DS_PROC_CONVENIO_W='|| a.ds_proc_convenio),1,100), /*Filme - #@DS_PROC_CONVENIO_W#@*/
 
		wheb_mensagem_pck.get_Texto(312061, 'CD_PROC_CONVENIO_W='|| substr(a.cd_proc_convenio,1,20)),/* Procedimento: #@CD_PROC_CONVENIO#@*/
 
		a.cd_setor_atendimento 

union
 
SELECT	2, 
		CASE WHEN c.ie_tipo_material='1' THEN 5 WHEN c.ie_tipo_material='5' THEN 5 WHEN c.ie_tipo_material='2' THEN 6 WHEN c.ie_tipo_material='3' THEN 6  ELSE 5 END , 
		substr(a.cd_material_convenio,1,20), 
		substr(a.ds_material,1,180), 
		max(a.dt_atendimento), 
		sum(a.qt_material_convenio), 
		sum(a.vl_material_convenio), 
		100, 
		' ', 
		' ', 
		' ', 
		CASE WHEN 'Simpro: '||a.cd_simpro='Simpro: ' THEN  			CASE WHEN 'Brasindice: '||a.cd_brasindice='Brasindice: ' THEN ' '  ELSE 'Brasindice: '||a.cd_brasindice END   ELSE 'Simpro: '||a.cd_simpro END , 
		a.cd_setor_atendimento cd_setor_atend 
from		material c, 
		conta_paciente_material_v a 
where		a.nr_interno_conta	= nr_interno_conta_p 
and		coalesce(a.cd_motivo_exc_conta::text, '') = '' 
and		a.cd_material		= c.cd_material 
and (a.nr_sequencia	= a.nr_seq_proc_pacote or 
		coalesce(a.nr_seq_proc_pacote::text, '') = '') 
group by 
		CASE WHEN c.ie_tipo_material='1' THEN 5 WHEN c.ie_tipo_material='5' THEN 5 WHEN c.ie_tipo_material='2' THEN 6 WHEN c.ie_tipo_material='3' THEN 6  ELSE 5 END , 
		substr(a.cd_material_convenio,1,20), 
		substr(a.ds_material,1,180), 
		a.cd_setor_atendimento, 
		CASE WHEN 'Simpro: '||a.cd_simpro='Simpro: ' THEN  			CASE WHEN 'Brasindice: '||a.cd_brasindice='Brasindice: ' THEN ' '  ELSE 'Brasindice: '||a.cd_brasindice END   ELSE 'Simpro: '||a.cd_simpro END  
order by	1,2,3;

 

BEGIN 
 
delete from w_conta_abramge_item 
where nr_interno_conta = nr_interno_conta_p;
commit;
 
/* Tratamento de procedimentos serviços, diárias e taxas */
 
OPEN C01;
LOOP 
FETCH C01 	into 
		cd_grupo_item_w, 
		cd_item_w, 
		ds_item_w, 
		dt_item_w, 
		qt_item_w, 
		vl_item_w, 
		pr_item_w, 
		ie_eme_w, 
		ie_dhe_w, 
		ie_funcao_medico_w, 
		nr_seq_item_w, 
		cd_setor_atendimento_w, 
		cd_especialidade_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	select nextval('w_conta_abramge_item_seq') 
	into STRICT	 nr_sequencia_w 
	;
 
	insert into w_conta_abramge_item( 
			NR_SEQUENCIA	, 
			NR_INTERNO_CONTA	,   
			IE_TIPO_ITEM	, 
			CD_GRUPO_ITEM	, 
			CD_ITEM		, 
			DS_ITEM		, 
			DT_ITEM		, 
			QT_ITEM		, 
			VL_ITEM		, 
			PR_ITEM		, 
			IE_EME		, 
			IE_DHE		, 
			IE_FUNCAO_MEDICO	, 
			DT_ATUALIZACAO	, 
			NM_USUARIO, 
			CD_SETOR_ATENDIMENTO, 
			CD_ESPECIALIDADE) 
		values ( 
			nr_sequencia_w	, 
			nr_interno_conta_p, 
			1			, 
			cd_grupo_item_w	, 
			cd_item_w		, 
			ds_item_w		, 
			dt_item_w		, 
			qt_item_w		, 
			vl_item_w		, 
			pr_item_w		, 
			ie_eme_w		, 
			ie_dhe_w		, 
			ie_funcao_medico_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_setor_atendimento_w, 
			cd_especialidade_w);
	end;
END LOOP;
close c01;
 
/* Tratamento do total de materiais */
 
select coalesce(sum(a.vl_material_convenio),0) 
into STRICT	 vl_total_materiais_w 
from	 material b, 
	 conta_paciente_material_v a 
where	 a.nr_interno_conta	= nr_interno_conta_p 
and	 coalesce(a.cd_motivo_exc_conta::text, '') = '' 
and	 a.cd_material		= b.cd_material 
and (a.nr_sequencia		= a.nr_seq_proc_pacote or 
	coalesce(a.nr_seq_proc_pacote::text, '') = '') 
and	 b.ie_tipo_material	in ('1','5');
 
if (vl_total_materiais_w	> 0) then 
	begin 
	cd_material_convenio_w	:= ' ';
	qt_registros_w		:= 0;
 
	select 	count(distinct(a.CD_MATERIAL_CONVENIO)) 
	into STRICT	qt_registros_w 
	from 	material b, 
		conta_paciente_material_v a 
	where	 a.nr_interno_conta		= nr_interno_conta_p 
	and	 coalesce(a.cd_motivo_exc_conta::text, '') = '' 
	and	 a.cd_material		= b.cd_material 
	and (a.nr_sequencia		= a.nr_seq_proc_pacote or 
		coalesce(a.nr_seq_proc_pacote::text, '') = '') 
	and	 b.ie_tipo_material		in ('1','5');
 
	if (qt_registros_w	= 1) then 
		begin 
		select 	coalesce(max(substr(a.CD_MATERIAL_CONVENIO,1,20)),' ') 
		into STRICT	cd_material_convenio_w 
		from 	material b, 
			conta_paciente_material_v a 
		where	 a.nr_interno_conta		= nr_interno_conta_p 
		and	 coalesce(a.cd_motivo_exc_conta::text, '') = '' 
		and	 a.cd_material		= b.cd_material 
		and (a.nr_sequencia		= a.nr_seq_proc_pacote or 
			coalesce(a.nr_seq_proc_pacote::text, '') = '') 
		and	 b.ie_tipo_material		in ('1','5');
		end;
	end if;
 
	select nextval('w_conta_abramge_item_seq') 
	into STRICT	 nr_sequencia_w 
	;
	insert into w_conta_abramge_item( 
			NR_SEQUENCIA	, 
			NR_INTERNO_CONTA	,   
			IE_TIPO_ITEM	, 
			CD_GRUPO_ITEM	, 
			CD_ITEM		, 
			DS_ITEM		, 
			DT_ITEM		, 
			QT_ITEM		, 
			VL_ITEM		, 
			PR_ITEM		, 
			IE_EME		, 
			IE_DHE		, 
			IE_FUNCAO_MEDICO	, 
			DT_ATUALIZACAO	, 
			NM_USUARIO) 
		values ( 
			nr_sequencia_w	, 
			nr_interno_conta_p, 
			1			, 
			5			, 
			cd_material_convenio_w	, 
			wheb_mensagem_pck.get_Texto(312074), /*'Materiais'*/
 
			null		, 
			1			, 
			vl_total_materiais_w, 
			100			, 
			' '			, 
			' '			, 
			null			, 
			clock_timestamp()		, 
			nm_usuario_p);
	end;
end if;
 
/* Tratamento do total de medicamentos */
 
select coalesce(sum(a.vl_material_convenio),0) 
into STRICT	 vl_total_medic_w 
from	 material b, 
	 conta_paciente_material_v a 
where	 a.nr_interno_conta	= nr_interno_conta_p 
and	 coalesce(a.cd_motivo_exc_conta::text, '') = '' 
and	 a.cd_material		= b.cd_material 
and (a.nr_sequencia		= a.nr_seq_proc_pacote or 
	coalesce(a.nr_seq_proc_pacote::text, '') = '') 
and	 b.ie_tipo_material	in ('2','3');
 
if (vl_total_medic_w	> 0) then 
	begin 
 
	cd_medicamento_convenio_w	:= ' ';
	qt_registros_w			:= 0;
 
	select 	count(distinct(a.CD_MATERIAL_CONVENIO)) 
	into STRICT	qt_registros_w 
	from 	material b, 
		conta_paciente_material_v a 
	where	 a.nr_interno_conta		= nr_interno_conta_p 
	and	 coalesce(a.cd_motivo_exc_conta::text, '') = '' 
	and	 a.cd_material		= b.cd_material 
	and (a.nr_sequencia		= a.nr_seq_proc_pacote or 
		coalesce(a.nr_seq_proc_pacote::text, '') = '') 
	and	 b.ie_tipo_material		in ('2','3');
 
	if (qt_registros_w	= 1) then 
		begin 
		select 	coalesce(max(substr(a.CD_MATERIAL_CONVENIO,1,20)),' ') 
		into STRICT	cd_medicamento_convenio_w 
		from 	material b, 
			conta_paciente_material_v a 
		where	 a.nr_interno_conta		= nr_interno_conta_p 
		and	 coalesce(a.cd_motivo_exc_conta::text, '') = '' 
		and	 a.cd_material		= b.cd_material 
		and (a.nr_sequencia		= a.nr_seq_proc_pacote or 
			coalesce(a.nr_seq_proc_pacote::text, '') = '') 
		and	 b.ie_tipo_material		in ('2','3');
		end;
	end if;
 
 
	select nextval('w_conta_abramge_item_seq') 
	into STRICT	 nr_sequencia_w 
	;
	insert into w_conta_abramge_item( 
			NR_SEQUENCIA	, 
			NR_INTERNO_CONTA	,   
			IE_TIPO_ITEM	, 
			CD_GRUPO_ITEM	, 
			CD_ITEM		, 
			DS_ITEM		, 
			DT_ITEM		, 
			QT_ITEM		, 
			VL_ITEM		, 
			PR_ITEM		, 
			IE_EME		, 
			IE_DHE		, 
			IE_FUNCAO_MEDICO	, 
			DT_ATUALIZACAO	, 
			NM_USUARIO) 
		values ( 
			nr_sequencia_w	, 
			nr_interno_conta_p, 
			1			, 
			6			, 
			cd_medicamento_convenio_w	, 
			wheb_mensagem_pck.get_Texto(312077), /*'Medicamentos'*/
 
			null		, 
			1			, 
			vl_total_medic_w	, 
			100			, 
			' '			, 
			' '			, 
			null			, 
			clock_timestamp()		, 
			nm_usuario_p);
	end;
end if;
 
 
/* Tratamento de materiais e medicamentos */
 
OPEN C02;
LOOP 
FETCH C02 	into 
		nr_seq_w, 
		cd_grupo_item_w, 
		cd_item_w, 
		ds_item_w, 
		dt_item_w, 
		qt_item_w, 
		vl_item_w, 
		pr_item_w, 
		ie_eme_w, 
		ie_dhe_w, 
		ie_funcao_medico_w, 
		ds_observacao_w, 
		cd_setor_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
	select nextval('w_conta_abramge_item_seq') 
	into STRICT	 nr_sequencia_w 
	;
 
	insert into w_conta_abramge_item( 
			NR_SEQUENCIA	, 
			NR_INTERNO_CONTA	,   
			IE_TIPO_ITEM	, 
			CD_GRUPO_ITEM	, 
			CD_ITEM		, 
			DS_ITEM		, 
			DT_ITEM		, 
			QT_ITEM		, 
			VL_ITEM		, 
			PR_ITEM		, 
			IE_EME		, 
			IE_DHE		, 
			IE_FUNCAO_MEDICO	, 
			ds_observacao	, 
			DT_ATUALIZACAO	, 
			NM_USUARIO, 
			cd_setor_atendimento) 
		values ( 
			nr_sequencia_w	, 
			nr_interno_conta_p, 
			2			, 
			cd_grupo_item_w	, 
			cd_item_w		, 
			ds_item_w		, 
			dt_item_w		, 
			qt_item_w		, 
			vl_item_w		, 
			pr_item_w		, 
			ie_eme_w		, 
			ie_dhe_w		, 
			ie_funcao_medico_w, 
			ds_observacao_w	, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_setor_atendimento_w);
	end;
END LOOP;
close c02;
 
 
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_conta_abramge ( nr_interno_conta_p bigint, nm_usuario_p text) FROM PUBLIC;
