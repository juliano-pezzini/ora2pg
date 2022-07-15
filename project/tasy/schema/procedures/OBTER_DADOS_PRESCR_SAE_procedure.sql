-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_prescr_sae ( nr_seq_sae_p bigint, nr_prescricao_p INOUT bigint, nr_seq_novo_p INOUT bigint, nr_agrupamento_p INOUT bigint) AS $body$
DECLARE

 
nr_prescricao_w	bigint;
					

BEGIN 
 
if (nr_seq_sae_p IS NOT NULL AND nr_seq_sae_p::text <> '') then 
	select	max(nr_prescricao) 
	into STRICT	nr_prescricao_w 
	from	pe_prescricao 
	where	nr_sequencia	= nr_seq_sae_p;
	 
	if (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '') then 
	 
		nr_prescricao_p	:= nr_prescricao_w;
		 
		select	coalesce(max(a.nr_sequencia),0)+1       nr_seq_novo, 
			obter_proximo_agrup_medic(nr_prescricao_w) nr_agrupamento 
		into STRICT	nr_seq_novo_p, 
			nr_agrupamento_p 
		from 	prescr_material a, 
			prescr_medica  b 
		where 	b.nr_prescricao = a.nr_prescricao 
		 and 	a.nr_prescricao = nr_prescricao_w;
		 
	end if;
 
end if;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_prescr_sae ( nr_seq_sae_p bigint, nr_prescricao_p INOUT bigint, nr_seq_novo_p INOUT bigint, nr_agrupamento_p INOUT bigint) FROM PUBLIC;

