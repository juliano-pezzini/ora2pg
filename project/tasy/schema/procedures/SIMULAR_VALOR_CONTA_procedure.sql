-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE simular_valor_conta ( nr_interno_conta_p bigint, cd_convenio_p bigint, cd_categoria_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_valor_w			bigint		:= 0;
cd_convenio_w			integer		:= 0;
cd_categoria_w			varchar(10);
nr_sequencia_w			bigint		:= 0;
vl_material_w			double precision		:= 0;
cd_estabelecimento_w		smallint		:= 0;
dt_conta_w				timestamp			:= clock_timestamp();
cd_material_w			integer		:= 0;
vl_preco_material_w		double precision		:= 0;
dt_ultima_vigencia_w		timestamp;
cd_tab_preco_mat_w		smallint		:= 0;
ie_origem_preco_w			smallint		:= 0;
qt_material_w			double precision		:= 0;
ie_valor_informado_w		varchar(1);
nr_atendimento_w			bigint		:= 0;
dt_atendimento_w			timestamp;
ie_tipo_convenio_w		smallint		:= 0;
ie_classif_contabil_w		varchar(1);
cd_autorizacao_w			varchar(20);
cd_senha_w				varchar(20);
QT_AUTORIZADA_W           	double precision := 0;
NR_SEQ_AUTORIZACAO_W      	bigint;
IE_GLOSA_W            	  	varchar(1);
NM_RESPONSAVEL_W          	varchar(40);
CD_SITUACAO_GLOSA_W       	smallint	   := 0;
IE_COBRA_PACIENTE_W       	varchar(1)  := 'N';
CD_ACAO_W            	  	varchar(1);
NR_PRESCRICAO_W	  	  	bigint;
NR_SEQUENCIA_PRESCRICAO_W 	integer;
CD_MATERIAL_PRESCRICAO_W  	integer;
VL_MATERIAL_ORIG_W        	double precision := 0;
VL_UNITARIO_ORIG_W        	double precision := 0;
DT_ULT_VIGENCIA_W         	timestamp         := clock_timestamp();
VL_TOTAL_MATERIAL_W       	double precision := 0;
VL_UNITARIO_W             	double precision := 0;
CD_TIPO_ACOMODACAO_W          smallint;
IE_TIPO_ATENDIMENTO_W         smallint;
CD_SETOR_ATENDIMENTO_W        integer;
cd_cgc_fornecedor_w		varchar(14) := '';
pr_glosa_w			double precision;
vl_glosa_w			double precision;
cd_motivo_exc_conta_w	bigint;
ie_autor_particular_w		varchar(1)	:= 'N';

cd_convenio_glosa_ww		integer := 0;
cd_categoria_glosa_ww		varchar(10):= ' ';
nr_seq_regra_ajuste_ww		bigint:= 0;
nr_seq_bras_preco_w		bigint;
nr_seq_mat_bras_w		bigint;
nr_seq_conv_bras_w		bigint;
nr_seq_conv_simpro_w		bigint;
nr_seq_mat_simpro_w		bigint;
nr_seq_simpro_preco_w		bigint;
nr_seq_ajuste_mat_w		bigint;
nr_seq_classif_atend_w		atendimento_paciente.nr_seq_classificacao%type;


c01 CURSOR FOR
SELECT 	a.nr_sequencia,
		a.cd_material,
		a.qt_material,
		coalesce(a.dt_conta,coalesce(a.dt_prescricao,a.dt_atendimento)),
		coalesce(a.ie_valor_informado,'N'),
		a.nr_atendimento,
		a.dt_atendimento,
		b.ie_cobra_paciente,
		a.cd_acao,
		a.nr_prescricao,
		a.nr_sequencia_prescricao,
		a.cd_material_prescricao,
		coalesce(a.vl_material,0),
		coalesce(a.vl_unitario,0),
		cd_cgc_fornecedor
from 		material b,
		material_atend_paciente a
where 	a.cd_material		= b.cd_material
and 		a.nr_interno_conta 	= nr_interno_conta_p
order by	a.cd_material,
		coalesce(a.dt_conta,coalesce(a.dt_prescricao,a.dt_atendimento));


BEGIN
CD_TIPO_ACOMODACAO_W          := NULL;
IE_TIPO_ATENDIMENTO_W         := NULL;
CD_SETOR_ATENDIMENTO_W        := NULL;

cd_convenio_w	:= cd_convenio_p;
cd_categoria_w	:= cd_categoria_p;

begin
delete from Mat_atend_paciente_valor
where ie_tipo_valor = 2
and	nr_seq_material in (SELECT nr_sequencia from material_atend_paciente
				where nr_interno_conta = nr_interno_conta_p);
end;
commit;

select	a.cd_estabelecimento,
	a.nr_seq_classificacao
into STRICT	cd_estabelecimento_w,
	nr_seq_classif_atend_w
from	atendimento_paciente a,
	conta_paciente b
where	a.nr_atendimento = b.nr_atendimento
and	b.nr_interno_conta = nr_interno_conta_p;

OPEN C01;
LOOP
FETCH C01 into	nr_sequencia_w,
			cd_material_w,
			qt_material_w,
			dt_conta_w,
			ie_valor_informado_w,
			nr_atendimento_w,
			dt_atendimento_w,
			ie_cobra_paciente_w,
			cd_acao_w,
			nr_prescricao_w,
			nr_sequencia_prescricao_w,
			cd_material_prescricao_w,
			vl_material_w,
			vl_unitario_w,
			cd_cgc_fornecedor_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	BEGIN
	vl_preco_material_w	:= 0;
	cd_convenio_w		:= cd_convenio_p;
	cd_categoria_w		:= cd_categoria_p;
	SELECT * FROM Glosa_Material(CD_ESTABELECIMENTO_W, NR_ATENDIMENTO_W, DT_ATENDIMENTO_W, CD_MATERIAL_W, QT_MATERIAL_W, CD_TIPO_ACOMODACAO_W, IE_TIPO_ATENDIMENTO_W, CD_SETOR_ATENDIMENTO_W, 0, null, null, null, null, CD_CONVENIO_W, CD_CATEGORIA_W, IE_TIPO_CONVENIO_W, IE_CLASSIF_CONTABIL_W, CD_AUTORIZACAO_W, NR_SEQ_AUTORIZACAO_W, QT_AUTORIZADA_W, CD_SENHA_W, NM_RESPONSAVEL_W, IE_GLOSA_W, CD_SITUACAO_GLOSA_W, pr_glosa_w, vl_glosa_w, cd_motivo_exc_conta_w, ie_autor_particular_w, cd_convenio_glosa_ww, cd_categoria_glosa_ww, nr_seq_regra_ajuste_ww, 0) INTO STRICT CD_CONVENIO_W, CD_CATEGORIA_W, IE_TIPO_CONVENIO_W, IE_CLASSIF_CONTABIL_W, CD_AUTORIZACAO_W, NR_SEQ_AUTORIZACAO_W, QT_AUTORIZADA_W, CD_SENHA_W, NM_RESPONSAVEL_W, IE_GLOSA_W, CD_SITUACAO_GLOSA_W, pr_glosa_w, vl_glosa_w, cd_motivo_exc_conta_w, ie_autor_particular_w, cd_convenio_glosa_ww, cd_categoria_glosa_ww, nr_seq_regra_ajuste_ww;

	if (IE_COBRA_PACIENTE_W = 'S') 	then
		SELECT * FROM Define_Preco_Material(CD_ESTABELECIMENTO_W, CD_CONVENIO_W, CD_CATEGORIA_W, DT_CONTA_W, CD_MATERIAL_W, CD_TIPO_ACOMODACAO_W, IE_TIPO_ATENDIMENTO_W, CD_SETOR_ATENDIMENTO_W, cd_cgc_fornecedor_w, 0, 0, null, null, null, null, null, nr_seq_classif_atend_w, null, null, VL_PRECO_MATERIAL_W, DT_ULT_VIGENCIA_W, CD_TAB_PRECO_MAT_W, IE_ORIGEM_PRECO_W, nr_seq_bras_preco_w, nr_seq_mat_bras_w, nr_seq_conv_bras_w, nr_seq_conv_simpro_w, nr_seq_mat_simpro_w, nr_seq_simpro_preco_w, nr_seq_ajuste_mat_w) INTO STRICT VL_PRECO_MATERIAL_W, DT_ULT_VIGENCIA_W, CD_TAB_PRECO_MAT_W, IE_ORIGEM_PRECO_W, nr_seq_bras_preco_w, nr_seq_mat_bras_w, nr_seq_conv_bras_w, nr_seq_conv_simpro_w, nr_seq_mat_simpro_w, nr_seq_simpro_preco_w, nr_seq_ajuste_mat_w;
	end if;

	VL_TOTAL_MATERIAL_W := (VL_PRECO_MATERIAL_W * QT_MATERIAL_W);

	begin
	select coalesce(max(nr_sequencia),0) + 1
	into STRICT 	nr_seq_valor_w
	from Mat_atend_paciente_valor
	where nr_seq_material 	= nr_sequencia_w;

     	Insert into Mat_atend_paciente_valor(nr_seq_material,
		nr_sequencia,
		ie_tipo_valor,
		dt_atualizacao,
		nm_usuario,
		vl_material,
		cd_convenio,
		cd_categoria)
	values (nr_sequencia_w,
		nr_seq_valor_w,
		2,
		clock_timestamp(),
		nm_usuario_p,
		vl_total_material_w,
		cd_convenio_w,
		cd_categoria_w);
	commit;
	end;
	END;
END LOOP;
close c01;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE simular_valor_conta ( nr_interno_conta_p bigint, cd_convenio_p bigint, cd_categoria_p text, nm_usuario_p text) FROM PUBLIC;
