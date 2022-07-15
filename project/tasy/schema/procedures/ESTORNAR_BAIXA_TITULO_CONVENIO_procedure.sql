-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE estornar_baixa_titulo_convenio ( nr_seq_retorno_p bigint, ds_seq_ret_item_p text, dt_baixa_p timestamp, nm_usuario_p text, nr_seq_retorno_novo_p INOUT text) AS $body$
DECLARE


/* NOVOS REGISTROS GERADOS */

nr_seq_retorno_neg_w	bigint;
nr_seq_retorno_novo_w	bigint;
nr_seq_ret_item_neg_w	bigint;
nr_seq_ret_item_novo_w	bigint;

/* GUIAS DO RETORNO */

nr_seq_ret_item_w	bigint;
cd_autorizacao_w	varchar(20);
nr_interno_conta_w	bigint;
vl_adequado_w		double precision;
vl_adicional_w		double precision;
vl_amenor_w		double precision;
vl_amenor_post_w	double precision;
vl_desconto_w		double precision;
vl_glosado_w		double precision;
vl_glosado_post_w	double precision;
vl_guia_w		double precision;
vl_juros_cobr_w		double precision;
vl_multa_cobr_w		double precision;
vl_nota_credito_w	double precision;
vl_pago_w				double precision;
vl_pago_estorno_w		double precision := 0;
vl_perdas_w				double precision;
vl_juros_w				double precision;	/* nao entra no novo retorno positivo porque eh calculado no vinculo com o recebimento */
vl_cambial_ativo_w		double precision;	/* nao entra no novo retorno positivo porque eh calculado no vinculo com o recebimento */
vl_cambial_passivo_w	double precision;	/* nao entra no novo retorno positivo porque eh calculado no vinculo com o recebimento */
vl_tributo_guia_w		double precision;
nr_titulo_w				bigint;
ie_glosa_w				convenio_retorno_item.ie_glosa%type;
ds_valores_originais_w	convenio_retorno_item.ds_valores_originais%type;
ie_tipo_glosa_w convenio_retorno.ie_tipo_glosa%type;

/* ITENS DA GUIA */

cd_item_convenio_w	varchar(20);
cd_material_w		integer;
cd_motivo_glosa_w	integer;
cd_procedimento_w	bigint;
cd_resposta_w		bigint;
cd_setor_responsavel_w	integer;
ie_origem_proced_w	bigint;
nr_seq_matpaci_w	bigint;
nr_seq_propaci_w	bigint;
nr_seq_ret_glosa_w	bigint;
qt_glosa_w		double precision;
vl_amaior_w		double precision;
vl_cobrado_w		double precision;
vl_glosa_w		double precision;
nr_seq_partic_w		bigint;

/* RECEBIMENTOS DO RETORNO */

nr_seq_receb_w		bigint;
vl_saldo_receb_w	double precision;
ie_status_receb_w	varchar(1);
vl_recebimento_w	double precision;
ie_passivo_saldo_tit_w	varchar(1);

ds_erro_w		varchar(4000);
nr_seq_conta_banco_w	bigint;
nr_seq_baixa_w		bigint;
nr_seq_perda_w		bigint;
vl_vinculacao_w		double precision  	:= 0;
total_estorno_w		double precision  	:= 0;
saldo_w  		double precision  	:= 0;
vl_estorno_w  		double precision  	:= 0;

/* Desfazer desdobramento parcial */

nr_seq_ret_estorno_w	convenio_retorno.nr_sequencia%type;

/* DBMS */

ds_module_w	varchar(2000);
ds_action_w	varchar(2000);	

c01 CURSOR FOR
SELECT	a.cd_autorizacao,
		a.nr_interno_conta,
		a.nr_sequencia,
		a.vl_adequado,
		a.vl_adicional,
		a.vl_amenor,
		a.vl_amenor_post,
		a.vl_desconto,
		a.vl_glosado,
		a.vl_glosado_post,
		a.vl_guia,
		a.vl_juros_cobr,
		a.vl_multa_cobr,
		a.vl_nota_credito,
		a.vl_pago,
		a.vl_perdas,
		a.vl_juros,
		a.vl_cambial_ativo,
		coalesce(a.vl_cambial_passivo,0),
		a.nr_titulo,
		a.ie_glosa,
		a.vl_tributo_guia,
		a.ds_valores_originais
