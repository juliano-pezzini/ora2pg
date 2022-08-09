-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nf_lote_prot_desdobrada (nr_seq_lote_protocolo_p bigint, cd_convenio_p bigint, cd_serie_nf_p text, cd_estabelecimento_p bigint, dt_emissao_p timestamp, cd_nat_oper_nf_p text, cd_operacao_nf_p bigint, cd_condicao_pagamento_p bigint, nm_usuario_p text, ds_complemento_p text, ds_observacao_p text, vl_desconto_nf_p bigint, vl_nota_p bigint, nr_seq_classif_fiscal_p bigint, nr_seq_sit_trib_p bigint, nr_nota_fiscal_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, cd_setor_atendimento_p bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE





cd_convenio_w			integer;
nr_sequencia_nf_w		bigint;
nr_sequencia_nf_ww		bigint;
ie_origem_proced_w		bigint;
cd_procedimento_w		bigint;
cd_material_w			integer;
qt_proc_mat_w			integer;
vl_proc_mat_w			double precision;
vl_item_prot_w			double precision;
vl_guias_w			double precision;
vl_total_guias_w		double precision	:= 0;
nr_interno_conta_prot_w		bigint;
vl_total_conta_w		double precision	:= 0;
vl_total_conta_ww		double precision	:= 0;
ie_tipo_convenio_w		integer;
ie_numero_nota_w		varchar(1);
cont_w				integer;
nr_contas_w			integer;
cd_cgc_emitente_w         	varchar(14);
cd_cgc_w			varchar(14);
nr_nota_fiscal_w           	varchar(255);
vl_total_nota_w         	double precision;
vl_mercadoria_w            	double precision;
vl_ipi_w        	         	double precision;
vl_descontos_w             	double precision;
vl_frete_w                	double precision;
vl_seguro_w                	double precision;
vl_despesa_acessoria_w     	double precision;
ds_observacao_w            	varchar(40);
vl_desconto_rateio_w       	double precision;
nr_sequencia_w             	bigint;
vl_unitario_item_nf_w		double precision;
ie_nf_guia_partic_w		varchar(001);
ds_erro_valor_w			varchar(12000)	:= null;
ds_erro_nota_w			varchar(12000)	:= null;
nr_notas_conta_w		integer	:= 0;
ds_erro_w			varchar(4000);
qt_itens_nf_w			integer;
ie_calcula_nf_w			varchar(01);
ie_regra_calcula_nf_w		varchar(01);
ie_calcula_nf_conv_w		varchar(01);
ie_tipo_nota_w			varchar(03);
qt_reg_w			bigint;
ie_atualiza_serie_nf_saida_w	varchar(15);
cd_pessoa_fisica_w		varchar(20);
ie_forma_pagamento_w		smallint;
dt_vencimento_prot_w		timestamp;
ie_tipo_conta_w			smallint;
cd_centro_custo_w		integer;
cd_conta_contabil_w		varchar(20);
ie_conta_financ_nf_w		varchar(255);
nr_seq_protocolo_w		bigint;
cd_conta_financ_w		bigint;
ie_gerar_titulo_w		varchar(1);
dt_vencimento_w			timestamp;
ds_vencimentos_w		varchar(2000);
qt_vencimentos_w		integer;
tx_juros_w			double precision;
tx_multa_w			double precision;
cd_tipo_taxa_juro_w		bigint;
cd_tipo_taxa_multa_w		bigint;
vl_saldo_lote_w			double precision;
ie_estab_serie_nf_w		parametro_compras.ie_estab_serie_nf%type;

c03 CURSOR FOR
SELECT	coalesce(sum(a.vl_item),0),
	a.nr_interno_conta
from	protocolo_convenio_item_v a
where 	a.nr_seq_protocolo = nr_seq_protocolo_w
and (coalesce(nr_seq_proc_pacote::text, '') = '' or nr_sequencia <> nr_seq_proc_pacote)
and 	coalesce(a.cd_motivo_exc_conta::text, '') = ''
group by a.nr_interno_conta;

c04 CURSOR FOR
SELECT	cd_material,
	cd_procedimento,
	ie_origem_proced,
	upper(ds_sql),
	coalesce(ie_lista_itens,'N')
from	parametro_nfs_lista
where	cd_estabelecimento	= cd_estabelecimento_p
and	cd_convenio		= cd_convenio_w
order by coalesce(ie_ordenacao, 1);

c05 CURSOR FOR
SELECT	nr_seq_protocolo
from	protocolo_convenio
where	nr_seq_lote_protocolo = nr_seq_lote_protocolo_p;


BEGIN

if (coalesce(vl_nota_p,0) = 0) then
	/*Favor informar o valor da nota fiscal.*/

	CALL wheb_mensagem_pck.exibir_mensagem_abort(193783);
end if;

select	coalesce(obter_saldo_lote_protocolo(nr_seq_lote_protocolo_p),0)
into STRICT	vl_saldo_lote_w
;

if (coalesce(vl_nota_p,0) > vl_saldo_lote_w) then
	/*O valor da nota não pode ser maior que o saldo do lote.*/

	CALL wheb_mensagem_pck.exibir_mensagem_abort(193784);
end if;

if (trunc(dt_emissao_p) > trunc(clock_timestamp())) then
	--'A data de emissão da nota não pode ser maior que a data atual!'
	CALL wheb_mensagem_pck.exibir_mensagem_abort(176746);
end if;

select	coalesce(max(ie_conta_financ_nf), 'N')
into STRICT	ie_conta_financ_nf_w
from	parametro_faturamento
where	cd_estabelecimento	= cd_estabelecimento_p;

cd_convenio_w		:= cd_convenio_p;

select	obter_tipo_convenio(cd_convenio_p)
into STRICT	ie_tipo_convenio_w
;

select	count(*)
into STRICT	cont_w
from	serie_nota_fiscal
where	cd_serie_nf 		= cd_serie_nf_p
and	cd_estabelecimento 	= cd_estabelecimento_p;
if (cont_w = 0) then
	--'A Série informada não está cadastrada!'
	CALL wheb_mensagem_pck.exibir_mensagem_abort(176750);
end if;

select	coalesce(max(ie_calcular_nf),'N'),
	coalesce(max(ie_atualiza_serie_nf_saida),'S')
into STRICT	ie_calcula_nf_conv_w,
	ie_atualiza_serie_nf_saida_w
from	convenio_estabelecimento
where	cd_convenio		= cd_convenio_p
and	cd_estabelecimento	= cd_estabelecimento_p;

vl_total_conta_w	:= 0;

open c05;
loop
fetch c05 into
	nr_seq_protocolo_w;
EXIT WHEN NOT FOUND; /* apply on c05 */
	begin

	select	sum(vl_item)
	into STRICT	vl_total_conta_ww
	from 	protocolo_convenio_item_v
	where 	nr_seq_protocolo = nr_seq_protocolo_w
	and (coalesce(nr_seq_proc_pacote::text, '') = '' or nr_sequencia <> nr_seq_proc_pacote)
	and 	coalesce(cd_motivo_exc_conta::text, '') = '';

	vl_total_conta_w	:= vl_total_conta_w + vl_total_conta_ww;

	open	c03;
	loop
	fetch 	c03 into
		vl_item_prot_w,
		nr_interno_conta_prot_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin
		select	count(*)
		into STRICT	nr_notas_conta_w
		from	nota_fiscal
		where	nr_interno_conta	= nr_interno_conta_prot_w;

		if (nr_notas_conta_w > 0) then
			ds_erro_nota_w	:= ds_erro_nota_w || Wheb_mensagem_pck.get_Texto(307127) || nr_interno_conta_prot_w || chr(13);
		end if;

		select	coalesce(sum(a.vl_guia),0)
		into STRICT	vl_guias_w
		from	conta_paciente_guia a
		where	a.nr_interno_conta	= nr_interno_conta_prot_w;

		vl_total_guias_w		:= vl_total_guias_w + vl_guias_w;
		if (vl_guias_w	<> vl_item_prot_w) then
			ds_erro_valor_w	:= ds_erro_valor_w ||
						Wheb_mensagem_pck.get_Texto(307127) || nr_interno_conta_prot_w ||
						Wheb_mensagem_pck.get_Texto(307129) || vl_item_prot_w ||
						Wheb_mensagem_pck.get_Texto(307130) || vl_guias_w || chr(13);
		end if;
		end;
	end loop;
	close c03;
	end;
end loop;
close c05;

if (ds_erro_nota_w IS NOT NULL AND ds_erro_nota_w::text <> '') then
	--'Existem contas com notas já geradas ' || chr(13) || ds_erro_nota_w || chr(13) || ' ');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(176752,'DS_ERRO_P='||ds_erro_nota_w);
