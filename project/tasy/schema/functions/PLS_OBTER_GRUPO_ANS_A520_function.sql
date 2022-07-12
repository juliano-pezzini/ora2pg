-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_grupo_ans_a520 ( nr_seq_ptu_aviso_conta_p bigint, ie_proc_mat_p text, cd_procedimento_p ptu_aviso_procedimento.cd_proc_envio%type, cd_mat_envio_p ptu_aviso_material.cd_mat_envio%type, cd_tabela_p text) RETURNS bigint AS $body$
DECLARE

					
ie_origem_proced_w		bigint;
cd_area_procedimento_w		bigint;
cd_especialidade_w		bigint;
cd_grupo_proc_w			bigint;
cd_cpf_executante_w		ptu_aviso_conta.cd_cpf_executante%type;
ie_tipo_atendimento_w		ptu_aviso_conta.ie_tipo_atendimento%type;
ie_tipo_guia_w			ptu_aviso_protocolo.ie_tipo_guia%type;
ie_regime_internacao_w		ptu_aviso_conta.ie_regime_internacao%type;
nr_seq_conselho_w		pessoa_fisica.nr_seq_conselho%type;
nr_seq_tipo_atendimento_w	bigint;
nr_seq_material_w		pls_material.nr_sequencia%type;
ie_tipo_desp_mat_w		pls_material.ie_tipo_despesa%type;
nr_seq_grupo_ans_ww		bigint	:= 0;
ie_liberado_w			varchar(10);
ds_ordem_w			varchar(2);
nr_seq_grupo_regra_w		bigint	:= null;
nr_seq_grupo_ans_w		bigint	:= null;
qt_reg_desp_proc_w		integer	:= 0;
qt_regra_w			bigint;
qt_reg_desp_mat_w		integer	:= 0;
qt_reg_desp_regra_w		integer	:= 0;

C00 CURSOR(	nr_seq_grupo_ans_pc		ans_grupo_desp_regra.nr_seq_grupo_ans%type,
		nr_seq_conselho_pc		ans_grupo_desp_regra.nr_seq_conselho%type,
		nr_seq_tipo_atendimento_pc	ans_grupo_desp_regra.nr_seq_tipo_atendimento%type,
		ie_tipo_guia_pc			ans_grupo_desp_regra.ie_tipo_guia%type,
		ie_regime_internacao_pc		ans_grupo_desp_regra.ie_regime_internacao%type) FOR
	SELECT	nr_seq_grupo_ans
	from	ans_grupo_desp_regra
	where	nr_seq_grupo_ans		= nr_seq_grupo_ans_pc
	and  	ie_tipo_protocolo		= 'I'
	and	((coalesce(nr_seq_conselho::text, '') = '') or (nr_seq_conselho 		= nr_seq_conselho_pc))
	and	((coalesce(nr_seq_tipo_atendimento::text, '') = '') or (nr_seq_tipo_atendimento 	= nr_seq_tipo_atendimento_pc))
	and	((coalesce(ie_tipo_guia::text, '') = '') or (ie_tipo_guia 		= ie_tipo_guia_pc))
	and	((coalesce(ie_regime_internacao::text, '') = '') or (ie_regime_internacao 	= ie_regime_internacao_pc))
	and	coalesce(nr_seq_tipo_atend_princ::text, '') = ''
	and	coalesce(ie_tipo_guia_princ::text, '') = ''
	order by coalesce(nr_seq_tipo_atendimento,-1);
	
C01 CURSOR(	nr_seq_grupo_ans_pc	ans_grupo_desp_proc.nr_seq_grupo_ans%type,
		cd_procedimento_pc	ans_grupo_desp_proc.cd_procedimento%type,
		ie_origem_proced_pc	ans_grupo_desp_proc.ie_origem_proced%type,
		cd_grupo_proc_pc	ans_grupo_desp_proc.cd_grupo_proc%type,
		cd_especialidade_pc	ans_grupo_desp_proc.cd_especialidade%type,
		cd_area_procedimento_pc	ans_grupo_desp_proc.cd_area_procedimento%type) FOR
	SELECT	/*+ USE_CONCAT */ nr_seq_grupo_ans,
		ie_liberado ie_liberado,
		1 ds_ordem
	from	ans_grupo_desp_proc
	where	nr_seq_grupo_ans	= nr_seq_grupo_ans_pc
	and	cd_procedimento  	= cd_procedimento_pc
	and	ie_origem_proced 	= ie_origem_proced_pc
	and	coalesce(cd_grupo_proc::text, '') = ''
	and	coalesce(cd_especialidade::text, '') = ''
	and	coalesce(cd_area_procedimento::text, '') = ''
	
union all

	SELECT	/*+ USE_CONCAT */ nr_seq_grupo_ans,
		ie_liberado ie_liberado,
		2 ds_ordem
	from	ans_grupo_desp_proc
	where	nr_seq_grupo_ans	= nr_seq_grupo_ans_pc
	and	coalesce(cd_procedimento::text, '') = ''
	and	cd_grupo_proc		= cd_grupo_proc_pc
	and	coalesce(cd_especialidade::text, '') = ''
	and	coalesce(cd_area_procedimento::text, '') = ''
	
