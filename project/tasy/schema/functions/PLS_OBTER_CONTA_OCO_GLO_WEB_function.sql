-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_conta_oco_glo_web ( nr_seq_protocolo_p bigint, nr_seq_ocorrencia_p bigint, nr_seq_motivo_glosa_p bigint, ie_tipo_p text) RETURNS bigint AS $body$
DECLARE

/*
O - Verifica total de contas com ocorrências no modelo atual de importação.
ON - Verifica o total de contas com ocorrências no novo modelo de importação.
*/
qt_registros_w	bigint;


BEGIN

if (ie_tipo_p = 'O') then
	select 	count(distinct b.nr_sequencia)
	into STRICT	qt_registros_w
	from 	pls_ocorrencia_benef a,
		pls_conta b
	where	a.nr_seq_conta 		= b.nr_sequencia
	and	b.nr_seq_protocolo	= nr_seq_protocolo_p
	and 	a.nr_seq_ocorrencia	= nr_seq_ocorrencia_p;

elsif (ie_tipo_p = 'ON') then
	select 	count(distinct b.nr_sequencia)
	into STRICT	qt_registros_w
	from 	pls_ocorrencia_imp a,
		pls_conta_imp b
	where	a.nr_seq_conta 		= b.nr_sequencia
	and	b.nr_seq_protocolo	= nr_seq_protocolo_p
	and 	a.nr_seq_ocorrencia	= nr_seq_ocorrencia_p;

else
	select 	count(distinct b.nr_sequencia)
	into STRICT	qt_registros_w
	from 	pls_conta_glosa a,
		pls_conta b
	where	a.nr_seq_conta 		= b.nr_sequencia
	and	b.nr_seq_protocolo	= nr_seq_protocolo_p
	and 	a.nr_seq_motivo_glosa	= nr_seq_motivo_glosa_p;
end if;


return qt_registros_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_conta_oco_glo_web ( nr_seq_protocolo_p bigint, nr_seq_ocorrencia_p bigint, nr_seq_motivo_glosa_p bigint, ie_tipo_p text) FROM PUBLIC;