end if;

if (ds_erro_valor_w IS NOT NULL AND ds_erro_valor_w::text <> '') then
	--' O valor do título ' || vl_total_conta_w || ' não bate com o valor das guias ' ||

	--				vl_total_guias_w || chr(13) ||

	--				ds_erro_valor_w || chr(13) || ' ');
					
	CALL wheb_mensagem_pck.exibir_mensagem_abort(173217,	'VL_TOTAL_CONTA_W='||vl_total_conta_w||';'||
							'VL_TOTAL_GUIAS_W='||vl_total_guias_w||';'||
							'DS_ERRO_VALOR_W='||ds_erro_valor_w);
					
end if;

begin
select	cd_cgc
into STRICT	cd_cgc_w
from	convenio
where	cd_convenio 	= cd_convenio_p;
exception
	when others then
		--'Erro ao ler o CGC do convênio do lote de protocolo');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(176775);
end;

/* obter sequencia da nota fiscal */

select	nextval('nota_fiscal_seq')
into STRICT	nr_sequencia_w
;

/* obter cgc do emitente */

select	cd_cgc
into STRICT	cd_cgc_emitente_w
from	estabelecimento
where	cd_estabelecimento = cd_estabelecimento_p;

/* obter se será considerado estabelecimento no parâmetro de compras */

