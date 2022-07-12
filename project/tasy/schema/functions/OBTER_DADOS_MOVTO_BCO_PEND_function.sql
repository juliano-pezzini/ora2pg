-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_movto_bco_pend (nr_seq_movto_pend_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
DC - Data de conciliação
HC - Histórico conciliação
HT - Histórico da transação
*/
ds_historico_w			varchar(255);
nr_seq_movto_trans_fin_w	bigint;
nr_seq_concil_w			bigint;
ds_retorno_w			varchar(255);
dt_conciliacao_w		timestamp;


c01 CURSOR FOR
SELECT	a.dt_atualizacao,
	b.ds_historico
from	banco_extrato_lanc b,
	concil_banc_movto a
where	b.nr_seq_concil	= a.nr_sequencia
and	a.nr_sequencia	= nr_seq_concil_w;


BEGIN

ds_retorno_w	:= null;

if (nr_seq_movto_pend_p IS NOT NULL AND nr_seq_movto_pend_p::text <> '') then

	select	max(a.nr_seq_movto_trans_fin)
	into STRICT	nr_seq_movto_trans_fin_w
	from	movto_banco_pend a
	where	a.nr_sequencia	= nr_seq_movto_pend_p;

	if (nr_seq_movto_trans_fin_w IS NOT NULL AND nr_seq_movto_trans_fin_w::text <> '') then

		if (ie_opcao_p = 'DC') or (ie_opcao_p = 'HC') then

			select	max(a.nr_seq_concil)
			into STRICT	nr_seq_concil_w
			from	movto_trans_financ a
			where	a.nr_sequencia	= nr_seq_movto_trans_fin_w;

			if (nr_seq_concil_w IS NOT NULL AND nr_seq_concil_w::text <> '') then
				open c01;
				loop
				fetch c01 into
					dt_conciliacao_w,
					ds_historico_w;
				EXIT WHEN NOT FOUND; /* apply on c01 */
					null;
				end loop;
				close c01;
			end if;
		else

			select	max(a.ds_historico)
			into STRICT	ds_historico_w
			from	movto_trans_financ a
			where	a.nr_sequencia	= nr_seq_movto_trans_fin_w;
		end if;
	end if;

	if (ie_opcao_p = 'DC') then
		ds_retorno_w	:= to_char(dt_conciliacao_w,'dd/mm/yyyy');
	elsif (ie_opcao_p = 'HC') or (ie_opcao_p = 'HT') then
		ds_retorno_w	:= ds_historico_w;
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_movto_bco_pend (nr_seq_movto_pend_p bigint, ie_opcao_p text) FROM PUBLIC;
