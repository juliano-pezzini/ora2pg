-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pat_obter_estab_bem_periodo (nr_seq_bem_p bigint, dt_parametro_p timestamp) RETURNS bigint AS $body$
DECLARE


qt_existe_w			smallint;
dt_parametro_w			timestamp := fim_dia(dt_parametro_p);
cd_estab_periodo_w		estabelecimento.cd_estabelecimento%type;


BEGIN

begin
/*
Verificar se existiu transferência do bem
*/
select	1
into STRICT	qt_existe_w
from	pat_tipo_historico b,
	pat_historico_bem a
where	a.nr_seq_tipo = b.nr_sequencia
and	a.nr_seq_bem = nr_seq_bem_p
and	b.ie_transferencia = 'S'  LIMIT 1;
exception
when others then
	/*
	Se não existiu então é o estabelecimento que o bem está no momento
	*/
	select	a.cd_estabelecimento
	into STRICT	cd_estab_periodo_w
	from	pat_bem a
	where	a.nr_sequencia = nr_seq_bem_p;
end;

/*
Se existiu transferência então é o último estab destino até a data de parâmetro
*/
if (coalesce(qt_existe_w,0) = 1) then
	begin
	begin
	select	cd_estab_destino
	into STRICT	cd_estab_periodo_w
	from (
		SELECT	a.cd_estab_destino
		from	pat_tipo_historico b,
			pat_historico_bem a
		where	a.nr_seq_tipo = b.nr_sequencia
		and	a.nr_seq_bem = nr_seq_bem_p
		and	b.ie_transferencia = 'S'
		and	a.dt_historico <= dt_parametro_w
		order by a.dt_historico desc
		) alias2 LIMIT 1;
	exception
	when others then
		/*
		Se o bem ainda não foi transferido, então pega o primeiro estab ORIGEM que achar nas transferências
		*/
		select	cd_estab_origem
		into STRICT	cd_estab_periodo_w
		from (
			SELECT	a.cd_estab_origem
			from	pat_tipo_historico b,
				pat_historico_bem a
			where	a.nr_seq_tipo = b.nr_sequencia
			and	a.nr_seq_bem = nr_seq_bem_p
			and	b.ie_transferencia = 'S'
			order by a.dt_historico
			) alias0 LIMIT 1;
	end;

	end;
end if;

/*
Se por alguma razão não encontrou um estabelecimento, então pega o estab atual do bem
*/
if (coalesce(nr_seq_bem_p,0) <> 0) and (coalesce(cd_estab_periodo_w,0) = 0) then
	begin

	select	max(a.cd_estabelecimento)
	into STRICT	cd_estab_periodo_w
	from	pat_bem a
	where	a.nr_sequencia = nr_seq_bem_p;

	end;
end if;

return	cd_estab_periodo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pat_obter_estab_bem_periodo (nr_seq_bem_p bigint, dt_parametro_p timestamp) FROM PUBLIC;
