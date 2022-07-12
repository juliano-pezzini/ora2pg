-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hgal_obter_valor_rel_conta ( nr_interno_conta_p bigint, nr_seq_propaci_p bigint, nr_seq_matpaci_p bigint, ie_emite_conta_p text, ie_tipo_valor_p text) RETURNS bigint AS $body$
DECLARE


cd_item_w			bigint;
ie_status_acerto_w		bigint;
ds_item_w			varchar(300);
ie_origem_proced_w		bigint;
qt_item_w			double precision;
ie_valor_informado_w 		varchar(1);
cd_procedimento_w		bigint;
vl_item_w			double precision;
vl_medico_w			double precision;
ie_classificacao_w		varchar(1);
nr_seq_matproc_w		bigint;
ie_emite_conta_w		varchar(3);
vl_custo_oper_w			double precision;
dt_item_w			timestamp;
cd_setor_atend_w		bigint;
cd_medic_exec_w			bigint;
ie_tipo_registro_w		varchar(1);
cd_convenio_w			bigint;
vl_preco_unitario_w		double precision;
vl_acresc_tab_w			double precision;
vl_acresc_tab_uni_w 		double precision;
vl_desconto_conta_w		double precision;
vl_desconto_tab_w		double precision;
vl_subtotal_w			double precision;
vl_preco_unitario_cal_w		double precision;
vl_preco_total_w		double precision;
vl_imposto_w			double precision;
vl_indice_w			double precision;
vl_material_w			double precision;
vl_material_tab_w		double precision;
vl_proced_tab_w			double precision;
vl_total_desconto_w 		double precision := 0;
vl_total_acresc_w		double precision := 0;
vl_retorno_w			double precision;
cd_tipo_procedimento_w		bigint;
nr_seq_proc_pacote_w		bigint;
nr_atendimento_w		bigint;

vl_coaseguro_hosp_w		double precision := 0;
vl_coaseguro_honor_w		double precision := 0;
vl_coaseguro_nivel_hosp_w	double precision := 0;
vl_deducible_w			double precision := 0;

ie_tipo_calculo_w		conv_regra_calculo_conta.ie_tipo_calculo%type;
pr_imposto_w			conv_regra_calculo_conta.pr_imposto%type;
pr_imposto_coaseg_hosp_w	conv_regra_calculo_conta.pr_imposto%type;
pr_imposto_coaseg_honor_w	conv_regra_calculo_conta.pr_imposto%type;
pr_imposto_coaseg_nivel_hosp_w	conv_regra_calculo_conta.pr_imposto%type;
pr_imposto_deducible_w		conv_regra_calculo_conta.pr_imposto%type;
cd_proc_calculo_w		conv_regra_calculo_conta.cd_proc_calculo%type;
ie_orig_proc_calculo_w		conv_regra_calculo_conta.ie_orig_proc_calculo%type;

nr_seq_proc_w			procedimento_paciente.nr_sequencia%type;

vl_total_item_w			double precision	:= 0;
vl_total_item_imposto_w		double precision	:= 0;
vl_total_conta_w		double precision	:= 0;
vl_coaseg_deduc_w		double precision	:= 0;
vl_coaseg_deduc_imp_w		double precision	:= 0;
vl_total_coaseg_deduc_w		double precision	:= 0;

vl_base_sem_imposto_w		double precision	:= 0;
vl_base_com_imposto_w		double precision	:= 0;
vl_total_imposto_w		double precision	:= 0;
vl_total_conta_imposto_w	double precision	:= 0;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;

/*
ie_tipo_valor_p

D - Desconto do item
I - Incremento no item (Geralmente asseguradoras internacionais)
DT - Desconto total (Descontos + coaseguro y deducible)
DC - Deducible y coaseguro
*/
C01 CURSOR FOR
SELECT
	'P',
	b.cd_procedimento,
	b.ie_origem_proced,
	coalesce(b.qt_procedimento,0),
	b.ie_valor_informado,
	b.vl_procedimento,
	b.vl_medico,
	p.ie_classificacao,
	b.nr_sequencia,
	b.ie_emite_conta,
	vl_custo_operacional,
	b.dt_procedimento,
	b.cd_setor_atendimento,
	CASE WHEN p.cd_tipo_procedimento=135 THEN cd_medico_executor  ELSE NULL END ,
	0
