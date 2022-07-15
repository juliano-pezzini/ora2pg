-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_solic_entr_gtplan ( nr_seq_item_p text, qt_entrega_p text, dt_entrega_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	bigint;


BEGIN

select	nextval('w_solic_compra_entr_gtplan_seq')
into STRICT	nr_sequencia_w
;

insert into w_solic_compra_entr_gtplan(
			nr_sequencia,
			nr_seq_item,
			qt_entrega,
			dt_entrega,
			dt_atualizacao,
			dt_atualizacao_nrec,
			nm_usuario,
			nm_usuario_nrec )
values (		nr_sequencia_w,
			nr_seq_item_p,
			qt_entrega_p,
			to_date(dt_entrega_p, 'dd/mm/yyyy'),
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p);


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_solic_entr_gtplan ( nr_seq_item_p text, qt_entrega_p text, dt_entrega_p text, nm_usuario_p text) FROM PUBLIC;

