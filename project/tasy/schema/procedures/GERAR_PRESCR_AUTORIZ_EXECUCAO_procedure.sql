-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_prescr_autoriz_execucao ( nr_atendimento_p bigint, nr_seq_interno_p bigint, nm_usuario_p text, dt_atendimento_p timestamp) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_seq_autorizacao_w		bigint;
cd_material_w			integer;
qt_material_w			double precision;
vl_material_w			double precision;
vl_unitario_w			double precision;
nr_seq_prescr_w		smallint;
cd_unidade_medida_w		varchar(30);
qt_cotacao_w			integer;
cd_cgc_w			varchar(14);
dt_entrada_unidade_w		timestamp;
cd_setor_atendimento_w	integer;
cd_convenio_w			integer;
cd_categoria_w		varchar(10);
ie_regra_mat_autorizado_w	varchar(15);
ie_consid_tipo_baixa_prescr_w	varchar(5) := 'N';
cd_tipo_baixa_prescr_w		tipo_baixa_prescricao.cd_tipo_baixa%type;
ie_atualiza_estoque_w		tipo_baixa_prescricao.ie_atualiza_estoque%type := 'N';
ie_conta_paciente_w		tipo_baixa_prescricao.ie_conta_paciente%type := 'N';
cd_local_estoque_w		setor_atendimento.cd_local_estoque%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type := wheb_usuario_pck.get_cd_estabelecimento;
ie_estoque_disp_w		varchar(1) := 'S';
cd_unidade_medida_consumo_w	material_estab.cd_unidade_medida_consumo%type;
ie_baixa_sem_estoque_w		varchar(5) := 'N';
ie_baixa_estoq_pac_w		varchar(1) := 'S';
ie_utiliza_dt_alta_w		varchar(1) := 'N';
dt_lancamento_w				timestamp := dt_atendimento_p;
C01 CURSOR FOR
	SELECT	b.nr_seq_autorizacao,
		b.cd_material,
		b.qt_material,
		b.vl_material,
		(b.vl_material / CASE WHEN b.qt_material=0 THEN 1  ELSE b.qt_material END ),
		row_number() OVER () AS rownum,
		c.cd_unidade_medida_consumo,
		b.nr_sequencia
	from	material c,
		material_autor_cirurgia b,
		autorizacao_cirurgia a
	where	a.nr_sequencia		= b.nr_seq_autorizacao
	and 	b.cd_material		= c.cd_material
	and	coalesce(b.ie_aprovacao,'S')	= 'S'
	and	a.nr_atendimento	= nr_atendimento_p
	and	coalesce(a.nr_prescricao::text, '') = ''
	and	ie_regra_mat_autorizado_w = 'E'
	and not exists (SELECT	1
					from    material_atend_paciente x
					where	x.cd_material = c.cd_material
					and		x.nr_atendimento = a.nr_atendimento
					and		x.cd_motivo_exc_conta is  null)
	
union

	select	b.nr_seq_autorizacao,
		b.cd_material,
		b.qt_autorizada,
		b.vl_unitario,
		(b.vl_unitario / CASE WHEN b.qt_autorizada=0 THEN 1  ELSE b.qt_autorizada END ), 
		row_number() OVER () AS rownum,
		c.cd_unidade_medida_consumo,
		b.nr_sequencia
	from	material c,
		material_autorizado b,
		estagio_autorizacao d, 
		autorizacao_convenio a
	where	a.nr_sequencia		= b.nr_sequencia_autor
	and 	b.cd_material		= c.cd_material
	and	a.nr_seq_estagio = d.nr_sequencia
	and	d.ie_interno = 10
	and	a.nr_atendimento	= nr_atendimento_p
	and	coalesce(a.nr_prescricao::text, '') = ''
	and	ie_regra_mat_autorizado_w = 'C'
	and not exists (select	1
					from    material_atend_paciente x
					where	x.cd_material = c.cd_material
					and		x.nr_atendimento = a.nr_atendimento
					and		x.cd_motivo_exc_conta is  null);


BEGIN

select	dt_entrada_unidade,
	cd_setor_atendimento
into STRICT	dt_entrada_unidade_w,
	cd_setor_atendimento_w
from	atend_paciente_unidade
where	nr_seq_interno		= nr_seq_interno_p;

