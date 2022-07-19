-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE proc_pac_record AS (
	nr_sequencia		PROCEDIMENTO_PACIENTE.NR_SEQUENCIA%type,
	nr_atendimento		PROCEDIMENTO_PACIENTE.NR_ATENDIMENTO%type,
	dt_atualizacao		PROCEDIMENTO_PACIENTE.DT_ATUALIZACAO%type,
	nm_usuario		PROCEDIMENTO_PACIENTE.NM_USUARIO%type,
	cd_convenio		PROCEDIMENTO_PACIENTE.CD_CONVENIO%type,
	cd_categoria		PROCEDIMENTO_PACIENTE.CD_CATEGORIA%type,
	vl_procedimento		PROCEDIMENTO_PACIENTE.VL_PROCEDIMENTO%type,
	vl_custo_operacional	PROCEDIMENTO_PACIENTE.VL_CUSTO_OPERACIONAL%type,
	nr_interno_conta	PROCEDIMENTO_PACIENTE.NR_INTERNO_CONTA%type,
	dt_entrada_unidade	PROCEDIMENTO_PACIENTE.DT_ENTRADA_UNIDADE%type,
	cd_procedimento		PROCEDIMENTO_PACIENTE.CD_PROCEDIMENTO%type,
	dt_procedimento		PROCEDIMENTO_PACIENTE.DT_PROCEDIMENTO%type,
	qt_procedimento		PROCEDIMENTO_PACIENTE.QT_PROCEDIMENTO%type,
	cd_edicao_amb		PROCEDIMENTO_PACIENTE.CD_EDICAO_AMB%type,
	vl_auxiliares		PROCEDIMENTO_PACIENTE.VL_AUXILIARES%type,
	cd_acao			PROCEDIMENTO_PACIENTE.CD_ACAO%type,
	dt_conta		PROCEDIMENTO_PACIENTE.DT_CONTA%type,
	cd_setor_atendimento	PROCEDIMENTO_PACIENTE.CD_SETOR_ATENDIMENTO%type,
	ie_origem_proced	PROCEDIMENTO_PACIENTE.IE_ORIGEM_PROCED%type,
	tx_procedimento		PROCEDIMENTO_PACIENTE.TX_PROCEDIMENTO%type,
	ie_valor_informado	PROCEDIMENTO_PACIENTE.IE_VALOR_INFORMADO%type,
	nm_usuario_original	PROCEDIMENTO_PACIENTE.NM_USUARIO_ORIGINAL%type,
	cd_setor_receita	PROCEDIMENTO_PACIENTE.CD_SETOR_RECEITA%type,
	nr_seq_atepacu		PROCEDIMENTO_PACIENTE.NR_SEQ_ATEPACU%type
);


CREATE OR REPLACE PROCEDURE processar_conta_col ( nr_interno_conta_p CONTA_PACIENTE.NR_INTERNO_CONTA%type, nm_usuario_p CONTA_PACIENTE.NM_USUARIO%type, processamento_p CONTA_PACIENTE.IE_COMPLEXIDADE%type DEFAULT 'D') AS $body$
DECLARE

TYPE proc_pac_type IS TABLE of proc_pac_record INDEX BY integer;
proc_pac_row            proc_pac_type;

nr_seq_proc_valor_w	PROC_PACIENTE_VALOR.NR_SEQUENCIA%type;
nr_interno_conta_w	CONTA_PACIENTE.NR_INTERNO_CONTA%type;
vl_total_conta_w	CONTA_PACIENTE.VL_CONTA%type;
nr_atendimento_w	CONTA_PAC_DEDUCAO_CONV.NR_ATENDIMENTO%type;
ie_tipo_calculo_w	CONTA_PAC_DEDUCAO_CONV.IE_TIPO_CALCULO%type;
pr_informado_calculo_w	CONTA_PAC_DEDUCAO_CONV.PR_INFORMADO_CALCULO%type;
vl_informado_calculo_w	CONTA_PAC_DEDUCAO_CONV.VL_INFORMADO_CALCULO%type;
cd_convenio_w		CONTA_PAC_DEDUCAO_CONV.CD_CONVENIO%type;
cd_categoria_w		CONTA_PAC_DEDUCAO_CONV.CD_CATEGORIA%type;
dt_processamento_w	CONTA_PAC_DEDUCAO_CONV.DT_PROCESSAMENTO%type;
cd_estabelecimento_w	CONTA_PACIENTE.CD_ESTABELECIMENTO%type;
vl_liquido_w		CONTA_PACIENTE.VL_CONTA%type;
nr_seq_desc_w		CONTA_PACIENTE_DESCONTO.NR_SEQUENCIA%type;
nr_interno_conta_desc_w	CONTA_PACIENTE_DESCONTO.NR_INTERNO_CONTA%type;
nr_conta_destino_w	CONTA_PACIENTE_DESCONTO.NR_INTERNO_CONTA%type;
qt_processada_w		CONTA_PACIENTE.QT_DIAS_CONTA%type;
vl_procedimento_w	PROCEDIMENTO_PACIENTE.VL_PROCEDIMENTO%type;
vl_custo_operacional_w	PROCEDIMENTO_PACIENTE.VL_CUSTO_OPERACIONAL%type;
nr_seq_proc_w		PROCEDIMENTO_PACIENTE.NR_SEQUENCIA%type;
nr_seq_material_novo_w	MATERIAL_ATEND_PACIENTE.NR_SEQUENCIA%TYPE;
vl_material_w		MATERIAL_ATEND_PACIENTE.VL_MATERIAL%type;
vl_unitario_w		MATERIAL_ATEND_PACIENTE.VL_UNITARIO%type;
ie_pr_informado_w	varchar(2);
pr_desconto_w		CONTA_PACIENTE_DESCONTO.PR_DESCONTO%TYPE;
vl_desconto_w		CONTA_PACIENTE_DESCONTO.VL_DESCONTO%TYPE := 0;

