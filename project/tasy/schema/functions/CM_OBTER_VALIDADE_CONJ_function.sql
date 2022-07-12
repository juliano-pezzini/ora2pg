-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cm_obter_validade_conj (nr_seq_ciclo_p bigint, nr_seq_conj_ester_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_retorno_w		timestamp;
nr_seq_metodo_w		bigint;
nr_seq_embalagem_w	bigint;
qt_dias_val_w		integer;


BEGIN

select	b.nr_seq_classif
into STRICT	nr_seq_metodo_w
from  	cm_ciclo a,
	cm_equipamento b
where	a.nr_sequencia = nr_seq_ciclo_p
and	a.nr_seq_equipamento = b.nr_sequencia;

select	nr_seq_embalagem
into STRICT	nr_seq_embalagem_w
from	cm_conjunto_cont
where	nr_sequencia = nr_seq_conj_ester_p
and	coalesce(ie_situacao,'A') = 'A';

select	coalesce(max(coalesce(qt_dia_validade,0)),0)
into STRICT	qt_dias_val_w
from	cm_validade
where	nr_seq_embalagem 	= nr_seq_embalagem_w
and	nr_seq_metodo	= nr_seq_metodo_w;

if (qt_dias_val_w > 0) then
	begin
	select (trunc(clock_timestamp()) + qt_dias_val_w)
	into STRICT	dt_retorno_w
	;
	end;
end if;

return dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cm_obter_validade_conj (nr_seq_ciclo_p bigint, nr_seq_conj_ester_p bigint) FROM PUBLIC;
