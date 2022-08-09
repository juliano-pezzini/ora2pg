-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos_kit_gerar AS (nr_seq_kit_pda		bigint,
		cd_material		integer,
		qt_material		double precision,
		cd_unidade_medida	varchar(30),
		ie_via_aplicacao	varchar(5),		
		nr_seq_lote_fornec	bigint,
		cd_kit_material		integer,
		cd_local_estoque	smallint);


CREATE OR REPLACE PROCEDURE gerar_kit_estoque ( nr_seq_kit_estoque_p bigint, nr_atendimento_p bigint, nr_seq_atepacu_p bigint, ie_local_estoque_p text, ie_baixa_sem_estoque_p text, nm_usuario_p text, cd_local_estoque_p bigint, ds_retorno_p INOUT text, dt_base_p timestamp, nr_doc_interno_p bigint, ie_forma_geracao_p text, ie_gerar_novo_kit_p text, nr_seq_comp_p bigint default null, qt_material_p bigint default null, cd_medico_prescritor_p text default null, nr_prescricao_p bigint default null) AS $body$
DECLARE

/*
ie_forma_geracao_p:
1 - Geracao normal pela funcao
2 - Geracao pelo PalmWeb (tabela temporaria) 
3 - Geracao pelo PalmWeb (baixa )   
4 - Geracao de componentes pela Exec Prescr
*/

--------------------------------------------------------------------------------------------------------
		
type Vetor_Kit_Gerar is
	table of campos_kit_gerar index by integer;
	
i				integer := 1;
j				integer := 1;
Vetor_Kit_Gerar_w		Vetor_Kit_Gerar;
--------------------------------------------------------------------------------------------------------
nr_sequencia_w			bigint;
cd_local_estoque_w		smallint;
cd_material_w			integer;
cd_convenio_w			integer;
cd_categoria_w			varchar(10);
qt_material_w			double precision;
cd_unidade_medida_w		varchar(30);
dt_entrada_unidade_w		timestamp;
ie_via_aplicacao_w			varchar(5);
cd_setor_atendimento_w		integer;
cd_setor_exclusivo_w		integer;
cd_pessoa_fisica_w		bigint;
cd_perfil_w			bigint;
ds_observacao_w			varchar(2000);
nr_doc_convenio_w		varchar(20);
ie_tipo_guia_w			varchar(2);
cd_senha_w			varchar(20);
nr_seq_lote_fornec_w		bigint;
cd_kit_material_w			integer;
cd_local_estoque_ww		smallint;
ds_erro_w			varchar(255);
ie_local_estoque_w			varchar(255);
cd_setor_usuario_w			integer;
ie_estoque_disp_w			varchar(1);
cd_estabelecimento_w		smallint;
ie_gerou_item_w			varchar(1);
dt_utilizacao_w			timestamp;
ie_existe_w			varchar(1);
ie_forma_geracao_w		varchar(1);
nr_seq_atepacu_w			bigint;
ds_retorno_reg_kit_w		varchar(255);
ds_retorno_kit_w			varchar(255);

ds_local_estoque_w		varchar(40);
ds_material_w			varchar(255);

ds_consiste_saldo_w		varchar(4000);
ds_consiste_saldo_ww		varchar(4000);
ds_retorno_w			varchar(4000);
nr_sequencia_ww			bigint;
cd_funcao_w			bigint;
ie_lancto_auto_mat_w		varchar(1);
ie_gera_novo_kit_w		varchar(1);
nr_seq_comp_w			kit_estoque_comp.nr_sequencia%type;
qt_kit_w				double precision	:= 0;
qt_reg_kit_w			double precision;
qt_kit_avulso_w			double precision;
qt_conv_estoque_w		double precision;
qt_saldo_w			double precision;
ie_disp_comp_kit_estoque_w		varchar(1);
ie_disp_reg_kit_estoque_w		varchar(1);
ie_gerado_barras_w		varchar(1);
NR_SEQ_ITEM_KIT_w		kit_estoque_comp.NR_SEQ_ITEM_KIT%type;
ie_consiste_lanc_sem_saldo_w	varchar(1);
cd_estabelecimento_logado_w	estabelecimento.cd_estabelecimento%type;
cd_estab_estoque_w		estabelecimento.cd_estabelecimento%type;
ie_estab_movto_w		parametro_estoque.ie_estab_movimento%type;
ie_utiliza_dt_alta_w		varchar(1) := 'N';
dt_lancamento_w			timestamp := dt_base_p;

