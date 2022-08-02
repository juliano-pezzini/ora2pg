-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_incluir_proc_analise ( nr_seq_analise_p bigint, nr_seq_segurado_p bigint, nr_seq_grupo_atual_p bigint, nr_seq_conta_p bigint, nr_seq_w_proc_p bigint, cd_guia_p text, ie_tipo_analise_p text, ie_commitar_p text, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_item_gerado_p INOUT bigint) AS $body$
DECLARE


ds_medicos_w			varchar(255);
ds_partic_w			varchar(255);
ds_partic_ww			varchar(255);
ds_observacao_w			varchar(255);
ds_cbo_prest_w			varchar(255);
ds_cbo_part_w			varchar(255);
cd_cbo_prest_w			varchar(255);
cd_cbo_part_w			varchar(255);
ie_tipo_segurado_w		varchar(10);
ie_atualiza_apresentado_w	varchar(10);
ie_calculo_pacote_w		varchar(2);
uf_conselho_w 			pls_proc_participante.uf_conselho%type;
ie_tipo_despesa_w		varchar(1);
ie_valor_informado_w		varchar(1)	:= 'N';
ie_via_acesso_w			varchar(1);
ie_participante_w		varchar(1);
vl_total_procedimento_w		double precision;
vl_procedimento_imp_w		double precision;
vl_total_apres_w		double precision;
vl_uni_apres_w			double precision;
vl_unitario_imp_w		double precision;
cd_procedimento_w		bigint;
qt_procedimento_w		double precision;
nr_seq_proc_w			bigint;
cd_medico_w			bigint;
cd_partic_w			bigint;
nr_seq_partic_w			bigint;
nr_seq_conselho_w		bigint;
nr_seq_cbo_saude_w		bigint;
nr_seq_conta_w			bigint;
nr_seq_item_criado_w		bigint;
nr_seq_grau_partic_w		bigint;
nr_seq_prestador_w		bigint;
ie_origem_proced_w		bigint;
nr_seq_tipo_taxa_w		bigint;
tx_item_w			double precision;
ie_origem_analise_w		smallint;
dt_procedimento_w		timestamp;
dt_inicio_w			timestamp;
dt_fim_w			timestamp;
ie_geracao_pos_estab_w		varchar(1);
ie_analise_cm_nova_w		varchar(3);
ie_consistir_analise_w		varchar(2);
tx_custo_operacional_w		pls_taxa_item.tx_custo_operacional%type;
tx_material_w			pls_taxa_item.tx_material%type;
tx_medico_w	  		pls_taxa_item.tx_medico%type;

C01 CURSOR FOR
	SELECT	cd_medico,
		nr_seq_cbo_saude,
		nr_seq_grau_partic,
		nr_seq_prestador,
		'S' ie_participante
	from	w_pls_proc_participante
	where	nr_seq_analise	= nr_seq_analise_p
	and	nm_usuario	= nm_usuario_p
	
