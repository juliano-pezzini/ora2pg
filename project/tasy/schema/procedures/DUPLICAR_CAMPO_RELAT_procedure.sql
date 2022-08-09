-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_campo_relat ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	bigint;


BEGIN

select nextval('banda_relat_campo_seq')
into STRICT nr_sequencia_w
;

insert into banda_relat_campo(
	nr_sequencia,
	nr_seq_banda,
	ds_campo,
	nr_seq_apresentacao,
	ie_tipo_campo,
	dt_atualizacao,
	nm_usuario,
	ie_borda_sup,
	ie_borda_inf,
	ie_borda_esq,
	ie_borda_dir,
	ie_totalizar,
	ie_campo_quebra,
	ie_quebra_pagina,
	ie_zera_apos_imprimir,
	ie_transparente,
	ie_alinhamento,
	ie_ajustar_tamanho,
	ie_estender,
	ie_alinhar_banda,
  	qt_altura,
	qt_tamanho,
	qt_topo,
	qt_esquerda,
	ds_label,
	nm_atributo,
	ds_conteudo,
       ds_expressao,
	ds_mascara,
	ds_sql,
	ds_cor_fundo,
	qt_tam_fonte,
	ds_cor_fonte,
	ds_tipo_fonte,
	ie_tipo_barcode,
	ie_humano_barcode,
	pr_altura_barcode,
	qt_fonte_barcode,
	ds_estilo_fonte,
	ds_cor_label,
	ie_altera_valor,
	ie_metodo_estender)
SELECT	nr_sequencia_w,
	nr_seq_banda,
	ds_campo,
	nr_seq_apresentacao,
	ie_tipo_campo,
	clock_timestamp(),
	nm_usuario_p,
	ie_borda_sup,
	ie_borda_inf,
	ie_borda_esq,
	ie_borda_dir,
	ie_totalizar,
	ie_campo_quebra,
	ie_quebra_pagina,
	ie_zera_apos_imprimir,
	ie_transparente,
	ie_alinhamento,
	ie_ajustar_tamanho,
	ie_estender,
	ie_alinhar_banda,
  	qt_altura,
	qt_tamanho,
	qt_topo,
	qt_esquerda,
	ds_label,
	nm_atributo,
	ds_conteudo,
       ds_expressao,
	ds_mascara,
	ds_sql,
	ds_cor_fundo,
	qt_tam_fonte,
	ds_cor_fonte,
	ds_tipo_fonte,
	ie_tipo_barcode,
	ie_humano_barcode,
	pr_altura_barcode,
	qt_fonte_barcode,
	ds_estilo_fonte,
	ds_cor_label,
	ie_altera_valor,
	ie_metodo_estender
from banda_relat_campo
where nr_sequencia = nr_sequencia_p;



insert into banda_relat_campo_longo(
   nr_sequencia,
   nr_seq_banda_relat_campo,
   dt_atualizacao,
   nm_usuario,
   dt_atualizacao_nrec,
   nm_usuario_nrec,
   ds_conteudo)
SELECT nextval('banda_relat_campo_longo_seq'),
   nr_sequencia_w,
   a.dt_atualizacao,
   a.nm_usuario,
   a.dt_atualizacao_nrec,
   a.nm_usuario_nrec,
   a.ds_conteudo
from  banda_relat_campo_longo a
where  nr_seq_banda_relat_campo = nr_sequencia_p;

commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_campo_relat ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
