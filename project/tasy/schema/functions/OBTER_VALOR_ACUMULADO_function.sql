-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_acumulado ( nr_seq_tabela_p text, cd_estabelecimento_p text, ie_valor_p text, ie_classif_conta_p text, cd_centro_controle_p bigint, nr_seq_ng_p bigint) RETURNS bigint AS $body$
DECLARE



vl_retorno_w 		double precision;
nr_seq_tabela_w		bigint;
vl_mes_w		double precision;
dt_mesano_final_w	timestamp;
dt_inicio_ano_w		timestamp;



C01 CURSOR FOR
	SELECT	nr_sequencia
	from	tabela_custo
	where	to_char(dt_mes_referencia,'mm/yyyy') between to_char(to_date(dt_inicio_ano_w),'mm/yyyy') and to_char(to_date(dt_mesano_final_w),'mm/yyyy')
	and	ie_orcado_real 		= ie_valor_p
	and	cd_tipo_tabela_custo 	= 11;



BEGIN
vl_retorno_w		:=	0;

select  dt_mes_referencia
into STRICT    dt_mesano_final_w
from	tabela_custo
where	nr_sequencia = nr_seq_tabela_p;

dt_inicio_ano_w		:= trunc(dt_mesano_final_w,'year');



open C01;
loop
fetch C01 into
	nr_seq_tabela_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

		select	coalesce(sum(vl_mes),0)
		into STRICT	vl_mes_w
		from	resultado_centro_controle
		where	nr_seq_tabela = nr_seq_tabela_w
		and	cd_centro_controle = cd_centro_controle_p
		and	coalesce(nr_seq_ng, 0)	= coalesce(nr_seq_ng_p,0)
		and	ie_classif_conta = ie_classif_conta_p;


	vl_retorno_w := vl_retorno_w + vl_mes_w;

	end;
end loop;
close C01;


return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_acumulado ( nr_seq_tabela_p text, cd_estabelecimento_p text, ie_valor_p text, ie_classif_conta_p text, cd_centro_controle_p bigint, nr_seq_ng_p bigint) FROM PUBLIC;
