-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_glosa_reap ( nr_seq_propaci_p bigint, nr_seq_matpaci_p bigint) RETURNS bigint AS $body$
DECLARE


vl_glosa_w	double precision	:= 0;


BEGIN

if (coalesce(nr_seq_propaci_p,0) <> 0) then
	select	sum(vl_glosa)
	into STRICT	vl_glosa_w
	from (
		SELECT	CASE WHEN coalesce(a.ie_acao_glosa,d.ie_acao_glosa)='R' THEN 0  ELSE coalesce(a.vl_glosa,0) END  vl_glosa
		FROM procedimento_paciente c, convenio_retorno_glosa a
LEFT OUTER JOIN motivo_glosa d ON (a.cd_motivo_glosa = d.cd_motivo_glosa)
WHERE c.nr_sequencia		= a.nr_seq_propaci  and c.nr_sequencia		= nr_seq_propaci_p ) alias5;
end if;

if (coalesce(nr_seq_matpaci_p,0) <> 0) then
	select	sum(vl_glosa)
	into STRICT	vl_glosa_w
	from (
		SELECT	CASE WHEN coalesce(a.ie_acao_glosa,d.ie_acao_glosa)='R' THEN 0  ELSE coalesce(a.vl_glosa,0) END  vl_glosa
		FROM material_atend_paciente c, convenio_retorno_glosa a
LEFT OUTER JOIN motivo_glosa d ON (a.cd_motivo_glosa = d.cd_motivo_glosa)
WHERE c.nr_sequencia		= a.nr_seq_matpaci  and c.nr_sequencia		= nr_seq_matpaci_p ) alias5;
end if;

return vl_glosa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_glosa_reap ( nr_seq_propaci_p bigint, nr_seq_matpaci_p bigint) FROM PUBLIC;