dt_atual_w		CONSTANT timestamp := clock_timestamp();

type nr_sequencia_tp is table of material_atend_paciente.nr_sequencia%type index by integer;
type nr_seq_origem_tp is table of material_atend_paciente.nr_seq_origem%type index by integer;
type vl_original_tp is table of material_atend_paciente.vl_material%type index by integer;
type vl_orig_proc_tp is table of procedimento_paciente.vl_procedimento%type index by integer;
type vl_orig_custo_oper_tp is table of procedimento_paciente.vl_custo_operacional%type index by integer;

nr_sequencia_w			nr_sequencia_tp;
nr_seq_origem_w			nr_seq_origem_tp;
vl_original_w			vl_original_tp;
vl_orig_proc_w			vl_orig_proc_tp;
vl_orig_custo_oper_w		vl_orig_custo_oper_tp;
vl_total_conta_ajuste_w		conta_paciente.vl_conta%type;
vl_item_ajuste_w		procedimento_paciente.vl_procedimento%type;
nr_seq_proc_ajuste_w		procedimento_paciente.nr_sequencia%type;
nr_seq_mat_ajuste_w		material_atend_paciente.nr_sequencia%type;
vl_diferenca_w			double precision;
vl_liquido_acumulado_w		conta_paciente_desc_item.vl_liquido%type;
vl_desconto_acumulado_w		conta_paciente_desc_item.vl_desconto%type;
nr_seq_desconot_acum_w		conta_paciente_desc_item.nr_seq_desconto%type;

	
c_desc_item_proc CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_origem,
		a.vl_procedimento,
		a.vl_custo_operacional
	from	procedimento_paciente a
	where	exists (SELECT	1
			from	procedimento_paciente x
			where	x.nr_sequencia = a.nr_seq_origem
			and	x.nr_interno_conta = nr_interno_conta_p);

c_desc_item_mat CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_origem,
		a.vl_material
	from	material_atend_paciente a
	where	exists (SELECT	1
			from	material_atend_paciente x
			where	x.nr_sequencia = a.nr_seq_origem
			and	x.nr_interno_conta = nr_interno_conta_p);

c_mat_pac CURSOR FOR
	SELECT	a.nr_sequencia,
		a.cd_material,
		a.qt_material,
		a.cd_setor_atendimento,
		a.nr_seq_atepacu,
		coalesce(a.vl_material,0) vl_material,
		a.cd_convenio,
		a.cd_categoria,
		a.dt_atendimento,
		a.cd_unidade_medida,
		a.dt_entrada_unidade,
		a.cd_acao,
		coalesce(a.dt_conta, a.dt_prescricao, a.dt_atendimento) dt_conta,
		a.cd_cgc_fornecedor,
		a.nr_seq_proc_princ,
		a.ie_valor_informado
	from	material_atend_paciente a
	where	a.nr_interno_conta = nr_interno_conta_p;

c_mat_pac_w		c_mat_pac%rowtype;

c_proced_pac CURSOR FOR
	SELECT 	a.nr_sequencia,
		a.nr_atendimento, 
		a.dt_atualizacao, 
		a.nm_usuario, 
		a.cd_convenio,
		a.cd_categoria, 
		a.vl_procedimento, 
		a.vl_custo_operacional, 
		a.nr_interno_conta,
		a.dt_entrada_unidade, 
		a.cd_procedimento, 
		a.dt_procedimento, 
		a.qt_procedimento,
		a.cd_edicao_amb, 
		a.vl_auxiliares, 
		a.cd_acao, 
		a.dt_conta, cd_setor_atendimento,
		a.ie_origem_proced, 
		a.tx_procedimento, 
		a.ie_valor_informado, 
		a.nm_usuario_original,
		a.cd_setor_receita, 
		a.nr_seq_atepacu, 
		a.nr_seq_origem
	from procedimento_paciente a
	where a.nr_interno_conta = nr_interno_conta_p;
	
c_conta_orgem CURSOR FOR
	SELECT	i.nr_sequencia,
		i.nr_seq_desconto,
		i.vl_conta,
		i.vl_desconto,
		i.vl_liquido,
		i.nr_seq_material,
		i.nr_seq_procedimento
	from	conta_paciente_desconto c,
		conta_paciente_desc_item i
	where	c.nr_interno_conta = nr_interno_conta_p
	and 	i.nr_seq_desconto = c.nr_sequencia
	and	c.ie_classificacao not in ('D', 'A');

c_proced_pac_w		c_proced_pac%rowtype;
c_conta_orgem_w		c_conta_orgem%rowtype;


BEGIN

SELECT  coalesce(MAX(a.NR_SEQUENCIA), 0)
INTO STRICT    qt_processada_w
FROM    CONTA_PAC_DEDUCAO_CONV a
WHERE   (a.DT_PROCESSAMENTO IS NOT NULL AND a.DT_PROCESSAMENTO::text <> '')
AND     NR_SEQ_CONTA_ORIG = nr_interno_conta_p;