union

	SELECT	null,
		null,
		null,
		null,
		'N'
	
	where	not exists (select	1
				from	w_pls_proc_participante
				where	nr_seq_analise	= nr_seq_analise_p
				and	nm_usuario	= nm_usuario_p);

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionário [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
	


BEGIN

if (ie_tipo_analise_p = 'IN') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(277092);
end if;

ie_consistir_analise_w := Obter_Param_Usuario(1365, 16, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, cd_estabelecimento_p, ie_consistir_analise_w);

select	nr_seq_tipo_taxa,
	cd_procedimento,
	ie_origem_proced,
	dt_inicio_proc,
	dt_fim_proc,
	coalesce(vl_uni_apres,0),
	coalesce(vl_apresentado,0),
	ie_via_acesso,
	dt_procedimento,
	qt_apresentada,
	coalesce(tx_item,100)
into STRICT	nr_seq_tipo_taxa_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	dt_inicio_w,
	dt_fim_w,
	vl_uni_apres_w,
	vl_total_apres_w,
	ie_via_acesso_w,
	dt_procedimento_w,
	qt_procedimento_w,
	tx_item_w
from	w_pls_conta_proc
where	nr_sequencia	= nr_seq_w_proc_p;

if (nr_seq_tipo_taxa_w IS NOT NULL AND nr_seq_tipo_taxa_w::text <> '') then
	select	max(tx_item),
		max(tx_custo_operacional),
		max(tx_material),
		max(tx_medico)               
	into STRICT	tx_item_w,
		tx_custo_operacional_w,
		tx_material_w,
		tx_medico_w
	from	pls_taxa_item
	where	nr_sequencia	= nr_seq_tipo_taxa_w;
end if;

select	coalesce(dt_procedimento_w, dt_emissao),
	ie_tipo_segurado
into STRICT	dt_procedimento_w,
	ie_tipo_segurado_w
from	pls_conta
where	nr_sequencia	= nr_seq_conta_p;

if (coalesce(vl_total_apres_w,0) > 0) then
	ie_valor_informado_w	:= 'S';
end if;

if (coalesce(vl_total_apres_w::text, '') = '') then
	vl_total_apres_w	:= vl_uni_apres_w * qt_procedimento_w;
end if;

if (ie_tipo_analise_p = 'IN') then
	vl_uni_apres_w	:= dividir(vl_total_apres_w,qt_procedimento_w);
end if;

if (ie_tipo_analise_p <> 'IN') then /* Quando não for análise de intercâmbio lançar um procedimento e vincular os participantes a este único procedimento */

	--obtem a seq da conta proc
	select	nextval('pls_conta_proc_seq')
	into STRICT	nr_seq_proc_w
	;

	insert into pls_conta_proc(nr_sequencia, cd_procedimento, ie_origem_proced,
		qt_procedimento, dt_procedimento, ie_via_acesso,
		nr_seq_conta, nm_usuario, nm_usuario_nrec,
		dt_atualizacao, dt_atualizacao_nrec, ie_situacao,
		ie_status, qt_procedimento_imp, tx_item,
		dt_inicio_proc, dt_fim_proc, cd_procedimento_imp,
		ds_procedimento_imp, vl_unitario_imp, vl_procedimento_imp,
		ie_valor_informado, ie_vl_apresentado_sistema, ie_ato_cooperado,
		vl_apresentado_xml, ie_status_pagamento, tx_medico,
		tx_custo_operacional, tx_material, ie_acao_analise)
	values (nr_seq_proc_w, cd_procedimento_w, ie_origem_proced_w,
		0, dt_procedimento_w, ie_via_acesso_w,
		nr_seq_conta_p, nm_usuario_p, nm_usuario_p,
		clock_timestamp(), clock_timestamp(), 'D',
		'A', qt_procedimento_w, tx_item_w,
		dt_inicio_w, dt_fim_w, null,
		null, vl_uni_apres_w, vl_total_apres_w,
		ie_valor_informado_w, 'N', CASE WHEN ie_tipo_analise_p='IN' THEN '1'  ELSE null END ,
		CASE WHEN ie_tipo_analise_p='IN' THEN vl_total_apres_w  ELSE null END ,'I', coalesce(tx_medico_w,100),
		coalesce(tx_custo_operacional_w,0), coalesce(tx_material_w,0), 'I');
		
	CALL pls_cta_proc_mat_regra_pck.cria_registro_regra_proc(nr_seq_proc_w, nm_usuario_p);
	CALL pls_cta_proc_mat_regra_pck.gera_seq_tiss_proc(nr_seq_proc_w, null, null, nr_seq_conta_p, nm_usuario_p);
	
	nr_seq_item_criado_w	:= nr_seq_proc_w;
	
	ds_observacao_w :=	'Procedimento inserido: ' || substr(cd_procedimento_w || '-' || pls_obter_desc_procedimento(cd_procedimento_w,ie_origem_proced_w),1,150) ||
					chr(13) || chr(10) || 'Quantidade inserida: ' || qt_procedimento_w;
	/*Inserindo histórico*/

	CALL pls_inserir_hist_analise(nr_seq_conta_p, nr_seq_analise_p, 19,
				 nr_seq_proc_w, 'P', null,
				 null,ds_observacao_w, nr_seq_grupo_atual_p,
				 nm_usuario_p,cd_estabelecimento_p);
		
	nr_seq_item_criado_w	:= nr_seq_proc_w;
end if;

open C01;
loop
fetch C01 into
	cd_medico_w,
	nr_seq_cbo_saude_w,
	nr_seq_grau_partic_w,
	nr_seq_prestador_w,
	ie_participante_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	if (ie_tipo_analise_p = 'IN') then /* Quando análise de intercâmbio lançar um procedimento para cada participante */

		--obtem a seq da conta proc
		select	nextval('pls_conta_proc_seq')
		into STRICT	nr_seq_proc_w
		;

		insert into pls_conta_proc(nr_sequencia, cd_procedimento, ie_origem_proced,
			qt_procedimento, dt_procedimento, ie_via_acesso,
			nr_seq_conta, nm_usuario, nm_usuario_nrec,
			dt_atualizacao, dt_atualizacao_nrec, ie_situacao,
			ie_status, qt_procedimento_imp, tx_item,
			dt_inicio_proc, dt_fim_proc, cd_procedimento_imp,
			ds_procedimento_imp, vl_unitario_imp, vl_procedimento_imp,
			ie_valor_informado, ie_vl_apresentado_sistema, ie_ato_cooperado,
			vl_apresentado_xml, ie_status_pagamento, tx_medico,
			tx_custo_operacional, tx_material, ie_acao_analise)
		values (nr_seq_proc_w, cd_procedimento_w, ie_origem_proced_w,
			0, dt_procedimento_w, ie_via_acesso_w,
			nr_seq_conta_p, nm_usuario_p, nm_usuario_p,
			clock_timestamp(), clock_timestamp(), 'D',
			'A', qt_procedimento_w, tx_item_w,
			dt_inicio_w, dt_fim_w, null,
			null, vl_uni_apres_w, vl_total_apres_w,
			ie_valor_informado_w, 'N', CASE WHEN ie_tipo_analise_p='IN' THEN '1'  ELSE null END ,
			CASE WHEN ie_tipo_analise_p='IN' THEN vl_total_apres_w  ELSE null END ,'I', coalesce(tx_medico_w,100),
			coalesce(tx_custo_operacional_w,0), coalesce(tx_material_w,0), 'I');

		CALL pls_cta_proc_mat_regra_pck.cria_registro_regra_proc(nr_seq_proc_w, nm_usuario_p);
		CALL pls_cta_proc_mat_regra_pck.gera_seq_tiss_proc(nr_seq_proc_w, null, null, nr_seq_conta_p, nm_usuario_p);
		
		ds_observacao_w :=	'Procedimento inserido: ' || substr(cd_procedimento_w || '-' || pls_obter_desc_procedimento(cd_procedimento_w,ie_origem_proced_w),1,150) ||
					chr(13) || chr(10) || 'Quantidade inserida: ' || qt_procedimento_w;
		/*Inserindo histórico*/

		CALL pls_inserir_hist_analise(nr_seq_conta_p, nr_seq_analise_p, 19,
					 nr_seq_proc_w, 'P', null,
					 null,ds_observacao_w, nr_seq_grupo_atual_p,
					 nm_usuario_p,cd_estabelecimento_p);
			
		nr_seq_item_criado_w	:= nr_seq_proc_w;
	end if;
	
	if (ie_participante_w = 'S') then
		if (cd_medico_w > 0) then
			uf_conselho_w 		:= obter_dados_medico(cd_medico_w, 'UFCRM');
			nr_seq_conselho_w 	:= pls_obter_seq_conselho_prof(cd_medico_w);
		end if;

		insert into pls_proc_participante(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_conta_proc,
			cd_medico,
			nr_seq_grau_partic,
			uf_conselho,
			nr_seq_cbo_saude,
			nr_seq_conselho,
			nr_seq_prestador,
			ie_status,
			ie_status_pagamento)
		values (nextval('pls_proc_participante_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_proc_w,
			cd_medico_w,
			nr_seq_grau_partic_w,
			uf_conselho_w,
			nr_seq_cbo_saude_w,
			nr_seq_conselho_w,
			nr_seq_prestador_w,
			'A',
			'I');
	end if;
	end;
end loop;
close C01;

select	max(ie_tipo_despesa)
into STRICT	ie_tipo_despesa_w
from	pls_conta_proc
where	nr_sequencia = nr_seq_proc_w;

select	coalesce(max(ie_calculo_pacote),'P'),
	coalesce(max(ie_atualizar_valor_apresent),'N'),
	coalesce(max(ie_geracao_pos_estabelecido),'F'),
	coalesce(max(ie_analise_cm_nova),'N')
into STRICT	ie_calculo_pacote_w,
	ie_atualiza_apresentado_w,
	ie_geracao_pos_estab_w,
	ie_analise_cm_nova_w
from	pls_parametros
where	cd_estabelecimento	= cd_estabelecimento_p;

if (ie_tipo_analise_p <> 'IN') and (ie_geracao_pos_estab_w = 'C')then
	CALL pls_gerar_valor_pos_estab(nr_seq_conta_p, nm_usuario_p, ie_geracao_pos_estab_w,nr_seq_proc_w,null,'A');
end if;
--Tratamento incluído devido ao fato da análise ser consistida por completo na sequencia dispercisando este recurso
if (ie_consistir_analise_w = 'N') then
	CALL pls_analise_consistir_item(nr_seq_analise_p,
				'I',
				nr_seq_grupo_atual_p,
				nr_seq_conta_p,
				nr_seq_proc_w,
				null,
				cd_estabelecimento_p,
				nm_usuario_p);
end if;

nr_seq_item_gerado_p	:= nr_seq_item_criado_w;

delete	from w_pls_proc_participante
where	nr_seq_analise	= nr_seq_analise_p
and	nm_usuario	= nm_usuario_p;

delete	from w_pls_conta_proc
where	nm_usuario	= nm_usuario_p;

if (coalesce(ie_commitar_p,'S') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_incluir_proc_analise ( nr_seq_analise_p bigint, nr_seq_segurado_p bigint, nr_seq_grupo_atual_p bigint, nr_seq_conta_p bigint, nr_seq_w_proc_p bigint, cd_guia_p text, ie_tipo_analise_p text, ie_commitar_p text, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_item_gerado_p INOUT bigint) FROM PUBLIC;

