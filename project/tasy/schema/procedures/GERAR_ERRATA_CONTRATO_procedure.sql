-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_errata_contrato ( nr_sequencia_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_novo_p INOUT bigint) AS $body$
DECLARE


nr_sequencia_w			bigint;
nr_seq_errata_w			bigint;
nr_seq_docto_w			bigint;
nr_seq_docto_ww			bigint;
nr_seq_regra_nf_w			bigint;
nr_seq_regra_nf_ww		bigint;
ds_regra_w			varchar(80);
ie_regra_dia_w			varchar(1);
qt_dia_mes_w			smallint;
ds_observacao_w			varchar(255);
dt_especifica_w			timestamp;
ie_avisa_venc_doc_w		varchar(1);
cd_material_w			integer;
cd_conta_contabil_w		varchar(20);
cd_centro_custo_w			integer;
nr_seq_crit_rateio_w		bigint;
ds_complemento_w			varchar(255);
ds_obs_regra_w			varchar(255);
nr_seq_conta_financ_w		bigint;
vl_pagto_w			double precision;
dt_inicio_vigencia_w		timestamp;
dt_fim_vigencia_w			timestamp;
ds_retorno_w			varchar(255);
ds_erro_w			varchar(255);
vl_parametro_w			bigint;
ie_liberar_aditivo_w			varchar(2);
qt_existe_w			integer;
ie_apenas_maior_vig_w		varchar(1);
ie_preco_w			varchar(1);
ie_quantidade_w			varchar(1);
ie_preenche_dt_adt_w		varchar(1);
ie_gera_itens_w			varchar(1);
cd_estabelecimento_w		contrato_regra_nf.CD_ESTAB_REGRA%type;
cd_local_estoque_w		contrato_regra_nf.cd_local_estoque%type;
nr_seq_proj_rec_w		contrato_regra_nf.nr_seq_proj_rec%type;
vl_desconto_w			contrato_regra_nf.vl_desconto%type;
pr_desconto_w			contrato_regra_nf.pr_desconto%type;

c01 CURSOR FOR
SELECT	nr_sequencia,
	ds_regra,
	ie_regra_dia,
	qt_dia_mes,
	ds_observacao,
	dt_especifica,
	ie_avisa_vencimento
from	contrato_regra_doc
where	nr_seq_contrato = nr_sequencia_p;


c02 CURSOR FOR
SELECT	nr_sequencia,
	cd_material,
	cd_conta_contabil,
	cd_centro_custo,
	nr_seq_crit_rateio,
	ds_complemento,
	ds_observacao,
	nr_seq_conta_financ,
	vl_pagto,
	dt_inicio_vigencia,
	dt_fim_vigencia,
	ie_preco,
	ie_quantidade,
	CD_ESTAB_REGRA,
	cd_local_estoque,
	nr_seq_proj_rec,
	vl_desconto,
	pr_desconto
from	contrato_regra_nf
where	nr_seq_contrato = nr_sequencia_p
and	ie_apenas_maior_vig_w = 'N'

union

select	nr_sequencia,
	cd_material,
	cd_conta_contabil,
	cd_centro_custo,
	nr_seq_crit_rateio,
	ds_complemento,
	ds_observacao,
	nr_seq_conta_financ,
	vl_pagto,
	dt_inicio_vigencia,
	dt_fim_vigencia,
	ie_preco,
	ie_quantidade,
	CD_ESTAB_REGRA,
	cd_local_estoque,
	nr_seq_proj_rec,
	vl_desconto,
	pr_desconto
from	contrato_regra_nf a
where	nr_seq_contrato = nr_sequencia_p
and	ie_apenas_maior_vig_w = 'S'
and	trunc(dt_fim_vigencia) =	(select	max(x.dt_fim_vigencia)
				from	contrato_regra_nf x
				where	x.nr_seq_contrato = a.nr_seq_contrato
				and	x.cd_material = a.cd_material)
and (coalesce(a.ie_situacao::text, '') = '' or a.ie_situacao = 'A');


BEGIN

/*identifica se este contrato ja e um aditivo*/