c01 CURSOR FOR
SELECT	0 nr_sequencia,
	a.cd_material,
	a.qt_material,
	substr(obter_dados_material_estab(d.cd_material,cd_estabelecimento_w,'UMS'),1,30) cd_unidade_medida_consumo,
	d.ie_via_aplicacao,		
	a.nr_seq_lote_fornec,
	b.cd_kit_material,
	b.cd_setor_exclusivo,
	a.ie_gerado_barras,
	a.NR_SEQ_ITEM_KIT
from	material d,
	kit_estoque b,
	kit_estoque_comp a
where (b.nr_sequencia 	= a.nr_seq_kit_estoque)
and (a.cd_material		= d.cd_material)
and (a.nr_seq_kit_estoque 	= nr_seq_kit_estoque_p)
and (d.ie_situacao		= 'A')
and	ie_forma_geracao_w in ('1','2','4')
and	((nr_seq_comp_w = 0) or (a.nr_sequencia = nr_seq_comp_w))
and (coalesce(a.ie_gerado_barras,'N') <> 'E')

union all

SELECT	a.nr_sequencia,
	a.cd_material,
	a.qt_material,
	a.cd_unidade_medida cd_unidade_medida_consumo,
	a.ie_via_aplicacao,
	a.nr_seq_lote_fornec,
	a.cd_kit_material,
	null,
	null,
	null
from	w_kit_estoque_comp_pda a
where (a.nr_seq_kit_estoque 	= nr_seq_kit_estoque_p)
and	a.nm_usuario 		= nm_usuario_p
and	ie_forma_geracao_w	= '3';


BEGIN

nr_seq_comp_w := coalesce(nr_seq_comp_p,0);
cd_pessoa_fisica_w := obter_pessoa_fisica_usuario(wheb_usuario_pck.get_nm_usuario,'C');

cd_estabelecimento_logado_w             := wheb_usuario_pck.get_cd_estabelecimento;

select  max(IE_ESTAB_MOVIMENTO)
into STRICT    ie_estab_movto_w
from    parametro_estoque
where   cd_estabelecimento              = cd_estabelecimento_logado_w;

cd_estab_estoque_w       := null;

if (ie_estab_movto_w       = 'N') then
        cd_estab_estoque_w       := cd_estabelecimento_logado_w;
end if;

