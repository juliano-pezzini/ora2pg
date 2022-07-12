-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_eme_quantidade_calculo ( ie_base_calculo_p text, nr_seq_contrato_p bigint, dt_competencia_p timestamp, nr_seq_faturamento_p eme_faturamento.nr_sequencia%type, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


ds_retorno_w		integer;
qt_quantidade_w		integer;
ie_dt_competencia_w	varchar(1);
nr_mes_anterior_w	smallint := 0;


BEGIN

ie_dt_competencia_w := obter_param_usuario(929, 25, obter_perfil_ativo, Wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_dt_competencia_w);

if (ie_dt_competencia_w = 'N') then
	nr_mes_anterior_w := -1;
end if;

/*Busca a quantidade de usuarios*/

if (ie_base_calculo_p = 'U') then
	select	count(*)
	into STRICT	qt_quantidade_w
	from 	eme_pf_contrato
	where	nr_seq_contrato = nr_seq_contrato_p
	and	coalesce(dt_cancelamento::text, '') = '';
end if;

/*Busca a quantidade de atendimentos realizados no mes anterior*/

if (ie_base_calculo_p = 'A') then
	select	count(*)
	into STRICT	qt_quantidade_w
	from	eme_chamado
	where	nr_seq_contrato = nr_seq_contrato_p
	and	to_char(dt_chamado,'mm/yyyy') <= to_char(pkg_date_utils.add_month(trunc(dt_competencia_p),nr_mes_anterior_w,0),'mm/yyyy')
	and	((ie_faturamento = 'S' and coalesce(ie_opcao_p,'X') <> 'F') or (coalesce(ie_opcao_p,'X') = 'F' and nr_seq_faturamento = nr_seq_faturamento_p));
end if;

/*Busca a quantidade de horas atendidas no mes anterior*/

if (ie_base_calculo_p = 'H') then
	select	coalesce(sum((dt_fim_atend - dt_inicio_atend) * 24),0)
	into STRICT	qt_quantidade_w
	from	eme_chamado
	where	nr_seq_contrato = nr_seq_contrato_p
	and	to_char(dt_chamado,'mm/yyyy') <= to_char(pkg_date_utils.add_month(trunc(dt_competencia_p),nr_mes_anterior_w,0),'mm/yyyy')
	and	((ie_faturamento = 'S' and coalesce(ie_opcao_p,'X') <> 'F') or (coalesce(ie_opcao_p,'X') = 'F' and nr_seq_faturamento = nr_seq_faturamento_p));
end if;

/*Busca a quantidade de atendimentos realizados no mes de competência*/

if (ie_base_calculo_p = 'V') then

	select	count(1)
	into STRICT	qt_quantidade_w
	from	eme_chamado
	where	nr_seq_contrato = nr_seq_contrato_p
	and	to_char(dt_chamado,'mm/yyyy') <= to_char(pkg_date_utils.add_month(trunc(dt_competencia_p),nr_mes_anterior_w,0),'mm/yyyy')
	and	((ie_faturamento = 'S' and coalesce(ie_opcao_p,'X') <> 'F') or (coalesce(ie_opcao_p,'X') = 'F' and nr_seq_faturamento = nr_seq_faturamento_p));

end if;

if (ie_base_calculo_p = 'F') or
	(ie_base_calculo_p = 'A' AND qt_quantidade_w = 0) or
	(ie_base_calculo_p = 'V' AND qt_quantidade_w = 0) then
	qt_quantidade_w	:= 1;
end if;

ds_retorno_w	:= qt_quantidade_w;

RETURN	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_eme_quantidade_calculo ( ie_base_calculo_p text, nr_seq_contrato_p bigint, dt_competencia_p timestamp, nr_seq_faturamento_p eme_faturamento.nr_sequencia%type, ie_opcao_p text) FROM PUBLIC;

