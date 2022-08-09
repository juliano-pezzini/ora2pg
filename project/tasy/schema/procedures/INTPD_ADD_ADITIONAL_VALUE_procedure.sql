-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_add_aditional_value ( ds_name_p text, DS_VALUE_p text, ie_tipo_p text, NR_SEQ_FILA_p text ) AS $body$
BEGIN

insert into INTPD_DATA_RECEIVE(	nr_sequencia,
								DT_ATUALIZACAO,
								DT_ATUALIZACAO_NREC,
								NM_USUARIO,
								NM_USUARIO_NREC,
								DS_NAME,
								DS_VALUE,
								IE_TIPO,
								NR_SEQ_FILA)
						values (	nextval('intpd_data_receive_seq'),
								clock_timestamp(),
								clock_timestamp(),
								'INTPD',
								'INTPD',
								ds_name_p,
								DS_VALUE_p,
								ie_tipo_p,
								NR_SEQ_FILA_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_add_aditional_value ( ds_name_p text, DS_VALUE_p text, ie_tipo_p text, NR_SEQ_FILA_p text ) FROM PUBLIC;
