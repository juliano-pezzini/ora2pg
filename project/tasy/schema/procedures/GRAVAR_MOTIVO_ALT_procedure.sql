-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_motivo_alt ( nr_seq_cronograma_p bigint, ds_motivo_p text, ds_comentario_p text, nr_seq_cron_etapa_p bigint) AS $body$
DECLARE



nr_sequencia_w			bigint;



BEGIN
select 	max(nr_sequencia)
into STRICT	nr_sequencia_w
from  	gpi_log_data
where	nr_seq_cronograma  = nr_seq_cronograma_p
and		nr_seq_cron_etapa	=	nr_seq_cron_etapa_p;

update gpi_log_data
set		ds_motivo 	  = ds_motivo_p,
		ds_observacao = ds_comentario_p
where	nr_sequencia  = nr_sequencia_w;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_motivo_alt ( nr_seq_cronograma_p bigint, ds_motivo_p text, ds_comentario_p text, nr_seq_cron_etapa_p bigint) FROM PUBLIC;