ie_regra_mat_autorizado_w := coalesce(obter_valor_param_usuario(67, 390, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'E');

ie_baixa_sem_estoque_w 	  := coalesce(obter_valor_param_usuario(24, 13, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N');
cd_tipo_baixa_prescr_w 	  := coalesce(obter_valor_param_usuario(24, 28, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),0);
ie_consid_tipo_baixa_prescr_w := coalesce(obter_valor_param_usuario(24, 330, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N');
ie_utiliza_dt_alta_w 		:= coalesce(obter_valor_param_usuario(24, 55, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N');

if (coalesce(ie_consid_tipo_baixa_prescr_w,'N') = 'S') and (coalesce(cd_tipo_baixa_prescr_w,0) > 0) then
	
	select	max(ie_atualiza_estoque),
		max(ie_conta_paciente)
	into STRICT	ie_atualiza_estoque_w,
		ie_conta_paciente_w
	from	tipo_baixa_prescricao
	where	ie_prescricao_devolucao = 'P'
	and	cd_tipo_baixa		= cd_tipo_baixa_prescr_w;
	
	select	max(cd_local_estoque)
	into STRICT	cd_local_estoque_w
	from	setor_atendimento
	where	cd_setor_atendimento = cd_setor_atendimento_w;
	
end if;


open C01;
loop
fetch C01 into	nr_seq_autorizacao_w,
		cd_material_w,
		qt_material_w,
		vl_material_w,
		vl_unitario_w,
		nr_seq_prescr_w,
		cd_unidade_medida_w,
		nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

select	count(*),
	max(cd_cgc)
into STRICT	qt_cotacao_w, 
	cd_cgc_w
from	material_autor_cir_cot
where	nr_sequencia	= nr_sequencia_w;

if (qt_cotacao_w <> 1) then
	cd_cgc_w	:= '';
end if;

select	obter_convenio_atendimento(nr_atendimento_p)
into STRICT	cd_convenio_w
;

select min(cd_categoria)
into STRICT	cd_categoria_w
from	atend_categoria_convenio
where	nr_atendimento	= nr_atendimento_p
  and	cd_convenio		= cd_convenio_w;

if (cd_local_estoque_w IS NOT NULL AND cd_local_estoque_w::text <> '') then 
	ie_estoque_disp_w := Obter_disp_estoque(cd_material_w, cd_local_estoque_w, cd_estabelecimento_w, 0, qt_material_w, cd_cgc_w, ie_estoque_disp_w);
end if;

if (coalesce(ie_utiliza_dt_alta_w,'N') = 'S') then
	dt_lancamento_w := coalesce(obter_dados_atendimento_dt(nr_atendimento_p, 'DA'), dt_atendimento_p);
end if;

if (ie_baixa_sem_estoque_w = 'S') or (ie_atualiza_estoque_w = 'N') or (coalesce(cd_local_estoque_w::text, '') = '') or (ie_estoque_disp_w = 'S') or (ie_consid_tipo_baixa_prescr_w = 'N')then

	ie_baixa_estoq_pac_w :=  coalesce(substr(obter_se_baixa_estoque_pac(cd_setor_atendimento_w, cd_material_w,null,0),1,1),'S');

	if (ie_conta_paciente_w	= 'S') or (ie_consid_tipo_baixa_prescr_w = 'N') then

		select	nextval('material_atend_paciente_seq')
		into STRICT	nr_sequencia_w
		;

		insert into material_atend_paciente(nr_sequencia,
				nr_atendimento,
				dt_entrada_unidade,
				cd_material,
				dt_atendimento,
				dt_conta,
				cd_unidade_medida,
				qt_material,
				dt_atualizacao,
				nm_usuario,
				vl_material,
				cd_acao,
				cd_setor_atendimento,
				vl_unitario,
				ie_valor_informado,
				ie_guia_informada,
				nm_usuario_original,
				cd_material_exec,
				nr_seq_atepacu,
				ie_auditoria,	
				cd_cgc_fornecedor,
				cd_convenio,
				cd_categoria,
				cd_local_estoque)
			values (nr_sequencia_w,
				nr_atendimento_p,
				dt_entrada_unidade_w,
				cd_material_w,
				coalesce(dt_lancamento_w,clock_timestamp()),
				coalesce(dt_atendimento_p,clock_timestamp()),
				cd_unidade_medida_w,
				qt_material_w,
				clock_timestamp(),
				nm_usuario_p,
				vl_material_w,
				'1',
				cd_setor_atendimento_w,
				vl_unitario_w,
				'N',		
				'N',
				nm_usuario_p,
				cd_material_w,
				nr_seq_interno_p,
				'N',
				cd_cgc_w,
				cd_convenio_w,
				cd_categoria_w,
				CASE WHEN ie_consid_tipo_baixa_prescr_w='S' THEN cd_local_estoque_w  ELSE null END );
				
			
		if (ie_atualiza_estoque_w	= 'S') and (ie_baixa_estoq_pac_w   = 'S') and (cd_local_estoque_w IS NOT NULL AND cd_local_estoque_w::text <> '') then
			
			begin
			cd_unidade_medida_consumo_w := substr(obter_dados_material_estab(cd_material_w,cd_estabelecimento_w,'UMS'),1,30);
			exception
			when others then
				cd_unidade_medida_consumo_w := null;
			end;
			
			CALL Gerar_Prescricao_Estoque(cd_estabelecimento_w,
				nr_atendimento_p,
				dt_entrada_unidade_w,
				cd_material_w,
				clock_timestamp(),
				'1',
				cd_local_estoque_w,
				qt_material_w,
				cd_setor_atendimento_w,
				cd_unidade_medida_consumo_w,
				nm_usuario_p,
				'I',
				null, --NR_PRESCRICAO_P,
				null,
				null, --NR_SEQ_PROC_PRINC_P,
				nr_sequencia_w,
				cd_cgc_w,
				'',
				0,
				0,
				0,
				null, '','','');
		end if;
			
		CALL Atualiza_preco_material(nr_sequencia_w, nm_usuario_p);
		
	end if;
end if;
	
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_prescr_autoriz_execucao ( nr_atendimento_p bigint, nr_seq_interno_p bigint, nm_usuario_p text, dt_atendimento_p timestamp) FROM PUBLIC;
