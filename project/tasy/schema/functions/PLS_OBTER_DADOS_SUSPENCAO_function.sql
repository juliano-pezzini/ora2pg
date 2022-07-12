-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_suspencao ( nr_seq_segurado_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_suspensao_w		bigint;
nr_seq_congenere_w		bigint;
nr_seq_contrato_w		bigint;
qt_suspensoes_w			bigint;
qt_retorno_suspensao_w		bigint;
ie_origem_w			varchar(10);
dt_prev_fim_susp_w		timestamp;
dt_fim_suspensao_w		timestamp;

/*ie_opcao_p
S = situação do segurado com a suspensão
O = origem da suspenção
*/
BEGIN

select	a.nr_seq_suspensao,
	a.nr_seq_congenere,
	a.nr_seq_contrato
into STRICT	nr_seq_suspensao_w,
	nr_seq_congenere_w,
	nr_seq_contrato_w
from	pls_segurado	a
where	a.nr_sequencia	= nr_seq_segurado_p;


select	count(1)
into STRICT	qt_retorno_suspensao_w
from	pls_segurado_suspensao
where	nr_seq_segurado	= nr_seq_segurado_p
and	coalesce(DT_FIM_SUSPENSAO::text, '') = '';

if (qt_retorno_suspensao_w > 0) then
	ie_origem_w	:= 'B';
else

	if (nr_seq_suspensao_w IS NOT NULL AND nr_seq_suspensao_w::text <> '') then
		ie_origem_w	:= 'C';
	else
		select	count(1)
		into STRICT	qt_retorno_suspensao_w
		from	pls_segurado_suspensao
		where	nr_seq_congenere	= nr_seq_congenere_w
		and	coalesce(DT_FIM_SUSPENSAO::text, '') = '';

		if (qt_retorno_suspensao_w > 0) then
			ie_origem_w	:= 'CO';
		else
			return '';
		end if;
	end if;
end if;

if (ie_opcao_p = 'O') then
	if (ie_origem_w IS NOT NULL AND ie_origem_w::text <> '') then
		if (ie_origem_w	= 'B') then
			return 'B';
		elsif (ie_origem_w	= 'C') then
			return 'C';
		elsif (ie_origem_w	= 'CO') then
			return 'CO';
		end if;
	else
		return '';
	end if;
elsif (ie_opcao_p = 'S') then
	if (ie_origem_w IS NOT NULL AND ie_origem_w::text <> '') then
		if (ie_origem_w = 'B') then
			select	max(DT_PREV_FIM_SUSP)
			into STRICT	dt_prev_fim_susp_w
			from	PLS_SEGURADO_SUSPENSAO
			where	nr_seq_segurado	= nr_seq_segurado_p
			and	coalesce(DT_FIM_SUSPENSAO::text, '') = '';

			if (dt_prev_fim_susp_w > clock_timestamp() or coalesce(dt_prev_fim_susp_w::text, '') = '') then
				return 'Suspenso';
			else
				return 'Ativo';
			end if;
		elsif (ie_origem_w = 'C') then
			select	max(DT_PREV_FIM_SUSP)
			into STRICT	dt_prev_fim_susp_w
			from	pls_segurado_suspensao
			where	nr_sequencia	= nr_seq_suspensao_w;

			if (dt_prev_fim_susp_w > clock_timestamp() or coalesce(dt_prev_fim_susp_w::text, '') = '') then
				return 'Suspenso';
			else
				return 'Ativo';
			end if;

		elsif (ie_origem_w = 'CO') then
			select	max(DT_PREV_FIM_SUSP)
			into STRICT	dt_prev_fim_susp_w
			from	pls_segurado_suspensao
			where	nr_seq_congenere	= nr_seq_congenere_w
			and	coalesce(DT_FIM_SUSPENSAO::text, '') = '';

			if (dt_prev_fim_susp_w > clock_timestamp() or coalesce(dt_prev_fim_susp_w::text, '') = '') then
				return 'Suspenso';
			else
				return 'Ativo';
			end if;
		else
			return '';
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_suspencao ( nr_seq_segurado_p bigint, ie_opcao_p text) FROM PUBLIC;

