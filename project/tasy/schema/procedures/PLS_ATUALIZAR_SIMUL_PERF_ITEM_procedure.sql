-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_simul_perf_item ( nr_seq_simul_param_item_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_fator_alteracao_w	bigint;
tx_indice_w			double precision;


BEGIN

select	max(nr_seq_fator_alteracao)
into STRICT	nr_seq_fator_alteracao_w
from	pls_simul_param_item
where	nr_sequencia	= nr_seq_simul_param_item_p;

if (nr_seq_fator_alteracao_w IS NOT NULL AND nr_seq_fator_alteracao_w::text <> '') then
	begin
	select	tx_indice
	into STRICT	tx_indice_w
	from	pls_simul_fator_alt_cond
	where	nr_seq_fator	= nr_seq_fator_alteracao_w
	and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and fim_dia(dt_fim_vigencia);
	exception
	when others then
		tx_indice_w	:= 1;
	end;
else
	tx_indice_w	:= 1;
end if;

update	pls_simul_param_item
set	tx_indice	= tx_indice_w
where	nr_sequencia	= nr_seq_simul_param_item_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_simul_perf_item ( nr_seq_simul_param_item_p bigint, nm_usuario_p text) FROM PUBLIC;