from	convenio_retorno_item a
where	a.nr_seq_retorno	= nr_seq_retorno_p
and	(('C' = ds_seq_ret_item_p and a.nr_sequencia in (SELECT	x.nr_seq_ret_item from w_estornar_conv_ret_item x where x.nr_seq_retorno = nr_seq_retorno_p)) or (coalesce(ds_seq_ret_item_p,'X') = 'X'));



c02 CURSOR FOR
SELECT	a.cd_item_convenio,
		a.cd_material,
		a.cd_motivo_glosa,
		a.cd_procedimento,
		a.cd_resposta,
		a.cd_setor_responsavel,
		a.ie_origem_proced,
		a.nr_seq_matpaci,
		a.nr_seq_propaci,
		a.nr_sequencia,
		a.qt_glosa,
		a.vl_amaior,
		a.vl_cobrado,
		a.vl_glosa,
		a.nr_seq_partic
from	convenio_retorno_glosa a
where	a.nr_seq_ret_item	= nr_seq_ret_item_w;


c03 CURSOR FOR
SELECT	distinct
	b.nr_sequencia,
	b.vl_recebimento,
	a.vl_vinculacao
from	convenio_receb b,
	convenio_ret_receb a
where	a.nr_seq_retorno	= nr_seq_retorno_p
and	a.nr_seq_receb		= b.nr_sequencia
order by a.vl_vinculacao desc;


c04 CURSOR FOR
SELECT	a.nr_titulo,
	a.nr_sequencia
FROM	titulo_receber_liq a
WHERE	a.nr_seq_retorno 	= nr_seq_retorno_p
AND	a.nr_seq_ret_item 	= nr_seq_ret_item_w;



BEGIN

dbms_application_info.read_module(ds_module_w, ds_action_w);

begin
	select	coalesce(nr_sequencia, 0)
	into STRICT	nr_seq_ret_estorno_w
	from	convenio_retorno
	where	nr_seq_ret_origem = nr_seq_retorno_p;
exception
when others then
	nr_seq_ret_estorno_w := 0;
end;

if	nr_seq_ret_estorno_w > 0 and ds_action_w <> 'DESFAZER_DESDOB_PARCIAL' then
	/*
		Retorno utilizado como base para desdobramento de recebimento parcial. Para prosseguir sera necessario estornar ou excluir a sequencia de retorno: #@NR_RETORNO#@
	*/
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1125860, 'NR_RETORNO='||nr_seq_ret_estorno_w);
end if;

dbms_application_info.SET_ACTION('ESTORNAR_BAIXA_TITULO_CONVENIO');

select	coalesce(max(e.ie_passivo_saldo_tit),'S'),
		max(d.ie_tipo_glosa)
into STRICT	ie_passivo_saldo_tit_w, 
		ie_tipo_glosa_w
FROM convenio_retorno d
LEFT OUTER JOIN parametro_contas_receber e ON (d.cd_estabelecimento = e.cd_estabelecimento)
WHERE d.nr_sequencia		= nr_seq_retorno_p;

select	max(a.nr_seq_conta_banco)
into STRICT	nr_seq_conta_banco_w
from	titulo_receber_liq a
where	a.nr_seq_retorno	= nr_seq_retorno_p;

/* Gerar retorno negativo */

select	nextval('convenio_retorno_seq')
into STRICT	nr_seq_retorno_neg_w
;

