-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_regra_tx_mat_prest ( nr_interno_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*
Esta procedure tem o objetivo de duplicar os materiais da conta de origem para outra conta do prestador. 
Estes materiais duplicados  terao seus valores definidos por regra de taxa do prestador. Verificar o cadastro: Regra para a cobranca de taxas dos materiais por prestador no Shif+F11.

nr_interno_conta_p : Conta de origem onde serao verificados os materiais para duplica-los para uma outra conta do prestador.
Inicialmente chamado na FECHAR_CONTA_PACIENTE.
*/
					
cd_material_w			material_atend_paciente.cd_material%type;
cd_estabelecimento_w		conta_paciente.cd_estabelecimento%type;
cd_cgc_prestador_w		material_atend_paciente.cd_cgc_prestador%type;
cd_subgrupo_material_w		classe_material.cd_subgrupo_material%type;
cd_grupo_material_w		subgrupo_material.cd_grupo_material%type;
cd_classe_material_w		material.cd_classe_material%type;
cd_convenio_prestador_w		regra_taxa_mat_prestador.cd_convenio_prestador%type;
cd_categoria_prestador_w	regra_taxa_mat_prestador.cd_categoria_prestador%type;
cd_grupo_material_regra_w	regra_taxa_mat_prestador.cd_grupo_material%type;
cd_subgrupo_material_regra_w	regra_taxa_mat_prestador.cd_subgrupo_material%type;
cd_classe_material_regra_w	regra_taxa_mat_prestador.cd_classe_material%type;
cd_material_regra_w		regra_taxa_mat_prestador.cd_material%type;
cd_convenio_calculo_w  		conta_paciente.cd_convenio_parametro%type;
cd_categoria_calculo_w		conta_paciente.cd_categoria_calculo%type;
cd_setor_atendimento_w		setor_atendimento.cd_setor_atendimento%type;
cd_local_estoque_w		material_atend_paciente.cd_local_estoque%type;
cd_conta_receita_w		conta_contabil.cd_conta_contabil%type;	
cd_centro_custo_w		centro_custo.cd_centro_custo%type;
dt_periodo_inicial_w		conta_paciente.dt_periodo_inicial%type;
dt_entrada_atendimento_w	atendimento_paciente.dt_entrada%type;
dt_alta_atendimento_w		atendimento_paciente.dt_alta%type;
dt_acerto_conta_w		conta_paciente.dt_acerto_conta%type;
ie_tipo_convenio_aux2_w		convenio.ie_classif_contabil%type;
ie_classif_contabil_w		convenio.ie_tipo_convenio%type;
ie_tipo_atendimento_w		atendimento_paciente.ie_tipo_atendimento%type;
ie_regra_pacote_w		varchar(5) := 'N';
ie_responsavel_credito_w 	material_atend_paciente.ie_responsavel_credito%type;
ie_clinica_w			atendimento_paciente.ie_clinica%type;
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
nr_interno_conta_nova_w		conta_paciente.nr_interno_conta%type;
nr_seq_regra_taxa_w		regra_taxa_mat_prestador.nr_sequencia%type;
nr_seq_mat_novo_w   		material_atend_paciente.nr_sequencia%type;
nr_seq_material_w		material_atend_paciente.nr_sequencia%type;
pr_prestador_w			regra_taxa_mat_prestador.pr_prestador%type;
qt_material_w			material_atend_paciente.qt_material%type;
vl_unitario_novo_w		material_atend_paciente.vl_unitario%type;
vl_material_w			material_atend_paciente.vl_material%type;
vl_material_novo_w		material_atend_paciente.vl_material%type;
vl_unitario_w			material_atend_paciente.vl_unitario%type;
vl_prestador_w			regra_taxa_mat_prestador.vl_prestador%type;
qt_regras_w			integer := 0;
cd_sequencia_parametro_w	procedimento_paciente.cd_sequencia_parametro%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.cd_material,
		coalesce(a.qt_material,0), 
		coalesce(a.vl_material,0), 
		coalesce(a.vl_unitario,0),
		coalesce(a.cd_cgc_prestador,0),
		coalesce(a.ie_responsavel_credito,0),
		a.nr_atendimento,
		a.cd_setor_atendimento,
		a.cd_local_estoque,
		CASE WHEN coalesce(a.nr_seq_proc_pacote,0)=0 THEN 'N'  ELSE 'S' END 
	from	material_atend_paciente a
	where	a.nr_interno_conta = nr_interno_conta_p
	and 	a.vl_unitario <> 0
	and 	coalesce(a.nr_seq_mat_glosa::text, '') = ''
	and	coalesce(a.nr_seq_proc_pacote::text, '') = ''
	and 	not exists ( --se ja duplicou em alguma vez, nao vai duplicar novamente
			SELECT	1
			from	mat_atend_pac_tx_prest x
			where 	x.nr_seq_mat_origem = a.nr_sequencia
		)
	and 	not exists ( --se eh um item que foi duplicado pela regra, nao vai duplicar novamente
			select	1
			from	mat_atend_pac_tx_prest x
			where 	x.nr_seq_mat_gerado = a.nr_sequencia
		)
	order by nr_sequencia;

C02 CURSOR FOR
	SELECT	nr_sequencia,
		coalesce(cd_material,0),
		coalesce(pr_prestador,0),
		coalesce(vl_prestador,0),
		cd_convenio_prestador,
		cd_categoria_prestador,
		coalesce(cd_classe_material,0),
		coalesce(cd_subgrupo_material,0),
		coalesce(cd_grupo_material,0)
	from	regra_taxa_mat_prestador
	where	coalesce(cd_estabelecimento,coalesce(cd_estabelecimento_w,0)) 	 = coalesce(cd_estabelecimento_w,0)
	and 	coalesce(cd_material,coalesce(cd_material_w,0)) 			 = coalesce(cd_material_w,0)
	and 	coalesce(cd_grupo_material, coalesce(cd_grupo_material_w,0)) 	 = coalesce(cd_grupo_material_w,0)
	and 	coalesce(cd_subgrupo_material, coalesce(cd_subgrupo_material_w,0)) = coalesce(cd_subgrupo_material_w,0)
	and 	coalesce(cd_classe_material, coalesce(cd_classe_material_w,0)) 	 = coalesce(cd_classe_material_w,0)
	and 	coalesce(cd_cgc_prestador,coalesce(cd_cgc_prestador_w,'0'))		 = coalesce(cd_cgc_prestador_w,'0')
	and 	coalesce(ie_responsavel_credito,'0') 				 = coalesce(ie_responsavel_credito_w,'0')
	and 	clock_timestamp() between dt_inicio_vigencia and coalesce(dt_final_vigencia,clock_timestamp())
	and 	ie_situacao = 'A'
	order by
		coalesce(cd_material,0),
		coalesce(cd_classe_material,0),
		coalesce(cd_subgrupo_material,0),
		coalesce(cd_grupo_material,0),	
		coalesce(dt_inicio_vigencia, clock_timestamp()),
		coalesce(cd_cgc_prestador,'0'),
		coalesce(ie_responsavel_credito,' '),
		coalesce(cd_estabelecimento,0);

BEGIN

select 	count(1)
into STRICT	qt_regras_w
from   	regra_taxa_mat_prestador
where 	ie_situacao = 'A';

if (coalesce(nr_interno_conta_p,0) = 0) or (qt_regras_w = 0) then
	goto final;
end if;

select 	a.cd_estabelecimento,
	a.dt_periodo_inicial,
	b.dt_entrada,
	b.dt_alta,
	b.ie_clinica
into STRICT 	cd_estabelecimento_w,
	dt_periodo_inicial_w,
	dt_entrada_atendimento_w,	
	dt_alta_atendimento_w,
	ie_clinica_w
from 	conta_paciente 		a, 
	atendimento_paciente 	b
where 	a.nr_atendimento 	= b.nr_atendimento
and  	a.nr_interno_conta 	= nr_interno_conta_p;


open C01; --MATERIAIS DA CONTA
loop
fetch C01 into	
	nr_seq_material_w,
	cd_material_w,	
	qt_material_w,
	vl_material_w,
	vl_unitario_w,
	cd_cgc_prestador_w,
	ie_responsavel_credito_w,
	nr_atendimento_w,
	cd_setor_atendimento_w,
	cd_local_estoque_w,
	ie_regra_pacote_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	nr_seq_regra_taxa_w		:= 0;
	cd_material_regra_w 		:= null;
	pr_prestador_w 			:= null;
	vl_prestador_w			:= null;
	cd_convenio_prestador_w 	:= null;
	cd_categoria_prestador_w 	:= null;
	cd_classe_material_regra_w	:= null;
	cd_subgrupo_material_regra_w	:= null;
	cd_grupo_material_regra_w 	:= null;
	cd_sequencia_parametro_w    := null;
	
	select	coalesce(max(a.cd_classe_material),0),
		coalesce(max(b.cd_subgrupo_material),0),
		coalesce(max(c.cd_grupo_material),0)
	into STRICT	cd_classe_material_w,
		cd_subgrupo_material_w,
		cd_grupo_material_w
	from	material 		a,
		classe_material 	b,
		subgrupo_material 	c
	where	a.cd_material          = cd_material_w
	and 	a.cd_classe_material   = b.cd_classe_material
	and	b.cd_subgrupo_material = c.cd_subgrupo_material;
	end;

	open C02;--REGRAS DE TAXA
	loop
	fetch C02 into
		nr_seq_regra_taxa_w,
		cd_material_regra_w,
		pr_prestador_w,
		vl_prestador_w,
		cd_convenio_prestador_w,
		cd_categoria_prestador_w,
		cd_classe_material_regra_w,
		cd_subgrupo_material_regra_w,
		cd_grupo_material_regra_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
	end loop;
	close C02;
	
	if (coalesce(nr_seq_regra_taxa_w,0) > 0) then
		if (coalesce(nr_interno_conta_nova_w::text, '') = '') then
			--OBTER A NOVA CONTA
			SELECT * FROM OBTER_CONTA_PACIENTE(
				cd_estabelecimento_w, nr_atendimento_w, cd_convenio_prestador_w, cd_categoria_prestador_w, nm_usuario_p, dt_periodo_inicial_w, dt_entrada_atendimento_w, dt_alta_atendimento_w, null, null, null, dt_acerto_conta_w,   --out
				nr_interno_conta_nova_w,  --out
				cd_convenio_calculo_w,   --out
				cd_categoria_calculo_w) INTO STRICT dt_acerto_conta_w, 
				nr_interno_conta_nova_w, 
				cd_convenio_calculo_w, 
				cd_categoria_calculo_w; --out
		end if;	
	
		nr_seq_mat_novo_w  := duplicar_mat_paciente2(nr_seq_material_w, nm_usuario_p, 'N', nr_seq_mat_novo_w );
		
		select	coalesce(max(ie_tipo_convenio),0),
			max(ie_classif_contabil)
		into STRICT	ie_tipo_convenio_aux2_w,
			ie_classif_contabil_w
		from	convenio
		where	cd_convenio	= cd_convenio_calculo_w;

		SELECT * FROM define_conta_material(
			cd_estabelecimento_w, cd_material_w, 1, ie_clinica_w, cd_setor_atendimento_w, ie_classif_contabil_w, ie_tipo_atendimento_w, ie_tipo_convenio_aux2_w, cd_convenio_calculo_w, cd_categoria_calculo_w, cd_local_estoque_w, null, dt_entrada_atendimento_w, cd_conta_receita_w, --out
			cd_centro_custo_w,  --out
			null, ie_regra_pacote_w) INTO STRICT cd_conta_receita_w, 
			cd_centro_custo_w;
		
		cd_sequencia_parametro_w := philips_contabil_pck.get_parametro_conta_contabil();
		
		if (coalesce(pr_prestador_w,0) > 0) then
			vl_material_novo_w := vl_unitario_w * ( pr_prestador_w/100 ) * qt_material_w;
			vl_unitario_novo_w := vl_unitario_w * ( pr_prestador_w/100 );
		elsif (coalesce(vl_prestador_w,0) > 0) then
			vl_material_novo_w := vl_prestador_w * qt_material_w;
			vl_unitario_novo_w := vl_prestador_w;
		end if;
		
		--ATUALIZANDO NOVO MATERIAL
		update material_atend_paciente
		set	ie_valor_informado	= 'S',	
			vl_material		= vl_material_novo_w,
			vl_unitario		= vl_unitario_novo_w,
			qt_material		= 0,
			dt_acerto_conta 	= dt_acerto_conta_w,
			nr_interno_conta 	= nr_interno_conta_nova_w,
			cd_convenio		= cd_convenio_calculo_w,
			cd_categoria		= cd_categoria_calculo_w,
			dt_atendimento		= dt_atendimento - 3/86400, --Retirado o 3 Segundos que estava sendo acrescentado na procedure "duplicar_mat_paciente2"
			cd_conta_contabil	= cd_conta_receita_w,
			cd_centro_custo_receita	= CASE WHEN cd_centro_custo_w=0 THEN null  ELSE cd_centro_custo_w END ,
			cd_sequencia_parametro = cd_sequencia_parametro_w
		where	nr_sequencia		= nr_seq_mat_novo_w;
		
		insert into mat_atend_pac_tx_prest(nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_regra_tx_mat, nr_seq_mat_origem, nr_seq_mat_gerado)
		values (nextval('mat_atend_pac_tx_prest_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, nr_seq_regra_taxa_w, nr_seq_material_w, nr_seq_mat_novo_w);
		
	end if;
end loop;
close C01;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

<<final>>
null;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_regra_tx_mat_prest ( nr_interno_conta_p bigint, nm_usuario_p text) FROM PUBLIC;
