-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_gera_solic_prot ( cd_estabelecimento_p bigint, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


qt_existe_w 		bigint;
ie_gerar_w		varchar(1);
ie_ordem_w		integer;
QT_DIAS_INTERVALO_w	integer;
DT_DIA_FIXO_MES_w	smallint;
IE_CONSIDERA_FERIADO_w	varchar(1);

c01 CURSOR FOR
SELECT	1 ie_ordem,
	ie_gerar
from	REGRA_PROT_TRAN_ESTAB_DIA
where	nr_seq_protocolo = nr_sequencia_p
and	coalesce(ie_dia_semana::text, '') = ''

union all

select	9 ie_ordem,
	ie_gerar
from	REGRA_PROT_TRAN_ESTAB_DIA
where	nr_seq_protocolo = nr_sequencia_p
and	ie_dia_semana	= obter_cod_dia_semana(clock_timestamp())
order by ie_ordem, ie_gerar;


BEGIN
ie_gerar_w := 'S';

select	QT_DIAS_INTERVALO,
	DT_DIA_FIXO_MES,
	IE_CONSIDERA_FERIADO
into STRICT	QT_DIAS_INTERVALO_w,
	DT_DIA_FIXO_MES_w,
	IE_CONSIDERA_FERIADO_w
from	REGRA_PROT_TRANSF_ESTAB
where	nr_sequencia = nr_sequencia_p;

if (coalesce(IE_CONSIDERA_FERIADO_w,'S') = 'N' and (obter_se_feriado( cd_estabelecimento_p,trunc(clock_timestamp(),'dd')) > 0)) then
	ie_gerar_w := 'N';
elsif	((coalesce(DT_DIA_FIXO_MES_w,0) > 0) and (DT_DIA_FIXO_MES_w <> somente_numero(to_char(clock_timestamp(),'dd')))) then
	ie_gerar_w := 'N';
elsif (coalesce(QT_DIAS_INTERVALO_w,0) > 0) then
	begin
	select	count(*)
	into STRICT	qt_existe_w
	from	ordem_compra
	where	nr_seq_protocolo = nr_sequencia_p
	and	trunc(dt_ordem_compra,'dd') >= (trunc(clock_timestamp(),'dd') - QT_DIAS_INTERVALO_w);

	if (qt_existe_w > 0) then
		ie_gerar_w := 'N';
	end if;
	end;
else
	begin
	ie_gerar_w := 'N';
	open C01;
	loop
	fetch C01 into
		ie_ordem_w,
		ie_gerar_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;
	end;
end if;

return	ie_gerar_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_gera_solic_prot ( cd_estabelecimento_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
