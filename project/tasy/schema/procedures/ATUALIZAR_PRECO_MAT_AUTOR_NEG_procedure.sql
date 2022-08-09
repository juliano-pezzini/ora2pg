-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_preco_mat_autor_neg (nr_seq_material_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


dt_pedido_w			timestamp;
ie_out_number_w			bigint;
cd_material_w			integer;
qt_material_w			double precision;
vl_preco_w			double precision;
vl_negociado_w			double precision;
cd_fornecedor_w			varchar(14);
cd_cond_pagto_w			bigint;
nr_atendimento_w			bigint;
nr_seq_autorizacao_w		bigint;
cd_convenio_w			integer;
cd_categoria_w			varchar(10);
cd_subgrupo_material_w		smallint;
nr_idade_w			bigint;
nr_seq_agenda_w			autorizacao_cirurgia.nr_seq_agenda%type;
cd_estabelecimento_w		smallint;
ie_out_varchar_w			varchar(255);

cd_estab_logado_w			integer := wheb_usuario_pck.get_cd_estabelecimento;
ie_tipo_atendimento_w		atendimento_paciente.ie_tipo_atendimento%type;
cd_setor_atendimento_w		procedimento_paciente.cd_setor_atendimento%type;
dt_entrada_w			atendimento_paciente.dt_entrada%type;
cd_plano_w			atend_categoria_convenio.cd_plano_convenio%type;
ie_clinica_w			atendimento_paciente.ie_clinica%type;
cd_usuario_convenio_w		atend_categoria_convenio.cd_usuario_convenio%type;
nr_seq_classif_atend_w		atendimento_paciente.nr_seq_classificacao%type;
nr_seq_origem_w			atend_categoria_convenio.nr_seq_origem%type;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;


BEGIN

select	a.cd_material,
	CASE WHEN coalesce(a.qt_material,0)=0 THEN a.qt_solicitada  ELSE a.qt_material END  qt_material,
	a.nr_seq_autorizacao,
	b.nr_atendimento,
	b.dt_pedido,
	b.nr_seq_agenda,
	b.cd_estabelecimento
into STRICT	cd_material_w,
	qt_material_w,
	nr_seq_autorizacao_w,
	nr_atendimento_w,
	dt_pedido_w,
	nr_seq_agenda_w,
	cd_estabelecimento_w
from	material_autor_cirurgia a,
	autorizacao_cirurgia b
where	1 = 1
and 	a.nr_sequencia		= nr_seq_material_p
and	a.nr_seq_autorizacao    	= b.nr_sequencia;

if (coalesce(qt_material_w::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(179623);
end if;

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
	begin
	select	max(a.cd_convenio),
		coalesce(max(a.cd_categoria),'X'),
		max(b.ie_tipo_atendimento),
		obter_setor_atendimento(b.nr_atendimento),
		max(b.dt_entrada),
		obter_idade(c.dt_nascimento,clock_timestamp(),'A'),
		max(a.cd_plano_convenio),
		max(b.ie_clinica),
		max(a.cd_usuario_convenio),
		max(b.nr_seq_classificacao),
		max(a.nr_seq_origem)
	into STRICT	cd_convenio_w,
		cd_categoria_w,
		ie_tipo_atendimento_w,
		cd_setor_atendimento_w,
		dt_entrada_w,
		nr_idade_w,
		cd_plano_w,
		ie_clinica_w,
		cd_usuario_convenio_w,
		nr_seq_classif_atend_w,
		nr_seq_origem_w
	from	atend_categoria_convenio a,
		atendimento_paciente b,
		pessoa_fisica c
	where	a.nr_atendimento		= nr_atendimento_w
	and	c.cd_pessoa_fisica	= b.cd_pessoa_fisica
	and	b.nr_atendimento		= a.nr_atendimento
	and	a.dt_inicio_vigencia	=
			(SELECT	max(x.dt_inicio_vigencia)
			from	atend_categoria_convenio x
			where	x.nr_atendimento	= a.nr_atendimento);
	exception
	when others then
		cd_convenio_w := null;
	end;
	
elsif (nr_seq_agenda_w IS NOT NULL AND nr_seq_agenda_w::text <> '') then
	
	Select	cd_convenio,
		coalesce(cd_categoria,'X'),
		ie_tipo_atendimento,
		ie_clinica,
		cd_usuario_convenio,
		cd_plano,
		cd_pessoa_fisica
	into STRICT	cd_convenio_w,
		cd_categoria_w,
		ie_tipo_atendimento_w,
		ie_clinica_w,
		cd_usuario_convenio_w,
		cd_plano_w,
		cd_pessoa_fisica_w
	from	agenda_paciente
	where	nr_sequencia 		= nr_seq_agenda_w;

	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
		nr_idade_w := obter_idade_pf(cd_pessoa_fisica_w, clock_timestamp(), 'A');
	end if;

end if;

SELECT * FROM obter_regra_ajuste_mat(
		coalesce(cd_estabelecimento_w,cd_estab_logado_w), 	--cd_estabelecimento_p
		cd_convenio_w, 					--cd_convenio_p
		cd_categoria_w, 					--cd_categoria_p
		cd_material_w, 					--cd_material_p
		clock_timestamp(), 					--dt_vigencia_p
		'0', 						--cd_tipo_acomodacao_p
		coalesce(ie_tipo_atendimento_w,0), 			--ie_tipo_atendimento_p
		coalesce(cd_setor_atendimento_w,0), 			--cd_setor_atendimento_p
		coalesce(nr_idade_w,0), 				--qt_idade_p
		null, 						--nr_sequencia_p
		cd_plano_w, 					--cd_plano_p
		null, 						--cd_proc_referencia_p
		null, 						--ie_origem_proced_p
		null, 						--nr_seq_proc_interno_p
		dt_entrada_w, 					--dt_entrada_p
		ie_out_number_w, 				--OUT tx_ajuste_p
		vl_negociado_w, 					--OUT vl_negociado_p
		ie_out_varchar_w, 				--OUT ie_preco_informado_p
		ie_out_varchar_w, 				--OUT ie_glosa_p
		ie_out_number_w, 				--OUT tx_brasindice_pfb_p
		ie_out_number_w, 				--OUT tx_brasindice_pmc_p
		ie_out_number_w, 				--OUT tx_pmc_neg_p
		ie_out_number_w, 				--OUT tx_pmc_pos_p
		ie_out_number_w, 				--OUT tx_afaturar_p
		ie_out_number_w, 				--OUT tx_simpro_pfb_p
		ie_out_number_w, 				--OUT tx_simpro_pmc_p
		ie_out_varchar_w, 				--OUT ie_origem_preco_p
		ie_out_varchar_w, 				--OUT ie_precedencia_p
		ie_out_number_w, 				--OUT pr_glosa_p
		ie_out_number_w, 				--OUT vl_glosa_p
		ie_out_number_w, 				--OUT cd_tabela_preco_p
		ie_out_number_w, 				--OUT cd_motivo_exc_conta_p
		ie_out_number_w,  				--OUT nr_seq_regra_p
		ie_out_varchar_w,  				--OUT ie_autor_particular_p
		ie_out_number_w, 				--OUT cd_convenio_glosa_p
		ie_out_varchar_w, 				--OUT cd_categoria_glosa_p
		null, 						--ie_atend_retorno_p
		ie_out_number_w, 				--OUT tx_pfb_neg_p
		ie_out_number_w, 				--OUT tx_pfb_pos_p
		ie_out_varchar_w, 				--OUT ie_ignora_preco_venda_p
		ie_out_number_w, 				--OUT tx_simpro_pos_pfb_p
		ie_out_number_w, 				--OUT tx_simpro_neg_pfb_p
		ie_out_number_w, 				--OUT tx_simpro_pos_pmc_p
		ie_out_number_w, 				--OUT tx_simpro_neg_pmc_p
		nr_seq_origem_w, 				--nr_seq_origem_p
		null, 						--nr_seq_cobertura_p
		null, 						--qt_dias_internacao_p
		null, 						--nr_seq_regra_lanc_p
		null, 						--nr_seq_lib_dieta_conv_p
		ie_clinica_w, 					--ie_clinica_p
		cd_usuario_convenio_w, 				--cd_usuario_convenio_p
		nr_seq_classif_atend_w) INTO STRICT 
		ie_out_number_w, 
		vl_negociado_w, 
		ie_out_varchar_w, 
		ie_out_varchar_w, 
		ie_out_number_w, 
		ie_out_number_w, 
		ie_out_number_w, 
		ie_out_number_w, 
		ie_out_number_w, 
		ie_out_number_w, 
		ie_out_number_w, 
		ie_out_varchar_w, 
		ie_out_varchar_w, 
		ie_out_number_w, 
		ie_out_number_w, 
		ie_out_number_w, 
		ie_out_number_w, 
		ie_out_number_w, 
		ie_out_varchar_w, 
		ie_out_number_w, 
		ie_out_varchar_w, 
		ie_out_number_w, 
		ie_out_number_w, 
		ie_out_varchar_w, 
		ie_out_number_w, 
		ie_out_number_w, 
		ie_out_number_w, 
		ie_out_number_w;			--nr_seq_classif_atend_p
vl_preco_w := vl_negociado_w;

if (vl_preco_w <> 0) then
	begin

	select	(obter_dados_pf_pj_estab(cd_estabelecimento_p, null, cd_fornecedor_w, 'ECP'))::numeric
	into STRICT	cd_cond_pagto_w
	;

	update	material_autor_cirurgia
	set	vl_material	= (qt_material_w * vl_preco_w),
		nm_usuario	= nm_usuario_p,
        dt_atualizacao = clock_timestamp(),
		vl_unitario_material	= vl_preco_w,
		ie_origem_preco	= 3
	where	nr_sequencia	= nr_seq_material_p;

	if (cd_fornecedor_w IS NOT NULL AND cd_fornecedor_w::text <> '') then
		begin
		insert	into material_autor_cir_cot(nr_sequencia,
			cd_cgc,
			dt_atualizacao,
			nm_usuario,
			vl_cotado,
			vl_unitario_cotado,
			cd_condicao_pagamento,
			ie_aprovacao)
		values (nr_seq_material_p,
			cd_fornecedor_w,
			clock_timestamp(),
			nm_usuario_p,
			(qt_material_w * vl_preco_w),
			vl_preco_w,
			cd_cond_pagto_w,
			'N');
		end;
	end if;
	end;
else
	ds_retorno_p	:= cd_material_w;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_preco_mat_autor_neg (nr_seq_material_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;
