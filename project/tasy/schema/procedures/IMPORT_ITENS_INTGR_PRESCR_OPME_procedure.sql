-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE import_itens_intgr_prescr_opme (id_pedido_p bigint, nm_usuario_p text, cd_material_p text, qt_material_p bigint, vl_unitario_p text, vl_total_p text, ds_observacao_p text, cd_cnpj_p text, ds_razao_social_p text, ie_opcao_p text, prazo_entrega_p bigint, nm_fantasia_p text, ds_forma_pagamento_p text, ie_origem_inf_p text, nr_prescricao_p INOUT bigint, ds_erro_p INOUT text) AS $body$
DECLARE


nr_cirurgia_w				cirurgia.nr_cirurgia%type;
nr_prescricao_w				cirurgia.nr_prescricao%type;
ie_tipo_pessoa_w			pessoa_fisica.ie_tipo_pessoa%type;
cd_medico_cirurgiao_w			agenda_paciente.cd_medico%type;
cd_pessoa_fisica_w			agenda_paciente.cd_pessoa_fisica%type;
nr_seq_prescr_material_w		prescr_material.nr_sequencia%type;
cd_convenio_w				agenda_paciente.cd_convenio%type;
cd_categoria_w				agenda_paciente.cd_categoria%type;
cd_setor_atendimento_w			setor_atendimento.cd_setor_atendimento%type;
ie_forma_adep_w		    		varchar(10);
cd_unidade_medida_w			prescr_material.cd_unidade_medida%type;
cd_intervalo_w				intervalo_prescricao.cd_intervalo%type;
ie_adep_w		    		varchar(10);
nr_atendimento_w			agenda_paciente.nr_atendimento%type;
cd_setor_atendimento_ww			prescr_medica.cd_setor_atendimento%type;
nr_seq_agenda_w				agenda_paciente.nr_sequencia%type;
vl_unitario_w				double precision;
vl_total_w				double precision;
cd_material_w				material.cd_material%type;
cd_cnpj_w				varchar(14);
cd_estabelecimento_w			smallint;
dt_agenda_w				agenda_paciente.dt_agenda%type;
ie_copiar_preco_estab_w			parametros_opme.ie_copiar_preco_estab%type;
ie_atualiza_tabela_w			parametros_opme.ie_atualiza_tabela%type;
cd_tabela_preco_w			parametros_opme.cd_tabela_preco%type;
cd_setor_prescr_w			agenda.cd_setor_exclusivo%type;
qt_existe_w				integer;
nr_cot_compra_w				cot_compra.nr_cot_compra%type;
cd_tabela_preco_ww 			convenio_preco_mat.cd_tab_preco_mat%type;
cd_moeda_w				parametro_compras.cd_moeda_padrao%type;
cd_tipo_pessoa_w			parametro_compras.cd_tipo_pessoa_bionexo%type;
cd_cep_w				pessoa_juridica.cd_cep%type;
sg_estado_w				pessoa_juridica.sg_estado%type;
cd_condicao_pagto_w			condicao_pagamento.cd_condicao_pagamento%type;
cd_estab_w				estabelecimento.cd_estabelecimento%type;
nr_seq_classif_w			bigint;
ds_titulo_w				varchar(255);
ds_comunicado_w				varchar(2000);
ds_forma_pagto_fornec_w			varchar(80);
nr_seq_cot_fornecedor_w			cot_compra_forn.nr_sequencia%type;
dt_retorno_prev_w			timestamp;
nr_item_cot_compra_w			cot_compra_item.nr_item_cot_compra%type;
nr_seq_fornec_w				cot_compra_forn.nr_sequencia%type;
nr_item_cotacao_w			cot_compra_item.nr_item_cot_compra%type;
nr_sequencia_item_w			cot_compra_forn_item.nr_sequencia%type;
ie_origem_inf_w				prescr_medica.ie_origem_inf%type;

c02 CURSOR FOR
SELECT	cd_estabelecimento
from	estabelecimento
where	ie_situacao = 'A';


BEGIN

begin
	vl_unitario_w 	:= (REPLACE(vl_unitario_p, '.', ''))::numeric;
exception when others then
	vl_unitario_w := (REPLACE(REPLACE(vl_unitario_p, '.', ''), ',', '.'))::numeric;