SELECT  MAX(NR_ATENDIMENTO),
        MAX(CD_ESTABELECIMENTO),
        MAX(OBTER_VALOR_CONTA(NR_INTERNO_CONTA, 0))
INTO STRICT    nr_atendimento_w,
        cd_estabelecimento_w,
        vl_total_conta_w
FROM    CONTA_PACIENTE
WHERE   NR_INTERNO_CONTA = nr_interno_conta_p;

IF (processamento_p = 'P' AND qt_processada_w = 0) THEN
	SELECT	NR_SEQUENCIA,
		NR_ATENDIMENTO,
		DT_ATUALIZACAO,
		NM_USUARIO,
		CD_CONVENIO,
		CD_CATEGORIA,
		VL_PROCEDIMENTO,
		VL_CUSTO_OPERACIONAL,
		NR_INTERNO_CONTA,
		DT_ENTRADA_UNIDADE,
		CD_PROCEDIMENTO,
		DT_PROCEDIMENTO,
		QT_PROCEDIMENTO,
		CD_EDICAO_AMB,
		VL_AUXILIARES,
		CD_ACAO,
		DT_CONTA,
		CD_SETOR_ATENDIMENTO,
		IE_ORIGEM_PROCED,
		TX_PROCEDIMENTO,
		IE_VALOR_INFORMADO,
		NM_USUARIO_ORIGINAL,
		CD_SETOR_RECEITA,
		NR_SEQ_ATEPACU
	BULK COLLECT INTO STRICT proc_pac_row
	FROM	PROCEDIMENTO_PACIENTE
	WHERE	NR_INTERNO_CONTA = nr_interno_conta_p;

	SELECT  nextval('conta_paciente_seq')
	INTO STRICT    nr_interno_conta_w
	;

	SELECT	IE_TIPO_CALCULO,
		PR_INFORMADO_CALCULO,
		VL_INFORMADO_CALCULO,
		CD_CONVENIO,
		CD_CATEGORIA,
		DT_PROCESSAMENTO
	INTO STRICT	ie_tipo_calculo_w,
		pr_informado_calculo_w,
		vl_informado_calculo_w,
		cd_convenio_w,
		cd_categoria_w,
		dt_processamento_w
	FROM	CONTA_PAC_DEDUCAO_CONV
	WHERE	NR_SEQ_CONTA_ORIG = nr_interno_conta_p;

    if((ie_tipo_calculo_w = 'R' or ie_tipo_calculo_w = 'P') and pr_informado_calculo_w > 0 and coalesce(vl_informado_calculo_w::text, '') = '') then
        ie_tipo_calculo_w := 'C';
    elsif((ie_tipo_calculo_w = 'R' or ie_tipo_calculo_w = 'P') and coalesce(pr_informado_calculo_w::text, '') = '' and vl_informado_calculo_w > 0) then
        ie_tipo_calculo_w := 'M';
    elsif((ie_tipo_calculo_w = 'R' or ie_tipo_calculo_w = 'P') and (coalesce(pr_informado_calculo_w::text, '') = '' or pr_informado_calculo_w = 0) and (coalesce(vl_informado_calculo_w::text, '') = '' or vl_informado_calculo_w = 0)) then
        CALL wheb_mensagem_pck.exibir_mensagem_abort(1214467);
    end if;

	if (vl_informado_calculo_w > vl_total_conta_w) then
		/* O valor informado e maior do que o valor total da conta. */

		CALL wheb_mensagem_pck.exibir_mensagem_abort(1206095);
	end if;

	if (pr_informado_calculo_w > 999.99) then
		/* O percentual informado e maior do que o permitido. */

		CALL wheb_mensagem_pck.exibir_mensagem_abort(1206096);
	end if;

	INSERT INTO CONTA_PACIENTE(
		NR_INTERNO_CONTA,
		CD_ESTABELECIMENTO,
		NR_ATENDIMENTO,
		dt_acerto_conta,
		ie_status_acerto,
		dt_periodo_final,
		DT_ATUALIZACAO,
		NM_USUARIO,
		cd_convenio_parametro,
		CD_CATEGORIA_CALCULO,
		dt_periodo_inicial,
		NR_SEQ_CONTA_ORIGEM
	) VALUES (
		nr_interno_conta_w,
		cd_estabelecimento_w,
		nr_atendimento_w,
		dt_atual_w,
		1,
		dt_atual_w,
		dt_atual_w,
		nm_usuario_p,
		cd_convenio_w,
		cd_categoria_w,
		dt_atual_w,
		nr_interno_conta_p
	);

	open c_proced_pac;
	loop
	fetch c_proced_pac into
		c_proced_pac_w;
	EXIT WHEN NOT FOUND; /* apply on c_proced_pac */
		begin
		IF (ie_pr_informado_w = 'N') THEN
			pr_informado_calculo_w	:= round(((vl_informado_calculo_w/vl_total_conta_w)*100),3);
			vl_liquido_w		:= vl_total_conta_w - TRUNC((vl_total_conta_w * ((vl_informado_calculo_w / vl_total_conta_w) * 100) / 100), 2);
			vl_procedimento_w	:= ROUND((c_proced_pac_w.VL_PROCEDIMENTO * ((vl_informado_calculo_w / vl_total_conta_w) * 100) / 100),2);
			vl_custo_operacional_w	:= ROUND((c_proced_pac_w.VL_CUSTO_OPERACIONAL * ((vl_informado_calculo_w / vl_total_conta_w) * 100) / 100),2);
		ELSIF (ie_pr_informado_w = 'S') THEN
			vl_informado_calculo_w	:= trunc(((pr_informado_calculo_w / 100) * vl_total_conta_w), 2);
			vl_liquido_w		:= vl_total_conta_w - TRUNC(((vl_total_conta_w * pr_informado_calculo_w) / 100),2);
			vl_procedimento_w	:= round((c_proced_pac_w.VL_PROCEDIMENTO * pr_informado_calculo_w / 100)::numeric,2);
			vl_custo_operacional_w	:= ROUND((c_proced_pac_w.VL_CUSTO_OPERACIONAL * ((vl_informado_calculo_w / vl_total_conta_w) * 100) / 100),2);
		END IF;

		SELECT	nextval('procedimento_paciente_seq')
		INTO STRICT	nr_seq_proc_w
		;

		insert into procedimento_paciente(
			nr_sequencia,
			nr_atendimento, 
			dt_atualizacao, 
			nm_usuario, 
			cd_convenio,
			cd_categoria, 
			vl_procedimento, 
			vl_custo_operacional, 
			nr_interno_conta,
			dt_entrada_unidade, 
			cd_procedimento, 
			dt_procedimento, 
			qt_procedimento,
			cd_edicao_amb, 
			vl_auxiliares, 
			cd_acao, 
			dt_conta, cd_setor_atendimento,
			ie_origem_proced, 
			tx_procedimento, 
			ie_valor_informado, 
			nm_usuario_original,
			cd_setor_receita, 
			nr_seq_atepacu, 
			nr_seq_origem
		) values (
			nr_seq_proc_w,
			nr_atendimento_w,
			dt_atual_w,
			nm_usuario_p,
			cd_convenio_w,
			cd_categoria_w,
			vl_procedimento_w,
			vl_custo_operacional_w,
			nr_interno_conta_w,
			c_proced_pac_w.DT_ENTRADA_UNIDADE,
			c_proced_pac_w.CD_PROCEDIMENTO,
			c_proced_pac_w.DT_PROCEDIMENTO,
			c_proced_pac_w.QT_PROCEDIMENTO,
			c_proced_pac_w.CD_EDICAO_AMB,
			c_proced_pac_w.VL_AUXILIARES,
			c_proced_pac_w.CD_ACAO,
			c_proced_pac_w.DT_CONTA,
			c_proced_pac_w.CD_SETOR_ATENDIMENTO,
			c_proced_pac_w.IE_ORIGEM_PROCED,
			c_proced_pac_w.TX_PROCEDIMENTO,
			'S',
			c_proced_pac_w.NM_USUARIO_ORIGINAL,
			c_proced_pac_w.CD_SETOR_RECEITA,
			c_proced_pac_w.NR_SEQ_ATEPACU,
			c_proced_pac_w.NR_SEQUENCIA);
		end;
	end loop;
	close c_proced_pac;

	UPDATE	PROCEDIMENTO_PACIENTE
	SET	VL_PROCEDIMENTO      = (CASE ie_pr_informado_w
					WHEN 'N' THEN VL_PROCEDIMENTO - ROUND(VL_PROCEDIMENTO * ((vl_informado_calculo_w / vl_total_conta_w) * 100) / 100, 2)
					WHEN 'S' THEN VL_PROCEDIMENTO - round((VL_PROCEDIMENTO * pr_informado_calculo_w / 100)::numeric,2)
					ELSE 0
					END),
		VL_CUSTO_OPERACIONAL = (CASE ie_pr_informado_w 
					WHEN 'N' THEN VL_CUSTO_OPERACIONAL - ROUND(VL_CUSTO_OPERACIONAL * ((vl_informado_calculo_w / vl_total_conta_w) * 100) / 100,2)
					WHEN 'S' THEN VL_CUSTO_OPERACIONAL - round((VL_CUSTO_OPERACIONAL * pr_informado_calculo_w / 100)::numeric,2)
					ELSE NULL
					END),
		IE_VALOR_INFORMADO   =  'S'
	WHERE	NR_INTERNO_CONTA = nr_interno_conta_p;

	open c_mat_pac;
	loop
	fetch c_mat_pac into
		c_mat_pac_w;
	EXIT WHEN NOT FOUND; /* apply on c_mat_pac */
		begin
		
		if (ie_pr_informado_w = 'N') then
			pr_informado_calculo_w	:= round(((vl_informado_calculo_w/vl_total_conta_w) * 100),3);
			vl_liquido_w		:= vl_total_conta_w - trunc((vl_total_conta_w * ((vl_informado_calculo_w / vl_total_conta_w) * 100) / 100),2);
			vl_material_w		:= round((c_mat_pac_w.vl_material * ((vl_informado_calculo_w / vl_total_conta_w) * 100) / 100),2);
			vl_unitario_w		:= vl_material_w / c_mat_pac_w.qt_material;
		elsif (ie_pr_informado_w = 'S') then
			vl_informado_calculo_w	:= trunc(((pr_informado_calculo_w / 100) * vl_total_conta_w), 2);
			vl_liquido_w		:= vl_total_conta_w - trunc(((vl_total_conta_w * pr_informado_calculo_w) / 100),2);
			vl_material_w       	:= round((c_mat_pac_w.vl_material * pr_informado_calculo_w / 100)::numeric,2);
			vl_unitario_w		:= vl_material_w / c_mat_pac_w.qt_material;
		end if;
		
		select	nextval('material_atend_paciente_seq')
		into STRICT	nr_seq_material_novo_w
		;
		
		insert into material_atend_paciente(
			nr_sequencia,
			nr_atendimento,
			dt_atualizacao,
			nm_usuario,
			cd_convenio,
			cd_categoria,
			vl_unitario,
			vl_material,
			nr_interno_conta,
			dt_entrada_unidade,
			cd_material,
			dt_atendimento,
			cd_unidade_medida,
			qt_material,
			cd_acao,
			dt_conta,
			cd_setor_atendimento,
			ie_valor_informado,
			nr_seq_atepacu,
			nr_seq_origem
		) values (
			nr_seq_material_novo_w,
			nr_atendimento_w,
			dt_atual_w,
			nm_usuario_p,
			cd_convenio_w,
			cd_categoria_w,
			vl_unitario_w,
			vl_material_w,
			nr_interno_conta_w,
			c_mat_pac_w.dt_entrada_unidade,
			c_mat_pac_w.cd_material,
			c_mat_pac_w.dt_atendimento,
			c_mat_pac_w.cd_unidade_medida,
			c_mat_pac_w.qt_material,
			c_mat_pac_w.cd_acao,
			c_mat_pac_w.dt_conta,
			c_mat_pac_w.cd_setor_atendimento,
			'S',
			c_mat_pac_w.nr_seq_atepacu,
			c_mat_pac_w.nr_sequencia);
		end;
	end loop;
	close c_mat_pac;

	update  material_atend_paciente
	set     vl_material	= (	case ie_pr_informado_w
					when 'N' then vl_material - round(vl_material * ((vl_informado_calculo_w / vl_total_conta_w) * 100) / 100,2)
					when 'S' then vl_material - round((vl_material * pr_informado_calculo_w / 100)::numeric,2)
					else 0
					end),
		vl_unitario	= (	case ie_pr_informado_w 
					when 'N' then vl_material - round(vl_material * ((vl_informado_calculo_w / vl_total_conta_w) * 100) / 100,2)
					when 'S' then vl_material - round((vl_material * pr_informado_calculo_w / 100)::numeric,2)
					else 0
					end) / qt_material,
		ie_valor_informado   =  'S'
	where   nr_interno_conta = nr_interno_conta_p;
	
	IF ie_pr_informado_w = 'S' THEN
		pr_desconto_w := round((pr_informado_calculo_W)::numeric, 2);
	ELSE
		pr_desconto_w := round(((vl_informado_calculo_w/ vl_total_conta_w) * 100 ), 2);
	END IF;

	---Ajuste arredondamento conta destino---
	if (vl_informado_calculo_w > 0) then

		SELECT  MAX(OBTER_VALOR_CONTA(NR_INTERNO_CONTA, 0))
		INTO STRICT    vl_total_conta_ajuste_w
		FROM    CONTA_PACIENTE
		WHERE   NR_INTERNO_CONTA = nr_interno_conta_w;
		
		select 	vl,
			nr_seq_procedimento,
			nr_seq_material
		into STRICT	vl_item_ajuste_w,
			nr_seq_proc_ajuste_w,
			nr_seq_mat_ajuste_w
		from (	
			SELECT	a.vl_procedimento vl,
				a.nr_sequencia nr_seq_procedimento,
				null nr_seq_material
			from	procedimento_paciente a
			where	a.nr_interno_conta = nr_interno_conta_w
			
union all

			SELECT	a.vl_material vl,
				null nr_seq_procedimento,
				a.nr_sequencia nr_seq_material
			from	material_atend_paciente a
			where	a.nr_interno_conta = nr_interno_conta_w
		  order by vl desc) alias0 LIMIT 1;	

		if (vl_total_conta_ajuste_w > vl_informado_calculo_w) then
			vl_diferenca_w := (vl_total_conta_ajuste_w - vl_informado_calculo_w);
			if (nr_seq_proc_ajuste_w IS NOT NULL AND nr_seq_proc_ajuste_w::text <> '') then
				update	procedimento_paciente
				set	vl_procedimento = (vl_procedimento - vl_diferenca_w)
				where	nr_sequencia = nr_seq_proc_ajuste_w;
				
			elsif (nr_seq_mat_ajuste_w IS NOT NULL AND nr_seq_mat_ajuste_w::text <> '') then
				update	material_atend_paciente
				set	vl_material = (vl_material - vl_diferenca_w)
				where	nr_sequencia = nr_seq_mat_ajuste_w;
			end if;
		end if;

		if (vl_total_conta_ajuste_w < vl_informado_calculo_w) then
			vl_diferenca_w := (vl_informado_calculo_w - vl_total_conta_ajuste_w);
			if (nr_seq_proc_ajuste_w IS NOT NULL AND nr_seq_proc_ajuste_w::text <> '') then
				update	procedimento_paciente
				set	vl_procedimento = (vl_procedimento + vl_diferenca_w)
				where	nr_sequencia = nr_seq_proc_ajuste_w;
				
			elsif (nr_seq_mat_ajuste_w IS NOT NULL AND nr_seq_mat_ajuste_w::text <> '') then
				update	material_atend_paciente
				set	vl_material = (vl_material + vl_diferenca_w)
				where	nr_sequencia = nr_seq_mat_ajuste_w;
			end if;
		end if;
	end if;
	---FIM Ajuste arredondamento  conta destino---
	
	INSERT INTO CONTA_PACIENTE_DESCONTO(
		NR_SEQUENCIA,
		NR_INTERNO_CONTA,
		ie_tipo_desconto,
		DT_ATUALIZACAO,
		NM_USUARIO,
		VL_CONTA,
		PR_DESCONTO,
		VL_DESCONTO,
		VL_LIQUIDO,
		dt_desconto,
		dt_calculo,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_pacote,
		ie_classificacao
	) VALUES (
		nextval('conta_paciente_desconto_seq'),
		nr_interno_conta_p,
		6,
		dt_atual_w,
		nm_usuario_p,
		vl_total_conta_w,
		pr_desconto_w,
		coalesce(vl_informado_calculo_w,0),
		vl_liquido_w,
		dt_atual_w,
		dt_atual_w,
		dt_atual_w,
		nm_usuario_p,
		'A',
		'D'
	);

	INSERT INTO CONTA_PACIENTE_DESC_ITEM(
		NR_SEQUENCIA,
		NR_SEQ_DESCONTO,
		CD_ESTRUTURA,
		DT_ATUALIZACAO,
		NM_USUARIO,
		VL_CONTA,
		IE_CALCULA,
		PR_DESCONTO,
		VL_DESCONTO,
		VL_LIQUIDO,
		IE_DESC_MATERIAL,
		CD_PROCEDIMENTO,
		NR_SEQ_PROCEDIMENTO)
	SELECT	nextval('conta_paciente_desc_item_seq'),
		c.NR_SEQUENCIA,
		CASE WHEN a.IE_EMITE_CONTA='S' THEN  1 WHEN a.IE_EMITE_CONTA='N' THEN  2  ELSE a.IE_EMITE_CONTA END ,
		clock_timestamp(),
		WHEB_USUARIO_PCK.GET_NM_USUARIO,
		(a.VL_PROCEDIMENTO + (
		SELECT  coalesce(MAX(f.VL_PROCEDIMENTO), 0)
		FROM    PROCEDIMENTO_PACIENTE f,
			CONTA_PACIENTE g
		WHERE   f.NR_INTERNO_CONTA	= g.NR_INTERNO_CONTA
		AND     g.NR_SEQ_CONTA_ORIGEM	= b.NR_INTERNO_CONTA
		AND     f.NR_SEQ_ORIGEM		= a.NR_SEQUENCIA
		)) VL_CONTA,
		'S',
		c.PR_DESCONTO,
		(
		SELECT  coalesce(MAX(d.VL_PROCEDIMENTO), 0)
		FROM    PROCEDIMENTO_PACIENTE d,
			CONTA_PACIENTE e
		WHERE   d.NR_INTERNO_CONTA	= e.NR_INTERNO_CONTA
		AND     e.NR_SEQ_CONTA_ORIGEM	= b.NR_INTERNO_CONTA
		AND     d.NR_SEQ_ORIGEM		= a.NR_SEQUENCIA
		) VL_DESCONTO,
		a.VL_PROCEDIMENTO VL_LIQUIDO,
		'S',
		a.CD_PROCEDIMENTO,
		a.NR_SEQUENCIA
	FROM	PROCEDIMENTO_PACIENTE a,
		CONTA_PACIENTE b,
		CONTA_PACIENTE_DESCONTO c
	WHERE	a.NR_INTERNO_CONTA = b.NR_INTERNO_CONTA
	AND	c.NR_INTERNO_CONTA = a.NR_INTERNO_CONTA
	AND 	c.IE_CLASSIFICACAO NOT IN ('D', 'A')
	AND	b.NR_INTERNO_CONTA = nr_interno_conta_p;

	insert into conta_paciente_desc_item(
		nr_sequencia,
		nr_seq_desconto,
		cd_estrutura,
		dt_atualizacao,
		nm_usuario,
		vl_conta,
		ie_calcula,
		pr_desconto,
		vl_desconto,
		vl_liquido,
		ie_desc_material,
		cd_material,
		nr_seq_material)
	SELECT  nextval('conta_paciente_desc_item_seq'),
		c.nr_sequencia,
		CASE WHEN a.ie_emite_conta='S' THEN  1 WHEN a.ie_emite_conta='N' THEN  2  ELSE a.ie_emite_conta END ,
		clock_timestamp(),
		wheb_usuario_pck.get_nm_usuario,
		(a.vl_material + (	SELECT	coalesce(max(f.vl_material), 0)
					from	material_atend_paciente f,
						conta_paciente g
					where	f.nr_interno_conta	= g.nr_interno_conta
					and	g.nr_seq_conta_origem	= b.nr_interno_conta
					and	f.nr_seq_origem		= a.nr_sequencia)) vl_conta,
		'S',
		c.pr_desconto,
		(select coalesce(max(d.vl_material), 0)
		from    material_atend_paciente d,
			conta_paciente e
		where   d.nr_interno_conta      = e.nr_interno_conta
		and     e.nr_seq_conta_origem   = b.nr_interno_conta
		and     d.nr_seq_origem         = a.nr_sequencia) vl_desconto,
		a.vl_material vl_liquido,
		'S',
		a.cd_material,
		a.nr_sequencia
	from	material_atend_paciente a,
		conta_paciente b,
		conta_paciente_desconto c
	where	a.nr_interno_conta = b.nr_interno_conta
	and	c.nr_interno_conta = a.nr_interno_conta
	and 	c.ie_classificacao not in ('D', 'A')
	and	b.nr_interno_conta = nr_interno_conta_p;

	---Ajuste arredondamento conta origem---
	if (vl_informado_calculo_w > 0) then
		
		select	sum(i.vl_desconto)
		into STRICT	vl_desconto_acumulado_w
		from	conta_paciente_desconto c,
			conta_paciente_desc_item i
		where	c.nr_interno_conta = nr_interno_conta_p
		and 	i.nr_seq_desconto = c.nr_sequencia
		and	c.ie_classificacao not in ('D', 'A');
		
		if (vl_desconto_acumulado_w <> vl_informado_calculo_w) then
			vl_liquido_acumulado_w := 0;
			
			open c_conta_orgem;
			loop
			fetch 	c_conta_orgem into	
				c_conta_orgem_w;
			EXIT WHEN NOT FOUND; /* apply on c_conta_orgem */
				begin
				nr_seq_desconot_acum_w := c_conta_orgem_w.nr_seq_desconto;
				vl_diferenca_w := c_conta_orgem_w.vl_conta - c_conta_orgem_w.vl_desconto;
				if (c_conta_orgem_w.vl_liquido <> vl_diferenca_w) then
					update	conta_paciente_desc_item
					set	vl_liquido = vl_diferenca_w
					where 	nr_sequencia = c_conta_orgem_w.nr_sequencia;
					
					if (c_conta_orgem_w.nr_seq_material IS NOT NULL AND c_conta_orgem_w.nr_seq_material::text <> '') then
						update	material_atend_paciente
						set	vl_material = vl_diferenca_w
						where	nr_sequencia = c_conta_orgem_w.nr_seq_material;
					end if;
					
					if (c_conta_orgem_w.nr_seq_procedimento IS NOT NULL AND c_conta_orgem_w.nr_seq_procedimento::text <> '') then
						update	procedimento_paciente
						set	vl_procedimento = vl_diferenca_w
						where	nr_sequencia = c_conta_orgem_w.nr_seq_procedimento;
					end if;
					
					vl_liquido_acumulado_w := vl_liquido_acumulado_w + vl_diferenca_w;
				end if;
				
				end;
			end loop;
			close c_conta_orgem;
			
			update	conta_paciente_desconto
			set	vl_desconto = vl_informado_calculo_w,
				vl_liquido = vl_liquido_acumulado_w,
				vl_conta = vl_liquido_acumulado_w + vl_informado_calculo_w
			where	nr_sequencia = nr_seq_desconot_acum_w;
		end if;
	end if;
	---FIM Ajuste arredondamento  conta destino---
	
	UPDATE	CONTA_PAC_DEDUCAO_CONV
	SET	DT_PROCESSAMENTO    = dt_atual_w,
		NR_SEQ_CONTA_DES    = nr_interno_conta_w
	WHERE	NR_SEQ_CONTA_ORIG   = nr_interno_conta_p;

	UPDATE	CONTA_PACIENTE
	SET	NR_SEQ_CONTA_ORIGEM = nr_interno_conta_p
	WHERE	NR_INTERNO_CONTA    = nr_interno_conta_w;

	INSERT INTO PROC_PACIENTE_VALOR(
		NR_SEQUENCIA,
		NR_SEQ_PROCEDIMENTO,
		IE_TIPO_VALOR,
		DT_ATUALIZACAO,
		NM_USUARIO,
		VL_PROCEDIMENTO,
		VL_MEDICO,
		VL_ANESTESISTA,
		VL_MATERIAIS,
		VL_AUXILIARES,
		VL_CUSTO_OPERACIONAL,
		CD_CONVENIO,
		CD_CATEGORIA
		)
	SELECT (SELECT  coalesce(MAX(b.NR_SEQUENCIA), 0) + 1
		FROM    PROC_PACIENTE_VALOR b
		WHERE   b.NR_SEQ_PROCEDIMENTO = a.NR_SEQUENCIA
		),
		a.NR_SEQUENCIA,
		3,
		clock_timestamp(),
		nm_usuario_p,
		a.VL_PROCEDIMENTO,
		0,
		0,
		0,
		0,
		0,
		(SELECT MAX(b.CD_CONVENIO_CALCULO) FROM CONTA_PACIENTE b WHERE b.NR_INTERNO_CONTA = nr_interno_conta_p),
		(SELECT MAX(c.CD_CATEGORIA_CALCULO) FROM CONTA_PACIENTE c WHERE c.NR_INTERNO_CONTA = nr_interno_conta_p)
	FROM	PROCEDIMENTO_PACIENTE a
	WHERE	a.NR_INTERNO_CONTA = nr_interno_conta_p;

	insert into mat_atend_paciente_valor(
		nr_sequencia,
		nr_seq_material,
		ie_tipo_valor,
		dt_atualizacao,
		nm_usuario,
		vl_material,
		cd_convenio,
		cd_categoria,
		pr_valor
	) SELECT (
		SELECT	coalesce(max(b.nr_sequencia), 0) + 1
		from	mat_atend_paciente_valor b
		where	b.nr_seq_material = a.nr_sequencia),
		a.nr_sequencia,
		3,
		clock_timestamp(),
		nm_usuario_p,
		a.vl_material,
		(select max(b.cd_convenio_calculo) from conta_paciente b where b.nr_interno_conta = nr_interno_conta_p),
		(select max(c.cd_categoria_calculo) from conta_paciente c where c.nr_interno_conta = nr_interno_conta_p),
		0		
	from    material_atend_paciente a
	where   a.nr_interno_conta = nr_interno_conta_p;