FROM	conta_paciente a,
	procedimento_paciente b,
	procedimento p
WHERE	b.nr_interno_conta = a.nr_interno_conta
AND	b.cd_procedimento = p.cd_procedimento
AND	b.ie_origem_proced = p.ie_origem_proced
and	a.nr_interno_conta = nr_interno_conta_p
AND (b.nr_sequencia = coalesce(nr_seq_propaci_p,nr_sequencia))	--------- PROCEDIMENTOS
AND (ie_emite_conta = coalesce(ie_emite_conta_p,ie_emite_conta))
and	coalesce(nr_seq_matpaci_p::text, '') = ''
AND	((coalesce(b.nr_seq_proc_pacote::text, '') = '')
OR	 (b.nr_sequencia = (	SELECT 	z.nr_seq_procedimento
				FROM 	atendimento_pacote z
				WHERE  	z.nr_seq_procedimento = b.nr_sequencia
				AND  	z.nr_atendimento = nr_atendimento_w)
AND (b.nr_seq_proc_pacote IS NOT NULL AND b.nr_seq_proc_pacote::text <> '')))
and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
and	not exists (	select	1
			from	conv_regra_calculo_conta y
			where	y.cd_convenio = coalesce(a.cd_convenio_calculo, a.cd_convenio_parametro)
			and	y.ie_situacao = 'A'
			and	y.cd_proc_calculo = b.cd_procedimento
			and	y.ie_orig_proc_calculo = b.ie_origem_proced)

UNION ALL

SELECT
	'M',
	b.cd_material,
	NULL,
	coalesce(b.qt_material,0) qt_item,
	b.ie_valor_informado,
	b.vl_unitario,
	0,
	NULL,
	b.nr_sequencia,
	b.ie_emite_conta,
	0,
	b.dt_atendimento dt_item,
	b.cd_setor_atendimento,
	NULL cd_medico_executor,
	vl_material
FROM	conta_paciente a,
	material_atend_paciente b
WHERE	a.nr_interno_conta = nr_interno_conta_p
AND (b.nr_sequencia = coalesce(nr_seq_matpaci_p,b.nr_sequencia))	--------- MATERIAIS
AND (ie_emite_conta = coalesce(ie_emite_conta_p,ie_emite_conta))
and	coalesce(nr_seq_propaci_p::text, '') = ''
AND	coalesce(b.nr_seq_proc_pacote::text, '') = ''
and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
AND	b.nr_interno_conta = a.nr_interno_conta;

C02 CURSOR FOR
	SELECT	ie_tipo_calculo,
		pr_imposto,
		cd_proc_calculo,
		ie_orig_proc_calculo
	from	conv_regra_calculo_conta
	where	cd_convenio = cd_convenio_w
	and	cd_estabelecimento = cd_estabelecimento_w
	and	ie_situacao = 'A';


BEGIN


select  ie_status_acerto,
	cd_convenio_parametro,
	nr_atendimento,
	cd_estabelecimento
into STRICT	ie_status_acerto_w,
	cd_convenio_w,
	nr_atendimento_w,
	cd_estabelecimento_w
from	conta_paciente
where	nr_interno_conta = nr_interno_conta_p;

select	coalesce(a.vl_base_sem_imposto,0) vl_base_sem_imposto,
	coalesce(b.vl_base_com_imposto,0) vl_base_com_imposto,
	coalesce(c.vl_imposto,0) vl_imposto,
	coalesce(a.vl_base_sem_imposto + b.vl_base_com_imposto + c.vl_imposto,0) vl_total,
	coalesce(a.vl_base_sem_imposto + b.vl_base_com_imposto,0) vl_total_conta
into STRICT	vl_base_sem_imposto_w,
	vl_base_com_imposto_w,
	vl_total_imposto_w,
	vl_total_conta_imposto_w,
	vl_total_conta_w
