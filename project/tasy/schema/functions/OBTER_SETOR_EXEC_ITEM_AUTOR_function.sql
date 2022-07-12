-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_setor_exec_item_autor ( nr_seq_item_autor_p bigint, nr_prescricao_p bigint, nr_seq_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE


vl_retorno_w	setor_atendimento.ds_descricao%type;


BEGIN

select	max(s.ds_descricao)
into STRICT	vl_retorno_w
from	material_atend_paciente a,
	setor_atendimento s
where	1=1
and	s.cd_setor_atendimento = a.cd_setor_atendimento
and	((a.nr_seq_mat_autor 	= nr_seq_item_autor_p) or
	(a.nr_sequencia_prescricao 	= nr_seq_prescricao_p AND a.nr_prescricao		= nr_prescricao_p));

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_setor_exec_item_autor ( nr_seq_item_autor_p bigint, nr_prescricao_p bigint, nr_seq_prescricao_p bigint) FROM PUBLIC;

