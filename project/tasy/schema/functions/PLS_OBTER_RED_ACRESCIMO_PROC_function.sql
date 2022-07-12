-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_red_acrescimo_proc ( nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

 
nr_seq_regra_w			pls_conta_proc.nr_seq_regra%type;
tx_item_w			pls_conta_proc.tx_item%type;
ie_via_acesso_w			pls_conta_proc.ie_via_acesso%type;
tx_proc_horario_w		pls_proc_criterio_horario.tx_procedimento%type;
tx_ajuste_geral_w		pls_regra_preco_proc.tx_ajuste_geral%type;
tx_ajuste_medico_w		pls_regra_preco_proc.tx_ajuste_ch_honor%type;
nr_seq_regra_horario_w		pls_conta_proc.nr_seq_regra_horario%type;
ds_retorno_w			varchar(255);
ie_conta_pos_w			smallint;
tx_medico_horario_w		pls_proc_criterio_horario.tx_medico%type;


BEGIN 
select	max(tx_item), 
	max(ie_via_acesso) 
into STRICT	tx_item_w, 
	ie_via_acesso_w 
from	pls_conta_proc 
where	nr_sequencia = nr_seq_conta_proc_p;
 
select	count(1) 
into STRICT	ie_conta_pos_w 
from	pls_conta_pos_estabelecido 
where	nr_seq_conta_proc = nr_seq_conta_proc_p 
and	ie_situacao = 'A';
 
if (coalesce(ie_conta_pos_w,0) = 0) then 
	select	max(nr_seq_regra), 
		max(nr_seq_regra_horario) 
	into STRICT	nr_seq_regra_w, 
		nr_seq_regra_horario_w 
	from	pls_conta_proc 
	where	nr_sequencia	= nr_seq_conta_proc_p;
 
	select	max(tx_ajuste_geral), 
		max(tx_ajuste_ch_honor) 
	into STRICT	tx_ajuste_geral_w, 
		tx_ajuste_medico_w 
	from	pls_regra_preco_proc 
	where	nr_sequencia	= nr_seq_regra_w;
 
	select	max(a.tx_procedimento) 
	into STRICT	tx_proc_horario_w 
	from	pls_proc_criterio_horario	a 
	where	a.nr_sequencia	= nr_seq_regra_horario_w;
else 
	select	max(nr_seq_regra_pos_estab), 
		max(nr_seq_regra_horario) 
	into STRICT	nr_seq_regra_w, 
		nr_seq_regra_horario_w 
	from	pls_conta_pos_estabelecido 
	where	nr_seq_conta_proc	= nr_seq_conta_proc_p 
	and	ie_situacao 		= 'A';
 
	if (coalesce(nr_seq_regra_w,0) = 0) then 
		select	max(nr_seq_pos_estab_interc) 
		into STRICT	nr_seq_regra_w 
		from	pls_conta_pos_estabelecido 
		where	nr_seq_conta_proc	= nr_seq_conta_proc_p 
		and	ie_situacao 		= 'A';
	end if;
	 
	select	max(tx_ajuste_geral), 
		max(tx_ajuste_ch_honor) 
	into STRICT	tx_ajuste_geral_w, 
		tx_ajuste_medico_w 
	from	pls_regra_preco_proc 
	where	nr_sequencia	= nr_seq_regra_w;
 
	select	max(a.tx_procedimento), 
		max(tx_medico) 
	into STRICT	tx_proc_horario_w, 
		tx_medico_horario_w 
	from	pls_proc_criterio_horario	a 
	where	a.nr_sequencia	= nr_seq_regra_horario_w;
end if;
 
if (coalesce(tx_item_w,0) = 0) and (coalesce(tx_ajuste_geral_w,0) = 0) and (coalesce(tx_proc_horario_w,0) = 0) and (coalesce(tx_ajuste_medico_w,0) = 0) and (coalesce(tx_medico_horario_w,0) = 0) then 
	ds_retorno_w	:= 0;
else 
	if (coalesce(tx_item_w,0) = 0) or (coalesce(ie_via_acesso_w,'X') <> 'U') then --OS 993782 Caso a via de acesso seja diferente de "Única ou principal" desconsidera a taxa do itam - aedemuth 
		tx_item_w		:= 1;
	else 
		tx_item_w := dividir_sem_round((tx_item_w)::numeric,100);
	end if;
	 
	if (coalesce(tx_ajuste_geral_w,0) = 0) then 
		tx_ajuste_geral_w	:= 1;
	end if;
	 
	if (coalesce(tx_proc_horario_w,0) = 0) then 
		tx_proc_horario_w	:= 1;
	end if;
	 
	if (coalesce(tx_ajuste_medico_w,0) = 0) then 
		tx_ajuste_medico_w	:= 1;
	end if;
	 
	if (coalesce(tx_medico_horario_w,0) = 0) then 
		tx_medico_horario_w	:= 1;
	end if;
	 
	ds_retorno_w	:= ((((tx_item_w * tx_ajuste_geral_w) * tx_ajuste_medico_w) * tx_proc_horario_w)*tx_medico_horario_w);
end if;
 
select	to_char(coalesce(ds_retorno_w,0), '999,999,999,990.99') 
into STRICT	ds_retorno_w
;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_red_acrescimo_proc ( nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type) FROM PUBLIC;

