-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valores_cobranca (nr_seq_cobranca_p bigint, ie_valor_p text) RETURNS bigint AS $body$
DECLARE


vl_retorno_w		double precision	:= null;
vl_original_w		double precision;
vl_acobrar_w		double precision;
vl_total_acobrar_w	double precision;
vl_terceiro_w		double precision;
ie_juros_multa_cobr_w	varchar(1);
cd_estabelecimento_w	smallint;
vl_juros_w		double precision;
vl_multa_w		double precision;
nr_titulo_w		bigint;
ie_juros_cheque_cob_w	varchar(1);
nr_seq_cheque_w		bigint;
dt_inclusao_w		timestamp;
ie_acao_valor_w		varchar(1);

/*
VTC	Valor total a cobrar
VC	Valor a cobrar
VT	Valor total cheque
*/
BEGIN

if (nr_seq_cobranca_p IS NOT NULL AND nr_seq_cobranca_p::text <> '') then
	select	vl_original,
		vl_acobrar,
		obter_valor_terc_cobranca(nr_sequencia),
		nr_titulo,
		cd_estabelecimento,
		nr_seq_cheque,
		dt_inclusao
	into STRICT	vl_original_w,
		vl_acobrar_w,
		vl_terceiro_w,
		nr_titulo_w,
		cd_estabelecimento_w,
		nr_seq_cheque_w,
		dt_inclusao_w
	from	cobranca
	where	nr_sequencia	= nr_seq_cobranca_p;

	select	coalesce(max(ie_juros_multa_cobr),'N'),
		max(ie_juros_cheque_cob)
	into STRICT	ie_juros_multa_cobr_w,
		ie_juros_cheque_cob_w
	from	parametro_contas_receber
	where	cd_estabelecimento	= cd_estabelecimento_w;

	select	coalesce(max(ie_acao_valor),'D')
	into STRICT	ie_acao_valor_w
	from	cobranca_valor_terc
	where	nr_seq_cobranca	= nr_seq_cobranca_p;

	if (ie_valor_p	= 'VTC')  then

		vl_total_acobrar_w	:= vl_acobrar_w;

		if (ie_acao_valor_w = 'D') then
			vl_total_acobrar_w	:= vl_total_acobrar_w - vl_terceiro_w;
		elsif (ie_acao_valor_w = 'A') then
			vl_total_acobrar_w	:= vl_total_acobrar_w + vl_terceiro_w;
		end if;

		if (ie_juros_multa_cobr_w = 'S') then
			vl_juros_w	:=	obter_juros_multa_titulo(nr_titulo_w,clock_timestamp(),'R','J');
			vl_multa_w	:= 	obter_juros_multa_titulo(nr_titulo_w,clock_timestamp(),'R','M');

			vl_total_acobrar_w	:= vl_total_acobrar_w + vl_juros_w + vl_multa_w;
		end if;

		if (ie_juros_cheque_cob_w = 'S') then
			SELECT * FROM calcular_juro_multa_cheque(nr_seq_cheque_w, clock_timestamp(), dt_inclusao_w, vl_juros_w, vl_multa_w) INTO STRICT vl_juros_w, vl_multa_w;

			vl_total_acobrar_w	:= coalesce(vl_total_acobrar_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0);
		end if;

		vl_retorno_w	:= vl_total_acobrar_w;

	elsif (ie_valor_p	= 'VC') then

		vl_total_acobrar_w	:= vl_acobrar_w;

		if (ie_juros_cheque_cob_w = 'S') then
			SELECT * FROM calcular_juro_multa_cheque(nr_seq_cheque_w, clock_timestamp(), dt_inclusao_w, vl_juros_w, vl_multa_w) INTO STRICT vl_juros_w, vl_multa_w;
		end if;

		vl_juros_w	:=	coalesce(vl_juros_w,0) +  coalesce(obter_juros_multa_titulo(nr_titulo_w,clock_timestamp(),'R','J'),0);
		vl_multa_w	:= 	coalesce(vl_multa_w,0) + coalesce(obter_juros_multa_titulo(nr_titulo_w,clock_timestamp(),'R','M'),0);

		vl_total_acobrar_w	:= coalesce(vl_total_acobrar_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0);

		vl_retorno_w	:= vl_total_acobrar_w;
	elsif (ie_valor_p	= 'VT') then
		vl_total_acobrar_w	:= vl_acobrar_w;

		if (ie_acao_valor_w = 'D') then
			vl_total_acobrar_w	:= vl_total_acobrar_w - vl_terceiro_w;
		elsif (ie_acao_valor_w = 'A') then
			vl_total_acobrar_w	:= vl_total_acobrar_w + vl_terceiro_w;
		end if;

		if (ie_juros_multa_cobr_w = 'S') then
			vl_juros_w	:=	obter_juros_multa_titulo(nr_titulo_w,clock_timestamp(),'R','J');
			vl_multa_w	:= 	obter_juros_multa_titulo(nr_titulo_w,clock_timestamp(),'R','M');

			vl_total_acobrar_w	:= vl_total_acobrar_w + vl_juros_w + vl_multa_w;
		end if;

		if (ie_juros_cheque_cob_w = 'S') then
			vl_juros_w	:= obter_juro_multa_cheque(nr_seq_cheque_w,clock_timestamp(), 'R', 'J');
			vl_multa_w	:= obter_juro_multa_cheque(nr_seq_cheque_w,clock_timestamp(), 'R', 'M');
			--calcular_juro_multa_cheque(nr_seq_cheque_w,sysdate,dt_inclusao_w,vl_juros_w,vl_multa_w);
			vl_total_acobrar_w	:= coalesce(vl_total_acobrar_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0);
		end if;

		vl_retorno_w	:= vl_total_acobrar_w;

	end if;
end if;


return vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valores_cobranca (nr_seq_cobranca_p bigint, ie_valor_p text) FROM PUBLIC;
