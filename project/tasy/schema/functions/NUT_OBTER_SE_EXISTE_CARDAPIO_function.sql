-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nut_obter_se_existe_cardapio ( nr_seq_cardapio_p bigint, dt_cardapio_destino_p timestamp, dt_ref_p timestamp, ie_semana_p bigint, ie_dia_semana_p bigint, nr_seq_serv_destino_p bigint, ie_tipo_copia_p text, nr_seq_local_p bigint, dt_fim_card_destino_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1) := 'N';
qt_cardapios_w		bigint;
nr_seq_card_dia_w	bigint;
dt_ini_origem_w		timestamp;
dt_fim_origem_w		timestamp;
dt_ini_destino_w	timestamp;
dt_fim_destino_w	timestamp;
ie_dia_semana_w		smallint;
ie_semana_w		smallint;
dt_ref_destino_w	varchar(10);
mes_destino_w		varchar(2);
ie_primeira_semana_w	varchar(1);
ano_destino_w		varchar(4);
dt_cardapio_destino_w	timestamp;
nr_seq_grupo_producao_w	bigint;
cd_dieta_w		bigint;
nr_seq_opcao_w		bigint;
nr_seq_local_w		bigint;
nr_seq_servico_w	bigint;
			
C02 CURSOR FOR
	SELECT  nr_sequencia
	from 	nut_cardapio_dia
	where 	ie_semana = ie_semana_p
	and	ie_dia_semana = ie_dia_semana_p
	and	dt_vigencia_inicial between dt_ini_origem_w and dt_fim_origem_w
	and	nr_seq_local = coalesce(nr_seq_local_p,nr_seq_local);
	

BEGIN
dt_cardapio_destino_w := dt_cardapio_destino_p;

while(dt_cardapio_destino_w <= dt_fim_card_destino_p) and (ds_retorno_w = 'N') loop
	begin
	--obter codigo do dia e da semana de destino da copia
	ie_dia_semana_w := obter_cod_dia_semana(dt_cardapio_destino_w);
	ie_semana_w 	:= obter_semana_cardapio(dt_cardapio_destino_w);
	--obter datas de inicio e fim de vigencia do dia selecionado para copia
	SELECT * FROM obter_dia_ini_fim_mes_vig(dt_ref_p, dt_ini_origem_w, dt_fim_origem_w) INTO STRICT dt_ini_origem_w, dt_fim_origem_w;

	select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT 	ie_primeira_semana_w
	  
	where 	to_char(dt_cardapio_destino_w,'dd') < 8
	and	  	ie_semana_w > 1;

	if (ie_primeira_semana_w = 'S') then
		if (to_char(dt_cardapio_destino_w,'mm') = '01') then
			mes_destino_w := '12';
			ano_destino_w := to_char(dt_cardapio_destino_w,'yyyy') - 1;
		else
			mes_destino_w := to_char(dt_cardapio_destino_w,'mm') - 1;
			ano_destino_w := to_char(dt_cardapio_destino_w,'yyyy');
		end if;
	else
		mes_destino_w := to_char(dt_cardapio_destino_w,'mm');
		ano_destino_w := to_char(dt_cardapio_destino_w,'yyyy');
	end if;

	dt_ref_destino_w := pkg_date_utils.get_date(ano_destino_w,mes_destino_w,1,0);

	if (ie_tipo_copia_p = 'O') and (nr_seq_cardapio_p IS NOT NULL AND nr_seq_cardapio_p::text <> '') then
		
		--obter datas de inicio e fim de vigencia para os novos registros que serao criados
		SELECT * FROM obter_dia_ini_fim_mes_vig(dt_ref_destino_w, dt_ini_destino_w, dt_fim_destino_w) INTO STRICT dt_ini_destino_w, dt_fim_destino_w;

		select	max(nr_seq_grupo_producao),
			max(cd_dieta),
			max(nr_seq_opcao),
			max(nr_seq_local),
			max(nr_seq_servico)
		into STRICT	nr_seq_grupo_producao_w,
			cd_dieta_w,
			nr_seq_opcao_w,
			nr_seq_local_w,
			nr_seq_servico_w
		from	nut_cardapio_dia
		where	nr_sequencia = nr_seq_cardapio_p;

		select	count(*)
		into STRICT	qt_cardapios_w
		from	nut_cardapio_dia
		where	ie_dia_semana	= ie_dia_semana_w
		and	ie_semana	= ie_semana_w
		and	dt_vigencia_inicial	= dt_ini_destino_w
		and	dt_vigencia_final	= dt_fim_destino_w
		and	nr_seq_servico		= coalesce(nr_seq_serv_destino_p,nr_seq_servico_w)
		and	coalesce(nr_seq_grupo_producao,0)	= coalesce(nr_seq_grupo_producao_w,0)
		and	coalesce(cd_dieta,0)		= coalesce(cd_dieta_w,0)
		and	coalesce(nr_seq_opcao,0)	= coalesce(nr_seq_opcao_w,0)
		and	coalesce(nr_seq_local,0)	= coalesce(nr_seq_local_w,0);
		
		if (qt_cardapios_w > 0) then
			ds_retorno_w := 'S';
		end if;
		
	elsif (ie_tipo_copia_p = 'D') then
		open c02;
		loop
		fetch C02 into	
			nr_seq_card_dia_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			
			SELECT * FROM obter_dia_ini_fim_mes_vig(dt_ref_destino_w, dt_ini_destino_w, dt_fim_destino_w) INTO STRICT dt_ini_destino_w, dt_fim_destino_w;

			select	max(nr_seq_grupo_producao),
				max(cd_dieta),
				max(nr_seq_opcao),
				max(nr_seq_local),
				max(nr_seq_servico)
			into STRICT	nr_seq_grupo_producao_w,
				cd_dieta_w,
				nr_seq_opcao_w,
				nr_seq_local_w,
				nr_seq_servico_w
			from	nut_cardapio_dia
			where	nr_sequencia = nr_seq_card_dia_w;

			select	count(*)
			into STRICT	qt_cardapios_w
			from	nut_cardapio_dia
			where	ie_dia_semana	= ie_dia_semana_w
			and	ie_semana	= ie_semana_w
			and	dt_vigencia_inicial	= dt_ini_destino_w
			and	dt_vigencia_final	= dt_fim_destino_w
			and	nr_seq_servico		= nr_seq_servico_w
			and	coalesce(nr_seq_grupo_producao,0)	= coalesce(nr_seq_grupo_producao_w,0)
			and	coalesce(cd_dieta,0)		= coalesce(cd_dieta_w,0)
			and	coalesce(nr_seq_opcao,0)	= coalesce(nr_seq_opcao_w,0)
			and	coalesce(nr_seq_local,0)	= coalesce(nr_seq_local_w,0);
			
			if (qt_cardapios_w > 0) then
				ds_retorno_w := 'S';
			end if;
			
			end;
		end loop;
		close C02;

	end if;
	
	dt_cardapio_destino_w := dt_cardapio_destino_w + 1;
	
	end;
end loop;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nut_obter_se_existe_cardapio ( nr_seq_cardapio_p bigint, dt_cardapio_destino_p timestamp, dt_ref_p timestamp, ie_semana_p bigint, ie_dia_semana_p bigint, nr_seq_serv_destino_p bigint, ie_tipo_copia_p text, nr_seq_local_p bigint, dt_fim_card_destino_p timestamp) FROM PUBLIC;

