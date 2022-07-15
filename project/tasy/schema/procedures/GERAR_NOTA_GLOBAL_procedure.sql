-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nota_global ( cd_serie_nf_p text, nm_usuario_p text, cd_operacao_nf_p bigint, cd_natureza_operacao_p bigint, cd_condicao_pagamento_p bigint, cd_estabelecimento_p bigint, nr_nota_fiscal_p INOUT bigint, nr_sequencia_p INOUT bigint, cd_tipo_relacao_p text, cd_uso_cfdi_p text, cd_convenio_p text) AS $body$
DECLARE



nr_sequencia_w          nota_fiscal.nr_sequencia%TYPE;
ie_tipo_nota_w          nota_fiscal.ie_tipo_nota%TYPE := 'SE';
nr_sequencia_nf_w       nota_fiscal.nr_sequencia_nf%TYPE;
nr_nota_fiscal_w	nota_fiscal.nr_nota_fiscal%TYPE;
cd_cgc_emitente_w	nota_fiscal.cd_cgc_emitente%TYPE;
cd_natureza_operacao_w  natureza_operacao.cd_natureza_operacao%TYPE;
cd_cgc_w                nota_fiscal.cd_cgc%TYPE;


BEGIN

SELECT	nextval('nota_fiscal_seq')
INTO STRICT	nr_sequencia_w
;

select  obter_cgc_convenio(cd_convenio_p)
into STRICT    cd_cgc_w
;

	-- INICIO PEGAR O NR_NOTA_FISCAL
begin
	SELECT	nr_ultima_nf + 1
	INTO STRICT	nr_nota_fiscal_w
	FROM	serie_nota_fiscal
	WHERE	cd_serie_nf 			= cd_serie_nf_p
	AND	cd_estabelecimento 		= cd_estabelecimento_p;
	exception
when no_data_found then
     CALL wheb_mensagem_pck.exibir_mensagem_abort(219156);
end;

SELECT 	max(cd_cgc)
INTO STRICT 	cd_cgc_emitente_w
FROM 	estabelecimento
WHERE 	cd_estabelecimento = cd_estabelecimento_p;

SELECT 	coalesce(MAX(nr_sequencia_nf),0)+1
INTO STRICT	nr_sequencia_nf_w
FROM 	nota_fiscal
WHERE	nr_nota_fiscal 		= nr_nota_fiscal_w
AND	cd_estabelecimento 	= cd_estabelecimento_p
AND	cd_serie_nf 		= cd_serie_nf_p
AND	cd_cgc_emitente		= cd_cgc_emitente_w;


SELECT	coalesce(cd_natureza_operacao,cd_natureza_operacao_p)
INTO STRICT	cd_natureza_operacao_w
FROM	operacao_nota
WHERE	cd_operacao_nf = cd_operacao_nf_p;


INSERT 	INTO nota_fiscal(
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
		dt_contabil,
		cd_cgc,
		cd_pessoa_fisica,
		vl_ipi,
		vl_descontos,
		vl_frete,
		vl_seguro,
		vl_despesa_acessoria,
		vl_despesa_doc,
		ds_observacao,
		nr_nota_referencia,
		cd_serie_referencia,
		cd_natureza_operacao,
		dt_atualizacao_estoque,
		vl_desconto_rateio,
		ie_situacao,
		nr_ordem_compra,
		nr_lote_contabil,
		nr_sequencia,
		vl_conv_moeda,
		ie_entregue_bloqueto,
		ie_tipo_nota,
		cd_setor_digitacao,
		nr_danfe)
	VALUES (	cd_estabelecimento_p,
		cd_cgc_emitente_w,
		cd_serie_nf_p,
		nr_nota_fiscal_w,
		nr_sequencia_nf_w,
		cd_operacao_nf_p,
		clock_timestamp(),
		clock_timestamp(),
		'1',
		'0',
		'0',
		0,
		0,
		0,
		0,
		clock_timestamp(),
		nm_usuario_p,
		cd_condicao_pagamento_p,
		NULL,
		cd_cgc_w,
		null,
		0,
		0,
		NULL,
		0,
		0,
		0,
		null,
		NULL,
		NULL,
		cd_natureza_operacao_w,
		NULL,
		0,
		'1',
		NULL,
		0,
		nr_sequencia_w,
		NULL,
		'N',
		ie_tipo_nota_w,
		NULL,
		NULL);

		IF (cd_tipo_relacao_p IS NOT NULL AND cd_tipo_relacao_p::text <> '') THEN

		INSERT  INTO fis_tipo_relacao(nr_sequencia,
			nr_seq_nota,
			dt_atualizacao,
			nm_usuario,
			cd_tipo_relacao,
			cd_estabelecimento)
		VALUES (	nextval('fis_tipo_relacao_seq'),
			nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_tipo_relacao_p,
			cd_estabelecimento_p);


		END IF;


		IF (cd_uso_cfdi_p IS NOT NULL AND cd_uso_cfdi_p::text <> '') THEN

		INSERT	INTO fis_uso_cfdi(nr_sequencia,
				nr_seq_nota,
				dt_atualizacao,
				nm_usuario,
				cd_uso_cfdi,
				cd_estabelecimento)
		VALUES (	nextval('fis_uso_cfdi_seq'),
				nr_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				cd_uso_cfdi_p,
				cd_estabelecimento_p);

		END IF;


nr_nota_fiscal_p := nr_nota_fiscal_w;
nr_sequencia_p   := nr_sequencia_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nota_global ( cd_serie_nf_p text, nm_usuario_p text, cd_operacao_nf_p bigint, cd_natureza_operacao_p bigint, cd_condicao_pagamento_p bigint, cd_estabelecimento_p bigint, nr_nota_fiscal_p INOUT bigint, nr_sequencia_p INOUT bigint, cd_tipo_relacao_p text, cd_uso_cfdi_p text, cd_convenio_p text) FROM PUBLIC;

