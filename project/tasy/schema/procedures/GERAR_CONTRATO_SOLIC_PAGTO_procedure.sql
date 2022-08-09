-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_contrato_solic_pagto ( nr_solic_compra_p bigint, nr_seq_tipo_contrato_p bigint, nr_seq_subtipo_contrato_p text, cd_cond_pagto_p text, cd_setor_resp_p text, ie_renovacao_p text, cd_pessoa_resp_p text, qt_dias_rescisao_p bigint, dt_inicio_p timestamp, dt_final_p timestamp, nr_seq_motivo_cancel_p bigint, nm_usuario_p text, nr_seq_contrato_p INOUT bigint) AS $body$
DECLARE


nr_seq_contrato_w				bigint;
cd_Estabelecimento_w			bigint;
cd_fornec_sugerido_w			varchar(14);
cd_pessoa_fisica_w			varchar(10);
cd_local_estoque_w			integer;
cd_conta_contabil_w			varchar(20);
cd_centro_custo_w				integer;
cd_material_w				integer;
nr_sequencia_w				bigint;
nr_cot_compra_w				bigint;
dt_geracao_ordem_compra_w		timestamp;
ds_tipo_servico_w			varchar(255);

c01 CURSOR FOR
SELECT	cd_material
from	solic_compra_item
where	nr_solic_compra = nr_solic_compra_p;

c02 CURSOR FOR
SELECT	distinct
	b.nr_cot_compra,
	a.dt_geracao_ordem_compra
from	cot_compra a,
	cot_compra_item b
where	a.nr_cot_compra = b.nr_cot_compra
and	b.nr_solic_compra = nr_solic_compra_p;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_sequencia_w
from	contrato
where	nr_solic_compra = nr_solic_compra_p;

if (nr_sequencia_w > 0) then
	/*(-20011,'Já existe um contrato para esta solicitação. Contrato: ' || nr_sequencia_w || '.');*/

	CALL wheb_mensagem_pck.exibir_mensagem_abort(189952,'NR_SEQUENCIA_W='||nr_sequencia_w);
end if;

open C02;
loop
fetch C02 into
	nr_cot_compra_w,
	dt_geracao_ordem_compra_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	if (dt_geracao_ordem_compra_w IS NOT NULL AND dt_geracao_ordem_compra_w::text <> '') then
		/*(-20011,'Não é possível gerar o contrato, porque já foi gerado ordem de compra desta solicitação. Verifique na cotação número   ' || nr_cot_compra_w || ' que já possui ordem de compra.');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(189955,'NR_COT_COMPRA_W='||NR_COT_COMPRA_W);
	end if;
	end;
end loop;
close C02;

select	cd_fornec_sugerido,
	cd_pessoa_fisica,
	cd_Estabelecimento,
	cd_local_estoque,
	cd_centro_custo,
	cd_conta_contabil,
	substr(obter_valor_dominio(4200,ie_tipo_servico),1,255)
into STRICT	cd_fornec_sugerido_w,
	cd_pessoa_fisica_w,
	cd_Estabelecimento_w,
	cd_local_estoque_w,
	cd_centro_custo_w,
	cd_conta_contabil_w,
	ds_tipo_servico_w
from	solic_compra
where	nr_solic_compra = nr_solic_compra_p;

select	nextval('contrato_seq')
into STRICT	nr_seq_contrato_w
;

insert into contrato(
	nr_sequencia,
	nr_seq_tipo_contrato,
	nr_seq_subtipo_contrato,
	cd_setor,
	cd_pessoa_resp,
	ds_objeto_contrato,
	dt_atualizacao,
	nm_usuario,
	dt_inicio,
	dt_fim,
	cd_estabelecimento,
	ie_avisa_vencimento,
	ie_avisa_venc_setor,
	ie_classificacao,
	ie_avisa_reajuste,
	ie_prazo_contrato,
	ie_renovacao,
	ie_situacao,
	qt_dias_rescisao,
	cd_cgc_contratado,
	cd_pessoa_contratada,
	cd_condicao_pagamento,
	nr_solic_compra,
	ie_periodo_nf)
values (	nr_seq_contrato_w,
	nr_seq_tipo_contrato_p,
	nr_seq_subtipo_contrato_p,
	cd_setor_resp_p,
	cd_pessoa_resp_p,
	Wheb_mensagem_pck.get_Texto(301317, 'DS_TIPO_SERVICO_W='|| DS_TIPO_SERVICO_W),
	clock_timestamp(),
	nm_usuario_p,
	dt_inicio_p,
	dt_final_p,
	cd_estabelecimento_w,
	'N',
	'S',
	'AT',
	'N',
	'D',
	ie_renovacao_p,
	'A',
	qt_dias_rescisao_p,
	cd_fornec_sugerido_w,
	cd_pessoa_fisica_w,
	cd_cond_pagto_p,
	nr_solic_compra_p,
	'N');

open c01;
loop
fetch c01 into
	cd_material_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	insert into contrato_regra_nf(
		nr_sequencia,
		nr_seq_contrato,
		dt_atualizacao,
		nm_usuario,
		cd_material,
		dt_inicio_vigencia,
		dt_fim_vigencia,
		vl_pagto,
		cd_estab_regra,
		cd_centro_custo,
		cd_conta_contabil,
		cd_local_estoque,
		ie_tipo_regra,
		ie_gera_sc_automatico)
	values (	nextval('contrato_regra_nf_seq'),
		nr_seq_contrato_w,
		clock_timestamp(),
		nm_usuario_p,
		cd_material_w,
		dt_inicio_p,
		dt_final_p,
		null,
		cd_estabelecimento_w,
		cd_centro_custo_w,
		cd_conta_contabil_w,
		cd_local_estoque_w,
		'SP',
		'N');
	end;
end loop;
close c01;

update	solic_compra
set	nr_seq_motivo_cancel = nr_seq_motivo_cancel_p,
	dt_baixa = clock_timestamp()
where	nr_solic_compra = nr_solic_compra_p;

open C02;
loop
fetch C02 into
	nr_cot_compra_w,
	dt_geracao_ordem_compra_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	update	cot_compra
	set	nr_seq_motivo_cancel = nr_seq_motivo_cancel_p
	where	nr_cot_compra = nr_cot_compra_w;
	end;
end loop;
close C02;

CALL gerar_historico_solic_compra(
	nr_solic_compra_p,
	Wheb_mensagem_pck.get_Texto(301318),
	Wheb_mensagem_pck.get_Texto(301319, 'NR_SEQ_CONTRATO_W='|| NR_SEQ_CONTRATO_W ), /*'Gerado o contrato ' || NR_SEQ_CONTRATO_W || ' desta solicitação de pagamento, a partir da opção Gerar contrato.',*/
	'D',
	nm_usuario_p);

commit;

nr_seq_contrato_p	:= nr_seq_contrato_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_contrato_solic_pagto ( nr_solic_compra_p bigint, nr_seq_tipo_contrato_p bigint, nr_seq_subtipo_contrato_p text, cd_cond_pagto_p text, cd_setor_resp_p text, ie_renovacao_p text, cd_pessoa_resp_p text, qt_dias_rescisao_p bigint, dt_inicio_p timestamp, dt_final_p timestamp, nr_seq_motivo_cancel_p bigint, nm_usuario_p text, nr_seq_contrato_p INOUT bigint) FROM PUBLIC;