from	(SELECT (coalesce(a.vl_procedimento,0) + coalesce(b.vl_material,0)) vl_base_sem_imposto
	from (select	sum(coalesce(vl_procedimento,0)) vl_procedimento
		from	procedimento_paciente a
		where	a.nr_interno_conta = nr_interno_conta_p
		and	coalesce(a.nr_seq_proc_pacote::text, '') = ''
		and	not exists (	select	1
				from	propaci_imposto x
				where	x.nr_seq_propaci = a.nr_sequencia
				and	x.pr_imposto > 0)) a,
		(select	sum(coalesce(vl_material,0)) vl_material
		from	material_atend_paciente a
		where	a.nr_interno_conta = nr_interno_conta_p
		and	coalesce(a.nr_seq_proc_pacote::text, '') = ''
		and	not exists (	select	1
				from	matpaci_imposto x
				where	x.nr_seq_matpaci = a.nr_sequencia
				and	x.pr_imposto > 0)) b) a,
	(select (coalesce(a.vl_procedimento,0) + coalesce(b.vl_material,0)) vl_base_com_imposto
	from (select	sum(coalesce(vl_procedimento,0)) vl_procedimento
		from	procedimento_paciente x
		where	x.nr_interno_conta = nr_interno_conta_p
		and	exists (	select	1
				from	propaci_imposto y
				where	y.nr_seq_propaci = x.nr_sequencia
				and	y.pr_imposto > 0)) a,
		(select	sum(coalesce(vl_material,0)) vl_material
		from	material_atend_paciente x
		where	x.nr_interno_conta = nr_interno_conta_p
		and	exists (	select	1
				from	matpaci_imposto y
				where	y.nr_seq_matpaci = x.nr_sequencia
				and	y.pr_imposto > 0)) b) b,
	(select (coalesce(a.vl_imposto,0) + coalesce(b.vl_imposto,0)) vl_imposto
	from (select	sum(coalesce(vl_imposto,0)) vl_imposto
		from	procedimento_paciente x,
			propaci_imposto y
		where	x.nr_interno_conta = nr_interno_conta_p
		and	y.nr_seq_propaci = x.nr_sequencia) a,
		(select	sum(coalesce(vl_imposto,0)) vl_imposto
		from	material_atend_paciente x,
			matpaci_imposto y
		where	x.nr_interno_conta = nr_interno_conta_p
		and	y.nr_seq_matpaci = x.nr_sequencia) b) c;


open C02;
loop
fetch C02 into
	ie_tipo_calculo_w,
	pr_imposto_w,
	cd_proc_calculo_w,
	ie_orig_proc_calculo_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin

	begin
	if (ie_tipo_calculo_w = 'D') then

		pr_imposto_deducible_w	:= pr_imposto_w;

		select	vl_procedimento,
			nr_sequencia
		into STRICT	vl_deducible_w,
			nr_seq_proc_w
		from	procedimento_paciente
		where	cd_procedimento = cd_proc_calculo_w
		and	ie_origem_proced = ie_orig_proc_calculo_w
		and	nr_interno_conta = nr_interno_conta_p;

	elsif (ie_tipo_calculo_w = 'H') then

		pr_imposto_coaseg_hosp_w	:= pr_imposto_w;

		select	vl_procedimento,
			nr_sequencia
		into STRICT	vl_coaseguro_hosp_w,
			nr_seq_proc_w
		from	procedimento_paciente
		where	cd_procedimento = cd_proc_calculo_w
		and	ie_origem_proced = ie_orig_proc_calculo_w
		and	nr_interno_conta = nr_interno_conta_p;

	elsif (ie_tipo_calculo_w = 'N') then

		pr_imposto_coaseg_honor_w	:= pr_imposto_w;

		select	vl_procedimento,
			nr_sequencia
		into STRICT	vl_coaseguro_honor_w,
			nr_seq_proc_w
		from	procedimento_paciente
		where	cd_procedimento = cd_proc_calculo_w
		and	ie_origem_proced = ie_orig_proc_calculo_w
		and	nr_interno_conta = nr_interno_conta_p;

	elsif (ie_tipo_calculo_w = 'A') then

		pr_imposto_coaseg_nivel_hosp_w	:= pr_imposto_w;

		select	vl_procedimento,
			nr_sequencia
		into STRICT	vl_coaseguro_nivel_hosp_w,
			nr_seq_proc_w
		from	procedimento_paciente
		where	cd_procedimento = cd_proc_calculo_w
		and	ie_origem_proced = ie_orig_proc_calculo_w
		and	nr_interno_conta = nr_interno_conta_p;

	end if;
	exception
		when others then
		ie_tipo_calculo_w	:= null;
	end;

	end;
end loop;
close C02;