union all

	select	/*+ USE_CONCAT */ nr_seq_grupo_ans,
		ie_liberado ie_liberado,
		3 ds_ordem
	from	ans_grupo_desp_proc
	where	nr_seq_grupo_ans	= nr_seq_grupo_ans_pc
	and	coalesce(cd_procedimento::text, '') = ''
	and	coalesce(cd_grupo_proc::text, '') = ''
	and	cd_especialidade	= cd_especialidade_pc
	and	coalesce(cd_area_procedimento::text, '') = ''
	
union all

	select	/*+ USE_CONCAT */ nr_seq_grupo_ans,
		ie_liberado ie_liberado,
		4 ds_ordem
	from	ans_grupo_desp_proc
	where	nr_seq_grupo_ans	= nr_seq_grupo_ans_pc
	and	coalesce(cd_procedimento::text, '') = ''
	and	coalesce(cd_grupo_proc::text, '') = ''
	and	coalesce(cd_especialidade::text, '') = ''
	and	cd_area_procedimento	= cd_area_procedimento_pc
	
union 	all

	select	/*+ USE_CONCAT */ nr_seq_grupo_ans,
		ie_liberado ie_liberado,
		5 ds_ordem
	from	ans_grupo_desp_proc
	where	nr_seq_grupo_ans	= nr_seq_grupo_ans_pc
	and	coalesce(cd_procedimento::text, '') = ''
	and	coalesce(cd_grupo_proc::text, '') = ''
	and	coalesce(cd_especialidade::text, '') = ''
	and	coalesce(cd_area_procedimento::text, '') = ''
	order by ds_ordem;
	
C02 CURSOR(	ie_tipo_desp_mat_pc	ans_grupo_desp_mat.ie_tipo_despesa%type) FOR
	SELECT	/*+ USE_CONCAT */ a.nr_sequencia nr_seq_grupo_ans,
		ie_liberado ie_liberado
	from	ans_grupo_desp_mat	b,
		ans_grupo_despesa 	a
	where	a.nr_sequencia		= nr_seq_grupo_desp
	and	a.ie_situacao		= 'A'
	and	a.cd_estabelecimento	= coalesce(wheb_usuario_pck.get_cd_estabelecimento,1)
	and	((coalesce(ie_tipo_despesa::text, '') = '') or (ie_tipo_despesa = ie_tipo_desp_mat_pc))
	order by coalesce(a.nr_seq_apresentacao,0),
		coalesce(ie_tipo_despesa,'0');
		
C03 CURSOR FOR
	SELECT	nr_sequencia
	from	ans_grupo_despesa	
	where	cd_estabelecimento	= coalesce(wheb_usuario_pck.get_cd_estabelecimento,1)
	and	ie_situacao		= 'A'
	order by coalesce(nr_seq_apresentacao,0),
		nr_sequencia;
		
BEGIN

select	b.cd_cpf_executante,
	b.ie_tipo_atendimento,
	a.ie_tipo_guia,
	b.ie_regime_internacao
into STRICT	cd_cpf_executante_w,
	ie_tipo_atendimento_w,
	ie_tipo_guia_w,
	ie_regime_internacao_w
from	ptu_aviso_conta		b,
	ptu_aviso_protocolo	a
where	a.nr_sequencia		= b.nr_seq_aviso_protocolo
and	b.nr_sequencia		= nr_seq_ptu_aviso_conta_p;

select	max(a.nr_seq_conselho)
into STRICT	nr_seq_conselho_w
from	medico			b,
	pessoa_fisica		a
where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
and	b.cd_pessoa_fisica	= 	(SELECT	max(x.cd_pessoa_fisica)
					from	pessoa_fisica	x
					where	x.nr_cpf = cd_cpf_executante_w);

nr_seq_tipo_atendimento_w	:= pls_obter_tipo_atend_tiss(ie_tipo_atendimento_w, coalesce(wheb_usuario_pck.get_cd_estabelecimento,1));

