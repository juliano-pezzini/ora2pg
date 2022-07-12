-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_dados_teste ( nr_seq_dialise_dialisador_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


qt_registro_w		bigint;
ds_resultado_w   	varchar(1);
ie_troca_emergencia_w  	varchar(1);
nr_seq_dialisador_w	bigint;
qt_dialisadores_w	bigint;
ie_substituir_maquina_w	varchar(1);

BEGIN

select	ie_troca_emergencia
into STRICT	ie_troca_emergencia_w
from	hd_dialise_dialisador
where	nr_sequencia  = nr_seq_dialise_dialisador_p;


select	max(nr_seq_dialisador)
into STRICT	nr_seq_dialisador_w
from	hd_dialise_dialisador
where	nr_sequencia  = nr_seq_dialise_dialisador_p;

select  count(*)
into STRICT	qt_dialisadores_w
from	hd_dialise_dialisador
where	nr_seq_dialisador = nr_seq_dialisador_w;

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_substituir_maquina_w
from	hd_dialise_dialisador
where	nr_seq_dialise = (SELECT	max(nr_seq_dialise)
			from		hd_dialise_dialisador
			where		nr_sequencia = nr_seq_dialise_dialisador_p)
and	nr_seq_dialisador = nr_seq_dialisador_w
and	(nr_seq_motivo_sub IS NOT NULL AND nr_seq_motivo_sub::text <> '');

if (ie_opcao_p = '1') then

	select	count(*)
	into STRICT	qt_registro_w
	from	hd_dialisador_teste
	where	nr_seq_dialise_dialisador = nr_seq_dialise_dialisador_p
	and	nr_teste   = 1
	and	ie_resultado   = 'P';

elsif (ie_opcao_p = '2') then

	select	count(*)
	into STRICT	qt_registro_w
	from	hd_dialisador_teste
	where	nr_seq_dialise_dialisador = nr_seq_dialise_dialisador_p
	and	nr_teste   = 2
	and	ie_resultado   = 'N';

elsif (ie_opcao_p = '3') then

	select	count(*)
	into STRICT	qt_registro_w
	from	hd_dialisador_teste
	where	nr_seq_dialise_dialisador = nr_seq_dialise_dialisador_p
	and	nr_teste   	= 1
	and	ie_resultado   = 'N';

end if;

if	(((ie_troca_emergencia_w in ('S','U')) and (qt_dialisadores_w = 1)) or (qt_registro_w > 0) or (ie_substituir_maquina_w = 'S')) then
	ds_resultado_w := 'S';
else
	ds_resultado_w := 'N';
end if;

return	ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_dados_teste ( nr_seq_dialise_dialisador_p bigint, ie_opcao_p text) FROM PUBLIC;

