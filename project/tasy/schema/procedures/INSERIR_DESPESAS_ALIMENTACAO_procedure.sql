-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_despesas_alimentacao ( nm_usuario_p text, nr_seq_viagem_p bigint, dt_retorno_prev_p timestamp, dt_saida_prev_p timestamp ) AS $body$
DECLARE


nr_cont_w		bigint :=0;
nr_seq_relat_w		bigint;
nr_dias_w		bigint;
vl_diario_w		bigint;
cd_estabelecimento_w	smallint;



BEGIN

select	cd_estabelecimento
into STRICT 	cd_estabelecimento_w
from	via_viagem
where 	nr_sequencia = nr_seq_viagem_p;

select	trunc(dt_retorno_prev_p) - trunc(dt_saida_prev_p)
into STRICT	nr_dias_w
;

select	max(coalesce(vl_dia, 0) - coalesce(vl_beneficio_ref,0))
into STRICT	vl_diario_w
from	via_regra_alimentacao
where	ie_situacao = 'A'
and	cd_estabelecimento = cd_estabelecimento_w;

select 	nextval('via_relat_desp_seq')
into STRICT	nr_seq_relat_w
;

insert into	via_relat_desp(
			nr_sequencia,
			nr_seq_viagem,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_relatorio,
			dt_aprovacao,
			nm_usuario_aprov,
			dt_liberacao,
			nm_usuario_libera,
			dt_recebimento,
			nr_seq_fech_proj)
values (
			nr_seq_relat_w,
			nr_seq_viagem_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			null,
			null,
			null,
			null,
			null,
			null
			);

loop
exit when nr_dias_w = 0;

	insert into via_despesa(
				nr_sequencia,
				nr_seq_relat,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				dt_despesa,
				nr_seq_classif_desp,
				vl_despesa,
				nr_documento,
				ds_complemento,
				ie_responsavel_custo,
				cd_cgc_resp_custo,
				ie_tipo_despesa,
				nr_seq_forma_pagto,
				cd_cgc,
				vl_desp_original,
				ds_justificativa,
				nr_seq_motivo_alt_valor,
				qt_km )
	values (
				nextval('via_despesa_seq'),
				nr_seq_relat_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				trunc(dt_saida_prev_p)+nr_cont_w,
				4,
				vl_diario_w,
				null,
				wheb_mensagem_pck.get_texto(316952), --Valor referente à alimentação diária
				'N',
				null,
				'E',
				5,
				null,
				vl_diario_w,
				wheb_mensagem_pck.get_texto(316951), --Alimentação
				null,
				null);

	nr_cont_w := nr_cont_w + 1;
	nr_dias_w := nr_dias_w - 1;

end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_despesas_alimentacao ( nm_usuario_p text, nr_seq_viagem_p bigint, dt_retorno_prev_p timestamp, dt_saida_prev_p timestamp ) FROM PUBLIC;