select	count(*)
into STRICT	qt_existe_w
from	contrato
where	ie_classificacao = 'ER'
and	nr_sequencia = nr_sequencia_p;
if (qt_existe_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(182731);
end if;

select	obter_valor_param_usuario(1200, 75, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)
into STRICT	ie_liberar_aditivo_w
;

select	obter_valor_param_usuario(1200, 76, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)
into STRICT	ie_preenche_dt_adt_w
;

select	obter_valor_param_usuario(1200, 98, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)
into STRICT	ie_gera_itens_w
;

/*verifica quantos aditivos existem que ainda nao estao atualizados*/

select	count(*)
into STRICT	qt_existe_w
from	contrato
where	coalesce(dt_atualizacao_aditivo::text, '') = ''
and	ie_classificacao = 'ER'
and	nr_seq_contrato_atual = nr_sequencia_p;
if (qt_existe_w > 0) and (ie_liberar_aditivo_w = 'N') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(182732);
end if;


select nextval('contrato_seq')
into STRICT nr_sequencia_w
;

select	obter_valor_param_usuario(1200, 10, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)
into STRICT	vl_parametro_w
;

select	obter_valor_param_usuario(1200, 64, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)
into STRICT	ie_apenas_maior_vig_w
;

/*cria o novo contrato*/

select	coalesce(max(nr_seq_errata), 0) + 1
into STRICT	nr_seq_errata_w
from	contrato
where	nr_seq_contrato_atual = nr_sequencia_p
and	ie_classificacao = 'ER';

SELECT * FROM gerar_codigo_auto_errata(nr_sequencia_p, vl_parametro_w, ds_retorno_w, ds_erro_w) INTO STRICT ds_retorno_w, ds_erro_w;

if (vl_parametro_w = 1) then
	select (substr(ds_retorno_w,1,length(ds_retorno_w)-1) || nr_seq_errata_w)
	into STRICT	ds_retorno_w
	;
elsif (vl_parametro_w = 3) then
	select 	cd_contrato
	into STRICT	ds_retorno_w
	from	contrato
	where	nr_sequencia = nr_sequencia_p;
end if;

insert into contrato(
	nr_sequencia,		cd_cgc_contratado,
	nr_seq_tipo_contrato,	ds_objeto_contrato,
	ie_renovacao,		dt_atualizacao,
	nm_usuario,		ie_situacao,
	dt_inicio,			dt_fim,
	qt_dias_rescisao,		cd_contrato,
	ie_prazo_contrato,		nm_contato,
	cd_pessoa_resp,		vl_total_contrato,
	ds_atribuicao,		ie_pagar_receber,
	cd_pessoa_negoc,		cd_pessoa_contratada,
	dt_revisao,		cd_estabelecimento,
	ie_avisa_vencimento,	qt_dias_aviso_venc,
	cd_cargo,		ds_motivo_rescisao,
	nr_seq_forma_rescisao,	vl_multa_contratual,
	cd_setor,			cd_condicao_pagamento,
	ie_avisa_venc_setor,	pr_multa_contratual,
	nr_seq_subtipo_contrato,	ie_classificacao,
	nr_seq_errata,		nr_seq_contrato_atual,
	dt_atualizacao_nrec,	nm_usuario_nrec,
	ie_periodo_nf,		qt_maximo_nf_periodo,
	qt_dias_revisao,		ie_estagio,
	nr_seq_indice_reajuste,	qt_dias_reajuste,
	nr_seq_contrato_gestao,	cd_pessoa_contratante,
	cd_cnpj_contratante,	cd_paciente,
	cd_medico_resp)
SELECT	nr_sequencia_w,		cd_cgc_contratado,
	nr_seq_tipo_contrato,	ds_objeto_contrato,
	ie_renovacao,		clock_timestamp(),
	nm_usuario_p,		ie_situacao,
	CASE WHEN ie_preenche_dt_adt_w='S' THEN  dt_inicio WHEN ie_preenche_dt_adt_w='N' THEN  clock_timestamp() END ,	dt_fim,
	qt_dias_rescisao,		ds_retorno_w,
	ie_prazo_contrato,		nm_contato,
	cd_pessoa_resp,		0,
	ds_atribuicao,		ie_pagar_receber,
	cd_pessoa_negoc,		cd_pessoa_contratada,
	dt_revisao,		cd_estabelecimento,
	ie_avisa_vencimento,	qt_dias_aviso_venc,
	cd_cargo,		ds_motivo_rescisao,
	nr_seq_forma_rescisao,	vl_multa_contratual,
	cd_setor,			cd_condicao_pagamento,
	ie_avisa_venc_setor,	pr_multa_contratual,
	nr_seq_subtipo_contrato,	'ER',
	nr_seq_errata_w,		nr_sequencia_p,
	dt_atualizacao_nrec,	nm_usuario_nrec,
	coalesce(ie_periodo_nf,'N'),	qt_maximo_nf_periodo,
	qt_dias_revisao,		ie_estagio,
	nr_seq_indice_reajuste,	qt_dias_reajuste,
	nr_seq_contrato_gestao,	cd_pessoa_contratante,
	cd_cnpj_contratante,	cd_paciente,
	cd_medico_resp
from	contrato
where	nr_sequencia = nr_sequencia_p;


/*cria regra de pagamento*/

insert into contrato_regra_pagto(
	nr_sequencia,
	nr_seq_contrato,
	dt_atualizacao,
	nm_usuario,
	ie_forma,
	dt_primeiro_vencto,
	ie_tipo_valor,
	vl_pagto,
	cd_moeda,
	cd_indice_reajuste,
	ie_periodo_reajuste,
	cd_conta_financ,
	vl_ir,
	vl_inss,
	vl_iss,
	dt_inicio_vigencia,
	dt_final_vigencia,
	ds_observacao,
	qt_indice_reajuste,
	ds_ref_indice_reajuste,
	ds_regra_vencimento)
SELECT	nextval('contrato_regra_pagto_seq'),
	nr_sequencia_w,
	clock_timestamp(),
	nm_usuario_p,
	ie_forma,
	dt_primeiro_vencto,
	ie_tipo_valor,
	vl_pagto,
	cd_moeda,
	cd_indice_reajuste,
	ie_periodo_reajuste,
	cd_conta_financ,
	vl_ir,
	vl_inss,
	vl_iss,
	dt_inicio_vigencia,
	dt_final_vigencia,
	ds_observacao,
	qt_indice_reajuste,
	ds_ref_indice_reajuste,
	ds_regra_vencimento
from	contrato_regra_pagto
where	nr_seq_contrato = nr_sequencia_p;
	

/*nao deve criar as etapas*/

/*nao deve criar os historicos*/

/*cria documentacao*/

open c01;
loop
fetch c01 into
	nr_seq_docto_w,
	ds_regra_w,
	ie_regra_dia_w,
	qt_dia_mes_w,
	ds_observacao_w,
	dt_especifica_w,
	ie_avisa_venc_doc_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select nextval('contrato_regra_doc_seq')
	into STRICT nr_seq_docto_ww
	;

	insert into contrato_regra_doc(
		nr_sequencia,
		nr_seq_contrato,
		ds_regra,
		dt_atualizacao,
		nm_usuario,
		ie_regra_dia,
		qt_dia_mes,
		ds_observacao,
		dt_especifica,
		ie_avisa_vencimento)
	values ( nr_seq_docto_ww,
		nr_sequencia_w,
		ds_regra_w,
		clock_timestamp(),
		nm_usuario_p,
		ie_regra_dia_w,
		qt_dia_mes_w,
		ds_observacao_w,
		dt_especifica_w,
		ie_avisa_venc_doc_w);

	insert into contrato_controle_doc(
		nr_sequencia,
		nr_seq_regra,
		dt_atualizacao,
		nm_usuario,
		dt_entrega,
		nm_pessoa_entrega,
		ds_observacao)
	SELECT	nextval('contrato_controle_doc_seq'),
		nr_seq_docto_ww,
		clock_timestamp(),
		nm_usuario_p,
		dt_entrega,
		nm_pessoa_entrega,
		ds_observacao
	from	contrato_controle_doc
	where	nr_seq_regra = nr_seq_docto_w;
	end;
end loop;
close c01;
	
if (ie_gera_itens_w = 'S') then
	
	/*cria regras da nota*/

	open c02;
	loop
	fetch c02 into
		nr_seq_regra_nf_w,
		cd_material_w,
		cd_conta_contabil_w,
		cd_centro_custo_w,
		nr_seq_crit_rateio_w,
		ds_complemento_w,
		ds_obs_regra_w,
		nr_seq_conta_financ_w,
		vl_pagto_w,
		dt_inicio_vigencia_w,
		dt_fim_vigencia_w,
		ie_preco_w,
		ie_quantidade_w,
		cd_estabelecimento_w,
		cd_local_estoque_w,
		nr_seq_proj_rec_w,
		vl_desconto_w,
		pr_desconto_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin

		select nextval('contrato_regra_nf_seq')
		into STRICT nr_seq_regra_nf_ww
		;

		insert into contrato_regra_nf(
			nr_sequencia,
			nr_seq_contrato,
			dt_atualizacao,
			nm_usuario,
			cd_material,
			cd_conta_contabil,
			cd_centro_custo,
			nr_seq_crit_rateio,
			ds_complemento,
			ds_observacao,
			nr_seq_conta_financ,
			vl_pagto,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_inicio_vigencia,
			dt_fim_vigencia,
			ie_preco,
			ie_quantidade,
			CD_ESTAB_REGRA,
			cd_local_estoque,
			nr_seq_proj_rec,
			ie_gera_sc_automatico,
			IE_LIBERA_SOLIC,
			vl_desconto,
			pr_desconto,
            ie_situacao)
		values ( nr_seq_regra_nf_ww,
			nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_material_w,
			cd_conta_contabil_w,
			cd_centro_custo_w,
			nr_seq_crit_rateio_w,
			ds_complemento_w,
			ds_obs_regra_w,
			nr_seq_conta_financ_w,
			vl_pagto_w,
			clock_timestamp(),
			nm_usuario_p,
			dt_inicio_vigencia_w,
			dt_fim_vigencia_w,
			ie_preco_w,
			ie_quantidade_w,
			cd_estabelecimento_w,
			cd_local_estoque_w,
			nr_seq_proj_rec_w,
			'N',
			'S',
			vl_desconto_w,
			pr_desconto_w,
            'A');


		insert into contrato_regra_pagto_trib(
			nr_sequencia,
			nr_seq_regra_nf,
			cd_tributo,
			dt_atualizacao,
			nm_usuario,
			vl_tributo,
			pr_tributo,
			cd_beneficiario,
			cd_cond_pagto,
			cd_conta_financ,
			nr_seq_trans_reg,
			nr_seq_trans_baixa,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_corpo_item,
			ie_regra_trib,
			cd_darf)
		SELECT	nextval('contrato_regra_pagto_trib_seq'),
			nr_seq_regra_nf_ww,
			cd_tributo,
			clock_timestamp(),
			nm_usuario_p,
			vl_tributo,
			pr_tributo,
			cd_beneficiario,
			cd_cond_pagto,
			cd_conta_financ,
			nr_seq_trans_reg,
			nr_seq_trans_baixa,
			clock_timestamp(),
			nm_usuario_p,
			ie_corpo_item,
			ie_regra_trib,
			cd_darf
		from	contrato_regra_pagto_trib
		where	nr_seq_regra_nf = nr_seq_regra_nf_w;		
		
		if (nr_seq_regra_nf_w IS NOT NULL AND nr_seq_regra_nf_w::text <> '') and (coalesce(cd_estabelecimento_w,0) > 0) then
			insert into contrato_regra_nf_estab(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_regra_nf,
				cd_estab_regra)
			SELECT	nextval('contrato_regra_nf_estab_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_regra_nf_ww,
				cd_estab_regra
			from	contrato_regra_nf_estab
			where	nr_seq_regra_nf = nr_seq_regra_nf_w;          			
		end if;		
		end;
	end loop;
	close c02;
end if;
/*nao deve criar os anexos*/

nr_seq_novo_p	:= nr_sequencia_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_errata_contrato ( nr_sequencia_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_novo_p INOUT bigint) FROM PUBLIC;