insert	into convenio_retorno(cd_convenio,
	cd_convenio_particular,
	cd_estabelecimento,
	ds_observacao,
	dt_atualizacao,
	dt_baixa_cr,
	dt_retorno,
	ie_baixa_unica_ret,
	ie_status_retorno,
	ie_tipo_glosa,
	nm_usuario,
	nm_usuario_retorno,
	nr_seq_cobranca,
	nr_seq_protocolo,
	nr_seq_ret_estorno,
	nr_sequencia,
	nr_seq_tipo,
	ie_doc_retorno,
	nr_seq_ret_adiant)
SELECT	a.cd_convenio,
	a.cd_convenio_particular,
	a.cd_estabelecimento,
	wheb_mensagem_pck.get_Texto(313192, 'NR_SEQ_RETORNO_P='|| NR_SEQ_RETORNO_P), /*'Estorno do retorno ' || nr_seq_retorno_p,*/
	clock_timestamp(),
	coalesce(dt_baixa_p,a.dt_baixa_cr),
	clock_timestamp(),
	'N',
	'R',
	CASE WHEN ie_tipo_glosa_w='A' THEN  ie_tipo_glosa_w  ELSE 'N' END ,
	nm_usuario_p,
	nm_usuario_p,
	a.nr_seq_cobranca,
	a.nr_seq_protocolo,
	nr_seq_retorno_p,
	nr_seq_retorno_neg_w,
	a.nr_Seq_tipo,
	a.ie_doc_retorno,
	nr_seq_retorno_p
from	convenio_retorno a
where	a.nr_sequencia	= nr_seq_retorno_p;

--if	(nvl(nr_seq_ret_item_p,0) = 0) then


	/* Gerar retorno positivo */

	select	nextval('convenio_retorno_seq')
	into STRICT	nr_seq_retorno_novo_w
	;

	insert	into convenio_retorno(cd_convenio,
		cd_convenio_particular,
		cd_estabelecimento,
		ds_observacao,
		dt_atualizacao,
		dt_baixa_cr,
		dt_retorno,
		ie_baixa_unica_ret,
		ie_status_retorno,
		ie_tipo_glosa,
		nm_usuario,
		nm_usuario_retorno,
		nr_seq_protocolo,
		nr_sequencia,
		nr_Seq_tipo,
		ie_doc_retorno,
		nr_seq_ret_origem,
		nr_seq_ret_adiant)
	SELECT	a.cd_convenio,
		a.cd_convenio_particular,
		a.cd_estabelecimento,
		CASE WHEN ie_tipo_glosa_w='A' THEN wheb_mensagem_pck.get_Texto(1218045)  ELSE wheb_mensagem_pck.get_Texto(313193, 'NR_SEQ_RETORNO_P='|| NR_SEQ_RETORNO_P) END , /*'Retorno gerado a partir do estorno do retorno ' || nr_seq_retorno_p,*/
		clock_timestamp(),
		coalesce(dt_baixa_p,a.dt_baixa_cr),
		clock_timestamp(),
		'N',
		'R',
		CASE WHEN ie_tipo_glosa_w='A' THEN  'D'  ELSE 'N' END ,
		nm_usuario_p,
		nm_usuario_p,
		a.nr_seq_protocolo,
		nr_seq_retorno_novo_w,
		a.nr_Seq_tipo,
		a.ie_doc_retorno,
		a.nr_seq_ret_origem,
		nr_seq_retorno_p
	from	convenio_retorno a
	where	a.nr_sequencia	= nr_seq_retorno_p;