ELSIF (processamento_p = 'D' AND qt_processada_w != 0) THEN
	DELETE  FROM PROC_PACIENTE_VALOR a
	WHERE   EXISTS (
	SELECT  b.NR_SEQUENCIA
	FROM    PROCEDIMENTO_PACIENTE b
	WHERE   a.VL_PROCEDIMENTO       = b.VL_PROCEDIMENTO
	AND     a.NR_SEQ_PROCEDIMENTO   = b.NR_SEQUENCIA
	AND     b.NR_INTERNO_CONTA      = nr_interno_conta_p
	);

	delete	from mat_atend_paciente_valor a
	where	exists (SELECT	b.nr_sequencia
			from	material_atend_paciente b
			where   a.vl_material       = b.vl_material
			and	a.nr_seq_material   = b.nr_sequencia
			and     b.nr_interno_conta  = nr_interno_conta_p);

	SELECT	NR_SEQUENCIA,
		NR_INTERNO_CONTA,
		VL_CONTA
	INTO STRICT	nr_seq_desc_w,
		nr_interno_conta_desc_w,
		vl_total_conta_w
	FROM	CONTA_PACIENTE_DESCONTO
	WHERE	NR_INTERNO_CONTA = nr_interno_conta_p;

	SELECT	NR_INTERNO_CONTA
	INTO STRICT	nr_conta_destino_w
	FROM	CONTA_PACIENTE
	WHERE	NR_SEQ_CONTA_ORIGEM = nr_interno_conta_p;
	
	open c_desc_item_proc;
	loop
	fetch c_desc_item_proc bulk collect into
		nr_sequencia_w,
		nr_seq_origem_w,
		vl_orig_proc_w,
		vl_orig_custo_oper_w limit 1000;
	exit when nr_sequencia_w.count = 0;

		forall i in nr_sequencia_w.first..nr_sequencia_w.last
			update 	procedimento_paciente
			set 	vl_procedimento		= vl_procedimento + vl_orig_proc_w(i),
				vl_custo_operacional	= vl_custo_operacional + vl_orig_custo_oper_w(i),
				ie_valor_informado	= 'N'
			where 	nr_sequencia		= nr_seq_origem_w(i);
		commit;

		nr_sequencia_w.delete;
		nr_seq_origem_w.delete;
		vl_orig_proc_w.delete;
		vl_orig_custo_oper_w.delete;
	end loop;
	close c_desc_item_proc;
	
	open c_desc_item_mat;
	loop
	fetch c_desc_item_mat bulk collect into
		nr_sequencia_w,
		nr_seq_origem_w,
		vl_original_w limit 1000;
	exit when nr_sequencia_w.count = 0;

		forall i in nr_sequencia_w.first..nr_sequencia_w.last
			update 	material_atend_paciente
			set 	vl_material		= vl_material + vl_original_w(i),
				vl_unitario		= (vl_material + vl_original_w(i)) / qt_material,
				ie_valor_informado	= 'N'
			where 	nr_sequencia		= nr_seq_origem_w(i);
		commit;

		nr_sequencia_w.delete;
		nr_seq_origem_w.delete;
		vl_original_w.delete;
	end loop;
	close c_desc_item_mat;


	DELETE FROM CONTA_PACIENTE_DESC_ITEM
	WHERE	NR_SEQ_DESCONTO     = nr_seq_desc_w;

	DELETE FROM CONTA_PACIENTE_DESCONTO
	WHERE	NR_INTERNO_CONTA    = nr_interno_conta_p;

	DELETE FROM PROCEDIMENTO_PACIENTE
	WHERE	NR_INTERNO_CONTA    = nr_conta_destino_w;

	delete from material_atend_paciente
	where	nr_interno_conta    = nr_conta_destino_w;

	UPDATE	CONTA_PAC_DEDUCAO_CONV
	SET	NR_SEQ_CONTA_DES     = NULL
	WHERE	NR_SEQ_CONTA_ORIG   = nr_interno_conta_p;

	UPDATE	CONTA_PAC_DEDUCAO_CONV
	SET	NR_SEQ_CONTA_ORIG    = NULL
	WHERE	NR_SEQ_CONTA_DES    = nr_conta_destino_w;

	DELETE FROM CONTA_PACIENTE
	WHERE	NR_INTERNO_CONTA    = nr_conta_destino_w;

	UPDATE	CONTA_PAC_DEDUCAO_CONV
	SET	DT_PROCESSAMENTO     = NULL,
		NR_SEQ_CONTA_DES     = NULL
	WHERE	NR_SEQ_CONTA_ORIG   = nr_interno_conta_p;
END IF;

COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE processar_conta_col ( nr_interno_conta_p CONTA_PACIENTE.NR_INTERNO_CONTA%type, nm_usuario_p CONTA_PACIENTE.NM_USUARIO%type, processamento_p CONTA_PACIENTE.IE_COMPLEXIDADE%type DEFAULT 'D') FROM PUBLIC;