OPEN C01;
LOOP
FETCH C01 INTO
	ie_tipo_registro_w,
	cd_item_w,
	ie_origem_proced_w,
	qt_item_w,
	ie_valor_informado_w,
	vl_item_w,
	vl_medico_w,
	ie_classificacao_w,
	nr_seq_matproc_w,
	ie_emite_conta_w,
	vl_custo_oper_w,
	dt_item_w,
	cd_setor_atend_w,
	cd_medic_exec_w,
	vl_material_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	BEGIN
		vl_desconto_tab_w := 0;
		vl_indice_w := 0;
		vl_preco_unitario_w := 0;
		vl_desconto_conta_w := 0;
		vl_acresc_tab_w := 0;
		vl_preco_unitario_cal_w := 0;
		vl_subtotal_w := 0;
		vl_material_tab_w := 0;
		vl_proced_tab_w	:= 0;
		vl_preco_total_w := 0;
		vl_imposto_w := 0;
		--vl_total_desconto_w := 0;
		-- descrição do item
		IF (ie_tipo_registro_w = 'P') THEN
			ds_item_w := SUBSTR(obter_desc_procedimento(cd_item_w,ie_origem_proced_w),1,255);
			vl_desconto_conta_w := obter_desconto_matproc(nr_seq_matproc_w,'P');

			IF (ie_classificacao_w = 1) THEN
				vl_indice_w	  := coalesce(obter_indice_preco_proc(nr_seq_matproc_w),1);
			ELSE
				vl_indice_w	  := coalesce(obter_indice_preco_servico(nr_seq_matproc_w),1);
			END IF;

			vl_proced_tab_w := (vl_item_w + vl_desconto_conta_w) / vl_indice_w;
			vl_subtotal_w	:= vl_item_w;

			--calculo do valor unitario
			IF (ie_valor_informado_w  = 'N')  THEN
				IF coalesce(vl_item_w,0) <> 0 THEN
					vl_preco_unitario_w := coalesce(vl_item_w,0) / qt_item_w;
				ELSE
					vl_preco_unitario_w := coalesce(vl_medico_w,0) / qt_item_w;
				END IF;

				IF (vl_indice_w > 0)THEN
					BEGIN
					vl_preco_unitario_w := ABS(vl_preco_unitario_w / vl_indice_w);
					EXCEPTION
					WHEN OTHERS THEN
						CALL Wheb_mensagem_pck.exibir_mensagem_abort('Hay items sin regla de precio o el item no esta en la tabla de precio para esta aseguradora');
					END;
				END IF;

				IF (vl_indice_w < 1) THEN
					vl_desconto_tab_w	:= vl_proced_tab_w * (1 - vl_indice_w);
				ELSE
					vl_acresc_tab_w		:= (vl_proced_tab_w * (vl_indice_w - 1));

				END IF;

				vl_preco_unitario_w := vl_preco_unitario_w;

			ELSE
				IF coalesce(vl_item_w ,0) <> 0 THEN
					vl_preco_unitario_w := vl_item_w;
				ELSIF coalesce(vl_medico_w ,0) <> 0 THEN
					vl_preco_unitario_w := vl_item_w;
				ELSE
					vl_preco_unitario_w := vl_custo_oper_w;
				END IF;
				vl_preco_unitario_w := vl_preco_unitario_w + vl_desconto_conta_w;

				IF (vl_indice_w = 0) THEN
					vl_desconto_tab_w := 0;
				ELSE
					IF (vl_desconto_conta_w > 0) THEN
						IF (vl_indice_w < 1) AND (vl_indice_w > 0) THEN
							vl_preco_unitario_cal_w := ABS(vl_preco_unitario_w / vl_indice_w);
							vl_desconto_tab_w	:= vl_preco_unitario_cal_w * (1 - vl_indice_w);
						ELSE
							--vl_preco_unitario_cal_w := abs(vl_preco_unitario_w / vl_indice_w);
							vl_acresc_tab_w		:= vl_preco_unitario_cal_w * (vl_indice_w - 1);
						END IF;
					END IF;
				END IF;

				--vl_preco_unitario_w := vl_preco_unitario_w + vl_desconto_tab_w + vl_desconto_conta_w;
				vl_preco_unitario_w := vl_preco_unitario_w + vl_desconto_tab_w;

			END IF;

			SELECT 	coalesce(SUM(x.vl_imposto),0)
			INTO STRICT	vl_imposto_w
			FROM 	propaci_imposto x
			WHERE 	x.nr_seq_propaci = nr_seq_matproc_w;

			vl_preco_total_w := vl_imposto_w + vl_subtotal_w;

			vl_total_item_w	:= vl_total_item_w + coalesce(vl_item_w,0);

		ELSE
			ds_item_w   := SUBSTR(obter_desc_material(cd_item_w),1,255);
			vl_desconto_conta_w := obter_desconto_matproc(nr_seq_matproc_w,'M');
			vl_indice_w := (coalesce(obter_indice_preco_material_2(nr_seq_matproc_w),1));
			vl_material_tab_w := (vl_material_w + vl_desconto_conta_w) / vl_indice_w;
			vl_subtotal_w := vl_material_w;

			IF (ie_valor_informado_w  IN ('N'))  THEN
				vl_preco_unitario_w := ABS(vl_item_w / vl_indice_w);
				IF (vl_indice_w < 1) THEN
					vl_desconto_tab_w := vl_material_tab_w * (1 - vl_indice_w);
				ELSE
					vl_acresc_tab_w := vl_material_tab_w * (vl_indice_w - 1);
				END IF;
				vl_acresc_tab_uni_w := vl_acresc_tab_w / qt_item_w;
				vl_preco_unitario_w := vl_preco_unitario_w + vl_acresc_tab_uni_w;

			ELSE
				IF (vl_indice_w = 0) THEN
					vl_desconto_tab_w := 0;
				ELSE
					IF (vl_desconto_conta_w > 0) THEN
						vl_preco_unitario_w := ABS(vl_item_w / vl_indice_w);
						--vl_material_tab_w := vl_material_tab_w + vl_desconto_conta_w;
						IF (vl_indice_w < 1) THEN
							vl_desconto_tab_w := vl_material_tab_w * (1 - vl_indice_w);
						ELSE
							vl_acresc_tab_w := vl_material_tab_w * (vl_indice_w - 1);
						END IF;
						vl_acresc_tab_uni_w := vl_acresc_tab_w / qt_item_w;
						vl_preco_unitario_w := vl_preco_unitario_w + vl_acresc_tab_uni_w;
					ELSE
						vl_preco_unitario_w := vl_item_w;
					END IF;
				END IF;
			END IF;

			SELECT 	coalesce(SUM(x.vl_imposto),0)
			INTO STRICT	vl_imposto_w
			FROM 	matpaci_imposto x
			WHERE	x.nr_seq_matpaci = nr_seq_matproc_w;

			vl_preco_total_w := vl_subtotal_w + vl_imposto_w;

			vl_total_item_w	:= vl_total_item_w + coalesce(vl_material_w,0);

			--calculo do valor unitario
		END IF;
	END;

	vl_total_desconto_w	:= vl_total_desconto_w + vl_desconto_tab_w + vl_desconto_conta_w;
	vl_total_acresc_w 	:= vl_total_acresc_w + vl_acresc_tab_w;

