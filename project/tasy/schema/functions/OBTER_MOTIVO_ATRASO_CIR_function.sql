-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_motivo_atraso_cir ( nr_cirurgia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*
ie_opcao_p
d - descrição
c - código
t - tempo
*/
ds_retorno_w	varchar(100) := null;
nr_seq_motivo_w	bigint;
qt_tempo_w	integer;


BEGIN

select	coalesce(max(nr_seq_motivo),0),
	coalesce(max(qt_tempo),0)
into STRICT	nr_seq_motivo_w,
	qt_tempo_w
from	cir_paciente_atraso
where	nr_cirurgia		=	nr_cirurgia_p
and	dt_atualizacao_nrec	= 	(SELECT	max(dt_atualizacao_nrec)
					 from	cir_paciente_atraso
					 where	nr_cirurgia = nr_cirurgia_p);

if (ie_opcao_p = 'D') and (nr_seq_motivo_w > 0) then
	select	ds_motivo
	into STRICT	ds_retorno_w
	from	cir_motivo_atraso
	where	nr_sequencia	=	nr_seq_motivo_w;
elsif (ie_opcao_p = 'C') and (nr_seq_motivo_w > 0) then
	ds_retorno_w	:= nr_seq_motivo_w;
elsif (ie_opcao_p = 'T') then
	ds_retorno_w	:= qt_tempo_w;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_motivo_atraso_cir ( nr_cirurgia_p bigint, ie_opcao_p text) FROM PUBLIC;
