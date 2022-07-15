-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cme_insert_generate_item ( nr_seq_conjunto_p bigint, nr_seq_ciclo_p bigint, nr_seq_lote_p bigint, cd_setor_atendimento_p bigint, nm_usuario_barras_p text, cd_estabelecimento_p bigint, nr_seq_ciclo_lav_p bigint, ds_erro_p INOUT bigint) AS $body$
DECLARE


nr_seq_ciclo_w       	cm_conjunto_cont.nr_seq_ciclo%type;
nr_seq_lote_w        	cm_conjunto_cont.nr_seq_lote%type;
nr_seq_embalagem_w   	cm_conjunto.nr_seq_embalagem%type;
qt_ponto_w           	cm_conjunto.qt_ponto%type;
nr_sequencia_w       	cm_conjunto_cont.nr_sequencia%type;
nr_seq_controle_w    	cm_conjunto_cont.nr_seq_controle%type;


BEGIN

nr_seq_ciclo_w		:= coalesce(nr_seq_ciclo_p,0);
nr_seq_lote_w		:= coalesce(nr_seq_lote_p,0);

select	nr_seq_embalagem,
	qt_ponto,
  nr_sequencia
into STRICT	nr_seq_embalagem_w,
	qt_ponto_w,
  nr_seq_controle_w
from	cm_conjunto
where	nr_sequencia = nr_seq_conjunto_p;

select	nextval('cm_conjunto_cont_seq')
into STRICT	nr_sequencia_w
;


INSERT INTO CM_CONJUNTO_CONT(
		NR_SEQUENCIA   ,
		CD_ESTABELECIMENTO ,
		DT_ATUALIZACAO   ,  
		NM_USUARIO       ,  
		IE_STATUS_CONJUNTO  ,
		DT_ORIGEM          ,
		NM_USUARIO_ORIGEM  ,
		NR_SEQ_EMBALAGEM   ,
		QT_PONTO           ,
		VL_ESTERILIZACAO   ,
		NR_SEQ_CONJUNTO    ,
		NR_SEQ_CICLO      ,
		NR_SEQ_LOTE        ,
		CD_SETOR_ATENDIMENTO,
		NM_USUARIO_BAIXA_CIRURGIA,
		NR_SEQ_CICLO_LAV,
		NR_SEQ_ITEM)
	Values (
		nr_sequencia_w,
		cd_estabelecimento_p,
		clock_timestamp(),
		NM_USUARIO_BARRAS_P,
		1,
		clock_timestamp(),
		NM_USUARIO_BARRAS_P,
		nr_seq_embalagem_w,
		qt_ponto_w,
		0,
		null,
		nr_seq_ciclo_p,
		null,
		cd_setor_atendimento_p,
		NM_USUARIO_BARRAS_P,
		nr_seq_ciclo_lav_p,
		nr_seq_conjunto_p
    );
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cme_insert_generate_item ( nr_seq_conjunto_p bigint, nr_seq_ciclo_p bigint, nr_seq_lote_p bigint, cd_setor_atendimento_p bigint, nm_usuario_barras_p text, cd_estabelecimento_p bigint, nr_seq_ciclo_lav_p bigint, ds_erro_p INOUT bigint) FROM PUBLIC;

