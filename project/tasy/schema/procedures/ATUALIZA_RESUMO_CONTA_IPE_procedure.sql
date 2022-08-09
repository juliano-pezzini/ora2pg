-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_resumo_conta_ipe (nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;
nr_seq_protocolo_w		bigint;
nr_interno_conta_w		bigint;
nr_seq_conta_convenio_w		bigint;
vl_total_item_w			double precision;
vl_original_w			double precision;



C01 CURSOR FOR
SELECT nr_seq_protocolo,
	 nr_interno_conta,
	 coalesce(nr_seq_conta_convenio,0),
	 sum(vl_total_item),
	 sum(coalesce(vl_original,0))
from	 w_interf_conta_item_ipe
where	 nr_seq_protocolo	= nr_seq_protocolo_p
group by
	 nr_seq_protocolo,
	 nr_interno_conta,
	 coalesce(nr_seq_conta_convenio,0)
order by 1,3,2;




BEGIN
/* Limpar tabela */

delete from ipe_conta_resumo
where nr_seq_protocolo	= nr_seq_protocolo_p;
commit;

OPEN C01;
LOOP
FETCH C01 	into
		nr_seq_protocolo_w,
		nr_interno_conta_w,
		nr_seq_conta_convenio_w,
		vl_total_item_w,
		vl_original_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
     		BEGIN
		select nextval('ipe_conta_resumo_seq')
		into STRICT	 nr_sequencia_w
		;

		insert into ipe_conta_resumo(
			 nr_sequencia,
			 nr_seq_protocolo,
			 nr_interno_conta,
			 nr_seq_conta_convenio,
			 vl_total_conta,
			 dt_atualizacao,
			 nm_usuario,
			 vl_original)
		values (
			 nr_sequencia_w,
			 nr_seq_protocolo_w,
			 nr_interno_conta_w,
			 nr_seq_conta_convenio_w,
			 vl_total_item_w,
			 clock_timestamp(),
			 nm_usuario_p,
			 vl_original_w);
		END;
END LOOP;
close C01;
commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_resumo_conta_ipe (nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;