end;

cd_material_w	:= somente_numero(cd_material_p);
cd_cnpj_w	:= cd_cnpj_p;

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_agenda_w
from	agenda_paciente
where	cd_sistema_externo = id_pedido_p;

if (coalesce(nr_seq_agenda_w,0) = 0)then
	ds_erro_p := 'Nao foi encontrado registro de agenda cirurgica para o pedido realizado.';
	return;
end if;

/* Encontra numero de cirurgia vinculada ao registro da agenda cirurgica */


/* Encontra numero de prescricao atual da cirurgia */

select	coalesce(max(nr_cirurgia),0)
into STRICT	nr_cirurgia_w
from	cirurgia
where	nr_seq_agenda = nr_seq_agenda_w;	

if (coalesce(nr_cirurgia_w,0) = 0)then
	ds_erro_p := 'Nao foi encontrado registro de cirurgia para o agendamento cirurgico do pedido realizado.';
	return;
end if;

select	max(cd_estabelecimento),
	max(b.cd_convenio),
	max(b.cd_categoria),
	max(b.dt_agenda)
into STRICT	cd_estabelecimento_w,
	cd_convenio_w,
	cd_categoria_w,
	dt_agenda_w
from	agenda a,
	agenda_paciente b
where 	a.cd_agenda = b.cd_agenda
and	b.nr_sequencia = nr_seq_agenda_w;

select	coalesce(max(ie_copiar_preco_estab), 'N')
into STRICT 	ie_copiar_preco_estab_w
from	parametros_opme
where 	cd_estabelecimento = cd_estabelecimento_w
and	ie_sistema_integracao = 'P';

select	coalesce(max(b.ie_tipo_pessoa),'1')
into STRICT	ie_tipo_pessoa_w
from	pessoa_fisica b,
	usuario a
where	a.cd_pessoa_fisica = b.cd_pessoa_fisica
and	a.nm_usuario = nm_usuario_p;

ie_origem_inf_w	:= coalesce(ie_origem_inf_p,ie_tipo_pessoa_w);

