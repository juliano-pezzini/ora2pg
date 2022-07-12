-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_procmat_glosa (nr_seq_proc_princ_p bigint, ie_opcao_p text, nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


qt_procedimento_w	double precision 	:= 0;


BEGIN

if (ie_opcao_p = 'P') then
	select	qt_procedimento
	into STRICT 	qt_procedimento_w
	from	procedimento_paciente
	where	nr_sequencia = nr_seq_proc_princ_p
	and 	cd_situacao_glosa > 0
	and	nr_atendimento = nr_atendimento_p;
end if;

if (ie_opcao_p = 'M') then
	select	qt_material
	into STRICT 	qt_procedimento_w
	from	material_atend_paciente
	where	nr_sequencia = nr_seq_proc_princ_p
	and 	cd_situacao_glosa > 0
	and	nr_atendimento = nr_atendimento_p;
end if;

Return qt_procedimento_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_procmat_glosa (nr_seq_proc_princ_p bigint, ie_opcao_p text, nr_atendimento_p bigint) FROM PUBLIC;
