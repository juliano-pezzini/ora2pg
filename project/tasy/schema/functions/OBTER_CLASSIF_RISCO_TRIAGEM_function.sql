-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_classif_risco_triagem (nr_prescricao_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_prioridade_w	bigint;
nr_sequencia_w		bigint:= null;
ie_classif_triagem_w	varchar(1);


BEGIN
select	coalesce(max(ie_forma_classif_triagem), 'A')
into STRICT	ie_classif_triagem_w
from	parametro_medico
where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

if (ie_classif_triagem_w = 'A') then
	select	max(c.nr_seq_prioridade)
	into STRICT	nr_seq_prioridade_w
	from	pe_diagnostico a,
		pe_prescr_diag b,
		triagem_classif_risco c
	where	a.nr_sequencia   = b.nr_seq_diag
	and	a.nr_seq_classif = c.nr_sequencia
	and	b.nr_seq_prescr  = nr_prescricao_p;
else
	select	min(c.nr_seq_prioridade)
	into STRICT	nr_seq_prioridade_w
	from	pe_diagnostico a,
		pe_prescr_diag b,
		triagem_classif_risco c
	where	a.nr_sequencia   = b.nr_seq_diag
	and	a.nr_seq_classif = c.nr_sequencia
	and	b.nr_seq_prescr  = nr_prescricao_p;
end if;

if (nr_seq_prioridade_w IS NOT NULL AND nr_seq_prioridade_w::text <> '') then
	select	max(nr_sequencia)
	into STRICT	nr_sequencia_w
	from	triagem_classif_risco
	where	nr_seq_prioridade = nr_seq_prioridade_w
	and     coalesce(ie_situacao,'A') = 'A';
end if;
return nr_sequencia_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_classif_risco_triagem (nr_prescricao_p bigint) FROM PUBLIC;

