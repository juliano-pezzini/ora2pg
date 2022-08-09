-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_qrcode (nr_sequencia_p bigint, nr_seq_qrcode_p bigint, ds_tipo_relatorio_p text) AS $body$
BEGIN

if (upper(ds_tipo_relatorio_p) = 'RECEITA') then
    update med_receita
    set nr_seq_qrcode = nr_seq_qrcode_p
    where nr_sequencia = nr_sequencia_p;

elsif (upper(ds_tipo_relatorio_p) = 'ATESTADO') then 
    update atestado_paciente
    set nr_seq_qrcode = nr_seq_qrcode_p
    where nr_sequencia = nr_sequencia_p;

end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_qrcode (nr_sequencia_p bigint, nr_seq_qrcode_p bigint, ds_tipo_relatorio_p text) FROM PUBLIC;