if (ie_opcao_p = 1) then
	begin
	
	select	coalesce(max(ie_atualiza_tabela), 'N'),
		max(cd_tabela_preco)
	into STRICT	ie_atualiza_tabela_w,
		cd_tabela_preco_w
	from	parametros_opme
	where	ie_sistema_integracao = 'P'
	and	cd_estabelecimento = cd_estabelecimento_w;

	if (coalesce(vl_unitario_w,0) > 0) then
		if (ie_atualiza_tabela_w = 'S') and (cd_tabela_preco_w IS NOT NULL AND cd_tabela_preco_w::text <> '') then
				CALL atualiza_tab_preco_OPMENexo(cd_material_w, clock_timestamp(), cd_tabela_preco_w, cd_estabelecimento_w, vl_unitario_w, cd_cnpj_w, nm_usuario_p);
			if (ie_copiar_preco_estab_w = 'S') then
				CALL copiar_tabela_preco_mat_estab(cd_tabela_preco_w, cd_estabelecimento_w, cd_material_w, trunc(clock_timestamp()), nm_usuario_p);
			end if;
		elsif (ie_atualiza_tabela_w in ('C', 'D')) then
			
			select 	max(cd_tab_preco_mat)
			into STRICT	cd_tabela_preco_ww
			from	convenio_preco_mat
			where 	cd_convenio = cd_convenio_w
			and	cd_categoria = cd_categoria_w
			and	ie_integracao_opme = 'S'
			and 	cd_estabelecimento = cd_estabelecimento_w;
			
			if (coalesce(cd_tabela_preco_ww, coalesce(cd_tabela_preco_w, 0)) > 0) then
				if (ie_atualiza_tabela_w = 'D')  then
					CALL atua_tab_preco_dt_age_opmenexo(cd_material_w, dt_agenda_w, coalesce(cd_tabela_preco_ww, cd_tabela_preco_w), cd_estabelecimento_w, vl_unitario_w, cd_cnpj_w, nm_usuario_p);
					
					if (ie_copiar_preco_estab_w = 'S') then
						CALL copiar_tabela_preco_mat_estab(coalesce(cd_tabela_preco_ww, cd_tabela_preco_w), cd_estabelecimento_w, cd_material_w, trunc(dt_agenda_w), nm_usuario_p);
					end if;
				else
					CALL atua_tab_preco_dt_age_opmenexo(cd_material_w, clock_timestamp(), coalesce(cd_tabela_preco_ww, cd_tabela_preco_w), cd_estabelecimento_w, vl_unitario_w, cd_cnpj_w, nm_usuario_p);
					
					if (ie_copiar_preco_estab_w = 'S') then
						CALL copiar_tabela_preco_mat_estab(coalesce(cd_tabela_preco_ww, cd_tabela_preco_w), cd_estabelecimento_w, cd_material_w, trunc(clock_timestamp()), nm_usuario_p);
					end if;
				end if;
			end if;
		end if;

	end if;

	if (coalesce(nr_prescricao_p,0) > 0) then
		nr_prescricao_w := nr_prescricao_p;
	else	
		/*Procura pela prescricao ja vinculada na cirurgia, desde que a propria cirurgia ainda possa ser modificada. Senao cria uma nova especifica para os materiais da integracao.*/

		select	coalesce(max(nr_prescricao),0)
		into STRICT	nr_prescricao_w
		from	cirurgia
		where	nr_cirurgia = nr_cirurgia_w
		and	coalesce(dt_liberacao::text, '') = ''
		and	clock_timestamp() < dt_inicio_cirurgia
		and	coalesce(dt_cancelamento::text, '') = '';
	end if;

	/* [246] - Forma de definir se a prescricao vai para a ADEP */

	ie_forma_adep_w := Obter_Param_Usuario(924, 246, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_forma_adep_w);

	/* [548] - Setor padrao ao gerar a prescricao de materiais especiais */

	cd_setor_atendimento_ww := obter_param_usuario(900, 548, Obter_Perfil_ativo, nm_usuario_p, cd_estabelecimento_w, cd_setor_atendimento_ww);

	if (nr_prescricao_w < 1)then
		begin	

		/* Prescricao ja liberada, ou nao existe, precisa criar uma nova e atualizar valor da variavel nr_prescricao_w */

		
		select	coalesce(max(cd_setor_exclusivo),0)
		into STRICT	cd_setor_prescr_w
		from	Agenda b,
			agenda_paciente a
		where 	a.cd_agenda	= b.cd_agenda
		and	a.nr_sequencia	= nr_seq_agenda_w;

		if (cd_setor_prescr_w = 0) then
			select	max(cd_setor_atendimento)
			into STRICT	cd_setor_prescr_w
			from 	usuario
			where 	nm_usuario = nm_usuario_p;
		end if;
		
		/* Identificar se existe uma prescricao de materiais especiais para o agendamento, mas que nao seja o ja vinculado na cirurgia  (ie_tipo_prescr_cirur =  1 - Materiais especiais, 2 - PEPO, 3 - Patologia) */

		select  coalesce(max(NR_PRESCRICAO),0)
		into STRICT	nr_prescricao_w
		from 	prescr_medica a
		where	a.nr_seq_agenda = nr_seq_agenda_w
		and	not exists (SELECT 1 from cirurgia b where b.nr_cirurgia = nr_cirurgia_w and a.nr_prescricao = b.nr_prescricao)
		and	a.ie_tipo_prescr_cirur 		= 1;
		
		/* A prescricao que existe nao pode ser utilizada, entao deve criar uma nova */

		
		if (nr_prescricao_w = 0) then
			select	nr_atendimento,
				cd_convenio,
				cd_categoria,
				cd_medico,
				cd_pessoa_fisica
			into STRICT	nr_atendimento_w,
				cd_convenio_w,
				cd_categoria_w,
				cd_medico_cirurgiao_w,
				cd_pessoa_fisica_w
			from	agenda_paciente
			where	nr_sequencia = nr_seq_agenda_w;
			
			select	nextval('prescr_medica_seq')
			into STRICT	nr_prescricao_w
			;
			
			select	max(obter_setor_atendimento(nr_atendimento_w))
			into STRICT	cd_setor_atendimento_w
			;
				
			if (ie_forma_adep_w = 'DS') then
				select	coalesce(max(ie_adep),'N')
				into STRICT	ie_adep_w
				from	setor_atendimento
				where	cd_setor_atendimento = cd_setor_atendimento_w;
			elsif (ie_forma_adep_w = 'NV') then
				ie_adep_w   := 'N';
			elsif (ie_forma_adep_w = 'PV') then
				ie_adep_w := 'S';
			elsif (ie_forma_adep_w = 'PNV') then
				ie_adep_w := 'N';
			else
				ie_adep_w := 'S';
			end if;	
			
			/* Verificar informacoes do insert */

			
			insert	into prescr_medica(
				dt_prescricao,
				cd_medico,
				cd_pessoa_fisica,
				cd_estabelecimento,
				nm_usuario_original,
				nr_horas_validade,
				nr_prescricao,
				nr_cirurgia,
				ie_recem_nato,
				ie_origem_inf,
				dt_primeiro_horario,
				nm_usuario,
				dt_atualizacao,
				cd_prescritor,
				ie_tipo_prescr_cirur,
				nr_seq_agenda,
				nr_atendimento,
				ie_adep,
				cd_setor_entrega,
				cd_setor_atendimento)
			values (
				clock_timestamp(),
				cd_medico_cirurgiao_w,
				cd_pessoa_fisica_w,
				cd_estabelecimento_w,
				nm_usuario_p,
				24,
				nr_prescricao_w,
				nr_cirurgia_w,
				'N',
				ie_origem_inf_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				obter_dados_usuario_opcao(nm_usuario_p, 'C'),
				1,
				nr_seq_agenda_w,
				nr_atendimento_w,
				ie_adep_w,
				cd_setor_prescr_w,
				coalesce(cd_setor_atendimento_ww,cd_setor_prescr_w));
			commit;
			
			nr_prescricao_p := nr_prescricao_w;		
		end if;
		
		end;
	end if;

	select count(*)
	into STRICT qt_existe_w
	from prescr_material
	where nr_prescricao = nr_prescricao_w
	and cd_material = cd_material_w
	and cd_fornec_consignado = cd_cnpj_w;

	if (coalesce(qt_existe_w,0) > 0) then
		begin
		
		select nr_sequencia
		into STRICT nr_seq_prescr_material_w
		from prescr_material
		where nr_prescricao = nr_prescricao_w
		and cd_material = cd_material_w
		and cd_fornec_consignado = cd_cnpj_w;
		
		update 	prescr_material
		set	ie_origem_inf = ie_origem_inf_w,
			cd_unidade_medida = cd_unidade_medida_w,
			qt_unitaria = qt_material_p,
			qt_material = qt_material_p,
			cd_motivo_baixa = 0,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p,
			qt_dose = qt_material_p,
			nr_ocorrencia = 1,
			qt_total_dispensar = qt_material_p,
			nr_seq_marca = substr(obter_marca_material(cd_material_w,'C'),1,20),
			ds_observacao = ds_observacao_p
		where nr_prescricao = nr_prescricao_w
			and cd_material = cd_material_w
			and cd_fornec_consignado = cd_cnpj_w;
		
		end;
	elsif (coalesce(qt_existe_w,0) = 0) then
		begin
		
		select nextval('prescr_material_seq')
		into STRICT nr_seq_prescr_material_w
		;

		select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_w,'UMS'),1,30) cd_unidade_medida_consumo
		into STRICT	cd_unidade_medida_w
		from	material
		where	cd_material = cd_material_w;

		select 	max(cd_intervalo)
		into STRICT	cd_intervalo_w
		from 	intervalo_prescricao
		where 	ie_agora = 'S';

		insert into prescr_material(nr_prescricao,			nr_sequencia,
			ie_origem_inf,			cd_material,
			cd_unidade_medida,		qt_unitaria,
			qt_material,			cd_motivo_baixa,
			ie_status_cirurgia,		cd_intervalo,
			dt_atualizacao,			nm_usuario,
			cd_fornec_consignado,		qt_dose,
			nr_ocorrencia,			qt_total_dispensar,
			ds_horarios,			dt_baixa,
			ie_utiliza_kit,			cd_unidade_medida_dose,
			qt_conversao_dose,		ie_urgencia,
			nr_sequencia_solucao,		nr_sequencia_proc,
			qt_solucao,			hr_dose_especial,
			qt_dose_especial,		ds_dose_diferenciada,
			ie_medicacao_paciente,		nr_sequencia_diluicao,
			nr_seq_marca,			ds_observacao)
		values (nr_prescricao_w,		nr_seq_prescr_material_w,
			ie_origem_inf_w,		cd_material_w,
			cd_unidade_medida_w,		qt_material_p,
			qt_material_p,			0,
			/* estagio item cirurgia (GI - Gerado - CB - Consistido Barras AD - Material Adicional - EX - Executado - PE - Prescr Emergencia) */

			'GI', 				cd_intervalo_w,
			clock_timestamp(),			nm_usuario_p,
			cd_cnpj_w,			qt_material_p,
			1,				qt_material_p,
			null,				null,
			'N',				null,
			null,				'N',
			null,				null,
			null,				null,
			null,				null,
			'N',				null,
			substr(obter_marca_material(cd_material_w,'C'),1,20),			ds_observacao_p);
		end;
	end if;

	select count(*)
	into STRICT qt_existe_w
	from prescr_mat_desc_material
	where  nr_cirurgia = nr_cirurgia_w
	and (Elimina_Acentuacao(ds_material) = (SELECT Elimina_Acentuacao(ds_material) from material where cd_material = cd_material_w)
		or Elimina_Acentuacao(ds_material) = (select Elimina_Acentuacao(ds_reduzida) from material where cd_material = cd_material_w)
	);
	
	if (coalesce(qt_existe_w,0) > 0) then
	
		delete from prescr_mat_desc_material
		where  nr_cirurgia = nr_cirurgia_w
		and (Elimina_Acentuacao(ds_material) = (SELECT Elimina_Acentuacao(ds_material) from material where cd_material = cd_material_w)
			or Elimina_Acentuacao(ds_material) = (select Elimina_Acentuacao(ds_reduzida) from material where cd_material = cd_material_w)
		);
		
	end if;
	
	end;