--end if;
open c01;
loop
fetch c01 into
	cd_autorizacao_w,
	nr_interno_conta_w,
	nr_seq_ret_item_w,
	vl_adequado_w,
	vl_adicional_w,
	vl_amenor_w,
	vl_amenor_post_w,
	vl_desconto_w,
	vl_glosado_w,
	vl_glosado_post_w,
	vl_guia_w,
	vl_juros_cobr_w,
	vl_multa_cobr_w,
	vl_nota_credito_w,
	vl_pago_w,
	vl_perdas_w,
	vl_juros_w,
	vl_cambial_ativo_w,
	vl_cambial_passivo_w,
	nr_titulo_w,
	ie_glosa_w,
	vl_tributo_guia_w,
	ds_valores_originais_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	/* Gerar guias do retorno negativo */

	select	nextval('convenio_retorno_item_seq')
	into STRICT	nr_seq_ret_item_neg_w
	;
	
	insert	into convenio_retorno_item(cd_autorizacao,
		ds_observacao,
		dt_atualizacao,
		ie_analisada,
		ie_glosa,
		ie_libera_repasse,
		nm_usuario,
		nr_interno_conta,
		nr_seq_retorno,
		nr_sequencia,
		nr_titulo,
		vl_adequado,
		vl_adicional,
		vl_amenor,
		vl_amenor_post,
		vl_desconto,
		vl_glosado,
		vl_glosado_post,
		vl_guia,
		vl_juros_cobr,
		vl_multa_cobr,
		vl_nota_credito,
		vl_pago,
		vl_perdas,
		vl_juros,
		vl_cambial_ativo,
		vl_cambial_passivo,
		nr_seq_ret_item_est,
		vl_tributo_guia)
	values (cd_autorizacao_w,
		wheb_mensagem_pck.get_Texto(313194, 'NR_SEQ_RET_ITEM_W='|| NR_SEQ_RET_ITEM_W), /*'Estorno da guia ' || nr_seq_ret_item_w,*/
		clock_timestamp(),
		'N',
		ie_glosa_w,
		'S',
		nm_usuario_p,
		nr_interno_conta_w,
		nr_seq_retorno_neg_w,
		nr_seq_ret_item_neg_w,
		nr_titulo_w,
		vl_adequado_w * -1,
		vl_adicional_w * -1,
		vl_amenor_w * -1,
		vl_amenor_post_w * -1,
		vl_desconto_w * -1,
		vl_glosado_w * -1,
		vl_glosado_post_w * -1,
		vl_guia_w,
		vl_juros_cobr_w * -1,
		vl_multa_cobr_w * -1,
		vl_nota_credito_w * -1,
		vl_pago_w * -1,
		vl_perdas_w * -1,
		vl_juros_w * -1,
		vl_cambial_ativo_w * -1,
		vl_cambial_passivo_w * -1,
		nr_seq_ret_item_w,
		vl_tributo_guia_w * -1);
		
		
		vl_estorno_w := (vl_estorno_w + (vl_pago_w + vl_adicional_w + vl_cambial_passivo_w));

	--if	(nvl(nr_seq_ret_item_p,0) = 0) then


		/* Gerar guias do retorno positivo */

		select	nextval('convenio_retorno_item_seq')
		into STRICT	nr_seq_ret_item_novo_w
		;
		
		if (ie_tipo_glosa_w = 'A') then
			vl_adicional_w	:= 0;
			vl_amenor_w		:= 0;
			vl_amenor_post_w	:= 0;
			vl_glosado_w	:= 0;
			vl_glosado_post_w	:= 0;
		end if;
		
		insert	into convenio_retorno_item(cd_autorizacao,
			ds_observacao,
			dt_atualizacao,
			ie_analisada,
			ie_glosa,
			ie_libera_repasse,
			nm_usuario,
			nr_interno_conta,
			nr_seq_retorno,
			nr_sequencia,
			nr_titulo,
			vl_adequado,
			vl_adicional,
			vl_amenor,
			vl_amenor_post,
			vl_desconto,
			vl_glosado,
			vl_glosado_post,
			vl_guia,
			vl_juros_cobr,
			vl_multa_cobr,
			vl_nota_credito,
			vl_pago,
			vl_perdas,
			vl_tributo_guia,
			ds_valores_originais)
		values (cd_autorizacao_w,
			CASE WHEN ie_tipo_glosa_w='A' THEN wheb_mensagem_pck.get_Texto(1218045)  ELSE wheb_mensagem_pck.get_Texto(313195, 'NR_SEQ_RET_ITEM_W='|| NR_SEQ_RET_ITEM_W) END , /*'Guia gerada a partir do estorno da guia ' || nr_seq_ret_item_w,*/
			clock_timestamp(),
			'N',
			ie_glosa_w,
			'S',
			nm_usuario_p,
			nr_interno_conta_w,
			nr_seq_retorno_novo_w,
			nr_seq_ret_item_novo_w,
			nr_titulo_w,
			vl_adequado_w,
			vl_adicional_w,
			vl_amenor_w,
			vl_amenor_post_w,
			vl_desconto_w,
			vl_glosado_w,
			vl_glosado_post_w,
			vl_guia_w,
			vl_juros_cobr_w,
			vl_multa_cobr_w,
			vl_nota_credito_w,
			CASE WHEN ie_tipo_glosa_w='A' THEN  coalesce(vl_guia_w,0) + coalesce(vl_cambial_passivo_w,0)  ELSE coalesce(vl_pago_w,0) + coalesce(vl_cambial_passivo_w,0) END ,
			vl_perdas_w,
			vl_tributo_guia_w,
			ds_valores_originais_w);

	--end if;
	open c02;
	loop
	fetch c02 into
		cd_item_convenio_w,
		cd_material_w,
		cd_motivo_glosa_w,
		cd_procedimento_w,
		cd_resposta_w,
		cd_setor_responsavel_w,
		ie_origem_proced_w,
		nr_seq_matpaci_w,
		nr_seq_propaci_w,
		nr_seq_ret_glosa_w,
		qt_glosa_w,
		vl_amaior_w,
		vl_cobrado_w,
		vl_glosa_w,
		nr_seq_partic_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */

		/* Gerar itens do retorno negativo */

		insert	into convenio_retorno_glosa(cd_item_convenio,
			cd_material,
			cd_motivo_glosa,
			cd_procedimento,
			cd_resposta,
			cd_setor_responsavel,
			ds_observacao,
			dt_atualizacao,
			ie_atualizacao,
			ie_origem_proced,
			nm_usuario,
			nr_seq_matpaci,
			nr_seq_propaci,
			nr_seq_ret_item,
			nr_sequencia,
			qt_glosa,
			vl_amaior,
			vl_cobrado,
			vl_glosa,
			nr_seq_partic)
		values (cd_item_convenio_w,
			cd_material_w,
			cd_motivo_glosa_w,
			cd_procedimento_w,
			cd_resposta_w,
			cd_setor_responsavel_w,
			wheb_mensagem_pck.get_Texto(313196, 'NR_SEQ_RET_GLOSA_W='|| NR_SEQ_RET_GLOSA_W), /*'Estorno do item ' || nr_seq_ret_glosa_w,*/
			clock_timestamp(),
			'N',
			ie_origem_proced_w,
			nm_usuario_p,
			nr_seq_matpaci_w,
			nr_seq_propaci_w,
			nr_seq_ret_item_neg_w,
			nextval('convenio_retorno_glosa_seq'),
			qt_glosa_w * -1,
			vl_amaior_w * -1,
			vl_cobrado_w,
			vl_glosa_w * -1,
			nr_seq_partic_w);

		if (ie_tipo_glosa_w <> 'A') then

			/* Gerar itens do retorno positivo */

			insert	into convenio_retorno_glosa(cd_item_convenio,
				cd_material,
				cd_motivo_glosa,
				cd_procedimento,
				cd_resposta,
				cd_setor_responsavel,
				ds_observacao,
				dt_atualizacao,
				ie_atualizacao,
				ie_origem_proced,
				nm_usuario,
				nr_seq_matpaci,
				nr_seq_propaci,
				nr_seq_ret_item,
				nr_sequencia,
				qt_glosa,
				vl_amaior,
				vl_cobrado,
				vl_glosa,
				nr_seq_partic)
			values (cd_item_convenio_w,
				cd_material_w,
				cd_motivo_glosa_w,
				cd_procedimento_w,
				cd_resposta_w,
				cd_setor_responsavel_w,
				wheb_mensagem_pck.get_Texto(313197, 'NR_SEQ_RET_GLOSA_W='|| NR_SEQ_RET_GLOSA_W), /*'Item gerado a partir do estorno do item ' || nr_seq_ret_glosa_w,*/
				clock_timestamp(),
				'N',
				ie_origem_proced_w,
				nm_usuario_p,
				nr_seq_matpaci_w,
				nr_seq_propaci_w,
				nr_seq_ret_item_novo_w,
				nextval('convenio_retorno_glosa_seq'),
				qt_glosa_w,
				vl_amaior_w,
				vl_cobrado_w,
				vl_glosa_w,
				nr_seq_partic_w);

		end if;

	end loop;
	close c02;
	
	open C04;
	loop
	fetch C04 into	
		nr_titulo_w,
		nr_seq_baixa_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		select	max(a.nr_Sequencia)
		into STRICT	nr_seq_perda_w
		from	perda_contas_receber a
		where	a.nr_titulo 	= nr_titulo_w
		and	a.nr_seq_baixa 	= nr_seq_baixa_w
		and	vl_saldo > 0;
		
		if (nr_seq_perda_w > 0) then
			CALL fin_cancelar_perda(nr_Seq_perda_w, nm_usuario_p);
		end if;
		end;
	end loop;
	close C04;