END LOOP;
CLOSE C01;

vl_coaseg_deduc_w	:= coalesce(vl_coaseguro_hosp_w,0) + coalesce(vl_deducible_w,0) + coalesce(vl_coaseguro_honor_w,0) + coalesce(vl_coaseguro_nivel_hosp_w,0);

if (coalesce(vl_coaseg_deduc_w,0) <> 0) then
	vl_total_coaseg_deduc_w	:= round((dividir(coalesce(vl_coaseg_deduc_w,0) * coalesce(vl_total_item_w,0), vl_total_conta_w - vl_coaseg_deduc_w))::numeric,2);
end if;

if (ie_tipo_valor_p = 'D') then
	vl_retorno_w	:= vl_total_desconto_w;
elsif (ie_tipo_valor_p = 'I') then
	vl_retorno_w	:= vl_total_acresc_w;
elsif (ie_tipo_valor_p = 'DT') then
	vl_retorno_w := vl_total_coaseg_deduc_w * -1;
	vl_retorno_w	:= vl_retorno_w + vl_total_desconto_w;
elsif (ie_tipo_valor_p = 'DC') then
	vl_retorno_w := vl_total_coaseg_deduc_w * -1;
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hgal_obter_valor_rel_conta ( nr_interno_conta_p bigint, nr_seq_propaci_p bigint, nr_seq_matpaci_p bigint, ie_emite_conta_p text, ie_tipo_valor_p text) FROM PUBLIC;
