-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importar_d301_segmento_rec (nr_seq_dataset_p bigint, ds_conteudo_rec_p text, nm_usuario_p text) AS $body$
DECLARE


  nr_ident_conta_w            d301_segmento_rec.nr_ident_conta%type;
  ds_dt_conta_w               d301_segmento_rec.ds_dt_conta%type;
  nr_seq_301_indic_cobr_w     d301_segmento_rec.nr_seq_301_indic_cobr%type;
  nr_seq_301_indic_cobr_ped_w d301_segmento_rec.nr_seq_301_indic_cobr_ped%type;
  ds_dt_admissao_w            d301_segmento_rec.ds_dt_admissao%type;
  vl_cobranca_conta_w         d301_segmento_rec.vl_cobranca_conta%type;
  nr_conta_banc_hosp_w        d301_segmento_rec.nr_conta_banc_hosp%type;
  nr_referencia_hosp_w        d301_segmento_rec.nr_referencia_hosp%type;
  nr_ik_cobranca_w            d301_segmento_rec.nr_ik_cobranca%type;
  ds_conteudo_w               varchar(32767);


BEGIN

ds_conteudo_w := replace(ds_conteudo_rec_p,'''','');

if (obter_valor_separador(ds_conteudo_w,1,'+') = 'REC') then

	nr_ident_conta_w            	:= obter_valor_separador(ds_conteudo_w,2,'+');
	ds_dt_conta_w               	:= obter_valor_separador(ds_conteudo_w,3,'+');
	nr_seq_301_indic_cobr_w		:= obter_seq_valor_301('C301_11_INDIC_COBR','IE_INDICADOR',substr(obter_valor_separador(ds_conteudo_w,4,'+'),0,1));
	nr_seq_301_indic_cobr_ped_w	:= obter_seq_valor_301('C301_11_INDIC_COBR_PEDIDO','IE_PEDIDO',substr(obter_valor_separador(ds_conteudo_w,4,'+'),2,2));
	ds_dt_admissao_w            	:= obter_valor_separador(ds_conteudo_w,5,'+');
	vl_cobranca_conta_w         	:= obter_valor_separador(ds_conteudo_w,6,'+');
	nr_conta_banc_hosp_w        	:= obter_valor_separador(ds_conteudo_w,7,'+');
	nr_referencia_hosp_w        	:= obter_valor_separador(ds_conteudo_w,8,'+');
	nr_ik_cobranca_w            	:= obter_valor_separador(ds_conteudo_w,9,'+');

	insert into d301_segmento_rec(	nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_ident_conta,
					ds_dt_conta,
					nr_seq_301_indic_cobr,
					nr_seq_301_indic_cobr_ped,
					ds_dt_admissao,
					vl_cobranca_conta,
					nr_conta_banc_hosp,
					nr_referencia_hosp,
					nr_ik_cobranca,
					nr_seq_dataset,
					nr_seq_dataset_ret)
				values (nextval('d301_segmento_rec_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_ident_conta_w,
					ds_dt_conta_w,
					nr_seq_301_indic_cobr_w,
					nr_seq_301_indic_cobr_ped_w,
					ds_dt_admissao_w,
					vl_cobranca_conta_w,
					nr_conta_banc_hosp_w,
					nr_referencia_hosp_w,
					nr_ik_cobranca_w,
					null,
					nr_seq_dataset_p);

commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importar_d301_segmento_rec (nr_seq_dataset_p bigint, ds_conteudo_rec_p text, nm_usuario_p text) FROM PUBLIC;
