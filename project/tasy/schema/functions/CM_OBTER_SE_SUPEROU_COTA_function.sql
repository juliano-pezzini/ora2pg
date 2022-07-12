-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cm_obter_se_superou_cota ( nr_requisicao_p bigint, nr_seq_conjunto_p bigint) RETURNS varchar AS $body$
DECLARE



cd_setor_atendimento_w		integer;
qt_conjunto_regra_w		bigint;
qt_conj_atendido_w		bigint;
ie_periodo_w			varchar(1);
qt_regra_w			bigint;
nr_seq_conjunto_w		bigint;
ds_retorno_w			varchar(1) := 'N';


BEGIN

select	cd_setor_atendimento
into STRICT	cd_setor_atendimento_w
from	cm_requisicao
where	nr_sequencia = nr_requisicao_p;


select	count(*),
	coalesce(max(qt_conjunto),0),
	coalesce(max(ie_periodo),'D')
into STRICT	qt_regra_w,
	qt_conjunto_regra_w,
	ie_periodo_w
from	cm_conjunto_cota
where	nr_seq_conjunto 		= nr_seq_conjunto_p
and	cd_setor_atendimento	= cd_setor_atendimento_w
and	ie_situacao = 'A';

if (qt_regra_w > 0) then
	begin
	if (ie_periodo_w = 'D') then

		select	count(*)
		into STRICT	qt_conj_atendido_w
		from  	cm_requisicao_conj a,
			cm_requisicao_item b,
			cm_requisicao c
		where	a.nr_seq_item_req = b.nr_sequencia
		and	b.nr_seq_requisicao = c.nr_sequencia
		and	trunc(a.dt_atendimento) = trunc(clock_timestamp())
		and	b.nr_seq_conjunto = nr_seq_conjunto_p
		and	c.cd_setor_atendimento = cd_setor_atendimento_w;

		if (qt_conj_atendido_w >= qt_conjunto_regra_w) then
			ds_retorno_w	:=  'S';
		end if;

	elsif (ie_periodo_w = 'M') then

		select	count(*)
		into STRICT	qt_conj_atendido_w
		from  	cm_requisicao_conj a,
			cm_requisicao_item b,
			cm_requisicao c
			where	a.nr_seq_item_req = b.nr_sequencia
		and	b.nr_seq_requisicao = c.nr_sequencia
		and	trunc(a.dt_atendimento,'mm') = trunc(clock_timestamp(),'mm')
		and	b.nr_seq_conjunto = nr_seq_conjunto_p
		and	c.cd_setor_atendimento = cd_setor_atendimento_w;

		if (qt_conj_atendido_w >= qt_conjunto_regra_w) then
			ds_retorno_w	:=  'S';
		end if;

	end if;
	end;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cm_obter_se_superou_cota ( nr_requisicao_p bigint, nr_seq_conjunto_p bigint) FROM PUBLIC;