end if;

/* atualiza cot_compra baseado nos valores de entrada desta procedure */

	
select	coalesce(max(nr_cot_compra),0)
into STRICT	nr_cot_compra_w
from	cot_compra
where	nr_seq_agenda_pac = nr_seq_agenda_w;

if (nr_cot_compra_w > 0) then
	select	cd_estabelecimento
	into STRICT	cd_estabelecimento_w
	from	cot_compra
	where	nr_cot_compra = nr_cot_compra_w;

	select	cd_moeda_padrao,
		cd_condicao_pagamento_padrao,
		coalesce(cd_tipo_pessoa_bionexo,0)
	into STRICT	cd_moeda_w,
		cd_condicao_pagto_w,
		cd_tipo_pessoa_w
	from	parametro_compras
	where	cd_estabelecimento = cd_estabelecimento_w;
	
	select	count(*)
	into STRICT	qt_existe_w
	from	pessoa_juridica
	where	cd_cgc = cd_cnpj_w;

	if (qt_existe_w = 0) then	

		if (cd_tipo_pessoa_w = 0) then	
			select	min(cd_tipo_pessoa)
			into STRICT	cd_tipo_pessoa_w
			from	pessoa_juridica
			where	ie_situacao = 'A';
		end if;
	
		select	coalesce(cd_cep,0),
			coalesce(sg_estado,'SP')
		into STRICT	cd_cep_w,
			sg_estado_w
		from	pessoa_juridica
		where	cd_cgc = obter_cgc_estabelecimento(cd_estabelecimento_w);
		
		insert into pessoa_juridica(
			cd_cgc,
			ds_razao_social,
			nm_fantasia,
			cd_cep,
			ds_endereco,
			ds_municipio,
			sg_estado,
			dt_atualizacao,
			nm_usuario,
			cd_tipo_pessoa,
			ie_prod_fabric,
			ie_situacao,
			dt_atualizacao_nrec,
			nm_usuario_nrec)
		values (	cd_cnpj_w,
			substr(ds_razao_social_p,1,255),
			substr(nm_fantasia_p,1,255),
			cd_cep_w,
			wheb_mensagem_pck.get_texto(802243),
			wheb_mensagem_pck.get_texto(802243),
			sg_estado_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_tipo_pessoa_w,
			'N',
			'A',
			clock_timestamp(),
			nm_usuario_p);
			
		open C02;
		loop
		fetch C02 into	
			cd_estab_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			
			insert into pessoa_juridica_estab(
				nr_sequencia,
				cd_cgc,
				cd_estabelecimento,
				dt_atualizacao,
				nm_usuario,
				ie_conta_dif_nf,
				ie_rateio_adiant,
				ie_retem_iss)
			values (	nextval('pessoa_juridica_estab_seq'),
				cd_cnpj_w,
				cd_estab_w,
				clock_timestamp(),
				nm_usuario_p,
				'N',
				'P',
				'N');	
			end;
		end loop;
		close C02;
	
		select	obter_classif_comunic('F')
		into STRICT	nr_seq_classif_w
		;

		ds_titulo_w	:= 	WHEB_MENSAGEM_PCK.get_texto(302769);
		ds_comunicado_w	:= 	WHEB_MENSAGEM_PCK.get_texto(302770,'NR_COT_COMPRA_W=' || nr_cot_compra_w || ';' || 'CD_CNPJ_W=' || cd_cnpj_w || ';' ||
									'DS_RAZAO_SOCIAL_P=' || substr(ds_razao_social_p,1,80));
	
		insert	into comunic_interna(
			dt_comunicado,		ds_titulo,			ds_comunicado,
			nm_usuario,		dt_atualizacao,			ie_geral,
			nm_usuario_destino,	nr_sequencia,			ie_gerencial,
			nr_seq_classif,		dt_liberacao)
		values (	clock_timestamp(),		ds_titulo_w,			ds_comunicado_w,
			nm_usuario_p,		clock_timestamp(),			'N',
			nm_usuario_p,		nextval('comunic_interna_seq'),	'N',
			nr_seq_classif_w,	clock_timestamp());
	end if;	

	if (cd_cnpj_w <> '0') and (ie_opcao_p = 0) then

		ds_forma_pagto_fornec_w := '';
		
		select	max(cd_interno)
		into STRICT	ds_forma_pagto_fornec_w
		from	conversao_meio_externo
		where	upper(nm_tabela) = 'CONDICAO_PAGAMENTO'
		and	upper(nm_atributo) = 'CD_CONDICAO_PAGAMENTO'
		and	ie_sistema_externo = 'B'
		and	cd_externo = ds_forma_pagamento_p;
	
		select	coalesce(max(cd_condicao_pagamento),cd_condicao_pagto_w)
		into STRICT	cd_condicao_pagto_w
		from	condicao_pagamento
		where	upper(cd_condicao_pagamento) = upper(coalesce(ds_forma_pagto_fornec_w,ds_forma_pagamento_p));
		
		select	nextval('cot_compra_forn_seq')
		into STRICT	nr_seq_cot_fornecedor_w
		;

		insert	into cot_compra_forn(
			nr_sequencia,
			nr_cot_compra,
			cd_cgc_fornecedor,
			dt_atualizacao,
			nm_usuario,
			ds_observacao,
			cd_moeda,
			cd_condicao_pagamento,
			ie_frete,
			ie_gerado_bionexo,
			ie_status_envio_email_lib)
		values (	nr_seq_cot_fornecedor_w,
			nr_cot_compra_w,
			cd_cnpj_w,
			clock_timestamp(),
			nm_usuario_p,
			ds_forma_pagamento_p,
			cd_moeda_w, 
			cd_condicao_pagto_w,
			'C',
			'X',
			'N');
	end if;
	
	if (cd_cnpj_w <> '0') and (ie_opcao_p = 1) then
		
		select	dt_retorno_prev + coalesce(prazo_entrega_p,0)
		into STRICT	dt_retorno_prev_w
		from	cot_compra
		where	nr_cot_compra = nr_cot_compra_w;
		
		select	coalesce(max(nr_item_cot_compra),0) +1
		into STRICT	nr_item_cot_compra_w
		from	cot_compra_item
		where	nr_cot_compra = nr_cot_compra_w;
		
		insert into cot_compra_item(		
			nr_cot_compra,
			nr_item_cot_compra,
			cd_material,
			qt_material,
			cd_unidade_medida_compra,
			dt_atualizacao,
			dt_limite_entrega,
			nm_usuario,
			ie_situacao)
		values (	nr_cot_compra_w,
			nr_item_cot_compra_w,
			cd_material_w,
			replace(qt_material_p,'.',','),
			obter_dados_material(cd_material_w,'UMP'),
			clock_timestamp(),
			dt_retorno_prev_w,
			nm_usuario_p,
			'A');
			
		insert into cot_compra_item_entrega(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_cot_compra,
			nr_item_cot_compra,
			dt_entrega,
			qt_entrega)
		values (	nextval('cot_compra_item_entrega_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_cot_compra_w,
			nr_item_cot_compra_w,
			dt_retorno_prev_w,
			replace(qt_material_p,'.',','));	
	
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_fornec_w
		from	cot_compra_forn
		where	nr_cot_compra = nr_cot_compra_w
		and	cd_cgc_fornecedor = cd_cnpj_w;
		
		if (nr_seq_fornec_w > 0) then
		
			select	coalesce(min(a.nr_item_cot_compra),0)
			into STRICT	nr_item_cotacao_w
			from	cot_compra_item a
			where	a.nr_cot_compra	= nr_cot_compra_w
			and	a.cd_material = cd_material_w;		
		
			if (nr_item_cotacao_w = 0) then
				select	coalesce(min(a.nr_item_cot_compra),0)
				into STRICT	nr_item_cotacao_w
				from	cot_compra_item a,
					cot_compra_item_aceite b
				where	a.nr_cot_compra = b.nr_cot_compra
				and	a.nr_item_cot_compra = b.nr_item_cot_compra
				and	a.nr_cot_compra	= nr_cot_compra_w
				and	b.cd_material = cd_material_w;
			end if;
		
			update	cot_compra_item
			set	ie_situacao = 'A'
			where	nr_cot_compra = nr_cot_compra_w
			and	nr_item_cot_compra = nr_item_cotacao_w
			and	coalesce(ie_situacao,'A') <> 'A';
		
			select	nextval('cot_compra_forn_item_seq')
			into STRICT	nr_sequencia_item_w
			;
			
			begin
				vl_total_w 	:= (REPLACE(vl_total_p, '.', ''))::numeric;
			exception when others then
				vl_total_w := (REPLACE(REPLACE(vl_total_p, '.', ''), ',', '.'))::numeric;
			end;

			insert into cot_compra_forn_item(
				nr_sequencia,
				nr_seq_cot_forn,
				nr_cot_compra,
				nr_item_cot_compra,
				cd_cgc_fornecedor,
				qt_material,
				vl_unitario_material,
				dt_atualizacao,
				nm_usuario,
				vl_preco_liquido,
				vl_total_liquido_item,
				ie_situacao,
				ds_marca,
				ds_marca_fornec,
				cd_material)
			values (	nr_sequencia_item_w,
				nr_seq_fornec_w,
				nr_cot_compra_w,
				nr_item_cotacao_w,
				cd_cnpj_w,
				replace(qt_material_p,'.',','),
				replace(vl_unitario_w,'.',','),
				clock_timestamp(),
				nm_usuario_p,
				replace(vl_total_w,'.',','),
				replace(vl_total_w,'.',','),
				'A',
				substr(obter_marca_material(cd_material_w,'C'),1,30),
				substr(obter_marca_material(cd_material_w,'C'),1,30),
				cd_material_w);
		end if;
	end if;
else	
	ds_erro_p := 'Nao foi encontrada cotacao de compra vinculada ao agendamento da cirurgia';
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE import_itens_intgr_prescr_opme (id_pedido_p bigint, nm_usuario_p text, cd_material_p text, qt_material_p bigint, vl_unitario_p text, vl_total_p text, ds_observacao_p text, cd_cnpj_p text, ds_razao_social_p text, ie_opcao_p text, prazo_entrega_p bigint, nm_fantasia_p text, ds_forma_pagamento_p text, ie_origem_inf_p text, nr_prescricao_p INOUT bigint, ds_erro_p INOUT text) FROM PUBLIC;
