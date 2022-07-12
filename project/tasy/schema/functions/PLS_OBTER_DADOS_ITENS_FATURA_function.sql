-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_itens_fatura ( nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);


BEGIN
if (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then	-- PROCEDIMENTOS
	if (upper(ie_opcao_p) = upper('vsc')) then -- Vl proced (honorario)
		select	coalesce(max(vl_procedimento),0)
		into STRICT	ds_retorno_w
		from	ptu_nota_servico
		where	nr_seq_conta_proc = nr_seq_conta_proc_p;

	end if;

	if (upper(ie_opcao_p) = upper('vcc')) then -- Vl custo operacional
		select	coalesce(max(vl_custo_operacional),0)
		into STRICT	ds_retorno_w
		from	ptu_nota_servico
		where	nr_seq_conta_proc = nr_seq_conta_proc_p;

	end if;

	if (upper(ie_opcao_p) = upper('vcf')) then -- Vl filme
		select	coalesce(max(vl_filme),0)
		into STRICT	ds_retorno_w
		from	ptu_nota_servico
		where	nr_seq_conta_proc = nr_seq_conta_proc_p;

	end if;

	if (upper(ie_opcao_p) = upper('vcas')) then -- Vl adic serviço
		select	coalesce(max(vl_adic_procedimento),0)
		into STRICT	ds_retorno_w
		from	ptu_nota_servico
		where	nr_seq_conta_proc = nr_seq_conta_proc_p;

	end if;

	if (upper(ie_opcao_p) = upper('vcac')) then -- Vl adic CO
		select	coalesce(max(vl_adic_co),0)
		into STRICT	ds_retorno_w
		from	ptu_nota_servico
		where	nr_seq_conta_proc = nr_seq_conta_proc_p;

	end if;

	if (upper(ie_opcao_p) = upper('vcaf')) then -- Vl adic filme
		select	coalesce(max(vl_adic_filme),0)
		into STRICT	ds_retorno_w
		from	ptu_nota_servico
		where	nr_seq_conta_proc = nr_seq_conta_proc_p;

	end if;

elsif (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '') then	-- MATERIAIS
	if (upper(ie_opcao_p) = upper('vsc')) then -- Vl proced (honorario)
		select	coalesce(max(vl_procedimento),0)
		into STRICT	ds_retorno_w
		from	ptu_nota_servico
		where	nr_seq_conta_mat = nr_seq_conta_mat_p;

	end if;

	if (upper(ie_opcao_p) = upper('vcc')) then -- Vl custo operacional
		select	coalesce(max(vl_custo_operacional),0)
		into STRICT	ds_retorno_w
		from	ptu_nota_servico
		where	nr_seq_conta_mat = nr_seq_conta_mat_p;

	end if;

	if (upper(ie_opcao_p) = upper('vcf')) then -- Vl filme
		select	coalesce(max(vl_filme),0)
		into STRICT	ds_retorno_w
		from	ptu_nota_servico
		where	nr_seq_conta_mat = nr_seq_conta_mat_p;

	end if;

	if (upper(ie_opcao_p) = upper('vcas')) then -- Vl adic serviço
		select	coalesce(max(vl_adic_procedimento),0)
		into STRICT	ds_retorno_w
		from	ptu_nota_servico
		where	nr_seq_conta_mat = nr_seq_conta_mat_p;

	end if;

	if (upper(ie_opcao_p) = upper('vcac')) then -- Vl adic CO
		select	coalesce(max(vl_adic_co),0)
		into STRICT	ds_retorno_w
		from	ptu_nota_servico
		where	nr_seq_conta_mat = nr_seq_conta_mat_p;

	end if;

	if (upper(ie_opcao_p) = upper('vcaf')) then -- Vl adic filme
		select	coalesce(max(vl_adic_filme),0)
		into STRICT	ds_retorno_w
		from	ptu_nota_servico
		where	nr_seq_conta_mat = nr_seq_conta_mat_p;

	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_itens_fatura ( nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, ie_opcao_p text) FROM PUBLIC;