select	coalesce(max(ie_estab_serie_nf),'N')
into STRICT	ie_estab_serie_nf_w
from	parametro_compras
where	cd_estabelecimento = cd_estabelecimento_p;

/* zerar valores não sabidos */

nr_nota_fiscal_w	:= nr_sequencia_w + 800000;
vl_mercadoria_w		:= 0;
vl_total_nota_w		:= 0;
vl_ipi_w		:= 0;
vl_descontos_w		:= coalesce(vl_desconto_nf_p,0);
vl_frete_w		:= 0;
vl_seguro_w		:= 0;
vl_despesa_acessoria_w	:= 0;
vl_desconto_rateio_w	:= 0;
--nr_sequencia_nf_w		:= 9; foi retirado essa linha pelo select abaixo, pois dava problema caso na UK caso já tivesse uma nova com essa informação = 9 (9 são as notas canceladas)
ie_tipo_nota_w		:= 'SE';
cd_pessoa_fisica_w:= null;
--2 Parâmetros não informados (Pessoa Jurídica)
if	((coalesce(cd_pessoa_fisica_p::text, '') = '') and (coalesce(cd_cgc_p::text, '') = '')) then
	cd_cgc_w:= cd_cgc_w;
end if;
--2 Parâmetros informados (Pessoa Jurídica)
if (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') then
	cd_cgc_w	:= cd_cgc_p;
	cd_pessoa_fisica_w:= null;
end if;
--Apenas Parâmetro Pessoa Física (Pessoa Física)
if	((coalesce(cd_cgc_p::text, '') = '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '')) then
	ie_tipo_nota_w	:= 'SF';
	cd_cgc_w:= null;
	cd_pessoa_fisica_w:= cd_pessoa_fisica_p;
end if;

select 	coalesce(max(nr_sequencia_nf),0)+1
into STRICT	nr_sequencia_nf_w
from 	nota_fiscal
where	nr_nota_fiscal 		= nr_nota_fiscal_w
and	cd_estabelecimento 	= cd_estabelecimento_p
and	cd_serie_nf 		= cd_serie_nf_p
and	cd_cgc_emitente		= cd_cgc_emitente_w;

/* gravar nota fiscal */

begin
insert into nota_fiscal(
	nr_sequencia,
	cd_estabelecimento,
	cd_cgc_emitente,
	cd_serie_nf,
	nr_nota_fiscal,
	nr_sequencia_nf,
	cd_operacao_nf,
	dt_emissao,
	dt_entrada_saida,
	ie_acao_nf,
	ie_emissao_nf,
	ie_tipo_frete,
	vl_mercadoria,
	vl_total_nota,
	qt_peso_bruto,
	qt_peso_liquido,
	dt_atualizacao,
	nm_usuario,
	cd_condicao_pagamento,
	cd_cgc,
	cd_pessoa_fisica,
	vl_ipi,
	vl_descontos,
	vl_frete,
	vl_seguro,
	vl_despesa_acessoria,
	ds_observacao,
	cd_natureza_operacao,
	vl_desconto_rateio,
	ie_situacao,
	nr_interno_conta,
	nr_seq_protocolo,
	nr_seq_lote_prot,
	ds_obs_desconto_nf,
	nr_seq_classif_fiscal,
	ie_tipo_nota,
	nr_recibo,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_setor_digitacao)
values (	nr_sequencia_w,
	cd_estabelecimento_p,
	cd_cgc_emitente_w,
	cd_serie_nf_p,
	nr_nota_fiscal_w,
	nr_sequencia_nf_w,
	cd_operacao_nf_p,
	dt_emissao_p,
	dt_emissao_p,
	'1',
	'0',
	'0',
	vl_mercadoria_w,
	vl_total_nota_w,
	0,
	0,
	clock_timestamp(),
	nm_usuario_p,
	cd_condicao_pagamento_p,
	cd_cgc_w,
	cd_pessoa_fisica_w,
	vl_ipi_w,
	vl_descontos_w,
	vl_frete_w,
	vl_seguro_w,
	vl_despesa_acessoria_w,
	ds_observacao_p,
	cd_nat_oper_nf_p,
	vl_desconto_rateio_w,
	'1',
	null,
	null,
	nr_seq_lote_protocolo_p,
	null,
	nr_seq_classif_fiscal_p,
	ie_tipo_nota_w,
	null,
	clock_timestamp(),
	nm_usuario_p,
	cd_setor_atendimento_p);
exception
	when others then
		ds_erro_w	:= sqlerrm(SQLSTATE);
		/*(-20011,'Erro ao Gravar Corpo da Nota Fiscal' || chr(10) || 
		'estab: '	|| cd_estabelecimento_p	||
		'cgc: '   	|| cd_cgc_emitente_w 	||
		'serie: ' 	|| cd_serie_nf_p 		||
		'nota: '  	|| nr_nota_fiscal_w 		||
		'seq: '   	|| nr_sequencia_nf_w  	|| chr(10) ||
		ds_erro_w);*/
		
		CALL wheb_mensagem_pck.exibir_mensagem_abort(173250,
							'CD_ESTAB_NOTA_FISCAL_W='||cd_estabelecimento_p||';'||
							'CD_CGC_EMITENTE_W='||cd_cgc_emitente_w||';'||
							'CD_SERIE_NF_W='||cd_serie_nf_p||';'||
							'NR_NOTA_FISCAL_W='||nr_nota_fiscal_w||';'||
							'NR_SEQUENCIA_NF_W='||nr_sequencia_nf_w||';'||
							'DS_ERRO_W='||ds_erro_w);
end;
CALL gerar_historico_nota_fiscal(nr_sequencia_w, nm_usuario_p, 16, Wheb_mensagem_pck.get_Texto(307131));

/* vincular as contas à nota fiscal */

insert into conta_paciente_nf(
	nr_interno_conta,
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	cd_perfil)
SELECT	a.nr_interno_conta,
	nr_sequencia_w,
	clock_timestamp(),
	nm_usuario_p,
	obter_perfil_ativo
from	conta_paciente a
where	a.ie_status_acerto =  2
and	a.nr_seq_protocolo in (
	SELECT	nr_seq_protocolo
	from	protocolo_convenio
	where	nr_seq_lote_protocolo = nr_seq_lote_protocolo_p);

/* testar condição erro */

select	count(*)
into STRICT	nr_contas_w
from	conta_paciente_nf
where	nr_sequencia = nr_sequencia_w;
if (nr_contas_w = 0) then	
	--(-20001,'Nenhuma conta foi associada');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(173251);
end if;

/* tratar itens da nota fiscal */

if (coalesce(cd_procedimento_p,0) > 0) and (coalesce(ie_origem_proced_p,0) > 0) then
	begin

	qt_proc_mat_w		:= 1;
	vl_unitario_item_nf_w	:= vl_nota_p;
	vl_proc_mat_w		:= vl_nota_p;
	cd_material_w		:= null;
	ie_origem_proced_w	:= coalesce(ie_origem_proced_p,1);
	cd_procedimento_w	:= cd_procedimento_p;

	ie_tipo_conta_w	:= 3;
	if (coalesce(cd_centro_custo_w::text, '') = '') then
		ie_tipo_conta_w	:= 2;
	end if;

	select	obter_tipo_convenio(cd_convenio_p)
	into STRICT	ie_tipo_convenio_w
	;

	if (cd_material_w > 0) then
		SELECT * FROM define_conta_material(
			cd_estabelecimento_p, cd_material_w, ie_tipo_conta_w, 0, 0, 0, ie_tipo_convenio_w, 0, 0, 0, null, null, trunc(clock_timestamp()), cd_conta_contabil_w, cd_centro_custo_w, null) INTO STRICT cd_conta_contabil_w, cd_centro_custo_w;
	end if;
	
	if (cd_procedimento_w > 0) then
		SELECT * FROM define_conta_procedimento(
			cd_estabelecimento_p, cd_procedimento_w, ie_origem_proced_w, ie_tipo_conta_w, 0, 0, 0, 0, ie_tipo_convenio_w, 0, 0, trunc(clock_timestamp()), cd_conta_contabil_w, cd_centro_custo_w, null, null) INTO STRICT cd_conta_contabil_w, cd_centro_custo_w;
	end if;

	if (ie_conta_financ_nf_w = 'S') then
		/* Edgar 10/05/2010, OS 212387, tratar conta financeira */

		cd_conta_financ_w := obter_conta_financeira(	'E', cd_estabelecimento_p, cd_material_w, cd_procedimento_w, ie_origem_proced_w, null, cd_convenio_w, cd_cgc_p, cd_centro_custo_w, cd_conta_financ_w, null, cd_operacao_nf_p, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
	end if;

	insert into nota_fiscal_item(
		nr_sequencia,
		cd_estabelecimento,
		cd_cgc_emitente,
		cd_serie_nf,
		nr_nota_fiscal,
		nr_sequencia_nf,
		nr_item_nf,
		cd_natureza_operacao,
		dt_atualizacao,
		nm_usuario,
		qt_item_nf,
		vl_unitario_item_nf,
		vl_total_item_nf,
		vl_frete,
		vl_desconto,
		vl_despesa_acessoria,
		vl_desconto_rateio,
		vl_seguro,
		vl_liquido,
		cd_material,
		cd_procedimento,
		cd_local_estoque,
		ds_observacao,
		ie_origem_proced,
		nr_seq_conta_financ,
		ds_complemento,
		nr_atendimento,
		cd_conta_contabil,
		cd_sequencia_parametro)
	values (	nr_sequencia_w,
		cd_estabelecimento_p,
		cd_cgc_emitente_w,
		cd_serie_nf_p,
		nr_nota_fiscal_w,
		nr_sequencia_nf_w,
		1,
		cd_nat_oper_nf_p,
		clock_timestamp(),
		nm_usuario_p,
		qt_proc_mat_w,
		vl_unitario_item_nf_w,
		vl_proc_mat_w,
		0,
		0,
		0,
		0,
		0,
		vl_proc_mat_w,
		CASE WHEN cd_material_w=0 THEN  null  ELSE cd_material_w END ,
		CASE WHEN cd_procedimento_w=0 THEN  null  ELSE cd_procedimento_w END ,
		null,
		ds_observacao_w,
		CASE WHEN ie_origem_proced_w=0 THEN  null  ELSE ie_origem_proced_w END ,
		cd_conta_financ_w,
		ds_complemento_p,
		null,
		cd_conta_contabil_w,
		philips_contabil_pck.get_parametro_conta_contabil);
	end;
end if;

/* testar condição erro  - nota sem itens */

qt_itens_nf_w := 0;

select	count(*)
into STRICT	qt_itens_nf_w
from	nota_fiscal_item
where	nr_sequencia = nr_sequencia_w;
if (qt_itens_nf_w = 0) then
	--(-20001,'Nenhum item gerado para nota fiscal');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(173254);
end if;

select	coalesce(max(ie_nf_guia_partic),'S'),
	coalesce(max(ie_calcula_nf),'N')
into STRICT	ie_nf_guia_partic_w,
	ie_calcula_nf_w
from	parametro_faturamento
where	cd_estabelecimento	= cd_estabelecimento_p;

ie_regra_calcula_nf_w := obter_param_usuario(-80, 27, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_regra_calcula_nf_w);

/* locar a tabela e obter o numero da nota fiscal */

lock table serie_nota_fiscal in exclusive mode;
select	nr_ultima_nf + 1,
	ie_numero_nota
into STRICT	nr_nota_fiscal_w,
	ie_numero_nota_w
from	serie_nota_fiscal
where	cd_serie_nf 		= cd_serie_nf_p
and	cd_estabelecimento 	= cd_estabelecimento_p;

if (nr_nota_fiscal_p <> 0) then
	nr_nota_fiscal_w		:= nr_nota_fiscal_p;
end if;

select	count(*)
into STRICT	qt_reg_w
from	nota_fiscal_aidf
where	cd_estabelecimento 	= cd_estabelecimento_p
and	cd_serie_nf 		= cd_serie_nf_p;

if (qt_reg_w > 0) then
	select	count(*)
	into STRICT	qt_reg_w
	from	nota_fiscal_aidf
	where	cd_estabelecimento 	= cd_estabelecimento_p
	and	cd_serie_nf 		= cd_serie_nf_p
	and	nr_nota_fiscal_w >= nr_nota_ini
	and 	nr_nota_fiscal_w <= nr_nota_fim;
	
	if (qt_reg_w = 0) then
		--(-20011,	'Sem autorização para informar este número de nota fiscal (' || nr_nota_fiscal_w || '), ' || chr(10) || chr(13) || 

		--				'verifique o cadastro de autorizações(AIDF) nos cadastros de estoque.');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(173255,'NR_NOTA_FISCAL_W='||nr_nota_fiscal_w);
	end if;
end if;

if (ie_atualiza_serie_nf_saida_w = 'S') then

	if (ie_numero_nota_w = 'T') and (cd_setor_atendimento_p > 0) then
			
		select	count(*)
		into STRICT	qt_reg_w
		from	serie_nota_fiscal_setor
		where	cd_serie_nf = cd_serie_nf_p
		and	cd_Estabelecimento = cd_estabelecimento_p
		and	cd_setor_atendimento = cd_setor_atendimento_p;
			
		if (qt_reg_w > 0) then				
			select	nr_ultima_nf +1
			into STRICT	nr_nota_fiscal_w
			from	serie_nota_fiscal_setor
			where	cd_serie_nf = cd_serie_nf_p
			and	cd_Estabelecimento = cd_estabelecimento_p
			and	cd_setor_atendimento = cd_setor_atendimento_p;
						
			if	((coalesce(ie_regra_calcula_nf_w,'D') = 'S') or
				((coalesce(ie_regra_calcula_nf_w,'D') = 'D') and (ie_calcula_nf_w = 'S')) or
				((coalesce(ie_regra_calcula_nf_w,'D') = 'C') and (ie_calcula_nf_conv_w = 'S'))) then
				update	serie_nota_fiscal_setor
				set	nr_ultima_nf 		= nr_nota_fiscal_w
				where	cd_serie_nf 		= cd_serie_nf_p
				and	cd_estabelecimento 	= cd_estabelecimento_p
				and	cd_setor_atendimento	= cd_setor_atendimento_p;
			end if;
		end if;	
	else
		update	serie_nota_fiscal
		set	nr_ultima_nf 		= nr_nota_fiscal_w
		where	cd_serie_nf 		= cd_serie_nf_p
		and	cd_estabelecimento 	= cd_estabelecimento_p;
		
		if (coalesce(ie_estab_serie_nf_w,'N') = 'S') then
			update	serie_nota_fiscal
			set	nr_ultima_nf 		= nr_nota_fiscal_w
			where	cd_serie_nf 		= cd_serie_nf_p
			and	cd_estabelecimento in (SELECT	z.cd_estabelecimento
							from	estabelecimento z
							where	z.cd_cgc = cd_cgc_emitente_w);
		else
			update	serie_nota_fiscal
			set	nr_ultima_nf 		= nr_nota_fiscal_w
			where	cd_serie_nf 		= cd_serie_nf_p
			and	cd_estabelecimento 	= cd_estabelecimento_p;
		end if;
	end if;
end if;

select 	coalesce(max(nr_sequencia_nf),0)+1
into STRICT	nr_sequencia_nf_ww
from 	nota_fiscal
where	nr_nota_fiscal 		= nr_nota_fiscal_w
and	cd_estabelecimento 	= cd_estabelecimento_p
and	cd_serie_nf 		= cd_serie_nf_p
and	cd_cgc_emitente		= cd_cgc_emitente_w;

/* atualizar os totais da nota fiscal */

update	nota_fiscal
set	vl_mercadoria	= vl_proc_mat_w,
	vl_total_nota	= vl_proc_mat_w - + vl_descontos_w,
	vl_descontos	= vl_descontos_w,
	vl_ipi		= vl_ipi_w,
	nr_nota_fiscal	= nr_nota_fiscal_w,
	nr_sequencia_nf	= nr_sequencia_nf_ww
where	nr_sequencia 	= nr_sequencia_w;

update	nota_fiscal_item
set	nr_nota_fiscal	= nr_nota_fiscal_w
where	nr_sequencia 	= nr_sequencia_w;

CALL gerar_imposto_nf(nr_sequencia_w, nm_usuario_p, nr_seq_sit_trib_p, null);

CALL atualiza_total_nota_fiscal(nr_sequencia_w,nm_usuario_p);

if (coalesce(cd_condicao_pagamento_p,0) > 0) then
	select	ie_forma_pagamento
	into STRICT	ie_forma_pagamento_w
	from	condicao_pagamento
	where	cd_condicao_pagamento = cd_condicao_pagamento_p;
end if;

if (coalesce(ie_forma_pagamento_w,0) = 10) then	/*Conforme vencimnetos, buscar o vencimento do protocolo*/
	begin
	select	max(dt_vencimento)
	into STRICT	dt_vencimento_prot_w
	from	protocolo_convenio
	where	nr_seq_lote_protocolo = nr_seq_lote_protocolo_p;
	
	select	vl_total_nota
	into STRICT	vl_total_nota_w
	from	nota_fiscal
	where	nr_sequencia = nr_sequencia_w;
	
	insert into nota_fiscal_venc(
			nr_sequencia,
			cd_estabelecimento,
			cd_cgc_emitente,
			cd_serie_nf,
			nr_sequencia_nf,
			dt_vencimento,
			vl_vencimento,
			dt_atualizacao,
			nm_usuario,
			nr_nota_fiscal,
			ie_origem)
		values (	nr_sequencia_w,
			cd_estabelecimento_p,
			cd_cgc_emitente_w,
			cd_serie_nf_p,
			nr_sequencia_nf_w,
			coalesce(dt_vencimento_prot_w, dt_emissao_p),
			vl_total_nota_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_nota_fiscal_w,
			'N');
	end;
else
	CALL gerar_nota_fiscal_venc(nr_sequencia_w, dt_emissao_p);
end if;

if	((coalesce(ie_regra_calcula_nf_w,'D') = 'S') or
	((coalesce(ie_regra_calcula_nf_w,'D') = 'D') and (ie_calcula_nf_w = 'S')) or
	((coalesce(ie_regra_calcula_nf_w,'D') = 'C') and (ie_calcula_nf_conv_w = 'S'))) then
	update	nota_fiscal
	set	dt_atualizacao_estoque 	= clock_timestamp()
	where	nr_sequencia 		= nr_sequencia_w;
end if;

select	coalesce(obter_saldo_lote_protocolo(nr_seq_lote_protocolo_p),0)
into STRICT	vl_saldo_lote_w
;

if (vl_saldo_lote_w <= 0) then
	update	lote_protocolo
	set 	dt_geracao_nota 	= clock_timestamp(),
		nm_usuario 	= nm_usuario_p
	where 	nr_sequencia 	= nr_seq_lote_protocolo_p;
end if;

ie_gerar_titulo_w := obter_param_usuario(85, 125, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_titulo_w);

if (ie_gerar_titulo_w	= 'T') then

	SELECT * FROM calcular_vencimento(cd_estabelecimento_p, cd_condicao_pagamento_p, dt_emissao_p, qt_vencimentos_w, ds_vencimentos_w) INTO STRICT qt_vencimentos_w, ds_vencimentos_w;

	if (qt_vencimentos_w	= 1) then
		dt_vencimento_w	:= to_date(substr(ds_vencimentos_w,1,10),'dd/mm/yyyy');
	end if;

	select	max(a.cd_tipo_taxa_juro),
		max(a.cd_tipo_taxa_multa),
		max(a.pr_juro_padrao),
		max(a.pr_multa_padrao)
	into STRICT	cd_tipo_taxa_juro_w,
		cd_tipo_taxa_multa_w,
		tx_juros_w,
		tx_multa_w
	from	parametro_contas_receber a
	where	a.cd_estabelecimento	= cd_estabelecimento_p;

	CALL gerar_titulo_lote_protocolo(	nr_seq_lote_protocolo_p,
				cd_estabelecimento_p,
				cd_pessoa_fisica_p,
				cd_cgc_p,
				null,
				null,
				null,
				cd_condicao_pagamento_p,
				dt_vencimento_w,
				dt_emissao_p,
				vl_total_conta_w,
				null,
				tx_juros_w,
				cd_tipo_taxa_juro_w,
				tx_multa_w,
				cd_tipo_taxa_multa_w,
				0,
				null,
				null,
				nr_nota_fiscal_w,
				cd_serie_nf_p,
				nm_usuario_p,
				'N');

end if;

update	titulo_receber
set	nr_nota_fiscal 	= nr_nota_fiscal_w,
	nr_seq_nf_saida	= nr_sequencia_w
where	nr_seq_protocolo in (SELECT	x.nr_seq_protocolo
				from	protocolo_convenio x
				where	x.nr_seq_lote_protocolo	= nr_seq_lote_protocolo_p)
and	coalesce(nr_nota_fiscal, '0') = '0';

nr_sequencia_p		:= nr_sequencia_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nf_lote_prot_desdobrada (nr_seq_lote_protocolo_p bigint, cd_convenio_p bigint, cd_serie_nf_p text, cd_estabelecimento_p bigint, dt_emissao_p timestamp, cd_nat_oper_nf_p text, cd_operacao_nf_p bigint, cd_condicao_pagamento_p bigint, nm_usuario_p text, ds_complemento_p text, ds_observacao_p text, vl_desconto_nf_p bigint, vl_nota_p bigint, nr_seq_classif_fiscal_p bigint, nr_seq_sit_trib_p bigint, nr_nota_fiscal_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, cd_setor_atendimento_p bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;