end loop;
close c01;


/* Consistir retorno negativo - nao consiste retorno negativo
consistir_Retorno_Convenio(nr_seq_retorno_neg_w,nm_usuario_p,'N','N'); */
update	convenio_retorno
set	ie_status_retorno	= 'C'
where	nr_sequencia		= nr_seq_retorno_neg_w;

total_estorno_w := vl_estorno_w;

/* Vincular retorno negativo */

open c03;
loop
fetch c03 into
	nr_seq_receb_w,
	vl_recebimento_w,
	vl_vinculacao_w;
EXIT WHEN NOT FOUND; /* apply on c03 */


	select	coalesce(sum(a.vl_vinculacao),0)
	into STRICT 	saldo_w
	from	convenio_receb b,
		convenio_ret_receb a
	where	a.nr_seq_retorno	in (SELECT x.nr_sequencia
					from convenio_retorno x 
					where (x.nr_sequencia = nr_seq_retorno_p or x.nr_seq_ret_estorno = nr_seq_retorno_p))
	and	a.nr_seq_receb	= b.nr_sequencia
	and      a.nr_seq_receb 	= nr_seq_receb_w
	order by a.vl_vinculacao desc;

	if (saldo_w > 0) then
		if (vl_estorno_w > saldo_w) then
		
		-- 313192  Estorno do retorno N*

		-- 779895  Valor total das guias selecionadas para estorno $

		-- 779896  Valor vinculado no recebimento disponivel para o estorno $
			
			insert	into convenio_ret_receb(nr_seq_receb,
				nm_usuario,
				dt_atualizacao,
				nr_seq_retorno,
				vl_vinculacao,
				ds_observacao)
			SELECT	a.nr_seq_receb,
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_retorno_neg_w,
				saldo_w * -1,
				(wheb_mensagem_pck.get_Texto(313192, 'NR_SEQ_RETORNO_P='|| nr_seq_retorno_p) || chr(13) || chr(10) ||
				 wheb_mensagem_pck.get_Texto(779895, 'TOTAL_ESTORNO_P='|| total_estorno_w)   || chr(13) || chr(10) || 
				 wheb_mensagem_pck.get_Texto(779896, 'VL_VINCULADO_P='|| a.vl_vinculacao)    || chr(13) || chr(10) || 
				 wheb_mensagem_pck.get_Texto(779910, 'VL_SALDO_P='|| (vl_estorno_w - saldo_w)|| chr(13) || chr(10)))
			from	convenio_ret_receb a
			where	a.nr_seq_retorno		= nr_seq_retorno_p
			and	a.nr_seq_receb		= nr_seq_receb_w;
			
			vl_estorno_w := vl_estorno_w - saldo_w;
			
		elsif (vl_estorno_w > 0) then
			
			insert	into convenio_ret_receb(nr_seq_receb,
				nm_usuario,
				dt_atualizacao,
				nr_seq_retorno,
				vl_vinculacao,
				ds_observacao)
			SELECT	a.nr_seq_receb,
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_retorno_neg_w,
				vl_estorno_w * -1,
				(wheb_mensagem_pck.get_Texto(313192, 'NR_SEQ_RETORNO_P='|| nr_seq_retorno_p)|| chr(13) || chr(10) ||
				 wheb_mensagem_pck.get_Texto(779895, 'TOTAL_ESTORNO_P='|| total_estorno_w)  || chr(13) || chr(10) ||
				 wheb_mensagem_pck.get_Texto(779896, 'VL_VINCULADO_P='|| a.vl_vinculacao)   || chr(13) || chr(10))
			from	convenio_ret_receb a
			where	a.nr_seq_retorno		= nr_seq_retorno_p
			and	a.nr_seq_receb		= nr_seq_receb_w;	
			
			vl_estorno_w := 0;
		end if;
		
	end if;
	

	select	(obter_saldo_receb_convenio(nr_seq_receb_w,clock_timestamp()))::numeric
	into STRICT	vl_saldo_receb_w
	;

	if (coalesce(vl_saldo_receb_w,0) = 0) then
		ie_status_receb_w	:= 'T';
	elsif (coalesce(vl_saldo_receb_w,0) = coalesce(vl_recebimento_w,0)) then
		ie_status_receb_w	:= 'N';
	else
		ie_status_receb_w	:= 'P';
	end if;

	update	convenio_receb
	set	ie_status	= ie_status_receb_w
	where	nr_sequencia	= nr_seq_receb_w;