if (coalesce(cd_estab_estoque_w::text, '') = '') then
	select	max(cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from 	atendimento_paciente
	where 	nr_atendimento = nr_atendimento_p;
else
	cd_estabelecimento_w	:= cd_estab_estoque_w;
end if;

ie_gera_novo_kit_w := 'N';
if (coalesce(ie_gerar_novo_kit_p, 'S') <> 'N') then
	ie_gera_novo_kit_w := substr(coalesce(obter_valor_param_usuario(24, 316, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N'),1,1);
end if;
ie_forma_geracao_w := substr(coalesce(ie_forma_geracao_p,'1'),1,1);

cd_perfil_w	:= obter_perfil_ativo;
cd_funcao_w	:= obter_funcao_ativa;

ds_observacao_w:= WHEB_MENSAGEM_PCK.get_texto(306764,'CD_PERFIL_W='|| CD_PERFIL_W ||';NR_SEQ_KIT_ESTOQUE_P='|| NR_SEQ_KIT_ESTOQUE_P); /*'Perfil: ' || cd_perfil_w || '  Kit de estoque: ' || nr_seq_kit_estoque_p ;*/
ie_local_estoque_w	:= elimina_acentuacao(upper(ie_local_estoque_p));
cd_setor_usuario_w	:= wheb_usuario_pck.get_cd_setor_atendimento;


if (coalesce(cd_setor_usuario_w,0)	<= 0) then
	cd_setor_usuario_w	:= null;
end if;

nr_seq_atepacu_w := nr_seq_atepacu_p;

if (ie_forma_geracao_w in ('2','3','4')) then
	select	max(coalesce(nr_seq_atepacu,0))
	into STRICT	nr_seq_atepacu_w
	from	atendimento_paciente_v
	where	nr_atendimento = nr_atendimento_p;
end if;

select 	dt_entrada_unidade,
	cd_setor_atendimento,
	obter_convenio_atendimento(nr_atendimento)
into STRICT	dt_entrada_unidade_w,
	cd_setor_atendimento_w,
	cd_convenio_w
from 	atend_paciente_unidade
where 	nr_atendimento = nr_atendimento_p
and 	nr_seq_interno = nr_seq_atepacu_w;

select	max(cd_categoria)
into STRICT	cd_categoria_w
from 	Atend_categoria_convenio a
where 	a.nr_atendimento	= nr_atendimento_p
and 	a.cd_convenio 		= cd_convenio_w
and 	a.dt_inicio_vigencia	= (	SELECT 	max(dt_inicio_vigencia)
					from 	Atend_categoria_convenio b
					where 	nr_atendimento = nr_atendimento_p
					and 	b.cd_convenio = cd_convenio_w);
					
select	coalesce(max(ie_disp_comp_kit_estoque), 'N'),
		coalesce(max(ie_disp_reg_kit_estoque), 'N')
into STRICT	ie_disp_comp_kit_estoque_w,
		ie_disp_reg_kit_estoque_w
from	parametro_estoque
where	cd_estabelecimento = cd_estabelecimento_w;

select	coalesce(max(qt_conv_estoque_consumo),1)
into STRICT	qt_conv_estoque_w
from	material
where	cd_material = cd_material_w;

ie_consiste_lanc_sem_saldo_w	:= coalesce(obter_valor_param_usuario(24, 311, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w),'N');
ie_lancto_auto_mat_w		:= coalesce(obter_valor_param_usuario(24, 313, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w),'N');
ie_utiliza_dt_alta_w 		:= coalesce(obter_valor_param_usuario(24, 55, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N');

begin
select 	max(nr_doc_convenio),
	max(ie_tipo_guia),
	max(cd_senha)
into STRICT	nr_doc_convenio_w,
	ie_tipo_guia_w,
	cd_senha_w
from 	atend_categoria_convenio
where 	nr_atendimento = nr_atendimento_p
and 	cd_categoria = cd_categoria_w
and 	cd_convenio  = cd_convenio_w
and 	dt_inicio_vigencia = 	(SELECT	max(dt_inicio_vigencia)
				from	atend_categoria_convenio b
				where	nr_atendimento = nr_atendimento_p
				and 	b.cd_convenio  = cd_convenio_w
				and 	b.cd_categoria = cd_categoria_w);
exception
	when others then
		nr_doc_convenio_w	:= '';
		cd_senha_w		:= '';
		ie_tipo_guia_w		:= '';
end;

cd_local_estoque_w	:= cd_local_estoque_p;

ds_erro_w		:= '';
ds_consiste_saldo_w	:= '';
ie_gerou_item_w		:= 'N';
ie_existe_w		:= 'S';
dt_utilizacao_w		:= null;

select	max(dt_utilizacao),
	coalesce(max('S'),'N')
into STRICT	dt_utilizacao_w,
	ie_existe_w
from	kit_estoque
where	nr_sequencia = nr_seq_kit_estoque_p;

if (ie_forma_geracao_w <> '3') and (coalesce(dt_utilizacao_w::text, '') = '') then
	begin
	select	CASE WHEN count(*)=0 THEN null  ELSE clock_timestamp() END
	into STRICT	dt_utilizacao_w
	from	w_kit_estoque_comp_pda
	where	nr_seq_kit_estoque = nr_seq_kit_estoque_p;
	end;
end if;

if (coalesce(ie_utiliza_dt_alta_w,'N') = 'S') and (cd_funcao_w = 24) then
	dt_lancamento_w := coalesce(obter_dados_atendimento_dt(nr_atendimento_p, 'DA'), dt_base_p);
end if;

if (ie_existe_w = 'N') then
	ds_erro_w := substr(Wheb_mensagem_pck.get_Texto(306766, 'NR_SEQ_KIT_ESTOQUE_P='|| NR_SEQ_KIT_ESTOQUE_P),1,255); /*Kit de estoque numero #@NR_SEQ_KIT_ESTOQUE_P#@ nao encontrado.*/
elsif (dt_utilizacao_w IS NOT NULL AND dt_utilizacao_w::text <> '') then
	ds_erro_w := substr(Wheb_mensagem_pck.get_Texto(306767, 'NR_SEQ_KIT_ESTOQUE_P='|| NR_SEQ_KIT_ESTOQUE_P),1,255); /*kit de estoque numero #@NR_SEQ_KIT_ESTOQUE_P#@ ja foi utilizado.*/
else
	begin
	open c01;
	loop
	fetch c01 into
		nr_sequencia_ww,
		cd_material_w,
		qt_material_w,
		cd_unidade_medida_w,
		ie_via_aplicacao_w,		
		nr_seq_lote_fornec_w,
		cd_kit_material_w,
		cd_setor_exclusivo_w,
		ie_gerado_barras_w,
		NR_SEQ_ITEM_KIT_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		if (nr_seq_comp_w > 0) and (qt_material_p > 0) then
			qt_material_w := qt_material_p;
		end if;
		
		if (coalesce(cd_setor_exclusivo_w,0) > 0) and (coalesce(cd_setor_atendimento_w,0) > 0) and (cd_setor_exclusivo_w <> cd_setor_atendimento_w) then
			ds_erro_w := substr(WHEB_MENSAGEM_PCK.get_texto(306768,'NR_SEQ_KIT_ESTOQUE_P='|| NR_SEQ_KIT_ESTOQUE_P ||';CD_SETOR_EXCLUSIVO_W='|| CD_SETOR_EXCLUSIVO_W ||';CD_SETOR_ATENDIMENTO_W='|| CD_SETOR_ATENDIMENTO_W),1,255);
					/*O setor exclusivo do kit de estoque numero #@NR_SEQ_KIT_ESTOQUE_P#@ (#@CD_SETOR_EXCLUSIVO_W#@) difere do setor da execucao (#@CD_SETOR_ATENDIMENTO_W#@). O kit nao sera lancado.*/

		end if;
		
		ie_estoque_disp_w	:= 'N';
		cd_local_estoque_ww	:= cd_local_estoque_w;
				
		if (obter_se_matkit_baixa_estoque(cd_material_w, cd_kit_material_w, NR_SEQ_ITEM_KIT_w) = 'N') then
			cd_local_estoque_ww	:= null;
		end if;
		
		if (cd_local_estoque_ww IS NOT NULL AND cd_local_estoque_ww::text <> '') then
			ie_estoque_disp_w := obter_disp_estoque(cd_material_w, (cd_local_estoque_w)::numeric , cd_estabelecimento_w, 0, qt_material_w, '', ie_estoque_disp_w);
			
			if (ie_estoque_disp_w = 'N') and (ie_disp_comp_kit_estoque_w in ('S','C'))then
				begin
				qt_saldo_w 	:=	obter_saldo_disp_estoque(cd_estabelecimento_w, cd_material_w, cd_local_estoque_w, trunc(clock_timestamp(),'mm'));										
				qt_kit_w	:=	dividir(coalesce(qt_material_w,0) , coalesce(qt_conv_estoque_w,1));
				
				if (ie_disp_comp_kit_estoque_w = 'S') or
					(ie_disp_comp_kit_estoque_w = 'C' AND ie_gerado_barras_w = 'S') then
					begin
					qt_saldo_w := qt_saldo_w + qt_kit_w;
					
					if (qt_saldo_w >= qt_kit_w) then
						ie_estoque_disp_w := 'S';
					end if;
					end;
				end if;
				end;
			end if;
			if (ie_estoque_disp_w = 'N') and (ie_disp_reg_kit_estoque_w = 'S') then
				
				select	coalesce(sum(a.qt_material),0)
				into STRICT	qt_reg_kit_w
				from	kit_estoque_reg c,
					kit_estoque b,
					material x,
					kit_estoque_comp a
				where	c.nr_sequencia		= b.nr_seq_reg_kit
				and	a.nr_seq_kit_estoque	= b.nr_sequencia
				and	a.cd_material 		= x.cd_material
				and	x.cd_material_estoque	= cd_material_w
				and	b.cd_local_estoque		= cd_local_estoque_w
				and	b.cd_estabelecimento	= cd_estabelecimento_w
				and	a.ie_gerado_barras		= 'S'
				and	coalesce(a.nr_seq_motivo_exclusao::text, '') = ''
				and	coalesce(b.dt_utilizacao::text, '') = ''
				and	c.ie_situacao		= 'A'
				and	coalesce(c.dt_utilizacao::text, '') = '';

				select	coalesce(sum(a.qt_material),0)
				into STRICT	qt_kit_avulso_w
				from	kit_estoque_reg b,
					material x,
					kit_estoque_comp_avulso a
				where	b.nr_sequencia		= a.nr_seq_reg_kit
				and	x.cd_material		= a.cd_material
				and	a.cd_local_estoque		= cd_local_estoque_w
				and	b.cd_estabelecimento	= cd_estabelecimento_w
				and	x.cd_material_estoque	= cd_material_w
				and	b.ie_situacao		= 'A'
				and	a.ie_gerado_barras		= 'S'
				and	coalesce(b.dt_utilizacao::text, '') = '';
					
				if (qt_kit_avulso_w + qt_reg_kit_w > 0) then
					ie_estoque_disp_w := 'S';
				end if;
			end if;
		end if;
		
		if 	((ie_baixa_sem_estoque_p = 'S') or (coalesce(cd_local_estoque_ww::text, '') = '') or (ie_estoque_disp_w = 'S')) then
			begin
			if (coalesce(ds_erro_w, 'X') = 'X') then
				begin
				if (ie_consiste_lanc_sem_saldo_w = 'S') then
			
					i	:= coalesce(Vetor_Kit_Gerar_w.Count,0) + 1;
			
					Vetor_Kit_Gerar_w[i].nr_seq_kit_pda  	:= nr_sequencia_ww;
					Vetor_Kit_Gerar_w[i].cd_material  	:= cd_material_w;
					Vetor_Kit_Gerar_w[i].qt_material	:= qt_material_w;
					Vetor_Kit_Gerar_w[i].cd_unidade_medida  := cd_unidade_medida_w;
					Vetor_Kit_Gerar_w[i].ie_via_aplicacao  	:= ie_via_aplicacao_w;
					Vetor_Kit_Gerar_w[i].nr_seq_lote_fornec	:= nr_seq_lote_fornec_w;
					Vetor_Kit_Gerar_w[i].cd_kit_material  	:= cd_kit_material_w;
					Vetor_Kit_Gerar_w[i].cd_local_estoque  	:= cd_local_estoque_ww;
					
					ie_gerou_item_w := 'S';
				
				elsif (ie_forma_geracao_w <> '2') then
					begin
					select	nextval('material_atend_paciente_seq')
					into STRICT	nr_sequencia_w
					;				
					
					begin	
					insert into material_atend_paciente(
						nr_sequencia     	,
						nr_atendimento          ,       
						dt_entrada_unidade      ,       
						cd_material             ,       
						cd_material_exec        ,
						dt_conta                ,       
						dt_atendimento          ,       
						qt_material             ,       
						qt_executada            ,       
						dt_atualizacao          ,       
						nm_usuario              ,       
						cd_unidade_medida   	,           
						cd_convenio             ,       
						cd_categoria            ,       
						cd_acao 	                ,       
						cd_local_estoque	,               
						cd_setor_atendimento    ,       
						ie_valor_informado      ,       
						nm_usuario_original     ,       
						cd_setor_receita	,
						cd_situacao_glosa	,
						nr_seq_atepacu		,
						ie_auditoria		,
						ie_via_aplicacao	,
						ds_observacao		,
						ie_guia_informada	,
						ie_tipo_guia		,
						nr_doc_convenio		,
						nr_seq_lote_fornec	,
						cd_senha		,
						nr_seq_kit_estoque	,
						nr_doc_interno		,
						nr_seq_cor_exec	,
						cd_medico_prescritor,
						nr_prescricao)
					values (nr_sequencia_w  	,              
						nr_atendimento_p        ,       
						dt_entrada_unidade_w    ,       
						cd_material_w           ,       
						cd_material_w		,
						coalesce(dt_lancamento_w,clock_timestamp())	,       
						coalesce(dt_lancamento_w,clock_timestamp())	,  
						qt_material_w		,       
						qt_material_w	      	,       
						clock_timestamp()                 ,       
						nm_usuario_p            ,       
						cd_unidade_medida_w	,
						cd_convenio_w           ,       
						cd_categoria_w          ,       
						'1'			,       
						cd_local_estoque_ww     ,       
						cd_setor_atendimento_w  ,       
						'N'			,       
						nm_usuario_p            ,       
						cd_setor_atendimento_w  ,
						0			,
						nr_seq_atepacu_w	,
						'N'			,
						ie_via_aplicacao_w	,
						ds_observacao_w		,
						'N'			,
						ie_tipo_guia_w		,
						null,
						nr_seq_lote_fornec_w	,
						cd_senha_w		,
						nr_seq_kit_estoque_p	,
						nr_doc_interno_p	,
						4522			,
						cd_medico_prescritor_p,
						nr_prescricao_p);
						/*SO2879465 ajuste efetuando o commit a cada insercao na conta. 
						Desta forma, evitando deadlock no update da tabela saldo_estoque (atualizar_saldo)*/
						if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
					exception
						when 	others then
						begin
						ds_erro_w	:= substr(sqlerrm,1,255);
						nr_sequencia_w	:= 0;
						end;
					end;				
				
					if (nr_sequencia_w > 0) then
						begin
						update	material_atend_paciente /*apos inserir deve atualizar o campo 'Kit' para nao ocorrer problemas nas rotinas da conta*/
						set	cd_kit_material	= cd_kit_material_w
						where	nr_sequencia	= nr_sequencia_w;
						
						if (ie_forma_geracao_w = '3') then
							update	w_kit_estoque_comp_pda
							set	nr_seq_map = nr_sequencia_w
							where	nr_sequencia = nr_sequencia_ww;
						end if;
						
						CALL atualiza_preco_material(nr_sequencia_w, nm_usuario_p);
						
						if (ie_lancto_auto_mat_w = 'S') then
							CALL gerar_lanc_automatico_mat(nr_atendimento_p, cd_local_estoque_ww, 132, nm_usuario_p, nr_sequencia_w, null, null);
						end if;
						
						ie_gerou_item_w := 'S';
						end;
					end if;
					
					CALL gerar_autor_regra(nr_atendimento_p, nr_sequencia_w, null, null, null, null, 'EP', nm_usuario_p, null, null, null, null, null, null,'','','');
					end;
				else	
					begin					
					insert into w_kit_estoque_comp_pda(
						nr_sequencia,
						cd_material,
						qt_material,
						cd_unidade_medida,
						ie_via_aplicacao,
						nr_seq_lote_fornec,
						nr_Seq_kit_estoque,
						cd_kit_material,
						nm_usuario,
						nm_usuario_nrec,
						dt_atualizacao,
						dt_atualizacao_nrec)
					values (
						nextval('w_kit_estoque_comp_pda_seq'),
						cd_material_w           ,
						qt_material_w		,       
						cd_unidade_medida_w	,
						ie_via_aplicacao_w	,
						nr_seq_lote_fornec_w	,
						nr_seq_kit_estoque_p	,
						cd_kit_material_w,
						nm_usuario_p,
						nm_usuario_p,
						clock_timestamp(),
						clock_timestamp());
						
					ie_gerou_item_w := 'S';
					end;
				end if;
				end;
			end if;	
			end;
		else
			begin			
			select	max(ds_material)
			into STRICT	ds_material_w
			from	material
			where	cd_material = cd_material_w;
			
			ds_consiste_saldo_w := substr(ds_consiste_saldo_w || '['||cd_material_w||'] - ' || ds_material_w || '.' || chr(13) || chr(10),1,4000);
			ds_consiste_saldo_ww:= ds_consiste_saldo_w;	

			CALL gravar_log_tasy(5618, 'ie_baixa_sem_estoque_p='||ie_baixa_sem_estoque_p || ';cd_local_estoque_ww='||cd_local_estoque_ww ||
								';cd_material_w='|| cd_material_w || ';cd_kit_material_w='||cd_kit_material_w ||
								';NR_SEQ_ITEM_KIT_w='||NR_SEQ_ITEM_KIT_w ||';ie_estoque_disp_w='|| ie_estoque_disp_w||
								';ie_disp_comp_kit_estoque_w='||ie_disp_comp_kit_estoque_w || ';qt_saldo_w='||qt_saldo_w ||
								';qt_kit_w='||qt_kit_w ||';qt_reg_kit_w='||qt_reg_kit_w||';qt_kit_avulso_w='||qt_kit_avulso_w, substr(nr_atendimento_p, 1, 15));
			
			end;
		end if;
		end;
	end loop;
	close c01;
	
	if (coalesce(nr_sequencia_w,0) > 0) and (ie_forma_geracao_p = '1') and (cd_funcao_w = 24) and (coalesce(ie_gera_novo_kit_w,'S') <> 'N') and (nr_seq_comp_w = 0) then
		SELECT * FROM gerar_carrinho_kit_execucao(cd_estabelecimento_w, cd_pessoa_fisica_w, nm_usuario_p, cd_local_estoque_w, nr_seq_kit_estoque_p, null, ds_retorno_reg_kit_w, ds_retorno_kit_w) INTO STRICT ds_retorno_reg_kit_w, ds_retorno_kit_w;
	end if;
	end;
end if;

if (Vetor_Kit_Gerar_w.count > 0) and (coalesce(ds_consiste_saldo_w,'X') = 'X') then
	ie_gerou_item_w := 'N';
	
	for	j in 1..Vetor_Kit_Gerar_w.count loop
	
		if (ie_forma_geracao_w <> '2') then
			begin
			select	nextval('material_atend_paciente_seq')
			into STRICT	nr_sequencia_w
			;
			
			begin	
			insert into material_atend_paciente(
				nr_sequencia,
				nr_atendimento,
				dt_entrada_unidade,
				cd_material,
				cd_material_exec,
				dt_conta,
				dt_atendimento,
				qt_material,
				qt_executada,
				dt_atualizacao,
				nm_usuario,
				cd_unidade_medida,
				cd_convenio,
				cd_categoria,
				cd_acao,
				cd_local_estoque,
				cd_setor_atendimento,
				ie_valor_informado,
				nm_usuario_original,
				cd_setor_receita,
				cd_situacao_glosa,
				nr_seq_atepacu,
				ie_auditoria,
				ie_via_aplicacao,
				ds_observacao,
				ie_guia_informada,
				ie_tipo_guia,
				nr_doc_convenio,
				nr_seq_lote_fornec,
				cd_senha,
				nr_seq_kit_estoque,
				nr_doc_interno,
				nr_seq_cor_exec,
				cd_medico_prescritor)
			values (nr_sequencia_w,
				nr_atendimento_p,
				dt_entrada_unidade_w,
				Vetor_Kit_Gerar_w[j].cd_material,
				Vetor_Kit_Gerar_w[j].cd_material,
				coalesce(dt_lancamento_w,clock_timestamp()),
				coalesce(dt_lancamento_w,clock_timestamp()),
				Vetor_Kit_Gerar_w[j].qt_material,
				Vetor_Kit_Gerar_w[j].qt_material,
				clock_timestamp(),
				nm_usuario_p,
				Vetor_Kit_Gerar_w[j].cd_unidade_medida,
				cd_convenio_w,
				cd_categoria_w,
				'1',
				Vetor_Kit_Gerar_w[j].cd_local_estoque,
				cd_setor_atendimento_w,
				'N',
				nm_usuario_p,
				cd_setor_atendimento_w,
				0,
				nr_seq_atepacu_w,
				'N',
				Vetor_Kit_Gerar_w[j].ie_via_aplicacao,
				ds_observacao_w,
				'N',
				ie_tipo_guia_w,
				null,
				Vetor_Kit_Gerar_w[j].nr_seq_lote_fornec,
				cd_senha_w,
				nr_seq_kit_estoque_p,
				nr_doc_interno_p,
				4522,
				cd_medico_prescritor_p);
				/*SO2879465 ajuste efetuando o commit a cada insercao na conta. 
				Desta forma, evitando deadlock no update da tabela saldo_estoque (atualizar_saldo)*/
				if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
			exception
				when 	others then
				begin
				ds_erro_w	:= substr(sqlerrm,1,255);
				nr_sequencia_w	:= 0;
				end;
			end;
		
			if (nr_sequencia_w > 0) then
				begin
				update	material_atend_paciente /*apos inserir deve atualizar o campo 'Kit' para nao ocorrer problemas nas rotinas da conta*/
				set	cd_kit_material	= Vetor_Kit_Gerar_w[j].cd_kit_material
				where	nr_sequencia	= nr_sequencia_w;
				
				if (ie_forma_geracao_w = '3') then
					update	w_kit_estoque_comp_pda
					set	nr_seq_map = nr_sequencia_w
					where	nr_sequencia = Vetor_Kit_Gerar_w[i].nr_seq_kit_pda;
				end if;
				
				CALL atualiza_preco_material(nr_sequencia_w, nm_usuario_p);
				
				if (ie_lancto_auto_mat_w = 'S') then
					CALL gerar_lanc_automatico_mat(nr_atendimento_p, Vetor_Kit_Gerar_w[j].cd_local_estoque, 132, nm_usuario_p, nr_sequencia_w, null, null);
				end if;
				
				ie_gerou_item_w := 'S';
				end;
			end if;
			
			CALL gerar_autor_regra(nr_atendimento_p, nr_sequencia_w, null, null, null, null, 'EP', nm_usuario_p, null, null, null, null, null, null,'','','');
			end;
		else	
			begin
			insert into w_kit_estoque_comp_pda(
				nr_sequencia,
				cd_material,
				qt_material,
				cd_unidade_medida,
				ie_via_aplicacao,
				nr_seq_lote_fornec,
				nr_Seq_kit_estoque,
				cd_kit_material,
				nm_usuario,
				nm_usuario_nrec,
				dt_atualizacao,
				dt_atualizacao_nrec)
			values (
				nextval('w_kit_estoque_comp_pda_seq'),
				Vetor_Kit_Gerar_w[j].cd_material,
				Vetor_Kit_Gerar_w[j].qt_material,
				Vetor_Kit_Gerar_w[j].cd_unidade_medida,
				Vetor_Kit_Gerar_w[j].ie_via_aplicacao,
				Vetor_Kit_Gerar_w[j].nr_seq_lote_fornec,
				nr_seq_kit_estoque_p,
				Vetor_Kit_Gerar_w[j].cd_kit_material,
				nm_usuario_p,
				nm_usuario_p,
				clock_timestamp(),
				clock_timestamp());
				
			ie_gerou_item_w := 'S';
			end;
		end if;
		
	end loop;
end if;

/* colocado por fabio e jonas, estorna o lancamento dos itens, caso em que o ultimo item nao tenha estoque, por exemplo*/

if (coalesce(ds_erro_w, 'X') <> 'X') then
	begin
	ie_gerou_item_w := 'N';
	ds_retorno_w	:= substr(ds_erro_w,1,255);
	rollback;
	end;
elsif (ie_gerou_item_w = 'N') and (ie_forma_geracao_w not in ('3','4')) then
	begin
	ds_retorno_w	:= Wheb_mensagem_pck.get_Texto(306771); /*'Nenhum item gerado pelo Kit de estoque!';*/
	rollback;
	end;
elsif (ie_forma_geracao_w not in ('2','4')) then
	begin
	if (ie_forma_geracao_w <> '3') then
		ds_retorno_w	:= Wheb_mensagem_pck.get_Texto(306777); /*'Kit de estoque gerado com sucesso!';*/
	end if;
	
	update	kit_estoque
	set	dt_utilizacao	= clock_timestamp(),
		nm_usuario_util	= nm_usuario_p,
		nr_atendimento	= nr_atendimento_p		
	where	nr_sequencia 	= nr_seq_kit_estoque_p;	
	end;
end if;

if (coalesce(ds_consiste_saldo_w,'X') <> 'X') then
	begin
	select	max(ds_local_estoque)
	into STRICT	ds_local_estoque_w
	from	local_estoque
	where	cd_local_estoque = cd_local_estoque_ww;

	ds_consiste_saldo_w := substr(WHEB_MENSAGEM_PCK.get_texto(306781,'DS_LOCAL_ESTOQUE_W='|| DS_LOCAL_ESTOQUE_W ||';DS_CONSISTE_SALDO_W='|| DS_CONSISTE_SALDO_W),1,4000);
	/*Alguns materiais nao foram gerados, pois nao existe saldo disponivel ou estao bloqueado para inventario.
	Local de estoque: #@DS_LOCAL_ESTOQUE_W#@
	#@DS_CONSISTE_SALDO_W#@*/
	
	ds_retorno_w := substr(ds_retorno_w || chr(13) || chr(10) || chr(13) || chr(10) || ds_consiste_saldo_w,1,4000);
	end;
end if;

if (cd_funcao_w = 24) and (ie_consiste_lanc_sem_saldo_w = 'S') and
	((coalesce(ds_consiste_saldo_w,'X') <> 'X') or (coalesce(cd_local_estoque_ww::text, '') = '')) then
	
	select	max(ds_local_estoque)
	into STRICT	ds_local_estoque_w
	from	local_estoque
	where	cd_local_estoque = cd_local_estoque_ww;
		
	ds_retorno_w	    := Wheb_mensagem_pck.get_Texto(306785); /*'Geracao Cancelada !';*/
	ds_consiste_saldo_w := substr(WHEB_MENSAGEM_PCK.get_texto(306786,'DS_LOCAL_ESTOQUE_W='|| DS_LOCAL_ESTOQUE_W ||';DS_CONSISTE_SALDO_WW='|| DS_CONSISTE_SALDO_WW),1,4000);
	/*Nenhum item foi gerado, pois alguns materiais nao tem saldo disponivel ou estao bloqueados para inventario. Parametro [311].
	Local de estoque: #@DS_LOCAL_ESTOQUE_W#@
	#@DS_CONSISTE_SALDO_WW#@*/
	ds_retorno_w := substr(ds_retorno_w || chr(13) || chr(10) || chr(13) || chr(10) || ds_consiste_saldo_w,1,4000);
	rollback;
end if;


ds_retorno_p := substr(ds_retorno_w,1,255);

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_kit_estoque ( nr_seq_kit_estoque_p bigint, nr_atendimento_p bigint, nr_seq_atepacu_p bigint, ie_local_estoque_p text, ie_baixa_sem_estoque_p text, nm_usuario_p text, cd_local_estoque_p bigint, ds_retorno_p INOUT text, dt_base_p timestamp, nr_doc_interno_p bigint, ie_forma_geracao_p text, ie_gerar_novo_kit_p text, nr_seq_comp_p bigint default null, qt_material_p bigint default null, cd_medico_prescritor_p text default null, nr_prescricao_p bigint default null) FROM PUBLIC;
