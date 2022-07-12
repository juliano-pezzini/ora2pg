-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_moeda_pck.set_dados_cambio ( ie_opcao_p text, cd_estabelecimento_p bigint, cd_moeda_cotacao_p bigint, dt_referencia_p timestamp) AS $body$
DECLARE


	vl_cotacao_ww	cotacao_moeda.vl_cotacao%type;
	dt_cotacao_ww	cotacao_moeda.dt_cotacao%type;

	ie_achou_w	varchar(1) := 'N';
	i		integer;

	c01 CURSOR FOR
	SELECT	vl_cotacao,
		dt_cotacao
	from	cotacao_moeda
	where	dt_cotacao	< dt_referencia_p
	--and	cd_estabelecimento = cd_estabelecimento_p
	and	cd_moeda	= cd_moeda_cotacao_p
	order by dt_cotacao desc;

	
BEGIN
	ie_achou_w	:=	'N';
	i		:=	current_setting('wheb_moeda_pck.cotacao_moeda_w')::vetor.count;

	if (cd_moeda_cotacao_p = wheb_moeda_pck.get_moeda_padrao(cd_estabelecimento_p)) then
		begin
		ie_achou_w		:=	'S';
		dt_cotacao_ww		:=	clock_timestamp();
		vl_cotacao_ww		:=	1;
		end;
	end if;

	while	(ie_achou_w = 'N' AND i > 0) loop
		begin
		i	:=	i - 1;

		if (current_setting('wheb_moeda_pck.cotacao_moeda_w')::vetor[i].cd_estabelecimento = cd_estabelecimento_p) and (current_setting('wheb_moeda_pck.cotacao_moeda_w')::vetor[i].cd_moeda_cotacao = cd_moeda_cotacao_p) and (current_setting('wheb_moeda_pck.cotacao_moeda_w')::vetor[i].dt_referencia = dt_referencia_p) then
			begin
			dt_cotacao_ww		:=	current_setting('wheb_moeda_pck.cotacao_moeda_w')::vetor[i].dt_cotacao;
			vl_cotacao_ww		:=	current_setting('wheb_moeda_pck.cotacao_moeda_w')::vetor[i].vl_cotacao;
			ie_achou_w		:=	'S';
			end;
		end if;
		end;
	end loop;

	if (ie_achou_w = 'N') then
		begin
		open c01;
		loop
		fetch c01 into
			vl_cotacao_ww,
			dt_cotacao_ww;
		exit when ((c01%notfound) or (coalesce(vl_cotacao_ww,0) <> 0));
			begin
			ie_achou_w	:=	'S';
			end;
		end loop;
		close c01;

		if (ie_achou_w = 'S') then
			begin
			i	:=	current_setting('wheb_moeda_pck.cotacao_moeda_w')::vetor.count;
			current_setting('wheb_moeda_pck.cotacao_moeda_w')::vetor[i].cd_estabelecimento	:= cd_estabelecimento_p;
			current_setting('wheb_moeda_pck.cotacao_moeda_w')::vetor[i].cd_moeda_cotacao	:= cd_moeda_cotacao_p;
			current_setting('wheb_moeda_pck.cotacao_moeda_w')::vetor[i].dt_referencia 		:= dt_referencia_p;
			current_setting('wheb_moeda_pck.cotacao_moeda_w')::vetor[i].dt_cotacao		:= dt_cotacao_ww;
			current_setting('wheb_moeda_pck.cotacao_moeda_w')::vetor[i].vl_cotacao		:= vl_cotacao_ww;
			end;
		end if;
		end;
	end if;

	PERFORM set_config('wheb_moeda_pck.cd_estabelecimento_w', cd_estabelecimento_p, false);
	PERFORM set_config('wheb_moeda_pck.dt_referencia_w', dt_referencia_p, false);

	if (ie_opcao_p = 'D') then
		PERFORM set_config('wheb_moeda_pck.cd_moeda_destino_w', cd_moeda_cotacao_p, false);
		PERFORM set_config('wheb_moeda_pck.vl_cotacao_destino_w', vl_cotacao_ww, false);
	else
		PERFORM set_config('wheb_moeda_pck.cd_moeda_origem_w', cd_moeda_cotacao_p, false);
		PERFORM set_config('wheb_moeda_pck.vl_cotacao_origem_w', vl_cotacao_ww, false);
	end if;
	null;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE wheb_moeda_pck.set_dados_cambio ( ie_opcao_p text, cd_estabelecimento_p bigint, cd_moeda_cotacao_p bigint, dt_referencia_p timestamp) FROM PUBLIC;
