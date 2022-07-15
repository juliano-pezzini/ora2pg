-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_receb_conv_adiant (nr_adiantamento_p bigint, cd_convenio_p bigint, NR_SEQ_TRANS_FIN_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_receb_w		bigint;
ds_mensagem_w		varchar(255);
/* Projeto Multimoeda - Variáveis */

vl_adto_estrang_w	double precision;
vl_cotacao_w		cotacao_moeda.vl_cotacao%type;
vl_adiantamento_w	double precision;
vl_complemento_w	double precision;
cd_moeda_w		integer;


BEGIN

select	max(vl_adto_estrang),
	max(vl_cotacao),
	max(vl_adiantamento),
	max(cd_moeda)
into STRICT	vl_adto_estrang_w,
	vl_cotacao_w,
	vl_adiantamento_w,
	cd_moeda_w
from	adiantamento
where	nr_adiantamento = nr_adiantamento_p;

select	nextval('convenio_receb_seq')
into STRICT	nr_seq_receb_w
;

/* Projeto Multimoeda - Verifica se o adiantamento é moeda estrangeira */

if (coalesce(vl_adto_estrang_w,0) <> 0 and coalesce(vl_cotacao_w,0) <> 0) then
	vl_complemento_w := vl_adiantamento_w - vl_adto_estrang_w;
else
	vl_adto_estrang_w := null;
	vl_complemento_w := null;
	vl_cotacao_w := null;
	cd_moeda_w := null;
end if;

ds_mensagem_w := substr(wheb_mensagem_pck.get_texto(303029) || to_char(nr_adiantamento_p),1,255);
insert	into convenio_receb(NR_SEQUENCIA,
	CD_CONVENIO,
	DT_RECEBIMENTO,
	VL_RECEBIMENTO,
	DT_ATUALIZACAO,
	NM_USUARIO,
	IE_STATUS,
	NR_SEQ_CONTA_BANCO,
	NR_SEQ_TRANS_FIN,
	NR_LOTE_CONTABIL,
	DS_OBSERVACAO,
	VL_DESPESA_BANCARIA,
	VL_DEPOSITO,
	DT_FLUXO_CAIXA,
	CD_ESTABELECIMENTO,
	DT_LIBERACAO,
	IE_INTEGRAR_CB_FLUXO,
	IE_TIPO_GLOSA,
	NR_ADIANTAMENTO,
	vl_moeda_original,
	tx_cambial,
	cd_moeda)
SELECT	nr_seq_receb_w,
	cd_convenio_p,
	DT_ADIANTAMENTO,
	VL_ADIANTAMENTO,
	clock_timestamp(),
	NM_USUARIO_p,
	'N',
	NR_SEQ_CONTA_BANCO,
	NR_SEQ_TRANS_FIN_p,
	0,
	ds_mensagem_w,
	0,
	VL_ADIANTAMENTO,
	null,
	CD_ESTABELECIMENTO,
	null,
	'N',
	'N',
	NR_ADIANTAMENTO,
	vl_adto_estrang_w,  -- Projeto Multimoeda - Retorna os valores em moeda estrangeira quando adiantamento em moeda estrangeira.
	vl_cotacao_w,
	cd_moeda_w
from	adiantamento
where	nr_adiantamento	= nr_adiantamento_p;

CALL ATUALIZAR_SALDO_ADIANTAMENTO(nr_adiantamento_p, nm_usuario_p, null, vl_cotacao_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_receb_conv_adiant (nr_adiantamento_p bigint, cd_convenio_p bigint, NR_SEQ_TRANS_FIN_p bigint, nm_usuario_p text) FROM PUBLIC;