end loop;
close c03;



update	convenio_retorno
set	dt_vinculacao		= clock_timestamp(),
	ie_status_retorno	= 'V'
where	nr_sequencia		= nr_seq_retorno_neg_w;

CALL GERAR_RET_RECEB_GUIA(nr_seq_retorno_neg_w, 'S', nm_usuario_p);


/* Baixar retorno negativo */

ds_erro_w := baixa_titulo_convenio(nr_seq_retorno_neg_w, nm_usuario_p, nr_seq_conta_banco_w, ds_erro_w, null, null, 'N', null, null);

if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
	/* Alguns itens nao foram baixados, favor verificar! */

	CALL wheb_mensagem_pck.exibir_mensagem_abort(184537,'DS_ERRO_W='||ds_erro_w);
end if;

nr_seq_retorno_novo_p	:= nr_seq_retorno_neg_w;
if (nr_seq_retorno_novo_w IS NOT NULL AND nr_seq_retorno_novo_w::text <> '') then
	nr_seq_retorno_novo_p	:= nr_seq_retorno_novo_p || ' ' || wheb_mensagem_pck.get_Texto(313198) || ' ' || nr_seq_retorno_novo_w;
end if;

if	coalesce(nr_seq_ret_estorno_w, 0) > 0  then
	update	convenio_retorno
	set	nr_seq_ret_origem = nr_seq_retorno_novo_w
	where	nr_sequencia = nr_seq_ret_estorno_w;
end if;

update 	convenio_retorno
set	nr_seq_ret_origem  = NULL
where	nr_sequencia = nr_seq_retorno_p;

dbms_application_info.SET_ACTION('');

/*exception
	when others then
	dbms_application_info.SET_ACTION('');
	wheb_mensagem_pck.exibir_mensagem_abort(182241,'SQL_ERRM='||sqlerrm);
end;*/
delete 	FROM w_estornar_conv_ret_item
where	nr_seq_retorno = nr_seq_retorno_p;

CALL gerar_dashboard_regra(null, nr_seq_retorno_p);
					
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE estornar_baixa_titulo_convenio ( nr_seq_retorno_p bigint, ds_seq_ret_item_p text, dt_baixa_p timestamp, nm_usuario_p text, nr_seq_retorno_novo_p INOUT text) FROM PUBLIC;

