-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consitir_adt_contrato ( nr_seq_contrato_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE


cd_cgc_contratado_w		varchar(14);


BEGIN

select	cd_cgc_contratado
into STRICT	cd_cgc_contratado_w
from	contrato
where	nr_sequencia = nr_seq_contrato_p;



update	contrato
set	cd_cgc_contratado = cd_cgc_contratado_w
where	nr_seq_contrato_atual = nr_seq_contrato_p
and	cd_cgc_contratado <> cd_cgc_contratado_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consitir_adt_contrato ( nr_seq_contrato_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
