-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rop_obter_qtde_lavagens ( nr_seq_roupa_p bigint) RETURNS bigint AS $body$
DECLARE


qt_lavagens_w			bigint;


BEGIN

select	count(distinct a.nr_sequencia)
into STRICT	qt_lavagens_w
from	rop_lote_movto a,
	rop_movto_roupa b
where	a.nr_sequencia = b.nr_seq_lote
and	b.nr_seq_roupa = nr_seq_roupa_p
and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and	(((coalesce(a.nr_seq_lavanderia::text, '') = '') 	and (rop_obter_dados_operacao(a.nr_seq_operacao,'T') = 'EL')) or
	 ((a.nr_seq_lavanderia IS NOT NULL AND a.nr_seq_lavanderia::text <> '') 	and (obter_dados_lavanderia(a.nr_seq_lavanderia,'EV') = 'S')));

return	qt_lavagens_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rop_obter_qtde_lavagens ( nr_seq_roupa_p bigint) FROM PUBLIC;