if (ie_proc_mat_p = 'P') then
	select	CASE WHEN cd_tabela_p='22', 8, null) -- '00' (Tabela propria das operadoras) THEN  4(Proprio) WHEN cd_tabela_p='22' (TUSS procedimentos e eventos em saude) THEN  8(TUSS)	into STRICT	ie_origem_proced_w	;		SELECT * FROM pls_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_w, cd_area_procedimento_w, cd_especialidade_w, cd_grupo_proc_w, ie_origem_proced_w) INTO STRICT cd_area_procedimento_w, cd_especialidade_w, cd_grupo_proc_w, ie_origem_proced_w;	elsif (ie_proc_mat_p = 'M') and (cd_mat_envio_p IS NOT NULL AND cd_mat_envio_p::text <> '') and (cd_tabela_p IS NOT NULL AND cd_tabela_p::text <> '') then	select	max(nr_sequencia)	into STRICT	nr_seq_material_w	from	pls_material	where	cd_material_ops = cd_mat_envio_p	and	CASE WHEN ie_tipo_despesa='1' THEN '18' WHEN ie_tipo_despesa='2' THEN '20' WHEN ie_tipo_despesa='3' THEN '19' WHEN ie_tipo_despesa='7' THEN '19'  ELSE '00' END  = cd_tabela_p;	-- 1 (Gases medicinais), 18 (TUSS - diarias, taxas e gases medicinais), 2 (Medicamentos), 20 (TUSS - medicamentos), 3 (Materiais), 19 (TUSS - materiais e OPME), 7 (OPM), 19 (TUSS - materiais e OPME), 00 (Tabela propria das operadoras)
		if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then		select	ie_tipo_despesa		into STRICT	ie_tipo_desp_mat_w		from	pls_material		where	nr_sequencia = nr_seq_material_w;	end if;end if;if (coalesce(cd_procedimento_p,0) > 0) or ((coalesce(ie_tipo_desp_mat_w::text, '') = '') and (coalesce(cd_procedimento_p::text, '') = '')) then		for r_c03_w in C03 loop		for r_c01_w in C01(r_c03_w.nr_sequencia, cd_procedimento_p, ie_origem_proced_w, cd_grupo_proc_w, cd_especialidade_w, cd_area_procedimento_w) loop			nr_seq_grupo_ans_ww	:= r_c01_w.nr_seq_grupo_ans;			ie_liberado_w		:= r_c01_w.ie_liberado;			ds_ordem_w		:= r_c01_w.ds_ordem;						nr_seq_grupo_regra_w	:= null;			for r_c00_w in C00(nr_seq_grupo_ans_ww, nr_seq_conselho_w, nr_seq_tipo_atendimento_w, ie_tipo_guia_w, ie_regime_internacao_w) loop				nr_seq_grupo_regra_w := r_c00_w.nr_seq_grupo_ans;			end loop;						if (nr_seq_grupo_regra_w IS NOT NULL AND nr_seq_grupo_regra_w::text <> '') and (ie_liberado_w = 'S') then				nr_seq_grupo_ans_w	:= nr_seq_grupo_ans_ww;				exit;							elsif (nr_seq_grupo_regra_w IS NOT NULL AND nr_seq_grupo_regra_w::text <> '') and (ie_liberado_w = 'N') then				nr_seq_grupo_ans_w	:= null;				exit;			end if;		end loop;				if (nr_seq_grupo_ans_w IS NOT NULL AND nr_seq_grupo_ans_w::text <> '') then			exit;		end if;	end loop;		select	count(1)	into STRICT	qt_reg_desp_proc_w	from	ans_grupo_desp_proc	where	nr_seq_grupo_ans = nr_seq_grupo_ans_w;	elsif (coalesce(ie_tipo_desp_mat_w,'X') <> 'X') then	for r_c02_w in c02(ie_tipo_desp_mat_w) loop		nr_seq_grupo_ans_ww	:= r_c02_w.nr_seq_grupo_ans;		ie_liberado_w		:= r_c02_w.ie_liberado;				if (ie_liberado_w		= 'S') then			nr_seq_grupo_ans_ww	:= r_c02_w.nr_seq_grupo_ans;		elsif (ie_liberado_w		= 'N') then			nr_seq_grupo_ans_ww	:= null;		end if;				nr_seq_grupo_regra_w	:= null;		for r_c00_w in C00(nr_seq_grupo_ans_ww, nr_seq_conselho_w, nr_seq_tipo_atendimento_w, ie_tipo_guia_w, ie_regime_internacao_w) loop			nr_seq_grupo_regra_w := r_c00_w.nr_seq_grupo_ans;		end loop;				if (nr_seq_grupo_regra_w IS NOT NULL AND nr_seq_grupo_regra_w::text <> '') then			nr_seq_grupo_ans_w	:= nr_seq_grupo_ans_ww;			exit;		else			select	count(1)			into STRICT	qt_regra_w			from	ans_grupo_desp_regra			where	nr_seq_grupo_ans = nr_seq_grupo_ans_ww;						if (qt_regra_w = 0) then				nr_seq_grupo_ans_w	:= nr_seq_grupo_ans_ww;				exit;			else				nr_seq_grupo_ans_w	:= null;			end if;		end if;	end loop;		select	count(1)	into STRICT	qt_reg_desp_mat_w	from	ans_grupo_desp_mat	where	nr_seq_grupo_desp = nr_seq_grupo_ans_w;end if;select	count(1)into	qt_reg_desp_regra_wfrom	ans_grupo_desp_regrawhere	nr_seq_grupo_ans = nr_seq_grupo_ans_w;if (qt_reg_desp_proc_w = 0) and (qt_reg_desp_regra_w = 0) and (qt_reg_desp_mat_w = 0) then	nr_seq_grupo_ans_w	:= null;end if;return	nr_seq_grupo_ans_w;end; END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_grupo_ans_a520 ( nr_seq_ptu_aviso_conta_p bigint, ie_proc_mat_p text, cd_procedimento_p ptu_aviso_procedimento.cd_proc_envio%type, cd_mat_envio_p ptu_aviso_material.cd_mat_envio%type, cd_tabela_p text) FROM PUBLIC;
