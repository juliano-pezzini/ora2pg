-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_dados_vacina (nr_sequencia_p bigint, nr_seq_vacina_p bigint) AS $body$
DECLARE

ds_lote_w			varchar(255);
dt_validade_lote_w	timestamp;


BEGIN

if (nr_sequencia_p > 0) and (nr_seq_vacina_p > 0) then

select substr(EO_OBTER_DESC_LOTE(nr_sequencia_p),1,255)
into STRICT ds_lote_w
;

select	max(DT_VALIDADE)
into STRICT 	dt_validade_lote_w
from	MATERIAL_LOTE_FORNEC
where	nr_sequencia = nr_sequencia_p;

update PACIENTE_VACINA
set ds_lote = ds_lote_w,
	dt_validade_lote = dt_validade_lote_w
where nr_sequencia = nr_seq_vacina_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_dados_vacina (nr_sequencia_p bigint, nr_seq_vacina_p bigint) FROM PUBLIC;
